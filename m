Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79485693164
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 14:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjBKN4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 08:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjBKN4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 08:56:17 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23932CC43
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 05:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676123775; x=1707659775;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Yf9uN5AleEb2rnod9jgnJ0ohXkVLR4e93Al5AcGOoI4=;
  b=MLAItTMkbzeWGSf3rd4KW+xToUYRcZEqncs9YzpXudsvB1ITXCYqJaZF
   94Hzdk7wc9Ry5YqZ/Yf5IPrs6mHr7hx5BPZe+W62DaKPosFAUV0kL6EPv
   IdzYqTjKHodMvaubw8/HgQoVdoZHaUcD3ivI7P2FbgzF5UQSvRA8E5fIY
   SIBHEz0BzQVV52yEPI8aj0aH8PbIAprKkuRURMLOlteb8m5SXQ9SktGsC
   2Vkj4AUwwBKTWB2pdYczWukFx1vvTtR62vrJzQBeHJrSD82505yMyRKFc
   tNtuxMHSNYBVpdGslBEzpVQGy6GnAmdl/46YWOCCv9yc9RI1K8A/AWOk+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10618"; a="310245122"
X-IronPort-AV: E=Sophos;i="5.97,289,1669104000"; 
   d="scan'208";a="310245122"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2023 05:56:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10618"; a="792268412"
X-IronPort-AV: E=Sophos;i="5.97,289,1669104000"; 
   d="scan'208";a="792268412"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 11 Feb 2023 05:56:11 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pQqMM-0006YT-1d;
        Sat, 11 Feb 2023 13:56:10 +0000
Date:   Sat, 11 Feb 2023 21:55:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Harsh Jain <h.jain@amd.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        thomas.lendacky@amd.com, Raju.Rangoju@amd.com,
        Shyam-sundar.S-k@amd.com, harshjain.prof@gmail.com,
        abhijit.gangurde@amd.com, puneet.gupta@amd.com,
        nikhil.agarwal@amd.com, tarak.reddy@amd.com, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Harsh Jain <h.jain@amd.com>
Subject: Re: [PATCH  6/6]  net: ethernet: efct: Add maintainer, kconfig,
 makefile
Message-ID: <202302112108.yWxsei6x-lkp@intel.com>
References: <20230210130321.2898-7-h.jain@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210130321.2898-7-h.jain@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harsh,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on net/master horms-ipvs/master linus/master v6.2-rc7 next-20230210]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Harsh-Jain/net-ethernet-efct-New-X3-net-driver/20230210-210711
patch link:    https://lore.kernel.org/r/20230210130321.2898-7-h.jain%40amd.com
patch subject: [PATCH  6/6]  net: ethernet: efct: Add maintainer, kconfig, makefile
config: i386-defconfig (https://download.01.org/0day-ci/archive/20230211/202302112108.yWxsei6x-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/93ed306161ac0259bd72b14922a7f6af60b3748c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Harsh-Jain/net-ethernet-efct-New-X3-net-driver/20230210-210711
        git checkout 93ed306161ac0259bd72b14922a7f6af60b3748c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302112108.yWxsei6x-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/net/ethernet/amd/efct/mcdi.c:12:
   drivers/net/ethernet/amd/efct/efct_io.h: In function '_efct_writeq':
>> drivers/net/ethernet/amd/efct/efct_io.h:57:9: error: implicit declaration of function '__raw_writeq'; did you mean '_efct_writeq'? [-Werror=implicit-function-declaration]
      57 |         __raw_writeq((__force u64)value, reg);
         |         ^~~~~~~~~~~~
         |         _efct_writeq
   drivers/net/ethernet/amd/efct/efct_io.h: In function '_efct_readq':
>> drivers/net/ethernet/amd/efct/efct_io.h:62:32: error: implicit declaration of function '__raw_readq' [-Werror=implicit-function-declaration]
      62 |         return (__force __le64)__raw_readq(reg);
         |                                ^~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   In file included from drivers/net/ethernet/amd/efct/efct_nic.c:15:
   drivers/net/ethernet/amd/efct/efct_io.h: In function '_efct_writeq':
>> drivers/net/ethernet/amd/efct/efct_io.h:57:9: error: implicit declaration of function '__raw_writeq'; did you mean '_efct_writeq'? [-Werror=implicit-function-declaration]
      57 |         __raw_writeq((__force u64)value, reg);
         |         ^~~~~~~~~~~~
         |         _efct_writeq
   drivers/net/ethernet/amd/efct/efct_io.h: In function '_efct_readq':
>> drivers/net/ethernet/amd/efct/efct_io.h:62:32: error: implicit declaration of function '__raw_readq' [-Werror=implicit-function-declaration]
      62 |         return (__force __le64)__raw_readq(reg);
         |                                ^~~~~~~~~~~
   In file included from drivers/net/ethernet/amd/efct/efct_driver.h:25,
                    from drivers/net/ethernet/amd/efct/efct_common.h:13,
                    from drivers/net/ethernet/amd/efct/efct_nic.c:10:
   drivers/net/ethernet/amd/efct/efct_nic.c: In function 'efct_time_sync_event':
   drivers/net/ethernet/amd/efct/efct_bitfield.h:112:27: warning: left shift count >= width of type [-Wshift-count-overflow]
     112 |          (native_element) << ((min) - (low)))
         |                           ^~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:124:9: note: in expansion of macro 'EFCT_EXTRACT_NATIVE'
     124 |         EFCT_EXTRACT_NATIVE(le32_to_cpu(element), min, max, low, high)
         |         ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:144:11: note: in expansion of macro 'EFCT_EXTRACT32'
     144 |           EFCT_EXTRACT32((qword).u32[1], 32, 63, low, high)) &          \
         |           ^~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:164:9: note: in expansion of macro 'EFCT_EXTRACT_QWORD32'
     164 |         EFCT_EXTRACT_QWORD32(qword, EFCT_LOW_BIT(field),                \
         |         ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:212:41: note: in expansion of macro 'EFCT_QWORD_FIELD32'
     212 | #define EFCT_QWORD_FIELD                EFCT_QWORD_FIELD32
         |                                         ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_nic.c:746:38: note: in expansion of macro 'EFCT_QWORD_FIELD'
     746 |         evq->sync_timestamp_major =  EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_TSYNC_TIME_HIGH_48);
         |                                      ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:69:22: warning: left shift count >= width of type [-Wshift-count-overflow]
      69 |          (((((u32)1) << (width))) - 1))
         |                      ^~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:145:10: note: in expansion of macro 'EFCT_MASK32'
     145 |          EFCT_MASK32((high) + 1 - (low)))
         |          ^~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:164:9: note: in expansion of macro 'EFCT_EXTRACT_QWORD32'
     164 |         EFCT_EXTRACT_QWORD32(qword, EFCT_LOW_BIT(field),                \
         |         ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:212:41: note: in expansion of macro 'EFCT_QWORD_FIELD32'
     212 | #define EFCT_QWORD_FIELD                EFCT_QWORD_FIELD32
         |                                         ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_nic.c:746:38: note: in expansion of macro 'EFCT_QWORD_FIELD'
     746 |         evq->sync_timestamp_major =  EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_TSYNC_TIME_HIGH_48);
         |                                      ^~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   In file included from drivers/net/ethernet/amd/efct/efct_tx.c:11:
   drivers/net/ethernet/amd/efct/efct_io.h: In function '_efct_writeq':
