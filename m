Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC44652423F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 03:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbiELB6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 21:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbiELB6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 21:58:38 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB702393DE;
        Wed, 11 May 2022 18:58:36 -0700 (PDT)
Received: from kwepemi500018.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KzFJx1NKNz1JBmt;
        Thu, 12 May 2022 09:57:21 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 kwepemi500018.china.huawei.com (7.221.188.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 12 May 2022 09:58:34 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 12 May 2022 09:58:33 +0800
Message-ID: <f7a73d6e-b5aa-269f-2251-4148bb35d655@huawei.com>
Date:   Thu, 12 May 2022 09:58:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 0/3] Refix the socket leak in xs_setup_local()
To:     Trond Myklebust <trondmy@hammerspace.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "anna@kernel.org" <anna@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220511132232.4030-1-wanghai38@huawei.com>
 <2125358c4fbdcf2e9f84017a2f6b27830ffcb8f2.camel@hammerspace.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
In-Reply-To: <2125358c4fbdcf2e9f84017a2f6b27830ffcb8f2.camel@hammerspace.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/5/12 0:14, Trond Myklebust 写道:
> On Wed, 2022-05-11 at 21:22 +0800, Wang Hai wrote:
>> Patch1 and patch2 roll back the wrong solution to fix socket leaks.
>>
>> Patch3 adds safe teardown mechanism to re-fix socket leaks.
>>
>> Wang Hai (3):
>>    Revert "SUNRPC: Ensure gss-proxy connects on setup"
>>    Revert "Revert "SUNRPC: attempt AF_LOCAL connect on setup""
>>    SUNRPC: Fix local socket leak in xs_setup_local()
>>
>>   include/linux/sunrpc/clnt.h          |  1 -
>>   net/sunrpc/auth_gss/gss_rpc_upcall.c |  2 +-
>>   net/sunrpc/clnt.c                    |  3 ---
>>   net/sunrpc/xprtsock.c                | 19 ++++++++++++++++++-
>>   4 files changed, 19 insertions(+), 6 deletions(-)
>>
> Thanks, but there is already a fix for this queued up in the linux-next
> branch.
Thanks, sorry to bother you, I found it.

I only subscribed to the linux-kernel@vger.kernel.org mailing list,
not the linux-nfs@vger.kernel.org mailing list separately. So I
didn't notice it was fixed.

-- 
Wang Hai

