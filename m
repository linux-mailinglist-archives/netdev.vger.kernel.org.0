Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C571523474
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243948AbiEKNjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237276AbiEKNjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:39:52 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FCD1C197D
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 06:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652276390; x=1683812390;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cai6Koo2OeZXscp6wACE8a5n1gMQEPNR4S4FEPkVqi8=;
  b=kUnuwW2xSKVI4RFNViCTnEW1URA4JIUiErYuoUnFNEllEcQTqq8EEvAI
   7h5YX8CjJDc/iTm3f22JtnBrMkgOBCRY5U6VGlSFUrbpi2fwI7qaIUVNV
   TTI+ie3hQurH5/TijxHgJ6dxR7f3Niasoc/jCy88ySzr6E5hV4YkMuw/B
   o/L27tYUou1hsrg6ckk4CPex1HklRdfHE9fGT1ypqywsWcl825THn/Sud
   /v26v0imZs0Y+9NLjJj9Jy9nj96F/WSjLPkTxFbirBvo2hNGg7bLmZFOl
   /5CZvCzGD/JSDU3fvTr341QNbsqtt4gHcNuyJwTVL1rdCgdOEIDYc2lB2
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="294940806"
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="294940806"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 06:39:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="602942377"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 11 May 2022 06:39:47 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nomZ8-000J9O-RN;
        Wed, 11 May 2022 13:39:46 +0000
Date:   Wed, 11 May 2022 21:39:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     lixue liang <lianglixue@greatwall.com.cn>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        lixue liang <lianglixue@greatwall.com.cn>
Subject: Re: [PATCH] =?utf-8?B?aWdiX21haW7vvJpBZGRl?= =?utf-8?Q?d?= invalid
 mac address handling in igb_probe
