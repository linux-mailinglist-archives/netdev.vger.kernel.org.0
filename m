Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A906A2F85A9
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387641AbhAOTku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:40:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbhAOTks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 14:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 21A4323877;
        Fri, 15 Jan 2021 19:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610739608;
        bh=OqJuTacYVe5Bxir/gb6byWVxQroc34WsBFDoE5pzCr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eve3pEq5Rm7heki7mRBtsSuIj1CY9UUyC9vTZkiaIa9IJRrETwM86XTRPMkrc1+pt
         pKWGilehOkMGFiK0r3Vt57cjYz4I/v6vnj4fdjwYNDOd8e7LaLV3KYxCZ5u04lZjqk
         hEwCHRuf4VY6xtd4rmapUjDCqaezpufTOSYa+sYsCiajDLWLV+B5oZed4xB63Hktg8
         m3bAYO1Y12ml/r5XcMYFXM4Mt3qIfreImM5nSuMHic/GYdUYqpQMYMiTkxi2bUWDlc
         LM32u4RzermMPwVskS3ZLGFY3K9Dsu8Lm4wnxepmMcyeGlIwwzNTAfPEwpiNkZ8U1F
         PdSDvPsp3WHZw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 16AB660593;
        Fri, 15 Jan 2021 19:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] octeontx2-af: Fix missing check bugs in rvu_cgx.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161073960808.5378.10488625223498492105.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jan 2021 19:40:08 +0000
References: <1610719804-35230-1-git-send-email-wangyingjie55@126.com>
In-Reply-To: <1610719804-35230-1-git-send-email-wangyingjie55@126.com>
To:     Yingjie Wang <wangyingjie55@126.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vraman@marvell.com,
        skardach@marvell.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 15 Jan 2021 06:10:04 -0800 you wrote:
> From: Yingjie Wang <wangyingjie55@126.com>
> 
> In rvu_mbox_handler_cgx_mac_addr_get()
> and rvu_mbox_handler_cgx_mac_addr_set(),
> the msg is expected only from PFs that are mapped to CGX LMACs.
> It should be checked before mapping,
> so we add the is_cgx_config_permitted() in the functions.
> 
> [...]

Here is the summary with links:
  - [v3] octeontx2-af: Fix missing check bugs in rvu_cgx.c
    https://git.kernel.org/netdev/net/c/b7ba6cfabc42

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


