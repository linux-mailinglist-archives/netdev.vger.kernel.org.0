Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C989334C0E2
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhC2BKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229861AbhC2BKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 21:10:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B544361878;
        Mon, 29 Mar 2021 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616980209;
        bh=7ZpGTszKHp/HTdmdSRY3sy5MYneNTgNrftTkGvrMlh0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e8g2Tgs5GUYKG4u+HXmBRnNreEUAsZtIOydjHygAkt2UGkP6d8SFB/FGEi9gfhCIr
         jRSLPFhXZmZQ/Y8NCFWwHTEtk0SZ8GNfiJH1oymg/gng7VDPVZeGpq/Y2Z4Rlxfa8k
         Ld0hEx21DRFLs6UL//ZOpkva2EyeXhKWrYWMBeOX0H/H9K2l4QyOxU+Z+zKMBvcS3C
         SlD52tdRP2xT0wAHmczljWxvaIfysM68OdlWIqr/1s+jNd+gJ3K7h5mK+zXgGKMHMn
         /skOy/vFOQ34k5oR5p11V+LkOjFS7YesxNNGP5poVpEa1y6Nr80x04e4ABBUaDnix2
         fDPmbj7kuBlGg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A6C3A60A3B;
        Mon, 29 Mar 2021 01:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mt76: mt7615: remove redundant dev_err call in
 mt7622_wmac_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161698020967.2631.17916389081654027279.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 01:10:09 +0000
References: <1616838978-6420-1-git-send-email-huangguobin4@huawei.com>
In-Reply-To: <1616838978-6420-1-git-send-email-huangguobin4@huawei.com>
To:     Huang Guobin <huangguobin4@huawei.com>
Cc:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, kvalo@codeaurora.org,
        kuba@kernel.org, matthias.bgg@gmail.com,
        elfring@users.sourceforge.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 27 Mar 2021 17:56:18 +0800 you wrote:
> From: Guobin Huang <huangguobin4@huawei.com>
> 
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] mt76: mt7615: remove redundant dev_err call in mt7622_wmac_probe()
    https://git.kernel.org/netdev/net-next/c/8e99ca3fdb31

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


