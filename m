Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624892852EF
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 22:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgJFUKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 16:10:32 -0400
Received: from mga07.intel.com ([134.134.136.100]:17887 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727181AbgJFUKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 16:10:31 -0400
IronPort-SDR: AX5kZz0tVcbSKxeaaOE1pVt7Si9ncedopKFPbtbIxKbeagZbtRzBjvTlsl2d9xpCZZfkL90M9X
 /GCCzODFsRGw==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="228806207"
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="gz'50?scan'50,208,50";a="228806207"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 13:10:24 -0700
IronPort-SDR: +7050oZiR0YVpGzBkU1Z830evRLSAyMKJLKpHn+Wdm0oNOu7RTMD4eQMn1e3o8CNMICSk2hhSP
 vY2kGzZdDdbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="gz'50?scan'50,208,50";a="418363367"
Received: from lkp-server02.sh.intel.com (HELO b5ae2f167493) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 06 Oct 2020 13:10:20 -0700
Received: from kbuild by b5ae2f167493 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kPtHv-0001Jb-G6; Tue, 06 Oct 2020 20:10:19 +0000
Date:   Wed, 7 Oct 2020 04:09:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com
Subject: Re: [PATCH bpf-next V1 5/6] bpf: Add MTU check for TC-BPF packets
 after egress hook
Message-ID: <202010070454.BOMR9UZ5-lkp@intel.com>
References: <160200019184.719143.17780588544420986957.stgit@firesoul>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <160200019184.719143.17780588544420986957.stgit@firesoul>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jesper,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Jesper-Dangaard-Brouer/bpf-New-approach-for-BPF-MTU-handling-and-enforcement/20201007-000903
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: s390-randconfig-r026-20201006 (attached as .config)
compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project 1127662c6dc2a276839c75a42238b11a3ad00f32)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/0day-ci/linux/commit/2065cee7d6b74c8f1dabae4e4e15999a841e3349
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jesper-Dangaard-Brouer/bpf-New-approach-for-BPF-MTU-handling-and-enforcement/20201007-000903
        git checkout 2065cee7d6b74c8f1dabae4e4e15999a841e3349
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=s390 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from arch/s390/include/asm/io.h:72:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:119:21: note: expanded from macro '__swab32'
           ___constant_swab32(x) :                 \
                              ^
   include/uapi/linux/swab.h:20:12: note: expanded from macro '___constant_swab32'
           (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) |            \
                     ^
   In file included from net/core/dev.c:89:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:11:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:72:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:119:21: note: expanded from macro '__swab32'
           ___constant_swab32(x) :                 \
                              ^
   include/uapi/linux/swab.h:21:12: note: expanded from macro '___constant_swab32'
           (((__u32)(x) & (__u32)0x00ff0000UL) >>  8) |            \
                     ^
   In file included from net/core/dev.c:89:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:11:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:72:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:119:21: note: expanded from macro '__swab32'
           ___constant_swab32(x) :                 \
                              ^
   include/uapi/linux/swab.h:22:12: note: expanded from macro '___constant_swab32'
           (((__u32)(x) & (__u32)0xff000000UL) >> 24)))
                     ^
   In file included from net/core/dev.c:89:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:11:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:72:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:120:12: note: expanded from macro '__swab32'
           __fswab32(x))
                     ^
   In file included from net/core/dev.c:89:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:11:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:72:
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
   net/core/dev.c:4068:7: warning: unused variable 'mtu_check' [-Wunused-variable]
           bool mtu_check = false;
                ^
>> net/core/dev.c:4176:1: warning: unused label 'drop' [-Wunused-label]
   drop:
   ^~~~~
   net/core/dev.c:4949:1: warning: unused function 'sch_handle_ingress' [-Wunused-function]
   sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
   ^
   net/core/dev.c:5094:19: warning: unused function 'nf_ingress' [-Wunused-function]
   static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
                     ^
   In file included from net/core/dev.c:71:
   In file included from include/linux/uaccess.h:6:
   In file included from include/linux/sched.h:14:
   In file included from include/linux/pid.h:5:
   In file included from include/linux/rculist.h:10:
   In file included from include/linux/list.h:9:
   In file included from include/linux/kernel.h:12:
   In file included from include/linux/bitops.h:29:
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
                           "oi     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:90:4: error: invalid operand in inline asm: 'ni	$0,${1:b}'
                           "ni     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:90:4: error: invalid operand in inline asm: 'ni	$0,${1:b}'
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
                           "oi     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:90:4: error: invalid operand in inline asm: 'ni	$0,${1:b}'
                           "ni     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:90:4: error: invalid operand in inline asm: 'ni	$0,${1:b}'
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
                           "oi     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
   arch/s390/include/asm/bitops.h:90:4: error: invalid operand in inline asm: 'ni	$0,${1:b}'
                           "ni     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
                           "oi     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
   arch/s390/include/asm/bitops.h:90:4: error: invalid operand in inline asm: 'ni	$0,${1:b}'
                           "ni     %0,%b1\n"
                           ^
   24 warnings and 14 errors generated.
