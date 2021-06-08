Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1113A03CD
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbhFHTWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238809AbhFHTUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 15:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 06BA561108;
        Tue,  8 Jun 2021 19:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623179406;
        bh=beXrWUmJ/DeDzNcwkMAHQNTc8EyAukeMvuIL3vxiiGk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DFtgD3Wq+gf0mRStPNaQxMy7rcX4vsrqPWvjnZ1O2jt/eap8l+LC9GNUxKvi3vfak
         vmlFFrJ8tvnrfnfsPqUv5oF2l/0EoRI44woL19eSbIST6O8moBQ6r08W8Q9B+k5Nci
         BsFdmeM1x6n+RG1rDXSkAP1CangZJK5Wm5zFRmZ7JnQAcTbhlb6tlysf802JDPbDsG
         O5ngHnv2DQxMrSOKhFW3W0mqsxYxzbtELTkhiBhQUVnFdF/FB0TG53KaiCvPEutUJ5
         4xWad7gJ5q/BhoNGKU4Oml4Tqs8b/8ECNj0GHtQh63ObfW+jkJ8rqA/OSjzhZCSASz
         trO4T2CYXwG1Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EE223609E4;
        Tue,  8 Jun 2021 19:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nvme: NVME_TCP_OFFLOAD should not default to m
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162317940597.2276.17237091802998795532.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 19:10:05 +0000
References: <39b1a3684880e1d85ef76e34403886e8f1d22508.1623149635.git.geert+renesas@glider.be>
In-Reply-To: <39b1a3684880e1d85ef76e34403886e8f1d22508.1623149635.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     davem@davemloft.net, kbusch@kernel.org, axboe@fb.com, hch@lst.de,
        sagi@grimberg.me, okulkarni@marvell.com, hare@suse.de,
        dbalandin@marvell.com, himanshu.madhani@oracle.com,
        smalin@marvell.com, pmladek@suse.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  8 Jun 2021 12:56:09 +0200 you wrote:
> The help text for the symbol controlling support for the NVM Express
> over Fabrics TCP offload common layer suggests to not enable this
> support when unsure.
> 
> Hence drop the "default m", which actually means "default y" if
> CONFIG_MODULES is not enabled.
> 
> [...]

Here is the summary with links:
  - nvme: NVME_TCP_OFFLOAD should not default to m
    https://git.kernel.org/netdev/net-next/c/762411542050

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


