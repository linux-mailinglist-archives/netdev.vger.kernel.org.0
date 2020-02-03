Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8898150F49
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbgBCSWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:22:54 -0500
Received: from mga12.intel.com ([192.55.52.136]:51323 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgBCSWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 13:22:54 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 10:22:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="gz'50?scan'50,208,50";a="234780825"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 03 Feb 2020 10:22:46 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iygMv-0000x1-Jn; Tue, 04 Feb 2020 02:22:45 +0800
Date:   Tue, 4 Feb 2020 02:21:46 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Calvin Johnson <calvin.johnson@nxp.com>
Cc:     kbuild-all@lists.01.org, linux.cj@gmail.com,
        Jon Nettleton <jon@solid-run.com>, linux@armlinux.org.uk,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1 6/7] net: phylink: Introduce
 phylink_fwnode_phy_connect()
Message-ID: <202002040222.w3eEuGSb%lkp@intel.com>
References: <20200131153440.20870-7-calvin.johnson@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yoamwpbwbfmr2fk7"
Content-Disposition: inline
In-Reply-To: <20200131153440.20870-7-calvin.johnson@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yoamwpbwbfmr2fk7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Calvin,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on v5.5]
[cannot apply to driver-core/driver-core-testing net-next/master net/master linus/master sparc-next/master next-20200203]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Calvin-Johnson/ACPI-support-for-xgmac_mdio-and-dpaa2-mac-drivers/20200203-070754
base:    d5226fa6dbae0569ee43ecfc08bdcd6770fc4755
reproduce: make htmldocs

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   Warning: The Sphinx 'sphinx_rtd_theme' HTML theme was not found. Make sure you have the theme installed to produce pretty HTML output. Falling back to the default theme.
   WARNING: dot(1) not found, for better output quality install graphviz from http://www.graphviz.org
   WARNING: convert(1) not found, for SVG to PDF conversion install ImageMagick (https://www.imagemagick.org)
   include/linux/spi/spi.h:207: warning: Function parameter or member 'driver_override' not described in 'spi_device'
   include/linux/spi/spi.h:650: warning: Function parameter or member 'irq_flags' not described in 'spi_controller'
   drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c:1: warning: no structured comments found
   drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:1: warning: no structured comments found
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:254: warning: Function parameter or member 'hdcp_workqueue' not described in 'amdgpu_display_manager'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'quotactl' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'quota_on' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'sb_free_mnt_opts' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'sb_eat_lsm_opts' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'sb_kern_mount' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'sb_show_options' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'sb_add_mnt_opt' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'd_instantiate' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'getprocattr' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'setprocattr' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'locked_down' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'perf_event_open' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'perf_event_alloc' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'perf_event_free' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'perf_event_read' not described in 'security_list_options'
   include/linux/lsm_hooks.h:1830: warning: Function parameter or member 'perf_event_write' not described in 'security_list_options'
   drivers/usb/typec/bus.c:1: warning: 'typec_altmode_register_driver' not found
   drivers/usb/typec/bus.c:1: warning: 'typec_altmode_unregister_driver' not found
   drivers/usb/typec/class.c:1: warning: 'typec_altmode_register_notifier' not found
   drivers/usb/typec/class.c:1: warning: 'typec_altmode_unregister_notifier' not found
   include/linux/regulator/machine.h:196: warning: Function parameter or member 'max_uV_step' not described in 'regulation_constraints'
   include/linux/regulator/driver.h:223: warning: Function parameter or member 'resume' not described in 'regulator_ops'
   sound/soc/soc-core.c:2522: warning: Function parameter or member 'legacy_dai_naming' not described in 'snd_soc_register_dai'
   include/linux/skbuff.h:888: warning: Function parameter or member 'dev_scratch' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'list' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'ip_defrag_offset' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'skb_mstamp_ns' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member '__cloned_offset' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'head_frag' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member '__pkt_type_offset' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'encapsulation' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'encap_hdr_csum' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'csum_valid' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member '__pkt_vlan_present_offset' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'vlan_present' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'csum_complete_sw' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'csum_level' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'inner_protocol_type' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'remcsum_offload' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'sender_cpu' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'reserved_tailroom' not described in 'sk_buff'
   include/linux/skbuff.h:888: warning: Function parameter or member 'inner_ipproto' not described in 'sk_buff'
   include/net/sock.h:232: warning: Function parameter or member 'skc_addrpair' not described in 'sock_common'
   include/net/sock.h:232: warning: Function parameter or member 'skc_portpair' not described in 'sock_common'
   include/net/sock.h:232: warning: Function parameter or member 'skc_ipv6only' not described in 'sock_common'
   include/net/sock.h:232: warning: Function parameter or member 'skc_net_refcnt' not described in 'sock_common'
   include/net/sock.h:232: warning: Function parameter or member 'skc_v6_daddr' not described in 'sock_common'
   include/net/sock.h:232: warning: Function parameter or member 'skc_v6_rcv_saddr' not described in 'sock_common'
   include/net/sock.h:232: warning: Function parameter or member 'skc_cookie' not described in 'sock_common'
   include/net/sock.h:232: warning: Function parameter or member 'skc_listener' not described in 'sock_common'
   include/net/sock.h:232: warning: Function parameter or member 'skc_tw_dr' not described in 'sock_common'
   include/net/sock.h:232: warning: Function parameter or member 'skc_rcv_wnd' not described in 'sock_common'
   include/net/sock.h:232: warning: Function parameter or member 'skc_tw_rcv_nxt' not described in 'sock_common'
   include/net/sock.h:514: warning: Function parameter or member 'sk_rx_skb_cache' not described in 'sock'
   include/net/sock.h:514: warning: Function parameter or member 'sk_wq_raw' not described in 'sock'
   include/net/sock.h:514: warning: Function parameter or member 'tcp_rtx_queue' not described in 'sock'
   include/net/sock.h:514: warning: Function parameter or member 'sk_tx_skb_cache' not described in 'sock'
   include/net/sock.h:514: warning: Function parameter or member 'sk_route_forced_caps' not described in 'sock'
   include/net/sock.h:514: warning: Function parameter or member 'sk_txtime_report_errors' not described in 'sock'
   include/net/sock.h:514: warning: Function parameter or member 'sk_validate_xmit_skb' not described in 'sock'
   include/net/sock.h:514: warning: Function parameter or member 'sk_bpf_storage' not described in 'sock'
   include/net/sock.h:2459: warning: Function parameter or member 'tcp_rx_skb_cache_key' not described in 'DECLARE_STATIC_KEY_FALSE'
   include/net/sock.h:2459: warning: Excess function parameter 'sk' description in 'DECLARE_STATIC_KEY_FALSE'
   include/net/sock.h:2459: warning: Excess function parameter 'skb' description in 'DECLARE_STATIC_KEY_FALSE'
   net/core/skbuff.c:5489: warning: Function parameter or member 'ethernet' not described in 'skb_mpls_push'
   include/linux/netdevice.h:2082: warning: Function parameter or member 'gso_partial_features' not described in 'net_device'
   include/linux/netdevice.h:2082: warning: Function parameter or member 'l3mdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2082: warning: Function parameter or member 'xfrmdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2082: warning: Function parameter or member 'tlsdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2082: warning: Function parameter or member 'name_assign_type' not described in 'net_device'
   include/linux/netdevice.h:2082: warning: Function parameter or member 'ieee802154_ptr' not described in 'net_device'
   include/linux/netdevice.h:2082: warning: Function parameter or member 'mpls_ptr' not described in 'net_device'
   include/linux/netdevice.h:2082: warning: Function parameter or member 'xdp_prog' not described in 'net_device'
   include/linux/netdevice.h:2082: warning: Function parameter or member 'gro_flush_timeout' not described in 'net_device'
   include/linux/netdevice.h:2082: warning: Function parameter or member 'nf_hooks_ingress' not described in 'net_device'
   include/linux/netdevice.h:2082: warning: Function parameter or member 'qdisc_hash' not described in 'net_device'
   include/linux/netdevice.h:2082: warning: Function parameter or member 'xps_cpus_map' not described in 'net_device'
   include/linux/netdevice.h:2082: warning: Function parameter or member 'xps_rxqs_map' not described in 'net_device'
   drivers/net/phy/mdio_bus.c:861: warning: Function parameter or member 'child' not described in 'fwnode_mdiobus_child_is_phy'
   include/linux/phylink.h:56: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising' not described in 'phylink_link_state'
   include/linux/phylink.h:56: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising' not described in 'phylink_link_state'
>> drivers/net/phy/phylink.c:836: warning: Function parameter or member 'fwnode' not described in 'phylink_fwnode_phy_connect'
   drivers/net/phy/phylink.c:836: warning: Excess function parameter 'dn' description in 'phylink_fwnode_phy_connect'
   drivers/infiniband/core/umem_odp.c:167: warning: Function parameter or member 'ops' not described in 'ib_umem_odp_alloc_child'
   drivers/infiniband/core/umem_odp.c:217: warning: Function parameter or member 'ops' not described in 'ib_umem_odp_get'
   drivers/infiniband/ulp/iser/iscsi_iser.h:401: warning: Function parameter or member 'all_list' not described in 'iser_fr_desc'
   drivers/infiniband/ulp/iser/iscsi_iser.h:415: warning: Function parameter or member 'all_list' not described in 'iser_fr_pool'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:148: warning: Function parameter or member 'rsvd0' not described in 'opa_vesw_info'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:148: warning: Function parameter or member 'rsvd1' not described in 'opa_vesw_info'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:148: warning: Function parameter or member 'rsvd2' not described in 'opa_vesw_info'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:148: warning: Function parameter or member 'rsvd3' not described in 'opa_vesw_info'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:148: warning: Function parameter or member 'rsvd4' not described in 'opa_vesw_info'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:205: warning: Function parameter or member 'rsvd0' not described in 'opa_per_veswport_info'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:205: warning: Function parameter or member 'rsvd1' not described in 'opa_per_veswport_info'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:205: warning: Function parameter or member 'rsvd2' not described in 'opa_per_veswport_info'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:205: warning: Function parameter or member 'rsvd3' not described in 'opa_per_veswport_info'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:263: warning: Function parameter or member 'tbl_entries' not described in 'opa_veswport_mactable'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:342: warning: Function parameter or member 'reserved' not described in 'opa_veswport_summary_counters'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: Function parameter or member 'rsvd0' not described in 'opa_veswport_error_counters'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: Function parameter or member 'rsvd1' not described in 'opa_veswport_error_counters'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: Function parameter or member 'rsvd2' not described in 'opa_veswport_error_counters'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: Function parameter or member 'rsvd3' not described in 'opa_veswport_error_counters'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: Function parameter or member 'rsvd4' not described in 'opa_veswport_error_counters'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: Function parameter or member 'rsvd5' not described in 'opa_veswport_error_counters'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: Function parameter or member 'rsvd6' not described in 'opa_veswport_error_counters'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: Function parameter or member 'rsvd7' not described in 'opa_veswport_error_counters'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: Function parameter or member 'rsvd8' not described in 'opa_veswport_error_counters'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: Function parameter or member 'rsvd9' not described in 'opa_veswport_error_counters'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:460: warning: Function parameter or member 'reserved' not described in 'opa_vnic_vema_mad'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:485: warning: Function parameter or member 'reserved' not described in 'opa_vnic_notice_attr'
   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:500: warning: Function parameter or member 'reserved' not described in 'opa_vnic_vema_mad_trap'
   include/linux/input/sparse-keymap.h:43: warning: Function parameter or member 'sw' not described in 'key_entry'
   include/drm/drm_modeset_helper_vtables.h:1052: warning: Function parameter or member 'prepare_writeback_job' not described in 'drm_connector_helper_funcs'
   include/drm/drm_modeset_helper_vtables.h:1052: warning: Function parameter or member 'cleanup_writeback_job' not described in 'drm_connector_helper_funcs'
   include/net/cfg80211.h:1189: warning: Function parameter or member 'txpwr' not described in 'station_parameters'
   include/net/mac80211.h:4081: warning: Function parameter or member 'sta_set_txpwr' not described in 'ieee80211_ops'
   include/net/mac80211.h:2036: warning: Function parameter or member 'txpwr' not described in 'ieee80211_sta'
   include/linux/devfreq.h:187: warning: Function parameter or member 'last_status' not described in 'devfreq'
   drivers/devfreq/devfreq.c:1818: warning: bad line: - Resource-managed devfreq_register_notifier()
   drivers/devfreq/devfreq.c:1854: warning: bad line: - Resource-managed devfreq_unregister_notifier()
   drivers/devfreq/devfreq-event.c:355: warning: Function parameter or member 'edev' not described in 'devfreq_event_remove_edev'
   drivers/devfreq/devfreq-event.c:355: warning: Excess function parameter 'dev' description in 'devfreq_event_remove_edev'
   Documentation/admin-guide/hw-vuln/tsx_async_abort.rst:142: WARNING: duplicate label virt_mechanism, other instance in Documentation/admin-guide/hw-vuln/mds.rst
   Documentation/admin-guide/ras.rst:358: WARNING: Definition list ends without a blank line; unexpected unindent.
   Documentation/admin-guide/ras.rst:358: WARNING: Definition list ends without a blank line; unexpected unindent.
   Documentation/admin-guide/ras.rst:363: WARNING: Definition list ends without a blank line; unexpected unindent.
   Documentation/admin-guide/ras.rst:363: WARNING: Definition list ends without a blank line; unexpected unindent.
   Documentation/driver-api/driver-model/driver.rst:215: WARNING: Inline emphasis start-string without end-string.
   Documentation/driver-api/driver-model/driver.rst:215: WARNING: Inline emphasis start-string without end-string.
   include/uapi/linux/firewire-cdev.h:312: WARNING: Inline literal start-string without end-string.
   drivers/firewire/core-transaction.c:606: WARNING: Inline strong start-string without end-string.
   Documentation/x86/boot.rst:72: WARNING: Malformed table.
   Text in column margin in table line 57.

vim +836 drivers/net/phy/phylink.c

   820	
   821	/**
   822	 * phylink_fwnode_phy_connect() - connect the PHY specified in the fwnode.
   823	 * @pl: a pointer to a &struct phylink returned from phylink_create()
   824	 * @dn: a pointer to a &struct device_node.
   825	 * @flags: PHY-specific flags to communicate to the PHY device driver
   826	 *
   827	 * Connect the phy specified in the device node @dn to the phylink instance
   828	 * specified by @pl. Actions specified in phylink_connect_phy() will be
   829	 * performed.
   830	 *
   831	 * Returns 0 on success or a negative errno.
   832	 */
   833	int phylink_fwnode_phy_connect(struct phylink *pl,
   834				       struct fwnode_handle *fwnode,
   835				       u32 flags)
 > 836	{
   837		struct fwnode_handle *phy_node;
   838		struct phy_device *phy_dev;
   839		int ret;
   840		int status;
   841		struct fwnode_reference_args args;
   842	
   843		/* Fixed links and 802.3z are handled without needing a PHY */
   844		if (pl->link_an_mode == MLO_AN_FIXED ||
   845		    (pl->link_an_mode == MLO_AN_INBAND &&
   846		     phy_interface_mode_is_8023z(pl->link_interface)))
   847			return 0;
   848	
   849		status = acpi_node_get_property_reference(fwnode, "phy-handle", 0,
   850							  &args);
   851		if (ACPI_FAILURE(status) || !is_acpi_device_node(args.fwnode))
   852			status = acpi_node_get_property_reference(fwnode, "phy", 0,
   853								  &args);
   854		if (ACPI_FAILURE(status) || !is_acpi_device_node(args.fwnode))
   855			status = acpi_node_get_property_reference(fwnode,
   856								  "phy-device", 0,
   857								  &args);
   858	
   859		if (ACPI_FAILURE(status) || !is_acpi_device_node(args.fwnode)) {
   860			if (pl->link_an_mode == MLO_AN_PHY)
   861				return -ENODEV;
   862			return 0;
   863		}
   864	
   865		phy_dev = fwnode_phy_find_device(args.fwnode);
   866		if (phy_dev)
   867			phy_attach_direct(pl->netdev, phy_dev, flags,
   868					  pl->link_interface);
   869	
   870		/* refcount is held by phy_attach_direct() on success */
   871		put_device(&phy_dev->mdio.dev);
   872	
   873		if (!phy_dev)
   874			return -ENODEV;
   875	
   876		ret = phylink_bringup_phy(pl, phy_dev);
   877		if (ret)
   878			phy_detach(phy_dev);
   879	
   880		return ret;
   881	}
   882	EXPORT_SYMBOL_GPL(phylink_fwnode_phy_connect);
   883	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--yoamwpbwbfmr2fk7
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--yoamwpbwbfmr2fk7--
