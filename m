Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB3C3F4975
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236530AbhHWLLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236338AbhHWLK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 07:10:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9436E613B3;
        Mon, 23 Aug 2021 11:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629717015;
        bh=JIsdeovlEQV2y6xWAw1Frvg3XwKaQTW6JRoR4Z5ro4s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ix1YqcomnExU2bdEuSDSUSh23XIJYTdgCBsWNE/gUwrwKU3SUo1Xli0ysmmwu6zZf
         +52knXCODQ9KZaA2yM0cBVoiLjcBGBeHL/121ILI0Q+cb2C1FMP+La2k6howMzV4+g
         tc5KhxYAbYL7r3hHwUdzwTFDBfy2rCMTc0JMJLSUX44fmzbJ9wHfBuAgcZCp9cwiim
         kj2eUNyJi5oIAPab+lJ8CxXnRzg88afqMHj+IDP5F3D82fEc1hY5UC2+XNxIK2xVVj
         3hQo8BEj/wYfvosQksZbpJMB77mi2DjSrPMkt/RKHRu5GGW19l3sZ5F2tNwdh9r3Vp
         bD4WdMScLtDyw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 88087609ED;
        Mon, 23 Aug 2021 11:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qlcnic: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971701555.8269.16969253034297567411.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:10:15 +0000
References: <31df87ec75de7cdb52941c46f5b08beea603db67.1629664882.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <31df87ec75de7cdb52941c46f5b08beea603db67.1629664882.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 22:42:45 +0200 you wrote:
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
  - qlcnic: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/a14e39041b20

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


