Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA1C6AA03F
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 20:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbjCCTqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 14:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjCCTq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 14:46:29 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8202247438
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 11:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677872787; x=1709408787;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MmS1if5ocaW430OGqD/Zy7m55OH1On6Igy22isuRWf0=;
  b=JV/FpwtH14BsodA00hnU9sM3K/x1DPxElHFZloUsEmOuXJ2Ha9AEnuOu
   qLkIIqLcWHhys5e+GrR7AvcEXDJSkt7OfILZVPntvfBFCwHnnlR2Zcn5G
   31VpmFhvg6s73rcYxv3tUaD66tvR0PNzriZEnaDjb0Hrh1JDtlpkTbCWx
   V6Kp/0uXJk6qAGmBYSD2M6sa3vfL4UjgUJ5KZABqMyF3P49WH7REXdC95
   bTaHNKAM51Q2+iWtdh/IYoXytpMywXrWSAhGPsaMWCZQOLpligU36ndKc
   OF/gu/OCElt58HID68aO+8Ud/2ziDETKH0r0tzcVQuXERkulRNZqaYiYS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="421414728"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="421414728"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 11:46:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="705749578"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="705749578"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 03 Mar 2023 11:46:24 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pYBMF-0001dY-1h;
        Fri, 03 Mar 2023 19:46:23 +0000
