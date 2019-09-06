Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 218B3ABF0E
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 19:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391861AbfIFR5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 13:57:03 -0400
Received: from mga06.intel.com ([134.134.136.31]:11375 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387514AbfIFR5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 13:57:03 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 10:57:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,473,1559545200"; 
   d="gz'50?scan'50,208,50";a="199565693"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 06 Sep 2019 10:56:58 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1i6ITi-000DlW-17; Sat, 07 Sep 2019 01:56:58 +0800
Date:   Sat, 7 Sep 2019 01:56:19 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     kbuild-all@01.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [vhost:linux-next 13/15] htmldocs: mm/page_alloc.c:2207: warning:
 Function parameter or member 'order' not described in 'free_reported_page'
Message-ID: <201909070118.KtjSE7w2%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zilj7cnfkx3kml4z"
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zilj7cnfkx3kml4z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/mst/vhost.git linux-next
head:   c5db5a8d998da36ada7287aa53b4ed501a0a2b2b
commit: b1b0d638e6f93b91cf34585350bb00035d066989 [13/15] mm: Introduce Reported pages
reproduce: make htmldocs

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   Warning: The Sphinx 'sphinx_rtd_theme' HTML theme was not found. Make sure you have the theme installed to produce pretty HTML output. Falling back to the default theme.
   WARNING: dot(1) not found, for better output quality install graphviz from http://www.graphviz.org
   WARNING: convert(1) not found, for SVG to PDF conversion install ImageMagick (https://www.imagemagick.org)
   drivers/usb/typec/bus.c:1: warning: 'typec_altmode_register_driver' not found
   drivers/usb/typec/bus.c:1: warning: 'typec_altmode_unregister_driver' not found
   drivers/usb/typec/class.c:1: warning: 'typec_altmode_unregister_notifier' not found
   drivers/usb/typec/class.c:1: warning: 'typec_altmode_register_notifier' not found
   include/linux/w1.h:272: warning: Function parameter or member 'of_match_table' not described in 'w1_family'
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
   lib/genalloc.c:1: warning: 'gen_pool_add_virt' not found
   lib/genalloc.c:1: warning: 'gen_pool_alloc' not found
   lib/genalloc.c:1: warning: 'gen_pool_free' not found
   lib/genalloc.c:1: warning: 'gen_pool_alloc_algo' not found
   include/linux/regulator/machine.h:196: warning: Function parameter or member 'max_uV_step' not described in 'regulation_constraints'
   include/linux/regulator/driver.h:223: warning: Function parameter or member 'resume' not described in 'regulator_ops'
   include/linux/spi/spi.h:190: warning: Function parameter or member 'driver_override' not described in 'spi_device'
   fs/direct-io.c:258: warning: Excess function parameter 'offset' description in 'dio_complete'
   fs/libfs.c:496: warning: Excess function parameter 'available' description in 'simple_write_end'
   fs/posix_acl.c:647: warning: Function parameter or member 'inode' not described in 'posix_acl_update_mode'
   fs/posix_acl.c:647: warning: Function parameter or member 'mode_p' not described in 'posix_acl_update_mode'
   fs/posix_acl.c:647: warning: Function parameter or member 'acl' not described in 'posix_acl_update_mode'
   include/linux/i2c.h:337: warning: Function parameter or member 'init_irq' not described in 'i2c_client'
   include/linux/input/sparse-keymap.h:43: warning: Function parameter or member 'sw' not described in 'key_entry'
   include/linux/skbuff.h:893: warning: Function parameter or member 'dev_scratch' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'list' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'ip_defrag_offset' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'skb_mstamp_ns' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member '__cloned_offset' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'head_frag' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member '__pkt_type_offset' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'encapsulation' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'encap_hdr_csum' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'csum_valid' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member '__pkt_vlan_present_offset' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'vlan_present' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'csum_complete_sw' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'csum_level' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'inner_protocol_type' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'remcsum_offload' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'sender_cpu' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'reserved_tailroom' not described in 'sk_buff'
   include/linux/skbuff.h:893: warning: Function parameter or member 'inner_ipproto' not described in 'sk_buff'
   include/net/sock.h:233: warning: Function parameter or member 'skc_addrpair' not described in 'sock_common'
   include/net/sock.h:233: warning: Function parameter or member 'skc_portpair' not described in 'sock_common'
   include/net/sock.h:233: warning: Function parameter or member 'skc_ipv6only' not described in 'sock_common'
   include/net/sock.h:233: warning: Function parameter or member 'skc_net_refcnt' not described in 'sock_common'
   include/net/sock.h:233: warning: Function parameter or member 'skc_v6_daddr' not described in 'sock_common'
   include/net/sock.h:233: warning: Function parameter or member 'skc_v6_rcv_saddr' not described in 'sock_common'
   include/net/sock.h:233: warning: Function parameter or member 'skc_cookie' not described in 'sock_common'
   include/net/sock.h:233: warning: Function parameter or member 'skc_listener' not described in 'sock_common'
   include/net/sock.h:233: warning: Function parameter or member 'skc_tw_dr' not described in 'sock_common'
   include/net/sock.h:233: warning: Function parameter or member 'skc_rcv_wnd' not described in 'sock_common'
   include/net/sock.h:233: warning: Function parameter or member 'skc_tw_rcv_nxt' not described in 'sock_common'
   include/net/sock.h:515: warning: Function parameter or member 'sk_rx_skb_cache' not described in 'sock'
   include/net/sock.h:515: warning: Function parameter or member 'sk_wq_raw' not described in 'sock'
   include/net/sock.h:515: warning: Function parameter or member 'tcp_rtx_queue' not described in 'sock'
   include/net/sock.h:515: warning: Function parameter or member 'sk_tx_skb_cache' not described in 'sock'
   include/net/sock.h:515: warning: Function parameter or member 'sk_route_forced_caps' not described in 'sock'
   include/net/sock.h:515: warning: Function parameter or member 'sk_txtime_report_errors' not described in 'sock'
   include/net/sock.h:515: warning: Function parameter or member 'sk_validate_xmit_skb' not described in 'sock'
   include/net/sock.h:515: warning: Function parameter or member 'sk_bpf_storage' not described in 'sock'
   include/net/sock.h:2439: warning: Function parameter or member 'tcp_rx_skb_cache_key' not described in 'DECLARE_STATIC_KEY_FALSE'
   include/net/sock.h:2439: warning: Excess function parameter 'sk' description in 'DECLARE_STATIC_KEY_FALSE'
   include/net/sock.h:2439: warning: Excess function parameter 'skb' description in 'DECLARE_STATIC_KEY_FALSE'
   include/linux/netdevice.h:2040: warning: Function parameter or member 'gso_partial_features' not described in 'net_device'
   include/linux/netdevice.h:2040: warning: Function parameter or member 'l3mdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2040: warning: Function parameter or member 'xfrmdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2040: warning: Function parameter or member 'tlsdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2040: warning: Function parameter or member 'name_assign_type' not described in 'net_device'
   include/linux/netdevice.h:2040: warning: Function parameter or member 'ieee802154_ptr' not described in 'net_device'
   include/linux/netdevice.h:2040: warning: Function parameter or member 'mpls_ptr' not described in 'net_device'
   include/linux/netdevice.h:2040: warning: Function parameter or member 'xdp_prog' not described in 'net_device'
   include/linux/netdevice.h:2040: warning: Function parameter or member 'gro_flush_timeout' not described in 'net_device'
   include/linux/netdevice.h:2040: warning: Function parameter or member 'nf_hooks_ingress' not described in 'net_device'
   include/linux/netdevice.h:2040: warning: Function parameter or member '____cacheline_aligned_in_smp' not described in 'net_device'
   include/linux/netdevice.h:2040: warning: Function parameter or member 'qdisc_hash' not described in 'net_device'
   include/linux/netdevice.h:2040: warning: Function parameter or member 'xps_cpus_map' not described in 'net_device'
   include/linux/netdevice.h:2040: warning: Function parameter or member 'xps_rxqs_map' not described in 'net_device'
   include/linux/phylink.h:56: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising' not described in 'phylink_link_state'
   include/linux/phylink.h:56: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising' not described in 'phylink_link_state'
   drivers/net/phy/phylink.c:595: warning: Function parameter or member 'config' not described in 'phylink_create'
   drivers/net/phy/phylink.c:595: warning: Excess function parameter 'ndev' description in 'phylink_create'
   mm/util.c:1: warning: 'get_user_pages_fast' not found
   mm/slab.c:4215: warning: Function parameter or member 'objp' not described in '__ksize'
>> mm/page_alloc.c:2207: warning: Function parameter or member 'order' not described in 'free_reported_page'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:142: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_read_lock'
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
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:2822: warning: Function parameter or member 'pasid' not described in 'amdgpu_vm_make_compute'
   drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c:378: warning: Excess function parameter 'entry' description in 'amdgpu_irq_dispatch'
   drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c:379: warning: Function parameter or member 'ih' not described in 'amdgpu_irq_dispatch'
   drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c:379: warning: Excess function parameter 'entry' description in 'amdgpu_irq_dispatch'
   drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c:1: warning: no structured comments found
   drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:1: warning: no structured comments found
   drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c:1: warning: 'pp_dpm_sclk pp_dpm_mclk pp_dpm_pcie' not found
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:131: warning: Incorrect use of kernel-doc format: Documentation Makefile include scripts source @atomic_obj
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:237: warning: Incorrect use of kernel-doc format: Documentation Makefile include scripts source gpu_info FW provided soc bounding box struct or 0 if not
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:242: warning: Function parameter or member 'atomic_obj' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:242: warning: Function parameter or member 'backlight_link' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:242: warning: Function parameter or member 'backlight_caps' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:242: warning: Function parameter or member 'freesync_module' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:242: warning: Function parameter or member 'fw_dmcu' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:242: warning: Function parameter or member 'dmcu_fw_version' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:242: warning: Function parameter or member 'soc_bounding_box' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:1: warning: 'register_hpd_handlers' not found
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:1: warning: 'dm_crtc_high_irq' not found
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:1: warning: 'dm_pflip_high_irq' not found
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_pin' not described in 'drm_driver'
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_unpin' not described in 'drm_driver'
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_res_obj' not described in 'drm_driver'
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_get_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_import_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_vmap' not described in 'drm_driver'
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_vunmap' not described in 'drm_driver'
   include/drm/drm_drv.h:722: warning: Function parameter or member 'gem_prime_mmap' not described in 'drm_driver'
   include/drm/drm_modeset_helper_vtables.h:1053: warning: Function parameter or member 'prepare_writeback_job' not described in 'drm_connector_helper_funcs'
   include/drm/drm_modeset_helper_vtables.h:1053: warning: Function parameter or member 'cleanup_writeback_job' not described in 'drm_connector_helper_funcs'
   include/drm/drm_atomic_state_helper.h:1: warning: no structured comments found
   drivers/gpu/drm/mcde/mcde_drv.c:1: warning: 'ST-Ericsson MCDE DRM Driver' not found
   include/net/cfg80211.h:1092: warning: Function parameter or member 'txpwr' not described in 'station_parameters'
   include/net/mac80211.h:4043: warning: Function parameter or member 'sta_set_txpwr' not described in 'ieee80211_ops'
   include/net/mac80211.h:2006: warning: Function parameter or member 'txpwr' not described in 'ieee80211_sta'
   Documentation/admin-guide/xfs.rst:257: WARNING: Block quote ends without a blank line; unexpected unindent.
   Documentation/trace/kprobetrace.rst:99: WARNING: Explicit markup ends without a blank line; unexpected unindent.
   Documentation/translations/it_IT/process/maintainer-pgp-guide.rst:458: WARNING: Unknown target name: "nitrokey pro".
   include/uapi/linux/firewire-cdev.h:312: WARNING: Inline literal start-string without end-string.
   drivers/firewire/core-transaction.c:606: WARNING: Inline strong start-string without end-string.
   Documentation/process/embargoed-hardware-issues.rst:215: WARNING: Malformed table.
   Bottom/header table border does not match top border.

vim +2207 mm/page_alloc.c

  2195	
  2196	#ifdef CONFIG_PAGE_REPORTING
  2197	/**
  2198	 * free_reported_page - Return a now-reported page back where we got it
  2199	 * @page: Page that was reported
  2200	 *
  2201	 * This function will pull the migratetype and order information out
  2202	 * of the page and attempt to return it where it found it. If the page
  2203	 * is added to the free list without changes we will mark it as being
  2204	 * reported.
  2205	 */
  2206	void free_reported_page(struct page *page, unsigned int order)
> 2207	{
  2208		struct zone *zone = page_zone(page);
  2209		unsigned long pfn;
  2210		unsigned int mt;
  2211	
  2212		/* zone lock should be held when this function is called */
  2213		lockdep_assert_held(&zone->lock);
  2214	
  2215		pfn = page_to_pfn(page);
  2216		mt = get_pfnblock_migratetype(page, pfn);
  2217		__free_one_page(page, pfn, zone, order, mt, true);
  2218	
  2219		/*
  2220		 * If page was not comingled with another page we can consider
  2221		 * the result to be "reported" since part of the page hasn't been
  2222		 * modified, otherwise we would need to report on the new larger
  2223		 * page.
  2224		 */
  2225		if (PageBuddy(page) && page_order(page) == order)
  2226			add_page_to_reported_list(page, zone, order, mt);
  2227	}
  2228	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--zilj7cnfkx3kml4z
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
AzRH+eOAYDviJ4KUtifgaAAA

--zilj7cnfkx3kml4z--