Message-ID: <202205112101.xfpSlc0Z-lkp@intel.com>
References: <20220511080716.10054-1-lianglixue@greatwall.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511080716.10054-1-lianglixue@greatwall.com.cn>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi lixue,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on tnguy-next-queue/dev-queue]
[also build test ERROR on v5.18-rc6 next-20220511]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/lixue-liang/igb_main-Added-invalid-mac-address-handling-in-igb_probe/20220511-162855
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git dev-queue
config: arm-socfpga_defconfig (https://download.01.org/0day-ci/archive/20220511/202205112101.xfpSlc0Z-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 18dd123c56754edf62c7042dcf23185c3727610f)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/intel-lab-lkp/linux/commit/6237ad497b2c8063fe59ba165d5ab87ae15aad0d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review lixue-liang/igb_main-Added-invalid-mac-address-handling-in-igb_probe/20220511-162855
        git checkout 6237ad497b2c8063fe59ba165d5ab87ae15aad0d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/net/ethernet/intel/igb/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/intel/igb/igb_main.c:3362:19: error: passing 'const unsigned char *' to parameter of type 'u8 *' (aka 'unsigned char *') discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
                   eth_random_addr(netdev->dev_addr);
                                   ^~~~~~~~~~~~~~~~
   include/linux/etherdevice.h:230:40: note: passing argument to parameter 'addr' here
   static inline void eth_random_addr(u8 *addr)
                                          ^
   1 error generated.


vim +3362 drivers/net/ethernet/intel/igb/igb_main.c

  3146	
  3147	/**
  3148	 *  igb_probe - Device Initialization Routine
  3149	 *  @pdev: PCI device information struct
  3150	 *  @ent: entry in igb_pci_tbl
  3151	 *
  3152	 *  Returns 0 on success, negative on failure
  3153	 *
  3154	 *  igb_probe initializes an adapter identified by a pci_dev structure.
  3155	 *  The OS initialization, configuring of the adapter private structure,
  3156	 *  and a hardware reset occur.
  3157	 **/
  3158	static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  3159	{
  3160		struct net_device *netdev;
  3161		struct igb_adapter *adapter;
  3162		struct e1000_hw *hw;
  3163		u16 eeprom_data = 0;
  3164		s32 ret_val;
  3165		static int global_quad_port_a; /* global quad port a indication */
  3166		const struct e1000_info *ei = igb_info_tbl[ent->driver_data];
  3167		u8 part_str[E1000_PBANUM_LENGTH];
  3168		int err;
  3169	
  3170		/* Catch broken hardware that put the wrong VF device ID in
  3171		 * the PCIe SR-IOV capability.
  3172		 */
  3173		if (pdev->is_virtfn) {
  3174			WARN(1, KERN_ERR "%s (%x:%x) should not be a VF!\n",
  3175				pci_name(pdev), pdev->vendor, pdev->device);
  3176			return -EINVAL;
  3177		}
  3178	
  3179		err = pci_enable_device_mem(pdev);
  3180		if (err)
  3181			return err;
  3182	
  3183		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
  3184		if (err) {
  3185			dev_err(&pdev->dev,
  3186				"No usable DMA configuration, aborting\n");
  3187			goto err_dma;
  3188		}
  3189	
  3190		err = pci_request_mem_regions(pdev, igb_driver_name);
  3191		if (err)
  3192			goto err_pci_reg;
  3193	
  3194		pci_enable_pcie_error_reporting(pdev);
  3195	
  3196		pci_set_master(pdev);
  3197		pci_save_state(pdev);
  3198	
  3199		err = -ENOMEM;
  3200		netdev = alloc_etherdev_mq(sizeof(struct igb_adapter),
  3201					   IGB_MAX_TX_QUEUES);
  3202		if (!netdev)
  3203			goto err_alloc_etherdev;
  3204	
  3205		SET_NETDEV_DEV(netdev, &pdev->dev);
  3206	
  3207		pci_set_drvdata(pdev, netdev);
  3208		adapter = netdev_priv(netdev);
  3209		adapter->netdev = netdev;
  3210		adapter->pdev = pdev;
  3211		hw = &adapter->hw;
  3212		hw->back = adapter;
  3213		adapter->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
  3214	
  3215		err = -EIO;
  3216		adapter->io_addr = pci_iomap(pdev, 0, 0);
  3217		if (!adapter->io_addr)
  3218			goto err_ioremap;
  3219		/* hw->hw_addr can be altered, we'll use adapter->io_addr for unmap */
  3220		hw->hw_addr = adapter->io_addr;
  3221	
  3222		netdev->netdev_ops = &igb_netdev_ops;
  3223		igb_set_ethtool_ops(netdev);
  3224		netdev->watchdog_timeo = 5 * HZ;
  3225	
  3226		strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
  3227	
  3228		netdev->mem_start = pci_resource_start(pdev, 0);
  3229		netdev->mem_end = pci_resource_end(pdev, 0);
  3230	
  3231		/* PCI config space info */
  3232		hw->vendor_id = pdev->vendor;
  3233		hw->device_id = pdev->device;
  3234		hw->revision_id = pdev->revision;
  3235		hw->subsystem_vendor_id = pdev->subsystem_vendor;
  3236		hw->subsystem_device_id = pdev->subsystem_device;
  3237	
  3238		/* Copy the default MAC, PHY and NVM function pointers */
  3239		memcpy(&hw->mac.ops, ei->mac_ops, sizeof(hw->mac.ops));
  3240		memcpy(&hw->phy.ops, ei->phy_ops, sizeof(hw->phy.ops));
  3241		memcpy(&hw->nvm.ops, ei->nvm_ops, sizeof(hw->nvm.ops));
  3242		/* Initialize skew-specific constants */
  3243		err = ei->get_invariants(hw);
  3244		if (err)
  3245			goto err_sw_init;
  3246	
  3247		/* setup the private structure */
  3248		err = igb_sw_init(adapter);
  3249		if (err)
  3250			goto err_sw_init;
  3251	
  3252		igb_get_bus_info_pcie(hw);
  3253	
  3254		hw->phy.autoneg_wait_to_complete = false;
  3255	
  3256		/* Copper options */
  3257		if (hw->phy.media_type == e1000_media_type_copper) {
  3258			hw->phy.mdix = AUTO_ALL_MODES;
  3259			hw->phy.disable_polarity_correction = false;
  3260			hw->phy.ms_type = e1000_ms_hw_default;
  3261		}
  3262	
  3263		if (igb_check_reset_block(hw))
  3264			dev_info(&pdev->dev,
  3265				"PHY reset is blocked due to SOL/IDER session.\n");
  3266	
  3267		/* features is initialized to 0 in allocation, it might have bits
  3268		 * set by igb_sw_init so we should use an or instead of an
  3269		 * assignment.
  3270		 */
  3271		netdev->features |= NETIF_F_SG |
  3272				    NETIF_F_TSO |
  3273				    NETIF_F_TSO6 |
  3274				    NETIF_F_RXHASH |
  3275				    NETIF_F_RXCSUM |
  3276				    NETIF_F_HW_CSUM;
  3277	
  3278		if (hw->mac.type >= e1000_82576)
  3279			netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
  3280	
  3281		if (hw->mac.type >= e1000_i350)
  3282			netdev->features |= NETIF_F_HW_TC;
  3283	
  3284	#define IGB_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
  3285					  NETIF_F_GSO_GRE_CSUM | \
  3286					  NETIF_F_GSO_IPXIP4 | \
  3287					  NETIF_F_GSO_IPXIP6 | \
  3288					  NETIF_F_GSO_UDP_TUNNEL | \
  3289					  NETIF_F_GSO_UDP_TUNNEL_CSUM)
  3290	
  3291		netdev->gso_partial_features = IGB_GSO_PARTIAL_FEATURES;
  3292		netdev->features |= NETIF_F_GSO_PARTIAL | IGB_GSO_PARTIAL_FEATURES;
  3293	
  3294		/* copy netdev features into list of user selectable features */
  3295		netdev->hw_features |= netdev->features |
  3296				       NETIF_F_HW_VLAN_CTAG_RX |
  3297				       NETIF_F_HW_VLAN_CTAG_TX |
  3298				       NETIF_F_RXALL;
  3299	
  3300		if (hw->mac.type >= e1000_i350)
  3301			netdev->hw_features |= NETIF_F_NTUPLE;
  3302	
  3303		netdev->features |= NETIF_F_HIGHDMA;
  3304	
  3305		netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
  3306		netdev->mpls_features |= NETIF_F_HW_CSUM;
  3307		netdev->hw_enc_features |= netdev->vlan_features;
  3308	
  3309		/* set this bit last since it cannot be part of vlan_features */
  3310		netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
  3311				    NETIF_F_HW_VLAN_CTAG_RX |
  3312				    NETIF_F_HW_VLAN_CTAG_TX;
  3313	
  3314		netdev->priv_flags |= IFF_SUPP_NOFCS;
  3315	
  3316		netdev->priv_flags |= IFF_UNICAST_FLT;
  3317	
  3318		/* MTU range: 68 - 9216 */
  3319		netdev->min_mtu = ETH_MIN_MTU;
  3320		netdev->max_mtu = MAX_STD_JUMBO_FRAME_SIZE;
  3321	
  3322		adapter->en_mng_pt = igb_enable_mng_pass_thru(hw);
  3323	
  3324		/* before reading the NVM, reset the controller to put the device in a
  3325		 * known good starting state
  3326		 */
  3327		hw->mac.ops.reset_hw(hw);
  3328	
  3329		/* make sure the NVM is good , i211/i210 parts can have special NVM
  3330		 * that doesn't contain a checksum
  3331		 */
  3332		switch (hw->mac.type) {
  3333		case e1000_i210:
  3334		case e1000_i211:
  3335			if (igb_get_flash_presence_i210(hw)) {
  3336				if (hw->nvm.ops.validate(hw) < 0) {
  3337					dev_err(&pdev->dev,
  3338						"The NVM Checksum Is Not Valid\n");
  3339					err = -EIO;
  3340					goto err_eeprom;
  3341				}
  3342			}
  3343			break;
  3344		default:
  3345			if (hw->nvm.ops.validate(hw) < 0) {
  3346				dev_err(&pdev->dev, "The NVM Checksum Is Not Valid\n");
  3347				err = -EIO;
  3348				goto err_eeprom;
  3349			}
  3350			break;
  3351		}
  3352	
  3353		if (eth_platform_get_mac_address(&pdev->dev, hw->mac.addr)) {
  3354			/* copy the MAC address out of the NVM */
  3355			if (hw->mac.ops.read_mac_addr(hw))
  3356				dev_err(&pdev->dev, "NVM Read Error\n");
  3357		}
  3358	
  3359		eth_hw_addr_set(netdev, hw->mac.addr);
  3360	
  3361		if (!is_valid_ether_addr(netdev->dev_addr)) {
> 3362			eth_random_addr(netdev->dev_addr);
  3363			memcpy(hw->mac.addr, netdev->dev_addr, netdev->addr_len);
  3364			dev_info(&pdev->dev,
  3365				 "Invalid Mac Address, already got random Mac Address\n");
  3366		}
  3367	
  3368		igb_set_default_mac_filter(adapter);
  3369	
  3370		/* get firmware version for ethtool -i */
  3371		igb_set_fw_version(adapter);
  3372	
  3373		/* configure RXPBSIZE and TXPBSIZE */
  3374		if (hw->mac.type == e1000_i210) {
  3375			wr32(E1000_RXPBS, I210_RXPBSIZE_DEFAULT);
  3376			wr32(E1000_TXPBS, I210_TXPBSIZE_DEFAULT);
  3377		}
  3378	
  3379		timer_setup(&adapter->watchdog_timer, igb_watchdog, 0);
  3380		timer_setup(&adapter->phy_info_timer, igb_update_phy_info, 0);
  3381	
  3382		INIT_WORK(&adapter->reset_task, igb_reset_task);
  3383		INIT_WORK(&adapter->watchdog_task, igb_watchdog_task);
  3384	
  3385		/* Initialize link properties that are user-changeable */
  3386		adapter->fc_autoneg = true;
  3387		hw->mac.autoneg = true;
  3388		hw->phy.autoneg_advertised = 0x2f;
  3389	
  3390		hw->fc.requested_mode = e1000_fc_default;
  3391		hw->fc.current_mode = e1000_fc_default;
  3392	
  3393		igb_validate_mdi_setting(hw);
  3394	
  3395		/* By default, support wake on port A */
  3396		if (hw->bus.func == 0)
  3397			adapter->flags |= IGB_FLAG_WOL_SUPPORTED;
  3398	
  3399		/* Check the NVM for wake support on non-port A ports */
  3400		if (hw->mac.type >= e1000_82580)
  3401			hw->nvm.ops.read(hw, NVM_INIT_CONTROL3_PORT_A +
  3402					 NVM_82580_LAN_FUNC_OFFSET(hw->bus.func), 1,
  3403					 &eeprom_data);
  3404		else if (hw->bus.func == 1)
  3405			hw->nvm.ops.read(hw, NVM_INIT_CONTROL3_PORT_B, 1, &eeprom_data);
  3406	
  3407		if (eeprom_data & IGB_EEPROM_APME)
  3408			adapter->flags |= IGB_FLAG_WOL_SUPPORTED;
  3409	
  3410		/* now that we have the eeprom settings, apply the special cases where
  3411		 * the eeprom may be wrong or the board simply won't support wake on
  3412		 * lan on a particular port
  3413		 */
  3414		switch (pdev->device) {
  3415		case E1000_DEV_ID_82575GB_QUAD_COPPER:
  3416			adapter->flags &= ~IGB_FLAG_WOL_SUPPORTED;
  3417			break;
  3418		case E1000_DEV_ID_82575EB_FIBER_SERDES:
  3419		case E1000_DEV_ID_82576_FIBER:
  3420		case E1000_DEV_ID_82576_SERDES:
  3421			/* Wake events only supported on port A for dual fiber
  3422			 * regardless of eeprom setting
  3423			 */
  3424			if (rd32(E1000_STATUS) & E1000_STATUS_FUNC_1)
  3425				adapter->flags &= ~IGB_FLAG_WOL_SUPPORTED;
  3426			break;
  3427		case E1000_DEV_ID_82576_QUAD_COPPER:
  3428		case E1000_DEV_ID_82576_QUAD_COPPER_ET2:
  3429			/* if quad port adapter, disable WoL on all but port A */
  3430			if (global_quad_port_a != 0)
  3431				adapter->flags &= ~IGB_FLAG_WOL_SUPPORTED;
  3432			else
  3433				adapter->flags |= IGB_FLAG_QUAD_PORT_A;
  3434			/* Reset for multiple quad port adapters */
  3435			if (++global_quad_port_a == 4)
  3436				global_quad_port_a = 0;
  3437			break;
  3438		default:
  3439			/* If the device can't wake, don't set software support */
  3440			if (!device_can_wakeup(&adapter->pdev->dev))
  3441				adapter->flags &= ~IGB_FLAG_WOL_SUPPORTED;
  3442		}
  3443	
  3444		/* initialize the wol settings based on the eeprom settings */
  3445		if (adapter->flags & IGB_FLAG_WOL_SUPPORTED)
  3446			adapter->wol |= E1000_WUFC_MAG;
  3447	
  3448		/* Some vendors want WoL disabled by default, but still supported */
  3449		if ((hw->mac.type == e1000_i350) &&
  3450		    (pdev->subsystem_vendor == PCI_VENDOR_ID_HP)) {
  3451			adapter->flags |= IGB_FLAG_WOL_SUPPORTED;
  3452			adapter->wol = 0;
  3453		}
  3454	
  3455		/* Some vendors want the ability to Use the EEPROM setting as
  3456		 * enable/disable only, and not for capability
  3457		 */
  3458		if (((hw->mac.type == e1000_i350) ||
  3459		     (hw->mac.type == e1000_i354)) &&
  3460		    (pdev->subsystem_vendor == PCI_VENDOR_ID_DELL)) {
  3461			adapter->flags |= IGB_FLAG_WOL_SUPPORTED;
  3462			adapter->wol = 0;
  3463		}
  3464		if (hw->mac.type == e1000_i350) {
  3465			if (((pdev->subsystem_device == 0x5001) ||
  3466			     (pdev->subsystem_device == 0x5002)) &&
  3467					(hw->bus.func == 0)) {
  3468				adapter->flags |= IGB_FLAG_WOL_SUPPORTED;
  3469				adapter->wol = 0;
  3470			}
  3471			if (pdev->subsystem_device == 0x1F52)
  3472				adapter->flags |= IGB_FLAG_WOL_SUPPORTED;
  3473		}
  3474	
  3475		device_set_wakeup_enable(&adapter->pdev->dev,
  3476					 adapter->flags & IGB_FLAG_WOL_SUPPORTED);
  3477	
  3478		/* reset the hardware with the new settings */
  3479		igb_reset(adapter);
  3480	
  3481		/* Init the I2C interface */
  3482		err = igb_init_i2c(adapter);
  3483		if (err) {
  3484			dev_err(&pdev->dev, "failed to init i2c interface\n");
  3485			goto err_eeprom;
  3486		}
  3487	
  3488		/* let the f/w know that the h/w is now under the control of the
  3489		 * driver.
  3490		 */
  3491		igb_get_hw_control(adapter);
  3492	
  3493		strcpy(netdev->name, "eth%d");
  3494		err = register_netdev(netdev);
  3495		if (err)
  3496			goto err_register;
  3497	
  3498		/* carrier off reporting is important to ethtool even BEFORE open */
  3499		netif_carrier_off(netdev);
  3500	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
