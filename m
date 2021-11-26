Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14A645E682
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344389AbhKZDZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 22:25:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240350AbhKZDXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 22:23:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 947F261153;
        Fri, 26 Nov 2021 03:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637896809;
        bh=7R6XHeeL2eJcyoGV8z6TQgONW9rXgQ5/Zu2jBHj3anE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rQrF4aXDd0tThjDj+T/0SXcZbfjhGtx/25XlMOTgHRPZZaOKGvB+uhGvqm4s2J3xj
         FXephgOlI5fWoPzw0Hrrf9zB4D51TiaGrlOvvlxyO72z9g3H0lt1v8M/DuakyT3itF
         tJcHOhd6fLb8w3+kAiUfgnbHbrwHXnvwBxxokpP25MSHEbrx17kYQqn7fH5HIiuJFs
         bYIFXGMVCfCf2U+7f/4OxtFfdru5v9P9mrJXIFWh7RT2/mabmxE2qhjD1NssL6Jb6+
         mf7SgoBtYTijwaCwgG7zWdxthuLvuc6aDLCIs5MnpEEX+KxCCZHaml8rnl+IM5qiro
         xeLdVZ8FQlPTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8800960A6C;
        Fri, 26 Nov 2021 03:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: disable detection of chip version 60
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163789680955.4222.5530649894034387002.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 03:20:09 +0000
References: <2cd3df01-5f8b-08dd-6def-3f31a3014bde@gmail.com>
In-Reply-To: <2cd3df01-5f8b-08dd-6def-3f31a3014bde@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 21:44:40 +0100 you wrote:
> It seems only XID 609 made it to the mass market. Therefore let's
> disable detection of the other RTL8125a XID's. If nobody complains
> we can remove support for RTL_GIGA_MAC_VER_60 later.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] r8169: disable detection of chip version 60
    https://git.kernel.org/netdev/net-next/c/4e9c91cf92ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


