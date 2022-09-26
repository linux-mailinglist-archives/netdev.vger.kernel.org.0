Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B6E5EA896
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 16:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbiIZOh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 10:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbiIZOh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 10:37:29 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EBBDF8D;
        Mon, 26 Sep 2022 05:56:29 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MbjLj2hzBzHtjl;
        Mon, 26 Sep 2022 20:51:41 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 20:56:27 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 26 Sep
 2022 20:56:26 +0800
Subject: Re: [PATCH net-next 00/14] redefine some macros of feature abilities
 judgement
To:     Leon Romanovsky <leon@kernel.org>, <kuba@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <lanhao@huawei.com>
References: <20220924023024.14219-1-huangguangbin2@huawei.com>
 <Yy7pjTX8VLLIiA0G@unreal>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <77050062-93b5-7488-a427-815f4c631b32@huawei.com>
Date:   Mon, 26 Sep 2022 20:56:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <Yy7pjTX8VLLIiA0G@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/24 19:27, Leon Romanovsky wrote:
> On Sat, Sep 24, 2022 at 10:30:10AM +0800, Guangbin Huang wrote:
>> The macros hnae3_dev_XXX_supported just can be used in hclge layer, but
>> hns3_enet layer may need to use, so this serial redefine these macros.
> 
> IMHO, you shouldn't add new obfuscated code, but delete it.
> 
> Jakub,
> 
> The more drivers authors will obfuscate in-kernel primitives and reinvent
> their own names, macros e.t.c, the less external reviewers you will be able
> to attract.
> 
> IMHO, netdev should have more active position do not allow obfuscated code.
> 
> Thanks
> 

Hi, Leon
I'm sorry, I can not get your point. Can you explain in more detail?
Do you mean the name "macro" should not be used?
