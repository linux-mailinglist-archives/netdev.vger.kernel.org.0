Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67826AA918
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 11:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjCDKRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 05:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjCDKQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 05:16:56 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE01149AC
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 02:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677925013; x=1709461013;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eM4eMCzRvTqassvwE9IO178P/Tx9J4vclt1qL5iXIv0=;
  b=bYfJvTlGNerXN313FU5CeEj+Hlh9T6ejVPYIH/NfRqHfaH8tX1vZ1Kn1
   FYgVLTHYqV4be3k8LFw5vUmu4EtHU+AZmEHWaiZg8GOwCjngNoOefG4gn
   +9+bbgjBkiO1jYARZ8wqUFlgh6z5Hjf1CcltvQdo1VbtxJZEDR8iR5ah7
   4Bn7/W/jPBFYDhAUtcuRatW7S8yVWi9lnVlgPvQlhOteIXEJVSCHpC8ts
   QeNsPY4La8NrYQeE5xNmH4absM9zRw/7ZJz0eQIZCIJ1VVEnueHZSyTnq
   uUL9ioG3Y8XtM6WW1yyeaQfEaQfq4G/f+1y4kR792xNDCzbtbj/Z/yeuD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="315645739"
X-IronPort-AV: E=Sophos;i="5.98,233,1673942400"; 
   d="scan'208";a="315645739"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2023 02:16:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="739783305"
X-IronPort-AV: E=Sophos;i="5.98,233,1673942400"; 
   d="scan'208";a="739783305"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 04 Mar 2023 02:16:49 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pYOwa-00024Q-35;
        Sat, 04 Mar 2023 10:16:48 +0000
Date:   Sat, 4 Mar 2023 18:16:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: Re: [PATCH v2] netdevice: use ifmap instead of plain fields
Message-ID: <202303041751.pvvDsaXr-lkp@intel.com>
References: <20230303180926.142107-1-vincenzopalazzodev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303180926.142107-1-vincenzopalazzodev@gmail.com>
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

