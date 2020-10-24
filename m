Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF054297A3B
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 03:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759151AbgJXBuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 21:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758773AbgJXBuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 21:50:05 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603504204;
        bh=CUzXYLtGveFSmSlLezNAhFfONjePV76oNr6E0NVVEKw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WEluteaaGv6KupDmZlmaFO3i56MU36X2hwKCaN3DaoM/8rC+Olk8QhzpKa/y5eF/p
         yRlEdR5Z5/R35RGBOv5OFQrQ5ss3XhFRl3t264YDx5/Y0jgNNJZZto0B0uQlO7WHWy
         V7gTUJ1bPA9SQjhC/Xll9B4QnDBPq7l2yINxaeIo=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ucc_geth: Drop extraneous parentheses in comparison
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160350420488.19271.8517625385382285867.git-patchwork-notify@kernel.org>
Date:   Sat, 24 Oct 2020 01:50:04 +0000
References: <20201023033236.3296988-1-mpe@ellerman.id.au>
In-Reply-To: <20201023033236.3296988-1-mpe@ellerman.id.au>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@ozlabs.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org, kuba@kernel.org,
        leoyang.li@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Oct 2020 14:32:36 +1100 you wrote:
> Clang warns about the extra parentheses in this comparison:
> 
>   drivers/net/ethernet/freescale/ucc_geth.c:1361:28:
>   warning: equality comparison with extraneous parentheses
>     if ((ugeth->phy_interface == PHY_INTERFACE_MODE_SGMII))
>          ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - net: ucc_geth: Drop extraneous parentheses in comparison
    https://git.kernel.org/netdev/net/c/dab234227cbd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


