Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885A73D11FA
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239416AbhGUO33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:29:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239301AbhGUO32 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 10:29:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9195461019;
        Wed, 21 Jul 2021 15:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626880204;
        bh=IVvhQ+FgV8MaBQMPIP2hEI/dpogkH22PgponJiUj80E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bRRTVH/48BF0Bg3SFVP8BmTjw2N7YQVgvkBMrUJ/tEogfVnDmGT2U7HO/duZwiIPK
         uErSeo5H0CuR7PKBJRjbVlSYySnorGjl5IgyL5JwCPdFdAi8YtwDqwAPUWArlPZvuF
         ugjXidDZdRdFTYhaBEF0lt3ehTTPZq8dVDS35WJg49HwIRimjB8rAGZo30NSMeGqPj
         wLc05JTIhExPkA2yLbFOAavFnEBFG6PW0PbOWkaR2SQcN7Zvm5+ZHw6nL1s/i/PxKz
         0qXzHlc2bEaJ6Bsx+3Y9HfpsjOl7vahz1zJ0HsntKaFwxmpsS54fDGUanEWgECjM+C
         PWZZ+C/1sIOaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 86CBE60CE0;
        Wed, 21 Jul 2021 15:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: switchdev:
 switchdev_handle_fdb_del_to_device(): fix no-op function for disabled
 CONFIG_NET_SWITCHDEV
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162688020454.31691.3836204530021681866.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 15:10:04 +0000
References: <20210721101714.78977-1-mkl@pengutronix.de>
In-Reply-To: <20210721101714.78977-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Jul 2021 12:17:14 +0200 you wrote:
> In patch 8ca07176ab00 ("net: switchdev: introduce a fanout helper for
> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE") new functionality including static
> inline no-op functions if CONFIG_NET_SWITCHDEV is disabled was added.
> 
> This patch fixes the following build error for disabled
> CONFIG_NET_SWITCHDEV:
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: switchdev: switchdev_handle_fdb_del_to_device(): fix no-op function for disabled CONFIG_NET_SWITCHDEV
    https://git.kernel.org/netdev/net-next/c/94111dfc18b8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


