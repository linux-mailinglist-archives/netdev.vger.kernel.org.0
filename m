Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AA84A9D8E
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376849AbiBDRSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:18:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:10667 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349319AbiBDRSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 12:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643995118; x=1675531118;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AoW3kNR5605uvpDcAlBLCX5Yx9vfaFMieXE8ktujwDY=;
  b=f1wx//xcc5FkozRf249Nw62SvjwHHKwmke2J03t18DshsCjtQ79HdrTY
   R0osi1FPeY7Ikv0g+9e4OPowu+96TKIOOKeHMLj09BIDLxLJEZA+yuUCD
   S4qJMK6vzCY36Ba9v+ZDzYmQR/NdKJr2jjPZb+YCtUOJxN6/4Q0NLP7ib
   otf3A1e1K2dh/4zO6Tp5nra/wlMiJhVtabmvbct01JsUV6eKk/n+2azTL
   ulBO7Y4eUGPINCNSaNgicYpiLfK3kx6Z7bovVevoiTW4UOAxEpI3iTfa6
   0Kq/t1630m/2uwPCOBs5sPqhjt48MJAZbEO9QNaYXPFhn0SEMpVTwo/qh
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="248353529"
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="248353529"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 09:18:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="631762926"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 04 Feb 2022 09:18:36 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nG2EF-000XvR-PH; Fri, 04 Feb 2022 17:18:35 +0000
Date:   Sat, 5 Feb 2022 01:18:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>, pablo@netfilter.org
Cc:     kbuild-all@lists.01.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH nf-next] nfqueue: enable to set skb->priority
Message-ID: <202202050128.hIk17NxG-lkp@intel.com>
References: <20220204102143.4010-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204102143.4010-1-nicolas.dichtel@6wind.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on nf-next/master]

url:    https://github.com/0day-ci/linux/commits/Nicolas-Dichtel/nfqueue-enable-to-set-skb-priority/20220204-182222
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20220205/202202050128.hIk17NxG-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/6a71b6ea544796cb9976502dfd64361abb745cc5
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Nicolas-Dichtel/nfqueue-enable-to-set-skb-priority/20220204-182222
        git checkout 6a71b6ea544796cb9976502dfd64361abb745cc5
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/ net/netfilter/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/netfilter/nfnetlink_queue.c:1017:3: error: 'NFQA_PRIORITY' undeclared here (not in a function); did you mean 'FRA_PRIORITY'?
    1017 |  [NFQA_PRIORITY]  = { .type = NLA_U32 },
         |   ^~~~~~~~~~~~~
         |   FRA_PRIORITY
>> net/netfilter/nfnetlink_queue.c:1017:3: error: array index in initializer not of integer type
   net/netfilter/nfnetlink_queue.c:1017:3: note: (near initialization for 'nfqa_verdict_policy')
   net/netfilter/nfnetlink_queue.c:1023:3: error: array index in initializer not of integer type
    1023 |  [NFQA_PRIORITY]  = { .type = NLA_U32 },
         |   ^~~~~~~~~~~~~
   net/netfilter/nfnetlink_queue.c:1023:3: note: (near initialization for 'nfqa_verdict_batch_policy')


vim +1017 net/netfilter/nfnetlink_queue.c

  1009	
  1010	static const struct nla_policy nfqa_verdict_policy[NFQA_MAX+1] = {
  1011		[NFQA_VERDICT_HDR]	= { .len = sizeof(struct nfqnl_msg_verdict_hdr) },
  1012		[NFQA_MARK]		= { .type = NLA_U32 },
  1013		[NFQA_PAYLOAD]		= { .type = NLA_UNSPEC },
  1014		[NFQA_CT]		= { .type = NLA_UNSPEC },
  1015		[NFQA_EXP]		= { .type = NLA_UNSPEC },
  1016		[NFQA_VLAN]		= { .type = NLA_NESTED },
> 1017		[NFQA_PRIORITY]		= { .type = NLA_U32 },
  1018	};
  1019	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
