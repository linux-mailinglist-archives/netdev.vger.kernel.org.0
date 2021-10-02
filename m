Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977B341FC35
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 15:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbhJBNV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 09:21:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233186AbhJBNVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 09:21:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2FE7961B26;
        Sat,  2 Oct 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633180808;
        bh=F0/VjbPA67Osj1PdCdSH/KgjXfSKUxM3daMY1uw4XT8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BmYr7Ufqfrgy+TafjsgrJsk7Cei4rUr1YEbYMRgDugDFV/+vwACWcHGRwjAA/2j8m
         F1x1riGvt8mrK6fIX9UWMU/IktoK/w7H80XBsRYIV/aEAqM9YLrrC9bPZPP9lLZavz
         RJdbf+5NJtsu5T9+xrmwKEqPHvjSB9LpMfuYuh36T6ZOaxNYwBXGCxdwLbAJtyLs9q
         VJx4eHrB8m3Bb1O3UpA6SjeLLZe1yZD8KgTToIz7KqkRC9rMenKYlm/RQAD8M0gYo1
         tGPHitQXZbRnD0+zMPgQKsqcq0TDEN7LIyU+DW0F42Cya6P2vcFmtEOa0PbQDAlkO8
         dtfh961RFkLgQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 23F3960AA0;
        Sat,  2 Oct 2021 13:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: renesas,ether: Update example to match
 reality
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163318080814.29287.18142746828049942976.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Oct 2021 13:20:08 +0000
References: <a1cf8a6ccca511e948075c4e20eea2e2ba001c2c.1633090323.git.geert+renesas@glider.be>
In-Reply-To: <a1cf8a6ccca511e948075c4e20eea2e2ba001c2c.1633090323.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     s.shtylyov@omp.ru, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  1 Oct 2021 14:13:20 +0200 you wrote:
> - Drop unneeded interrupt-parent,
>   - Convert to new style CPG/MSSR bindings,
>   - Add missing power-domains and resets properties,
>   - Update PHY subnode:
>       - Add example compatible values,
>       - Add micrel,led-mode and reset-gpios examples.
> 
> [...]

Here is the summary with links:
  - dt-bindings: net: renesas,ether: Update example to match reality
    https://git.kernel.org/netdev/net-next/c/63b1bae940a9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


