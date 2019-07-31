Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C89A7C7E1
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730323AbfGaP7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:59:10 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50084 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730160AbfGaP7J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 11:59:09 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6753393EB0F19B20B741;
        Wed, 31 Jul 2019 23:59:05 +0800 (CST)
Received: from [127.0.0.1] (10.184.191.73) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Wed, 31 Jul 2019
 23:58:54 +0800
Subject: Re: [PATCH net v2] ipvs: Improve robustness to the ipvs sysctl
To:     Julian Anastasov <ja@ssi.bg>
CC:     <wensong@linux-vs.org>, <horms@verge.net.au>,
        <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <lvs-devel@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>, Mingfangsen <mingfangsen@huawei.com>,
        <wangxiaogang3@huawei.com>, <xuhanbing@huawei.com>
References: <1997375e-815d-137f-20c9-0829a8587ee9@huawei.com>
 <4a0476d3-57a4-50e0-cae8-9dffc4f4d556@huawei.com>
 <alpine.LFD.2.21.1907302226340.4897@ja.home.ssi.bg>
From:   hujunwei <hujunwei4@huawei.com>
Message-ID: <484fef63-710a-701e-3151-eefaf3b9b1ca@huawei.com>
Date:   Wed, 31 Jul 2019 23:58:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.21.1907302226340.4897@ja.home.ssi.bg>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.191.73]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Julian

On 2019/7/31 3:29, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Tue, 30 Jul 2019, hujunwei wrote:
> 
>> From: Junwei Hu <hujunwei4@huawei.com>
>>
>> The ipvs module parse the user buffer and save it to sysctl,
>> then check if the value is valid. invalid value occurs
>> over a period of time.
>> Here, I add a variable, struct ctl_table tmp, used to read
>> the value from the user buffer, and save only when it is valid.
>> I delete proc_do_sync_mode and use extra1/2 in table for the
>> proc_dointvec_minmax call.
>>
>> Fixes: f73181c8288f ("ipvs: add support for sync threads")
>> Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
> 
> 	Looks good to me, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>
> 
> 	BTW, why ip_vs_zero_all everywhere? Due to old git version?
> 

I will update the git version and send the patch v3.

Regards,
Junwei

