Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595FE571B02
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiGLNUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiGLNUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1F933E39;
        Tue, 12 Jul 2022 06:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0CA26176B;
        Tue, 12 Jul 2022 13:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E579C341CB;
        Tue, 12 Jul 2022 13:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657632013;
        bh=VtYTT+GuTYziiLBNQuhIPi8afVUYtci7GhuKaVENo4w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EzkzOzloLxmnvnmvv0BQkmHpcwmdd9DXOkQ53Ud+7XtpkcNg7+oxNMByye3ZueUQQ
         gYMRbbiWALJjKmRBDF9Ax7mEJAJO5xm/xtSql5o3bOmmNJEzuuleAC/7gIEzdJG3MY
         sLhWnE3hrAcJbVwBOR9sfT0hPxDVk67rFnIEyXu8LAUPxNPn17+XRAWanLs7+p0XAs
         0oZ6oubuicae0BF1TSxdQhidF78InN6T1FGUd+AHbagSM5GcOCtY4xzpoH6NA3bEu4
         WVj3l6nOPKXE7GmtjiNs1hOilRtvE+bD/Q+8GWnmiy+IhWRWyT32lz5sxFXCFi8X0+
         KfzOBErMX2/eQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11604E45227;
        Tue, 12 Jul 2022 13:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: change the type of ip_route_input_rcu to static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165763201305.27182.8607099090817656312.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jul 2022 13:20:13 +0000
References: <20220711073549.8947-1-shaozhengchao@huawei.com>
In-Reply-To: <20220711073549.8947-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 11 Jul 2022 15:35:49 +0800 you wrote:
> The type of ip_route_input_rcu should be static.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  include/net/route.h |  4 ----
>  net/ipv4/route.c    | 34 +++++++++++++++++-----------------
>  2 files changed, 17 insertions(+), 21 deletions(-)

Here is the summary with links:
  - net: change the type of ip_route_input_rcu to static
    https://git.kernel.org/netdev/net-next/c/5022e221c98a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


