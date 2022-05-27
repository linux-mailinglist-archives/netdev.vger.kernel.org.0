Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F2C535ABC
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348043AbiE0Hz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347762AbiE0HzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:55:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBA3FC4D5
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 00:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653638122; x=1685174122;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6BP8alYMTBAjhSCGeih2Vc7RPzbBW1ws24N0kOFDGgc=;
  b=asdKP1VUzDRqGBtadHqm4sNXsyeBWDp+RZQctEzhZO+oEpIP7zTV3RR5
   vQVLOvWsK64lxQtgRpZ1WxZTkbw8FmkBtH3Enni4/jDZo3w+6dYb//pbT
   uwfTRkQf7zO/mi4j5RR4mEChGkqrcudInucUywtpPsg44JR0zcxLcZb95
   O8XFb8ENRIghje1SCxAb5AUvwlSCKuPKWtbhYmQow/uRxWSqY2rdI7tqe
   iBQgsXhnXotps5WUdi0G3m89GW55AC6wDLbhdektN/bJG9zhgpHwxd39q
   RQQFl3zzesFfwcgV3SrFz+dOVW9sDfkpazlMQPq7Ms4ad1ekgPCkjpC5O
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="274514276"
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="274514276"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 00:55:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="527915256"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 27 May 2022 00:55:20 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nuUoZ-0004XS-Tc;
        Fri, 27 May 2022 07:55:19 +0000
Date:   Fri, 27 May 2022 15:54:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: Re: [PATCH net-next v3] net: txgbe: Add build support for txgbe
Message-ID: <202205271506.b3ILwQFq-lkp@intel.com>
References: <20220527063157.486686-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527063157.486686-1-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiawen,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawen-Wu/net-txgbe-Add-build-support-for-txgbe/20220527-143401
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 7e062cda7d90543ac8c7700fc7c5527d0c0f22ad
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220527/202205271506.b3ILwQFq-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/b2d691a438052d44a1ec82c4b9e23ecf5514a579
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiawen-Wu/net-txgbe-Add-build-support-for-txgbe/20220527-143401
        git checkout b2d691a438052d44a1ec82c4b9e23ecf5514a579
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash drivers/net/ethernet/wangxun/txgbe/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c: In function 'txgbe_probe':
>> drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:93:26: warning: variable 'hw' set but not used [-Wunused-but-set-variable]
      93 |         struct txgbe_hw *hw = NULL;
         |                          ^~


vim +/hw +93 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c

    77	
    78	/**
    79	 * txgbe_probe - Device Initialization Routine
    80	 * @pdev: PCI device information struct
    81	 * @ent: entry in txgbe_pci_tbl
    82	 *
    83	 * Returns 0 on success, negative on failure
    84	 *
    85	 * txgbe_probe initializes an adapter identified by a pci_dev structure.
    86	 * The OS initialization, configuring of the adapter private structure,
    87	 * and a hardware reset occur.
    88	 **/
    89	static int txgbe_probe(struct pci_dev *pdev,
    90			       const struct pci_device_id __always_unused *ent)
    91	{
    92		struct txgbe_adapter *adapter = NULL;
  > 93		struct txgbe_hw *hw = NULL;
    94		struct net_device *netdev;
    95		int err, pci_using_dac;
    96	
    97		err = pci_enable_device_mem(pdev);
    98		if (err)
    99			return err;
   100	
   101		if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)) &&
   102		    !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
   103			pci_using_dac = 1;
   104		} else {
   105			err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
   106			if (err) {
   107				err = dma_set_coherent_mask(&pdev->dev,
   108							    DMA_BIT_MASK(32));
   109				if (err) {
   110					dev_err(&pdev->dev,
   111						"No usable DMA configuration, aborting\n");
   112					goto err_dma;
   113				}
   114			}
   115			pci_using_dac = 0;
   116		}
   117	
   118		err = pci_request_selected_regions(pdev,
   119						   pci_select_bars(pdev, IORESOURCE_MEM),
   120						   txgbe_driver_name);
   121		if (err) {
   122			dev_err(&pdev->dev,
   123				"pci_request_selected_regions failed 0x%x\n", err);
   124			goto err_pci_reg;
   125		}
   126	
   127		pci_enable_pcie_error_reporting(pdev);
   128		pci_set_master(pdev);
   129		/* errata 16 */
   130		pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
   131						   PCI_EXP_DEVCTL_READRQ,
   132						   0x1000);
   133	
   134		netdev = devm_alloc_etherdev_mqs(&pdev->dev,
   135						 sizeof(struct txgbe_adapter),
   136						 TXGBE_MAX_TX_QUEUES,
   137						 TXGBE_MAX_RX_QUEUES);
   138		if (!netdev) {
   139			err = -ENOMEM;
   140			goto err_alloc_etherdev;
   141		}
   142	
   143		SET_NETDEV_DEV(netdev, &pdev->dev);
   144	
   145		adapter = netdev_priv(netdev);
   146		adapter->netdev = netdev;
   147		adapter->pdev = pdev;
   148		hw = &adapter->hw;
   149	
   150		adapter->io_addr = devm_ioremap(&pdev->dev,
   151						pci_resource_start(pdev, 0),
   152						pci_resource_len(pdev, 0));
   153		if (!adapter->io_addr) {
   154			err = -EIO;
   155			goto err_ioremap;
   156		}
   157	
   158		/* setup the private structure */
   159		err = txgbe_sw_init(adapter);
   160		if (err)
   161			goto err_sw_init;
   162	
   163		if (pci_using_dac)
   164			netdev->features |= NETIF_F_HIGHDMA;
   165	
   166		pci_set_drvdata(pdev, adapter);
   167	
   168		return 0;
   169	
   170	err_sw_init:
   171		devm_iounmap(&pdev->dev, adapter->io_addr);
   172	err_ioremap:
   173	err_alloc_etherdev:
   174		pci_release_selected_regions(pdev,
   175					     pci_select_bars(pdev, IORESOURCE_MEM));
   176	err_pci_reg:
   177	err_dma:
   178		pci_disable_device(pdev);
   179		return err;
   180	}
   181	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
