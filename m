Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F52386D6E
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 01:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344299AbhEQXBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 19:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238765AbhEQXB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 19:01:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ABCEA610A1;
        Mon, 17 May 2021 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621292411;
        bh=8OQAHG0kOm9j4hc3DY1QpLrqxPsAGcVCHsWaeT05rAE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kXXNuRKxTPCEQMXEeCzCHBxZfbZKfSrSg+9ORQQq99Vhke5rHmDOuJmy3j4zWsubc
         QdltI//V+EWTfflWqiAIiptG3nLMB5OeeSA363Bfbg7tL6ddrQe/MItRjnP3+cvCnt
         2bEerojVx27tY3blxTh2zDN0uMo400UX8dDzkAG+c3fs5X/57y4oMN9z5DYb4wOBF+
         2d7ymAsf92nxfDF+forWmnpKc7G2NrHCltNuwRl2/gusO1xm/dRkV13fokAGm/6LKr
         vs+pbIbjjfKBNe2jjftqKleGp6l3IEyUCTbO1/MVidEywUlVv3AnmSez6nLI3ELTSB
         +LnbftYGdWOLQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A0FA760963;
        Mon, 17 May 2021 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: mdiobus: get rid of a BUG_ON()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162129241165.19462.1241266226481207863.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 23:00:11 +0000
References: <20210517090413.GC1955@kadam>
In-Reply-To: <20210517090413.GC1955@kadam>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 17 May 2021 12:04:13 +0300 you wrote:
> We spotted a bug recently during a review where a driver was
> unregistering a bus that wasn't registered, which would trigger this
> BUG_ON().  Let's handle that situation more gracefully, and just print
> a warning and return.
> 
> Reported-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: mdiobus: get rid of a BUG_ON()
    https://git.kernel.org/netdev/net/c/1dde47a66d4f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


