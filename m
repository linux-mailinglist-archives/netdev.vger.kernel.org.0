Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB0D31E18E
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 22:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhBQVkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 16:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231547AbhBQVks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 16:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 41A9F6186A;
        Wed, 17 Feb 2021 21:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613598008;
        bh=6NGqrFSbOLsiaMsrlfVnjrcO4pWY8TZorw5EHJN1yJs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F2BcKrrQQuvo/oFEsX7gE98EoL5XR4on9ZM2MstRKl1gWJ+tCUM5MyOMmPZX92yZ3
         2lqPGDcIe90Wy0lgvddbjV8bsN4LSe+6lqiztoTZYpVRSFhna5irL9nMpq5QLnQhUy
         BEekAxgYeHHzPSniwl24z0CUfbnHVlakXWA4cno0OIi81bwLwjo1BcxEhXfw9YWU+u
         trLgkh0pupDw8eRBScuURJvOlhoQyyuqRalA4aFfCUix/DnOgazKXE3S+Dwcw6E0am
         Ba2h4e+KuwV3GAVfUt+jSvffGFJiF0SaLvarMOp9bt5dq8Y4xwwKTy2kt4CB9NjF4a
         89RjsHMAqAfNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2DD4B60A17;
        Wed, 17 Feb 2021 21:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: use macro pm_ptr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161359800818.6903.10569917052223442087.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Feb 2021 21:40:08 +0000
References: <c79d075a-e30d-7960-83cb-820a18abd782@gmail.com>
In-Reply-To: <c79d075a-e30d-7960-83cb-820a18abd782@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Feb 2021 22:23:58 +0100 you wrote:
> Use macro pm_ptr(), this helps to avoid some ifdeffery.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] r8169: use macro pm_ptr
    https://git.kernel.org/netdev/net-next/c/80a2a40bd296

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


