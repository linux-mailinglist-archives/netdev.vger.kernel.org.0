Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD353195DD
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhBKWay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:30:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhBKWas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 17:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DFDCC64E3E;
        Thu, 11 Feb 2021 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613082607;
        bh=ShaKD/qbpIBe4ljPAtsNXUzPCgxCW3u0FCJboIKCiQs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R7EBbhj7G5L0j+Cw2Lex+ikcYBbajtrVLtSSsly3vpqR60znu0l29MlLjNIUt2DfA
         lxlOoXo/pPp+0zRRktRFtUAuj/NLOOsTuUC2St0XU3I6Qzhms7SB2UE2Td4tZSdvdk
         mP5iQjZPnngUlspYbKZMVXlaf5Oz3pEMHAmUASYE4n/p1j+YXnh5pB3MBluh948wnd
         k792LJRQqlP2EV5Zj4DRj6rfvGl9i0pzxxRKYJAIqgBlDOnnVtTJLeWOXX4UYJ188h
         6JTWDGRcFFMFh32rposDD25SDg4QbfFQzIs3wzCS16Tt5lHVWBsTMEOAzmr4ZvGfrz
         FRoK17/ZGYHMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CF45E60A2B;
        Thu, 11 Feb 2021 22:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: dwmac-intel-plat: remove unnecessary
 initialization
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308260784.8386.13702432494789149514.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 22:30:07 +0000
References: <20210210175935.3967631-1-nobuhiro1.iwamatsu@toshiba.co.jp>
In-Reply-To: <20210210175935.3967631-1-nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     davem@davemloft.net, kuba@kernel.org,
        rusaimi.amira.rusaimi@intel.com, vineetha.g.jaya.kumaran@intel.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Feb 2021 02:59:35 +0900 you wrote:
> plat_dat is initialized by stmmac_probe_config_dt().
> So, initialization is not required by priv->plat.
> This removes unnecessary initialization and variables.
> 
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c | 3 ---
>  1 file changed, 3 deletions(-)

Here is the summary with links:
  - net: stmmac: dwmac-intel-plat: remove unnecessary initialization
    https://git.kernel.org/netdev/net-next/c/0d645232ddbf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


