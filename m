Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC85E368904
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 00:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236915AbhDVWaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 18:30:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:58649 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232844AbhDVWaN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 18:30:13 -0400
IronPort-SDR: h+CTnfKtdePObZ/RYKqR7hvh7gCh1e+EWEyQTpcVuAk29fq2JXP8ZHR3l2W4MfvrLvx7FvbbXj
 Tf7hLxYtgX8A==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="193866677"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="gz'50?scan'50,208,50";a="193866677"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 15:29:37 -0700
IronPort-SDR: FR9y5fctmKzor1eiBDlAVXnGacpqY0fTdlBi2SnigzKYXO7lGFNN6Vul1hMw2YQ3X4hz45pi1+
 Omqnxx5V2I6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="gz'50?scan'50,208,50";a="421540897"
Received: from lkp-server01.sh.intel.com (HELO a48ff7ddd223) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 22 Apr 2021 15:29:34 -0700
Received: from kbuild by a48ff7ddd223 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lZhpG-0004OF-0c; Thu, 22 Apr 2021 22:29:34 +0000
Date:   Fri, 23 Apr 2021 06:28:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tanner Love <tannerlove.kernel@gmail.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Subject: Re: [PATCH net-next 2/3] once: replace uses of
 __section(".data.once") with DO_ONCE_LITE(_IF)?
Message-ID: <202104230602.N3ksyBSy-lkp@intel.com>
References: <20210422194738.2175542-3-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20210422194738.2175542-3-tannerlove.kernel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tanner,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Tanner-Love/net-update-netdev_rx_csum_fault-print-dump-only-once/20210423-034958
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5d869070569a23aa909c6e7e9d010fc438a492ef
config: powerpc-randconfig-r011-20210421 (attached as .config)
compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project f5446b769a7929806f72256fccd4826d66502e59)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install powerpc cross compiling tool for clang build
        # apt-get install binutils-powerpc-linux-gnu
        # https://github.com/0day-ci/linux/commit/eaeb33f0f85f70fc4e5fbae1e2344e9c6867c840
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Tanner-Love/net-update-netdev_rx_csum_fault-print-dump-only-once/20210423-034958
        git checkout eaeb33f0f85f70fc4e5fbae1e2344e9c6867c840
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 ARCH=powerpc 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from kernel/bounds.c:10:
   In file included from include/linux/page-flags.h:10:
   In file included from include/linux/bug.h:5:
   In file included from arch/powerpc/include/asm/bug.h:109:
   In file included from include/asm-generic/bug.h:7:
   In file included from include/linux/once.h:6:
   In file included from include/linux/jump_label.h:249:
   In file included from include/linux/atomic.h:7:
   In file included from arch/powerpc/include/asm/atomic.h:11:
