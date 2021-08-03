Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD073DEB3C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 12:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbhHCKu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 06:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235479AbhHCKuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 06:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2B2EA61051;
        Tue,  3 Aug 2021 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627987807;
        bh=5Gx9xThk2lQaUmxEZci+7l8glKf/fyIeRD5SMJMl0l8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XlBeNRI/5Gz6u1zcciwHezw2OxgH/kXLFXpr1apOR4Er0ON5v3yA/Ys6AGh9x5Wxd
         OlJD+Y/8sb6Vsdgpn//YCuaaUjwLRZ6RJSVVOICV8edNno0avo0AkeaMM577GXEwvQ
         lYyJCwmsmXOG0YjiCoKUx0+454xukvU3KPxPlfTiGp1jP0R3YHefSuSOZ/EPlVMsQD
         4CPVMLkr5CGKyUsBWXPpPSJi2l0G8PLRT0m6yuio2cP5nATZBLA6ruPSKTxC/dCgqT
         ZlXnb0hZl2YmaBnyx7ZDfKJb/pRKikVrD36eEmx34xHGViPrBRCD08p9ezP+ZdLELj
         l7cSK59Pngleg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 258BA60A49;
        Tue,  3 Aug 2021 10:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: Avoid db_recovery during recovery
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162798780714.3453.2415423620193302473.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 10:50:07 +0000
References: <20210801102340.19660-1-smalin@marvell.com>
In-Reply-To: <20210801102340.19660-1-smalin@marvell.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        aelior@marvell.com, malin1024@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 1 Aug 2021 13:23:40 +0300 you wrote:
> Avoid calling the qed doorbell recovery - qed_db_rec_handler()
> during device recovery.
> 
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_main.c | 5 +++++
>  1 file changed, 5 insertions(+)

Here is the summary with links:
  - qed: Avoid db_recovery during recovery
    https://git.kernel.org/netdev/net-next/c/995c3d49bd71

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


