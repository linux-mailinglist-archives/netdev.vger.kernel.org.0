Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7238A33A838
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 22:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbhCNVaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 17:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230482AbhCNVaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 17:30:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F23DA64EB3;
        Sun, 14 Mar 2021 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615757408;
        bh=yWfdJP78snR+PHJw9kAINJN+armndHy46iLsTSMnep4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ddUGpgJK4W7B+gvFivS3THkQQTZKedeJVlwO3OWi9Fjq1wmRkQ7sX5YbTVfqI/pGD
         KJdJ9uU+STwNK63L+I0x2k9c5qrBpSisvH3UkDj5woFWvNlZYlXGIVb60FoYOsUJpC
         FxJJiYD9o9s9qju2EOaRx7iHKsgurZegsxpPjplSvv/FIjmlrkIFntMWBK7u89dvl+
         mKmIbQM5sz4Nz3g6Ik6VSegnEl5TA/cqDkyACX5LBbDP3+X9i2EcUoyj4P1rzOFEqn
         MG5pkKp6ZUq7HR1iZNLeC1+CoWBlPoqaerj0W+jkzrhaJswuGiLPBikOL3RsvL60HZ
         3jwyvX3yotkAw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E044560A4C;
        Sun, 14 Mar 2021 21:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: arcnet: com20020 fix error handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161575740791.7685.11693179201709073385.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Mar 2021 21:30:07 +0000
References: <20210314180836.3105727-1-ztong0001@gmail.com>
In-Reply-To: <20210314180836.3105727-1-ztong0001@gmail.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     m.grzeschik@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 14 Mar 2021 14:08:36 -0400 you wrote:
> There are two issues when handling error case in com20020pci_probe()
> 
> 1. priv might be not initialized yet when calling com20020pci_remove()
> from com20020pci_probe(), since the priv is set at the very last but it
> can jump to error handling in the middle and priv remains NULL.
> 2. memory leak - the net device is allocated in alloc_arcdev but not
> properly released if error happens in the middle of the big for loop
> 
> [...]

Here is the summary with links:
  - net: arcnet: com20020 fix error handling
    https://git.kernel.org/netdev/net/c/6577b9a551ae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