--
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:11:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:72:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:119:21: note: expanded from macro '__swab32'
           ___constant_swab32(x) :                 \
                              ^
   include/uapi/linux/swab.h:20:12: note: expanded from macro '___constant_swab32'
           (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) |            \
                     ^
   In file included from net/core/dev.c:89:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:11:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:72:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:119:21: note: expanded from macro '__swab32'
           ___constant_swab32(x) :                 \
                              ^
   include/uapi/linux/swab.h:21:12: note: expanded from macro '___constant_swab32'
           (((__u32)(x) & (__u32)0x00ff0000UL) >>  8) |            \
                     ^
   In file included from net/core/dev.c:89:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:11:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:72:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:119:21: note: expanded from macro '__swab32'
           ___constant_swab32(x) :                 \
                              ^
   include/uapi/linux/swab.h:22:12: note: expanded from macro '___constant_swab32'
           (((__u32)(x) & (__u32)0xff000000UL) >> 24)))
                     ^
   In file included from net/core/dev.c:89:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:11:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:72:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:120:12: note: expanded from macro '__swab32'
           __fswab32(x))
                     ^
   In file included from net/core/dev.c:89:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:11:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:72:
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
>> net/core/dev.c:4176:1: warning: unused label 'drop' [-Wunused-label]
   drop:
   ^~~~~
   net/core/dev.c:4068:7: warning: unused variable 'mtu_check' [-Wunused-variable]
           bool mtu_check = false;
                ^
   net/core/dev.c:4949:1: warning: unused function 'sch_handle_ingress' [-Wunused-function]
   sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
   ^
   net/core/dev.c:5094:19: warning: unused function 'nf_ingress' [-Wunused-function]
   static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
                     ^
   In file included from net/core/dev.c:71:
   In file included from include/linux/uaccess.h:6:
   In file included from include/linux/sched.h:14:
   In file included from include/linux/pid.h:5:
   In file included from include/linux/rculist.h:10:
   In file included from include/linux/list.h:9:
   In file included from include/linux/kernel.h:12:
   In file included from include/linux/bitops.h:29:
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
                           "oi     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:90:4: error: invalid operand in inline asm: 'ni	$0,${1:b}'
                           "ni     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:90:4: error: invalid operand in inline asm: 'ni	$0,${1:b}'
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
                           "oi     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:90:4: error: invalid operand in inline asm: 'ni	$0,${1:b}'
                           "ni     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:90:4: error: invalid operand in inline asm: 'ni	$0,${1:b}'
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
                           "oi     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
   arch/s390/include/asm/bitops.h:90:4: error: invalid operand in inline asm: 'ni	$0,${1:b}'
                           "ni     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
                           "oi     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
   arch/s390/include/asm/bitops.h:90:4: error: invalid operand in inline asm: 'ni	$0,${1:b}'
                           "ni     %0,%b1\n"
                           ^
   24 warnings and 14 errors generated.

