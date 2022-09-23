Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4981A5E7439
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 08:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiIWGhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 02:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiIWGhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 02:37:50 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB831280DB;
        Thu, 22 Sep 2022 23:37:47 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MYj7L3frZzpStW;
        Fri, 23 Sep 2022 14:34:54 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 14:37:44 +0800
Message-ID: <287e46e8-8e6b-f872-f706-4a79a79a888c@huawei.com>
Date:   Fri, 23 Sep 2022 14:37:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [net-next] selftests: Fix the if conditions of in
 test_extra_filter()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <shuah@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <1663850569-33122-1-git-send-email-wangyufen@huawei.com>
 <20220922061239.115520b2@kernel.org>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <20220922061239.115520b2@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/22 21:12, Jakub Kicinski 写道:
> On Thu, 22 Sep 2022 20:42:49 +0800 Wang Yufen wrote:
>> The socket 2 bind the addr in use, bind should fail with EADDRINUSE. So
>> if bind success or errno != EADDRINUSE, testcase should be failed.
> Please add a Fixes tag, even if the buggy commit has not reached Linus
> yet.

Thanks for your comment.  will add in v2

