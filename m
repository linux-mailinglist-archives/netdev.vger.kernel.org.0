Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A663DF519
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 21:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239376AbhHCTEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 15:04:16 -0400
Received: from mga18.intel.com ([134.134.136.126]:42513 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239363AbhHCTEQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 15:04:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="200949070"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="gz'50?scan'50,208,50";a="200949070"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 12:04:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="gz'50?scan'50,208,50";a="419146833"
Received: from lkp-server01.sh.intel.com (HELO d053b881505b) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 03 Aug 2021 12:03:56 -0700
Received: from kbuild by d053b881505b with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mAzhk-000ED3-1c; Tue, 03 Aug 2021 19:03:56 +0000
Date:   Wed, 4 Aug 2021 03:03:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     clang-built-linux@googlegroups.com, kbuild-all@lists.01.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net-next 1/2] net: make
 switchdev_bridge_port_{,unoffload} loosely coupled with the bridge
Message-ID: <202108040250.l7q8RQW4-lkp@intel.com>
References: <20210803143624.1135002-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <20210803143624.1135002-2-vladimir.oltean@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Vladimir,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Vladimir-Oltean/Convert-switchdev_bridge_port_-un-offload-to-notifiers/20210803-223837
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git c8f6c77d06fe6147d07cb0e4952db008f72767cb
config: s390-randconfig-r014-20210803 (attached as .config)
compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 4f71f59bf3d9914188a11d0c41bedbb339d36ff5)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/0day-ci/linux/commit/9be67f3f310145283841b1483fd5323e5d88132f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Vladimir-Oltean/Convert-switchdev_bridge_port_-un-offload-to-notifiers/20210803-223837
        git checkout 9be67f3f310145283841b1483fd5323e5d88132f
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=s390 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from net/bridge/br.c:12:
   In file included from include/linux/netdevice.h:37:
   In file included from include/net/net_namespace.h:40:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from net/bridge/br.c:12:
   In file included from include/linux/netdevice.h:37:
   In file included from include/net/net_namespace.h:40:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from net/bridge/br.c:12:
   In file included from include/linux/netdevice.h:37:
   In file included from include/net/net_namespace.h:40:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:501:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:511:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:521:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:609:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:617:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:625:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:634:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:643:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:652:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   In file included from net/bridge/br.c:20:
>> net/bridge/br_private.h:1938:2: error: void function 'br_switchdev_port_unoffload' should not return a value [-Wreturn-type]
           return -EOPNOTSUPP;
           ^      ~~~~~~~~~~~
   12 warnings and 1 error generated.
--
   In file included from net/bridge/br_fdb.c:15:
   In file included from include/linux/netdevice.h:37:
   In file included from include/net/net_namespace.h:40:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from net/bridge/br_fdb.c:15:
   In file included from include/linux/netdevice.h:37:
   In file included from include/net/net_namespace.h:40:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from net/bridge/br_fdb.c:15:
   In file included from include/linux/netdevice.h:37:
   In file included from include/net/net_namespace.h:40:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:501:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:511:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:521:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:609:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:617:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:625:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:634:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:643:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:652:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   In file included from net/bridge/br_fdb.c:24:
   In file included from include/trace/events/bridge.h:10:
>> include/trace/events/../../../net/bridge/br_private.h:1938:2: error: void function 'br_switchdev_port_unoffload' should not return a value [-Wreturn-type]
           return -EOPNOTSUPP;
           ^      ~~~~~~~~~~~
   12 warnings and 1 error generated.
--
   In file included from net/core/net-traces.c:8:
   In file included from include/linux/netdevice.h:37:
   In file included from include/net/net_namespace.h:40:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from net/core/net-traces.c:8:
   In file included from include/linux/netdevice.h:37:
   In file included from include/net/net_namespace.h:40:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from net/core/net-traces.c:8:
   In file included from include/linux/netdevice.h:37:
   In file included from include/net/net_namespace.h:40:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:501:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:511:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:521:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:609:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:617:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:625:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:634:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:643:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:652:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   In file included from net/core/net-traces.c:39:
   In file included from include/trace/events/bridge.h:10:
>> include/trace/events/../../../net/bridge/br_private.h:1938:2: error: void function 'br_switchdev_port_unoffload' should not return a value [-Wreturn-type]
           return -EOPNOTSUPP;
           ^      ~~~~~~~~~~~
   In file included from net/core/net-traces.c:50:
   In file included from include/trace/events/neigh.h:255:
   In file included from include/trace/define_trace.h:102:
   In file included from include/trace/trace_events.h:738:
   include/trace/events/neigh.h:42:20: warning: variable 'pin6' set but not used [-Wunused-but-set-variable]
                   struct in6_addr *pin6;
                                    ^
   13 warnings and 1 error generated.


vim +/br_switchdev_port_unoffload +1938 net/bridge/br_private.h

  1932	
  1933	static inline void
  1934	br_switchdev_port_unoffload(struct net_bridge_port *p, const void *ctx,
  1935				    struct notifier_block *atomic_nb,
  1936				    struct notifier_block *blocking_nb)
  1937	{
> 1938		return -EOPNOTSUPP;
  1939	}
  1940	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--d6Gm4EdcadzBjdND
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--d6Gm4EdcadzBjdND--
