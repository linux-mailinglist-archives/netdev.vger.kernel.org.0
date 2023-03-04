Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7B46AAA74
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 15:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjCDOeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 09:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCDOeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 09:34:03 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4578D4EF1
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 06:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677940439; x=1709476439;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qn9XLmmbBZgRIDTnrbrgrbSleKelw/x5svL1EAo9rTA=;
  b=URENzbRMYfZHcSv0wOgiQGpyYIUZoyqygerlWNoNIQjNAiWlcpc6/BoG
   RnPut3bHLcQiaP4kvcNbAglexxy10Iv5a0TxyDetQxraJ+1uzDRYZdmZ2
   RQV5J6AB6iE5duscYjAGxWcb/o+Z9/ynHE6f71vh+j7QVc4faDr3XhrTU
   d5YBgfdQ9BP5edbupXX6kaQq6BbNP/475GwVmoWZsNP2mHPRWRUnLnhk6
   R6HO5UmyObuTj0qPqXbTeUleQNStj139bgtO50d58WqKmGUQPL8HUzXiT
   lXMKYqyQcZAudnPmHO6RRHLeXtI1VM8lVzDywyiVqPbuqyDbn/ArkX25i
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10639"; a="319089964"
X-IronPort-AV: E=Sophos;i="5.98,233,1673942400"; 
   d="scan'208";a="319089964"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2023 06:33:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10639"; a="849799420"
X-IronPort-AV: E=Sophos;i="5.98,233,1673942400"; 
   d="scan'208";a="849799420"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 04 Mar 2023 06:33:55 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pYSxO-0002DT-36;
        Sat, 04 Mar 2023 14:33:54 +0000
