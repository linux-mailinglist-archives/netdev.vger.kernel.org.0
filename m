Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97BCD5BF351
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 04:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiIUCIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 22:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiIUCIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 22:08:50 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238E15143B;
        Tue, 20 Sep 2022 19:08:49 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MXMDS1bLWz14RNk;
        Wed, 21 Sep 2022 10:04:40 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 10:08:43 +0800
Message-ID: <05bf784d-e0aa-0dde-ca6b-e147b9753f20@huawei.com>
Date:   Wed, 21 Sep 2022 10:08:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next,v2 03/18] selftests/tc-testings: add selftests
 for cake qdisc
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>, <shuah@kernel.org>,
        <victor@mojatatu.com>
CC:     <zhijianx.li@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20220917050304.127729-1-shaozhengchao@huawei.com>
 <87r106w3tm.fsf@toke.dk>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <87r106w3tm.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/20 21:52, Toke Høiland-Jørgensen wrote:
> Zhengchao Shao <shaozhengchao@huawei.com> writes:
> 
>> Test 1212: Create CAKE with default setting
>> Test 3281: Create CAKE with bandwidth limit
>> Test c940: Create CAKE with autorate-ingress flag
>> Test 2310: Create CAKE with rtt time
>> Test 2385: Create CAKE with besteffort flag
>> Test a032: Create CAKE with diffserv8 flag
>> Test 2349: Create CAKE with diffserv4 flag
>> Test 8472: Create CAKE with flowblind flag
>> Test 2341: Create CAKE with dsthost and nat flag
>> Test 5134: Create CAKE with wash flag
>> Test 2302: Create CAKE with flowblind and no-split-gso flag
>> Test 0768: Create CAKE with dual-srchost and ack-filter flag
>> Test 0238: Create CAKE with dual-dsthost and ack-filter-aggressive flag
>> Test 6572: Create CAKE with memlimit and ptm flag
>> Test 2436: Create CAKE with fwmark and atm flag
>> Test 3984: Create CAKE with overhead and mpu
>> Test 5421: Create CAKE with conservative and ingress flag
>> Test 6854: Delete CAKE with conservative and ingress flag
>> Test 2342: Replace CAKE with mpu
>> Test 2313: Change CAKE with mpu
>> Test 4365: Show CAKE class
>>
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> The subject prefix is misspelled for all the test patches (should be
> selftests/tc-testing without the last 's').
> 
> Also, v2 of the series wasn't properly threaded for some reason, which
> makes it harder to apply as a whole.
> 
> Other than those nits, for this patch:
> 
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> 
Hi Toke：
	Thank you for your review. I will send v3.

Zhengchao Shao
