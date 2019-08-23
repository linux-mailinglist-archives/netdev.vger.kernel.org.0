Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB8089A5A7
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 04:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391255AbfHWCjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 22:39:46 -0400
Received: from mga06.intel.com ([134.134.136.31]:51859 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388226AbfHWCjq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 22:39:46 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 19:39:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="gz'50?scan'50,208,50";a="203628674"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 22 Aug 2019 19:39:42 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1i0zUM-0003PX-7U; Fri, 23 Aug 2019 10:39:42 +0800
Date:   Fri, 23 Aug 2019 10:39:20 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec-next 1/7] net: add queue argument to
 __skb_wait_for_more_packets and __skb_{,try_}recv_datagram
Message-ID: <201908231052.fKC1ARbG%lkp@intel.com>
References: <46946935e3faf51447443c9504d56c5eba49bef2.1566395202.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="f4cggq523jfhcvz6"
Content-Disposition: inline
In-Reply-To: <46946935e3faf51447443c9504d56c5eba49bef2.1566395202.git.sd@queasysnail.net>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--f4cggq523jfhcvz6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Sabrina,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on ipsec-next/master]

url:    https://github.com/0day-ci/linux/commits/Sabrina-Dubroca/ipsec-add-TCP-encapsulation-support-RFC-8229/20190823-065431
base:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/klassert/ipsec-next.git master
reproduce: make htmldocs

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:294: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:294: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:343: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:343: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:343: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:183: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_read_lock'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Function parameter or member 'range' not described in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Function parameter or member 'range' not described in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:347: warning: cannot understand function prototype: 'struct amdgpu_vm_pt_cursor '
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:348: warning: cannot understand function prototype: 'struct amdgpu_vm_pt_cursor '
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:494: warning: Function parameter or member 'start' not described in 'amdgpu_vm_pt_first_dfs'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:546: warning: Function parameter or member 'adev' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:546: warning: Function parameter or member 'vm' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:546: warning: Function parameter or member 'start' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:546: warning: Function parameter or member 'cursor' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:546: warning: Function parameter or member 'entry' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:823: warning: Function parameter or member 'level' not described in 'amdgpu_vm_bo_param'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1285: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_flags'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1285: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_flags'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1285: warning: Function parameter or member 'level' not described in 'amdgpu_vm_update_flags'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1285: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_flags'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1285: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_flags'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1285: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_flags'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1285: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_flags'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1285: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_flags'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:2812: warning: Function parameter or member 'pasid' not described in 'amdgpu_vm_make_compute'
   drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c:375: warning: Excess function parameter 'entry' description in 'amdgpu_irq_dispatch'
   drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c:376: warning: Function parameter or member 'ih' not described in 'amdgpu_irq_dispatch'
   drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c:376: warning: Excess function parameter 'entry' description in 'amdgpu_irq_dispatch'
   drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c:1: warning: no structured comments found
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:128: warning: Incorrect use of kernel-doc format:          * @atomic_obj
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:210: warning: Function parameter or member 'atomic_obj' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:210: warning: Function parameter or member 'backlight_link' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:210: warning: Function parameter or member 'backlight_caps' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:210: warning: Function parameter or member 'freesync_module' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:210: warning: Function parameter or member 'fw_dmcu' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:210: warning: Function parameter or member 'dmcu_fw_version' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:1: warning: no structured comments found
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_pin' not described in 'drm_driver'
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_unpin' not described in 'drm_driver'
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_res_obj' not described in 'drm_driver'
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_get_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_import_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_vmap' not described in 'drm_driver'
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_vunmap' not described in 'drm_driver'
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_mmap' not described in 'drm_driver'
   include/drm/drm_modeset_helper_vtables.h:1004: warning: Function parameter or member 'prepare_writeback_job' not described in 'drm_connector_helper_funcs'
   include/drm/drm_modeset_helper_vtables.h:1004: warning: Function parameter or member 'cleanup_writeback_job' not described in 'drm_connector_helper_funcs'
   include/drm/drm_atomic_state_helper.h:1: warning: no structured comments found
   drivers/gpu/drm/scheduler/sched_main.c:419: warning: Function parameter or member 'full_recovery' not described in 'drm_sched_start'
   drivers/gpu/drm/i915/i915_vma.h:50: warning: cannot understand function prototype: 'struct i915_vma '
   drivers/gpu/drm/i915/i915_vma.h:1: warning: no structured comments found
   drivers/gpu/drm/i915/intel_guc_fwif.h:536: warning: cannot understand function prototype: 'struct guc_log_buffer_state '
   drivers/gpu/drm/i915/i915_trace.h:1: warning: no structured comments found
   drivers/gpu/drm/i915/i915_reg.h:156: warning: bad line: 
   include/linux/interconnect.h:1: warning: no structured comments found
   include/linux/skbuff.h:897: warning: Function parameter or member 'dev_scratch' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'list' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'ip_defrag_offset' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'skb_mstamp_ns' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member '__cloned_offset' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'head_frag' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member '__pkt_type_offset' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'encapsulation' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'encap_hdr_csum' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'csum_valid' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member '__pkt_vlan_present_offset' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'vlan_present' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'csum_complete_sw' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'csum_level' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'inner_protocol_type' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'remcsum_offload' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'sender_cpu' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'reserved_tailroom' not described in 'sk_buff'
   include/linux/skbuff.h:897: warning: Function parameter or member 'inner_ipproto' not described in 'sk_buff'
   include/net/sock.h:238: warning: Function parameter or member 'skc_addrpair' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_portpair' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_ipv6only' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_net_refcnt' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_v6_daddr' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_v6_rcv_saddr' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_cookie' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_listener' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_tw_dr' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_rcv_wnd' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_tw_rcv_nxt' not described in 'sock_common'
   include/net/sock.h:520: warning: Function parameter or member 'sk_rx_skb_cache' not described in 'sock'
   include/net/sock.h:520: warning: Function parameter or member 'sk_wq_raw' not described in 'sock'
   include/net/sock.h:520: warning: Function parameter or member 'tcp_rtx_queue' not described in 'sock'
   include/net/sock.h:520: warning: Function parameter or member 'sk_tx_skb_cache' not described in 'sock'
   include/net/sock.h:520: warning: Function parameter or member 'sk_route_forced_caps' not described in 'sock'
   include/net/sock.h:520: warning: Function parameter or member 'sk_txtime_report_errors' not described in 'sock'
   include/net/sock.h:520: warning: Function parameter or member 'sk_validate_xmit_skb' not described in 'sock'
   include/net/sock.h:520: warning: Function parameter or member 'sk_bpf_storage' not described in 'sock'
