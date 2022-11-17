Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFAE62D8A3
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 11:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239663AbiKQK5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 05:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239715AbiKQK5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:57:02 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D996BDC5
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 02:54:42 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NCcCJ0yp7zqSTb;
        Thu, 17 Nov 2022 18:50:52 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 18:54:40 +0800
Message-ID: <5be5b648-d72a-5577-1d34-dfa9a6658827@huawei.com>
Date:   Thu, 17 Nov 2022 18:54:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH 0/3 v2] 9p: Fix write overflow in p9_read_work
Content-Language: en-US
To:     <asmadeus@codewreck.org>
CC:     <ericvh@gmail.com>, <lucho@ionkov.net>, <linux_oss@crudebyte.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <v9fs-developer@lists.sourceforge.net>,
        <netdev@vger.kernel.org>
References: <20221117091159.31533-1-guozihua@huawei.com>
 <Y3YRuHnkULT1Ti3l@codewreck.org>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <Y3YRuHnkULT1Ti3l@codewreck.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/17 18:49, asmadeus@codewreck.org wrote:
> GUO Zihua wrote on Thu, Nov 17, 2022 at 05:11:56PM +0800:
>> This patchset fixes the write overflow issue in p9_read_work. As well as
>> some follow up cleanups.
> 
> Thanks for this v2.
> 
> Comments below
> 
>> GUO Zihua (3):
>>    9p: Fix write overflow in p9_read_work
>>    9p: Remove redundent checks for message size against msize.
> 
> This has 'Fixes: 3da2e34b64cd ("9p: Fix write overflow in
> p9_read_work")' but that commit isn't applied yet, so the commit hash
> only exists in your tree -- I will get a different hash when I apply the
> patch (because it'll contain my name as committer, date changed etc)
> 
> I don't think it really makes sense to separate these two patches, I'll
> squash them together on my side.
> 
>>    9p: Use P9_HDRSZ for header size
> 
> This makes sense to keep separate, I'll just drop the 'fixes' tag for
> the same reason as above
> 
> 
> I'll do the squash & test tomorrow, you don't need to resend.
> I will tell you when I push to next so you can check you're happy with
> my version.

Sounds great! Thanks Dominique!
-- 
Best
GUO Zihua

