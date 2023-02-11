Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D410F692EC5
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 07:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBKGhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 01:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBKGhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 01:37:33 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3428514EBE
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 22:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676097449; x=1707633449;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9gJpkJt3TaRPs6SWmfeEDwUFeKZtBCaDSHw7WJjsXnE=;
  b=PdCNrf1lQJj2jKCF/7Xx+8Qwq7rCN7mKXL1HS3Q/SoZYCA8k2YEf3FHs
   AlMA4FSuBth5BkzL6zgCqNuMnabNQifTRM3ygMXzbCuorbhZrqbE3RTnn
   XQWLZB/+CG0oIpG+k3MMw/UTGKfr8dUWQsBVexH/VtOnmrqlqo64gVXCz
   KpCTRcgDy+Jbwt0HpR5XecdkaAz2wHnoJoZDWOlJJmbuwnzHCyLIl1v7D
   02D5OloTpjuHspt/DQR1LR9JM5dAyfYmzGdlD3WiPF22JJw19IWT+4v4j
   O+DUYEf8Tu3k0vLqDpqOM5GQXlzRoWYaVXGxiiBqDP4pahKiV90WWUr+n
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="392992451"
X-IronPort-AV: E=Sophos;i="5.97,289,1669104000"; 
   d="scan'208";a="392992451"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 22:37:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="811058158"
X-IronPort-AV: E=Sophos;i="5.97,289,1669104000"; 
   d="scan'208";a="811058158"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 10 Feb 2023 22:36:59 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pQjVK-0006If-1W;
        Sat, 11 Feb 2023 06:36:58 +0000
