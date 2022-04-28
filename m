Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C2F5128DA
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 03:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238962AbiD1Bdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 21:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbiD1Bds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 21:33:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24771DA53;
        Wed, 27 Apr 2022 18:30:35 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KpdKS4znvzGpPn;
        Thu, 28 Apr 2022 09:27:56 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 28 Apr 2022 09:30:34 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 28 Apr 2022 09:30:33 +0800
Subject: Re: [PATCH -next] net: cpsw: add missing of_node_put() in
 cpsw_probe_dt()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <grygorii.strashko@ti.com>, <davem@davemloft.net>
References: <20220426124757.373587-1-yangyingliang@huawei.com>
 <20220427175245.2311a74c@kernel.org>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <44de5ff6-90ec-8e5c-ef49-7b720aba5f99@huawei.com>
Date:   Thu, 28 Apr 2022 09:30:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20220427175245.2311a74c@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/4/28 8:52, Jakub Kicinski wrote:
> On Tue, 26 Apr 2022 20:47:57 +0800 Yang Yingliang wrote:
>> Subject: [PATCH -next] net: cpsw: add missing of_node_put() in cpsw_probe_dt()
> Why next? The commit under Fixes is in Linus's tree.
>
> Please sort this out and repost.
It supposed to net, I write a wrong title, I will resend it.

Thanks,
Yang
>
>> If devm_kcalloc() fails, 'tmp_node' should be put in cpsw_probe_dt().
>>
>> Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> .
