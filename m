Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F9C60844D
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 06:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiJVEas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 00:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiJVEaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 00:30:46 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B43A2475E4
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 21:30:38 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MvSxP5ChRzJn7G;
        Sat, 22 Oct 2022 12:27:53 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 22 Oct 2022 12:30:35 +0800
Message-ID: <0226f3b4-54d4-c983-560f-9adb724b84d9@huawei.com>
Date:   Sat, 22 Oct 2022 12:30:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 1/2] netdevsim: fix memory leak in nsim_drv_probe()
 when nsim_dev_resources_register() failed
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jiri@mellanox.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20221020023358.263414-1-shaozhengchao@huawei.com>
 <20221020023358.263414-2-shaozhengchao@huawei.com>
 <20221020172612.0a8e60bb@kernel.org>
 <ec77bbe9-7ced-8d9a-909c-9e6658b28e31@huawei.com>
 <297b3e63-efa5-fc14-35d7-2f6e7e334122@huawei.com>
 <20221021082140.524e97a4@kernel.org>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20221021082140.524e97a4@kernel.org>
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



On 2022/10/21 23:21, Jakub Kicinski wrote:
> On Fri, 21 Oct 2022 17:13:10 +0800 shaozhengchao wrote:
>>>> Looks like a rename patch.
>>>>
>>>> The Fixes tag must point to the commit which introduced the bug.
>>>>   
>>> OK, I will check it.
>> Sorry, I check this commit introduce the bug. What do I have missed?
> 
> Say more?  All I see it do is rename devlink_resources_register()
> to nsim_dev_resources_register(). Which part do I need to look at?
Sorry about that. I have got it. Thank you.
