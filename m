Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6ED609800
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 03:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiJXB7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 21:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiJXB7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 21:59:03 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2BA6E2EC;
        Sun, 23 Oct 2022 18:59:03 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MwdRF2m0bzVj44;
        Mon, 24 Oct 2022 09:54:17 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 09:59:01 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 09:59:00 +0800
Subject: Re: [PATCH -next] rfkill: replace BUG_ON() with WARN_ON() in core.c
To:     Leon Romanovsky <leon@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <johannes@sipsolutions.net>
References: <20221021135738.524370-1-yangyingliang@huawei.com>
 <Y1T4aWIbueaf4jYM@unreal>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <ab635939-6763-42c1-0410-79e6c65b4568@huawei.com>
Date:   Mon, 24 Oct 2022 09:58:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <Y1T4aWIbueaf4jYM@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/10/23 16:16, Leon Romanovsky wrote:
> On Fri, Oct 21, 2022 at 09:57:38PM +0800, Yang Yingliang wrote:
>> Replace BUG_ON() with WARN_ON() to handle fault more gracefully.
>>
>> Suggested-by: Johannes Berg <johannes@sipsolutions.net>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   net/rfkill/core.c | 25 ++++++++++++++++---------
>>   1 file changed, 16 insertions(+), 9 deletions(-)
> Please add changelog and version numbers when you set your series.
>
> The same comment as https://lore.kernel.org/all/Y1T3a1y/pWdbt2ow@unreal
The link is unreachable.
> or you should delete BUG_ONs completely or simply replace them with WARN_ONs.
>
> There is no need in all these if (...).
If remove BUG_ONs or not use if (...), it may lead null-ptr-deref, it's 
same as
using BUG_ON(), which leads system crash.

Thanks,
Yang
>
> Thanks
> .
