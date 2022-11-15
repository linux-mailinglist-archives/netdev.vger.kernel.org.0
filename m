Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B446629A3D
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 14:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238203AbiKON3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 08:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbiKON3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 08:29:37 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6560F1089
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:29:36 -0800 (PST)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NBRlk4GltzJn2H;
        Tue, 15 Nov 2022 21:26:26 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 21:29:34 +0800
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 15 Nov
 2022 21:29:34 +0800
Subject: Re: [PATCH net-next 0/2] net: hns3: Cleanup for static warnings.
To:     Jakub Kicinski <kuba@kernel.org>
References: <20221112081749.56229-1-lanhao@huawei.com>
 <20221114185926.23148f9e@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
Reply-To: <shenjian15@huawei.com>, <chenhao418@huawei.com>
From:   Hao Lan <lanhao@huawei.com>
Message-ID: <6c944a9e-166e-085e-912a-b239a53d6ea2@huawei.com>
Date:   Tue, 15 Nov 2022 21:29:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20221114185926.23148f9e@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.37]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

Thanks, we will send another patch.

On 2022/11/15 10:59, Jakub Kicinski wrote:
> On Sat, 12 Nov 2022 16:17:47 +0800 Hao Lan wrote:
>> Most static warnings are mainly about:
>> Patch #1: fix hns3 driver header file not self-contained issue.
>> Patch #2: add complete parentheses for some macros.
> 
> You need to say what static checker was used.
> I think it's documented in the "researcher guidelines" doc.
> In case patch 2 was based on a warning from checkpatch please
> drop it from the series, we don't take checkpatch-based cleanups.
> .
> 
