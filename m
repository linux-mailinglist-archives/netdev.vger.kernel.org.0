Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B5B3CA4A0
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 19:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhGORm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 13:42:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhGORm6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 13:42:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DDC8761370;
        Thu, 15 Jul 2021 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626370804;
        bh=AvXsv3GD39OXLavXHgamvuxA4pg3QSFNOh8zinKDRbk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hg1/yZscgh8yxkB0M17N39apvTIHys+h/R6xarHcgKBecyvVo0kIMX6U3Ejlq6ct6
         wtc7Nj6DIinWhSc00VA98wD6oWi5PZL486XxFfUuLoKtiPcEbWvV8vSp2GZ6FbrZcq
         AsaABrRp14ZivW5RIUetG8O7VKJOpdW5CFjul8xvNGDEI4u85b+503lXhEO9wlzwar
         D9J/YiwQHu4d+WgOR0/w6j0nJLyMrrEFYs9UigKXM39KobzRNZqXm7aPjUd0RqueAW
         zOK20/oaCNTL3sG6cwNfrROXJ3znvryeXlrfQD3t//g2VDK6y7uFEdKaPoDGbmuUXy
         H+rdPWav+4O8g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CF3ED609EF;
        Thu, 15 Jul 2021 17:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: NET_DSA_MV88E6XXX_PTP should depend
 on NET_DSA_MV88E6XXX
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162637080484.16853.2952427953859094243.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Jul 2021 17:40:04 +0000
References: <0f880ee706a5478c7d8835a8f7aa15d3c0d916e3.1626256421.git.geert+renesas@glider.be>
In-Reply-To: <0f880ee706a5478c7d8835a8f7aa15d3c0d916e3.1626256421.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Jul 2021 11:58:12 +0200 you wrote:
> Making global2 support mandatory removed the Kconfig symbol
> NET_DSA_MV88E6XXX_GLOBAL2.  This symbol also served as an intermediate
> symbol to make NET_DSA_MV88E6XXX_PTP depend on NET_DSA_MV88E6XXX.  With
> the symbol removed, the user is always asked about PTP support for
> Marvell 88E6xxx switches, even if the latter support is not enabled.
> 
> Fix this by reinstating the dependency.
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: mv88e6xxx: NET_DSA_MV88E6XXX_PTP should depend on NET_DSA_MV88E6XXX
    https://git.kernel.org/netdev/net/c/99bb2ebab953

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


