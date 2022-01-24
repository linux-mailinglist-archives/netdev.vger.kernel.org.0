Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C48A499E75
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 00:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1588875AbiAXWeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 17:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584551AbiAXWVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 17:21:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57947C0424D0;
        Mon, 24 Jan 2022 12:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E939B60C60;
        Mon, 24 Jan 2022 20:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A6F0C340E8;
        Mon, 24 Jan 2022 20:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643057410;
        bh=v0ZBZ33oPhbzNEpDUC/x/V7sUUhuTWKhVK4xuPjaASQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YCl/ojQvGOpxY05jd8NPK8gST/w9n+P0v2DirAktjBGzkv4qKGn4EgthOeFiWJtUE
         ByxT9kiDpxx69C7V5MsK8ecrwNT8uhMLHV7gjiZ0HxYvRjlrCbrwL2u0X/vbrdiayo
         Uyc1+zz9sRqV3IG1TeTxAhTDPftgsIWe9ix1a8yrhvgyFQ61lZwwQWNAxT6Gdx3WuO
         jS9Pn7tqwhcfGVd5a2nfl9MJyOoHb1Pr+gelzYVqPIKpGaijay58i8mJiDMu8i5vEj
         7hUfg8nA4YyY+yyMsPFUCU6l55wmfWxx+N+cRzWoDhkqFW0Ez7Wc0wHfdE1dl5T475
         70z1ZcB4RGp9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E02DF607B4;
        Mon, 24 Jan 2022 20:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] mailmap: update email address of Brian Silverman
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164305741024.30543.5579629857136486957.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Jan 2022 20:50:10 +0000
References: <20220124175955.3464134-2-mkl@pengutronix.de>
In-Reply-To: <20220124175955.3464134-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        bsilver16384@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Mon, 24 Jan 2022 18:59:51 +0100 you wrote:
> Brian Silverman's address at bluerivertech.com is not valid anymore,
> use Brian's private email address instead.
> 
> Link: https://lore.kernel.org/all/20220110082359.2019735-1-mkl@pengutronix.de
> Cc: Brian Silverman <bsilver16384@gmail.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net,1/5] mailmap: update email address of Brian Silverman
    https://git.kernel.org/netdev/net/c/984d1efff230
  - [net,2/5] dt-bindings: can: tcan4x5x: fix mram-cfg RX FIFO config
    https://git.kernel.org/netdev/net/c/17a30422621c
  - [net,3/5] can: m_can: m_can_fifo_{read,write}: don't read or write from/to FIFO if length is 0
    https://git.kernel.org/netdev/net/c/db72589c49fd
  - [net,4/5] can: tcan4x5x: regmap: fix max register value
    https://git.kernel.org/netdev/net/c/e59986de5ff7
  - [net,5/5] can: flexcan: mark RX via mailboxes as supported on MCF5441X
    https://git.kernel.org/netdev/net/c/f04aefd4659b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


