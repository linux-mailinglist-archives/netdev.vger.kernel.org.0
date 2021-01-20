Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE542FD24D
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 15:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389592AbhATOFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:05:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:15722 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbhATNDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 08:03:14 -0500
IronPort-SDR: a/fflbK13mLEu3hjh7HwoP9yHwBVO9CVSHUT7L/6wlp6tJK0j4GqA50RxP5GINrHPy6AIMoNyI
 CSAcPP38mVvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="166191820"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="gz'50?scan'50,208,50";a="166191820"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 05:02:17 -0800
IronPort-SDR: CBqYWZ2OP8CSjLVr+Gr7TRqJU+Fj6QRd3F2VPhQsdeH6fu+7sc/BvGY8twNz7IwGjViE6zFp8p
 y88+AeNIRQVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="gz'50?scan'50,208,50";a="573885902"
Received: from lkp-server01.sh.intel.com (HELO 260eafd5ecd0) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 20 Jan 2021 05:02:12 -0800
Received: from kbuild by 260eafd5ecd0 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1l2D7j-0005nx-DA; Wed, 20 Jan 2021 13:02:11 +0000
Date:   Wed, 20 Jan 2021 21:01:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: Re: [PATCH bpf-next 4/8] xsk: register XDP sockets at bind(), and
 add new AF_XDP BPF helper
Message-ID: <202101202043.cg7vjYPH-lkp@intel.com>
References: <20210119153655.153999-5-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210119153655.153999-5-bjorn.topel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi "Björn,

I love your patch! Yet something to improve:

[auto build test ERROR on 95204c9bfa48d2f4d3bab7df55c1cc823957ff81]

url:    https://github.com/0day-ci/linux/commits/Bj-rn-T-pel/Introduce-bpf_redirect_xsk-helper/20210120-165233
base:    95204c9bfa48d2f4d3bab7df55c1cc823957ff81
config: nios2-randconfig-r034-20210120 (attached as .config)
compiler: nios2-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/e90e83e99e93790a73ecb4071ffd4366c75f12c0
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Bj-rn-T-pel/Introduce-bpf_redirect_xsk-helper/20210120-165233
        git checkout e90e83e99e93790a73ecb4071ffd4366c75f12c0
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=nios2 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   net/core/filter.c: In function '____bpf_xdp_redirect_xsk':
>> net/core/filter.c:4165:35: error: 'struct netdev_rx_queue' has no member named 'xsk'
    4165 |  xs = READ_ONCE(dev->_rx[queue_id].xsk);
         |                                   ^
   include/linux/compiler_types.h:300:9: note: in definition of macro '__compiletime_assert'
     300 |   if (!(condition))     \
         |         ^~~~~~~~~
   include/linux/compiler_types.h:320:2: note: in expansion of macro '_compiletime_assert'
     320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:2: note: in expansion of macro 'compiletime_assert'
      36 |  compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long), \
         |  ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:21: note: in expansion of macro '__native_word'
      36 |  compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long), \
         |                     ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:2: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |  compiletime_assert_rwonce_type(x);    \
         |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/core/filter.c:4165:7: note: in expansion of macro 'READ_ONCE'
    4165 |  xs = READ_ONCE(dev->_rx[queue_id].xsk);
         |       ^~~~~~~~~
>> net/core/filter.c:4165:35: error: 'struct netdev_rx_queue' has no member named 'xsk'
    4165 |  xs = READ_ONCE(dev->_rx[queue_id].xsk);
         |                                   ^
   include/linux/compiler_types.h:300:9: note: in definition of macro '__compiletime_assert'
     300 |   if (!(condition))     \
         |         ^~~~~~~~~
   include/linux/compiler_types.h:320:2: note: in expansion of macro '_compiletime_assert'
     320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:2: note: in expansion of macro 'compiletime_assert'
      36 |  compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long), \
         |  ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:21: note: in expansion of macro '__native_word'
      36 |  compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long), \
         |                     ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:2: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |  compiletime_assert_rwonce_type(x);    \
         |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/core/filter.c:4165:7: note: in expansion of macro 'READ_ONCE'
    4165 |  xs = READ_ONCE(dev->_rx[queue_id].xsk);
         |       ^~~~~~~~~
>> net/core/filter.c:4165:35: error: 'struct netdev_rx_queue' has no member named 'xsk'
    4165 |  xs = READ_ONCE(dev->_rx[queue_id].xsk);
         |                                   ^
   include/linux/compiler_types.h:300:9: note: in definition of macro '__compiletime_assert'
     300 |   if (!(condition))     \
         |         ^~~~~~~~~
   include/linux/compiler_types.h:320:2: note: in expansion of macro '_compiletime_assert'
     320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:2: note: in expansion of macro 'compiletime_assert'
      36 |  compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long), \
         |  ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:21: note: in expansion of macro '__native_word'
      36 |  compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long), \
         |                     ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:2: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |  compiletime_assert_rwonce_type(x);    \
         |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/core/filter.c:4165:7: note: in expansion of macro 'READ_ONCE'
    4165 |  xs = READ_ONCE(dev->_rx[queue_id].xsk);
         |       ^~~~~~~~~
