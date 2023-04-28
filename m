Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020146F13C4
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 11:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345601AbjD1JAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 05:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345507AbjD1JA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 05:00:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C2D1BC;
        Fri, 28 Apr 2023 02:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82D6764223;
        Fri, 28 Apr 2023 09:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD736C433A8;
        Fri, 28 Apr 2023 09:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682672421;
        bh=lJw+O90a6v3rkXnEzhO4UQOIEMF91DQf47yecoODgrI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bosqTgTcY9zv3LNq51CKyzmoll6svv1MUfN0T6Tg0MvohQlXz2gLcqvJg1ZRwP6gE
         vYdylGMySHZw0ecwy12FZ8DaVObUx6ba0pOBIcR6YIbOZ/FZvDk56FxYhCl8vMjfyb
         uYT/VIRsC1NB31ZPCpFKYFo45hdAE0o1M9+8H837YIqRkqu0b/JPwSRsA5b+b6XOkx
         WW0wYakjpgmVDwINaoyGgWE2U/ZVzAGWIO5yBMbTTOrUg5RHAraWTUc5bWRnJs/o9J
         hGEYVWWuVkGC2yl6gcEgtMh+T34I4F1pThfG4roHV0d8yovXjrzWEuS34r69PwFTTL
         xeZlraRnxjwmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C860BC41677;
        Fri, 28 Apr 2023 09:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atlantic:hw_atl2:hw_atl2_utils_fw:  Remove unnecessary
 (void*) conversions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168267242181.9185.7527374858338578640.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Apr 2023 09:00:21 +0000
References: <20230427102531.14783-1-yunchuan@nfschina.com>
In-Reply-To: <20230427102531.14783-1-yunchuan@nfschina.com>
To:     wuych <yunchuan@nfschina.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, irusskikh@marvell.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Apr 2023 18:25:31 +0800 you wrote:
> Pointer variables of void * type do not require type cast.
> 
> Signed-off-by: wuych <yunchuan@nfschina.com>
> ---
>  .../net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - atlantic:hw_atl2:hw_atl2_utils_fw: Remove unnecessary (void*) conversions
    https://git.kernel.org/netdev/net-next/c/042334a8d424

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


