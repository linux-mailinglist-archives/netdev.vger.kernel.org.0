Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3062D2DB8B4
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 03:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgLPCCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 21:02:54 -0500
Received: from mga07.intel.com ([134.134.136.100]:29780 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgLPCCx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 21:02:53 -0500
IronPort-SDR: CdRbEUacfwsdel4GdFMc2wxd64E5ZkKRkcroLSdvsZuwWkvrGyAeGKuG/Gc31eeUx9wJwuAztc
 iYoy3rgaQFRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="239083019"
X-IronPort-AV: E=Sophos;i="5.78,423,1599548400"; 
   d="scan'208";a="239083019"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 18:02:12 -0800
IronPort-SDR: 2aCwRwf+9gWdIItrlMWBNnRQXh+Rj0I5QHH5o2I1EK8pVJb+BfZOmDbtvQF1gavdq4W9oMUqvd
 50N0JsEq/WTQ==
X-IronPort-AV: E=Sophos;i="5.78,423,1599548400"; 
   d="scan'208";a="337920350"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.117]) ([10.239.13.117])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 18:02:08 -0800
Subject: Re: [kbuild-all] Re: [PATCH 1/3] Add TX sending hardware timestamp.
To:     Philip Li <philip.li@intel.com>,
        "Geva, Erez" <erez.geva.ext@siemens.com>
Cc:     kernel test robot <lkp@intel.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>, Sudler@ml01.01.org,
        Andreas <andreas.meisinger@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>
References: <20201209143707.13503-2-erez.geva.ext@siemens.com>
 <202012101050.lTUKkbvy-lkp@intel.com>
 <VI1PR10MB244664932EF569D492539DB8ABCB0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <20201212084708.GA31899@intel.com>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <9ac27644-6e7b-e618-2750-7e6c77465410@intel.com>
Date:   Wed, 16 Dec 2020 10:01:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20201212084708.GA31899@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/20 4:47 PM, Philip Li wrote:
> On Thu, Dec 10, 2020 at 12:41:32PM +0000, Geva, Erez wrote:
>> On 10/12/2020 04:11, kernel test robot wrote:
>>> Hi Erez,
>>>
>>> Thank you for the patch! Yet something to improve:
>>>
>> Thanks for the robot,
>> as we rarely use clang for kernel. It is very helpful.
>>
>>> [auto build test ERROR on b65054597872ce3aefbc6a666385eabdf9e288da]
>>>
>>> url:    https://github.com/0day-ci/linux/commits/Erez-Geva/Add-sending-TX-hardware-timestamp-for-TC-ETF-Qdisc/20201210-000521
>> I can not find this commit

Hi Erez,

The url has been recovered now.

Best Regards,
Rong Chen

