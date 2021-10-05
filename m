Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D3B4225FC
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 14:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhJEML6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 08:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233808AbhJEML5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 08:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4BD6E61166;
        Tue,  5 Oct 2021 12:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633435807;
        bh=tQ1PrR11XN1QXy/YyooEMn8lxi309ux+mV6CSzGbzC8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K05HggHF54sgYhgNXHumh68mFx2rizdYvCxSwum1iA1VjOgVQeuIWz93slKCNt0Ah
         UQGnwaN/23257gW+EESqY1ij9Fo1UeW+VEPP/9DhtDBnH9YKV5Z9kC74TfBmR7eF2Q
         AomjqnMJa8hCnMK3oaXn0aOqHHhwGkQ0QZosoJc/k4aHU+AoL76ZsUlcLokQ/xQfIj
         K77BjxVuASPYe6kroa3sM87aET+CRejbHqO+Bvsw4D+AmrQEpvEgaAnkJbjY39JaLE
         vdiSH02tyqkGlU+6M8aqVDMZlyOqHY2VpZp3qWAg+fcW6Ib7AKxYAEiL6VXHLzMjX7
         IIVnYWJOaC3+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 36D2A60A1B;
        Tue,  5 Oct 2021 12:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] net: sfp: Fix typo in state machine debug string
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163343580721.21299.18004142188617727761.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Oct 2021 12:10:07 +0000
References: <20211004215002.1647148-1-sean.anderson@seco.com>
In-Reply-To: <20211004215002.1647148-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org,
        hkallweit1@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  4 Oct 2021 17:50:02 -0400 you wrote:
> The string should be "tx_disable" to match the state enum.
> 
> Fixes: 4005a7cb4f55 ("net: phy: sftp: print debug message with text, not numbers")
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> This was first submitted as [1], but has been submitted separately, per
> request.
> 
> [...]

Here is the summary with links:
  - [net] net: sfp: Fix typo in state machine debug string
    https://git.kernel.org/netdev/net/c/25a9da6641f1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


