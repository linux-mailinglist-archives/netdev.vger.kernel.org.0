Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDDA6E2DEF
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 02:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjDOAdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 20:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDOAdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 20:33:03 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2735149D7
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 17:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681518782; x=1713054782;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6P7E7NKEe41OzyBVirlyoWHp+A1sk8HOKEYg38W59q4=;
  b=nm1ZwwILa12PyQDRhshq5qZ0kK1hp+nnRjMmLunvn3YhgehJvKZdR6nT
   PNn4Y/bZZM4reknxXm5xKFV8dgpJWNGpi1//F1WwOcKZ+5Cv8ttvE2Lm8
   vruSLCY9nuRf8TkJWtprRxBovS4YFnz2Wlpdhr0U2gJIO4tZ/tXA1tJ5G
   kPdrelJbxxiNPlOZSsdqU451gi+m9oQpuTksLUoAtOQ4oy9xXqftPcF7Q
   lMQgRd9adcT1R6ZeIkzFV6mdOo2o8xHDh3FfPXrs3ghM2IBAiuc5J7p0v
   h6rjXzL4r5bxi4RC6+1LTdbaY+TuPlMaY8sjGm9Y1CD3vTo8zytc++egB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="430891691"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="430891691"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 17:33:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="667380242"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="667380242"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 14 Apr 2023 17:32:59 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pnTqc-000aAN-1V;
        Sat, 15 Apr 2023 00:32:58 +0000
Date:   Sat, 15 Apr 2023 08:32:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, pablo@netfilter.org,
        fw@strlen.de
Subject: Re: [PATCH net-next 5/5] net: skbuff: hide nf_trace and ipvs_property
Message-ID: <202304150856.ZcdKTZna-lkp@intel.com>
References: <20230414160105.172125-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414160105.172125-6-kuba@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Kicinski/net-skbuff-hide-wifi_acked-when-CONFIG_WIRELESS-not-set/20230415-000750
patch link:    https://lore.kernel.org/r/20230414160105.172125-6-kuba%40kernel.org
patch subject: [PATCH net-next 5/5] net: skbuff: hide nf_trace and ipvs_property
config: ia64-randconfig-r031-20230409 (https://download.01.org/0day-ci/archive/20230415/202304150856.ZcdKTZna-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e2a92e33e41fe773b7c4a32a75db87340855387a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jakub-Kicinski/net-skbuff-hide-wifi_acked-when-CONFIG_WIRELESS-not-set/20230415-000750
        git checkout e2a92e33e41fe773b7c4a32a75db87340855387a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304150856.ZcdKTZna-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/nf_tables_core.c: In function 'nft_trace_packet':
>> net/netfilter/nf_tables_core.c:64:42: error: 'struct sk_buff' has no member named 'nf_trace'
      64 |                 info->nf_trace = pkt->skb->nf_trace;
         |                                          ^~
   net/netfilter/nf_tables_core.c: In function 'nft_trace_copy_nftrace':
   net/netfilter/nf_tables_core.c:75:50: error: 'struct sk_buff' has no member named 'nf_trace'
      75 |                         info->nf_trace = pkt->skb->nf_trace;
         |                                                  ^~
   net/netfilter/nf_tables_core.c: In function '__nft_trace_verdict':
   net/netfilter/nf_tables_core.c:132:56: error: 'struct sk_buff' has no member named 'nf_trace'
     132 |                         info->nf_trace = info->pkt->skb->nf_trace;
         |                                                        ^~
--
   net/netfilter/nf_tables_trace.c: In function 'nft_trace_init':
>> net/netfilter/nf_tables_trace.c:284:34: error: 'struct sk_buff' has no member named 'nf_trace'
     284 |         info->nf_trace = pkt->skb->nf_trace;
         |                                  ^~
--
   net/netfilter/nft_meta.c: In function 'nft_meta_set_eval':
>> net/netfilter/nft_meta.c:446:20: error: 'struct sk_buff' has no member named 'nf_trace'
     446 |                 skb->nf_trace = !!value8;
         |                    ^~


vim +64 net/netfilter/nf_tables_core.c

01ef16c2dd2e9a Patrick McHardy   2015-03-03  56  
399a14ec7993d6 Florian Westphal  2022-08-04  57  static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
399a14ec7993d6 Florian Westphal  2022-08-04  58  				    struct nft_traceinfo *info,
01ef16c2dd2e9a Patrick McHardy   2015-03-03  59  				    const struct nft_chain *chain,
2c865a8a28a10e Pablo Neira Ayuso 2022-01-09  60  				    const struct nft_rule_dp *rule,
33d5a7b14bfd02 Florian Westphal  2015-11-28  61  				    enum nft_trace_types type)
01ef16c2dd2e9a Patrick McHardy   2015-03-03  62  {
e639f7ab079b52 Florian Westphal  2015-11-28  63  	if (static_branch_unlikely(&nft_trace_enabled)) {
e34b9ed96ce3b0 Florian Westphal  2022-06-22 @64  		info->nf_trace = pkt->skb->nf_trace;
33d5a7b14bfd02 Florian Westphal  2015-11-28  65  		info->rule = rule;
e65eebec9c67df Florian Westphal  2018-05-11  66  		__nft_trace_packet(info, chain, type);
33d5a7b14bfd02 Florian Westphal  2015-11-28  67  	}
01ef16c2dd2e9a Patrick McHardy   2015-03-03  68  }
01ef16c2dd2e9a Patrick McHardy   2015-03-03  69  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