>> net/core/filter.c:4165:35: error: 'struct netdev_rx_queue' has no member named 'xsk'
    4165 |  xs = READ_ONCE(dev->_rx[queue_id].xsk);
         |                                   ^
   include/linux/compiler_types.h:300:9: note: in definition of macro '__compiletime_assert'
     300 |   if (!(condition))     \
         |         ^~~~~~~~~
   include/linux/compiler_types.h:320:2: note: in expansion of macro '_compiletime_assert'
     320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:2: note: in expansion of macro 'compiletime_assert'
      36 |  compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long), \
         |  ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:21: note: in expansion of macro '__native_word'
      36 |  compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long), \
         |                     ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:2: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |  compiletime_assert_rwonce_type(x);    \
         |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/core/filter.c:4165:7: note: in expansion of macro 'READ_ONCE'
    4165 |  xs = READ_ONCE(dev->_rx[queue_id].xsk);
         |       ^~~~~~~~~
>> net/core/filter.c:4165:35: error: 'struct netdev_rx_queue' has no member named 'xsk'
    4165 |  xs = READ_ONCE(dev->_rx[queue_id].xsk);
         |                                   ^
   include/linux/compiler_types.h:300:9: note: in definition of macro '__compiletime_assert'
     300 |   if (!(condition))     \
         |         ^~~~~~~~~
   include/linux/compiler_types.h:320:2: note: in expansion of macro '_compiletime_assert'
     320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:2: note: in expansion of macro 'compiletime_assert'
      36 |  compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long), \
         |  ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:2: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |  compiletime_assert_rwonce_type(x);    \
         |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/core/filter.c:4165:7: note: in expansion of macro 'READ_ONCE'
    4165 |  xs = READ_ONCE(dev->_rx[queue_id].xsk);
         |       ^~~~~~~~~
>> net/core/filter.c:4165:35: error: 'struct netdev_rx_queue' has no member named 'xsk'
    4165 |  xs = READ_ONCE(dev->_rx[queue_id].xsk);
         |                                   ^
   include/linux/compiler_types.h:271:13: note: in definition of macro '__unqual_scalar_typeof'
     271 |   _Generic((x),      \
         |             ^
   include/asm-generic/rwonce.h:50:2: note: in expansion of macro '__READ_ONCE'
      50 |  __READ_ONCE(x);       \
         |  ^~~~~~~~~~~
   net/core/filter.c:4165:7: note: in expansion of macro 'READ_ONCE'
    4165 |  xs = READ_ONCE(dev->_rx[queue_id].xsk);
         |       ^~~~~~~~~
   In file included from ./arch/nios2/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:246,
                    from include/linux/kernel.h:10,
                    from include/linux/list.h:9,
                    from include/linux/module.h:12,
                    from net/core/filter.c:20:
>> net/core/filter.c:4165:35: error: 'struct netdev_rx_queue' has no member named 'xsk'
    4165 |  xs = READ_ONCE(dev->_rx[queue_id].xsk);
         |                                   ^
   include/asm-generic/rwonce.h:44:72: note: in definition of macro '__READ_ONCE'
      44 | #define __READ_ONCE(x) (*(const volatile __unqual_scalar_typeof(x) *)&(x))
         |                                                                        ^
   net/core/filter.c:4165:7: note: in expansion of macro 'READ_ONCE'
    4165 |  xs = READ_ONCE(dev->_rx[queue_id].xsk);
         |       ^~~~~~~~~

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for SERIAL_CORE_CONSOLE
   Depends on TTY && HAS_IOMEM
   Selected by
   - EARLY_PRINTK


vim +4165 net/core/filter.c

  4157	
  4158	BPF_CALL_2(bpf_xdp_redirect_xsk, struct xdp_buff *, xdp, u64, action)
  4159	{
  4160		struct net_device *dev = xdp->rxq->dev;
  4161		u32 queue_id = xdp->rxq->queue_index;
  4162		struct bpf_redirect_info *ri;
  4163		struct xdp_sock *xs;
  4164	
> 4165		xs = READ_ONCE(dev->_rx[queue_id].xsk);
  4166		if (!xs)
  4167			return action;
  4168	
  4169		ri = this_cpu_ptr(&bpf_redirect_info);
  4170		ri->tgt_type = XDP_REDIR_XSK;
  4171		ri->tgt_value = xs;
  4172	
  4173		return XDP_REDIRECT;
  4174	}
  4175	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--7AUc2qLy4jB3hD7Z
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
dvytZHUBAA==

--7AUc2qLy4jB3hD7Z--
