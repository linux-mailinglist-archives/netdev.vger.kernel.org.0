Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1B646F47B
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 21:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhLIUDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 15:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhLIUDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 15:03:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CC8C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 12:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 573BBCE2832
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 20:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B9C3C341C6;
        Thu,  9 Dec 2021 20:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639080011;
        bh=YnNs7az/qTTbTLdtsHA8c/HDbey3m6k2oXgBT+NTBFw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oEA35apeb4ygwrav4LktCYXYpdLrcRQuszi7HvgSlZdrgPdftOEJ5lJsGsd68cWz9
         ofWOMOv9qLH7AllRNig+azGSa9oeNMy8rNk8H+922MbbkQvT7m//GtGRF3VV1VdPDb
         gjZClzsfppPYtkfOoiuXdAjduGbFp1YZK+MBaCYnyPXaD05BS4YiV2o7XrTYbkQDlE
         0otExP+lEsis0qap8T++LseXMRVDLyQxqQL3qIb+jK6Y2ngx2GvV2m6MvjfzVJ8wxN
         pymkW82fut+HUW/nk04JfF34pnZeJjys/Qe5WIHiZ9lZ2qMGEaiZyc6FN9yJYm09yR
         l8QG9bC9jj5jA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 466E960A37;
        Thu,  9 Dec 2021 20:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/5] net: phylink: add legacy_pre_march2020 indicator
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163908001128.24516.3335515439099109879.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 20:00:11 +0000
References: <E1mucmf-00EyCl-KA@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mucmf-00EyCl-KA@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     chris.snook@gmail.com, nbd@nbd.name, f.fainelli@gmail.com,
        john@phrozen.org, Mark-MC.Lee@mediatek.com, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 07 Dec 2021 15:53:37 +0000 you wrote:
> Add a boolean to phylink_config to indicate whether a driver has not
> been updated for the changes in commit 7cceb599d15d ("net: phylink:
> avoid mac_config calls"), and thus are reliant on the old behaviour.
> 
> We were currently keying the phylink behaviour on the presence of a
> PCS, but this is sub-optimal for modern drivers that may not have a
> PCS.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: phylink: add legacy_pre_march2020 indicator
    https://git.kernel.org/netdev/net-next/c/3e5b1feccea7
  - [net-next,2/5] net: dsa: mark DSA phylink as legacy_pre_march2020
    https://git.kernel.org/netdev/net-next/c/0a9f0794d9bd
  - [net-next,3/5] net: mtk_eth_soc: mark as a legacy_pre_march2020 driver
    https://git.kernel.org/netdev/net-next/c/b06515367fac
  - [net-next,4/5] net: phylink: use legacy_pre_march2020
    https://git.kernel.org/netdev/net-next/c/001f4261fe4d
  - [net-next,5/5] net: ag71xx: remove unnecessary legacy methods
    https://git.kernel.org/netdev/net-next/c/11053047a4af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


