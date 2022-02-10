Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59EE84B1188
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243527AbiBJPUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:20:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240962AbiBJPUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:20:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF88CF1;
        Thu, 10 Feb 2022 07:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2B32CCE249A;
        Thu, 10 Feb 2022 15:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98BD7C340EE;
        Thu, 10 Feb 2022 15:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644506408;
        bh=xcG0TwU1WjTIk6vJLMfTpcGPhyjZ0Acu3vYMtzxiwUw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Teu4UJG1JV0LXmdPpyZInn1XyHDOs99qlLGerV0h/xKICVqQjBi2AItUQ9p98ebuw
         5tJbMC5e4xx+bLuG9X65fcXZrByNTa75dNb2zXK3h5FGXV5Jjjjr9lEaqKvYm2faUc
         nSWUYsgj+0iNiCOZupVOXfdzOp3f+1SPoRU2T4t54pbyQ8hblsUIcQMFfST2vbVwR4
         swr0eeuWPuNc8xnwmb8KAkbgGF6Vb6qwlRsTN0zExKgry5fo9pkJIGYwkaldAXfSr7
         l87QVCNLa5Viak5QsDi3cLSdIUEdMQeys2+dJ5hO7gAT7jSUfG3Y73upvY4j+cnqhA
         MJa5dozVvhBHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A9D6E6D3DE;
        Thu, 10 Feb 2022 15:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] skbuff: cleanup double word in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164450640848.6138.12613376995224617074.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 15:20:08 +0000
References: <20220209150242.2292183-1-trix@redhat.com>
In-Reply-To: <20220209150242.2292183-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, alobakin@pm.me,
        edumazet@google.com, pabeni@redhat.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Feb 2022 07:02:42 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Remove the second 'to'.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  net/core/skbuff.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - skbuff: cleanup double word in comment
    https://git.kernel.org/netdev/net/c/58e61e416b5a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


