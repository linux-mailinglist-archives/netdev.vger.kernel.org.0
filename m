Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157A02DC739
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388805AbgLPTdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:33:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388790AbgLPTdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:33:13 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608146407;
        bh=2Jnf1zuqBPamWK4jeVn6TvmKqQRJBVz5yboS/GSZE6E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qYHbqORbA3ok6uwuuxWUYsBHqDtw6XuWljVIrTUO6KBZ1Cu/uIVBOE8YK3STM1egc
         +EDaN09eTwezkxfpNzCtOMlBKG9CfiivizdXTJUCe9S4ALQz6uivO2WGn9vRERzs8/
         kS4NCLTAwNf48bYXiTKgLq56pg46a/WI4+e0eDfobyiQL3Jju47ruLDfgg2G1fZTqO
         5CNLsbPsnIT0ZGVjTU0uKL8DN+JR+XpiTe0WgjA7JwW5wC52J/+fzJm3T7YKas3shE
         D74eFmcd+7jX5hPspoh5qOk0afkfqXCG3PPA/S+yDDLx9QXLZ0LEhqIyr3gMM7d35m
         Jylmgv65amWbQ==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mscc: ocelot: Fix a resource leak in the error handling
 path of the probe function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160814640705.4483.2350966398303153186.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Dec 2020 19:20:07 +0000
References: <20201213114838.126922-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20201213114838.126922-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     UNGLinuxDriver@microchip.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 13 Dec 2020 12:48:38 +0100 you wrote:
> In case of error after calling 'ocelot_init()', it must be undone by a
> corresponding 'ocelot_deinit()' call, as already done in the remove
> function.
> 
> Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - net: mscc: ocelot: Fix a resource leak in the error handling path of the probe function
    https://git.kernel.org/netdev/net/c/f87675b836b3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


