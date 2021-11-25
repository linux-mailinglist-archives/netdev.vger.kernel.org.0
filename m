Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB0345DE37
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 17:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356229AbhKYQFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 11:05:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhKYQDV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 11:03:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 236B66108E;
        Thu, 25 Nov 2021 16:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637856010;
        bh=ucYoul2wvLTG4PBO56hF4AxJWAGQbC8TJdZcAk422Ks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ePD6MPCAjCTjr8QWwQYoks4TOCIjpPFBQQvPqPPsb/JcwATS6NHiA8K/5nqsaN5kV
         rjvQy1StCKoCq0IdZG1BeRZ4oy+rQ0exEEwN+HNnEtfPEgeJ+Im7evrQNnx7pyWL1a
         VJ3DmstgvES4ranJaEy9QbqZPozUIOW03yFGEdIbGsDcJ9e97j1r1QuoIxB+9YXXsT
         NaZFWbejIvCREg2Sid3PXBgxHUCXED2DwXmCtWpry3iF5r/kJHxoWa3Jxw/9+E7yZr
         +2dLbQ9dr374v8LDqL6ZKzV3mEhFZx1LEUWizLScI981xQ3dxNZfVY0txTdRneJJ9+
         IcyHja+Gy5+fw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1624160A21;
        Thu, 25 Nov 2021 16:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] mdio: aspeed: Fix "Link is Down" issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163785601008.7926.14064362154729889685.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 16:00:10 +0000
References: <20211125024432.15809-1-dylan_hung@aspeedtech.com>
In-Reply-To: <20211125024432.15809-1-dylan_hung@aspeedtech.com>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     linux-kernel@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        andrew@aj.id.au, joel@jms.id.au, kuba@kernel.org,
        davem@davemloft.net, linux@armlinux.org.uk, hkallweit1@gmail.com,
        andrew@lunn.ch, BMC-SW@aspeedtech.com, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Nov 2021 10:44:32 +0800 you wrote:
> The issue happened randomly in runtime.  The message "Link is Down" is
> popped but soon it recovered to "Link is Up".
> 
> The "Link is Down" results from the incorrect read data for reading the
> PHY register via MDIO bus.  The correct sequence for reading the data
> shall be:
> 1. fire the command
> 2. wait for command done (this step was missing)
> 3. wait for data idle
> 4. read data from data register
> 
> [...]

Here is the summary with links:
  - [v2] mdio: aspeed: Fix "Link is Down" issue
    https://git.kernel.org/netdev/net/c/9dbe33cf371b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


