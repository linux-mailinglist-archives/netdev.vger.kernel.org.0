Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471115244C2
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 07:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349501AbiELFQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 01:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349490AbiELFQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 01:16:41 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABF21FCC0
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 22:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652332599; x=1683868599;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Cu222JPcutWUglrp4QqmdELzi4FjMw/DwJoWUn+mHAU=;
  b=DwKdWaaxg2RLyKQAmPR8USq9CJLIQezJJEFR1TR5S4LXE9H6A9ZyOp3/
   dYZ+fOhkkz4XOC7FHN5dVIIt9zIYopKZ1xisiQ2JSDHXxXc+eb6JtbY1/
   lM1rfVTGERYl4X4Gt9RzddVrK+0nDblo0jFzquR4fu/NAfuZeGebHAGKE
   UHdp9FmmOMtogA1uq5ETtE/5CpDb28exymP3sG1VcNC8d36fYipbxwAtB
   lEEL3GicOWstrnS8sD4TQ2w/0efBXY/uRVJd7hTxdOZoZMfiHoiNelShr
   44Tx7ARQmSTyHq+cuAoyjdyDzLHo2q0iSCEPrKm8YdZt/NNarUx0D79If
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="257441356"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="257441356"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 22:16:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="542613854"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 11 May 2022 22:16:34 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1np1Bi-000Jxw-2t;
        Thu, 12 May 2022 05:16:34 +0000
Date:   Thu, 12 May 2022 13:15:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: Re: [PATCH net-next 02/14] net: txgbe: Add hardware initialization
Message-ID: <202205121354.BKT9ZuVB-lkp@intel.com>
References: <20220511032659.641834-3-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511032659.641834-3-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiawen,

I love your patch! Perhaps something to improve:

[auto build test WARNING on horms-ipvs/master]
[cannot apply to net-next/master net/master linus/master v5.18-rc6 next-20220511]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawen-Wu/Wangxun-10-Gigabit-Ethernet-Driver/20220511-113032
base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220512/202205121354.BKT9ZuVB-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f33cce2ea458796311d5925beaf78c01546f36ce
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiawen-Wu/Wangxun-10-Gigabit-Ethernet-Driver/20220511-113032
        git checkout f33cce2ea458796311d5925beaf78c01546f36ce
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:98:6: warning: no previous prototype for 'txgbe_service_event_schedule' [-Wmissing-prototypes]
      98 | void txgbe_service_event_schedule(struct txgbe_adapter *adapter)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:178:6: warning: no previous prototype for 'txgbe_reset' [-Wmissing-prototypes]
     178 | void txgbe_reset(struct txgbe_adapter *adapter)
         |      ^~~~~~~~~~~
>> drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:208:6: warning: no previous prototype for 'txgbe_disable_device' [-Wmissing-prototypes]
     208 | void txgbe_disable_device(struct txgbe_adapter *adapter)
         |      ^~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:264:5: warning: no previous prototype for 'txgbe_init_shared_code' [-Wmissing-prototypes]
     264 | s32 txgbe_init_shared_code(struct txgbe_hw *hw)
         |     ^~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c: In function 'txgbe_probe':
   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:460:18: warning: variable 'pci_using_dac' set but not used [-Wunused-but-set-variable]
     460 |         int err, pci_using_dac, expected_gts;
         |                  ^~~~~~~~~~~~~
--
   drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c:205: warning: Function parameter or member 'pools' not described in 'txgbe_set_rar'
   drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c:205: warning: Excess function parameter 'vmdq' description in 'txgbe_set_rar'
>> drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c:444: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    *  This function should only be involved in the IOV mode.


