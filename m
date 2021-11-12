Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D584844E075
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 03:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhKLCtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 21:49:52 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:27201 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhKLCtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 21:49:51 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Hr2xs1CN3z8vNN;
        Fri, 12 Nov 2021 10:45:21 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.15; Fri, 12 Nov 2021 10:46:48 +0800
Received: from [10.174.179.215] (10.174.179.215) by
 dggema769-chm.china.huawei.com (10.1.198.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Fri, 12 Nov 2021 10:46:47 +0800
Subject: Re: 32bit x86 build broken (was: Re: [GIT PULL] Networking for
 5.16-rc1)
To:     Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
CC:     <torvalds@linux-foundation.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <linux-can@vger.kernel.org>
References: <20211111163301.1930617-1-kuba@kernel.org>
 <163667214755.13198.7575893429746378949.pr-tracker-bot@kernel.org>
 <20211111174654.3d1f83e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <c8e95de5-ae1e-a36b-06ac-101132ac2da3@huawei.com>
Date:   Fri, 12 Nov 2021 10:46:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20211111174654.3d1f83e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/11/12 9:46, Jakub Kicinski wrote:
> On Thu, 11 Nov 2021 23:09:07 +0000 pr-tracker-bot@kernel.org wrote:
>> The pull request you sent on Thu, 11 Nov 2021 08:33:01 -0800:
>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc1  
>>
>> has been merged into torvalds/linux.git:
>> https://git.kernel.org/torvalds/c/f54ca91fe6f25c2028f953ce82f19ca2ea0f07bb
> 
> Rafael, Srinivas, we're getting 32 bit build failures after pulling back
> from Linus today.
> 
> make[1]: *** [/home/nipa/net/Makefile:1850: drivers] Error 2
> make: *** [Makefile:219: __sub-make] Error 2
> ../drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c: In function ‘send_mbox_cmd’:
> ../drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c:79:37: error: implicit declaration of function ‘readq’; did you mean ‘readl’? [-Werror=implicit-function-declaration]
>    79 |                         *cmd_resp = readq((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_DATA));
>       |                                     ^~~~~
>       |                                     readl
> 
> Is there an ETA on getting this fixed?

This is fixed by:
https://lore.kernel.org/lkml/a22a1eeb-c7a0-74c1-46e2-0a7bada73520@infradead.org/T/

> 
> 
> .
> 
