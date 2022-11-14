Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A8C627816
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbiKNIrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235899AbiKNIrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:47:37 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A401BE8E
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:47:37 -0800 (PST)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N9jX55RBgzqSMM;
        Mon, 14 Nov 2022 16:43:49 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 16:47:35 +0800
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 14 Nov
 2022 16:47:35 +0800
Subject: Re: [PATCH net 2/3] net: hns3: fix return value check bug of rx
 copybreak
To:     Leon Romanovsky <leon@kernel.org>
References: <20221112082118.57844-1-lanhao@huawei.com>
 <20221112082118.57844-3-lanhao@huawei.com> <Y3HwyOlO1FXhiPcS@unreal>
CC:     <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <linyunsheng@huawei.com>, <liuyonglong@huawei.com>,
        <chenhao418@huawei.com>, <wangjie125@huawei.com>,
        <huangguangbin2@huawei.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <xiaojiantao1@h-partners.com>
From:   Hao Lan <lanhao@huawei.com>
Message-ID: <750a820f-b01a-59f5-a6c9-26e0d793dafe@huawei.com>
Date:   Mon, 14 Nov 2022 16:47:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <Y3HwyOlO1FXhiPcS@unreal>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.37]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you, I will send patch V2.

On 2022/11/14 15:39, Leon Romanovsky wrote:
> On Sat, Nov 12, 2022 at 04:21:17PM +0800, Hao Lan wrote:
>> From: Jie Wang <wangjie125@huawei.com>
>>
>> The refactoring of rx copybreak modifies the original return logic, which
>> will make this feature unavailable. So this patch fixes the return logic of
>> rx copybreak.
>>
>> Fixes: e74a726da2c4 ("net: hns3: refactor hns3_nic_reuse_page()")
>> Fixes: 99f6b5fb5f63 ("net: hns3: use bounce buffer when rx page can not be reused")
>>
>> Signed-off-by: Jie Wang <wangjie125@huawei.com>
> 
> Please delete blank line between Fixes and SOBs, in all three patches.
> 
> Thanks
> .
> 