>> drivers/net/ethernet/amd/efct/efct_io.h:57:9: error: implicit declaration of function '__raw_writeq'; did you mean '_efct_writeq'? [-Werror=implicit-function-declaration]
      57 |         __raw_writeq((__force u64)value, reg);
         |         ^~~~~~~~~~~~
         |         _efct_writeq
   drivers/net/ethernet/amd/efct/efct_io.h: In function '_efct_readq':
>> drivers/net/ethernet/amd/efct/efct_io.h:62:32: error: implicit declaration of function '__raw_readq' [-Werror=implicit-function-declaration]
      62 |         return (__force __le64)__raw_readq(reg);
         |                                ^~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_tx.c: In function 'txq_piobuf_w64':
>> drivers/net/ethernet/amd/efct/efct_tx.c:89:9: error: implicit declaration of function 'writeq'; did you mean 'writel'? [-Werror=implicit-function-declaration]
      89 |         writeq(val, dest64);
         |         ^~~~~~
         |         writel
   In file included from drivers/net/ethernet/amd/efct/efct_driver.h:25,
                    from drivers/net/ethernet/amd/efct/efct_tx.h:11,
                    from drivers/net/ethernet/amd/efct/efct_tx.c:9:
   drivers/net/ethernet/amd/efct/efct_tx.c: In function 'efct_ev_tx':
   drivers/net/ethernet/amd/efct/efct_bitfield.h:112:27: warning: left shift count >= width of type [-Wshift-count-overflow]
     112 |          (native_element) << ((min) - (low)))
         |                           ^~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:124:9: note: in expansion of macro 'EFCT_EXTRACT_NATIVE'
     124 |         EFCT_EXTRACT_NATIVE(le32_to_cpu(element), min, max, low, high)
         |         ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:144:11: note: in expansion of macro 'EFCT_EXTRACT32'
     144 |           EFCT_EXTRACT32((qword).u32[1], 32, 63, low, high)) &          \
         |           ^~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:164:9: note: in expansion of macro 'EFCT_EXTRACT_QWORD32'
     164 |         EFCT_EXTRACT_QWORD32(qword, EFCT_LOW_BIT(field),                \
         |         ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:212:41: note: in expansion of macro 'EFCT_QWORD_FIELD32'
     212 | #define EFCT_QWORD_FIELD                EFCT_QWORD_FIELD32
         |                                         ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_tx.c:326:22: note: in expansion of macro 'EFCT_QWORD_FIELD'
     326 |         partial_ts = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_TXCMPL_PARTIAL_TSTAMP);
         |                      ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:69:22: warning: left shift count >= width of type [-Wshift-count-overflow]
      69 |          (((((u32)1) << (width))) - 1))
         |                      ^~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:145:10: note: in expansion of macro 'EFCT_MASK32'
     145 |          EFCT_MASK32((high) + 1 - (low)))
         |          ^~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:164:9: note: in expansion of macro 'EFCT_EXTRACT_QWORD32'
     164 |         EFCT_EXTRACT_QWORD32(qword, EFCT_LOW_BIT(field),                \
         |         ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:212:41: note: in expansion of macro 'EFCT_QWORD_FIELD32'
     212 | #define EFCT_QWORD_FIELD                EFCT_QWORD_FIELD32
         |                                         ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_tx.c:326:22: note: in expansion of macro 'EFCT_QWORD_FIELD'
     326 |         partial_ts = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_TXCMPL_PARTIAL_TSTAMP);
         |                      ^~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   In file included from drivers/net/ethernet/amd/efct/efct_rx.c:15:
   drivers/net/ethernet/amd/efct/efct_io.h: In function '_efct_writeq':