>>
>>> base:    b65054597872ce3aefbc6a666385eabdf9e288da
>>> config: mips-randconfig-r026-20201209 (attached as .config)
>>> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project 1968804ac726e7674d5de22bc2204b45857da344)
>> However the clang in
>> https://download.01.org/0day-ci/cross-package/clang-latest/clang.tar.xz  is version 11
> Sorry that these are issues at our side, including the branch/commit missing.
> The push to download.01.org failed and did not really work, we will look for
> recovering them.
>
>>> reproduce (this is a W=1 build):
>>>           wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>> Your make cross script tries to download the clang every time.
>> Please separate the download (which is ~400 MB and 2 GB after open) from the compilation.
> Hi Erez, thanks for your feedback, we will improve the reproduction
> side per these suggestions.
>
>> Please use "wget" follow your own instructions in this email.
>>
>>>           chmod +x ~/bin/make.cross
>>>           # install mips cross compiling tool for clang build
>>>           # apt-get install binutils-mips-linux-gnu
>>>           # https://github.com/0day-ci/linux/commit/8a8f634bc74db16dc551cfcf3b63c1183f98eaac
>>>           git remote add linux-review https://github.com/0day-ci/linux
>>>           git fetch --no-tags linux-review Erez-Geva/Add-sending-TX-hardware-timestamp-for-TC-ETF-Qdisc/20201210-000521
>> This branch is absent
>>
>>>           git checkout 8a8f634bc74db16dc551cfcf3b63c1183f98eaac
>> This commit as well
>>
>>>           # save the attached .config to linux build tree
>>>           COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=mips
>>>
>> I use Debian 10.7.
>> I usually compile with GCC. I have not see any errors.
>>
>> When I use clang 11 from download.01.org I get a crash right away.
>> Please add a proper instructions how to use clang on Debian or provide
>> a Docker container with updated clang for testing.
>>
>>> If you fix the issue, kindly add following tag as appropriate
>>> Reported-by: kernel test robot <lkp@intel.com>
>>>
>>> All errors (new ones prefixed by >>):
>>>
>>>>> net/core/sock.c:2383:7: error: use of undeclared identifier 'SCM_HW_TXTIME'; did you mean 'SOCK_HW_TXTIME'?
>>>              case SCM_HW_TXTIME:
>>>                   ^~~~~~~~~~~~~
>>>                   SOCK_HW_TXTIME
>>>      include/net/sock.h:862:2: note: 'SOCK_HW_TXTIME' declared here
>>>              SOCK_HW_TXTIME,
>>>              ^
>>>      1 error generated.
>>>
>>> vim +2383 net/core/sock.c
>>>
>>>     2351	
>>>     2352	int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct cmsghdr *cmsg,
>>>     2353			     struct sockcm_cookie *sockc)
>>>     2354	{
>>>     2355		u32 tsflags;
>>>     2356	
>>>     2357		switch (cmsg->cmsg_type) {
>>>     2358		case SO_MARK:
>>>     2359			if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
>>>     2360				return -EPERM;
>>>     2361			if (cmsg->cmsg_len != CMSG_LEN(sizeof(u32)))
>>>     2362				return -EINVAL;
>>>     2363			sockc->mark = *(u32 *)CMSG_DATA(cmsg);
>>>     2364			break;
>>>     2365		case SO_TIMESTAMPING_OLD:
>>>     2366			if (cmsg->cmsg_len != CMSG_LEN(sizeof(u32)))
>>>     2367				return -EINVAL;
>>>     2368	
>>>     2369			tsflags = *(u32 *)CMSG_DATA(cmsg);
>>>     2370			if (tsflags & ~SOF_TIMESTAMPING_TX_RECORD_MASK)
>>>     2371				return -EINVAL;
>>>     2372	
>>>     2373			sockc->tsflags &= ~SOF_TIMESTAMPING_TX_RECORD_MASK;
>>>     2374			sockc->tsflags |= tsflags;
>>>     2375			break;
>>>     2376		case SCM_TXTIME:
>>>     2377			if (!sock_flag(sk, SOCK_TXTIME))
>>>     2378				return -EINVAL;
>>>     2379			if (cmsg->cmsg_len != CMSG_LEN(sizeof(u64)))
>>>     2380				return -EINVAL;
>>>     2381			sockc->transmit_time = get_unaligned((u64 *)CMSG_DATA(cmsg));
>>>     2382			break;
>>>> 2383		case SCM_HW_TXTIME:
>>>     2384			if (!sock_flag(sk, SOCK_HW_TXTIME))
>>>     2385				return -EINVAL;
>>>     2386			if (cmsg->cmsg_len != CMSG_LEN(sizeof(u64)))
>>>     2387				return -EINVAL;
>>>     2388			sockc->transmit_hw_time = get_unaligned((u64 *)CMSG_DATA(cmsg));
>>>     2389			break;
>>>     2390		/* SCM_RIGHTS and SCM_CREDENTIALS are semantically in SOL_UNIX. */
>>>     2391		case SCM_RIGHTS:
>>>     2392		case SCM_CREDENTIALS:
>>>     2393			break;
>>>     2394		default:
>>>     2395			return -EINVAL;
>>>     2396		}
>>>     2397		return 0;
>>>     2398	}
>>>     2399	EXPORT_SYMBOL(__sock_cmsg_send);
>>>     2400	
>>>
>>> ---
>>> 0-DAY CI Kernel Test Service, Intel Corporation
>>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>>>
>> Please improve the robot, so we can comply and properly support clang compilation.
> Got it, we will keep improving the bot.
>
>> Thanks
>>     Erez
>> _______________________________________________
>> kbuild-all mailing list -- kbuild-all@lists.01.org
>> To unsubscribe send an email to kbuild-all-leave@lists.01.org
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org