>> arch/powerpc/include/asm/cmpxchg.h:80:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   XCHG_GEN(u8, _local, "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:22:11: note: expanded from macro 'XCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:81:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   XCHG_GEN(u8, _relaxed, "cc");
   ^
   arch/powerpc/include/asm/cmpxchg.h:22:11: note: expanded from macro 'XCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:82:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   XCHG_GEN(u16, _local, "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:22:11: note: expanded from macro 'XCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:83:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   XCHG_GEN(u16, _relaxed, "cc");
   ^
   arch/powerpc/include/asm/cmpxchg.h:22:11: note: expanded from macro 'XCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
>> arch/powerpc/include/asm/cmpxchg.h:166:2: error: implicit declaration of function 'BUILD_BUG_ON_MSG' [-Werror,-Wimplicit-function-declaration]
           BUILD_BUG_ON_MSG(1, "Unsupported size for __xchg");
           ^
   arch/powerpc/include/asm/cmpxchg.h:185:2: error: implicit declaration of function 'BUILD_BUG_ON_MSG' [-Werror,-Wimplicit-function-declaration]
           BUILD_BUG_ON_MSG(1, "Unsupported size for __xchg_local");
           ^
   arch/powerpc/include/asm/cmpxchg.h:206:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u8, , PPC_ATOMIC_ENTRY_BARRIER, PPC_ATOMIC_EXIT_BARRIER, "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:207:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u8, _local, , , "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:208:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u8, _acquire, , PPC_ACQUIRE_BARRIER, "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:209:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u8, _relaxed, , , "cc");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:210:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u16, , PPC_ATOMIC_ENTRY_BARRIER, PPC_ATOMIC_EXIT_BARRIER, "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:211:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u16, _local, , , "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:212:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u16, _acquire, , PPC_ACQUIRE_BARRIER, "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:213:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u16, _relaxed, , , "cc");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:407:2: error: implicit declaration of function 'BUILD_BUG_ON_MSG' [-Werror,-Wimplicit-function-declaration]
           BUILD_BUG_ON_MSG(1, "Unsupported size for __cmpxchg");
           ^
   arch/powerpc/include/asm/cmpxchg.h:427:2: error: implicit declaration of function 'BUILD_BUG_ON_MSG' [-Werror,-Wimplicit-function-declaration]
           BUILD_BUG_ON_MSG(1, "Unsupported size for __cmpxchg_local");
           ^
   arch/powerpc/include/asm/cmpxchg.h:447:2: error: implicit declaration of function 'BUILD_BUG_ON_MSG' [-Werror,-Wimplicit-function-declaration]
           BUILD_BUG_ON_MSG(1, "Unsupported size for __cmpxchg_relaxed");
           ^
   arch/powerpc/include/asm/cmpxchg.h:467:2: error: implicit declaration of function 'BUILD_BUG_ON_MSG' [-Werror,-Wimplicit-function-declaration]
           BUILD_BUG_ON_MSG(1, "Unsupported size for __cmpxchg_acquire");
           ^
   In file included from kernel/bounds.c:10:
   In file included from include/linux/page-flags.h:10:
   In file included from include/linux/bug.h:5:
   In file included from arch/powerpc/include/asm/bug.h:109:
   In file included from include/asm-generic/bug.h:7:
   In file included from include/linux/once.h:6:
   In file included from include/linux/jump_label.h:249:
   In file included from include/linux/atomic.h:7:
   In file included from arch/powerpc/include/asm/atomic.h:11:
   In file included from arch/powerpc/include/asm/cmpxchg.h:526:
   In file included from include/asm-generic/cmpxchg-local.h:6:
   In file included from include/linux/irqflags.h:16:
   In file included from arch/powerpc/include/asm/irqflags.h:12:
   In file included from arch/powerpc/include/asm/hw_irq.h:12:
   In file included from arch/powerpc/include/asm/ptrace.h:264:
   In file included from include/linux/thread_info.h:59:
   In file included from arch/powerpc/include/asm/thread_info.h:13:
   In file included from arch/powerpc/include/asm/page.h:249:
>> arch/powerpc/include/asm/page_32.h:48:2: error: implicit declaration of function '__WARN' [-Werror,-Wimplicit-function-declaration]
           WARN_ON((unsigned long)addr & (L1_CACHE_BYTES - 1));
           ^
   arch/powerpc/include/asm/bug.h:87:4: note: expanded from macro 'WARN_ON'
                           __WARN();                               \
                           ^
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   20 errors generated.
--
   In file included from kernel/bounds.c:10:
   In file included from include/linux/page-flags.h:10:
   In file included from include/linux/bug.h:5:
   In file included from arch/powerpc/include/asm/bug.h:109:
   In file included from include/asm-generic/bug.h:7:
   In file included from include/linux/once.h:6:
   In file included from include/linux/jump_label.h:249:
   In file included from include/linux/atomic.h:7:
   In file included from arch/powerpc/include/asm/atomic.h:11:
