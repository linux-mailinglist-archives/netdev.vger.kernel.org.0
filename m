Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE511320B79
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 16:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhBUPhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 10:37:50 -0500
Received: from mga07.intel.com ([134.134.136.100]:53136 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhBUPhu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Feb 2021 10:37:50 -0500
IronPort-SDR: A4e/65PIbll+kOJIR9BSEfugj9kBrSrnN9fqhu+nCMsPgKa9m6JSAzK2Xib3XX4L/2ICMx7vkC
 X+62LzrmGfDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9901"; a="248309966"
X-IronPort-AV: E=Sophos;i="5.81,195,1610438400"; 
   d="scan'208";a="248309966"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2021 07:37:05 -0800
IronPort-SDR: suaj0f+En1ymZx9DVfmQGFvnmWO8FM5esTnuaJJnE7BPx0PDimxbDJw9/8UCyi6RpMR60X/T77
 tbMJE4n8+Hww==
X-IronPort-AV: E=Sophos;i="5.81,195,1610438400"; 
   d="scan'208";a="402040142"
Received: from vyakovle-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.38.19])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2021 07:37:03 -0800
Subject: Re: [PATCH bpf-next v2 1/2] bpf, xdp: per-map bpf_redirect_map
 functions for XDP
To:     kernel test robot <lkp@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, maciej.fijalkowski@intel.com,
        hawk@kernel.org, toke@redhat.com, magnus.karlsson@intel.com,
        john.fastabend@gmail.com
References: <20210220153056.111968-2-bjorn.topel@gmail.com>
 <202102210003.jU1k0vMh-lkp@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <7abb8101-6f4b-a79e-935b-c2377680d858@intel.com>
Date:   Sun, 21 Feb 2021 16:36:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <202102210003.jU1k0vMh-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-20 18:00, kernel test robot wrote:
> Hi "Björn,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on 7b1e385c9a488de9291eaaa412146d3972e9dec5]
> 
> url:    https://github.com/0day-ci/linux/commits/Bj-rn-T-pel/Optimize-bpf_redirect_map-xdp_do_redirect/20210220-233623
> base:   7b1e385c9a488de9291eaaa412146d3972e9dec5
> config: s390-randconfig-m031-20210221 (attached as .config)
> compiler: s390-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/0day-ci/linux/commit/3995bc7a37a3a7975c4a04f668408d5aa31cbe37
>          git remote add linux-review https://github.com/0day-ci/linux
>          git fetch --no-tags linux-review Bj-rn-T-pel/Optimize-bpf_redirect_map-xdp_do_redirect/20210220-233623
>          git checkout 3995bc7a37a3a7975c4a04f668408d5aa31cbe37
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=s390
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>     s390-linux-ld: kernel/bpf/verifier.o: in function `fixup_bpf_calls':
>>> verifier.c:(.text+0xa4fc): undefined reference to `get_xdp_redirect_func'
>

This is triggered when CONFIG_NET is not set. For some reason I thought
that BPF implied NET, but this was wrong. I'll fix this in v3.


Björn


> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 
