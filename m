Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D9C3C7541
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhGMQwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhGMQwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 12:52:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1A4FA61249;
        Tue, 13 Jul 2021 16:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626195004;
        bh=Jc/aIRrr1fVZIxxmCRLM9d0sV/40S2zFnr2iXIb3aHQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B25owtBg7MVt446PV9jO6P/uX5s7HxwJnyJef02dPHHRwE4xMEst45JXhHHbY4PcH
         fbZuNp/Q9W3+VMJ3wZAJSUhFMlM0mYzxPJTU0PERkGU774vwk2J5cTjb22AfZBrGnS
         crpVPObi9QZ1n50/fLAH9vGSDmpUVd0iyM17UmX61/aWq1lSbk8tBHkHbW7Km8NKra
         cmVo1dhX72AY6pLsgeUbzl6G9wUnSzTU+rHz7I5/DnyP+V4eKRoZaevMCKCfUH7+MA
         JkGUKwWGwW7dY0FhvoQyR08itQz8gQEr2KNS+F2zxSrSPur+TYOlukxP9plk7aps8K
         FtNIUFuONsYGQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0C87160A0C;
        Tue, 13 Jul 2021 16:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fddi: fix UAF in fza_probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162619500404.7532.15193182665229786599.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Jul 2021 16:50:04 +0000
References: <20210713105853.8979-1-paskripkin@gmail.com>
In-Reply-To: <20210713105853.8979-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     macro@orcam.me.uk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 13 Jul 2021 13:58:53 +0300 you wrote:
> fp is netdev private data and it cannot be
> used after free_netdev() call. Using fp after free_netdev()
> can cause UAF bug. Fix it by moving free_netdev() after error message.
> 
> Fixes: 61414f5ec983 ("FDDI: defza: Add support for DEC FDDIcontroller 700
> TURBOchannel adapter")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: fddi: fix UAF in fza_probe
    https://git.kernel.org/netdev/net/c/deb7178eb940

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


