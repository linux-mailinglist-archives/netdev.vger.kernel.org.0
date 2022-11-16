Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4F762BFB4
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 14:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238752AbiKPNkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 08:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238577AbiKPNkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 08:40:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1797B248EB;
        Wed, 16 Nov 2022 05:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 60C8BCE1B7C;
        Wed, 16 Nov 2022 13:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D4D1C433D6;
        Wed, 16 Nov 2022 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668606016;
        bh=9ssDzJCVb+IM3Mp3/H+XJ4ZS7rQ6o6pgVr8DoqOYW+Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RnUbzuDV4CahgLZEorZwuO1hUjI0wUxph0m8aE6iuEj/KbG3cEkMSmjydwMFrzAfO
         y3Dwnz9DnKLNMuEfgUKblP+Rjvxpav2hEMTDwYNk96LAslbEhFXd0phGrhZ0cy3fTf
         iXIjA9/unNnNq2GBGf35se5ewNsiPChjWDMiw1jnGoNgxlw+ztwxVfNhppLfukvays
         cxpOdIu/DqHJUiITig3dxWe+ZqzweVOkzLZYW+Uk/u9qzHjJG6Gcp16iiwZ/uJmF42
         Ezs+IOhmMAap4deaz+zLctR4+lG1/vlJSc47+CVvG1XMVw2+l3q4I/uBYTqH/WRD4b
         jfqLuDBR1Jh6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B462C395F0;
        Wed, 16 Nov 2022 13:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ax25: af_ax25: Remove unnecessary (void*) conversions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166860601617.31330.7738435256770513736.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 13:40:16 +0000
References: <20221115021424.3367-1-zeming@nfschina.com>
In-Reply-To: <20221115021424.3367-1-zeming@nfschina.com>
To:     Li zeming <zeming@nfschina.com>
Cc:     jreuter@yaina.de, ralf@linux-mips.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 15 Nov 2022 10:14:24 +0800 you wrote:
> The valptr pointer is of (void *) type, so other pointers need not be
> forced to assign values to it.
> 
> Signed-off-by: Li zeming <zeming@nfschina.com>
> ---
>  net/ax25/af_ax25.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - ax25: af_ax25: Remove unnecessary (void*) conversions
    https://git.kernel.org/netdev/net-next/c/1d7322f28fde

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


