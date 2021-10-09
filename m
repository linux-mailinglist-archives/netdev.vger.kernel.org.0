Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57038427477
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 02:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243950AbhJIACF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 20:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243798AbhJIACD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 20:02:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FC1B60FDC;
        Sat,  9 Oct 2021 00:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633737607;
        bh=HY/FnszOBnN8B7mHWvR5hwGsTE9czR8qvpoXRWqESTg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CfT/daZUpKsXpu/VzNQuJJClijQWcuN4xRukiAvanJ4i8hkCd5ZaOzYISfcWkkVis
         MSL2cBVR4B2iZ91RA8uTGv6ijpvrGBQW0PBhqP4djtkdyzSu89t4RaX2tMGr9Vr6Zh
         TAxCga3MCTbbWUJb9GgkicGlDLhR1TQA4XkLTN3WBxys5dXJHnoCEFl0V7U6odfiTA
         OplJaqKunFvMUC2f2IJU15/w/yDyPNa86mGdnnvvQEA9NwgfMF3zCisled8dLZpwSP
         ZHvEquntL+4DF4gP+dE1V/5DOy2sdzZBXu4xNG1MQ2vu4RCE5zOmpg++N2tCdH5oe9
         HgPsMaOd7USlw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8A1D5608FC;
        Sat,  9 Oct 2021 00:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: tg3: fix redundant check of true expression
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163373760756.30259.6866212585033229395.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Oct 2021 00:00:07 +0000
References: <20211008063147.1421-1-sakiwit@gmail.com>
In-Reply-To: <20211008063147.1421-1-sakiwit@gmail.com>
To:     =?utf-8?q?J=CE=B5an_Sacren_=3Csakiwit=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  8 Oct 2021 00:31:47 -0600 you wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> Remove the redundant check of (tg3_asic_rev(tp) == ASIC_REV_5705) after
> it is checked to be true.
> 
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: tg3: fix redundant check of true expression
    https://git.kernel.org/netdev/net-next/c/6ed3f61e3200

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


