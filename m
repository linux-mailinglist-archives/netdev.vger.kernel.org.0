Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA925ED353
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiI1DNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 23:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiI1DN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:13:29 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDAA1D6259;
        Tue, 27 Sep 2022 20:13:27 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MchKd4ypxzlXP6;
        Wed, 28 Sep 2022 11:09:09 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 11:13:25 +0800
Message-ID: <987b807d-9f10-414a-524c-40e3d9f69e72@huawei.com>
Date:   Wed, 28 Sep 2022 11:13:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH -next] net: i82596: Add __init/__exit annotations to
 module init/exit funcs
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <linmq006@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220926115456.1331889-1-ruanjinjie@huawei.com>
 <20220927075257.11594332@kernel.org>
Content-Language: en-US
From:   Ruan Jinjie <ruanjinjie@huawei.com>
In-Reply-To: <20220927075257.11594332@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/27 22:52, Jakub Kicinski wrote:
> On Mon, 26 Sep 2022 19:54:56 +0800 ruanjinjie wrote:
>> Add missing __init/__exit annotations to module init/exit funcs
> 
> How many of these do you have? Do you use a tool to find the cases 
> where the annotations can be used?
> 
I think Linux kernel drivers have many of these problems.I use grep
command to compare all the driver C files and find where the annotations
can be used.

> Please read Documentation/process/researcher-guidelines.rst
> and make sure you comply with what is expected in the commit message.

Thank you very much! Some key information is missing from the commit
message. Should I update the commit message and resubmit the patch?