>> net/core/datagram.c:253: warning: Function parameter or member 'queue' not described in '__skb_try_recv_datagram'
   include/linux/netdevice.h:2044: warning: Function parameter or member 'gso_partial_features' not described in 'net_device'
   include/linux/netdevice.h:2044: warning: Function parameter or member 'l3mdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2044: warning: Function parameter or member 'xfrmdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2044: warning: Function parameter or member 'tlsdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2044: warning: Function parameter or member 'name_assign_type' not described in 'net_device'
   include/linux/netdevice.h:2044: warning: Function parameter or member 'ieee802154_ptr' not described in 'net_device'
   include/linux/netdevice.h:2044: warning: Function parameter or member 'mpls_ptr' not described in 'net_device'
   include/linux/netdevice.h:2044: warning: Function parameter or member 'xdp_prog' not described in 'net_device'
   include/linux/netdevice.h:2044: warning: Function parameter or member 'gro_flush_timeout' not described in 'net_device'
   include/linux/netdevice.h:2044: warning: Function parameter or member 'nf_hooks_ingress' not described in 'net_device'
   include/linux/netdevice.h:2044: warning: Function parameter or member '____cacheline_aligned_in_smp' not described in 'net_device'
   include/linux/netdevice.h:2044: warning: Function parameter or member 'qdisc_hash' not described in 'net_device'
   include/linux/netdevice.h:2044: warning: Function parameter or member 'xps_cpus_map' not described in 'net_device'
   include/linux/netdevice.h:2044: warning: Function parameter or member 'xps_rxqs_map' not described in 'net_device'
   include/linux/phylink.h:56: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising' not described in 'phylink_link_state'
   include/linux/phylink.h:56: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising' not described in 'phylink_link_state'
   drivers/net/phy/phylink.c:593: warning: Function parameter or member 'config' not described in 'phylink_create'
   drivers/net/phy/phylink.c:593: warning: Excess function parameter 'ndev' description in 'phylink_create'
   include/linux/lsm_hooks.h:1811: warning: Function parameter or member 'quotactl' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1811: warning: Function parameter or member 'quota_on' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1811: warning: Function parameter or member 'sb_free_mnt_opts' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1811: warning: Function parameter or member 'sb_eat_lsm_opts' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1811: warning: Function parameter or member 'sb_kern_mount' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1811: warning: Function parameter or member 'sb_show_options' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1811: warning: Function parameter or member 'sb_add_mnt_opt' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1811: warning: Function parameter or member 'd_instantiate' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1811: warning: Function parameter or member 'getprocattr' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1811: warning: Function parameter or member 'setprocattr' not described in 'security_list_options'
   Documentation/admin-guide/mm/numaperf.rst:168: WARNING: Footnote [1] is not referenced.
   Documentation/bpf/btf.rst:154: WARNING: Unexpected indentation.
   Documentation/bpf/btf.rst:163: WARNING: Unexpected indentation.
   lib/list_sort.c:162: WARNING: Unexpected indentation.
   lib/list_sort.c:163: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/xarray.h:232: WARNING: Unexpected indentation.
   kernel/time/hrtimer.c:1120: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/signal.c:349: WARNING: Inline literal start-string without end-string.
   include/uapi/linux/firewire-cdev.h:312: WARNING: Inline literal start-string without end-string.
   Documentation/driver-api/gpio/driver.rst:419: WARNING: Unknown target name: "devm".
   include/linux/i2c.h:511: WARNING: Inline strong start-string without end-string.
   drivers/ata/libata-core.c:5944: WARNING: Unknown target name: "hw".
   drivers/message/fusion/mptbase.c:5057: WARNING: Definition list ends without a blank line; unexpected unindent.
   drivers/tty/serial/serial_core.c:1959: WARNING: Definition list ends without a blank line; unexpected unindent.
   include/linux/regulator/driver.h:289: WARNING: Unknown target name: "regulator_regmap_x_voltage".
   Documentation/driver-api/soundwire/locking.rst:50: WARNING: Inconsistent literal block quoting.
   Documentation/driver-api/soundwire/locking.rst:51: WARNING: Line block ends without a blank line.
   Documentation/driver-api/soundwire/locking.rst:55: WARNING: Inline substitution_reference start-string without end-string.
   Documentation/driver-api/soundwire/locking.rst:56: WARNING: Line block ends without a blank line.
   include/linux/spi/spi.h:380: WARNING: Unexpected indentation.
   fs/posix_acl.c:636: WARNING: Inline emphasis start-string without end-string.
   fs/debugfs/inode.c:385: WARNING: Inline literal start-string without end-string.
   fs/debugfs/inode.c:464: WARNING: Inline literal start-string without end-string.
   fs/debugfs/inode.c:496: WARNING: Inline literal start-string without end-string.
   fs/debugfs/inode.c:583: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:394: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:400: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:439: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:445: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:484: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:490: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:530: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:536: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:578: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:584: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:845: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:851: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:898: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:904: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:1001: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:1001: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:1096: WARNING: Inline literal start-string without end-string.
   fs/debugfs/file.c:1102: WARNING: Inline literal start-string without end-string.
   drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c:2024: WARNING: Inline emphasis start-string without end-string.
   drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c:2026: WARNING: Inline emphasis start-string without end-string.
   Documentation/networking/af_xdp.rst:319: WARNING: Literal block expected; none found.
   Documentation/networking/af_xdp.rst:326: WARNING: Literal block expected; none found.
   Documentation/networking/device_drivers/freescale/dpaa2/dpio-driver.rst:43: WARNING: Definition list ends without a blank line; unexpected unindent.
   Documentation/networking/device_drivers/freescale/dpaa2/dpio-driver.rst:63: WARNING: Unexpected indentation.
   Documentation/networking/dsa/sja1105.rst:91: WARNING: Block quote ends without a blank line; unexpected unindent.
   Documentation/networking/dsa/sja1105.rst:91: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/netdevice.h:3486: WARNING: Inline emphasis start-string without end-string.
   include/linux/netdevice.h:3486: WARNING: Inline emphasis start-string without end-string.
   net/core/dev.c:4994: WARNING: Unknown target name: "page_is".
   Documentation/security/keys/core.rst:1597: WARNING: Inline literal start-string without end-string.
   Documentation/security/keys/core.rst:1597: WARNING: Inline emphasis start-string without end-string.
   Documentation/security/keys/core.rst:1597: WARNING: Inline emphasis start-string without end-string.
   Documentation/security/keys/core.rst:1598: WARNING: Inline emphasis start-string without end-string.
   Documentation/security/keys/core.rst:1598: WARNING: Inline emphasis start-string without end-string.
   Documentation/security/keys/core.rst:1600: WARNING: Inline literal start-string without end-string.
   Documentation/security/keys/core.rst:1600: WARNING: Inline emphasis start-string without end-string.
   Documentation/security/keys/core.rst:1600: WARNING: Inline emphasis start-string without end-string.
   Documentation/security/keys/core.rst:1600: WARNING: Inline emphasis start-string without end-string.
   Documentation/security/keys/core.rst:1600: WARNING: Inline emphasis start-string without end-string.
   Documentation/security/keys/core.rst:1666: WARNING: Inline literal start-string without end-string.
   Documentation/security/keys/core.rst:1666: WARNING: Inline emphasis start-string without end-string.
   Documentation/security/keys/core.rst:1666: WARNING: Inline emphasis start-string without end-string.
   Documentation/security/keys/core.rst:1666: WARNING: Inline emphasis start-string without end-string.
   Documentation/security/keys/trusted-encrypted.rst:112: WARNING: Literal block expected; none found.
   Documentation/security/keys/trusted-encrypted.rst:121: WARNING: Unexpected indentation.
   Documentation/security/keys/trusted-encrypted.rst:122: WARNING: Block quote ends without a blank line; unexpected unindent.
   Documentation/security/keys/trusted-encrypted.rst:123: WARNING: Block quote ends without a blank line; unexpected unindent.

