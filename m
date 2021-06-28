Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB88C3B6B10
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbhF1Wwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234332AbhF1Ww3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 18:52:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6672761CF8;
        Mon, 28 Jun 2021 22:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624920603;
        bh=+gUO1O+1c6ODZizu1igqWRG3S/qxAbxEupFjE4NJa2o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YbwAXixCvr411g6L7zj6mn/oBn6soO5Zkmw42NRaR/O7GYWs5b0we1TDFaNg4vkGT
         X5jrRttkbY0z3YYSzA01fTOw3qEIclKVkniIyx2xBZRZ7zVye4/mVsb06TyJq/cf5j
         vm7HDalTUQjq17DoN1uVfF3CfgEHCEqhbRlIJs4wsA1+TLxdkW5cxHsd980LEtGKB2
         YKwSDtvpteg7YEUIOmS3Gem3Ldn1eBmJRBHrP+1Vhf6qKxAoAk22POxqhS92Ijpswj
         n86S4caHshMKXePGZeUt6QFjg4+k2LW1zBoxD5HLrgAlBuObqsfzbdPxjrhpnmeqUf
         Qc7ENNM5sQCaQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5B39860ACA;
        Mon, 28 Jun 2021 22:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: at803x: mask 1000 Base-X link mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162492060336.20914.6352883574180645313.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 22:50:03 +0000
References: <20210627101607.79604-1-mail@david-bauer.net>
In-Reply-To: <20210627101607.79604-1-mail@david-bauer.net>
To:     David Bauer <mail@david-bauer.net>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 27 Jun 2021 12:16:07 +0200 you wrote:
> AR8031/AR8033 have different status registers for copper
> and fiber operation. However, the extended status register
> is the same for both operation modes.
> 
> As a result of that, ESTATUS_1000_XFULL is set to 1 even when
> operating in copper TP mode.
> 
> [...]

Here is the summary with links:
  - net: phy: at803x: mask 1000 Base-X link mode
    https://git.kernel.org/netdev/net/c/b856150c8098

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


