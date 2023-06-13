Return-Path: <netdev+bounces-10544-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40DA772EF1A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 00:20:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA9F02808FB
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 22:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83C063EDA6;
	Tue, 13 Jun 2023 22:20:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7128B3ED8C
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 22:20:33 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792AD1BE6
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 15:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686694829; x=1718230829;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Emrdgq0rg3LDJM+JZ3s4XR0fHwZQOkX9LL+ZXJ5nnXI=;
  b=Y37SOk/lVDmNs6NmgN899wczblpotUArDEkMtycNXgyUx0a/std/C1Xu
   kOBumt+zDTqbzrXNXS4Px+CFkZeCLdMdHmPvt8PpAsRK4UqIm5PPikZTW
   kSX6g+HplGL5IJVeComLhPHYYCFFRirmGOVtIX4QdaaP6vzjTME1YqGGe
   w1NfgrGOTKvDYufQ9qxRdfkIZCWqz1Kgtd7VX4amDKnHr1a+IDtKXUVtN
   fiA2AtuWv6ucPYm+estcYyGAgXIGnjHtENUAUm012rcCfE6eGQRypSHOQ
   +xtT0e+CWHuEIjE9wmZbwooX8+vanKYsK2a1sFANc6AubOfSgZggt3RbN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="424345474"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="424345474"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 15:20:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="662159191"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="662159191"
Received: from lkp-server01.sh.intel.com (HELO 211f47bdb1cb) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 13 Jun 2023 15:20:26 -0700
Received: from kbuild by 211f47bdb1cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q9CNF-0001rO-39;
	Tue, 13 Jun 2023 22:20:25 +0000
Date: Wed, 14 Jun 2023 06:19:44 +0800
From: kernel test robot <lkp@intel.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	intel-wired-lan@lists.osuosl.org
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
	fred@cloudflare.com,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH iwl-next] ice: allow hot-swapping XDP programs
Message-ID: <202306140615.m2lBEhM9-lkp@intel.com>
References: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Maciej,

kernel test robot noticed the following build errors:

[auto build test ERROR on tnguy-next-queue/dev-queue]

