Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFA74615B5
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348596AbhK2NFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:05:30 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49492 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236565AbhK2ND3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:03:29 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 28045CE124A
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 13:00:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 7FCEC6056B;
        Mon, 29 Nov 2021 13:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638190809;
        bh=UNgh7xhzYPkUHTc0tLwUJ5wIn5KM6wM1xUoOfW8AYNg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uUC1Z9R05c7MQsSJ9vvOUnoJCWHnEsJddwgsF17Q/X7yZS1J22xSIxOf22lJTt/L2
         LWOsl/uoPm6EAp0s0+qk0FiqYh+5PlatPGHXD8dHqBEvofBFOIImm9nSCELM5ClzB0
         Y+q4Bb9SlgPHsJfMjTqwSa2Clnx4/gSJtCjbdlRRlM3wKAlDWOzYnvozuFioP3X0kU
         jiDdG7MG3Ls0kMDEej3Z5+SxwpMHq6tJreuSUXRnP7299IZlsG1fjuVOkBR+jB+XoN
         bQb53B3OGn18RBSIQ+w9f8m2+2soVHI1yfnWkTkH8KIcVSjDH//vNbPnsdrCEWE+je
         64Lh5vnQP7oaw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 725AB60A4D;
        Mon, 29 Nov 2021 13:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/3] net: dsa: realtek-smi: don't log an error on
 EPROBE_DEFER
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819080945.6089.1370849061046653334.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 13:00:09 +0000
References: <20211129103019.1997018-1-alvin@pqrs.dk>
In-Reply-To: <20211129103019.1997018-1-alvin@pqrs.dk>
To:     =?utf-8?b?QWx2aW4gxaBpcHJhZ2EgPGFsdmluQHBxcnMuZGs+?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linus.walleij@linaro.org, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com, vivien.didelot@gmail.com, hkallweit1@gmail.com,
        alsi@bang-olufsen.dk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 11:30:17 +0100 you wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Probe deferral is not an error, so don't log this as an error:
> 
> [0.590156] realtek-smi ethernet-switch: unable to register switch ret = -517
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] net: dsa: realtek-smi: don't log an error on EPROBE_DEFER
    https://git.kernel.org/netdev/net-next/c/b014861d96a6
  - [net,v2,2/3] net: dsa: rtl8365mb: fix garbled comment
    https://git.kernel.org/netdev/net-next/c/1ecab9370eef
  - [net,v2,3/3] net: dsa: rtl8365mb: set RGMII RX delay in steps of 0.3 ns
    https://git.kernel.org/netdev/net-next/c/ef136837aaf6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


