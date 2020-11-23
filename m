Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F642BFE02
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 02:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgKWBOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 20:14:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:6750 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbgKWBOl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Nov 2020 20:14:41 -0500
IronPort-SDR: 7XZ69nit5JDSXkn+ZESXnAgIv8eBBIoK04sJRgeRR1XbkWA34NLjyIbAK0pO4j9U7n0KZmUnCY
 DuAp8joqDTOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="168174682"
X-IronPort-AV: E=Sophos;i="5.78,361,1599548400"; 
   d="scan'208";a="168174682"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2020 17:14:41 -0800
IronPort-SDR: 15ei7+3ogmIiP6fmJHzpkckgHgLx9iiXUJcKHHu8mxLciVx18EndMcnNgCPJRqCsKdADhv/nOW
 a6D/MLszqP3A==
X-IronPort-AV: E=Sophos;i="5.78,361,1599548400"; 
   d="scan'208";a="546224887"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.117]) ([10.239.13.117])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2020 17:14:38 -0800
Subject: Re: [kbuild-all] Re: [net-next,v2,4/5] seg6: add support for the SRv6
 End.DT4 behavior
To:     Jakub Kicinski <kuba@kernel.org>, kernel test robot <lkp@intel.com>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        netdev@vger.kernel.org
References: <20201107153139.3552-5-andrea.mayer@uniroma2.it>
 <202011131747.puABQV5A-lkp@intel.com>
 <20201113085730.5f3c850a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <9242894f-b831-067a-48d8-2f235963dedb@intel.com>
Date:   Mon, 23 Nov 2020 09:13:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20201113085730.5f3c850a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Sorry for the inconvenience, we have optimized the build bot to avoid 
this situation.

Best Regards,
Rong Chen

On 11/14/20 12:57 AM, Jakub Kicinski wrote:
> Good people of build bot,
>
> would you mind shedding some light on this one? It was also reported on
> v1, and Andrea said it's impossible to repro. Strange that build bot
> would make the same mistake twice, tho.
>
> Thanks!
>
> On Fri, 13 Nov 2020 17:23:09 +0800 kernel test robot wrote:
>> Hi Andrea,
>>
>> Thank you for the patch! Yet something to improve:
>>
>> [auto build test ERROR on ipvs/master]
>> [also build test ERROR on linus/master sparc-next/master v5.10-rc3 next-20201112]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use '--base' as documented in
>> https://git-scm.com/docs/git-format-patch]
>>
>> url:    https://github.com/0day-ci/linux/commits/Andrea-Mayer/seg6-add-support-for-the-SRv6-End-DT4-behavior/20201109-093019
>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
>> config: x86_64-randconfig-a005-20201111 (attached as .config)
>> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project 874b0a0b9db93f5d3350ffe6b5efda2d908415d0)
>> reproduce (this is a W=1 build):
>>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>          chmod +x ~/bin/make.cross
>>          # install x86_64 cross compiling tool for clang build
>>          # apt-get install binutils-x86-64-linux-gnu
>>          # https://github.com/0day-ci/linux/commit/761138e2f757ac64efe97b03311c976db242dc92
>>          git remote add linux-review https://github.com/0day-ci/linux
>>          git fetch --no-tags linux-review Andrea-Mayer/seg6-add-support-for-the-SRv6-End-DT4-behavior/20201109-093019
>>          git checkout 761138e2f757ac64efe97b03311c976db242dc92
>>          # save the attached .config to linux build tree
>>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>):
>>
>>>> net/ipv6/seg6_local.c:793:4: error: field designator 'slwt_ops' does not refer to any field in type 'struct seg6_action_desc'
>>                     .slwt_ops       = {
>>                      ^
>>>> net/ipv6/seg6_local.c:826:10: error: invalid application of 'sizeof' to an incomplete type 'struct seg6_action_desc []'
>>             count = ARRAY_SIZE(seg6_action_table);
>>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>     include/linux/kernel.h:48:32: note: expanded from macro 'ARRAY_SIZE'
>>     #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>>                                    ^~~~~
>>     2 errors generated.
>>
>> vim +793 net/ipv6/seg6_local.c
>>
>>     757	
>>     758	static struct seg6_action_desc seg6_action_table[] = {
>>     759		{
>>     760			.action		= SEG6_LOCAL_ACTION_END,
>>     761			.attrs		= 0,
>>     762			.input		= input_action_end,
>>     763		},
>>     764		{
>>     765			.action		= SEG6_LOCAL_ACTION_END_X,
>>     766			.attrs		= (1 << SEG6_LOCAL_NH6),
>>     767			.input		= input_action_end_x,
>>     768		},
>>     769		{
>>     770			.action		= SEG6_LOCAL_ACTION_END_T,
>>     771			.attrs		= (1 << SEG6_LOCAL_TABLE),
>>     772			.input		= input_action_end_t,
>>     773		},
>>     774		{
>>     775			.action		= SEG6_LOCAL_ACTION_END_DX2,
>>     776			.attrs		= (1 << SEG6_LOCAL_OIF),
>>     777			.input		= input_action_end_dx2,
>>     778		},
>>     779		{
>>     780			.action		= SEG6_LOCAL_ACTION_END_DX6,
>>     781			.attrs		= (1 << SEG6_LOCAL_NH6),
>>     782			.input		= input_action_end_dx6,
>>     783		},
>>     784		{
>>     785			.action		= SEG6_LOCAL_ACTION_END_DX4,
>>     786			.attrs		= (1 << SEG6_LOCAL_NH4),
>>     787			.input		= input_action_end_dx4,
>>     788		},
>>     789		{
>>     790			.action		= SEG6_LOCAL_ACTION_END_DT4,
>>     791			.attrs		= (1 << SEG6_LOCAL_TABLE),
>>     792			.input		= input_action_end_dt4,
>>   > 793			.slwt_ops	= {
>>     794						.build_state = seg6_end_dt4_build,
>>     795					  },
>>     796		},
>>     797		{
>>     798			.action		= SEG6_LOCAL_ACTION_END_DT6,
>>     799			.attrs		= (1 << SEG6_LOCAL_TABLE),
>>     800			.input		= input_action_end_dt6,
>>     801		},
>>     802		{
>>     803			.action		= SEG6_LOCAL_ACTION_END_B6,
>>     804			.attrs		= (1 << SEG6_LOCAL_SRH),
>>     805			.input		= input_action_end_b6,
>>     806		},
>>     807		{
>>     808			.action		= SEG6_LOCAL_ACTION_END_B6_ENCAP,
>>     809			.attrs		= (1 << SEG6_LOCAL_SRH),
>>     810			.input		= input_action_end_b6_encap,
>>     811			.static_headroom	= sizeof(struct ipv6hdr),
>>     812		},
>>     813		{
>>     814			.action		= SEG6_LOCAL_ACTION_END_BPF,
>>     815			.attrs		= (1 << SEG6_LOCAL_BPF),
>>     816			.input		= input_action_end_bpf,
>>     817		},
>>     818	
>>     819	};
>>     820	
>>     821	static struct seg6_action_desc *__get_action_desc(int action)
>>     822	{
>>     823		struct seg6_action_desc *desc;
>>     824		int i, count;
>>     825	
>>   > 826		count = ARRAY_SIZE(seg6_action_table);
>>     827		for (i = 0; i < count; i++) {
>>     828			desc = &seg6_action_table[i];
>>     829			if (desc->action == action)
>>     830				return desc;
>>     831		}
>>     832	
>>     833		return NULL;
>>     834	}
>>     835	
>>
>> ---
>> 0-DAY CI Kernel Test Service, Intel Corporation
>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org

