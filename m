Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE76A4AF14E
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiBIMUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbiBIMUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:20:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1594DE03A429
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 04:10:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A693061716
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 12:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13EB7C340EE;
        Wed,  9 Feb 2022 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644408609;
        bh=KANzPTs5JoaO8nr7y383Ir9Uy481IxM0Qr+AQqW22vM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S9379IwOThZmlvOaCTfKE4VhLwl/y3Makh7BeXyStycmKxa2L90zRMsZlFuxGCRmG
         /LzYb46fj0cckb897VqmFzcoVZSev3uCImoQNJKF9sjDIhe6Mp+nokx3ROdNN8GXMB
         G5UXMim+QbBlVe4kDSEOhPh3LtDaPNhah7DYHwN0+29FGs7ZTWrPjNjJnwyGHMryVP
         k5lxCGSKahIf0gHkcMuqghC47tnHA8PoTidudt5c59FKRk25RMUhmdPgbJkt7MitJB
         rygUGlrsP8YcgBQ5+j80ow4YGShqUdH9slyPK6cAYXYZ8i61dv/nfi2h1w07O3qxxA
         TQRxl5Pwm9O8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2D26E6D458;
        Wed,  9 Feb 2022 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] veth: fix races around rq->rx_notify_masked
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164440860898.17005.13378296235069340924.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 12:10:08 +0000
References: <20220208232822.3432213-1-eric.dumazet@gmail.com>
In-Reply-To: <20220208232822.3432213-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, makita.toshiaki@lab.ntt.co.jp,
        syzkaller@googlegroups.com
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

On Tue,  8 Feb 2022 15:28:22 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> veth being NETIF_F_LLTX enabled, we need to be more careful
> whenever we read/write rq->rx_notify_masked.
> 
> BUG: KCSAN: data-race in veth_xmit / veth_xmit
> 
> [...]

Here is the summary with links:
  - [net] veth: fix races around rq->rx_notify_masked
    https://git.kernel.org/netdev/net/c/68468d8c4cd4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


