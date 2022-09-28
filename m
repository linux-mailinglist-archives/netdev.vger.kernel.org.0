Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CED5ED217
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbiI1AkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiI1AkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A693D109778;
        Tue, 27 Sep 2022 17:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A519B81E5B;
        Wed, 28 Sep 2022 00:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4680C433D7;
        Wed, 28 Sep 2022 00:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664325614;
        bh=SZiD3H3Im+2dl8aELFqvfAWeUO4XUb6itbsUS+XkUGY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iq/9mfLZHEKVkulHqcHhgeErDUzPwjG1VYGf75km1ZGD1W7rzESZfhOXwjI5ThD7i
         bRl0Wp4xrxXCc9BLNbGo4sVc18XrBzgUg6Dj2WyVaz8Pih+ekduxhVF9/xR1KRxNbw
         USXtLXKyLaWXP5iGoyIx/O+Isk3HJoe8m2gbBBDxR0Y4+1HYhj0wwWIFF2r9KjnwMn
         eU5zoIDdYm1z0FZGoVHG6GNJa1uK6oJy45sh6UC72o1hsdFKOWpyQYE+99Ba2CSb2l
         Da5bGxOKhqYDGGU4ev7uBDypF68mdv3HczOO3YRxfQ7YtjBPFKVIFIet84fQfdATGW
         W7J7WlcTP8Vjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C33B9E21EC6;
        Wed, 28 Sep 2022 00:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ptp: Remove usage of the deprecated ida_simple_xxx API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166432561479.23988.8711390321450225487.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 00:40:14 +0000
References: <20220926012744.3363-1-liubo03@inspur.com>
In-Reply-To: <20220926012744.3363-1-liubo03@inspur.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 25 Sep 2022 21:27:44 -0400 you wrote:
> Use ida_alloc_xxx()/ida_free() instead of
> ida_simple_get()/ida_simple_remove().
> The latter is deprecated and more verbose.
> 
> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  drivers/ptp/ptp_clock.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - ptp: Remove usage of the deprecated ida_simple_xxx API
    https://git.kernel.org/netdev/net-next/c/ab7ea1e73532

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