>> drivers/net/ethernet/amd/efct/efct_io.h:57:9: error: implicit declaration of function '__raw_writeq'; did you mean '_efct_writeq'? [-Werror=implicit-function-declaration]
      57 |         __raw_writeq((__force u64)value, reg);
         |         ^~~~~~~~~~~~
         |         _efct_writeq
   drivers/net/ethernet/amd/efct/efct_io.h: In function '_efct_readq':
>> drivers/net/ethernet/amd/efct/efct_io.h:62:32: error: implicit declaration of function '__raw_readq' [-Werror=implicit-function-declaration]
      62 |         return (__force __le64)__raw_readq(reg);
         |                                ^~~~~~~~~~~
   In file included from drivers/net/ethernet/amd/efct/efct_driver.h:25,
                    from drivers/net/ethernet/amd/efct/efct_rx.h:11,
                    from drivers/net/ethernet/amd/efct/efct_rx.c:12:
   drivers/net/ethernet/amd/efct/efct_rx.c: In function 'efct_include_ts_in_rxskb':
   drivers/net/ethernet/amd/efct/efct_bitfield.h:112:27: warning: left shift count >= width of type [-Wshift-count-overflow]
     112 |          (native_element) << ((min) - (low)))
         |                           ^~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:124:9: note: in expansion of macro 'EFCT_EXTRACT_NATIVE'
     124 |         EFCT_EXTRACT_NATIVE(le32_to_cpu(element), min, max, low, high)
         |         ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:139:11: note: in expansion of macro 'EFCT_EXTRACT32'
     139 |           EFCT_EXTRACT32((oword).u32[3], 96, 127, low, high)) &         \
         |           ^~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:160:9: note: in expansion of macro 'EFCT_EXTRACT_OWORD32'
     160 |         EFCT_EXTRACT_OWORD32(oword, EFCT_LOW_BIT(field),                \
         |         ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:211:41: note: in expansion of macro 'EFCT_OWORD_FIELD32'
     211 | #define EFCT_OWORD_FIELD                EFCT_OWORD_FIELD32
         |                                         ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_rx.c:386:24: note: in expansion of macro 'EFCT_OWORD_FIELD'
     386 |         pkt_ts_major = EFCT_OWORD_FIELD(*((union efct_oword *)p_meta), ESF_HZ_RX_PREFIX_TIMESTAMP);
         |                        ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:69:22: warning: left shift count >= width of type [-Wshift-count-overflow]
      69 |          (((((u32)1) << (width))) - 1))
         |                      ^~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:140:10: note: in expansion of macro 'EFCT_MASK32'
     140 |          EFCT_MASK32((high) + 1 - (low)))
         |          ^~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:160:9: note: in expansion of macro 'EFCT_EXTRACT_OWORD32'
     160 |         EFCT_EXTRACT_OWORD32(oword, EFCT_LOW_BIT(field),                \
         |         ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_bitfield.h:211:41: note: in expansion of macro 'EFCT_OWORD_FIELD32'
     211 | #define EFCT_OWORD_FIELD                EFCT_OWORD_FIELD32
         |                                         ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_rx.c:386:24: note: in expansion of macro 'EFCT_OWORD_FIELD'
     386 |         pkt_ts_major = EFCT_OWORD_FIELD(*((union efct_oword *)p_meta), ESF_HZ_RX_PREFIX_TIMESTAMP);
         |                        ^~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +57 drivers/net/ethernet/amd/efct/efct_io.h

83f06a5b784384 Harsh Jain 2023-02-10  54  
83f06a5b784384 Harsh Jain 2023-02-10  55  static inline void _efct_writeq(__le64 value, void __iomem *reg)
83f06a5b784384 Harsh Jain 2023-02-10  56  {
83f06a5b784384 Harsh Jain 2023-02-10 @57  	__raw_writeq((__force u64)value, reg);
83f06a5b784384 Harsh Jain 2023-02-10  58  }
83f06a5b784384 Harsh Jain 2023-02-10  59  
83f06a5b784384 Harsh Jain 2023-02-10  60  static inline __le64 _efct_readq(void __iomem *reg)
83f06a5b784384 Harsh Jain 2023-02-10  61  {
83f06a5b784384 Harsh Jain 2023-02-10 @62  	return (__force __le64)__raw_readq(reg);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
