Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B116AA913
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 11:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjCDKQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 05:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjCDKQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 05:16:55 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569A11498E
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 02:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677925012; x=1709461012;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P1wkPjxcmiyE7CsMBstlYB9OyRv3JTbll2wLBdIKMaM=;
  b=XX8wRxm0k3NPg0f8MnzrxZcQn9PJaAmEiSbNb7ytSOF8coSDF6GFsR5d
   0E1nPMSW9+9KjnnEJNHBwXp6eul/0JqceEmoqz+5MMexCoreglD5Qyo9u
   D23aoWooUV/PJ6A0MB5oFr+a4FW5b11gfX4gNWjx9rZigIN+S37zQPSqB
   ZyFZtST9s03Ph7ksD33thkRfopc9mbS/DoiiTIxY3HZOgHA11FcTgjn9J
   wClNXrkg9aCAyA9HthScWouVI7xoDc+ER23Dc3B3hJIOA7acpC+CwTE0p
   jHwudOBz9o8T4ieKN+XwIukR8WgjVbe98+pHALbwPv3TSq8weFIi+kx0H
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="333969093"
X-IronPort-AV: E=Sophos;i="5.98,233,1673942400"; 
   d="scan'208";a="333969093"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2023 02:16:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="1004856500"
X-IronPort-AV: E=Sophos;i="5.98,233,1673942400"; 
   d="scan'208";a="1004856500"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 04 Mar 2023 02:16:49 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pYOwa-00024T-3C;
        Sat, 04 Mar 2023 10:16:48 +0000
