Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D686622163
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 02:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiKIBng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 20:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiKIBnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 20:43:17 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333E86A6BE
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 17:42:40 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N6SPx6s4TzHvTV;
        Wed,  9 Nov 2022 09:42:13 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 09:42:37 +0800
Message-ID: <e9106276-74b0-520f-51aa-ae38e2fd336e@huawei.com>
Date:   Wed, 9 Nov 2022 09:42:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] net: mv643xx_eth: disable napi when init rxq or txq
 failed in mv643xx_eth_open()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <sebastian.hesselbarth@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jeffrey.t.kirsher@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20221108025156.327279-1-shaozhengchao@huawei.com>
 <20221108172707.732325ce@kernel.org>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20221108172707.732325ce@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/11/9 9:27, Jakub Kicinski wrote:
> On Tue, 8 Nov 2022 10:51:56 +0800 Zhengchao Shao wrote:
>> When failed to init rxq or txq in mv643xx_eth_open() for opening device,
>> napi isn't disabled. When open mv643xx_eth device next time, it will
>> report a invalid opcode issue.
> 
> It will trigger a BUG_ON() in napi_enable()
> 
>> Fix it. Only be compiled, not be tested.
> 
> Please replace "Fix it. Only be compiled, not be tested."
> with "Compile tested only."
> 
>> Fixes: 527a626601de ("skge/sky2/mv643xx/pxa168: Move the Marvell Ethernet drivers")
> 
> This is not the commit which added this code, please find out where
> the code was added.

Hi Jakub:
	Thank you for your review. I will fix them in V2.

Zhengchao Shao
