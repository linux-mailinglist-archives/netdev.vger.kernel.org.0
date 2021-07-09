Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6153C290B
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 20:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhGIScw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 14:32:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhGIScs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 14:32:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EE845613D9;
        Fri,  9 Jul 2021 18:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625855405;
        bh=GwySWkFQciyRUe8UHEBlB5WqK1PbSk0nY5q+fpsGrHk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BgWufc5PKiAPbtInFMGnCb0bOtSsXYTI/RnpTHUjLwwTm3xnHMhxK+k48xkDMTkX1
         vT7PGTHlJ0fUn0E3uij3CQTVsJVJqzy5Egpxi3lUhXThZfFGTEq4xlblQWvQbJDA8f
         6by7a80BReJIoZclf/sfbT7Pov8nHKmOU+OTHJDKN6GtWSUIp3B4SLUkb3m5bVmK+0
         tO6I20VvPJKvpEWhIprOq3jfTlfAqck/dtyXvVxInOAHw7M3MMjgIoEIW2yoJcqe25
         YawZp+mEu/+pVldb1Z1fQtQKF2mKEQeeiKwf7pQxZU3sFKSBWmXmZ3v+RgXGnh9Bq7
         c0wVHthPHIsqA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E30D860CD4;
        Fri,  9 Jul 2021 18:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ti: fix UAF in tlan_remove_one
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162585540492.20680.15353189046687848023.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Jul 2021 18:30:04 +0000
References: <20210709145829.3335-1-paskripkin@gmail.com>
In-Reply-To: <20210709145829.3335-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     chessman@tux.org, davem@davemloft.net, kuba@kernel.org,
        devendra.aaru@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  9 Jul 2021 17:58:29 +0300 you wrote:
> priv is netdev private data and it cannot be
> used after free_netdev() call. Using priv after free_netdev()
> can cause UAF bug. Fix it by moving free_netdev() at the end of the
> function.
> 
> Fixes: 1e0a8b13d355 ("tlan: cancel work at remove path")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: ti: fix UAF in tlan_remove_one
    https://git.kernel.org/netdev/net/c/0336f8ffece6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