url:    https://github.com/intel-lab-lkp/linux/commits/Vincenzo-Palazzo/netdevice-use-ifmap-instead-of-plain-fields/20230304-021243
patch link:    https://lore.kernel.org/r/20230303180926.142107-1-vincenzopalazzodev%40gmail.com
patch subject: [PATCH v2] netdevice: use ifmap instead of plain fields
config: arm-randconfig-r012-20230302 (https://download.01.org/0day-ci/archive/20230304/202303041751.pvvDsaXr-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/51cc3d72ba492238269006f1dc11209ac772ba0a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vincenzo-Palazzo/netdevice-use-ifmap-instead-of-plain-fields/20230304-021243
        git checkout 51cc3d72ba492238269006f1dc11209ac772ba0a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/net/ethernet/3com/ drivers/net/ethernet/amd/ drivers/net/ethernet/xilinx/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303041751.pvvDsaXr-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/ethernet/3com/3c589_cs.c: In function 'tc589_config':
>> drivers/net/ethernet/3com/3c589_cs.c:277:12: error: 'struct net_device' has no member named 'base_addr'
     277 |         dev->base_addr = link->resource[0]->start;
         |            ^~
   drivers/net/ethernet/3com/3c589_cs.c:278:21: error: 'struct net_device' has no member named 'base_addr'
     278 |         ioaddr = dev->base_addr;
         |                     ^~
   In file included from include/linux/device.h:15,
                    from include/linux/dma-mapping.h:7,
                    from include/linux/skbuff.h:28,
                    from include/linux/if_ether.h:19,
                    from include/linux/ethtool.h:18,
                    from drivers/net/ethernet/3com/3c589_cs.c:36:
   drivers/net/ethernet/3com/3c589_cs.c:295:44: error: 'struct net_device' has no member named 'base_addr'
     295 |                                         dev->base_addr, dev->base_addr+15);
         |                                            ^~
   include/linux/dev_printk.h:110:37: note: in definition of macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                                     ^~~~~~~~~~~
   drivers/net/ethernet/3com/3c589_cs.c:294:25: note: in expansion of macro 'dev_err'
     294 |                         dev_err(&link->dev, "IO port conflict at 0x%03lx-0x%03lx\n",
         |                         ^~~~~~~
   drivers/net/ethernet/3com/3c589_cs.c:295:60: error: 'struct net_device' has no member named 'base_addr'
     295 |                                         dev->base_addr, dev->base_addr+15);
         |                                                            ^~
   include/linux/dev_printk.h:110:37: note: in definition of macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                                     ^~~~~~~~~~~
   drivers/net/ethernet/3com/3c589_cs.c:294:25: note: in expansion of macro 'dev_err'
     294 |                         dev_err(&link->dev, "IO port conflict at 0x%03lx-0x%03lx\n",
         |                         ^~~~~~~
   drivers/net/ethernet/3com/3c589_cs.c:322:53: error: 'struct net_device' has no member named 'base_addr'
     322 |                         (multi ? "562" : "589"), dev->base_addr, dev->irq,
         |                                                     ^~
   In file included from include/linux/io.h:13,
                    from include/linux/irq.h:20,
                    from include/asm-generic/hardirq.h:17,
                    from arch/arm/include/asm/hardirq.h:10,
                    from include/linux/hardirq.h:11,
                    from include/linux/interrupt.h:11,
                    from drivers/net/ethernet/3com/3c589_cs.c:33:
   drivers/net/ethernet/3com/3c589_cs.c: In function 'tc589_wait_for_completion':
   drivers/net/ethernet/3com/3c589_cs.c:368:22: error: 'struct net_device' has no member named 'base_addr'
     368 |         outw(cmd, dev->base_addr + EL3_CMD);
         |                      ^~
   arch/arm/include/asm/io.h:207:60: note: in definition of macro '__io'
     207 | #define __io(a)         __typesafe_io(PCI_IO_VIRT_BASE + ((a) & IO_SPACE_LIMIT))
         |                                                            ^
   drivers/net/ethernet/3com/3c589_cs.c:368:9: note: in expansion of macro 'outw'
     368 |         outw(cmd, dev->base_addr + EL3_CMD);
         |         ^~~~
   In file included from include/linux/byteorder/little_endian.h:5,
                    from arch/arm/include/uapi/asm/byteorder.h:22,
                    from include/asm-generic/bitops/le.h:6,
                    from arch/arm/include/asm/bitops.h:269,
                    from include/linux/bitops.h:68,
                    from include/linux/log2.h:12,
                    from include/asm-generic/div64.h:55,
                    from arch/arm/include/asm/div64.h:107,
                    from include/linux/math.h:6,
                    from include/linux/math64.h:6,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from drivers/net/ethernet/3com/3c589_cs.c:27:
   drivers/net/ethernet/3com/3c589_cs.c:370:30: error: 'struct net_device' has no member named 'base_addr'
     370 |                 if (!(inw(dev->base_addr + EL3_STATUS) & 0x1000))
         |                              ^~
   include/uapi/linux/byteorder/little_endian.h:37:51: note: in definition of macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   arch/arm/include/asm/io.h:243:37: note: in expansion of macro '__io'
     243 |                         __raw_readw(__io(p))); __iormb(); __v; })
         |                                     ^~~~
   drivers/net/ethernet/3com/3c589_cs.c:370:23: note: in expansion of macro 'inw'
     370 |                 if (!(inw(dev->base_addr + EL3_STATUS) & 0x1000))
         |                       ^~~
   drivers/net/ethernet/3com/3c589_cs.c: In function 'tc589_set_xcvr':
   drivers/net/ethernet/3com/3c589_cs.c:398:34: error: 'struct net_device' has no member named 'base_addr'
     398 |         unsigned int ioaddr = dev->base_addr;
         |                                  ^~
   drivers/net/ethernet/3com/3c589_cs.c: In function 'dump_status':
   drivers/net/ethernet/3com/3c589_cs.c:427:34: error: 'struct net_device' has no member named 'base_addr'
     427 |         unsigned int ioaddr = dev->base_addr;
         |                                  ^~
   drivers/net/ethernet/3com/3c589_cs.c: In function 'tc589_reset':
   drivers/net/ethernet/3com/3c589_cs.c:442:34: error: 'struct net_device' has no member named 'base_addr'
     442 |         unsigned int ioaddr = dev->base_addr;
         |                                  ^~
   drivers/net/ethernet/3com/3c589_cs.c: In function 'netdev_get_drvinfo':
   drivers/net/ethernet/3com/3c589_cs.c:485:36: error: 'struct net_device' has no member named 'base_addr'
     485 |                 "PCMCIA 0x%lx", dev->base_addr);
         |                                    ^~
   drivers/net/ethernet/3com/3c589_cs.c: In function 'el3_open':
   drivers/net/ethernet/3com/3c589_cs.c:522:29: error: 'struct net_device' has no member named 'base_addr'
     522 |           dev->name, inw(dev->base_addr + EL3_STATUS));
         |                             ^~
   include/uapi/linux/byteorder/little_endian.h:37:51: note: in definition of macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   arch/arm/include/asm/io.h:243:37: note: in expansion of macro '__io'
     243 |                         __raw_readw(__io(p))); __iormb(); __v; })
