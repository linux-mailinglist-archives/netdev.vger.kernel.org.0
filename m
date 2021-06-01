Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F85397C57
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbhFAWVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234782AbhFAWVq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:21:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 67A0B613C5;
        Tue,  1 Jun 2021 22:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622586004;
        bh=g1tw+FPPd3DSpbK+2Otf7EZbgYqMjlArAp/nvP0NZao=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Os2DGtKkngu92nV7DlTkJX8QInqN6MTQwA0GAubsLXFu93SwhlnQyTT+p2zN4uxYd
         sKYesYJ/n47iZ5JOZc6WpgJ2cHAPBJb24G8vTnIemoDRnkP8utlj5vbNZ/nl3Q3/Sa
         VKasD+GZHpc5Bp4dwYLMn4Vy2ttKb+zo8wN02r7JTc/0PsYew5DmiL1QLRJk5Dn5Rp
         nHdprl34GmrSROw7eAO04QB/hNMM3cGbDdbz3Igko7MVyOOL+hVXeuIQOi5+n55Ei7
         poBjf/ZZoApWj8glpywTlwaWLLEabR+04IJDSbEq/zfREFW4g5ApEkeJx6LAjqimkX
         mTXoumk1OLe0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5910860A47;
        Tue,  1 Jun 2021 22:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] Marvell Prestera Switchdev initial updates
 for firmware version 3.0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162258600435.8548.1338921091952281255.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 22:20:04 +0000
References: <20210531143246.24202-1-vadym.kochan@plvision.eu>
In-Reply-To: <20210531143246.24202-1-vadym.kochan@plvision.eu>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, tchornyi@marvell.com, linux-kernel@vger.kernel.org,
        mickeyr@marvell.com, vkochan@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 31 May 2021 17:32:42 +0300 you wrote:
> From: Vadym Kochan <vkochan@marvell.com>
> 
> This series adds minimal support for firmware version 3.0 which
> has such changes like:
> 
>     - initial routing support
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] net: marvell: prestera: disable events interrupt while handling
    https://git.kernel.org/netdev/net-next/c/263805c8840d
  - [net-next,v2,2/4] net: marvell: prestera: align flood setting according to latest firmware version
    https://git.kernel.org/netdev/net-next/c/c00e8a69fe42
  - [net-next,v2,3/4] net: marvell: prestera: bump supported firmware version to 3.0
    https://git.kernel.org/netdev/net-next/c/f1e1b2630178
  - [net-next,v2,4/4] net: marvell: prestera: try to load previous fw version
    https://git.kernel.org/netdev/net-next/c/47f26018a414

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


