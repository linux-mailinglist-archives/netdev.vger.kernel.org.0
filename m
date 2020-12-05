Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146822CFF98
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 00:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgLEXAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 18:00:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgLEXAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 18:00:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607209206;
        bh=MKcpS+fMViwj2ZnsgwDgH8ZLurqkru7yof1XDaB8Ex8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B0INwxU22rHFo9K5FUeErljjHPVV5PpvGM6UMw2op8px+8gXCJpd8fYNBGzSo3M1K
         Pat7AL4gxjrWYsoPz6xhOW6/XUfoD+2TAjjUrteLirWSMyxozpn266MpfgVjGwq6z7
         oYw4+JVt+bWwhDS6+EiLJiPq360oeC2wUiecDAjumMyA1t7ab8OO1LmW3tIGt0wekG
         zN0nIfylQ47Q9t09e5tewTIUXKqEjPimZZyggBt1cnl3+t1N8z3Kba5khORPO6uwFw
         6O/JsM+3C+glo7O4L6YsjHMlulw7dr4ah63QImYvenMIRr32ljfh2ZJI2EgVAN1QDE
         TjXKtSSePLUzw==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [v2] enetc: fix build warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160720920660.11906.14795091010527970418.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Dec 2020 23:00:06 +0000
References: <20201204192910.2306023-1-arnd@kernel.org>
In-Reply-To: <20201204192910.2306023-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, ioana.cionei@nxp.com, arnd@arndb.de,
        Po.Liu@nxp.com, leon@kernel.org, alexandru.marginean@nxp.com,
        michael@walle.cc, vladimir.oltean@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  4 Dec 2020 20:28:59 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When CONFIG_OF is disabled, there is a harmless warning about
> an unused variable:
> 
> enetc_pf.c: In function 'enetc_phylink_create':
> enetc_pf.c:981:17: error: unused variable 'dev' [-Werror=unused-variable]
> 
> [...]

Here is the summary with links:
  - [v2] enetc: fix build warning
    https://git.kernel.org/netdev/net-next/c/4560b2a3ecdd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


