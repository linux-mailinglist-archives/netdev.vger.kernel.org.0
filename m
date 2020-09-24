Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902CD2765CF
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgIXB0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:26:39 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3557 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725208AbgIXB0j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 21:26:39 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 5E62A9535F5CD6CC1A8F;
        Thu, 24 Sep 2020 09:26:36 +0800 (CST)
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 24 Sep 2020 09:26:35 +0800
Subject: Re: [PATCH net] hinic: fix wrong return value of mac-set cmd
To:     David Miller <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>, <zengweiliang.zengweiliang@huawei.com>
References: <20200922112643.15726-1-luobin9@huawei.com>
 <20200923.174352.634025554486458032.davem@davemloft.net>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <2794a80f-1e69-3050-5b8b-4fff75f3a69a@huawei.com>
Date:   Thu, 24 Sep 2020 09:26:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200923.174352.634025554486458032.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/24 8:43, David Miller wrote:
> From: Luo bin <luobin9@huawei.com>
> Date: Tue, 22 Sep 2020 19:26:43 +0800
> 
>> It should also be regarded as an error when hw return status=4 for PF's
>> setting mac cmd. Only if PF return status=4 to VF should this cmd be
>> taken special treatment.
>>
>> Signed-off-by: Luo bin <luobin9@huawei.com>
> 
> Bug fixes require a proper Fixes: tag.
> 
> Please resubmit with the corrected, thank you.
> .
> 
Will fix. Thanks!