vim +/txgbe_disable_device +208 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c

    97	
  > 98	void txgbe_service_event_schedule(struct txgbe_adapter *adapter)
    99	{
   100		if (!test_bit(__TXGBE_DOWN, &adapter->state) &&
   101		    !test_bit(__TXGBE_REMOVING, &adapter->state) &&
   102		    !test_and_set_bit(__TXGBE_SERVICE_SCHED, &adapter->state))
   103			queue_work(txgbe_wq, &adapter->service_task);
   104	}
   105	
   106	static void txgbe_service_event_complete(struct txgbe_adapter *adapter)
   107	{
   108		BUG_ON(!test_bit(__TXGBE_SERVICE_SCHED, &adapter->state));
   109	
   110		/* flush memory to make sure state is correct before next watchdog */
   111		smp_mb__before_atomic();
   112		clear_bit(__TXGBE_SERVICE_SCHED, &adapter->state);
   113	}
   114	
   115	static void txgbe_remove_adapter(struct txgbe_hw *hw)
   116	{
   117		struct txgbe_adapter *adapter = hw->back;
   118	
   119		if (!hw->hw_addr)
   120			return;
   121		hw->hw_addr = NULL;
   122		txgbe_dev_err("Adapter removed\n");
   123		if (test_bit(__TXGBE_SERVICE_INITED, &adapter->state))
   124			txgbe_service_event_schedule(adapter);
   125	}
   126	
   127	static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
   128	{
   129		struct txgbe_hw *hw = &adapter->hw;
   130		int i;
   131	
   132		for (i = 0; i < hw->mac.num_rar_entries; i++) {
   133			if (adapter->mac_table[i].state & TXGBE_MAC_STATE_MODIFIED) {
   134				if (adapter->mac_table[i].state &
   135						TXGBE_MAC_STATE_IN_USE) {
   136					TCALL(hw, mac.ops.set_rar, i,
   137					      adapter->mac_table[i].addr,
   138					      adapter->mac_table[i].pools,
   139					      TXGBE_PSR_MAC_SWC_AD_H_AV);
   140				} else {
   141					TCALL(hw, mac.ops.clear_rar, i);
   142				}
   143				adapter->mac_table[i].state &=
   144					~(TXGBE_MAC_STATE_MODIFIED);
   145			}
   146		}
   147	}
   148	
   149	/* this function destroys the first RAR entry */
   150	static void txgbe_mac_set_default_filter(struct txgbe_adapter *adapter,
   151						 u8 *addr)
   152	{
   153		struct txgbe_hw *hw = &adapter->hw;
   154	
   155		memcpy(&adapter->mac_table[0].addr, addr, ETH_ALEN);
   156		adapter->mac_table[0].pools = 1ULL;
   157		adapter->mac_table[0].state = (TXGBE_MAC_STATE_DEFAULT |
   158					       TXGBE_MAC_STATE_IN_USE);
   159		TCALL(hw, mac.ops.set_rar, 0, adapter->mac_table[0].addr,
   160		      adapter->mac_table[0].pools,
   161		      TXGBE_PSR_MAC_SWC_AD_H_AV);
   162	}
   163	
   164	static void txgbe_flush_sw_mac_table(struct txgbe_adapter *adapter)
   165	{
   166		u32 i;
   167		struct txgbe_hw *hw = &adapter->hw;
   168	
   169		for (i = 0; i < hw->mac.num_rar_entries; i++) {
   170			adapter->mac_table[i].state |= TXGBE_MAC_STATE_MODIFIED;
   171			adapter->mac_table[i].state &= ~TXGBE_MAC_STATE_IN_USE;
   172			memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
   173			adapter->mac_table[i].pools = 0;
   174		}
   175		txgbe_sync_mac_table(adapter);
   176	}
   177	
   178	void txgbe_reset(struct txgbe_adapter *adapter)
   179	{
   180		struct txgbe_hw *hw = &adapter->hw;
   181		struct net_device *netdev = adapter->netdev;
   182		int err;
   183		u8 old_addr[ETH_ALEN];
   184	
   185		if (TXGBE_REMOVED(hw->hw_addr))
   186			return;
   187	
   188		err = TCALL(hw, mac.ops.init_hw);
   189		switch (err) {
   190		case 0:
   191			break;
   192		case TXGBE_ERR_MASTER_REQUESTS_PENDING:
   193			txgbe_dev_err("master disable timed out\n");
   194			break;
   195		default:
   196			txgbe_dev_err("Hardware Error: %d\n", err);
   197		}
   198	
   199		/* do not flush user set addresses */
   200		memcpy(old_addr, &adapter->mac_table[0].addr, netdev->addr_len);
   201		txgbe_flush_sw_mac_table(adapter);
   202		txgbe_mac_set_default_filter(adapter, old_addr);
   203	
   204		/* update SAN MAC vmdq pool selection */
   205		TCALL(hw, mac.ops.set_vmdq_san_mac, 0);
   206	}
   207	
 > 208	void txgbe_disable_device(struct txgbe_adapter *adapter)
   209	{
   210		struct net_device *netdev = adapter->netdev;
   211		struct txgbe_hw *hw = &adapter->hw;
   212		u32 i;
   213	
   214		/* signal that we are down to the interrupt handler */
   215		if (test_and_set_bit(__TXGBE_DOWN, &adapter->state))
   216			return; /* do nothing if already down */
   217	
   218		txgbe_disable_pcie_master(hw);
   219		/* disable receives */
   220		TCALL(hw, mac.ops.disable_rx);
   221	
   222		/* call carrier off first to avoid false dev_watchdog timeouts */
   223		netif_carrier_off(netdev);
   224		netif_tx_disable(netdev);
   225	
   226		del_timer_sync(&adapter->service_timer);
   227	
   228		if (hw->bus.lan_id == 0)
   229			wr32m(hw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN0_UP, 0);
   230		else if (hw->bus.lan_id == 1)
   231			wr32m(hw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN1_UP, 0);
   232		else
   233			txgbe_dev_err("%s: invalid bus lan id %d\n", __func__,
   234				      hw->bus.lan_id);
   235	
   236		if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP) ||
   237		      ((hw->subsystem_device_id & TXGBE_WOL_MASK) == TXGBE_WOL_SUP))) {
   238			/* disable mac transmiter */
   239			wr32m(hw, TXGBE_MAC_TX_CFG, TXGBE_MAC_TX_CFG_TE, 0);
   240		}
   241		/* disable transmits in the hardware now that interrupts are off */
   242		for (i = 0; i < adapter->num_tx_queues; i++) {
   243			u8 reg_idx = adapter->tx_ring[i]->reg_idx;
   244	
   245			wr32(hw, TXGBE_PX_TR_CFG(reg_idx), TXGBE_PX_TR_CFG_SWFLSH);
   246		}
   247	
   248		/* Disable the Tx DMA engine */
   249		wr32m(hw, TXGBE_TDM_CTL, TXGBE_TDM_CTL_TE, 0);
   250	}
   251	
   252	void txgbe_down(struct txgbe_adapter *adapter)
   253	{
   254		txgbe_disable_device(adapter);
   255		txgbe_reset(adapter);
   256	}
   257	
   258	/**
   259	 *  txgbe_init_shared_code - Initialize the shared code
   260	 *  @hw: pointer to hardware structure
   261	 *
   262	 *  This will assign function pointers and assign the MAC type and PHY code.
   263	 **/
 > 264	s32 txgbe_init_shared_code(struct txgbe_hw *hw)
   265	{
   266		s32 status;
   267	
   268		status = txgbe_init_ops(hw);
   269		return status;
   270	}
   271	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