--
   drivers/net/ethernet/3com/3c574_cs.c: In function 'tc574_config':
>> drivers/net/ethernet/3com/3c574_cs.c:337:12: error: 'struct net_device' has no member named 'base_addr'
     337 |         dev->base_addr = link->resource[0]->start;
         |            ^~
   drivers/net/ethernet/3com/3c574_cs.c:339:21: error: 'struct net_device' has no member named 'base_addr'
     339 |         ioaddr = dev->base_addr;
         |                     ^~
   In file included from include/linux/kernel.h:29,
                    from include/linux/cpumask.h:10,
                    from include/linux/mm_types_task.h:14,
                    from include/linux/mm_types.h:5,
                    from include/linux/buildid.h:5,
                    from include/linux/module.h:14,
                    from drivers/net/ethernet/3com/3c574_cs.c:74:
   drivers/net/ethernet/3com/3c574_cs.c:357:38: error: 'struct net_device' has no member named 'base_addr'
     357 |                                   dev->base_addr, dev->base_addr+15);
         |                                      ^~
   include/linux/printk.h:427:33: note: in definition of macro 'printk_index_wrap'
     427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:518:9: note: in expansion of macro 'printk'
     518 |         printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   drivers/net/ethernet/3com/3c574_cs.c:356:25: note: in expansion of macro 'pr_notice'
     356 |                         pr_notice("IO port conflict at 0x%03lx-0x%03lx\n",
         |                         ^~~~~~~~~
   drivers/net/ethernet/3com/3c574_cs.c:357:54: error: 'struct net_device' has no member named 'base_addr'
     357 |                                   dev->base_addr, dev->base_addr+15);
         |                                                      ^~
   include/linux/printk.h:427:33: note: in definition of macro 'printk_index_wrap'
     427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:518:9: note: in expansion of macro 'printk'
     518 |         printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   drivers/net/ethernet/3com/3c574_cs.c:356:25: note: in expansion of macro 'pr_notice'
     356 |                         pr_notice("IO port conflict at 0x%03lx-0x%03lx\n",
         |                         ^~~~~~~~~
   drivers/net/ethernet/3com/3c574_cs.c:430:34: error: 'struct net_device' has no member named 'base_addr'
     430 |                     cardname, dev->base_addr, dev->irq, dev->dev_addr);
         |                                  ^~
   drivers/net/ethernet/3com/3c574_cs.c: In function 'dump_status':
   drivers/net/ethernet/3com/3c574_cs.c:473:34: error: 'struct net_device' has no member named 'base_addr'
     473 |         unsigned int ioaddr = dev->base_addr;
         |                                  ^~
   In file included from include/linux/io.h:13,
                    from include/linux/irq.h:20,
                    from include/asm-generic/hardirq.h:17,
                    from arch/arm/include/asm/hardirq.h:10,
                    from include/linux/hardirq.h:11,
                    from include/linux/interrupt.h:11,
                    from drivers/net/ethernet/3com/3c574_cs.c:79:
   drivers/net/ethernet/3com/3c574_cs.c: In function 'tc574_wait_for_completion':
   drivers/net/ethernet/3com/3c574_cs.c:492:22: error: 'struct net_device' has no member named 'base_addr'
     492 |         outw(cmd, dev->base_addr + EL3_CMD);
         |                      ^~
   arch/arm/include/asm/io.h:207:60: note: in definition of macro '__io'
     207 | #define __io(a)         __typesafe_io(PCI_IO_VIRT_BASE + ((a) & IO_SPACE_LIMIT))
         |                                                            ^
   drivers/net/ethernet/3com/3c574_cs.c:492:9: note: in expansion of macro 'outw'
     492 |         outw(cmd, dev->base_addr + EL3_CMD);
         |         ^~~~
   In file included from include/linux/byteorder/little_endian.h:5,
                    from arch/arm/include/uapi/asm/byteorder.h:22,
                    from include/asm-generic/bitops/le.h:6,
                    from arch/arm/include/asm/bitops.h:269,
                    from include/linux/bitops.h:68,
                    from include/linux/log2.h:12,
                    from include/asm-generic/div64.h:55,
                    from arch/arm/include/asm/div64.h:107,
                    from include/linux/math.h:6,
                    from include/linux/math64.h:6,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13:
   drivers/net/ethernet/3com/3c574_cs.c:494:30: error: 'struct net_device' has no member named 'base_addr'
     494 |                 if (!(inw(dev->base_addr + EL3_STATUS) & 0x1000)) break;
         |                              ^~
   include/uapi/linux/byteorder/little_endian.h:37:51: note: in definition of macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   arch/arm/include/asm/io.h:243:37: note: in expansion of macro '__io'
     243 |                         __raw_readw(__io(p))); __iormb(); __v; })
         |                                     ^~~~
   drivers/net/ethernet/3com/3c574_cs.c:494:23: note: in expansion of macro 'inw'
     494 |                 if (!(inw(dev->base_addr + EL3_STATUS) & 0x1000)) break;
         |                       ^~~
   drivers/net/ethernet/3com/3c574_cs.c: In function 'tc574_reset':
   drivers/net/ethernet/3com/3c574_cs.c:593:34: error: 'struct net_device' has no member named 'base_addr'
     593 |         unsigned int ioaddr = dev->base_addr;
         |                                  ^~
   drivers/net/ethernet/3com/3c574_cs.c: In function 'el3_open':
   drivers/net/ethernet/3com/3c574_cs.c:687:37: error: 'struct net_device' has no member named 'base_addr'
     687 |                   dev->name, inw(dev->base_addr + EL3_STATUS));
         |                                     ^~
   include/uapi/linux/byteorder/little_endian.h:37:51: note: in definition of macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   arch/arm/include/asm/io.h:243:37: note: in expansion of macro '__io'
     243 |                         __raw_readw(__io(p))); __iormb(); __v; })
         |                                     ^~~~
   include/linux/dev_printk.h:129:48: note: in expansion of macro 'inw'