Date:   Sat, 11 Feb 2023 14:36:03 +0800
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
Message-ID: <202302111407.gbTaWzgq-lkp@intel.com>
References: <20230210130321.2898-7-h.jain@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210130321.2898-7-h.jain@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harsh,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master horms-ipvs/master linus/master v6.2-rc7 next-20230210]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Harsh-Jain/net-ethernet-efct-New-X3-net-driver/20230210-210711
patch link:    https://lore.kernel.org/r/20230210130321.2898-7-h.jain%40amd.com
patch subject: [PATCH  6/6]  net: ethernet: efct: Add maintainer, kconfig, makefile
config: i386-defconfig (https://download.01.org/0day-ci/archive/20230211/202302111407.gbTaWzgq-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/93ed306161ac0259bd72b14922a7f6af60b3748c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Harsh-Jain/net-ethernet-efct-New-X3-net-driver/20230210-210711
        git checkout 93ed306161ac0259bd72b14922a7f6af60b3748c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ io_uring//

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302111407.gbTaWzgq-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/net/ethernet/amd/efct/efct_nic.c:15:
   drivers/net/ethernet/amd/efct/efct_io.h: In function '_efct_writeq':
   drivers/net/ethernet/amd/efct/efct_io.h:57:9: error: implicit declaration of function '__raw_writeq'; did you mean '_efct_writeq'? [-Werror=implicit-function-declaration]
      57 |         __raw_writeq((__force u64)value, reg);
         |         ^~~~~~~~~~~~
         |         _efct_writeq
   drivers/net/ethernet/amd/efct/efct_io.h: In function '_efct_readq':
   drivers/net/ethernet/amd/efct/efct_io.h:62:32: error: implicit declaration of function '__raw_readq' [-Werror=implicit-function-declaration]
      62 |         return (__force __le64)__raw_readq(reg);
         |                                ^~~~~~~~~~~
   In file included from drivers/net/ethernet/amd/efct/efct_driver.h:25,
                    from drivers/net/ethernet/amd/efct/efct_common.h:13,
                    from drivers/net/ethernet/amd/efct/efct_nic.c:10:
   drivers/net/ethernet/amd/efct/efct_nic.c: In function 'efct_time_sync_event':
>> drivers/net/ethernet/amd/efct/efct_bitfield.h:112:27: warning: left shift count >= width of type [-Wshift-count-overflow]
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
   drivers/net/ethernet/amd/efct/efct_io.h:57:9: error: implicit declaration of function '__raw_writeq'; did you mean '_efct_writeq'? [-Werror=implicit-function-declaration]
      57 |         __raw_writeq((__force u64)value, reg);
         |         ^~~~~~~~~~~~
         |         _efct_writeq
   drivers/net/ethernet/amd/efct/efct_io.h: In function '_efct_readq':
   drivers/net/ethernet/amd/efct/efct_io.h:62:32: error: implicit declaration of function '__raw_readq' [-Werror=implicit-function-declaration]
      62 |         return (__force __le64)__raw_readq(reg);
         |                                ^~~~~~~~~~~
   drivers/net/ethernet/amd/efct/efct_tx.c: In function 'txq_piobuf_w64':
   drivers/net/ethernet/amd/efct/efct_tx.c:89:9: error: implicit declaration of function 'writeq'; did you mean 'writel'? [-Werror=implicit-function-declaration]
      89 |         writeq(val, dest64);
         |         ^~~~~~
         |         writel
   In file included from drivers/net/ethernet/amd/efct/efct_driver.h:25,
                    from drivers/net/ethernet/amd/efct/efct_tx.h:11,
                    from drivers/net/ethernet/amd/efct/efct_tx.c:9:
   drivers/net/ethernet/amd/efct/efct_tx.c: In function 'efct_ev_tx':
>> drivers/net/ethernet/amd/efct/efct_bitfield.h:112:27: warning: left shift count >= width of type [-Wshift-count-overflow]
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
   drivers/net/ethernet/amd/efct/efct_io.h:57:9: error: implicit declaration of function '__raw_writeq'; did you mean '_efct_writeq'? [-Werror=implicit-function-declaration]
      57 |         __raw_writeq((__force u64)value, reg);
         |         ^~~~~~~~~~~~
         |         _efct_writeq
   drivers/net/ethernet/amd/efct/efct_io.h: In function '_efct_readq':
   drivers/net/ethernet/amd/efct/efct_io.h:62:32: error: implicit declaration of function '__raw_readq' [-Werror=implicit-function-declaration]
      62 |         return (__force __le64)__raw_readq(reg);
         |                                ^~~~~~~~~~~
   In file included from drivers/net/ethernet/amd/efct/efct_driver.h:25,
                    from drivers/net/ethernet/amd/efct/efct_rx.h:11,
                    from drivers/net/ethernet/amd/efct/efct_rx.c:12:
   drivers/net/ethernet/amd/efct/efct_rx.c: In function 'efct_include_ts_in_rxskb':
>> drivers/net/ethernet/amd/efct/efct_bitfield.h:112:27: warning: left shift count >= width of type [-Wshift-count-overflow]
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


vim +112 drivers/net/ethernet/amd/efct/efct_bitfield.h

83f06a5b784384 Harsh Jain 2023-02-10   90  
83f06a5b784384 Harsh Jain 2023-02-10   91  /* Format string and value expanders for printk */
83f06a5b784384 Harsh Jain 2023-02-10   92  #define EFCT_DWORD_FMT "%08x"
83f06a5b784384 Harsh Jain 2023-02-10   93  #define EFCT_OWORD_FMT "%08x:%08x:%08x:%08x"
83f06a5b784384 Harsh Jain 2023-02-10   94  #define EFCT_DWORD_VAL(dword)				\
83f06a5b784384 Harsh Jain 2023-02-10   95  	((u32)le32_to_cpu((dword).word32))
83f06a5b784384 Harsh Jain 2023-02-10   96  
83f06a5b784384 Harsh Jain 2023-02-10   97  /* Extract bit field portion [low,high) from the native-endian element
83f06a5b784384 Harsh Jain 2023-02-10   98   * which contains bits [min,max).
83f06a5b784384 Harsh Jain 2023-02-10   99   * For example, suppose "element" represents the high 32 bits of a
83f06a5b784384 Harsh Jain 2023-02-10  100   * 64-bit value, and we wish to extract the bits belonging to the bit
83f06a5b784384 Harsh Jain 2023-02-10  101   * field occupying bits 28-45 of this 64-bit value.
83f06a5b784384 Harsh Jain 2023-02-10  102   * Then EFCT_EXTRACT ( element, 32, 63, 28, 45 ) would give
83f06a5b784384 Harsh Jain 2023-02-10  103   *
83f06a5b784384 Harsh Jain 2023-02-10  104   *   ( element ) << 4
83f06a5b784384 Harsh Jain 2023-02-10  105   * The result will contain the relevant bits filled in the range
83f06a5b784384 Harsh Jain 2023-02-10  106   * [0,high-low), with garbage in bits [high-low+1,...).
83f06a5b784384 Harsh Jain 2023-02-10  107   */
83f06a5b784384 Harsh Jain 2023-02-10  108  #define EFCT_EXTRACT_NATIVE(native_element, min, max, low, high)		\
83f06a5b784384 Harsh Jain 2023-02-10  109  	((low) > (max) || (high) < (min) ? 0 :				\
83f06a5b784384 Harsh Jain 2023-02-10  110  	 (low) > (min) ?						\
83f06a5b784384 Harsh Jain 2023-02-10  111  	 (native_element) >> ((low) - (min)) :				\
83f06a5b784384 Harsh Jain 2023-02-10 @112  	 (native_element) << ((min) - (low)))
83f06a5b784384 Harsh Jain 2023-02-10  113  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
