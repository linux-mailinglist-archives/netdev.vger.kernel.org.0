Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5D849F868
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 12:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbiA1LjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 06:39:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:45251 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237846AbiA1LjU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 06:39:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643369960; x=1674905960;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PN5o/kpKeDNPdKUsT9CVJhrOgWqfA5kU/QW51qp+kdw=;
  b=CZ0TIM75DbYWSY9ioAr8AZHn0yYr0aWO/o21f+4ViL33qojOcPWtWpkF
   43GSv+Cre9vmro+TFbisnPvr4gJb3bGuV0eARghf+TE5oqRKQ58vO+Mhw
   2x4yYacqMGnPx1GjUvS26rmJuBhx0dREumgsYdfC6zkUkfv1jVZRfSgIZ
   mkA7EGS0yCPST4qwTh7zHePE9zGvi5PJNHhG7poSD9TzRGuoO9yTbYusz
   OC8CmGFxcldnakL9oBAJqUWYbGFR+hczFMoR2AoRda/+Z1+wJ/rAd6q2W
   ps7u+uKro0MQxFgycKWvvPcf1lsXk2fGzjkiTMKTzpTJogud1y2CxhBbz
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10240"; a="234481919"
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="234481919"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 03:39:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="564171994"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 28 Jan 2022 03:39:15 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nDPb0-000Nmz-O7; Fri, 28 Jan 2022 11:39:14 +0000
Date:   Fri, 28 Jan 2022 19:38:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     cgel.zte@gmail.com, kvalo@kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, kuba@kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] wcn36xx: use struct_size over open coded arithmetic
Message-ID: <202201281936.Qhf4hXej-lkp@intel.com>
References: <20220128080430.1211593-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128080430.1211593-1-chi.minghao@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvalo-wireless-drivers-next/master]
[also build test ERROR on kvalo-wireless-drivers/master v5.17-rc1 next-20220128]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/cgel-zte-gmail-com/wcn36xx-use-struct_size-over-open-coded-arithmetic/20220128-160610
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
config: arm-randconfig-c002-20220124 (https://download.01.org/0day-ci/archive/20220128/202201281936.Qhf4hXej-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/b6c0d24562c28f1e9a037c1aa7818c76854559e4
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/wcn36xx-use-struct_size-over-open-coded-arithmetic/20220128-160610
        git checkout b6c0d24562c28f1e9a037c1aa7818c76854559e4
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash drivers/firewire/ drivers/net/wireless/ath/wcn36xx/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/mm.h:30,
                    from arch/arm/include/asm/cacheflush.h:10,
                    from include/linux/cacheflush.h:5,
                    from include/linux/highmem.h:8,
                    from include/linux/bvec.h:10,
                    from include/linux/skbuff.h:17,
                    from include/linux/if_ether.h:19,
                    from include/linux/etherdevice.h:20,
                    from drivers/net/wireless/ath/wcn36xx/smd.c:20:
   drivers/net/wireless/ath/wcn36xx/smd.c: In function 'wcn36xx_smd_rsp_process':
>> include/linux/overflow.h:194:32: error: invalid type argument of '->' (have 'struct wcn36xx_hal_ind_msg')
     194 |                     sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                                ^~
   drivers/net/wireless/ath/wcn36xx/smd.c:3350:35: note: in expansion of macro 'struct_size'
    3350 |                 msg_ind = kmalloc(struct_size(*msg_ind, msg, len), GFP_ATOMIC);
         |                                   ^~~~~~~~~~~
   In file included from include/linux/bitfield.h:10,
                    from drivers/net/wireless/ath/wcn36xx/smd.c:19:
   include/linux/overflow.h:194:63: error: invalid type argument of '->' (have 'struct wcn36xx_hal_ind_msg')
     194 |                     sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                                                               ^~
   include/linux/build_bug.h:16:62: note: in definition of macro 'BUILD_BUG_ON_ZERO'
      16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
         |                                                              ^
   include/linux/compiler.h:258:51: note: in expansion of macro '__same_type'
     258 | #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
         |                                                   ^~~~~~~~~~~
   include/linux/overflow.h:194:44: note: in expansion of macro '__must_be_array'
     194 |                     sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                                            ^~~~~~~~~~~~~~~
   drivers/net/wireless/ath/wcn36xx/smd.c:3350:35: note: in expansion of macro 'struct_size'
    3350 |                 msg_ind = kmalloc(struct_size(*msg_ind, msg, len), GFP_ATOMIC);
         |                                   ^~~~~~~~~~~
   include/linux/overflow.h:194:63: error: invalid type argument of '->' (have 'struct wcn36xx_hal_ind_msg')
     194 |                     sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                                                               ^~
   include/linux/build_bug.h:16:62: note: in definition of macro 'BUILD_BUG_ON_ZERO'
      16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
         |                                                              ^
   include/linux/compiler.h:258:51: note: in expansion of macro '__same_type'
     258 | #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
         |                                                   ^~~~~~~~~~~
   include/linux/overflow.h:194:44: note: in expansion of macro '__must_be_array'
     194 |                     sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                                            ^~~~~~~~~~~~~~~
   drivers/net/wireless/ath/wcn36xx/smd.c:3350:35: note: in expansion of macro 'struct_size'
    3350 |                 msg_ind = kmalloc(struct_size(*msg_ind, msg, len), GFP_ATOMIC);
         |                                   ^~~~~~~~~~~
   include/linux/build_bug.h:16:51: error: bit-field '<anonymous>' width not an integer constant
      16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
         |                                                   ^
   include/linux/compiler.h:258:33: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     258 | #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
         |                                 ^~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:44: note: in expansion of macro '__must_be_array'
     194 |                     sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                                            ^~~~~~~~~~~~~~~
   drivers/net/wireless/ath/wcn36xx/smd.c:3350:35: note: in expansion of macro 'struct_size'
    3350 |                 msg_ind = kmalloc(struct_size(*msg_ind, msg, len), GFP_ATOMIC);
         |                                   ^~~~~~~~~~~
   In file included from include/linux/mm.h:30,
                    from arch/arm/include/asm/cacheflush.h:10,
                    from include/linux/cacheflush.h:5,
                    from include/linux/highmem.h:8,
                    from include/linux/bvec.h:10,
                    from include/linux/skbuff.h:17,
                    from include/linux/if_ether.h:19,
                    from include/linux/etherdevice.h:20,
                    from drivers/net/wireless/ath/wcn36xx/smd.c:20:
>> include/linux/overflow.h:195:28: error: invalid type argument of unary '*' (have 'struct wcn36xx_hal_ind_msg')
     195 |                     sizeof(*(p)))
         |                            ^~~~
   drivers/net/wireless/ath/wcn36xx/smd.c:3350:35: note: in expansion of macro 'struct_size'
    3350 |                 msg_ind = kmalloc(struct_size(*msg_ind, msg, len), GFP_ATOMIC);
         |                                   ^~~~~~~~~~~


