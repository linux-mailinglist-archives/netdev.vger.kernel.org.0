Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A652443BC3E
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 23:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbhJZVWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239545AbhJZVWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 17:22:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3418560F6F;
        Tue, 26 Oct 2021 21:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635283207;
        bh=nQifvL4+pk6Cow8uPtB2KSsFheh4K34V6u8mJl5LvWo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OvFp9tZBMpupSHVLFGTRjRftVE1raXlVzFJioIqCnY37RF+ktFDPbq8gPiW0/0SUA
         0Rob6FDSxvMf0jN1mlzMYPkU95LtxdvtzU/kqBJv3GupR58/kTPBFkXTL6TzjMh3Zb
         6RFnPIJSc6/lWSbgBII1OwisMNSSzv1nzi6vXdtf3XtaJlnKgqepmvY0Ky1Dh1NIwa
         PGQ07nP2OiBQX8FsStmP4ZX75Dhv9liBWcEgwfSNXvef1cZ/gsUOrUKybTEJ1bFgRt
         8VvLok1rkRBmZGv9JWPMZkaDS6f7VEWISSxe6YapB3N5zO5SmbgsFYTSiM7XgFL0KY
         TAG7E93RwN4wg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2578D60726;
        Tue, 26 Oct 2021 21:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: fixed warning: Function parameter not described
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163528320714.24909.13854222540925887393.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 21:20:07 +0000
References: <20211026102957.17100-1-luoj@codeaurora.org>
In-Reply-To: <20211026102957.17100-1-luoj@codeaurora.org>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Oct 2021 18:29:57 +0800 you wrote:
> Fixed warning: Function parameter or member 'enable' not
> described in 'genphy_c45_fast_retrain'
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> ---
>  drivers/net/phy/phy-c45.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - net: phy: fixed warning: Function parameter not described
    https://git.kernel.org/netdev/net-next/c/06338ceff925

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


