Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2165E5DCC
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 10:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiIVIp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 04:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiIVIpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 04:45:13 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9CAB4EB7;
        Thu, 22 Sep 2022 01:45:12 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MY80r2ztkzpVSH;
        Thu, 22 Sep 2022 16:42:20 +0800 (CST)
Received: from [10.67.110.176] (10.67.110.176) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 16:45:09 +0800
Subject: Re: [PATCH 2/5] mt76: Remove unused inline function
 mt76_wcid_mask_test()
To:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <idosch@nvidia.com>, <petrm@nvidia.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <nbd@nbd.name>,
        <lorenzo@kernel.org>, <ryder.lee@mediatek.com>,
        <shayne.chen@mediatek.com>, <sean.wang@mediatek.com>,
        <kvalo@kernel.org>, <matthias.bgg@gmail.com>, <amcohen@nvidia.com>,
        <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
References: <20220921090455.752011-1-cuigaosheng1@huawei.com>
 <20220921090455.752011-3-cuigaosheng1@huawei.com>
 <20220921061111.6d960cc3@kernel.org>
 <73a16853-d6fc-8a14-8050-d78c8fcd0e3a@quicinc.com>
From:   cuigaosheng <cuigaosheng1@huawei.com>
Message-ID: <cfe96d7e-c7b0-4320-35b4-958190d601ad@huawei.com>
Date:   Thu, 22 Sep 2022 16:45:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <73a16853-d6fc-8a14-8050-d78c8fcd0e3a@quicinc.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.176]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 9/21/2022 6:11 AM, Jakub Kicinski wrote:
>> On Wed, 21 Sep 2022 17:04:52 +0800 Gaosheng Cui wrote:
>>> All uses of mt76_wcid_mask_test() have
>>> been removed since commit 8950a62f19c9 ("mt76: get rid of
>>> mt76_wcid_hw routine"), so remove it.
>>
>> This should go via the wireless tree, please take it out of this series
>> and send it to linux-wireless separately.
>
> And when you do that add wifi: prefix to the subject
> .

Thanks for taking time to review this patch, I have made a patch v2 and 
submitted it.

link: 
https://lore.kernel.org/netdev/20220922074711.1408385-1-cuigaosheng1@huawei.com/