vim +253 net/core/datagram.c

65101aeca52241 Paolo Abeni           2017-05-16  209  
^1da177e4c3f41 Linus Torvalds        2005-04-16  210  /**
ea3793ee29d362 Rainer Weikusat       2015-12-06  211   *	__skb_try_recv_datagram - Receive a datagram skbuff
4dc3b16ba18c0f Pavel Pisa            2005-05-01  212   *	@sk: socket
d3f6cd9e6018db stephen hemminger     2017-07-12  213   *	@flags: MSG\_ flags
7c13f97ffde63c Paolo Abeni           2016-11-04  214   *	@destructor: invoked under the receive lock on successful dequeue
3f518bf745cbd6 Pavel Emelyanov       2012-02-21  215   *	@off: an offset in bytes to peek skb from. Returns an offset
3f518bf745cbd6 Pavel Emelyanov       2012-02-21  216   *	      within an skb where data actually starts
4dc3b16ba18c0f Pavel Pisa            2005-05-01  217   *	@err: error code returned
ea3793ee29d362 Rainer Weikusat       2015-12-06  218   *	@last: set to last peeked message to inform the wait function
ea3793ee29d362 Rainer Weikusat       2015-12-06  219   *	       what to look for when peeking
^1da177e4c3f41 Linus Torvalds        2005-04-16  220   *
^1da177e4c3f41 Linus Torvalds        2005-04-16  221   *	Get a datagram skbuff, understands the peeking, nonblocking wakeups
^1da177e4c3f41 Linus Torvalds        2005-04-16  222   *	and possible races. This replaces identical code in packet, raw and
^1da177e4c3f41 Linus Torvalds        2005-04-16  223   *	udp, as well as the IPX AX.25 and Appletalk. It also finally fixes
^1da177e4c3f41 Linus Torvalds        2005-04-16  224   *	the long standing peek and read race for datagram sockets. If you
^1da177e4c3f41 Linus Torvalds        2005-04-16  225   *	alter this routine remember it must be re-entrant.
^1da177e4c3f41 Linus Torvalds        2005-04-16  226   *
ea3793ee29d362 Rainer Weikusat       2015-12-06  227   *	This function will lock the socket if a skb is returned, so
ea3793ee29d362 Rainer Weikusat       2015-12-06  228   *	the caller needs to unlock the socket in that case (usually by
d651983dde41a8 Mauro Carvalho Chehab 2017-05-12  229   *	calling skb_free_datagram). Returns NULL with @err set to
ea3793ee29d362 Rainer Weikusat       2015-12-06  230   *	-EAGAIN if no data was available or to some other value if an
ea3793ee29d362 Rainer Weikusat       2015-12-06  231   *	error was detected.
^1da177e4c3f41 Linus Torvalds        2005-04-16  232   *
^1da177e4c3f41 Linus Torvalds        2005-04-16  233   *	* It does not lock socket since today. This function is
^1da177e4c3f41 Linus Torvalds        2005-04-16  234   *	* free of race conditions. This measure should/can improve
^1da177e4c3f41 Linus Torvalds        2005-04-16  235   *	* significantly datagram socket latencies at high loads,
^1da177e4c3f41 Linus Torvalds        2005-04-16  236   *	* when data copying to user space takes lots of time.
^1da177e4c3f41 Linus Torvalds        2005-04-16  237   *	* (BTW I've just killed the last cli() in IP/IPv6/core/netlink/packet
^1da177e4c3f41 Linus Torvalds        2005-04-16  238   *	*  8) Great win.)
^1da177e4c3f41 Linus Torvalds        2005-04-16  239   *	*			                    --ANK (980729)
^1da177e4c3f41 Linus Torvalds        2005-04-16  240   *
^1da177e4c3f41 Linus Torvalds        2005-04-16  241   *	The order of the tests when we find no data waiting are specified
^1da177e4c3f41 Linus Torvalds        2005-04-16  242   *	quite explicitly by POSIX 1003.1g, don't change them without having
^1da177e4c3f41 Linus Torvalds        2005-04-16  243   *	the standard around please.
^1da177e4c3f41 Linus Torvalds        2005-04-16  244   */
ccefe503d27b45 Sabrina Dubroca       2019-08-21  245  struct sk_buff *__skb_try_recv_datagram(struct sock *sk,
ccefe503d27b45 Sabrina Dubroca       2019-08-21  246  					struct sk_buff_head *queue,
ccefe503d27b45 Sabrina Dubroca       2019-08-21  247  					unsigned int flags,
7c13f97ffde63c Paolo Abeni           2016-11-04  248  					void (*destructor)(struct sock *sk,
7c13f97ffde63c Paolo Abeni           2016-11-04  249  							   struct sk_buff *skb),
fd69c399c7d626 Paolo Abeni           2019-04-08  250  					int *off, int *err,
ea3793ee29d362 Rainer Weikusat       2015-12-06  251  					struct sk_buff **last)
^1da177e4c3f41 Linus Torvalds        2005-04-16  252  {
ea3793ee29d362 Rainer Weikusat       2015-12-06 @253  	struct sk_buff *skb;
738ac1ebb96d02 Herbert Xu            2015-07-13  254  	unsigned long cpu_flags;
^1da177e4c3f41 Linus Torvalds        2005-04-16  255  	/*
^1da177e4c3f41 Linus Torvalds        2005-04-16  256  	 * Caller is allowed not to check sk->sk_err before skb_recv_datagram()
^1da177e4c3f41 Linus Torvalds        2005-04-16  257  	 */
^1da177e4c3f41 Linus Torvalds        2005-04-16  258  	int error = sock_error(sk);
^1da177e4c3f41 Linus Torvalds        2005-04-16  259  
^1da177e4c3f41 Linus Torvalds        2005-04-16  260  	if (error)
^1da177e4c3f41 Linus Torvalds        2005-04-16  261  		goto no_packet;
^1da177e4c3f41 Linus Torvalds        2005-04-16  262  
^1da177e4c3f41 Linus Torvalds        2005-04-16  263  	do {
^1da177e4c3f41 Linus Torvalds        2005-04-16  264  		/* Again only user level code calls this function, so nothing
^1da177e4c3f41 Linus Torvalds        2005-04-16  265  		 * interrupt level will suddenly eat the receive_queue.
^1da177e4c3f41 Linus Torvalds        2005-04-16  266  		 *
^1da177e4c3f41 Linus Torvalds        2005-04-16  267  		 * Look at current nfs client by the way...
8917a3c0b7d155 David Shwatrz         2010-12-02  268  		 * However, this function was correct in any case. 8)
^1da177e4c3f41 Linus Torvalds        2005-04-16  269  		 */
4934b0329f7150 Pavel Emelyanov       2012-02-21  270  		spin_lock_irqsave(&queue->lock, cpu_flags);
65101aeca52241 Paolo Abeni           2017-05-16  271  		skb = __skb_try_recv_from_queue(sk, queue, flags, destructor,
fd69c399c7d626 Paolo Abeni           2019-04-08  272  						off, &error, last);
3f518bf745cbd6 Pavel Emelyanov       2012-02-21  273  		spin_unlock_irqrestore(&queue->lock, cpu_flags);
de321ed3847125 Andrey Vagin          2017-05-17  274  		if (error)
de321ed3847125 Andrey Vagin          2017-05-17  275  			goto no_packet;
65101aeca52241 Paolo Abeni           2017-05-16  276  		if (skb)
^1da177e4c3f41 Linus Torvalds        2005-04-16  277  			return skb;
2b5cd0dfa38424 Alexander Duyck       2017-03-24  278  
2b5cd0dfa38424 Alexander Duyck       2017-03-24  279  		if (!sk_can_busy_loop(sk))
2b5cd0dfa38424 Alexander Duyck       2017-03-24  280  			break;
2b5cd0dfa38424 Alexander Duyck       2017-03-24  281  
2b5cd0dfa38424 Alexander Duyck       2017-03-24  282  		sk_busy_loop(sk, flags & MSG_DONTWAIT);
ccefe503d27b45 Sabrina Dubroca       2019-08-21  283  	} while (queue->prev != *last);
a5b50476f77a8f Eliezer Tamir         2013-06-10  284  
^1da177e4c3f41 Linus Torvalds        2005-04-16  285  	error = -EAGAIN;
^1da177e4c3f41 Linus Torvalds        2005-04-16  286  
^1da177e4c3f41 Linus Torvalds        2005-04-16  287  no_packet:
^1da177e4c3f41 Linus Torvalds        2005-04-16  288  	*err = error;
^1da177e4c3f41 Linus Torvalds        2005-04-16  289  	return NULL;
^1da177e4c3f41 Linus Torvalds        2005-04-16  290  }
ea3793ee29d362 Rainer Weikusat       2015-12-06  291  EXPORT_SYMBOL(__skb_try_recv_datagram);
ea3793ee29d362 Rainer Weikusat       2015-12-06  292  