url:    https://github.com/intel-lab-lkp/linux/commits/Maciej-Fijalkowski/ice-allow-hot-swapping-XDP-programs/20230613-231046
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git dev-queue
patch link:    https://lore.kernel.org/r/20230613151005.337462-1-maciej.fijalkowski%40intel.com
patch subject: [PATCH iwl-next] ice: allow hot-swapping XDP programs
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230614/202306140615.m2lBEhM9-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build):
        git remote add tnguy-next-queue https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git
        git fetch tnguy-next-queue dev-queue
        git checkout tnguy-next-queue/dev-queue
        b4 shazam https://lore.kernel.org/r/20230613151005.337462-1-maciej.fijalkowski@intel.com
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306140615.m2lBEhM9-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/ethernet/intel/ice/ice_main.c: In function 'ice_xdp_setup_prog':
>> drivers/net/ethernet/intel/ice/ice_main.c:2978:12: error: invalid storage class for function 'ice_xdp_safe_mode'
    2978 | static int ice_xdp_safe_mode(struct net_device __always_unused *dev,
         |            ^~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:2978:1: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
    2978 | static int ice_xdp_safe_mode(struct net_device __always_unused *dev,
         | ^~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:2992:12: error: invalid storage class for function 'ice_xdp'
    2992 | static int ice_xdp(struct net_device *dev, struct netdev_bpf *xdp)
         |            ^~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3017:13: error: invalid storage class for function 'ice_ena_misc_vector'
    3017 | static void ice_ena_misc_vector(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3055:20: error: invalid storage class for function 'ice_misc_intr'
    3055 | static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
         |                    ^~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3188:20: error: invalid storage class for function 'ice_misc_intr_thread_fn'
    3188 | static irqreturn_t ice_misc_intr_thread_fn(int __always_unused irq, void *data)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3222:13: error: invalid storage class for function 'ice_dis_ctrlq_interrupts'
    3222 | static void ice_dis_ctrlq_interrupts(struct ice_hw *hw)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3246:13: error: invalid storage class for function 'ice_free_irq_msix_misc'
    3246 | static void ice_free_irq_msix_misc(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3268:13: error: invalid storage class for function 'ice_ena_ctrlq_interrupts'
    3268 | static void ice_ena_ctrlq_interrupts(struct ice_hw *hw, u16 reg_idx)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3302:12: error: invalid storage class for function 'ice_req_irq_msix_misc'
    3302 | static int ice_req_irq_msix_misc(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3357:13: error: invalid storage class for function 'ice_napi_add'
    3357 | static void ice_napi_add(struct ice_vsi *vsi)
         |             ^~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3373:13: error: invalid storage class for function 'ice_set_ops'
    3373 | static void ice_set_ops(struct ice_vsi *vsi)
         |             ^~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3400:13: error: invalid storage class for function 'ice_set_netdev_features'
    3400 | static void ice_set_netdev_features(struct net_device *netdev)
         |             ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3509:1: error: invalid storage class for function 'ice_pf_vsi_setup'
    3509 | ice_pf_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi)
         | ^~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3521:1: error: invalid storage class for function 'ice_chnl_vsi_setup'
    3521 | ice_chnl_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
         | ^~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3543:1: error: invalid storage class for function 'ice_ctrl_vsi_setup'
    3543 | ice_ctrl_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi)
         | ^~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3583:1: error: invalid storage class for function 'ice_vlan_rx_add_vid'
    3583 | ice_vlan_rx_add_vid(struct net_device *netdev, __be16 proto, u16 vid)
         | ^~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3646:1: error: invalid storage class for function 'ice_vlan_rx_kill_vid'
    3646 | ice_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
         | ^~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3710:13: error: invalid storage class for function 'ice_rep_indr_tc_block_unbind'
    3710 | static void ice_rep_indr_tc_block_unbind(void *cb_priv)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3722:13: error: invalid storage class for function 'ice_tc_indir_block_unregister'
    3722 | static void ice_tc_indir_block_unregister(struct ice_vsi *vsi)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:3736:12: error: invalid storage class for function 'ice_tc_indir_block_register'
    3736 | static int ice_tc_indir_block_register(struct ice_vsi *vsi)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3756:1: error: invalid storage class for function 'ice_get_avail_q_count'
    3756 | ice_get_avail_q_count(unsigned long *pf_qmap, struct mutex *lock, u16 size)
         | ^~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3793:13: error: invalid storage class for function 'ice_deinit_pf'
    3793 | static void ice_deinit_pf(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3820:13: error: invalid storage class for function 'ice_set_pf_caps'
    3820 | static void ice_set_pf_caps(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3869:12: error: invalid storage class for function 'ice_init_pf'
    3869 | static int ice_init_pf(struct ice_pf *pf)
         |            ^~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:3982:13: error: invalid storage class for function 'ice_set_safe_mode_vlan_cfg'
    3982 | static void ice_set_safe_mode_vlan_cfg(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4033:13: error: invalid storage class for function 'ice_log_pkg_init'
    4033 | static void ice_log_pkg_init(struct ice_hw *hw, enum ice_ddp_state state)
         |             ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4118:1: error: invalid storage class for function 'ice_load_pkg'
    4118 | ice_load_pkg(const struct firmware *firmware, struct ice_pf *pf)
         | ^~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4157:13: error: invalid storage class for function 'ice_verify_cacheline_size'
    4157 | static void ice_verify_cacheline_size(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4170:12: error: invalid storage class for function 'ice_send_version'
    4170 | static int ice_send_version(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4189:12: error: invalid storage class for function 'ice_init_fdir'
    4189 | static int ice_init_fdir(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4230:13: error: invalid storage class for function 'ice_deinit_fdir'
    4230 | static void ice_deinit_fdir(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4251:14: error: invalid storage class for function 'ice_get_opt_fw_name'
    4251 | static char *ice_get_opt_fw_name(struct ice_pf *pf)
         |              ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4281:13: error: invalid storage class for function 'ice_request_fw'
    4281 | static void ice_request_fw(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4322:13: error: invalid storage class for function 'ice_print_wake_reason'
    4322 | static void ice_print_wake_reason(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4349:12: error: invalid storage class for function 'ice_register_netdev'
    4349 | static int ice_register_netdev(struct ice_vsi *vsi)
         |            ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4367:13: error: invalid storage class for function 'ice_unregister_netdev'
    4367 | static void ice_unregister_netdev(struct ice_vsi *vsi)
         |             ^~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4382:12: error: invalid storage class for function 'ice_cfg_netdev'
    4382 | static int ice_cfg_netdev(struct ice_vsi *vsi)
         |            ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4417:13: error: invalid storage class for function 'ice_decfg_netdev'
    4417 | static void ice_decfg_netdev(struct ice_vsi *vsi)
         |             ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4424:12: error: invalid storage class for function 'ice_start_eth'
    4424 | static int ice_start_eth(struct ice_vsi *vsi)
         |            ^~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4439:13: error: invalid storage class for function 'ice_stop_eth'
    4439 | static void ice_stop_eth(struct ice_vsi *vsi)
         |             ^~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4445:12: error: invalid storage class for function 'ice_init_eth'
    4445 | static int ice_init_eth(struct ice_pf *pf)
         |            ^~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4494:13: error: invalid storage class for function 'ice_deinit_eth'
    4494 | static void ice_deinit_eth(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4508:12: error: invalid storage class for function 'ice_init_dev'
    4508 | static int ice_init_dev(struct ice_pf *pf)
         |            ^~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4589:13: error: invalid storage class for function 'ice_deinit_dev'
    4589 | static void ice_deinit_dev(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4601:13: error: invalid storage class for function 'ice_init_features'
    4601 | static void ice_init_features(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4631:13: error: invalid storage class for function 'ice_deinit_features'
    4631 | static void ice_deinit_features(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4643:13: error: invalid storage class for function 'ice_init_wakeup'
    4643 | static void ice_init_wakeup(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4658:12: error: invalid storage class for function 'ice_init_link'
    4658 | static int ice_init_link(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4705:12: error: invalid storage class for function 'ice_init_pf_sw'
    4705 | static int ice_init_pf_sw(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4744:13: error: invalid storage class for function 'ice_deinit_pf_sw'
    4744 | static void ice_deinit_pf_sw(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4755:12: error: invalid storage class for function 'ice_alloc_vsis'
    4755 | static int ice_alloc_vsis(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4785:13: error: invalid storage class for function 'ice_dealloc_vsis'
    4785 | static void ice_dealloc_vsis(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4795:12: error: invalid storage class for function 'ice_init_devlink'
    4795 | static int ice_init_devlink(struct ice_pf *pf)


vim +/ice_xdp_safe_mode +2978 drivers/net/ethernet/intel/ice/ice_main.c

efc2214b6047b6 Maciej Fijalkowski     2019-11-04  2972  
ebc5399ea1dfcd Maciej Fijalkowski     2021-05-20  2973  /**
ebc5399ea1dfcd Maciej Fijalkowski     2021-05-20  2974   * ice_xdp_safe_mode - XDP handler for safe mode
ebc5399ea1dfcd Maciej Fijalkowski     2021-05-20  2975   * @dev: netdevice
ebc5399ea1dfcd Maciej Fijalkowski     2021-05-20  2976   * @xdp: XDP command
ebc5399ea1dfcd Maciej Fijalkowski     2021-05-20  2977   */
ebc5399ea1dfcd Maciej Fijalkowski     2021-05-20 @2978  static int ice_xdp_safe_mode(struct net_device __always_unused *dev,
ebc5399ea1dfcd Maciej Fijalkowski     2021-05-20  2979  			     struct netdev_bpf *xdp)
ebc5399ea1dfcd Maciej Fijalkowski     2021-05-20  2980  {
ebc5399ea1dfcd Maciej Fijalkowski     2021-05-20  2981  	NL_SET_ERR_MSG_MOD(xdp->extack,
ebc5399ea1dfcd Maciej Fijalkowski     2021-05-20  2982  			   "Please provide working DDP firmware package in order to use XDP\n"
ebc5399ea1dfcd Maciej Fijalkowski     2021-05-20  2983  			   "Refer to Documentation/networking/device_drivers/ethernet/intel/ice.rst");
ebc5399ea1dfcd Maciej Fijalkowski     2021-05-20  2984  	return -EOPNOTSUPP;
ebc5399ea1dfcd Maciej Fijalkowski     2021-05-20  2985  }
ebc5399ea1dfcd Maciej Fijalkowski     2021-05-20  2986  
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  2987  /**
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  2988   * ice_xdp - implements XDP handler
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  2989   * @dev: netdevice
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  2990   * @xdp: XDP command
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  2991   */
efc2214b6047b6 Maciej Fijalkowski     2019-11-04 @2992  static int ice_xdp(struct net_device *dev, struct netdev_bpf *xdp)
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  2993  {
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  2994  	struct ice_netdev_priv *np = netdev_priv(dev);
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  2995  	struct ice_vsi *vsi = np->vsi;
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  2996  
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  2997  	if (vsi->type != ICE_VSI_PF) {
af23635a5335aa Jesse Brandeburg       2020-02-13  2998  		NL_SET_ERR_MSG_MOD(xdp->extack, "XDP can be loaded only on PF VSI");
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  2999  		return -EINVAL;
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  3000  	}
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  3001  
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  3002  	switch (xdp->command) {
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  3003  	case XDP_SETUP_PROG:
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  3004  		return ice_xdp_setup_prog(vsi, xdp->prog, xdp->extack);
1742b3d528690a Magnus Karlsson        2020-08-28  3005  	case XDP_SETUP_XSK_POOL:
1742b3d528690a Magnus Karlsson        2020-08-28  3006  		return ice_xsk_pool_setup(vsi, xdp->xsk.pool,
2d4238f5569722 Krzysztof Kazimierczak 2019-11-04  3007  					  xdp->xsk.queue_id);
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  3008  	default:
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  3009  		return -EINVAL;
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  3010  	}
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  3011  }
efc2214b6047b6 Maciej Fijalkowski     2019-11-04  3012  
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3013  /**
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3014   * ice_ena_misc_vector - enable the non-queue interrupts
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3015   * @pf: board private structure
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3016   */
940b61af02f497 Anirudh Venkataramanan 2018-03-20 @3017  static void ice_ena_misc_vector(struct ice_pf *pf)
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3018  {
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3019  	struct ice_hw *hw = &pf->hw;
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3020  	u32 val;
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3021  
9d5c5a5290d4d7 Paul Greenwalt         2020-02-13  3022  	/* Disable anti-spoof detection interrupt to prevent spurious event
9d5c5a5290d4d7 Paul Greenwalt         2020-02-13  3023  	 * interrupts during a function reset. Anti-spoof functionally is
9d5c5a5290d4d7 Paul Greenwalt         2020-02-13  3024  	 * still supported.
9d5c5a5290d4d7 Paul Greenwalt         2020-02-13  3025  	 */
9d5c5a5290d4d7 Paul Greenwalt         2020-02-13  3026  	val = rd32(hw, GL_MDCK_TX_TDPU);
9d5c5a5290d4d7 Paul Greenwalt         2020-02-13  3027  	val |= GL_MDCK_TX_TDPU_RCU_ANTISPOOF_ITR_DIS_M;
9d5c5a5290d4d7 Paul Greenwalt         2020-02-13  3028  	wr32(hw, GL_MDCK_TX_TDPU, val);
9d5c5a5290d4d7 Paul Greenwalt         2020-02-13  3029  
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3030  	/* clear things first */
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3031  	wr32(hw, PFINT_OICR_ENA, 0);	/* disable all */
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3032  	rd32(hw, PFINT_OICR);		/* read to clear */
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3033  
3bcd7fa37f33cd Bruce Allan            2018-08-09  3034  	val = (PFINT_OICR_ECC_ERR_M |
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3035  	       PFINT_OICR_MAL_DETECT_M |
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3036  	       PFINT_OICR_GRST_M |
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3037  	       PFINT_OICR_PCI_EXCEPTION_M |
007676b4ac920d Anirudh Venkataramanan 2018-09-19  3038  	       PFINT_OICR_VFLR_M |
3bcd7fa37f33cd Bruce Allan            2018-08-09  3039  	       PFINT_OICR_HMC_ERR_M |
348048e724a0e8 Dave Ertman            2021-05-20  3040  	       PFINT_OICR_PE_PUSH_M |
3bcd7fa37f33cd Bruce Allan            2018-08-09  3041  	       PFINT_OICR_PE_CRITERR_M);
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3042  
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3043  	wr32(hw, PFINT_OICR_ENA, val);
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3044  
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3045  	/* SW_ITR_IDX = 0, but don't change INTENA */
4aad5335969f25 Piotr Raczynski        2023-05-15  3046  	wr32(hw, GLINT_DYN_CTL(pf->oicr_irq.index),
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3047  	     GLINT_DYN_CTL_SW_ITR_INDX_M | GLINT_DYN_CTL_INTENA_MSK_M);
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3048  }
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3049  
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3050  /**
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3051   * ice_misc_intr - misc interrupt handler
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3052   * @irq: interrupt number
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3053   * @data: pointer to a q_vector
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3054   */
940b61af02f497 Anirudh Venkataramanan 2018-03-20 @3055  static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3056  {
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3057  	struct ice_pf *pf = (struct ice_pf *)data;
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3058  	struct ice_hw *hw = &pf->hw;
4015d11e4b9720 Brett Creeley          2019-11-08  3059  	struct device *dev;
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3060  	u32 oicr, ena_mask;
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3061  
4015d11e4b9720 Brett Creeley          2019-11-08  3062  	dev = ice_pf_to_dev(pf);
7e408e07b42dce Anirudh Venkataramanan 2021-03-02  3063  	set_bit(ICE_ADMINQ_EVENT_PENDING, pf->state);
7e408e07b42dce Anirudh Venkataramanan 2021-03-02  3064  	set_bit(ICE_MAILBOXQ_EVENT_PENDING, pf->state);
8f5ee3c477a8e4 Jacob Keller           2021-06-09  3065  	set_bit(ICE_SIDEBANDQ_EVENT_PENDING, pf->state);
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3066  
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3067  	oicr = rd32(hw, PFINT_OICR);
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3068  	ena_mask = rd32(hw, PFINT_OICR_ENA);
940b61af02f497 Anirudh Venkataramanan 2018-03-20  3069  
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  3070  	if (oicr & PFINT_OICR_SWINT_M) {
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  3071  		ena_mask &= ~PFINT_OICR_SWINT_M;
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  3072  		pf->sw_int_count++;
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  3073  	}
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  3074  
b3969fd727aa1f Sudheer Mogilappagari  2018-08-09  3075  	if (oicr & PFINT_OICR_MAL_DETECT_M) {
b3969fd727aa1f Sudheer Mogilappagari  2018-08-09  3076  		ena_mask &= ~PFINT_OICR_MAL_DETECT_M;
7e408e07b42dce Anirudh Venkataramanan 2021-03-02  3077  		set_bit(ICE_MDD_EVENT_PENDING, pf->state);
b3969fd727aa1f Sudheer Mogilappagari  2018-08-09  3078  	}
007676b4ac920d Anirudh Venkataramanan 2018-09-19  3079  	if (oicr & PFINT_OICR_VFLR_M) {
f844d5212cb020 Brett Creeley          2020-02-27  3080  		/* disable any further VFLR event notifications */
7e408e07b42dce Anirudh Venkataramanan 2021-03-02  3081  		if (test_bit(ICE_VF_RESETS_DISABLED, pf->state)) {
f844d5212cb020 Brett Creeley          2020-02-27  3082  			u32 reg = rd32(hw, PFINT_OICR_ENA);
f844d5212cb020 Brett Creeley          2020-02-27  3083  
f844d5212cb020 Brett Creeley          2020-02-27  3084  			reg &= ~PFINT_OICR_VFLR_M;
f844d5212cb020 Brett Creeley          2020-02-27  3085  			wr32(hw, PFINT_OICR_ENA, reg);
f844d5212cb020 Brett Creeley          2020-02-27  3086  		} else {
007676b4ac920d Anirudh Venkataramanan 2018-09-19  3087  			ena_mask &= ~PFINT_OICR_VFLR_M;
7e408e07b42dce Anirudh Venkataramanan 2021-03-02  3088  			set_bit(ICE_VFLR_EVENT_PENDING, pf->state);
007676b4ac920d Anirudh Venkataramanan 2018-09-19  3089  		}
f844d5212cb020 Brett Creeley          2020-02-27  3090  	}
b3969fd727aa1f Sudheer Mogilappagari  2018-08-09  3091  
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3092  	if (oicr & PFINT_OICR_GRST_M) {
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3093  		u32 reset;
b3969fd727aa1f Sudheer Mogilappagari  2018-08-09  3094  
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3095  		/* we have a reset warning */
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3096  		ena_mask &= ~PFINT_OICR_GRST_M;
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3097  		reset = (rd32(hw, GLGEN_RSTAT) & GLGEN_RSTAT_RESET_TYPE_M) >>
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3098  			GLGEN_RSTAT_RESET_TYPE_S;
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3099  
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3100  		if (reset == ICE_RESET_CORER)
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3101  			pf->corer_count++;
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3102  		else if (reset == ICE_RESET_GLOBR)
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3103  			pf->globr_count++;
ca4929b6df7c72 Brett Creeley          2018-09-19  3104  		else if (reset == ICE_RESET_EMPR)
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3105  			pf->empr_count++;
ca4929b6df7c72 Brett Creeley          2018-09-19  3106  		else
4015d11e4b9720 Brett Creeley          2019-11-08  3107  			dev_dbg(dev, "Invalid reset type %d\n", reset);
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3108  
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3109  		/* If a reset cycle isn't already in progress, we set a bit in
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3110  		 * pf->state so that the service task can start a reset/rebuild.
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3111  		 */
7e408e07b42dce Anirudh Venkataramanan 2021-03-02  3112  		if (!test_and_set_bit(ICE_RESET_OICR_RECV, pf->state)) {
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3113  			if (reset == ICE_RESET_CORER)
7e408e07b42dce Anirudh Venkataramanan 2021-03-02  3114  				set_bit(ICE_CORER_RECV, pf->state);
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3115  			else if (reset == ICE_RESET_GLOBR)
7e408e07b42dce Anirudh Venkataramanan 2021-03-02  3116  				set_bit(ICE_GLOBR_RECV, pf->state);
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3117  			else
7e408e07b42dce Anirudh Venkataramanan 2021-03-02  3118  				set_bit(ICE_EMPR_RECV, pf->state);
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3119  
fd2a981777d911 Anirudh Venkataramanan 2018-08-09  3120  			/* There are couple of different bits at play here.
fd2a981777d911 Anirudh Venkataramanan 2018-08-09  3121  			 * hw->reset_ongoing indicates whether the hardware is
fd2a981777d911 Anirudh Venkataramanan 2018-08-09  3122  			 * in reset. This is set to true when a reset interrupt
fd2a981777d911 Anirudh Venkataramanan 2018-08-09  3123  			 * is received and set back to false after the driver
fd2a981777d911 Anirudh Venkataramanan 2018-08-09  3124  			 * has determined that the hardware is out of reset.
fd2a981777d911 Anirudh Venkataramanan 2018-08-09  3125  			 *
7e408e07b42dce Anirudh Venkataramanan 2021-03-02  3126  			 * ICE_RESET_OICR_RECV in pf->state indicates
fd2a981777d911 Anirudh Venkataramanan 2018-08-09  3127  			 * that a post reset rebuild is required before the
fd2a981777d911 Anirudh Venkataramanan 2018-08-09  3128  			 * driver is operational again. This is set above.
fd2a981777d911 Anirudh Venkataramanan 2018-08-09  3129  			 *
fd2a981777d911 Anirudh Venkataramanan 2018-08-09  3130  			 * As this is the start of the reset/rebuild cycle, set
fd2a981777d911 Anirudh Venkataramanan 2018-08-09  3131  			 * both to indicate that.
fd2a981777d911 Anirudh Venkataramanan 2018-08-09  3132  			 */
fd2a981777d911 Anirudh Venkataramanan 2018-08-09  3133  			hw->reset_ongoing = true;
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3134  		}
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3135  	}
0b28b702e72a6f Anirudh Venkataramanan 2018-03-20  3136  
ea9b847cda647b Jacob Keller           2021-06-09  3137  	if (oicr & PFINT_OICR_TSYN_TX_M) {
ea9b847cda647b Jacob Keller           2021-06-09  3138  		ena_mask &= ~PFINT_OICR_TSYN_TX_M;
d578e618f192f4 Karol Kolacinski       2023-06-01  3139  		if (!hw->reset_ongoing)
6e8b2c88fc8cf9 Karol Kolacinski       2023-06-01  3140  			set_bit(ICE_MISC_THREAD_TX_TSTAMP, pf->misc_thread);
6e8b2c88fc8cf9 Karol Kolacinski       2023-06-01  3141  	}
ea9b847cda647b Jacob Keller           2021-06-09  3142  
172db5f91d5f7b Maciej Machnikowski    2021-06-16  3143  	if (oicr & PFINT_OICR_TSYN_EVNT_M) {
172db5f91d5f7b Maciej Machnikowski    2021-06-16  3144  		u8 tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
172db5f91d5f7b Maciej Machnikowski    2021-06-16  3145  		u32 gltsyn_stat = rd32(hw, GLTSYN_STAT(tmr_idx));
172db5f91d5f7b Maciej Machnikowski    2021-06-16  3146  
6e8b2c88fc8cf9 Karol Kolacinski       2023-06-01  3147  		ena_mask &= ~PFINT_OICR_TSYN_EVNT_M;
6e8b2c88fc8cf9 Karol Kolacinski       2023-06-01  3148  
6e8b2c88fc8cf9 Karol Kolacinski       2023-06-01  3149  		if (hw->func_caps.ts_func_info.src_tmr_owned) {
6e8b2c88fc8cf9 Karol Kolacinski       2023-06-01  3150  			/* Save EVENTs from GLTSYN register */
6e8b2c88fc8cf9 Karol Kolacinski       2023-06-01  3151  			pf->ptp.ext_ts_irq |= gltsyn_stat &
6e8b2c88fc8cf9 Karol Kolacinski       2023-06-01  3152  					      (GLTSYN_STAT_EVENT0_M |
172db5f91d5f7b Maciej Machnikowski    2021-06-16  3153  					       GLTSYN_STAT_EVENT1_M |
172db5f91d5f7b Maciej Machnikowski    2021-06-16  3154  					       GLTSYN_STAT_EVENT2_M);
6e8b2c88fc8cf9 Karol Kolacinski       2023-06-01  3155  
6e8b2c88fc8cf9 Karol Kolacinski       2023-06-01  3156  			set_bit(ICE_MISC_THREAD_EXTTS_EVENT, pf->misc_thread);
6e8b2c88fc8cf9 Karol Kolacinski       2023-06-01  3157  		}
172db5f91d5f7b Maciej Machnikowski    2021-06-16  3158  	}
172db5f91d5f7b Maciej Machnikowski    2021-06-16  3159  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

