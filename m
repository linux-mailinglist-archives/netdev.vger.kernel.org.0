Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF8B698B0F
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 04:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjBPDPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 22:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjBPDPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 22:15:54 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7F83524B;
        Wed, 15 Feb 2023 19:15:52 -0800 (PST)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PHKlJ3YbgzRs02;
        Thu, 16 Feb 2023 11:13:16 +0800 (CST)
Received: from [10.174.178.171] (10.174.178.171) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 16 Feb 2023 11:15:49 +0800
Subject: Re: [PATCH net,v2,0/2] Fix a fib6 info notification bug
From:   "luwei (O)" <luwei32@huawei.com>
To:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230216042146.4069591-1-luwei32@huawei.com>
Message-ID: <de733652-0851-a381-60d8-3f95a71f8fe5@huawei.com>
Date:   Thu, 16 Feb 2023 11:15:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20230216042146.4069591-1-luwei32@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.171]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sorry, please ignore this patch

ÔÚ 2023/2/16 12:21 PM, Lu Wei Ð´µÀ:
> This patch set fixes a length calculation bug in fib6 info notification
> and adds two testcases.
>
> The test reult is listed as follows:
>
> before the fix patch:
>
> Fib6 info length calculation in route notify test
>      TEST: ipv6 route add notify                      [FAIL]
>
> Fib4 info length calculation in route notify test
>      TEST: ipv4 route add notify                      [ OK ]
>
> after the fix patch:
>
> Fib6 info length calculation in route notify test
>      TEST: ipv6 route add notify                      [ OK ]
>
> Fib4 info length calculation in route notify test
>      TEST: ipv4 route add notify                      [ OK ]
>
>
> Lu Wei (2):
>    ipv6: Add lwtunnel encap size of all siblings in nexthop calculation
>    selftests: fib_tests: Add test cases for IPv4/IPv6 in route notify
>
>   net/ipv6/route.c                         | 11 +--
>   tools/testing/selftests/net/fib_tests.sh | 92 +++++++++++++++++++++++-
>   2 files changed, 97 insertions(+), 6 deletions(-)
>
-- 
Best Regards,
Lu Wei