>> arch/powerpc/include/asm/cmpxchg.h:80:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   XCHG_GEN(u8, _local, "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:22:11: note: expanded from macro 'XCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:81:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   XCHG_GEN(u8, _relaxed, "cc");
   ^
   arch/powerpc/include/asm/cmpxchg.h:22:11: note: expanded from macro 'XCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:82:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   XCHG_GEN(u16, _local, "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:22:11: note: expanded from macro 'XCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:83:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   XCHG_GEN(u16, _relaxed, "cc");
   ^
   arch/powerpc/include/asm/cmpxchg.h:22:11: note: expanded from macro 'XCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
>> arch/powerpc/include/asm/cmpxchg.h:166:2: error: implicit declaration of function 'BUILD_BUG_ON_MSG' [-Werror,-Wimplicit-function-declaration]
           BUILD_BUG_ON_MSG(1, "Unsupported size for __xchg");
           ^
   arch/powerpc/include/asm/cmpxchg.h:185:2: error: implicit declaration of function 'BUILD_BUG_ON_MSG' [-Werror,-Wimplicit-function-declaration]
           BUILD_BUG_ON_MSG(1, "Unsupported size for __xchg_local");
           ^
   arch/powerpc/include/asm/cmpxchg.h:206:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u8, , PPC_ATOMIC_ENTRY_BARRIER, PPC_ATOMIC_EXIT_BARRIER, "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:207:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u8, _local, , , "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:208:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u8, _acquire, , PPC_ACQUIRE_BARRIER, "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:209:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u8, _relaxed, , , "cc");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:210:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u16, , PPC_ATOMIC_ENTRY_BARRIER, PPC_ATOMIC_EXIT_BARRIER, "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:211:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u16, _local, , , "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:212:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u16, _acquire, , PPC_ACQUIRE_BARRIER, "memory");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:213:1: error: use of undeclared identifier 'BITS_PER_BYTE'
   CMPXCHG_GEN(u16, _relaxed, , , "cc");
   ^
   arch/powerpc/include/asm/cmpxchg.h:47:11: note: expanded from macro 'CMPXCHG_GEN'
           bitoff = BITOFF_CAL(sizeof(type), off);                 \
                    ^
   arch/powerpc/include/asm/cmpxchg.h:11:61: note: expanded from macro 'BITOFF_CAL'
   #define BITOFF_CAL(size, off)   ((sizeof(u32) - size - off) * BITS_PER_BYTE)
                                                                 ^
   arch/powerpc/include/asm/cmpxchg.h:407:2: error: implicit declaration of function 'BUILD_BUG_ON_MSG' [-Werror,-Wimplicit-function-declaration]
           BUILD_BUG_ON_MSG(1, "Unsupported size for __cmpxchg");
           ^
   arch/powerpc/include/asm/cmpxchg.h:427:2: error: implicit declaration of function 'BUILD_BUG_ON_MSG' [-Werror,-Wimplicit-function-declaration]
           BUILD_BUG_ON_MSG(1, "Unsupported size for __cmpxchg_local");
           ^
   arch/powerpc/include/asm/cmpxchg.h:447:2: error: implicit declaration of function 'BUILD_BUG_ON_MSG' [-Werror,-Wimplicit-function-declaration]
           BUILD_BUG_ON_MSG(1, "Unsupported size for __cmpxchg_relaxed");
           ^
   arch/powerpc/include/asm/cmpxchg.h:467:2: error: implicit declaration of function 'BUILD_BUG_ON_MSG' [-Werror,-Wimplicit-function-declaration]
           BUILD_BUG_ON_MSG(1, "Unsupported size for __cmpxchg_acquire");
           ^
   In file included from kernel/bounds.c:10:
   In file included from include/linux/page-flags.h:10:
   In file included from include/linux/bug.h:5:
   In file included from arch/powerpc/include/asm/bug.h:109:
   In file included from include/asm-generic/bug.h:7:
   In file included from include/linux/once.h:6:
   In file included from include/linux/jump_label.h:249:
   In file included from include/linux/atomic.h:7:
   In file included from arch/powerpc/include/asm/atomic.h:11:
   In file included from arch/powerpc/include/asm/cmpxchg.h:526:
   In file included from include/asm-generic/cmpxchg-local.h:6:
   In file included from include/linux/irqflags.h:16:
   In file included from arch/powerpc/include/asm/irqflags.h:12:
   In file included from arch/powerpc/include/asm/hw_irq.h:12:
   In file included from arch/powerpc/include/asm/ptrace.h:264:
   In file included from include/linux/thread_info.h:59:
   In file included from arch/powerpc/include/asm/thread_info.h:13:
   In file included from arch/powerpc/include/asm/page.h:249:
>> arch/powerpc/include/asm/page_32.h:48:2: error: implicit declaration of function '__WARN' [-Werror,-Wimplicit-function-declaration]
           WARN_ON((unsigned long)addr & (L1_CACHE_BYTES - 1));
           ^
   arch/powerpc/include/asm/bug.h:87:4: note: expanded from macro 'WARN_ON'
                           __WARN();                               \
                           ^
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   20 errors generated.
   make[2]: *** [scripts/Makefile.build:116: kernel/bounds.s] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [Makefile:1235: prepare0] Error 2
   make[1]: Target 'modules_prepare' not remade because of errors.
   make: *** [Makefile:215: __sub-make] Error 2
   make: Target 'modules_prepare' not remade because of errors.
..


vim +/BITS_PER_BYTE +80 arch/powerpc/include/asm/cmpxchg.h

d0563a1297e234 Pan Xinhui    2016-04-27   72  
ae3a197e3d0bfe David Howells 2012-03-28   73  /*
ae3a197e3d0bfe David Howells 2012-03-28   74   * Atomic exchange
ae3a197e3d0bfe David Howells 2012-03-28   75   *
26760fc19a7e66 Boqun Feng    2015-12-15   76   * Changes the memory location '*p' to be val and returns
ae3a197e3d0bfe David Howells 2012-03-28   77   * the previous value stored there.
ae3a197e3d0bfe David Howells 2012-03-28   78   */
26760fc19a7e66 Boqun Feng    2015-12-15   79  
d0563a1297e234 Pan Xinhui    2016-04-27  @80  XCHG_GEN(u8, _local, "memory");
d0563a1297e234 Pan Xinhui    2016-04-27   81  XCHG_GEN(u8, _relaxed, "cc");
d0563a1297e234 Pan Xinhui    2016-04-27   82  XCHG_GEN(u16, _local, "memory");
d0563a1297e234 Pan Xinhui    2016-04-27   83  XCHG_GEN(u16, _relaxed, "cc");
d0563a1297e234 Pan Xinhui    2016-04-27   84  
ae3a197e3d0bfe David Howells 2012-03-28   85  static __always_inline unsigned long
26760fc19a7e66 Boqun Feng    2015-12-15   86  __xchg_u32_local(volatile void *p, unsigned long val)
ae3a197e3d0bfe David Howells 2012-03-28   87  {
ae3a197e3d0bfe David Howells 2012-03-28   88  	unsigned long prev;
ae3a197e3d0bfe David Howells 2012-03-28   89  
ae3a197e3d0bfe David Howells 2012-03-28   90  	__asm__ __volatile__(
ae3a197e3d0bfe David Howells 2012-03-28   91  "1:	lwarx	%0,0,%2 \n"
ae3a197e3d0bfe David Howells 2012-03-28   92  "	stwcx.	%3,0,%2 \n\
ae3a197e3d0bfe David Howells 2012-03-28   93  	bne-	1b"
ae3a197e3d0bfe David Howells 2012-03-28   94  	: "=&r" (prev), "+m" (*(volatile unsigned int *)p)
ae3a197e3d0bfe David Howells 2012-03-28   95  	: "r" (p), "r" (val)
ae3a197e3d0bfe David Howells 2012-03-28   96  	: "cc", "memory");
ae3a197e3d0bfe David Howells 2012-03-28   97  
ae3a197e3d0bfe David Howells 2012-03-28   98  	return prev;
ae3a197e3d0bfe David Howells 2012-03-28   99  }
ae3a197e3d0bfe David Howells 2012-03-28  100  
ae3a197e3d0bfe David Howells 2012-03-28  101  static __always_inline unsigned long
26760fc19a7e66 Boqun Feng    2015-12-15  102  __xchg_u32_relaxed(u32 *p, unsigned long val)
ae3a197e3d0bfe David Howells 2012-03-28  103  {
ae3a197e3d0bfe David Howells 2012-03-28  104  	unsigned long prev;
ae3a197e3d0bfe David Howells 2012-03-28  105  
ae3a197e3d0bfe David Howells 2012-03-28  106  	__asm__ __volatile__(
ae3a197e3d0bfe David Howells 2012-03-28  107  "1:	lwarx	%0,0,%2\n"
26760fc19a7e66 Boqun Feng    2015-12-15  108  "	stwcx.	%3,0,%2\n"
26760fc19a7e66 Boqun Feng    2015-12-15  109  "	bne-	1b"
26760fc19a7e66 Boqun Feng    2015-12-15  110  	: "=&r" (prev), "+m" (*p)
ae3a197e3d0bfe David Howells 2012-03-28  111  	: "r" (p), "r" (val)
26760fc19a7e66 Boqun Feng    2015-12-15  112  	: "cc");
ae3a197e3d0bfe David Howells 2012-03-28  113  
ae3a197e3d0bfe David Howells 2012-03-28  114  	return prev;
ae3a197e3d0bfe David Howells 2012-03-28  115  }
ae3a197e3d0bfe David Howells 2012-03-28  116  
ae3a197e3d0bfe David Howells 2012-03-28  117  #ifdef CONFIG_PPC64
ae3a197e3d0bfe David Howells 2012-03-28  118  static __always_inline unsigned long
26760fc19a7e66 Boqun Feng    2015-12-15  119  __xchg_u64_local(volatile void *p, unsigned long val)
ae3a197e3d0bfe David Howells 2012-03-28  120  {
ae3a197e3d0bfe David Howells 2012-03-28  121  	unsigned long prev;
ae3a197e3d0bfe David Howells 2012-03-28  122  
ae3a197e3d0bfe David Howells 2012-03-28  123  	__asm__ __volatile__(
ae3a197e3d0bfe David Howells 2012-03-28  124  "1:	ldarx	%0,0,%2 \n"
ae3a197e3d0bfe David Howells 2012-03-28  125  "	stdcx.	%3,0,%2 \n\
ae3a197e3d0bfe David Howells 2012-03-28  126  	bne-	1b"
ae3a197e3d0bfe David Howells 2012-03-28  127  	: "=&r" (prev), "+m" (*(volatile unsigned long *)p)
ae3a197e3d0bfe David Howells 2012-03-28  128  	: "r" (p), "r" (val)
ae3a197e3d0bfe David Howells 2012-03-28  129  	: "cc", "memory");
ae3a197e3d0bfe David Howells 2012-03-28  130  
ae3a197e3d0bfe David Howells 2012-03-28  131  	return prev;
ae3a197e3d0bfe David Howells 2012-03-28  132  }
ae3a197e3d0bfe David Howells 2012-03-28  133  
ae3a197e3d0bfe David Howells 2012-03-28  134  static __always_inline unsigned long
26760fc19a7e66 Boqun Feng    2015-12-15  135  __xchg_u64_relaxed(u64 *p, unsigned long val)
ae3a197e3d0bfe David Howells 2012-03-28  136  {
ae3a197e3d0bfe David Howells 2012-03-28  137  	unsigned long prev;
ae3a197e3d0bfe David Howells 2012-03-28  138  
ae3a197e3d0bfe David Howells 2012-03-28  139  	__asm__ __volatile__(
ae3a197e3d0bfe David Howells 2012-03-28  140  "1:	ldarx	%0,0,%2\n"
26760fc19a7e66 Boqun Feng    2015-12-15  141  "	stdcx.	%3,0,%2\n"
26760fc19a7e66 Boqun Feng    2015-12-15  142  "	bne-	1b"
26760fc19a7e66 Boqun Feng    2015-12-15  143  	: "=&r" (prev), "+m" (*p)
ae3a197e3d0bfe David Howells 2012-03-28  144  	: "r" (p), "r" (val)
26760fc19a7e66 Boqun Feng    2015-12-15  145  	: "cc");
ae3a197e3d0bfe David Howells 2012-03-28  146  
ae3a197e3d0bfe David Howells 2012-03-28  147  	return prev;
ae3a197e3d0bfe David Howells 2012-03-28  148  }
ae3a197e3d0bfe David Howells 2012-03-28  149  #endif
ae3a197e3d0bfe David Howells 2012-03-28  150  
ae3a197e3d0bfe David Howells 2012-03-28  151  static __always_inline unsigned long
d0563a1297e234 Pan Xinhui    2016-04-27  152  __xchg_local(void *ptr, unsigned long x, unsigned int size)
ae3a197e3d0bfe David Howells 2012-03-28  153  {
ae3a197e3d0bfe David Howells 2012-03-28  154  	switch (size) {
d0563a1297e234 Pan Xinhui    2016-04-27  155  	case 1:
d0563a1297e234 Pan Xinhui    2016-04-27  156  		return __xchg_u8_local(ptr, x);
d0563a1297e234 Pan Xinhui    2016-04-27  157  	case 2:
d0563a1297e234 Pan Xinhui    2016-04-27  158  		return __xchg_u16_local(ptr, x);
ae3a197e3d0bfe David Howells 2012-03-28  159  	case 4:
26760fc19a7e66 Boqun Feng    2015-12-15  160  		return __xchg_u32_local(ptr, x);
ae3a197e3d0bfe David Howells 2012-03-28  161  #ifdef CONFIG_PPC64
ae3a197e3d0bfe David Howells 2012-03-28  162  	case 8:
26760fc19a7e66 Boqun Feng    2015-12-15  163  		return __xchg_u64_local(ptr, x);
ae3a197e3d0bfe David Howells 2012-03-28  164  #endif
ae3a197e3d0bfe David Howells 2012-03-28  165  	}
10d8b1480e6966 pan xinhui    2016-02-23 @166  	BUILD_BUG_ON_MSG(1, "Unsupported size for __xchg");
ae3a197e3d0bfe David Howells 2012-03-28  167  	return x;
ae3a197e3d0bfe David Howells 2012-03-28  168  }
ae3a197e3d0bfe David Howells 2012-03-28  169  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--YiEDa0DAkWCtVeE4
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
cJ686TvS/wPF5L//AcsBAA==

--YiEDa0DAkWCtVeE4--
