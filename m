Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60B83195F3
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhBKWk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:40:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229907AbhBKWks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 17:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2BB4964E55;
        Thu, 11 Feb 2021 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613083208;
        bh=NCMpMdVoveJ63l/qLI1LC6Deeiq/VjezPF8sXz+cCG4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s+btd83uhlsW3y/6FX1JpX9lsctt4oGvRJXCIXGkSrp86IRP3PSNmk4DDLmJWNah2
         x5PN9hyuBFAxkT/9WZJz4YzvionF/SW0XeQHnDrVbixkrHwSU2QUOyPwASGTq7BUCI
         G4GCMpp951tx/JrhnGpNenrSdNRahlDD88uOcmSEldZVyKBDLMTWydKo7EiOFYvhBc
         SCcT4byF05pbPldmvODQg0ETP/epDW+hLzvBifkl1BB1TcZoZ/0gT0miULPRSE8i67
         sKOaRWT8telMZ6GrESQOf2abkX/Lgd2qzjTdLImXzGXySe3BYZUSFzNmsCmcpaSeSV
         xMh64F5pM2arg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1E87660A0F;
        Thu, 11 Feb 2021 22:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: disable detection of bogus xid's 308/388
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308320812.12386.15645663047471582940.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 22:40:08 +0000
References: <86862b9d-29ec-de71-889d-8ca5bba66892@gmail.com>
In-Reply-To: <86862b9d-29ec-de71-889d-8ca5bba66892@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Feb 2021 22:45:51 +0100 you wrote:
> Several years ago these two entries have been added, but it's not clear
> why. There's no trace that there has ever been such a chip version, and
> not even the r8101 vendor driver knows these id's. So let's disable
> detection, and if nobody complains remove them completely later.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: disable detection of bogus xid's 308/388
    https://git.kernel.org/netdev/net-next/c/cb456fce0b5a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


