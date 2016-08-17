module Bosh
  module Director
  end
end

require 'digest/sha1'
require 'erb'
require 'fileutils'
require 'forwardable'
require 'logger'
require 'logging'
require 'monitor'
require 'optparse'
require 'ostruct'
require 'pathname'
require 'pp'
require 'thread'
require 'tmpdir'
require 'yaml'
require 'time'
require 'zlib'

require 'common/exec'
require 'bosh/template/evaluation_context'
require 'common/version/release_version_list'

require 'bcrypt'
require 'blobstore_client'
require 'eventmachine'
require 'netaddr'
require 'delayed_job'
require 'sequel'
require 'sinatra/base'
require 'securerandom'
require 'nats/client'
require 'securerandom'
require 'delayed_job_sequel'

require 'common/thread_formatter'
require 'bosh/core/encryption_handler'
require 'bosh/director/api'
require 'bosh/director/dns/blobstore_dns_publisher'
require 'bosh/director/dns/canonicalizer'
require 'bosh/director/dns/dns_manager'
require 'bosh/director/dns/local_dns_repo'
require 'bosh/director/dns/dns_records'
require 'bosh/director/errors'
require 'bosh/director/ext'
require 'bosh/director/ip_util'
require 'bosh/director/cidr_range_combiner'
require 'bosh/director/lock_helper'
require 'bosh/director/validation_helper'
require 'bosh/director/download_helper'
require 'bosh/director/tagged_logger'
require 'bosh/director/legacy_deployment_helper'

require 'bosh/director/version'
require 'bosh/director/config'
require 'bosh/director/event_log'
require 'bosh/director/task_result_file'
require 'bosh/director/blob_util'

require 'bosh/director/agent_client'
require 'cloud'
require 'bosh/director/compile_task'
require 'bosh/director/key_generator'
require 'bosh/director/package_dependencies_manager'

require 'bosh/director/job_renderer'
require 'bosh/director/cycle_helper'
require 'bosh/director/encryption_helper'
require 'bosh/director/worker'
require 'bosh/director/password_helper'
require 'bosh/director/vm_creator'
require 'bosh/director/vm_recreator'
require 'bosh/director/vm_deleter'
require 'bosh/director/vm_metadata_updater'
require 'bosh/director/instance_reuser'
require 'bosh/director/deployment_plan'
require 'bosh/director/runtime_config'
require 'bosh/director/compiled_release'
require 'bosh/director/errand'
require 'bosh/director/duration'
require 'bosh/director/hash_string_vals'
require 'bosh/director/instance_deleter'
require 'bosh/director/instance_updater'
require 'bosh/director/instance_updater/preparer'
require 'bosh/director/instance_updater/state_applier'
require 'bosh/director/instance_updater/instance_state'
require 'bosh/director/single_disk_manager'
require 'bosh/director/multiple_disks_manager'
require 'bosh/director/disk_manager_factory'
require 'bosh/director/orphan_disk_manager'
require 'bosh/director/stopper'
require 'bosh/director/job_runner'
require 'bosh/director/job_updater'
require 'bosh/director/job_updater_factory'
require 'bosh/director/job_queue'
require 'bosh/director/lock'
require 'bosh/director/nats_rpc'
require 'bosh/director/network_reservation'
require 'bosh/director/problem_scanner/scanner'
require 'bosh/director/problem_resolver'
require 'bosh/director/post_deployment_script_runner'
require 'bosh/director/error_ignorer'
require 'bosh/director/deployment_deleter'
require 'bosh/director/permission_authorizer'
require 'bosh/director/transactor'
require 'bosh/director/sequel'
require 'bosh/director/agent_broadcaster'
require 'bosh/director/timeout'
require 'common/thread_pool'

require 'bosh/director/config_parser/deep_hash_replacement'
require 'bosh/director/config_parser/config_parser'
require 'bosh/director/config_parser/uaa_auth_provider'
require 'bosh/director/config_parser/http_client'

require 'bosh/director/manifest/manifest'
require 'bosh/director/manifest/changeset'
require 'bosh/director/manifest/diff_lines'
require 'bosh/director/manifest/deployment_manifest_resolver'

