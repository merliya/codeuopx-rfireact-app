/**
 * New Relic agent configuration.
 *
 * See lib/config/default.js in the agent distribution for a more complete
 * description of configuration variables and their potential values.
 * https://docs.newrelic.com/docs/agents/nodejs-agent/installation-configuration/nodejs-agent-configuration#environment-variable-overrides
 */
exports.config = {
  /**
   * Array of application names.
   */
  app_name: ['Rfi Node'], // Override with NEW_RELIC_APP_NAME Environ Var
  /**
   * Your New Relic license key.
   */
  license_key: '', // Override with NEW_RELIC_LICENSE_KEY Environ Var
  logging: {
    /**
     * Level at which to log. 'trace' is most useful to New Relic when diagnosing
     * issues with the agent, 'info' and higher will impose the least overhead on
     * production applications.
     */
    level: 'info', // Override with NEW_RELIC_LOG_LEVEL Environ Var
  },
  /**
   * When true, all request headers except for those listed in attributes.exclude
   * will be captured for all traces, unless otherwise specified in a destination's
   * attributes include/exclude lists.
   */
  agent_enabled: true, // Override with NEW_RELIC_ENABLED Environ Var
  allow_all_headers: true,
  high_security: false, // Override with NEW_RELIC_HIGH_SECURITY
  attributes: {
    /**
     * Prefix of attributes to exclude from all destinations. Allows * as wildcard
     * at end.
     *
     * NOTE: If excluding headers, they must be in camelCase form to be filtered.
     *
     * @env NEW_RELIC_ATTRIBUTES_EXCLUDE
     */
    exclude: [
      'request.headers.cookie',
      'request.headers.authorization',
      'request.headers.proxyAuthorization',
      'request.headers.setCookie*',
      'request.headers.x*',
      'response.headers.cookie',
      'response.headers.authorization',
      'response.headers.proxyAuthorization',
      'response.headers.setCookie*',
      'response.headers.x*',
    ],
  },
};
