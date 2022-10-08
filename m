Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFADB5F8236
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 03:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJHB72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 21:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJHB71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 21:59:27 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFD311C254;
        Fri,  7 Oct 2022 18:59:26 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MkpCX0LDlzVj19;
        Sat,  8 Oct 2022 09:55:04 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 8 Oct 2022 09:59:24 +0800
Received: from [10.67.108.67] (10.67.108.67) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 8 Oct
 2022 09:59:24 +0800
Message-ID: <580db9d2-b1de-e8b8-12c9-11c9fec292ff@huawei.com>
Date:   Sat, 8 Oct 2022 09:59:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH -next] net: mvneta: Remove unused variables 'i'
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20221010032506.2886099-1-chenzhongjin@huawei.com>
 <20220930085104.1400066b@kernel.org>
Content-Language: en-US
From:   Chen Zhongjin <chenzhongjin@huawei.com>
In-Reply-To: <20220930085104.1400066b@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.108.67]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/9/30 23:51, Jakub Kicinski wrote:
> On Mon, 10 Oct 2022 11:25:06 +0800 Chen Zhongjin wrote:
>> Reported by Clang [-Wunused-but-set-variable]
>>
>> 'commit cad5d847a093 ("net: mvneta: Fix the CPU choice in mvneta_percpu_elect")'
>> This commit had changed the logic to elect CPU in mvneta_percpu_elect().
>> Now the variable 'i' is not used in this function, so remove it.
> Please fix the date on your system. Your patches are sent with the date
> over a week in the future.
>
> Please note that we have a 24h wait period so you need to wait at least
> a day before you resend anything.

Sorry for late reply cuz I'm just back for work today.

Thanks for the tips. I'll fix the date problem and post it after 6.1-rc1.

Best,
Chen

