Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2833B96F4
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbhGAUMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230149AbhGAUMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 16:12:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C024B6140D;
        Thu,  1 Jul 2021 20:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625170204;
        bh=gYkZ2snUWYSqUK/4sIX1aGBwlpzegamfkak6iW8cmOY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SAxSKlV9n+6jAJUsKBqBBWzVraVsWFxAHlYDuFrfXR9YFGB/RBun4LbG+QbdaRBjn
         eoM3tCkq7M59VQ1irHY3+LcmfwjClTW2OpjKYqkogT8QUgozmzAAz0cQHWA6xdwurA
         0oQpL02MroYEtkFRvaI+6u31jRXjyGeKAyzY7quAJGcWsXnbnLN6tPAfCblOIGiorz
         ZcXSjnjyanJRJU3BJgitV0oispBo6qOXFXCsKy9GWAIPZU6aUF55eMgKdr5TAucvlF
         gNyl+ZUpmkoN0UCOjHgzJ4VEO4q8uh2qR3jV7CmPfLK9BfjYEPL3jsObd6NVF/u9d7
         JhbjUQGGsDFIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC763609F7;
        Thu,  1 Jul 2021 20:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next Patch v3 0/3] DMAC based packet filtering
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162517020470.3771.14716519937544292426.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 20:10:04 +0000
References: <20210630101059.27334-1-hkelam@marvell.com>
In-Reply-To: <20210630101059.27334-1-hkelam@marvell.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 30 Jun 2021 15:40:56 +0530 you wrote:
> Each MAC block supports 32 DMAC filters which can be configured to accept
> or drop packets based on address match This patch series adds mbox
> handlers and extends ntuple filter callbacks to accomdate DMAC filters
> such that user can install DMAC based filters on interface from ethtool.
> 
> Patch1 adds necessary mbox handlers such that mbox consumers like PF netdev
> can add/delete/update DMAC filters and Patch2 adds debugfs support to dump
> current list of installed filters. Patch3 adds support to call mbox
> handlers upon receiving DMAC filters from ethtool ntuple commands.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] octeontx2-af: DMAC filter support in MAC block
    https://git.kernel.org/netdev/net/c/6f14078e3ee5
  - [net-next,v3,2/3] octeontx2-af: Debugfs support for DMAC filters
    https://git.kernel.org/netdev/net/c/dbc52debf95f
  - [net-next,v3,3/3] octeontx2-pf: offload DMAC filters to CGX/RPM block
    https://git.kernel.org/netdev/net/c/79d2be385e9e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