:::::: The code at line 253 was first introduced by commit
:::::: ea3793ee29d3621faf857fa8ef5425e9ff9a756d core: enable more fine-grained datagram reception control

:::::: TO: Rainer Weikusat <rweikusat@mobileactivedefense.com>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--f4cggq523jfhcvz6
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICFVKX10AAy5jb25maWcAlFxbc+M2sn7fX8FKqk7N1FYmHtvjeM8pP0AgJCHmbQhQF7+w
FJl2VLElH0nenfn3pxsgRZBsaHK2NomNbtwb3V9f6J//8XPA3o+719Vxs169vHwPnqtttV8d
q8fgafNS/U8QpkGS6kCEUn8C5mizff/26+bq9ib48uny08Uv+/VlcF/tt9VLwHfbp83zO/Te
7Lb/+Pkf8P+fofH1DQba/3fwvF7/8lvwIaz+2Ky2wW+frqH354uP9ifg5WkylpOS81KqcsL5
3femCX4pZyJXMk3ufru4vrg48UYsmZxIF84QU6ZKpuJykuq0HagmzFmelDFbjkRZJDKRWrJI
PoiwZZT513Ke5vdty6iQUahlLEqx0GwUiVKluW7pepoLFpYyGafwr1IzhZ3NEUzMkb4Eh+r4
/tZudJSn9yIp06RUceZMDespRTIrWT4pIxlLfXd1iQdZbyGNMwmza6F0sDkE290RB256Ryln
UXMgP/3U9nMJJSt0SnQ2eywVizR2rRunbCbKe5EnIionD9JZqUsZAeWSJkUPMaMpiwdfj9RH
uG4J3TWdNuouyN1jnwGXdY6+eDjfOz1PvibONxRjVkS6nKZKJywWdz992O621UfnmtRSzWTG
ybF5nipVxiJO82XJtGZ8SvIVSkRyRMxvjpLlfAoCAO8Z5gKZiBoxBZkPDu9/HL4fjtVrK6YT
kYhccvMksjwdCeddOiQ1Tec0JRdK5DOmUfDiNBTdVzZOcy7C+vnIZNJSVcZyJZDJXG+1fQx2
T71Vtoog5fcqLWAseN2aT8PUGcls2WUJmWZnyPgEHaXhUGagKKCzKCOmdMmXPCKOw2iJWXu6
PbIZT8xEotVZYhmDHmHh74XSBF+cqrLIcC3N/enNa7U/UFc4fSgz6JWGkrsvJUmRIsNIkGJk
yCRlKidTvFaz01x1eep7GqymWUyWCxFnGoZPhLuapn2WRkWiWb4kp665XJo1M1nxq14d/gqO
MG+wgjUcjqvjIVit17v37XGzfW6PQ0t+X0KHknGewlxW6k5ToFSaK2zJ9FKUJHf+N5Zilpzz
IlDDy4L5liXQ3CXBr2B24A4pla8ss9tdNf3rJXWncrZ6b3/w6YoiUbWt41N4pEY4e+9mzhJd
jvDJAUORxCwrdTQqx1Ghpu4W+CRPi0zRim0q+H2WShgJpEqnOS2QdhFou8xYJE8uIkZLzii6
BwU8M487D4kdAzhIM7h4QAKolfDJwH9ilvCOnPbZFPzgPT8Zfr5xNBqoBB3BTXKRGXWoc8ZF
z9RlXGX3MHvENE7fUq0AuEuJwZhI0PY5fVwToWOAIWWtiWimpRqrsxzjKUt8KiJLlVyQWuD0
XOFS7+n7KDzPqrt/ui8DwzAufCsutFiQFJGlvnOQk4RF45Akmg16aEZXe2hqCsaapDBJwweZ
lkXuUzgsnEnYd31Z9IHDhCOW59IjE/fYcRnTfUfZ+KwkoKQZADOmno/RBoiu2yXAaAmYKnjP
HWWmxFeiP/QSYeiCcPscYM7yZC0dKfl80YFYRqXWjkhW7Z92+9fVdl0F4t/VFpQvA0XIUf2C
UWp1rWfwUIBwWiLsuZzFcCJpD5PVmvVvztiOPYvthKWxLb53gyifgV7N6bejIkbhOxUVI3cf
KkpH3v5wT/lENJjUzzYGixtJQDs56IGUFucu45TlIcAU35soxmOwKBmDyc25MlD4HuWRjmU0
eA31yXe9quYIFrc35ZXjiMDvrmuldF5wo3pDwQGL5i0xLXRW6NKofPB/qpenq8tf0NH9qSPh
cF7217ufVvv1n79+u735dW0c34Nxi8vH6sn+fuqHVjMUWamKLOv4jGBc+b2xAUNaHBc9Sxuj
bc2TsBxJCw7vbs/R2eLu8w3N0EjXD8bpsHWGO8F7xcow7kNp8KwbU1aOQ06AV0DRoxxhdIjm
utcddQiiMzTlC4oGfg8AcJkIY3sJDpAaeFllNgEJ0j19ooQuMnzbFgGC19EyJALwRUMy+giG
yhHoT4vk3sNnBJlks+uRI3AJrfcD5lLJUdRfsipUJuC8PWSDsKYFzJLF4J3D6yI5zOGyyHAC
AhvMYeRLNboNFm0eX+elwMsBx+ZhWU6Ur3thXECHPAYAIFgeLTm6d8LBK9nEYscI9F2k7i57
QRjF8ALxBeAtCQ5aoPFksv1uXR0Ou31w/P5mIfRTtTq+76uDBft2oAfwIFD8aD0T0wARtzkW
TBe5KNEHp/XvJI3CsVS0f50LDTgC5M87gRVfAHs5bUmRRyw0XDoK0jmkU9+KzCW9UIuJ01iC
5sphO6WB0R7rP12C0AKGANQ6KXrxoxZBXN/e0IQvZwha0TELpMXxgjBW8Y1RzS0nvAFAs7GU
9EAn8nk6fYwN9Zqm3ns2dv+bp/2Wbud5oVJaLGIxHksu0oSmzmXCpzLjnoXU5CvapsagKT3j
TgRYucni8xlqGdFgOebLXC685z2TjF+VdIjNED1nh3DQ0wuQgP8V1MaDkCSkGqFPcDfWPKip
HOu7Ly5L9NlPQ5iXgR6yrqgq4q5eBOnuNvA4W/Dp5Oa635zOui1gXmVcxEYjjFkso+XdjUs3
6hicwljl3WBIyoXCh6pEBLqRcldhRFDLZudOlKlpNpfXgUINhcXhsHG6nKQJMQo8G1bkQwKg
lkTFQjNyiiLmtr1VPZnQ1o8iLziMJbHFxFhYhcgTrN9ITACrfKaJoEqHpBrbDgjQ0BEtPJRM
0grMXCLvvGlroxzE/7rbbo67vQ0ytXfYOhd45qCZ5/3d11DWM1Z3EZGYML4E/8GjhXUKcj2i
jaG8pf0IHDcXozTVYMZ90ZlYcpBGeFr+81H0rdamUNJaK0kxjtjzkBtxsZTrTmCubry5puJV
s1hlEVjBq06XthWDNuQyGpZL2uluyT8c4TO1LgMP0/EYcOfdxTd+Yf/X2yeBYaEVhJrny0z3
qGPAC5bKCCxpguZ+stEmTQ4Bo/GO6pARyljUQAgMdhfi7qJ7AZk+A3tQeYK/kCp0+vPCBLk8
CttmBcD4pPO7m2tH2nROC5NZ/xkfFAdV4Lp4iUZRgmqSNIsSHB0eGjg9lJ8vLig5fSgvv1x0
hPShvOqy9kahh7mDYZwwjVgIXw6IKXBCi+5CG1mbLpUE5wphdY7i9rmWNjc8ig43Ssa5/uCf
TRLof9nrXnuEs1DR4Sseh8YvA41CA1+QODlellGo6UhToxDPOAAdebZC3sjzNNVZVExObsTu
P9U+ALW6eq5eq+3RjMN4JoPdG6aoO85E7YTRgQhKRXX9IhzWFQMzDSlm4057k7wIxvvqf9+r
7fp7cFivXnqmxKCHvBs2c/MNRO/TwPLxpeqPNcz5OGPZDqer+OEhmsFH74emIfiQcRlUx/Wn
j+68GCsYFYo4yTqKgDa4k4dRHs+Oo1ySpDTypE5BoGmQmwj95csFDY+NRlmq8Yg8Ks+O7Wls
tqv990C8vr+sGknrPqEaHTVjDfi7KVvAxRhtSUG99cIZTUhlUmSN2I83+9f/rPZVEO43/7bh
zjZaHdISPpZ5PGe5eUk+HTpJ00kkTqwDKdbV834VPDWzP5rZDaVJCdIMDXmw7m4FwCzuGHaZ
6wKrNljfxnRKLjBEtzlWa1QdvzxWbzAVynD7/t0pUhtwdGxm01ImsbTo1V3D76CFy4iNRESp
dBzR+HwSo71FYnQq5q84IvueXUb/A6svtEzKkZoPrlmC04RhOSKgdd+PyNhWDFJQBAAxdAfb
iuUoYyotNS4SGzgVeQ5uiUx+F+b3HhscVK/F7M+MOE3T+x4Rnz38ruWkSAsiHa7ghFFZ1fUB
VKwP1C+aFJugJxgAeNX2wUMMZW4w0eDQ7cptXY8NHJfzqdQmyE1E4MDfWCYMH6o2WTfTo8d3
dTkCoAhwsOxfYy4mYEWS0IbEaimpVWKHT4mvvqvBiiFvx+m8HMFWbJ61R4vlAiSzJSuznB4T
pn8w9lXkCWB3OHTphs/7yRpCEjAvgLFwcLdCYSN+pgc1CDF/k4/J6yNCEETdWPssz1NNgFnL
2VBorByXio1F4+n3h6ofcy0WCPJ7HHU/W3floYVp4Qn3yoyXtvylqeUitlIj1jrcTXLgQUVw
q/0geD/s2hinOjTbIQ8qNbpkn+6zm5F6CirNXpgJUPZvlai26AtnOjOhb49eSdDlEXWInLgI
gJyNayQ4CK0TyQFSEYHOQ+0rIhS6iNARhmL8jk62oV1EJ/HSYxALeO+k8ur2uu0KSJotG82j
I2dMHmHMewSnCSY4dAgpFu7JSY1irwYE1lPWN9eoiPDgncEbaDIktQpTg1rWTZlbPncSNGdI
/e724D08OWbYiqRT6dC0DZL+g8vI4BKvLhtHB/asGlw04enslz9Wh+ox+Mtmbd/2u6fNS6c2
6LQK5C4b82/ruNrU45mRTr4UOCIg+Vjqx/ndT8///Ge3ohJrWi2Pa/Y6jfWqefD28v686bor
LSdWoZmri1DW6NoXhxtUHj4W+CcHIfsRN8q91XF0DtZdXD8x+wPs1ezZ1HIoTLG7Ybn6aVJ5
g/rR6lxg9CC9LzrlnyO0MJSTkdiMYQa7KhJkqisLu3Tz5Cz9HI3sO88BHPg6u8Ru754jabE+
YGwCIn4tRIFWBzZhihL9LPmcYjBPsKnJKEdijP9Bk1rXZRoJE9+q9ftx9cdLZUrAAxOaPHak
bySTcaxRM9KFJJaseC49IbOaI5aetBGurx/kOAmYb4FmhXH1ugNXKm4d1gHYPxsEa6JrMUsK
FnXM3im0ZmmEkNWdu6OVJi1h+zmApR0OrKN2zZI1WyI2olz37vbEaGOmDdnEs6/dkwMlzj2B
N/SaSp2iH+7u7F5RAY6mWtkYKluLGuZ31xf/unGCzoT9pQL5bsL8vuPIcYAnicnLeCJKdBDg
IfOFmB5GBe3jPqhhHU/P3TCJ7MbZ6uRjRG5yG3BTnoQxgNqRSPg0Zjmlfk7PL9PCIhHWMSl+
se3EKryOJtZu/W6qls0rCKt/b9ZuBKDDLBVzNyd6kZYO6OadmAzGOcgIGeesW1TZuuGbdb2O
IB2G3QpbDDUVUeZLDYmZjrOxJ/2twUAxBEWeCiI7/Cm8Yb5wGCzzFHl42a0e65hF84DnYGNY
6Enc9Du6AaconZt6U1qVnTaH1RhhDl6Ib/eGQcxyT6WCZcCvQephwEwhYj4j5abwpdCpp5of
ybMiwmqSkQRNI4XqgB/6Tk9RwEcjegc38OM2O08mUZ6Ek6YfcDr2PaxYTqb6VHME+qiupWoF
wTYNbj6ZxSJQ729vu/3RXXGn3dqVzWHd2Vtz/kUcL9Ggk0sGjRClCmtNMNshuecSFXhGtPq7
JJctBNxdHBychTcTGkr5ryu+uCFFtte1jtx9Wx0CuT0c9++vpnjx8CdI9WNw3K+2B+QLANtW
wSOcweYNf+yG9f7fvU139nIEnBiMswlzgoK7/2zxMQWvu8d3sO0fMLC92VcwwSX/2HxUJrdH
AN2Ak4L/CvbVi/lcrT2MHgtKX9gEIw1NgR9INM/SrNvaRhvTrB+77k0y3R2OveFaIl/tH6kl
ePl3b6cEiDrC7ly78IGnKv7oqPbT2sNBxPXcOTkyw6cpKSsdme967S1cVFzJmsm5g0awgYgI
y1UgVAfn8TMuE8xl1+qMOvS39+NwxjZvkGTF8MlM4Q6MhMlf0wC7dLM/+HnM39MuhtXVLRMW
i/4rPW2Wmra9HWIjdlXwgFZreB6UxtEeJw+MhK/cHEj3Phruh0XGVPVEvD3RLJal/QzAU1g2
P5eZTWY+9Zbx29+ubr6Vk8xTD58o7ifCiiY25ewvLNEc/sno2bWIeN9bbDNhgytwohFmrwB+
Cyz6zIqhiF5yUjIv6SJyl93hvqJ9I+XLLGYxTZj2P1RqTj8bPq5MZ8H6Zbf+q69PxdY4XNl0
id8WYhIQ4Ch+IotZY3MBgMXiDKu1jzsYrwqOf1bB6vFxg/hg9WJHPXxy1dNwMmdxMvGWT6JE
9L5wPNHmdC7PFN+UbOb5TMVQsSSBdlctHX30iH5703nsqezTU/CuGb2P5ktFQvEoNXLrgdtL
VlTh/wjcJJJ91POfLJR5fzlunt63a7yZRv88DpOF8Tg035yWnloEpMeIjWkXbaoRiinJr7y9
70WcRZ6aRhxc31z9y1NGCGQV+zK3bLT4cnFhoLe/91JxXzUmkLUsWXx19WWBxX8s9J+A/hov
+iVZjf08d9COOhGTIvJ+BRGLULImPjT0sPartz836wOlbkJPTTG0lyHW9vHBcAy6EADebbZ8
PAs+sPfHzQ7Ayqla4+PgTwC0I/ytDtYb269eq+CP96cnUL7h0P558vFkN+uVrNZ/vWye/zwC
Cop4eAY6ABX/poDC0kFE63TsCnMqBhL4WRvH5wczn3yq/i06Dz4tEupzqwIURDrlsgQPTUem
AFIyJ8CP9MFHJdh4ikRMeeiqiqKrWcyxYJsB8I9dtInt2Z/fD/g3I4Jo9R2t5FB/JICaccYF
F3JGns+ZcToLA4wVTjy6WS8zj37CjnmKX6/OpfZ+Kz8qiyiTXuxTzGk7E8celSBihR8Ye6pN
5mUkQnomm7mVxudeEjcuQsab8LDieeF84mFIg9vOQQGDmew2xPzz9c3t59ua0iohza080yoD
9fzAf7WhppiNijFZUoWRZsyfkHff6+ecQ7EIpcp83/EWHjRoYpuEz9BhkClcUDIEbPFmvd8d
dk/HYPr9rdr/Mgue3yvw6A7D0MCPWJ39azbxfcuJtUXNhx8lcbRtBGAK7ro48fq++owilqSL
89+STOdN4mCwf25QmNq97ztQ4BSjvVc5L+Xt5RcnswitYqaJ1lEUnlpbPE3N4Lp9MhqldI2W
TOO48FrAvHrdHSt0mCkdhMEwjSEPGnkTne2gb6+HZ3K8LFaNKNEjdnr29PhcEnVTCtb2QZlP
84N0C47H5u1jcHir1punU5jtpHnZ68vuGZrVjneW15hZgmz7wYDg/Pu6DanWcu53q8f17tXX
j6TbwNoi+3W8ryosR6yCr7u9/Oob5EeshnfzKV74BhjQrA+2yK6/fRv0aWQKqItF+TWe0Kir
picZrbyIwc3oX99XL3Ae3gMj6a6Q4F8PGUjIAlPL3q0s8BvZRTnjBblUqvMpFPO3RM/xg4yu
GlaiNmZoob2Q2iTb6KP2KPRsHg9OAuOsa1jlMNIEELWcgGWMGdxablLJzl+M6fRxps6wLsVn
+o0/aMrTAEX4Qh/jeIiiwSPu/GWP1nGtQ+zIQEJLHpf3acIQllx6udDhzhasvLxNYnTuaSDS
4cLxSOnoLrXn8XJPJWjMh1CR+IaFsp7n2JyTZ0OcwbaP+93m0T1OloR52v+6pFFpNbuDYZin
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
Dlkxl2gAAA==

--f4cggq523jfhcvz6--
