Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307AB3F493C
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbhHWLB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:01:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236338AbhHWLA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 07:00:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 15430613C8;
        Mon, 23 Aug 2021 11:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629716408;
        bh=MTeDh3JsMvDf8fNuniA5EOdygFC8o00U4VnH9REwBJo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jorzRIa/EZrEkNAeEg5HORf9d6eCByEeVS2TcV9XopP66Y4kLSAT+0uqf17iuPwO4
         dMTaoEAIabhZkHe7cUJSAyjtYe7wm99yrFMTFrqE1bDdNyI8rUHnjXXzdqbyuqlk1X
         EcgsNIDQQWIV3r4sCPqnI0zrqGHvbNGD1NeZEcNQm8dEwNRPH0Rn7Uf189+XVP/R1U
         gm4aPf4WYZbbaGdo+GhKI5xCsar5aWVvE1yLEnZ2OszeJ8KPIOKFE3191cuhcRzX21
         4xmF/X4GKyDJZDw6rMXk94WKEc1ndH42IUR+NRCwuO2f1xRsI04kPxPIw/5K6p7j7I
         649/D4l+rJiwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0C83A609E6;
        Mon, 23 Aug 2021 11:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: broadcom: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971640804.3591.6165948198408667663.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:00:08 +0000
References: <c609bc53686fb8326244194a9bfccb75e0aef3f5.1629611777.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <c609bc53686fb8326244194a9bfccb75e0aef3f5.1629611777.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     rmody@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, siva.kallam@broadcom.com,
        prashant@broadcom.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 07:59:44 +0200 you wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below.
> 
> It has been compile tested.
> 
> 
> [...]

Here is the summary with links:
  - net: broadcom: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/df70303dd146

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


