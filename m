Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11003F4940
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbhHWLBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236357AbhHWLBF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 07:01:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2B2B86138E;
        Mon, 23 Aug 2021 11:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629716408;
        bh=qPc+/YNy+DRqqL2rBNWsuRnVgbCCXZALhynDGEd0BZA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X8GRSEZAYadCxPQ/kbXLlD8T8/tTnxc3M4wiiWneyWp8jNM/Iw8rhvf21e3/5Snkk
         4FLxZKc7Y3M/q5NKY0NSLbJHwbYAbcWBV4PGiW3EAk0smboKIurtuSOxw9f2hM2Ynr
         uv+8Fvyb1xNZlif2E4Q0bgTMh91GB8Lhq3NNoJ1mWuzXY5YrN9Dp0yLoMidfJCSFV3
         akuAnwkEpE2i/LOLKgbPVdMktiF8T9+LwT6CW2V4mdiy8n5nO2vtfshrUg44V03I7X
         r/pKigiKHzLTOLOTiAO8H7H+06HLDVHCWAxxB04LrJ0ojVlasa9GfBDuXEC6Jh2Ns8
         2zMS6qoM5jr9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 238D260A14;
        Mon, 23 Aug 2021 11:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ec_bhf: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971640814.3591.6280253938075829081.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:00:08 +0000
References: <a002a10bc045334efb854bfd80743e6487b8856b.1629613474.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <a002a10bc045334efb854bfd80743e6487b8856b.1629613474.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     reksio@newterm.pl, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 08:25:17 +0200 you wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below.
> 
> It has been hand modified to use 'dma_set_mask_and_coherent()' instead of
> 'pci_set_dma_mask()/pci_set_consistent_dma_mask()' when applicable.
> This is less verbose.
> 
> [...]

Here is the summary with links:
  - net: ec_bhf: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/05fbeb21afa0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