vim +194 include/linux/overflow.h

610b15c50e86eb Kees Cook           2018-05-07  180  
610b15c50e86eb Kees Cook           2018-05-07  181  /**
610b15c50e86eb Kees Cook           2018-05-07  182   * struct_size() - Calculate size of structure with trailing array.
610b15c50e86eb Kees Cook           2018-05-07  183   * @p: Pointer to the structure.
610b15c50e86eb Kees Cook           2018-05-07  184   * @member: Name of the array member.
b19d57d0f3cc6f Gustavo A. R. Silva 2020-06-08  185   * @count: Number of elements in the array.
610b15c50e86eb Kees Cook           2018-05-07  186   *
610b15c50e86eb Kees Cook           2018-05-07  187   * Calculates size of memory needed for structure @p followed by an
b19d57d0f3cc6f Gustavo A. R. Silva 2020-06-08  188   * array of @count number of @member elements.
610b15c50e86eb Kees Cook           2018-05-07  189   *
610b15c50e86eb Kees Cook           2018-05-07  190   * Return: number of bytes needed or SIZE_MAX on overflow.
610b15c50e86eb Kees Cook           2018-05-07  191   */
b19d57d0f3cc6f Gustavo A. R. Silva 2020-06-08  192  #define struct_size(p, member, count)					\
b19d57d0f3cc6f Gustavo A. R. Silva 2020-06-08  193  	__ab_c_size(count,						\
610b15c50e86eb Kees Cook           2018-05-07 @194  		    sizeof(*(p)->member) + __must_be_array((p)->member),\
610b15c50e86eb Kees Cook           2018-05-07 @195  		    sizeof(*(p)))
610b15c50e86eb Kees Cook           2018-05-07  196  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
