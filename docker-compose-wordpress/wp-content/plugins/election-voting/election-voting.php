<?php
/*
Plugin Name: Election Voting System
Description: Handles voting system for election
Version: 1.0
*/

// Create database table when plugin is activated
function election_plugin_activate() {
    global $wpdb;
    $table_name = $wpdb->prefix . 'election_votes';
    
    $charset_collate = $wpdb->get_charset_collate();

    $sql = "CREATE TABLE IF NOT EXISTS $table_name (
        id mediumint(9) NOT NULL AUTO_INCREMENT,
        candidate_name varchar(50) NOT NULL,
        vote_time datetime DEFAULT CURRENT_TIMESTAMP,
        voter_ip varchar(100) NOT NULL,
        PRIMARY KEY  (id)
    ) $charset_collate;";

    require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
    dbDelta($sql);
}
register_activation_hook(__FILE__, 'election_plugin_activate');

// Add AJAX handlers
function handle_vote_submission() {
    global $wpdb;
    $table_name = $wpdb->prefix . 'election_votes';
    
    $candidate = sanitize_text_field($_POST['candidate']);
    $voter_ip = $_SERVER['REMOTE_ADDR'];
    
    // Check if IP has already voted
    $existing_vote = $wpdb->get_var(
        $wpdb->prepare(
            "SELECT COUNT(*) FROM $table_name WHERE voter_ip = %s",
            $voter_ip
        )
    );
    
    if ($existing_vote > 0) {
        wp_send_json_error('You have already voted!');
        wp_die();
    }
    
    // Insert new vote
    $result = $wpdb->insert(
        $table_name,
        array(
            'candidate_name' => $candidate,
            'voter_ip' => $voter_ip
        )
    );
    
    if ($result) {
        wp_send_json_success('Vote recorded successfully!');
    } else {
        wp_send_json_error('Error recording vote.');
    }
    wp_die();
}
add_action('wp_ajax_cast_vote', 'handle_vote_submission');
add_action('wp_ajax_nopriv_cast_vote', 'handle_vote_submission');

// Get results function
function get_vote_results() {
    global $wpdb;
    $table_name = $wpdb->prefix . 'election_votes';
    
    $trump_votes = $wpdb->get_var("SELECT COUNT(*) FROM $table_name WHERE candidate_name = 'trump'");
    $harris_votes = $wpdb->get_var("SELECT COUNT(*) FROM $table_name WHERE candidate_name = 'harris'");
    
    wp_send_json_success(array(
        'trump' => intval($trump_votes),
        'harris' => intval($harris_votes)
    ));
    wp_die();
}
add_action('wp_ajax_get_results', 'get_vote_results');
add_action('wp_ajax_nopriv_get_results', 'get_vote_results');

// Add menu to WordPress admin
function election_admin_menu() {
    add_menu_page(
        'Election Results',
        'Election Results',
        'manage_options',
        'election-results',
        'display_election_results'
    );
}
add_action('admin_menu', 'election_admin_menu');

// Display results in admin
function display_election_results() {
    global $wpdb;
    $table_name = $wpdb->prefix . 'election_votes';
    
    $trump_votes = $wpdb->get_var("SELECT COUNT(*) FROM $table_name WHERE candidate_name = 'trump'");
    $harris_votes = $wpdb->get_var("SELECT COUNT(*) FROM $table_name WHERE candidate_name = 'harris'");
    
    echo '<div class="wrap">';
    echo '<h1>Election Results</h1>';
    echo '<div style="margin-top: 20px;">';
    echo '<h2>Current Standings:</h2>';
    echo '<p>Donald Trump: ' . intval($trump_votes) . ' votes</p>';
    echo '<p>Kamala Harris: ' . intval($harris_votes) . ' votes</p>';
    echo '</div></div>';
}
?>      