Date:   Sat, 4 Mar 2023 22:33:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, khc@pm.waw.pl,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3] netdevice: use ifmap instead of plain fields
Message-ID: <202303042238.bQFk2Esl-lkp@intel.com>
References: <20230304115626.215026-1-vincenzopalazzodev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230304115626.215026-1-vincenzopalazzodev@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincenzo,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vincenzo-Palazzo/netdevice-use-ifmap-instead-of-plain-fields/20230304-195731
patch link:    https://lore.kernel.org/r/20230304115626.215026-1-vincenzopalazzodev%40gmail.com
patch subject: [PATCH v3] netdevice: use ifmap instead of plain fields
config: arm64-randconfig-r026-20230302 (https://download.01.org/0day-ci/archive/20230304/202303042238.bQFk2Esl-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/89e04810927e646944e5cdd83fb9bb5a41cc5a3d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vincenzo-Palazzo/netdevice-use-ifmap-instead-of-plain-fields/20230304-195731
        git checkout 89e04810927e646944e5cdd83fb9bb5a41cc5a3d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/net/arcnet/ drivers/net/can/cc770/ drivers/net/can/sja1000/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303042238.bQFk2Esl-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/arcnet/com20020-pci.c:199:8: error: no member named 'base_addr' in 'struct net_device'
                   dev->base_addr = ioaddr;
                   ~~~  ^
   1 error generated.
--
>> drivers/net/can/cc770/cc770_isa.c:204:8: error: no member named 'base_addr' in 'struct net_device'
                   dev->base_addr = mem[idx];
                   ~~~  ^
   drivers/net/can/cc770/cc770_isa.c:209:8: error: no member named 'base_addr' in 'struct net_device'
                   dev->base_addr = port[idx];
                   ~~~  ^
   2 errors generated.
--
>> drivers/net/can/sja1000/sja1000_isa.c:159:8: error: no member named 'base_addr' in 'struct net_device'
                   dev->base_addr = mem[idx];
                   ~~~  ^
   drivers/net/can/sja1000/sja1000_isa.c:164:8: error: no member named 'base_addr' in 'struct net_device'
                   dev->base_addr = port[idx];
                   ~~~  ^
   2 errors generated.


vim +199 drivers/net/arcnet/com20020-pci.c

c51da42a6346c0 Michael Grzeschik  2014-09-29  118  
d6d7d3ed56e3bf Joe Perches        2015-05-05  119  static int com20020pci_probe(struct pci_dev *pdev,
d6d7d3ed56e3bf Joe Perches        2015-05-05  120  			     const struct pci_device_id *id)
^1da177e4c3f41 Linus Torvalds     2005-04-16  121  {
8c14f9c70327a6 Michael Grzeschik  2014-09-29  122  	struct com20020_pci_card_info *ci;
5ef216c1f84825 Michael Grzeschik  2014-09-18  123  	struct com20020_pci_channel_map *mm;
^1da177e4c3f41 Linus Torvalds     2005-04-16  124  	struct net_device *dev;
^1da177e4c3f41 Linus Torvalds     2005-04-16  125  	struct arcnet_local *lp;
c51da42a6346c0 Michael Grzeschik  2014-09-29  126  	struct com20020_priv *priv;
c51da42a6346c0 Michael Grzeschik  2014-09-29  127  	int i, ioaddr, ret;
c51da42a6346c0 Michael Grzeschik  2014-09-29  128  	struct resource *r;
^1da177e4c3f41 Linus Torvalds     2005-04-16  129  
6577b9a551aedb Tong Zhang         2021-03-14  130  	ret = 0;
6577b9a551aedb Tong Zhang         2021-03-14  131  
^1da177e4c3f41 Linus Torvalds     2005-04-16  132  	if (pci_enable_device(pdev))
^1da177e4c3f41 Linus Torvalds     2005-04-16  133  		return -EIO;
c51da42a6346c0 Michael Grzeschik  2014-09-29  134  
c51da42a6346c0 Michael Grzeschik  2014-09-29  135  	priv = devm_kzalloc(&pdev->dev, sizeof(struct com20020_priv),
c51da42a6346c0 Michael Grzeschik  2014-09-29  136  			    GFP_KERNEL);
e8a308affcd79d Kiran Padwal       2015-02-05  137  	if (!priv)
e8a308affcd79d Kiran Padwal       2015-02-05  138  		return -ENOMEM;
e8a308affcd79d Kiran Padwal       2015-02-05  139  
c51da42a6346c0 Michael Grzeschik  2014-09-29  140  	ci = (struct com20020_pci_card_info *)id->driver_data;
bd6f1fd5d33dfe Zheyu Ma           2022-03-02  141  	if (!ci)
bd6f1fd5d33dfe Zheyu Ma           2022-03-02  142  		return -EINVAL;
bd6f1fd5d33dfe Zheyu Ma           2022-03-02  143  
c51da42a6346c0 Michael Grzeschik  2014-09-29  144  	priv->ci = ci;
5ef216c1f84825 Michael Grzeschik  2014-09-18  145  	mm = &ci->misc_map;
c51da42a6346c0 Michael Grzeschik  2014-09-29  146  
6577b9a551aedb Tong Zhang         2021-03-14  147  	pci_set_drvdata(pdev, priv);
6577b9a551aedb Tong Zhang         2021-03-14  148  
c51da42a6346c0 Michael Grzeschik  2014-09-29  149  	INIT_LIST_HEAD(&priv->list_dev);
c51da42a6346c0 Michael Grzeschik  2014-09-29  150  
5ef216c1f84825 Michael Grzeschik  2014-09-18  151  	if (mm->size) {
5ef216c1f84825 Michael Grzeschik  2014-09-18  152  		ioaddr = pci_resource_start(pdev, mm->bar) + mm->offset;
5ef216c1f84825 Michael Grzeschik  2014-09-18  153  		r = devm_request_region(&pdev->dev, ioaddr, mm->size,
5ef216c1f84825 Michael Grzeschik  2014-09-18  154  					"com20020-pci");
5ef216c1f84825 Michael Grzeschik  2014-09-18  155  		if (!r) {
5ef216c1f84825 Michael Grzeschik  2014-09-18  156  			pr_err("IO region %xh-%xh already allocated.\n",
5ef216c1f84825 Michael Grzeschik  2014-09-18  157  			       ioaddr, ioaddr + mm->size - 1);
5ef216c1f84825 Michael Grzeschik  2014-09-18  158  			return -EBUSY;
5ef216c1f84825 Michael Grzeschik  2014-09-18  159  		}
5ef216c1f84825 Michael Grzeschik  2014-09-18  160  		priv->misc = ioaddr;
5ef216c1f84825 Michael Grzeschik  2014-09-18  161  	}
5ef216c1f84825 Michael Grzeschik  2014-09-18  162  
c51da42a6346c0 Michael Grzeschik  2014-09-29  163  	for (i = 0; i < ci->devcount; i++) {
c51da42a6346c0 Michael Grzeschik  2014-09-29  164  		struct com20020_pci_channel_map *cm = &ci->chan_map_tbl[i];
c51da42a6346c0 Michael Grzeschik  2014-09-29  165  		struct com20020_dev *card;
cb108619f2fc77 Michael Grzeschik  2017-06-28  166  		int dev_id_mask = 0xf;
c51da42a6346c0 Michael Grzeschik  2014-09-29  167  
^1da177e4c3f41 Linus Torvalds     2005-04-16  168  		dev = alloc_arcdev(device);
c51da42a6346c0 Michael Grzeschik  2014-09-29  169  		if (!dev) {
c51da42a6346c0 Michael Grzeschik  2014-09-29  170  			ret = -ENOMEM;
6577b9a551aedb Tong Zhang         2021-03-14  171  			break;
c51da42a6346c0 Michael Grzeschik  2014-09-29  172  		}
ae8ede6a0cdcf3 Michael Grzeschik  2015-03-20  173  		dev->dev_port = i;
a1799af4d7deef Stephen Hemminger  2009-01-09  174  
a1799af4d7deef Stephen Hemminger  2009-01-09  175  		dev->netdev_ops = &com20020_netdev_ops;
a1799af4d7deef Stephen Hemminger  2009-01-09  176  
454d7c9b14e20f Wang Chen          2008-11-12  177  		lp = netdev_priv(dev);
^1da177e4c3f41 Linus Torvalds     2005-04-16  178  
a34c0932c3b2f2 Joe Perches        2015-05-05  179  		arc_printk(D_NORMAL, dev, "%s Controls\n", ci->name);
c51da42a6346c0 Michael Grzeschik  2014-09-29  180  		ioaddr = pci_resource_start(pdev, cm->bar) + cm->offset;
c51da42a6346c0 Michael Grzeschik  2014-09-29  181  
c51da42a6346c0 Michael Grzeschik  2014-09-29  182  		r = devm_request_region(&pdev->dev, ioaddr, cm->size,
c51da42a6346c0 Michael Grzeschik  2014-09-29  183  					"com20020-pci");
c51da42a6346c0 Michael Grzeschik  2014-09-29  184  		if (!r) {
05a24b234b9dda Joe Perches        2015-05-05  185  			pr_err("IO region %xh-%xh already allocated\n",
c51da42a6346c0 Michael Grzeschik  2014-09-29  186  			       ioaddr, ioaddr + cm->size - 1);
c51da42a6346c0 Michael Grzeschik  2014-09-29  187  			ret = -EBUSY;
6577b9a551aedb Tong Zhang         2021-03-14  188  			goto err_free_arcdev;
^1da177e4c3f41 Linus Torvalds     2005-04-16  189  		}
^1da177e4c3f41 Linus Torvalds     2005-04-16  190  
c51da42a6346c0 Michael Grzeschik  2014-09-29  191  		/* Dummy access after Reset
c51da42a6346c0 Michael Grzeschik  2014-09-29  192  		 * ARCNET controller needs
c51da42a6346c0 Michael Grzeschik  2014-09-29  193  		 * this access to detect bustype
c51da42a6346c0 Michael Grzeschik  2014-09-29  194  		 */
0fec65130b9f11 Joe Perches        2015-05-05  195  		arcnet_outb(0x00, ioaddr, COM20020_REG_W_COMMAND);
0fec65130b9f11 Joe Perches        2015-05-05  196  		arcnet_inb(ioaddr, COM20020_REG_R_DIAGSTAT);
^1da177e4c3f41 Linus Torvalds     2005-04-16  197  
2a0ea04c83ab82 Michael Grzeschik  2017-06-28  198  		SET_NETDEV_DEV(dev, &pdev->dev);
^1da177e4c3f41 Linus Torvalds     2005-04-16 @199  		dev->base_addr = ioaddr;
13b5ffa0e282f3 Jakub Kicinski     2021-10-12  200  		arcnet_set_addr(dev, node);
ede07a1fc7d70a Michael Grzeschik  2017-06-28  201  		dev->sysfs_groups[0] = &com20020_state_group;
c51da42a6346c0 Michael Grzeschik  2014-09-29  202  		dev->irq = pdev->irq;
^1da177e4c3f41 Linus Torvalds     2005-04-16  203  		lp->card_name = "PCI COM20020";
8c14f9c70327a6 Michael Grzeschik  2014-09-29  204  		lp->card_flags = ci->flags;
^1da177e4c3f41 Linus Torvalds     2005-04-16  205  		lp->backplane = backplane;
^1da177e4c3f41 Linus Torvalds     2005-04-16  206  		lp->clockp = clockp & 7;
^1da177e4c3f41 Linus Torvalds     2005-04-16  207  		lp->clockm = clockm & 3;
^1da177e4c3f41 Linus Torvalds     2005-04-16  208  		lp->timeout = timeout;
^1da177e4c3f41 Linus Torvalds     2005-04-16  209  		lp->hw.owner = THIS_MODULE;
^1da177e4c3f41 Linus Torvalds     2005-04-16  210  
52ab12e4f99437 Michael Grzeschik  2017-06-28  211  		lp->backplane = (inb(priv->misc) >> (2 + i)) & 0x1;
52ab12e4f99437 Michael Grzeschik  2017-06-28  212  
a356ab1c3d4651 Michael Grzeschik  2017-06-28  213  		if (!strncmp(ci->name, "EAE PLX-PCI FB2", 15))
a356ab1c3d4651 Michael Grzeschik  2017-06-28  214  			lp->backplane = 1;
a356ab1c3d4651 Michael Grzeschik  2017-06-28  215  
5ef216c1f84825 Michael Grzeschik  2014-09-18  216  		/* Get the dev_id from the PLX rotary coder */
5ef216c1f84825 Michael Grzeschik  2014-09-18  217  		if (!strncmp(ci->name, "EAE PLX-PCI MA1", 15))
cb108619f2fc77 Michael Grzeschik  2017-06-28  218  			dev_id_mask = 0x3;
cb108619f2fc77 Michael Grzeschik  2017-06-28  219  		dev->dev_id = (inb(priv->misc + ci->rotary) >> 4) & dev_id_mask;
5ef216c1f84825 Michael Grzeschik  2014-09-18  220  
5ef216c1f84825 Michael Grzeschik  2014-09-18  221  		snprintf(dev->name, sizeof(dev->name), "arc%d-%d", dev->dev_id, i);
5ef216c1f84825 Michael Grzeschik  2014-09-18  222  
0fec65130b9f11 Joe Perches        2015-05-05  223  		if (arcnet_inb(ioaddr, COM20020_REG_R_STATUS) == 0xFF) {
c51da42a6346c0 Michael Grzeschik  2014-09-29  224  			pr_err("IO address %Xh is empty!\n", ioaddr);
c51da42a6346c0 Michael Grzeschik  2014-09-29  225  			ret = -EIO;
6577b9a551aedb Tong Zhang         2021-03-14  226  			goto err_free_arcdev;
^1da177e4c3f41 Linus Torvalds     2005-04-16  227  		}
^1da177e4c3f41 Linus Torvalds     2005-04-16  228  		if (com20020_check(dev)) {
c51da42a6346c0 Michael Grzeschik  2014-09-29  229  			ret = -EIO;
6577b9a551aedb Tong Zhang         2021-03-14  230  			goto err_free_arcdev;
^1da177e4c3f41 Linus Torvalds     2005-04-16  231  		}
^1da177e4c3f41 Linus Torvalds     2005-04-16  232  
c51da42a6346c0 Michael Grzeschik  2014-09-29  233  		card = devm_kzalloc(&pdev->dev, sizeof(struct com20020_dev),
c51da42a6346c0 Michael Grzeschik  2014-09-29  234  				    GFP_KERNEL);
01c3521f794ce9 Christophe Jaillet 2017-07-07  235  		if (!card) {
01c3521f794ce9 Christophe Jaillet 2017-07-07  236  			ret = -ENOMEM;
6577b9a551aedb Tong Zhang         2021-03-14  237  			goto err_free_arcdev;
01c3521f794ce9 Christophe Jaillet 2017-07-07  238  		}
c51da42a6346c0 Michael Grzeschik  2014-09-29  239  
c51da42a6346c0 Michael Grzeschik  2014-09-29  240  		card->index = i;
c51da42a6346c0 Michael Grzeschik  2014-09-29  241  		card->pci_priv = priv;
8890624a4e8c2c Michael Grzeschik  2014-09-18  242  		card->tx_led.brightness_set = led_tx_set;
8890624a4e8c2c Michael Grzeschik  2014-09-18  243  		card->tx_led.default_trigger = devm_kasprintf(&pdev->dev,
8890624a4e8c2c Michael Grzeschik  2014-09-18  244  						GFP_KERNEL, "arc%d-%d-tx",
8890624a4e8c2c Michael Grzeschik  2014-09-18  245  						dev->dev_id, i);
8890624a4e8c2c Michael Grzeschik  2014-09-18  246  		card->tx_led.name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
8890624a4e8c2c Michael Grzeschik  2014-09-18  247  						"pci:green:tx:%d-%d",
8890624a4e8c2c Michael Grzeschik  2014-09-18  248  						dev->dev_id, i);
8890624a4e8c2c Michael Grzeschik  2014-09-18  249  
8890624a4e8c2c Michael Grzeschik  2014-09-18  250  		card->tx_led.dev = &dev->dev;
8890624a4e8c2c Michael Grzeschik  2014-09-18  251  		card->recon_led.brightness_set = led_recon_set;
8890624a4e8c2c Michael Grzeschik  2014-09-18  252  		card->recon_led.default_trigger = devm_kasprintf(&pdev->dev,
8890624a4e8c2c Michael Grzeschik  2014-09-18  253  						GFP_KERNEL, "arc%d-%d-recon",
8890624a4e8c2c Michael Grzeschik  2014-09-18  254  						dev->dev_id, i);
8890624a4e8c2c Michael Grzeschik  2014-09-18  255  		card->recon_led.name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
8890624a4e8c2c Michael Grzeschik  2014-09-18  256  						"pci:red:recon:%d-%d",
8890624a4e8c2c Michael Grzeschik  2014-09-18  257  						dev->dev_id, i);
8890624a4e8c2c Michael Grzeschik  2014-09-18  258  		card->recon_led.dev = &dev->dev;
c51da42a6346c0 Michael Grzeschik  2014-09-29  259  		card->dev = dev;
c51da42a6346c0 Michael Grzeschik  2014-09-29  260  
8890624a4e8c2c Michael Grzeschik  2014-09-18  261  		ret = devm_led_classdev_register(&pdev->dev, &card->tx_led);
8890624a4e8c2c Michael Grzeschik  2014-09-18  262  		if (ret)
6577b9a551aedb Tong Zhang         2021-03-14  263  			goto err_free_arcdev;
8890624a4e8c2c Michael Grzeschik  2014-09-18  264  
8890624a4e8c2c Michael Grzeschik  2014-09-18  265  		ret = devm_led_classdev_register(&pdev->dev, &card->recon_led);
8890624a4e8c2c Michael Grzeschik  2014-09-18  266  		if (ret)
6577b9a551aedb Tong Zhang         2021-03-14  267  			goto err_free_arcdev;
8890624a4e8c2c Michael Grzeschik  2014-09-18  268  
c51da42a6346c0 Michael Grzeschik  2014-09-29  269  		dev_set_drvdata(&dev->dev, card);
c51da42a6346c0 Michael Grzeschik  2014-09-29  270  
c51da42a6346c0 Michael Grzeschik  2014-09-29  271  		ret = com20020_found(dev, IRQF_SHARED);
c51da42a6346c0 Michael Grzeschik  2014-09-29  272  		if (ret)
6577b9a551aedb Tong Zhang         2021-03-14  273  			goto err_free_arcdev;
^1da177e4c3f41 Linus Torvalds     2005-04-16  274  
8890624a4e8c2c Michael Grzeschik  2014-09-18  275  		devm_arcnet_led_init(dev, dev->dev_id, i);
8890624a4e8c2c Michael Grzeschik  2014-09-18  276  
c51da42a6346c0 Michael Grzeschik  2014-09-29  277  		list_add(&card->list, &priv->list_dev);
6577b9a551aedb Tong Zhang         2021-03-14  278  		continue;
^1da177e4c3f41 Linus Torvalds     2005-04-16  279  
6577b9a551aedb Tong Zhang         2021-03-14  280  err_free_arcdev:
6577b9a551aedb Tong Zhang         2021-03-14  281  		free_arcdev(dev);
6577b9a551aedb Tong Zhang         2021-03-14  282  		break;
6577b9a551aedb Tong Zhang         2021-03-14  283  	}
6577b9a551aedb Tong Zhang         2021-03-14  284  	if (ret)
c51da42a6346c0 Michael Grzeschik  2014-09-29  285  		com20020pci_remove(pdev);
c51da42a6346c0 Michael Grzeschik  2014-09-29  286  	return ret;
^1da177e4c3f41 Linus Torvalds     2005-04-16  287  }
^1da177e4c3f41 Linus Torvalds     2005-04-16  288  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
