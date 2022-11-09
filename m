Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E01622165
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 02:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiKIBnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 20:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiKIBnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 20:43:31 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6568965B3
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 17:43:26 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N6SMq5bNHzHqV1;
        Wed,  9 Nov 2022 09:40:23 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 09:43:24 +0800
Message-ID: <f309f6f9-86f7-80b7-69f0-5ac5315e85d6@huawei.com>
Date:   Wed, 9 Nov 2022 09:43:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] ethernet: s2io: disable napi when start nic failed in
 s2io_card_up()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jdmason@kudzu.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jeffrey.t.kirsher@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20221108005952.73685-1-shaozhengchao@huawei.com>
 <20221108172905.139a962d@kernel.org>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20221108172905.139a962d@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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



On 2022/11/9 9:29, Jakub Kicinski wrote:
> On Tue, 8 Nov 2022 08:59:52 +0800 Zhengchao Shao wrote:
>> Fixes: 86387e1ac4fc ("s2io/vxge: Move the Exar drivers")
> 
> Again, unlikely to be the culprit.
Thank you. Also will fix in v2.

Zhengchao Shao
