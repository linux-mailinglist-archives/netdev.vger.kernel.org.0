Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E778366EFB
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243928AbhDUPVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:21:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:35626 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240613AbhDUPVS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:21:18 -0400
IronPort-SDR: eOGRET8NM90IZvknRiz2/7ZhcyfW6Fh0rHicVEGJHd0ej+peeKGGxTEGENFKjMzjGPJ9FrVipA
 Il2BGyXBniCg==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="182846438"
X-IronPort-AV: E=Sophos;i="5.82,240,1613462400"; 
   d="gz'50?scan'50,208,50";a="182846438"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 08:20:44 -0700
IronPort-SDR: Iuj1/MUIiBwyqIE/Z7JpizZVI8216pVw882E+nWAcn/yChw+ieGj47IyVKBGHvfjsy8JxvNpTh
 gxukMNY3aoqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,240,1613462400"; 
   d="gz'50?scan'50,208,50";a="602924133"
Received: from lkp-server01.sh.intel.com (HELO a48ff7ddd223) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 21 Apr 2021 08:20:40 -0700
Received: from kbuild by a48ff7ddd223 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lZEed-0003eE-RN; Wed, 21 Apr 2021 15:20:39 +0000
Date:   Wed, 21 Apr 2021 23:19:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 3/3] asm-generic/io.h: Silence
 -Wnull-pointer-arithmetic warning on PCI_IOBASE
Message-ID: <202104212319.40Zv8JEe-lkp@intel.com>
References: <20210421111759.2059976-4-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20210421111759.2059976-4-schnelle@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Niklas,

I love your patch! Yet something to improve:

