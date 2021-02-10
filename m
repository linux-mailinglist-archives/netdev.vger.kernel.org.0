Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B6F3174BB
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbhBJXuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:50:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232565AbhBJXur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 18:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B8F8D64E05;
        Wed, 10 Feb 2021 23:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613001006;
        bh=WBjPLYl4furVnCUGUncMKY4HraEOdv4ShTVTnDxAzUA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pXe8mw4Xjo4+EGvydk2RbuAYhTX4sGX/bxUUmmryjw68FIDKcxm64ZFCW7/f6lh2i
         lM9kt8Ot2FcLbPD6turmohg1SONWut3JYSEvYE/FPh+ZJyLuY2MKhl1LVnU94gq6hs
         8JUwKtFnSe5u0JCa6OsV33AND2rotHLPPxnsezoYfOUkWPgFFMiBWvsiVOg16kiTsS
         9Ih+AViuLNn3QhnFbZ0wer9UWo14+Lye+Zu0dcqGCQ0Wqs/EB/cW2GzohOmRs9ek6Y
         /hOTmPKAvu/MFfmElzYBtHdB8Bcg33nflCmlKQwQs9ea9vu06D5lgbqpiczCgY+jeI
         gFQyT1q3JpsJg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A9FBF609D4;
        Wed, 10 Feb 2021 23:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] net: mvpp2: add an entry to skip parser
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161300100669.28743.67405275607303768.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Feb 2021 23:50:06 +0000
References: <1612966633-11064-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1612966633-11064-1-git-send-email-stefanc@marvell.com>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, atenart@kernel.org, lironh@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Feb 2021 16:17:13 +0200 you wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> This entry used when skipping the parser needed,
> for example, the custom header pretended to ethernet header.
> 
> Suggested-by: Liron Himi <liron@marvell.com>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mvpp2: add an entry to skip parser
    https://git.kernel.org/netdev/net-next/c/e4b62cf7559f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