--
   drivers/net/ethernet/amd/nmclan_cs.c: In function 'nmclan_config':
>> drivers/net/ethernet/amd/nmclan_cs.c:629:6: error: 'struct net_device' has no member named 'base_addr'
     629 |   dev->base_addr = link->resource[0]->start;
         |      ^~
   drivers/net/ethernet/amd/nmclan_cs.c:631:15: error: 'struct net_device' has no member named 'base_addr'
     631 |   ioaddr = dev->base_addr;
         |               ^~
   drivers/net/ethernet/amd/nmclan_cs.c:676:18: error: 'struct net_device' has no member named 'base_addr'
     676 |               dev->base_addr, dev->irq, if_names[dev->if_port], dev->dev_addr);
         |                  ^~
   drivers/net/ethernet/amd/nmclan_cs.c: In function 'nmclan_reset':
   drivers/net/ethernet/amd/nmclan_cs.c:746:20: error: 'struct net_device' has no member named 'base_addr'
     746 |   mace_init(lp, dev->base_addr, dev->dev_addr);
         |                    ^~
   drivers/net/ethernet/amd/nmclan_cs.c:747:21: error: 'struct net_device' has no member named 'base_addr'
     747 |   mace_write(lp, dev->base_addr, MACE_IMR, MACE_IMR_DEFAULT);
         |                     ^~
   drivers/net/ethernet/amd/nmclan_cs.c: In function 'mace_open':
   drivers/net/ethernet/amd/nmclan_cs.c:777:28: error: 'struct net_device' has no member named 'base_addr'
     777 |   unsigned int ioaddr = dev->base_addr;
         |                            ^~
   drivers/net/ethernet/amd/nmclan_cs.c: In function 'mace_close':
   drivers/net/ethernet/amd/nmclan_cs.c:800:28: error: 'struct net_device' has no member named 'base_addr'
     800 |   unsigned int ioaddr = dev->base_addr;
         |                            ^~
   drivers/net/ethernet/amd/nmclan_cs.c: In function 'netdev_get_drvinfo':
   drivers/net/ethernet/amd/nmclan_cs.c:820:36: error: 'struct net_device' has no member named 'base_addr'
     820 |                 "PCMCIA 0x%lx", dev->base_addr);
         |                                    ^~
   drivers/net/ethernet/amd/nmclan_cs.c: In function 'mace_start_xmit':
   drivers/net/ethernet/amd/nmclan_cs.c:858:28: error: 'struct net_device' has no member named 'base_addr'
     858 |   unsigned int ioaddr = dev->base_addr;
         |                            ^~
   drivers/net/ethernet/amd/nmclan_cs.c: In function 'mace_interrupt':
   drivers/net/ethernet/amd/nmclan_cs.c:927:15: error: 'struct net_device' has no member named 'base_addr'
     927 |   ioaddr = dev->base_addr;
         |               ^~
   drivers/net/ethernet/amd/nmclan_cs.c: In function 'mace_rx':
   drivers/net/ethernet/amd/nmclan_cs.c:1062:28: error: 'struct net_device' has no member named 'base_addr'
    1062 |   unsigned int ioaddr = dev->base_addr;
         |                            ^~
   drivers/net/ethernet/amd/nmclan_cs.c: In function 'mace_get_stats':
   drivers/net/ethernet/amd/nmclan_cs.c:1271:19: error: 'struct net_device' has no member named 'base_addr'
    1271 |   update_stats(dev->base_addr, dev);
         |                   ^~
   drivers/net/ethernet/amd/nmclan_cs.c: In function 'restore_multicast_list':
   drivers/net/ethernet/amd/nmclan_cs.c:1453:28: error: 'struct net_device' has no member named 'base_addr'
    1453 |   unsigned int ioaddr = dev->base_addr;
         |                            ^~