[auto build test ERROR on soc/for-next]
[also build test ERROR on asm-generic/master v5.12-rc8 next-20210421]
[cannot apply to arc/for-next sparc-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Niklas-Schnelle/asm-generic-io-h-Silence-Wnull-pointer-arithmetic-warning-on-PCI_IOBASE/20210421-192025
base:   https://git.kernel.org/pub/scm/linux/kernel/git/soc/soc.git for-next
config: riscv-nommu_k210_defconfig (attached as .config)
compiler: riscv64-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/05bc9b9b640336015712d139ebc42830d12a82da
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Niklas-Schnelle/asm-generic-io-h-Silence-Wnull-pointer-arithmetic-warning-on-PCI_IOBASE/20210421-192025
        git checkout 05bc9b9b640336015712d139ebc42830d12a82da
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross W=1 ARCH=riscv 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/riscv/include/asm/clint.h:10,
                    from arch/riscv/include/asm/timex.h:15,
                    from include/linux/timex.h:65,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from init/main.c:17:
   include/asm-generic/io.h: In function 'inb_p':
>> arch/riscv/include/asm/io.h:55:65: error: 'PCI_IOBASE' undeclared (first use in this function)
      55 | #define inb(c)  ({ u8  __v; __io_pbr(); __v = readb_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                                                 ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:87:48: note: in definition of macro 'readb_cpu'
      87 | #define readb_cpu(c)  ({ u8  __r = __raw_readb(c); __r; })
         |                                                ^
   include/asm-generic/io.h:579:9: note: in expansion of macro 'inb'
     579 |  return inb(addr);
         |         ^~~
   arch/riscv/include/asm/io.h:55:65: note: each undeclared identifier is reported only once for each function it appears in
      55 | #define inb(c)  ({ u8  __v; __io_pbr(); __v = readb_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                                                 ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:87:48: note: in definition of macro 'readb_cpu'
      87 | #define readb_cpu(c)  ({ u8  __r = __raw_readb(c); __r; })
         |                                                ^
   include/asm-generic/io.h:579:9: note: in expansion of macro 'inb'
     579 |  return inb(addr);
         |         ^~~
   In file included from include/linux/byteorder/little_endian.h:5,
                    from arch/riscv/include/uapi/asm/byteorder.h:10,
                    from include/asm-generic/bitops/le.h:6,
                    from arch/riscv/include/asm/bitops.h:202,
                    from include/linux/bitops.h:32,
                    from include/linux/kernel.h:11,
                    from include/linux/list.h:9,
                    from include/linux/module.h:12,
                    from init/main.c:17:
   include/asm-generic/io.h: In function 'inw_p':
   arch/riscv/include/asm/io.h:56:65: error: 'PCI_IOBASE' undeclared (first use in this function)
      56 | #define inw(c)  ({ u16 __v; __io_pbr(); __v = readw_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                                                 ^~~~~~~~~~
   include/uapi/linux/byteorder/little_endian.h:36:51: note: in definition of macro '__le16_to_cpu'
      36 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   arch/riscv/include/asm/io.h:56:47: note: in expansion of macro 'readw_cpu'
      56 | #define inw(c)  ({ u16 __v; __io_pbr(); __v = readw_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                               ^~~~~~~~~
   include/asm-generic/io.h:587:9: note: in expansion of macro 'inw'
     587 |  return inw(addr);
         |         ^~~
   include/asm-generic/io.h: In function 'inl_p':
   arch/riscv/include/asm/io.h:57:65: error: 'PCI_IOBASE' undeclared (first use in this function)
      57 | #define inl(c)  ({ u32 __v; __io_pbr(); __v = readl_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                                                 ^~~~~~~~~~
   include/uapi/linux/byteorder/little_endian.h:34:51: note: in definition of macro '__le32_to_cpu'
      34 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
         |                                                   ^
   arch/riscv/include/asm/io.h:57:47: note: in expansion of macro 'readl_cpu'
      57 | #define inl(c)  ({ u32 __v; __io_pbr(); __v = readl_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                               ^~~~~~~~~
   include/asm-generic/io.h:595:9: note: in expansion of macro 'inl'
     595 |  return inl(addr);
         |         ^~~
   In file included from arch/riscv/include/asm/clint.h:10,
                    from arch/riscv/include/asm/timex.h:15,
                    from include/linux/timex.h:65,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from init/main.c:17:
   include/asm-generic/io.h: In function 'outb_p':
   arch/riscv/include/asm/io.h:59:57: error: 'PCI_IOBASE' undeclared (first use in this function)
      59 | #define outb(v,c) ({ __io_pbw(); writeb_cpu((v),(void*)(PCI_IOBASE + (c))); __io_paw(); })
         |                                                         ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:91:52: note: in definition of macro 'writeb_cpu'
      91 | #define writeb_cpu(v, c) ((void)__raw_writeb((v), (c)))
         |                                                    ^
   include/asm-generic/io.h:603:2: note: in expansion of macro 'outb'
     603 |  outb(value, addr);
         |  ^~~~
   include/asm-generic/io.h: In function 'outw_p':
   arch/riscv/include/asm/io.h:60:57: error: 'PCI_IOBASE' undeclared (first use in this function)
      60 | #define outw(v,c) ({ __io_pbw(); writew_cpu((v),(void*)(PCI_IOBASE + (c))); __io_paw(); })
         |                                                         ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:92:76: note: in definition of macro 'writew_cpu'
      92 | #define writew_cpu(v, c) ((void)__raw_writew((__force u16)cpu_to_le16(v), (c)))
         |                                                                            ^
   include/asm-generic/io.h:611:2: note: in expansion of macro 'outw'
     611 |  outw(value, addr);
         |  ^~~~
   include/asm-generic/io.h: In function 'outl_p':
   arch/riscv/include/asm/io.h:61:57: error: 'PCI_IOBASE' undeclared (first use in this function)
      61 | #define outl(v,c) ({ __io_pbw(); writel_cpu((v),(void*)(PCI_IOBASE + (c))); __io_paw(); })
         |                                                         ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:93:76: note: in definition of macro 'writel_cpu'
      93 | #define writel_cpu(v, c) ((void)__raw_writel((__force u32)cpu_to_le32(v), (c)))
         |                                                                            ^
   include/asm-generic/io.h:619:2: note: in expansion of macro 'outl'
     619 |  outl(value, addr);
         |  ^~~~
   init/main.c: At top level:
   init/main.c:764:20: warning: no previous prototype for 'arch_post_acpi_subsys_init' [-Wmissing-prototypes]
     764 | void __init __weak arch_post_acpi_subsys_init(void) { }
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~
   init/main.c:776:20: warning: no previous prototype for 'mem_encrypt_init' [-Wmissing-prototypes]
     776 | void __init __weak mem_encrypt_init(void) { }
         |                    ^~~~~~~~~~~~~~~~
   init/main.c:778:20: warning: no previous prototype for 'poking_init' [-Wmissing-prototypes]
     778 | void __init __weak poking_init(void) { }
         |                    ^~~~~~~~~~~
--
   In file included from arch/riscv/include/asm/clint.h:10,
                    from arch/riscv/include/asm/timex.h:15,
                    from include/linux/timex.h:65,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from init/do_mounts.c:2:
   include/asm-generic/io.h: In function 'inb_p':
>> arch/riscv/include/asm/io.h:55:65: error: 'PCI_IOBASE' undeclared (first use in this function)
      55 | #define inb(c)  ({ u8  __v; __io_pbr(); __v = readb_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                                                 ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:87:48: note: in definition of macro 'readb_cpu'
      87 | #define readb_cpu(c)  ({ u8  __r = __raw_readb(c); __r; })
         |                                                ^
   include/asm-generic/io.h:579:9: note: in expansion of macro 'inb'
     579 |  return inb(addr);
         |         ^~~
   arch/riscv/include/asm/io.h:55:65: note: each undeclared identifier is reported only once for each function it appears in
      55 | #define inb(c)  ({ u8  __v; __io_pbr(); __v = readb_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                                                 ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:87:48: note: in definition of macro 'readb_cpu'
      87 | #define readb_cpu(c)  ({ u8  __r = __raw_readb(c); __r; })
         |                                                ^
   include/asm-generic/io.h:579:9: note: in expansion of macro 'inb'
     579 |  return inb(addr);
         |         ^~~
   In file included from include/linux/byteorder/little_endian.h:5,
                    from arch/riscv/include/uapi/asm/byteorder.h:10,
                    from include/asm-generic/bitops/le.h:6,
                    from arch/riscv/include/asm/bitops.h:202,
                    from include/linux/bitops.h:32,
                    from include/linux/kernel.h:11,
                    from include/linux/list.h:9,
                    from include/linux/module.h:12,
                    from init/do_mounts.c:2:
   include/asm-generic/io.h: In function 'inw_p':
   arch/riscv/include/asm/io.h:56:65: error: 'PCI_IOBASE' undeclared (first use in this function)
      56 | #define inw(c)  ({ u16 __v; __io_pbr(); __v = readw_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                                                 ^~~~~~~~~~
   include/uapi/linux/byteorder/little_endian.h:36:51: note: in definition of macro '__le16_to_cpu'
      36 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   arch/riscv/include/asm/io.h:56:47: note: in expansion of macro 'readw_cpu'
      56 | #define inw(c)  ({ u16 __v; __io_pbr(); __v = readw_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                               ^~~~~~~~~
   include/asm-generic/io.h:587:9: note: in expansion of macro 'inw'
     587 |  return inw(addr);
         |         ^~~
   include/asm-generic/io.h: In function 'inl_p':
   arch/riscv/include/asm/io.h:57:65: error: 'PCI_IOBASE' undeclared (first use in this function)
      57 | #define inl(c)  ({ u32 __v; __io_pbr(); __v = readl_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                                                 ^~~~~~~~~~
   include/uapi/linux/byteorder/little_endian.h:34:51: note: in definition of macro '__le32_to_cpu'
      34 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
         |                                                   ^
   arch/riscv/include/asm/io.h:57:47: note: in expansion of macro 'readl_cpu'
      57 | #define inl(c)  ({ u32 __v; __io_pbr(); __v = readl_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                               ^~~~~~~~~
   include/asm-generic/io.h:595:9: note: in expansion of macro 'inl'
     595 |  return inl(addr);
         |         ^~~
   In file included from arch/riscv/include/asm/clint.h:10,
                    from arch/riscv/include/asm/timex.h:15,
                    from include/linux/timex.h:65,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from init/do_mounts.c:2:
   include/asm-generic/io.h: In function 'outb_p':
   arch/riscv/include/asm/io.h:59:57: error: 'PCI_IOBASE' undeclared (first use in this function)
      59 | #define outb(v,c) ({ __io_pbw(); writeb_cpu((v),(void*)(PCI_IOBASE + (c))); __io_paw(); })
         |                                                         ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:91:52: note: in definition of macro 'writeb_cpu'
      91 | #define writeb_cpu(v, c) ((void)__raw_writeb((v), (c)))
         |                                                    ^
   include/asm-generic/io.h:603:2: note: in expansion of macro 'outb'
     603 |  outb(value, addr);
         |  ^~~~
   include/asm-generic/io.h: In function 'outw_p':
   arch/riscv/include/asm/io.h:60:57: error: 'PCI_IOBASE' undeclared (first use in this function)
      60 | #define outw(v,c) ({ __io_pbw(); writew_cpu((v),(void*)(PCI_IOBASE + (c))); __io_paw(); })
         |                                                         ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:92:76: note: in definition of macro 'writew_cpu'
      92 | #define writew_cpu(v, c) ((void)__raw_writew((__force u16)cpu_to_le16(v), (c)))
         |                                                                            ^
   include/asm-generic/io.h:611:2: note: in expansion of macro 'outw'
     611 |  outw(value, addr);
         |  ^~~~
   include/asm-generic/io.h: In function 'outl_p':
   arch/riscv/include/asm/io.h:61:57: error: 'PCI_IOBASE' undeclared (first use in this function)
      61 | #define outl(v,c) ({ __io_pbw(); writel_cpu((v),(void*)(PCI_IOBASE + (c))); __io_paw(); })
         |                                                         ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:93:76: note: in definition of macro 'writel_cpu'
      93 | #define writel_cpu(v, c) ((void)__raw_writel((__force u32)cpu_to_le32(v), (c)))
         |                                                                            ^
   include/asm-generic/io.h:619:2: note: in expansion of macro 'outl'
     619 |  outl(value, addr);
         |  ^~~~
--
   In file included from arch/riscv/include/asm/clint.h:10,
                    from arch/riscv/include/asm/timex.h:15,
                    from include/linux/timex.h:65,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/ktime.h:24,
                    from include/linux/timer.h:6,
                    from include/linux/workqueue.h:9,
                    from include/linux/rhashtable-types.h:15,
                    from include/linux/ipc.h:7,
                    from include/uapi/linux/sem.h:5,
                    from include/linux/sem.h:5,
                    from include/linux/sched.h:15,
                    from include/linux/uaccess.h:8,
                    from arch/riscv/kernel/signal.c:10:
   include/asm-generic/io.h: In function 'inb_p':
>> arch/riscv/include/asm/io.h:55:65: error: 'PCI_IOBASE' undeclared (first use in this function)
      55 | #define inb(c)  ({ u8  __v; __io_pbr(); __v = readb_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                                                 ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:87:48: note: in definition of macro 'readb_cpu'
      87 | #define readb_cpu(c)  ({ u8  __r = __raw_readb(c); __r; })
         |                                                ^
   include/asm-generic/io.h:579:9: note: in expansion of macro 'inb'
     579 |  return inb(addr);
         |         ^~~
   arch/riscv/include/asm/io.h:55:65: note: each undeclared identifier is reported only once for each function it appears in
      55 | #define inb(c)  ({ u8  __v; __io_pbr(); __v = readb_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                                                 ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:87:48: note: in definition of macro 'readb_cpu'
      87 | #define readb_cpu(c)  ({ u8  __r = __raw_readb(c); __r; })
         |                                                ^
   include/asm-generic/io.h:579:9: note: in expansion of macro 'inb'
     579 |  return inb(addr);
         |         ^~~
   In file included from include/linux/byteorder/little_endian.h:5,
                    from arch/riscv/include/uapi/asm/byteorder.h:10,
                    from include/asm-generic/bitops/le.h:6,
                    from arch/riscv/include/asm/bitops.h:202,
                    from include/linux/bitops.h:32,
                    from include/linux/kernel.h:11,
                    from include/asm-generic/bug.h:20,
                    from arch/riscv/include/asm/bug.h:83,
                    from include/linux/bug.h:5,
                    from include/linux/signal.h:5,
                    from arch/riscv/kernel/signal.c:9:
   include/asm-generic/io.h: In function 'inw_p':
   arch/riscv/include/asm/io.h:56:65: error: 'PCI_IOBASE' undeclared (first use in this function)
      56 | #define inw(c)  ({ u16 __v; __io_pbr(); __v = readw_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                                                 ^~~~~~~~~~
   include/uapi/linux/byteorder/little_endian.h:36:51: note: in definition of macro '__le16_to_cpu'
      36 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   arch/riscv/include/asm/io.h:56:47: note: in expansion of macro 'readw_cpu'
      56 | #define inw(c)  ({ u16 __v; __io_pbr(); __v = readw_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                               ^~~~~~~~~
   include/asm-generic/io.h:587:9: note: in expansion of macro 'inw'
     587 |  return inw(addr);
         |         ^~~
   include/asm-generic/io.h: In function 'inl_p':
   arch/riscv/include/asm/io.h:57:65: error: 'PCI_IOBASE' undeclared (first use in this function)
      57 | #define inl(c)  ({ u32 __v; __io_pbr(); __v = readl_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                                                 ^~~~~~~~~~
   include/uapi/linux/byteorder/little_endian.h:34:51: note: in definition of macro '__le32_to_cpu'
      34 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
         |                                                   ^
   arch/riscv/include/asm/io.h:57:47: note: in expansion of macro 'readl_cpu'
      57 | #define inl(c)  ({ u32 __v; __io_pbr(); __v = readl_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
         |                                               ^~~~~~~~~
   include/asm-generic/io.h:595:9: note: in expansion of macro 'inl'
     595 |  return inl(addr);
         |         ^~~
   In file included from arch/riscv/include/asm/clint.h:10,
                    from arch/riscv/include/asm/timex.h:15,
                    from include/linux/timex.h:65,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/ktime.h:24,
                    from include/linux/timer.h:6,
                    from include/linux/workqueue.h:9,
                    from include/linux/rhashtable-types.h:15,
                    from include/linux/ipc.h:7,
                    from include/uapi/linux/sem.h:5,
                    from include/linux/sem.h:5,
                    from include/linux/sched.h:15,
                    from include/linux/uaccess.h:8,
                    from arch/riscv/kernel/signal.c:10:
   include/asm-generic/io.h: In function 'outb_p':
   arch/riscv/include/asm/io.h:59:57: error: 'PCI_IOBASE' undeclared (first use in this function)
      59 | #define outb(v,c) ({ __io_pbw(); writeb_cpu((v),(void*)(PCI_IOBASE + (c))); __io_paw(); })
         |                                                         ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:91:52: note: in definition of macro 'writeb_cpu'
      91 | #define writeb_cpu(v, c) ((void)__raw_writeb((v), (c)))
         |                                                    ^
   include/asm-generic/io.h:603:2: note: in expansion of macro 'outb'
     603 |  outb(value, addr);
         |  ^~~~
   include/asm-generic/io.h: In function 'outw_p':
   arch/riscv/include/asm/io.h:60:57: error: 'PCI_IOBASE' undeclared (first use in this function)
      60 | #define outw(v,c) ({ __io_pbw(); writew_cpu((v),(void*)(PCI_IOBASE + (c))); __io_paw(); })
         |                                                         ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:92:76: note: in definition of macro 'writew_cpu'
      92 | #define writew_cpu(v, c) ((void)__raw_writew((__force u16)cpu_to_le16(v), (c)))
         |                                                                            ^
   include/asm-generic/io.h:611:2: note: in expansion of macro 'outw'
     611 |  outw(value, addr);
         |  ^~~~
   include/asm-generic/io.h: In function 'outl_p':
   arch/riscv/include/asm/io.h:61:57: error: 'PCI_IOBASE' undeclared (first use in this function)
      61 | #define outl(v,c) ({ __io_pbw(); writel_cpu((v),(void*)(PCI_IOBASE + (c))); __io_paw(); })
         |                                                         ^~~~~~~~~~
   arch/riscv/include/asm/mmio.h:93:76: note: in definition of macro 'writel_cpu'
      93 | #define writel_cpu(v, c) ((void)__raw_writel((__force u32)cpu_to_le32(v), (c)))
         |                                                                            ^
   include/asm-generic/io.h:619:2: note: in expansion of macro 'outl'
     619 |  outl(value, addr);
         |  ^~~~
   arch/riscv/kernel/signal.c: At top level:
..


vim +/PCI_IOBASE +55 arch/riscv/include/asm/io.h

fab957c11efe2f Palmer Dabbelt 2017-07-10  54  
ce246c444a08e0 Will Deacon    2019-02-22 @55  #define inb(c)		({ u8  __v; __io_pbr(); __v = readb_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
ce246c444a08e0 Will Deacon    2019-02-22  56  #define inw(c)		({ u16 __v; __io_pbr(); __v = readw_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
ce246c444a08e0 Will Deacon    2019-02-22  57  #define inl(c)		({ u32 __v; __io_pbr(); __v = readl_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })
fab957c11efe2f Palmer Dabbelt 2017-07-10  58  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--yrj/dFKFPuw6o+aM
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--yrj/dFKFPuw6o+aM--
