Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5423C2904
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 20:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhGIScu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 14:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhGIScs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 14:32:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DD262613C2;
        Fri,  9 Jul 2021 18:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625855404;
        bh=YTrKq02x1uN06n6JSc2dj2S/PWqa0Lk7L8H/qqkYa1U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T+IqmPOdvRRjiXq1efB+MOGtzVqirN968mvsDf/QMvXczmtvkxsPcU2ox0Cku0Jjk
         m32031G/XWzMM6WQBoxFCu+wbaEU4YOV1S1Bx7ayVLsgT14JRWMhaqEln4PSjUxRtB
         bj134LjTmemoUkC0vDrIXLlD9G8yBHG7BPdifJX28S0L8Z2Qd1LluwpBEwmlDhEtAG
         /Gt7dpV5aZjRF74NAHC+vetoXA3z6IfsuGASmEAE8AnMQLcjwyQRtCvpoDdjcQp88W
         9xRaIbyQmfifKJapCorKjAx4XwH/SdXWZ/JotmarQoCTOTd32C1iZTefxI9Sw8LRFt
         arKuUVa81YYsg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD2D760A54;
        Fri,  9 Jul 2021 18:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: moxa: fix UAF in moxart_mac_probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162585540483.20680.9784988427588332803.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Jul 2021 18:30:04 +0000
References: <20210709140953.1063-1-paskripkin@gmail.com>
In-Reply-To: <20210709140953.1063-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, huangguobin4@huawei.com,
        jonas.jensen@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  9 Jul 2021 17:09:53 +0300 you wrote:
> In case of netdev registration failure the code path will
> jump to init_fail label:
> 
> init_fail:
> 	netdev_err(ndev, "init failed\n");
> 	moxart_mac_free_memory(ndev);
> irq_map_fail:
> 	free_netdev(ndev);
> 	return ret;
> 
> [...]

Here is the summary with links:
  - net: moxa: fix UAF in moxart_mac_probe
    https://git.kernel.org/netdev/net/c/c78eaeebe855

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