--
   drivers/net/ethernet/xilinx/xilinx_emaclite.c: In function 'xemaclite_mdio_setup':
>> drivers/net/ethernet/xilinx/xilinx_emaclite.c:827:21: error: 'struct net_device' has no member named 'mem_start'
     827 |         if (lp->ndev->mem_start != res.start) {
         |                     ^~
   drivers/net/ethernet/xilinx/xilinx_emaclite.c: In function 'xemaclite_of_probe':
   drivers/net/ethernet/xilinx/xilinx_emaclite.c:1124:13: error: 'struct net_device' has no member named 'mem_start'
    1124 |         ndev->mem_start = res->start;
         |             ^~
>> drivers/net/ethernet/xilinx/xilinx_emaclite.c:1125:13: error: 'struct net_device' has no member named 'mem_end'
    1125 |         ndev->mem_end = res->end;
         |             ^~
   In file included from include/linux/device.h:15,
                    from include/linux/dma-mapping.h:7,
                    from include/linux/skbuff.h:28,
                    from include/net/net_namespace.h:43,
                    from include/linux/netdevice.h:38,
                    from drivers/net/ethernet/xilinx/xilinx_emaclite.c:12:
   drivers/net/ethernet/xilinx/xilinx_emaclite.c:1166:45: error: 'struct net_device' has no member named 'mem_start'
    1166 |                  (unsigned long __force)ndev->mem_start, lp->base_addr, ndev->irq);
         |                                             ^~
   include/linux/dev_printk.h:110:37: note: in definition of macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                                     ^~~~~~~~~~~
   drivers/net/ethernet/xilinx/xilinx_emaclite.c:1164:9: note: in expansion of macro 'dev_info'
    1164 |         dev_info(dev,
         |         ^~~~~~~~


vim +277 drivers/net/ethernet/3com/3c589_cs.c

^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  236  
15b99ac1729503 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2006-03-31  237  static int tc589_config(struct pcmcia_device *link)
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  238  {
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  239  	struct net_device *dev = link->priv;
dd0fab5b940c0b drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-24  240  	int ret, i, j, multi = 0, fifo;
923ca6f61887c9 drivers/net/ethernet/3com/3c589_cs.c Jakub Kicinski         2021-10-13  241  	__be16 addr[ETH_ALEN / 2];
906da809c5be30 drivers/net/pcmcia/3c589_cs.c        Olof Johansson         2008-02-04  242  	unsigned int ioaddr;
99101d3d8900dd drivers/net/pcmcia/3c589_cs.c        Joe Perches            2010-09-13  243  	static const char * const ram_split[] = {"5:3", "3:1", "1:1", "3:5"};
dddfbd824b96a2 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-18  244  	u8 *buf;
dddfbd824b96a2 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-18  245  	size_t len;
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  246  
dd0fab5b940c0b drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-24  247  	dev_dbg(&link->dev, "3c589_config\n");
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  248  
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  249  	/* Is this a 3c562? */
efd50585e2ff9b drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2006-10-25  250  	if (link->manf_id != MANFID_3COM)
636b8116d4e116 drivers/net/pcmcia/3c589_cs.c        Joe Perches            2010-08-12  251  		dev_info(&link->dev, "hmmm, is this really a 3Com card??\n");
efd50585e2ff9b drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2006-10-25  252  	multi = (link->card_id == PRODID_3COM_3C562);
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  253  
90abdc3b973229 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2010-07-24  254  	link->io_lines = 16;
90abdc3b973229 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2010-07-24  255  
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  256  	/* For the 3c562, the base address must be xx00-xx7f */
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  257  	for (i = j = 0; j < 0x400; j += 0x10) {
6df3efccee5f56 drivers/net/ethernet/3com/3c589_cs.c Justin van Wijngaarden 2014-02-17  258  		if (multi && (j & 0x80))
6df3efccee5f56 drivers/net/ethernet/3com/3c589_cs.c Justin van Wijngaarden 2014-02-17  259  			continue;
90abdc3b973229 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2010-07-24  260  		link->resource[0]->start = j ^ 0x300;
90abdc3b973229 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2010-07-24  261  		i = pcmcia_request_io(link);
4c89e88bfde6a3 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2008-08-03  262  		if (i == 0)
4c89e88bfde6a3 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2008-08-03  263  			break;
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  264  	}
dd0fab5b940c0b drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-24  265  	if (i != 0)
dd0fab5b940c0b drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-24  266  		goto failed;
dd0fab5b940c0b drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-24  267  
eb14120f743d29 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2010-03-07  268  	ret = pcmcia_request_irq(link, el3_interrupt);
dd0fab5b940c0b drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-24  269  	if (ret)
dd0fab5b940c0b drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-24  270  		goto failed;
dd0fab5b940c0b drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-24  271  
1ac71e5a35eebe drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2010-07-29  272  	ret = pcmcia_enable_device(link);
dd0fab5b940c0b drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-24  273  	if (ret)
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  274  		goto failed;
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  275  
eb14120f743d29 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2010-03-07  276  	dev->irq = link->irq;
9a017a910346af drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2010-07-24 @277  	dev->base_addr = link->resource[0]->start;
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  278  	ioaddr = dev->base_addr;
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  279  	EL3WINDOW(0);
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  280  
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  281  	/* The 3c589 has an extra EEPROM for configuration info, including
6df3efccee5f56 drivers/net/ethernet/3com/3c589_cs.c Justin van Wijngaarden 2014-02-17  282  	 * the hardware address.  The 3c562 puts the address in the CIS.
6df3efccee5f56 drivers/net/ethernet/3com/3c589_cs.c Justin van Wijngaarden 2014-02-17  283  	 */
dddfbd824b96a2 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-18  284  	len = pcmcia_get_tuple(link, 0x88, &buf);
dddfbd824b96a2 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-18  285  	if (buf && len >= 6) {
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  286  		for (i = 0; i < 3; i++)
923ca6f61887c9 drivers/net/ethernet/3com/3c589_cs.c Jakub Kicinski         2021-10-13  287  			addr[i] = htons(le16_to_cpu(buf[i*2]));
dddfbd824b96a2 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-18  288  		kfree(buf);
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  289  	} else {
dddfbd824b96a2 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-10-18  290  		kfree(buf); /* 0 < len < 6 */
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  291  		for (i = 0; i < 3; i++)
923ca6f61887c9 drivers/net/ethernet/3com/3c589_cs.c Jakub Kicinski         2021-10-13  292  			addr[i] = htons(read_eeprom(ioaddr, i));
923ca6f61887c9 drivers/net/ethernet/3com/3c589_cs.c Jakub Kicinski         2021-10-13  293  		if (addr[0] == htons(0x6060)) {
636b8116d4e116 drivers/net/pcmcia/3c589_cs.c        Joe Perches            2010-08-12  294  			dev_err(&link->dev, "IO port conflict at 0x%03lx-0x%03lx\n",
636b8116d4e116 drivers/net/pcmcia/3c589_cs.c        Joe Perches            2010-08-12  295  					dev->base_addr, dev->base_addr+15);
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  296  			goto failed;
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  297  		}
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  298  	}
923ca6f61887c9 drivers/net/ethernet/3com/3c589_cs.c Jakub Kicinski         2021-10-13  299  	eth_hw_addr_set(dev, (u8 *)addr);
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  300  
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  301  	/* The address and resource configuration register aren't loaded from
6df3efccee5f56 drivers/net/ethernet/3com/3c589_cs.c Justin van Wijngaarden 2014-02-17  302  	 * the EEPROM and *must* be set to 0 and IRQ3 for the PCMCIA version.
6df3efccee5f56 drivers/net/ethernet/3com/3c589_cs.c Justin van Wijngaarden 2014-02-17  303  	 */
6df3efccee5f56 drivers/net/ethernet/3com/3c589_cs.c Justin van Wijngaarden 2014-02-17  304  
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  305  	outw(0x3f00, ioaddr + 8);
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  306  	fifo = inl(ioaddr);
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  307  
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  308  	/* The if_port symbol can be set when the module is loaded */
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  309  	if ((if_port >= 0) && (if_port <= 3))
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  310  		dev->if_port = if_port;
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  311  	else
636b8116d4e116 drivers/net/pcmcia/3c589_cs.c        Joe Perches            2010-08-12  312  		dev_err(&link->dev, "invalid if_port requested\n");
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  313  
dd2e5a156525f1 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2009-11-03  314  	SET_NETDEV_DEV(dev, &link->dev);
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  315  
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  316  	if (register_netdev(dev) != 0) {
636b8116d4e116 drivers/net/pcmcia/3c589_cs.c        Joe Perches            2010-08-12  317  		dev_err(&link->dev, "register_netdev() failed\n");
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  318  		goto failed;
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  319  	}
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  320  
f64e96973a1fa8 drivers/net/pcmcia/3c589_cs.c        Alexander Kurz         2010-03-31  321  	netdev_info(dev, "3Com 3c%s, io %#3lx, irq %d, hw_addr %pM\n",
f64e96973a1fa8 drivers/net/pcmcia/3c589_cs.c        Alexander Kurz         2010-03-31  322  			(multi ? "562" : "589"), dev->base_addr, dev->irq,
e174961ca1a0b2 drivers/net/pcmcia/3c589_cs.c        Johannes Berg          2008-10-27  323  			dev->dev_addr);
f64e96973a1fa8 drivers/net/pcmcia/3c589_cs.c        Alexander Kurz         2010-03-31  324  	netdev_info(dev, "  %dK FIFO split %s Rx:Tx, %s xcvr\n",
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  325  			(fifo & 7) ? 32 : 8, ram_split[(fifo >> 16) & 3],
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  326  			if_names[dev->if_port]);
15b99ac1729503 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2006-03-31  327  	return 0;
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  328  
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  329  failed:
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  330  	tc589_release(link);
15b99ac1729503 drivers/net/pcmcia/3c589_cs.c        Dominik Brodowski      2006-03-31  331  	return -ENODEV;
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  332  } /* tc589_config */
^1da177e4c3f41 drivers/net/pcmcia/3c589_cs.c        Linus Torvalds         2005-04-16  333  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
