Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B5F2CFF9A
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 00:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgLEXAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 18:00:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEXAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 18:00:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607209206;
        bh=AgNJgCAvUzG/kGKbmPBycQCCzb13w/7DtKx2Qz0E0N8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W1seaw+Zh4OglvdNkO4vye32BjaqIX4euaysD99g277xEKml2cjHMAG6wwNvmD0zL
         TmRi+0XNnVV00KarsIWRjgc8Ya6G8uHVYIAvwZrear2PYeUggGNE1IdpveUIShH7+D
         WqfTOILZVx/LN1agv11at2uAjFSFPgqlHja+YinKz2AudUO0rxmjUmSjEGG39syFiS
         DdbhMGlrIB3SCLC7uKjEWuFBe3Xa7dFNuULKwJn9Vcw4Y01vVVz4t34auZRWBoJ2lA
         E5a6CkaptB32kwjluRb76HGfGxZyJN6/FYFd61p5RNDPsqnHhe7Eu1m/DGz7SLLNx/
         GCHkiEYyj2lyQ==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] enetc: Fix unused var build warning for CONFIG_OF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160720920654.11906.15915031095378086840.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Dec 2020 23:00:06 +0000
References: <20201204120800.17193-1-claudiu.manoil@nxp.com>
In-Reply-To: <20201204120800.17193-1-claudiu.manoil@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        arnd@arndb.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  4 Dec 2020 14:08:00 +0200 you wrote:
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
  - enetc: Fix unused var build warning for CONFIG_OF
    https://git.kernel.org/netdev/net-next/c/4560b2a3ecdd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


