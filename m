Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BE952AD86
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 23:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiEQV3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 17:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiEQV3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 17:29:07 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78C151E55
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652822943; x=1684358943;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v5M/4UQbts2J4rbUsLFg6NKTq7DpwnwFGVXShtEK3R0=;
  b=n1Kk4akqKXXD+JQe17MtywhbgU+w3Vs1BLvKuWMDW37T0z3Zd2qq2Rsd
   HWrqSwGRspY+YiOOzljYM6zENMOnhOZUzD+9nT177ExGDGAzlprF9SGeX
   UJfU6ep7qV2EDAp3GOl50tEWmnXpARz/uuxHV5Ess+QG7IzG/5g3HeE7j
   iqGFlfjDYV1cO/FepkG3t8xdzbdCjeanrUNii3HhOi6AyAjAvEDmj5Trj
   uTPCL7vFn2fa77qugzHphbmEKxzC37SWQSWB5Xsok1QdAMx881eGucFrR
   zbndyIXHc71UDjZ2eNyoto/i9RAYK+WE8aKmTztn1FCLdbV5I7o4RARdq
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="270166077"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="270166077"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 14:29:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="555973394"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 17 May 2022 14:29:01 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nr4kW-0001Rc-Sy;
        Tue, 17 May 2022 21:29:00 +0000
Date:   Wed, 18 May 2022 05:28:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: Re: [PATCH net-next v2] net: txgbe: Add build support for txgbe
Message-ID: <202205180531.6Hzhl9KN-lkp@intel.com>
References: <20220517092109.8161-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517092109.8161-1-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiawen,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawen-Wu/net-txgbe-Add-build-support-for-txgbe/20220517-171540
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 6251264fedde83ade6f0f1f7049037469dd4de0b
config: mips-allmodconfig (https://download.01.org/0day-ci/archive/20220518/202205180531.6Hzhl9KN-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/bbd3d7eec488dc00f9b366f24e12bcb793cdd0bc
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiawen-Wu/net-txgbe-Add-build-support-for-txgbe/20220517-171540
        git checkout bbd3d7eec488dc00f9b366f24e12bcb793cdd0bc
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash drivers/net/ethernet/wangxun/txgbe/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c: In function 'txgbe_probe':
>> drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:171:14: error: implicit declaration of function 'vmalloc'; did you mean 'kvmalloc'? [-Werror=implicit-function-declaration]
     171 |         hw = vmalloc(sizeof(*hw));
         |              ^~~~~~~
         |              kvmalloc
>> drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:171:12: warning: assignment to 'struct txgbe_hw *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     171 |         hw = vmalloc(sizeof(*hw));
         |            ^
>> drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:177:9: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
     177 |         vfree(hw);
         |         ^~~~~
         |         kvfree
   cc1: some warnings being treated as errors


vim +171 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c

   119	
   120	/**
   121	 * txgbe_probe - Device Initialization Routine
   122	 * @pdev: PCI device information struct
   123	 * @ent: entry in txgbe_pci_tbl
   124	 *
   125	 * Returns 0 on success, negative on failure
   126	 *
   127	 * txgbe_probe initializes an adapter identified by a pci_dev structure.
   128	 * The OS initialization, configuring of the adapter private structure,
   129	 * and a hardware reset occur.
   130	 **/
   131	static int txgbe_probe(struct pci_dev *pdev,
   132			       const struct pci_device_id __always_unused *ent)
   133	{
   134		struct net_device *netdev;
   135		struct txgbe_adapter *adapter = NULL;
   136		struct txgbe_hw *hw = NULL;
   137		int err, pci_using_dac;
   138		unsigned int indices = MAX_TX_QUEUES;
   139		bool disable_dev = false;
   140	
   141		err = pci_enable_device_mem(pdev);
   142		if (err)
   143			return err;
   144	
   145		if (!dma_set_mask(pci_dev_to_dev(pdev), DMA_BIT_MASK(64)) &&
   146		    !dma_set_coherent_mask(pci_dev_to_dev(pdev), DMA_BIT_MASK(64))) {
   147			pci_using_dac = 1;
   148		} else {
   149			err = dma_set_mask(pci_dev_to_dev(pdev), DMA_BIT_MASK(32));
   150			if (err) {
   151				err = dma_set_coherent_mask(pci_dev_to_dev(pdev),
   152							    DMA_BIT_MASK(32));
   153				if (err) {
   154					dev_err(pci_dev_to_dev(pdev),
   155						"No usable DMA configuration, aborting\n");
   156					goto err_dma;
   157				}
   158			}
   159			pci_using_dac = 0;
   160		}
   161	
   162		err = pci_request_selected_regions(pdev,
   163						   pci_select_bars(pdev, IORESOURCE_MEM),
   164						   txgbe_driver_name);
   165		if (err) {
   166			dev_err(pci_dev_to_dev(pdev),
   167				"pci_request_selected_regions failed 0x%x\n", err);
   168			goto err_pci_reg;
   169		}
   170	
 > 171		hw = vmalloc(sizeof(*hw));
   172		if (!hw)
   173			return -ENOMEM;
   174	
   175		hw->vendor_id = pdev->vendor;
   176		hw->device_id = pdev->device;
 > 177		vfree(hw);
   178	
   179		pci_enable_pcie_error_reporting(pdev);
   180		pci_set_master(pdev);
   181		/* errata 16 */
   182		if (MAX_REQUEST_SIZE == 512) {
   183			pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
   184							   PCI_EXP_DEVCTL_READRQ,
   185							   0x2000);
   186		} else {
   187			pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
   188							   PCI_EXP_DEVCTL_READRQ,
   189							   0x1000);
   190		}
   191	
   192		netdev = alloc_etherdev_mq(sizeof(struct txgbe_adapter), indices);
   193		if (!netdev) {
   194			err = -ENOMEM;
   195			goto err_alloc_etherdev;
   196		}
   197	
   198		SET_NETDEV_DEV(netdev, pci_dev_to_dev(pdev));
   199	
   200		adapter = netdev_priv(netdev);
   201		adapter->netdev = netdev;
   202		adapter->pdev = pdev;
   203		hw = &adapter->hw;
   204		hw->back = adapter;
   205		adapter->msg_enable = (1 << DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
   206	
   207		hw->hw_addr = ioremap(pci_resource_start(pdev, 0),
   208				      pci_resource_len(pdev, 0));
   209		adapter->io_addr = hw->hw_addr;
   210		if (!hw->hw_addr) {
   211			err = -EIO;
   212			goto err_ioremap;
   213		}
   214	
   215		strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
   216	
   217		/* setup the private structure */
   218		err = txgbe_sw_init(adapter);
   219		if (err)
   220			goto err_sw_init;
   221	
   222		if (pci_using_dac)
   223			netdev->features |= NETIF_F_HIGHDMA;
   224	
   225	err_sw_init:
   226		iounmap(adapter->io_addr);
   227	err_ioremap:
   228		disable_dev = !test_and_set_bit(__TXGBE_DISABLED, &adapter->state);
   229		free_netdev(netdev);
   230	err_alloc_etherdev:
   231		pci_release_selected_regions(pdev,
   232					     pci_select_bars(pdev, IORESOURCE_MEM));
   233	err_pci_reg:
   234	err_dma:
   235		if (!adapter || disable_dev)
   236			pci_disable_device(pdev);
   237		return err;
   238	}
   239	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
