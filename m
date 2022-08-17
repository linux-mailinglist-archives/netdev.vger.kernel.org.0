Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B33D596796
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 05:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238411AbiHQDAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 23:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238055AbiHQDAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 23:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691EA97502;
        Tue, 16 Aug 2022 20:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F205961052;
        Wed, 17 Aug 2022 03:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C37EC433B5;
        Wed, 17 Aug 2022 03:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660705216;
        bh=2VvHPIodg8nw507llDtxxCr8pEw1EcE5E0uRtB2pSvE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EYUMzFT9mvxbYdPDFbLVmHqj/E+YJ34BCWtoEGOR531NnP5Mak1ZTvwWL8gQ4VZhp
         vjenjvcWp1DKHi17Di6F8luxLeQHFXRaUpsN4FyqiImONIy/Ti8JOp/qfEBX0vasRc
         u9YzK6ize+vwxv/08YVtxOpzIoVca2FduJK2VCBr+0xMZ226wHkmdjxnt6MtY7WdRU
         7vWbZGS2totlKGTIwLBW6MT/9FtDBJr+RacTwOlu2jFPNq+yk0Qu84Fuj8+6qMrgs2
         3iNe7YHWVDc8fiOYFFljNjB+Or7uDfoXS8uDmlxnk6dmGrQu9cEdLz5PmpMcWd+9Tv
         eIjIDPIlZzQpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 303D7E2A053;
        Wed, 17 Aug 2022 03:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: delete unused input parameter in
 qdisc_create
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166070521619.25002.11604488986992513415.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 03:00:16 +0000
References: <20220815061023.51318-1-shaozhengchao@huawei.com>
In-Reply-To: <20220815061023.51318-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 Aug 2022 14:10:23 +0800 you wrote:
> The input parameter p is unused in qdisc_create. Delete it.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/sched/sch_api.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: sched: delete unused input parameter in qdisc_create
    https://git.kernel.org/netdev/net-next/c/cfc111d5391d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