Date:   Sat, 4 Mar 2023 03:46:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: Re: [PATCH v1] netdevice: use ifmap isteand of plain fields
Message-ID: <202303040357.BP5TQ4vl-lkp@intel.com>
References: <20230303150818.132386-1-vincenzopalazzodev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303150818.132386-1-vincenzopalazzodev@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincenzo,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]
[also build test ERROR on net-next/master horms-ipvs/master linus/master v6.2 next-20230303]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vincenzo-Palazzo/netdevice-use-ifmap-isteand-of-plain-fields/20230303-231003
patch link:    https://lore.kernel.org/r/20230303150818.132386-1-vincenzopalazzodev%40gmail.com
patch subject: [PATCH v1] netdevice: use ifmap isteand of plain fields
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20230304/202303040357.BP5TQ4vl-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/4efa870f9b2112fdebe7d1fffe30f5626b8d5229
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vincenzo-Palazzo/netdevice-use-ifmap-isteand-of-plain-fields/20230303-231003
        git checkout 4efa870f9b2112fdebe7d1fffe30f5626b8d5229
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303040357.BP5TQ4vl-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/hamradio/baycom_epp.c: In function 'epp_open':
>> drivers/net/hamradio/baycom_epp.c:818:51: error: 'struct net_device' has no member named 'base_addr'
     818 |         struct parport *pp = parport_find_base(dev->base_addr);
         |                                                   ^~
   In file included from include/linux/kernel.h:29,
                    from include/linux/cpumask.h:10,
                    from include/linux/mm_types_task.h:14,
                    from include/linux/mm_types.h:5,
                    from include/linux/buildid.h:5,
                    from include/linux/module.h:14,
                    from drivers/net/hamradio/baycom_epp.c:29:
   drivers/net/hamradio/baycom_epp.c:826:82: error: 'struct net_device' has no member named 'base_addr'
     826 |                 printk(KERN_ERR "%s: parport at 0x%lx unknown\n", bc_drvname, dev->base_addr);
         |                                                                                  ^~
   include/linux/printk.h:427:33: note: in definition of macro 'printk_index_wrap'
     427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   drivers/net/hamradio/baycom_epp.c:826:17: note: in expansion of macro 'printk'
     826 |                 printk(KERN_ERR "%s: parport at 0x%lx unknown\n", bc_drvname, dev->base_addr);
         |                 ^~~~~~
   drivers/net/hamradio/baycom_epp.c: In function 'epp_close':
   drivers/net/hamradio/baycom_epp.c:961:31: error: 'struct net_device' has no member named 'base_addr'
     961 |                bc_drvname, dev->base_addr, dev->irq);
         |                               ^~
   include/linux/printk.h:427:33: note: in definition of macro 'printk_index_wrap'
     427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   drivers/net/hamradio/baycom_epp.c:960:9: note: in expansion of macro 'printk'
     960 |         printk(KERN_INFO "%s: close epp at iobase 0x%lx irq %u\n",
         |         ^~~~~~
   drivers/net/hamradio/baycom_epp.c: In function 'baycom_siocdevprivate':
   drivers/net/hamradio/baycom_epp.c:1037:40: error: 'struct net_device' has no member named 'base_addr'
    1037 |                 hi.data.mp.iobase = dev->base_addr;
         |                                        ^~
   drivers/net/hamradio/baycom_epp.c:1049:20: error: 'struct net_device' has no member named 'base_addr'
    1049 |                 dev->base_addr = hi.data.mp.iobase;
         |                    ^~
   drivers/net/hamradio/baycom_epp.c: In function 'init_baycomepp':
   drivers/net/hamradio/baycom_epp.c:1242:20: error: 'struct net_device' has no member named 'base_addr'
    1242 |                 dev->base_addr = iobase[i];
         |                    ^~
--
   drivers/net/ethernet/8390/stnic.c: In function 'STNIC_DELAY':
   drivers/net/ethernet/8390/stnic.c:81:9: warning: variable 'trash' set but not used [-Wunused-but-set-variable]
      81 |   vword trash;
         |         ^~~~~
   drivers/net/ethernet/8390/stnic.c: In function 'stnic_probe':
>> drivers/net/ethernet/8390/stnic.c:125:6: error: 'struct net_device' has no member named 'base_addr'
     125 |   dev->base_addr = 0x1000;
         |      ^~


vim +818 drivers/net/hamradio/baycom_epp.c

^1da177e4c3f41 Linus Torvalds         2005-04-16  805  
^1da177e4c3f41 Linus Torvalds         2005-04-16  806  /*
^1da177e4c3f41 Linus Torvalds         2005-04-16  807   * Open/initialize the board. This is called (in the current kernel)
^1da177e4c3f41 Linus Torvalds         2005-04-16  808   * sometime after booting when the 'ifconfig' program is run.
^1da177e4c3f41 Linus Torvalds         2005-04-16  809   *
^1da177e4c3f41 Linus Torvalds         2005-04-16  810   * This routine should set everything up anew at each open, even
^1da177e4c3f41 Linus Torvalds         2005-04-16  811   * registers that "should" only need to be set once at boot, so that
^1da177e4c3f41 Linus Torvalds         2005-04-16  812   * there is non-reboot way to recover if something goes wrong.
^1da177e4c3f41 Linus Torvalds         2005-04-16  813   */
^1da177e4c3f41 Linus Torvalds         2005-04-16  814  
^1da177e4c3f41 Linus Torvalds         2005-04-16  815  static int epp_open(struct net_device *dev)
^1da177e4c3f41 Linus Torvalds         2005-04-16  816  {
^1da177e4c3f41 Linus Torvalds         2005-04-16  817  	struct baycom_state *bc = netdev_priv(dev);
^1da177e4c3f41 Linus Torvalds         2005-04-16 @818          struct parport *pp = parport_find_base(dev->base_addr);
^1da177e4c3f41 Linus Torvalds         2005-04-16  819  	unsigned int i, j;
^1da177e4c3f41 Linus Torvalds         2005-04-16  820  	unsigned char tmp[128];
^1da177e4c3f41 Linus Torvalds         2005-04-16  821  	unsigned char stat;
^1da177e4c3f41 Linus Torvalds         2005-04-16  822  	unsigned long tstart;
ca444073a2de97 Sudip Mukherjee        2017-09-17  823  	struct pardev_cb par_cb;
^1da177e4c3f41 Linus Torvalds         2005-04-16  824  	
^1da177e4c3f41 Linus Torvalds         2005-04-16  825          if (!pp) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  826                  printk(KERN_ERR "%s: parport at 0x%lx unknown\n", bc_drvname, dev->base_addr);
^1da177e4c3f41 Linus Torvalds         2005-04-16  827                  return -ENXIO;
^1da177e4c3f41 Linus Torvalds         2005-04-16  828          }
^1da177e4c3f41 Linus Torvalds         2005-04-16  829  #if 0
^1da177e4c3f41 Linus Torvalds         2005-04-16  830          if (pp->irq < 0) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  831                  printk(KERN_ERR "%s: parport at 0x%lx has no irq\n", bc_drvname, pp->base);
^1da177e4c3f41 Linus Torvalds         2005-04-16  832  		parport_put_port(pp);
^1da177e4c3f41 Linus Torvalds         2005-04-16  833                  return -ENXIO;
^1da177e4c3f41 Linus Torvalds         2005-04-16  834          }
^1da177e4c3f41 Linus Torvalds         2005-04-16  835  #endif
^1da177e4c3f41 Linus Torvalds         2005-04-16  836  	if ((~pp->modes) & (PARPORT_MODE_TRISTATE | PARPORT_MODE_PCSPP | PARPORT_MODE_SAFEININT)) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  837                  printk(KERN_ERR "%s: parport at 0x%lx cannot be used\n",
^1da177e4c3f41 Linus Torvalds         2005-04-16  838  		       bc_drvname, pp->base);
^1da177e4c3f41 Linus Torvalds         2005-04-16  839  		parport_put_port(pp);
^1da177e4c3f41 Linus Torvalds         2005-04-16  840                  return -EIO;
^1da177e4c3f41 Linus Torvalds         2005-04-16  841  	}
^1da177e4c3f41 Linus Torvalds         2005-04-16  842  	memset(&bc->modem, 0, sizeof(bc->modem));
ca444073a2de97 Sudip Mukherjee        2017-09-17  843  	memset(&par_cb, 0, sizeof(par_cb));
ca444073a2de97 Sudip Mukherjee        2017-09-17  844  	par_cb.wakeup = epp_wakeup;
ca444073a2de97 Sudip Mukherjee        2017-09-17  845  	par_cb.private = (void *)dev;
ca444073a2de97 Sudip Mukherjee        2017-09-17  846  	par_cb.flags = PARPORT_DEV_EXCL;
ca444073a2de97 Sudip Mukherjee        2017-09-17  847  	for (i = 0; i < NR_PORTS; i++)
ca444073a2de97 Sudip Mukherjee        2017-09-17  848  		if (baycom_device[i] == dev)
ca444073a2de97 Sudip Mukherjee        2017-09-17  849  			break;
ca444073a2de97 Sudip Mukherjee        2017-09-17  850  
ca444073a2de97 Sudip Mukherjee        2017-09-17  851  	if (i == NR_PORTS) {
ca444073a2de97 Sudip Mukherjee        2017-09-17  852  		pr_err("%s: no device found\n", bc_drvname);
ca444073a2de97 Sudip Mukherjee        2017-09-17  853  		parport_put_port(pp);
ca444073a2de97 Sudip Mukherjee        2017-09-17  854  		return -ENODEV;
ca444073a2de97 Sudip Mukherjee        2017-09-17  855  	}
ca444073a2de97 Sudip Mukherjee        2017-09-17  856  
ca444073a2de97 Sudip Mukherjee        2017-09-17  857  	bc->pdev = parport_register_dev_model(pp, dev->name, &par_cb, i);
^1da177e4c3f41 Linus Torvalds         2005-04-16  858  	parport_put_port(pp);
^1da177e4c3f41 Linus Torvalds         2005-04-16  859          if (!bc->pdev) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  860                  printk(KERN_ERR "%s: cannot register parport at 0x%lx\n", bc_drvname, pp->base);
^1da177e4c3f41 Linus Torvalds         2005-04-16  861                  return -ENXIO;
^1da177e4c3f41 Linus Torvalds         2005-04-16  862          }
^1da177e4c3f41 Linus Torvalds         2005-04-16  863          if (parport_claim(bc->pdev)) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  864                  printk(KERN_ERR "%s: parport at 0x%lx busy\n", bc_drvname, pp->base);
^1da177e4c3f41 Linus Torvalds         2005-04-16  865                  parport_unregister_device(bc->pdev);
^1da177e4c3f41 Linus Torvalds         2005-04-16  866                  return -EBUSY;
^1da177e4c3f41 Linus Torvalds         2005-04-16  867          }
^1da177e4c3f41 Linus Torvalds         2005-04-16  868          dev->irq = /*pp->irq*/ 0;
c4028958b6ecad David Howells          2006-11-22  869  	INIT_DELAYED_WORK(&bc->run_work, epp_bh);
^1da177e4c3f41 Linus Torvalds         2005-04-16  870  	bc->work_running = 1;
^1da177e4c3f41 Linus Torvalds         2005-04-16  871  	bc->modem = EPP_CONVENTIONAL;
^1da177e4c3f41 Linus Torvalds         2005-04-16  872  	if (eppconfig(bc))
^1da177e4c3f41 Linus Torvalds         2005-04-16  873  		printk(KERN_INFO "%s: no FPGA detected, assuming conventional EPP modem\n", bc_drvname);
^1da177e4c3f41 Linus Torvalds         2005-04-16  874  	else
^1da177e4c3f41 Linus Torvalds         2005-04-16  875  		bc->modem = /*EPP_FPGA*/ EPP_FPGAEXTSTATUS;
^1da177e4c3f41 Linus Torvalds         2005-04-16  876  	parport_write_control(pp, LPTCTRL_PROGRAM); /* prepare EPP mode; we aren't using interrupts */
^1da177e4c3f41 Linus Torvalds         2005-04-16  877  	/* reset the modem */
^1da177e4c3f41 Linus Torvalds         2005-04-16  878  	tmp[0] = 0;
^1da177e4c3f41 Linus Torvalds         2005-04-16  879  	tmp[1] = EPP_TX_FIFO_ENABLE|EPP_RX_FIFO_ENABLE|EPP_MODEM_ENABLE;
^1da177e4c3f41 Linus Torvalds         2005-04-16  880  	if (pp->ops->epp_write_addr(pp, tmp, 2, 0) != 2)
^1da177e4c3f41 Linus Torvalds         2005-04-16  881  		goto epptimeout;
^1da177e4c3f41 Linus Torvalds         2005-04-16  882  	/* autoprobe baud rate */
^1da177e4c3f41 Linus Torvalds         2005-04-16  883  	tstart = jiffies;
^1da177e4c3f41 Linus Torvalds         2005-04-16  884  	i = 0;
ff5688ae1cedfb Marcelo Feitoza Parisi 2006-01-09  885  	while (time_before(jiffies, tstart + HZ/3)) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  886  		if (pp->ops->epp_read_addr(pp, &stat, 1, 0) != 1)
^1da177e4c3f41 Linus Torvalds         2005-04-16  887  			goto epptimeout;
^1da177e4c3f41 Linus Torvalds         2005-04-16  888  		if ((stat & (EPP_NRAEF|EPP_NRHF)) == EPP_NRHF) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  889  			schedule();
^1da177e4c3f41 Linus Torvalds         2005-04-16  890  			continue;
^1da177e4c3f41 Linus Torvalds         2005-04-16  891  		}
^1da177e4c3f41 Linus Torvalds         2005-04-16  892  		if (pp->ops->epp_read_data(pp, tmp, 128, 0) != 128)
^1da177e4c3f41 Linus Torvalds         2005-04-16  893  			goto epptimeout;
^1da177e4c3f41 Linus Torvalds         2005-04-16  894  		if (pp->ops->epp_read_data(pp, tmp, 128, 0) != 128)
^1da177e4c3f41 Linus Torvalds         2005-04-16  895  			goto epptimeout;
^1da177e4c3f41 Linus Torvalds         2005-04-16  896  		i += 256;
^1da177e4c3f41 Linus Torvalds         2005-04-16  897  	}
^1da177e4c3f41 Linus Torvalds         2005-04-16  898  	for (j = 0; j < 256; j++) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  899  		if (pp->ops->epp_read_addr(pp, &stat, 1, 0) != 1)
^1da177e4c3f41 Linus Torvalds         2005-04-16  900  			goto epptimeout;
^1da177e4c3f41 Linus Torvalds         2005-04-16  901  		if (!(stat & EPP_NREF))
^1da177e4c3f41 Linus Torvalds         2005-04-16  902  			break;
^1da177e4c3f41 Linus Torvalds         2005-04-16  903  		if (pp->ops->epp_read_data(pp, tmp, 1, 0) != 1)
^1da177e4c3f41 Linus Torvalds         2005-04-16  904  			goto epptimeout;
^1da177e4c3f41 Linus Torvalds         2005-04-16  905  		i++;
^1da177e4c3f41 Linus Torvalds         2005-04-16  906  	}
^1da177e4c3f41 Linus Torvalds         2005-04-16  907  	tstart = jiffies - tstart;
^1da177e4c3f41 Linus Torvalds         2005-04-16  908  	bc->bitrate = i * (8 * HZ) / tstart;
^1da177e4c3f41 Linus Torvalds         2005-04-16  909  	j = 1;
^1da177e4c3f41 Linus Torvalds         2005-04-16  910  	i = bc->bitrate >> 3;
^1da177e4c3f41 Linus Torvalds         2005-04-16  911  	while (j < 7 && i > 150) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  912  		j++;
^1da177e4c3f41 Linus Torvalds         2005-04-16  913  		i >>= 1;
^1da177e4c3f41 Linus Torvalds         2005-04-16  914  	}
^1da177e4c3f41 Linus Torvalds         2005-04-16  915  	printk(KERN_INFO "%s: autoprobed bitrate: %d  int divider: %d  int rate: %d\n", 
^1da177e4c3f41 Linus Torvalds         2005-04-16  916  	       bc_drvname, bc->bitrate, j, bc->bitrate >> (j+2));
^1da177e4c3f41 Linus Torvalds         2005-04-16  917  	tmp[0] = EPP_TX_FIFO_ENABLE|EPP_RX_FIFO_ENABLE|EPP_MODEM_ENABLE/*|j*/;
^1da177e4c3f41 Linus Torvalds         2005-04-16  918  	if (pp->ops->epp_write_addr(pp, tmp, 1, 0) != 1)
^1da177e4c3f41 Linus Torvalds         2005-04-16  919  		goto epptimeout;
^1da177e4c3f41 Linus Torvalds         2005-04-16  920  	/*
^1da177e4c3f41 Linus Torvalds         2005-04-16  921  	 * initialise hdlc variables
^1da177e4c3f41 Linus Torvalds         2005-04-16  922  	 */
^1da177e4c3f41 Linus Torvalds         2005-04-16  923  	bc->hdlcrx.state = 0;
^1da177e4c3f41 Linus Torvalds         2005-04-16  924  	bc->hdlcrx.numbits = 0;
^1da177e4c3f41 Linus Torvalds         2005-04-16  925  	bc->hdlctx.state = tx_idle;
^1da177e4c3f41 Linus Torvalds         2005-04-16  926  	bc->hdlctx.bufcnt = 0;
^1da177e4c3f41 Linus Torvalds         2005-04-16  927  	bc->hdlctx.slotcnt = bc->ch_params.slottime;
^1da177e4c3f41 Linus Torvalds         2005-04-16  928  	bc->hdlctx.calibrate = 0;
^1da177e4c3f41 Linus Torvalds         2005-04-16  929  	/* start the bottom half stuff */
^1da177e4c3f41 Linus Torvalds         2005-04-16  930  	schedule_delayed_work(&bc->run_work, 1);
^1da177e4c3f41 Linus Torvalds         2005-04-16  931  	netif_start_queue(dev);
^1da177e4c3f41 Linus Torvalds         2005-04-16  932  	return 0;
^1da177e4c3f41 Linus Torvalds         2005-04-16  933  
^1da177e4c3f41 Linus Torvalds         2005-04-16  934   epptimeout:
^1da177e4c3f41 Linus Torvalds         2005-04-16  935  	printk(KERN_ERR "%s: epp timeout during bitrate probe\n", bc_drvname);
^1da177e4c3f41 Linus Torvalds         2005-04-16  936  	parport_write_control(pp, 0); /* reset the adapter */
^1da177e4c3f41 Linus Torvalds         2005-04-16  937          parport_release(bc->pdev);
^1da177e4c3f41 Linus Torvalds         2005-04-16  938          parport_unregister_device(bc->pdev);
^1da177e4c3f41 Linus Torvalds         2005-04-16  939  	return -EIO;
^1da177e4c3f41 Linus Torvalds         2005-04-16  940  }
^1da177e4c3f41 Linus Torvalds         2005-04-16  941  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