require 'bosh/director/log_bundles_cleaner'
require 'bosh/director/logs_fetcher'

require 'bosh/director/cloudcheck_helper'
require 'bosh/director/problem_handlers/base'
require 'bosh/director/problem_handlers/invalid_problem'
require 'bosh/director/problem_handlers/inactive_disk'
require 'bosh/director/problem_handlers/missing_disk'
require 'bosh/director/problem_handlers/unresponsive_agent'
require 'bosh/director/problem_handlers/mount_info_mismatch'
require 'bosh/director/problem_handlers/missing_vm'

require 'bosh/director/jobs/base_job'
require 'bosh/director/jobs/backup'
require 'bosh/director/jobs/scheduled_backup'
require 'bosh/director/jobs/scheduled_orphan_cleanup'
require 'bosh/director/jobs/scheduled_events_cleanup'
require 'bosh/director/jobs/create_snapshot'
require 'bosh/director/jobs/snapshot_deployment'
require 'bosh/director/jobs/snapshot_deployments'
require 'bosh/director/jobs/snapshot_self'
require 'bosh/director/jobs/delete_deployment'
require 'bosh/director/jobs/delete_deployment_snapshots'
require 'bosh/director/jobs/delete_release'
require 'bosh/director/jobs/delete_snapshots'
require 'bosh/director/jobs/delete_orphan_disks'
require 'bosh/director/jobs/delete_stemcell'
require 'bosh/director/jobs/cleanup_artifacts'
require 'bosh/director/jobs/export_release'
require 'bosh/director/jobs/update_deployment'
require 'bosh/director/jobs/update_release'
require 'bosh/director/jobs/update_stemcell'
require 'bosh/director/jobs/fetch_logs'
require 'bosh/director/jobs/vm_state'
require 'bosh/director/jobs/run_errand'
require 'bosh/director/jobs/cloud_check/scan'
require 'bosh/director/jobs/cloud_check/scan_and_fix'
require 'bosh/director/jobs/cloud_check/apply_resolutions'
require 'bosh/director/jobs/release/release_job'
require 'bosh/director/jobs/ssh'
require 'bosh/director/jobs/attach_disk'
require 'bosh/director/jobs/delete_vm'
require 'bosh/director/jobs/helpers'
require 'bosh/director/jobs/db_job'

require 'bosh/director/models/helpers/model_helper'

require 'bosh/director/db_backup'
require 'bosh/director/blobstores'
require 'bosh/director/api/director_uuid_provider'
require 'bosh/director/api/local_identity_provider'
require 'bosh/director/api/uaa_identity_provider'
require 'bosh/director/api/event_manager'
require 'bosh/director/app'

module Bosh::Director
  autoload :Models, 'bosh/director/models' # Defining model classes relies on a database connection
end

require 'bosh/director/thread_pool'
require 'bosh/director/api/extensions/scoping'
require 'bosh/director/api/extensions/syslog_request_logger'
require 'bosh/director/api/controllers/backups_controller'
require 'bosh/director/api/controllers/cleanup_controller'
require 'bosh/director/api/controllers/deployments_controller'
require 'bosh/director/api/controllers/disks_controller'
require 'bosh/director/api/controllers/packages_controller'
require 'bosh/director/api/controllers/info_controller'
require 'bosh/director/api/controllers/releases_controller'
require 'bosh/director/api/controllers/resources_controller'
require 'bosh/director/api/controllers/resurrection_controller'
require 'bosh/director/api/controllers/stemcells_controller'
require 'bosh/director/api/controllers/tasks_controller'
require 'bosh/director/api/controllers/task_controller'
require 'bosh/director/api/controllers/users_controller'
require 'bosh/director/api/controllers/cloud_configs_controller'
require 'bosh/director/api/controllers/runtime_configs_controller'
require 'bosh/director/api/controllers/locks_controller'
require 'bosh/director/api/controllers/restore_controller'
require 'bosh/director/api/controllers/events_controller'
require 'bosh/director/api/controllers/vms_controller'
require 'bosh/director/api/route_configuration'