vim +/drop +4176 net/core/dev.c

  4037	
  4038	/**
  4039	 *	__dev_queue_xmit - transmit a buffer
  4040	 *	@skb: buffer to transmit
  4041	 *	@sb_dev: suboordinate device used for L2 forwarding offload
  4042	 *
  4043	 *	Queue a buffer for transmission to a network device. The caller must
  4044	 *	have set the device and priority and built the buffer before calling
  4045	 *	this function. The function can be called from an interrupt.
  4046	 *
  4047	 *	A negative errno code is returned on a failure. A success does not
  4048	 *	guarantee the frame will be transmitted as it may be dropped due
  4049	 *	to congestion or traffic shaping.
  4050	 *
  4051	 * -----------------------------------------------------------------------------------
  4052	 *      I notice this method can also return errors from the queue disciplines,
  4053	 *      including NET_XMIT_DROP, which is a positive value.  So, errors can also
  4054	 *      be positive.
  4055	 *
  4056	 *      Regardless of the return value, the skb is consumed, so it is currently
  4057	 *      difficult to retry a send to this method.  (You can bump the ref count
  4058	 *      before sending to hold a reference for retry if you are careful.)
  4059	 *
  4060	 *      When calling this method, interrupts MUST be enabled.  This is because
  4061	 *      the BH enable code must have IRQs enabled so that it will not deadlock.
  4062	 *          --BLG
  4063	 */
  4064	static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
  4065	{
  4066		struct net_device *dev = skb->dev;
  4067		struct netdev_queue *txq;
  4068		bool mtu_check = false;
  4069		bool again = false;
  4070		struct Qdisc *q;
  4071		int rc = -ENOMEM;
  4072	
  4073		skb_reset_mac_header(skb);
  4074	
  4075		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
  4076			__skb_tstamp_tx(skb, NULL, skb->sk, SCM_TSTAMP_SCHED);
  4077	
  4078		/* Disable soft irqs for various locks below. Also
  4079		 * stops preemption for RCU.
  4080		 */
  4081		rcu_read_lock_bh();
  4082	
  4083		skb_update_prio(skb);
  4084	
  4085		qdisc_pkt_len_init(skb);
  4086	#ifdef CONFIG_NET_CLS_ACT
  4087		mtu_check = skb_is_redirected(skb);
  4088		skb->tc_at_ingress = 0;
  4089	# ifdef CONFIG_NET_EGRESS
  4090		if (static_branch_unlikely(&egress_needed_key)) {
  4091			unsigned int len_orig = skb->len;
  4092	
  4093			skb = sch_handle_egress(skb, &rc, dev);
  4094			if (!skb)
  4095				goto out;
  4096			/* BPF-prog ran and could have changed packet size beyond MTU */
  4097			if (rc == NET_XMIT_SUCCESS && skb->len > len_orig)
  4098				mtu_check = true;
  4099		}
  4100	# endif
  4101		/* MTU-check only happens on "last" net_device in a redirect sequence
  4102		 * (e.g. above sch_handle_egress can steal SKB and skb_do_redirect it
  4103		 * either ingress or egress to another device).
  4104		 */
  4105		if (mtu_check && !is_skb_forwardable(dev, skb)) {
  4106			rc = -EMSGSIZE;
  4107			goto drop;
  4108		}
  4109	#endif
  4110		/* If device/qdisc don't need skb->dst, release it right now while
  4111		 * its hot in this cpu cache.
  4112		 */
  4113		if (dev->priv_flags & IFF_XMIT_DST_RELEASE)
  4114			skb_dst_drop(skb);
  4115		else
  4116			skb_dst_force(skb);
  4117	
  4118		txq = netdev_core_pick_tx(dev, skb, sb_dev);
  4119		q = rcu_dereference_bh(txq->qdisc);
  4120	
  4121		trace_net_dev_queue(skb);
  4122		if (q->enqueue) {
  4123			rc = __dev_xmit_skb(skb, q, dev, txq);
  4124			goto out;
  4125		}
  4126	
  4127		/* The device has no queue. Common case for software devices:
  4128		 * loopback, all the sorts of tunnels...
  4129	
  4130		 * Really, it is unlikely that netif_tx_lock protection is necessary
  4131		 * here.  (f.e. loopback and IP tunnels are clean ignoring statistics
  4132		 * counters.)
  4133		 * However, it is possible, that they rely on protection
  4134		 * made by us here.
  4135	
  4136		 * Check this and shot the lock. It is not prone from deadlocks.
  4137		 *Either shot noqueue qdisc, it is even simpler 8)
  4138		 */
  4139		if (dev->flags & IFF_UP) {
  4140			int cpu = smp_processor_id(); /* ok because BHs are off */
  4141	
  4142			if (txq->xmit_lock_owner != cpu) {
  4143				if (dev_xmit_recursion())
  4144					goto recursion_alert;
  4145	
  4146				skb = validate_xmit_skb(skb, dev, &again);
  4147				if (!skb)
  4148					goto out;
  4149	
  4150				HARD_TX_LOCK(dev, txq, cpu);
  4151	
  4152				if (!netif_xmit_stopped(txq)) {
  4153					dev_xmit_recursion_inc();
  4154					skb = dev_hard_start_xmit(skb, dev, txq, &rc);
  4155					dev_xmit_recursion_dec();
  4156					if (dev_xmit_complete(rc)) {
  4157						HARD_TX_UNLOCK(dev, txq);
  4158						goto out;
  4159					}
  4160				}
  4161				HARD_TX_UNLOCK(dev, txq);
  4162				net_crit_ratelimited("Virtual device %s asks to queue packet!\n",
  4163						     dev->name);
  4164			} else {
  4165				/* Recursion is detected! It is possible,
  4166				 * unfortunately
  4167				 */
  4168	recursion_alert:
  4169				net_crit_ratelimited("Dead loop on virtual device %s, fix it urgently!\n",
  4170						     dev->name);
  4171			}
  4172		}
  4173	
  4174		rc = -ENETDOWN;
  4175		rcu_read_unlock_bh();
> 4176	drop:
  4177		atomic_long_inc(&dev->tx_dropped);
  4178		kfree_skb_list(skb);
  4179		return rc;
  4180	out:
  4181		rcu_read_unlock_bh();
  4182		return rc;
  4183	}
  4184	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--wRRV7LY7NUeQGEoC
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
pH+xM+p/A8LIm32uAQA=

--wRRV7LY7NUeQGEoC--
