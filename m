Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFD86404C
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfGJFFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 01:05:30 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41080 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726234AbfGJFFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 01:05:30 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 25DF892C0BA70E4A1D17;
        Wed, 10 Jul 2019 13:05:27 +0800 (CST)
Received: from [127.0.0.1] (10.65.87.206) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Wed, 10 Jul 2019
 13:05:20 +0800
Subject: Re: [PATCH v2 05/10] net: hisilicon: HI13X1_GMAX need dreq reset at
 first
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <davem@davemloft.net>, <robh+dt@kernel.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <mark.rutland@arm.com>, <dingtianhong@huawei.com>
References: <1562643071-46811-1-git-send-email-xiaojiangfeng@huawei.com>
 <1562643071-46811-6-git-send-email-xiaojiangfeng@huawei.com>
 <890c48d1-76b8-5aea-e175-aa7d9967acd2@cogentembedded.com>
 <101b8c68-75f5-00a7-9845-e59c0467768c@huawei.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <leeyou.li@huawei.com>,
        <nixiaoming@huawei.com>, <jianping.liu@huawei.com>,
        <xiekunxun@huawei.com>
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Message-ID: <5e3eda91-dedc-e687-6a18-b1aec1e9fe63@huawei.com>
Date:   Wed, 10 Jul 2019 13:05:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <101b8c68-75f5-00a7-9845-e59c0467768c@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.87.206]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/9 21:48, Jiangfeng Xiao wrote:
> 
> 
> On 2019/7/9 17:35, Sergei Shtylyov wrote:
>> Hello!
>>
>> On 09.07.2019 6:31, Jiangfeng Xiao wrote:
>>
[...]
>>> @@ -853,6 +867,15 @@ static int hip04_mac_probe(struct platform_device *pdev)
>>>           goto init_fail;
>>>       }
>>>   +#if defined(CONFIG_HI13X1_GMAC)
>>> +    res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>>> +    priv->sysctrl_base = devm_ioremap_resource(d, res);
>>
>>    There's devm_platform_ioremap_resource() now.
> 
> Thank you for your review, Great issue, which makes my code more concise.
> 
> I will fix it in v3. Or submit a patch to modify it separately, if maintainer
> applies this patch series.
> 
I decided to wait for this series of patches to sync to the mainline
and then fix this based on the mainline.

Because the mainline does not currently have this part of the code,
if I submit the changes, and the patch is accidentally merged into
another branch or another maintainer to handle, a conflict will occur.

As we all know, maintianer has to deal with many commits every day,
I don't want to increase the burden of maintainer.

So I decided to wait until the patch is synced to the mainline
and then modify it, which is more safe.

