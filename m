Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243FD4AA9A1
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358531AbiBEPUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:20:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37140 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357913AbiBEPUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:20:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EB6260F6F
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 15:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABF77C340F3;
        Sat,  5 Feb 2022 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644074409;
        bh=Q5ozjwm41QJNLmvSgU0RmFMUt9G4WsJ3faxQho81VOo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jckLnCz5G4j0tQdfwAHL00GYcmmGeLT1jNzPIaktnrbKQUWIuomGdOyCHVPHx6B+z
         1WUCklkGVX0fVWQYmA+YonHYXggv1yiDy1VIJiLgnhre7Tv8KblgRgk6/4LtzvAQ57
         Tvnnc0hNiilyz+MrmsjXdnTqMuop5rDA0KLCLs2u2HD1fLP1FTytu2Jj+zmOInibjJ
         Zh3/0rwSmsKwWPNF+W3qtQykXJIQm9cBR/BDTlwNaxx8yB0fG6bjvssUvpTU2NmuKM
         qrLXbGcjj5a6iZraDIs5KOYUMthCkEni+zV3eyQo1lVh5D8Yh8CR7a3La26zx8FSLT
         8oJpF8wBxvqrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97249E6D446;
        Sat,  5 Feb 2022 15:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: realtek: don't default Kconfigs to y
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164407440961.21243.14425267013874452160.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 15:20:09 +0000
References: <20220204155927.2393749-1-kuba@kernel.org>
In-Reply-To: <20220204155927.2393749-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, luizluca@gmail.com,
        arinc.unal@arinc9.com, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  4 Feb 2022 07:59:27 -0800 you wrote:
> We generally default the vendor to y and the drivers itself
> to n. NET_DSA_REALTEK, however, selects a whole bunch of things,
> so it's not a pure "vendor selection" knob. Let's default it all
> to n.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: realtek: don't default Kconfigs to y
    https://git.kernel.org/netdev/net-next/c/3115ff3c9d3c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