Date:   Sat, 4 Mar 2023 18:16:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: Re: [PATCH v2] netdevice: use ifmap instead of plain fields
Message-ID: <202303041847.nRrrz1v9-lkp@intel.com>
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
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vincenzo-Palazzo/netdevice-use-ifmap-instead-of-plain-fields/20230304-021243
patch link:    https://lore.kernel.org/r/20230303180926.142107-1-vincenzopalazzodev%40gmail.com
patch subject: [PATCH v2] netdevice: use ifmap instead of plain fields
config: s390-randconfig-r015-20230302 (https://download.01.org/0day-ci/archive/20230304/202303041847.nRrrz1v9-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/51cc3d72ba492238269006f1dc11209ac772ba0a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vincenzo-Palazzo/netdevice-use-ifmap-instead-of-plain-fields/20230304-021243
        git checkout 51cc3d72ba492238269006f1dc11209ac772ba0a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash drivers/net/arcnet/ drivers/net/ethernet/davicom/ drivers/net/ethernet/packetengines/ drivers/net/ethernet/smsc/ drivers/net/ethernet/ti/ drivers/net/fddi/skfp/ drivers/net/wan/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303041847.nRrrz1v9-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/net/arcnet/com20020_cs.c:44:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from drivers/net/arcnet/com20020_cs.c:44:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from drivers/net/arcnet/com20020_cs.c:44:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> drivers/net/arcnet/com20020_cs.c:232:16: error: no member named 'base_addr' in 'struct net_device'
           ioaddr = dev->base_addr = link->resource[0]->start;
                    ~~~  ^
   drivers/net/arcnet/com20020_cs.c:268:11: error: no member named 'base_addr' in 'struct net_device'
                      dev->base_addr, dev->irq);
                      ~~~  ^
   include/net/net_debug.h:66:46: note: expanded from macro 'netdev_dbg'
                   netdev_printk(KERN_DEBUG, __dev, format, ##args); \
                                                              ^~~~
   drivers/net/arcnet/com20020_cs.c:300:21: error: no member named 'base_addr' in 'struct net_device'
                   int ioaddr = dev->base_addr;
                                ~~~  ^
   12 warnings and 3 errors generated.
--
   In file included from drivers/net/wan/pci200syn.c:27:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from drivers/net/wan/pci200syn.c:27:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from drivers/net/wan/pci200syn.c:27:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> drivers/net/wan/pci200syn.c:376:8: error: no member named 'mem_start' in 'struct net_device'
                   dev->mem_start = ramphys;
                   ~~~  ^
>> drivers/net/wan/pci200syn.c:377:8: error: no member named 'mem_end' in 'struct net_device'
                   dev->mem_end = ramphys + ramsize - 1;
                   ~~~  ^
   12 warnings and 2 errors generated.
--
   In file included from drivers/net/wan/pc300too.c:31:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from drivers/net/wan/pc300too.c:31:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from drivers/net/wan/pc300too.c:31:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> drivers/net/wan/pc300too.c:437:8: error: no member named 'mem_start' in 'struct net_device'
                   dev->mem_start = ramphys;
                   ~~~  ^
>> drivers/net/wan/pc300too.c:438:8: error: no member named 'mem_end' in 'struct net_device'
                   dev->mem_end = ramphys + ramsize - 1;
                   ~~~  ^
   12 warnings and 2 errors generated.
--
   In file included from drivers/net/ethernet/davicom/dm9000.c:15:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from drivers/net/ethernet/davicom/dm9000.c:15:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from drivers/net/ethernet/davicom/dm9000.c:15:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> drivers/net/ethernet/davicom/dm9000.c:1572:8: error: no member named 'base_addr' in 'struct net_device'
           ndev->base_addr = (unsigned long)db->io_addr;
           ~~~~  ^
   12 warnings and 1 error generated.
..


vim +232 drivers/net/arcnet/com20020_cs.c

^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  194  
15b99ac1729503d drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2006-03-31  195  static int com20020_config(struct pcmcia_device *link)
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  196  {
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  197  	struct arcnet_local *lp;
2dfd2533e9e7006 drivers/net/arcnet/com20020_cs.c Himangi Saraogi   2014-08-09  198  	struct com20020_dev *info;
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  199  	struct net_device *dev;
dd0fab5b940c0b6 drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2009-10-24  200  	int i, ret;
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  201  	int ioaddr;
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  202  
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  203  	info = link->priv;
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  204  	dev = info->dev;
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  205  
dd0fab5b940c0b6 drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2009-10-24  206  	dev_dbg(&link->dev, "config...\n");
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  207  
dd0fab5b940c0b6 drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2009-10-24  208  	dev_dbg(&link->dev, "com20020_config\n");
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  209  
90abdc3b973229b drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2010-07-24  210  	dev_dbg(&link->dev, "baseport1 is %Xh\n",
90abdc3b973229b drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2010-07-24  211  		(unsigned int)link->resource[0]->start);
90abdc3b973229b drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2010-07-24  212  
4c89e88bfde6a3c drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2008-08-03  213  	i = -ENODEV;
90abdc3b973229b drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2010-07-24  214  	link->io_lines = 16;
90abdc3b973229b drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2010-07-24  215  
7f5e760c1b26904 drivers/net/arcnet/com20020_cs.c Joe Perches       2015-05-05  216  	if (!link->resource[0]->start) {
7f5e760c1b26904 drivers/net/arcnet/com20020_cs.c Joe Perches       2015-05-05  217  		for (ioaddr = 0x100; ioaddr < 0x400; ioaddr += 0x10) {
90abdc3b973229b drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2010-07-24  218  			link->resource[0]->start = ioaddr;
90abdc3b973229b drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2010-07-24  219  			i = pcmcia_request_io(link);
4c89e88bfde6a3c drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2008-08-03  220  			if (i == 0)
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  221  				break;
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  222  		}
7f5e760c1b26904 drivers/net/arcnet/com20020_cs.c Joe Perches       2015-05-05  223  	} else {
90abdc3b973229b drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2010-07-24  224  		i = pcmcia_request_io(link);
7f5e760c1b26904 drivers/net/arcnet/com20020_cs.c Joe Perches       2015-05-05  225  	}
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  226  
7f5e760c1b26904 drivers/net/arcnet/com20020_cs.c Joe Perches       2015-05-05  227  	if (i != 0) {
dd0fab5b940c0b6 drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2009-10-24  228  		dev_dbg(&link->dev, "requestIO failed totally!\n");
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  229  		goto failed;
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  230  	}
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  231  
9a017a910346afd drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2010-07-24 @232  	ioaddr = dev->base_addr = link->resource[0]->start;
dd0fab5b940c0b6 drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2009-10-24  233  	dev_dbg(&link->dev, "got ioaddr %Xh\n", ioaddr);
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  234  
5fa9167a1bf5f5a drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2009-11-08  235  	dev_dbg(&link->dev, "request IRQ %d\n",
eb14120f743d297 drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2010-03-07  236  		link->irq);
7f5e760c1b26904 drivers/net/arcnet/com20020_cs.c Joe Perches       2015-05-05  237  	if (!link->irq) {
dd0fab5b940c0b6 drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2009-10-24  238  		dev_dbg(&link->dev, "requestIRQ failed totally!\n");
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  239  		goto failed;
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  240  	}
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  241  
eb14120f743d297 drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2010-03-07  242  	dev->irq = link->irq;
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  243  
1ac71e5a35eebee drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2010-07-29  244  	ret = pcmcia_enable_device(link);
dd0fab5b940c0b6 drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2009-10-24  245  	if (ret)
dd0fab5b940c0b6 drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2009-10-24  246  		goto failed;
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  247  
7f5e760c1b26904 drivers/net/arcnet/com20020_cs.c Joe Perches       2015-05-05  248  	if (com20020_check(dev)) {
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  249  		regdump(dev);
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  250  		goto failed;
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  251  	}
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  252  
4cf1653aa90c632 drivers/net/pcmcia/com20020_cs.c Wang Chen         2008-11-12  253  	lp = netdev_priv(dev);
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  254  	lp->card_name = "PCMCIA COM20020";
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  255  	lp->card_flags = ARC_CAN_10MBIT; /* pretend all of them can 10Mbit */
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  256  
dd2e5a156525f11 drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2009-11-03  257  	SET_NETDEV_DEV(dev, &link->dev);
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  258  
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  259  	i = com20020_found(dev, 0);	/* calls register_netdev */
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  260  
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  261  	if (i != 0) {
636b8116d4e116e drivers/net/pcmcia/com20020_cs.c Joe Perches       2010-08-12  262  		dev_notice(&link->dev,
636b8116d4e116e drivers/net/pcmcia/com20020_cs.c Joe Perches       2010-08-12  263  			   "com20020_found() failed\n");
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  264  		goto failed;
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  265  	}
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  266  
636b8116d4e116e drivers/net/pcmcia/com20020_cs.c Joe Perches       2010-08-12  267  	netdev_dbg(dev, "port %#3lx, irq %d\n",
636b8116d4e116e drivers/net/pcmcia/com20020_cs.c Joe Perches       2010-08-12  268  		   dev->base_addr, dev->irq);
15b99ac1729503d drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2006-03-31  269  	return 0;
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  270  
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  271  failed:
dd0fab5b940c0b6 drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2009-10-24  272  	dev_dbg(&link->dev, "com20020_config failed...\n");
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  273  	com20020_release(link);
15b99ac1729503d drivers/net/pcmcia/com20020_cs.c Dominik Brodowski 2006-03-31  274  	return -ENODEV;
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  275  } /* com20020_config */
^1da177e4c3f415 drivers/net/pcmcia/com20020_cs.c Linus Torvalds    2005-04-16  276  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
