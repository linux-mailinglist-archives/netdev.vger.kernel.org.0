Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEAD46C2FC
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 19:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240604AbhLGSnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 13:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbhLGSnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 13:43:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B9AC061574;
        Tue,  7 Dec 2021 10:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 006C7CE1D8F;
        Tue,  7 Dec 2021 18:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7E5AC341C7;
        Tue,  7 Dec 2021 18:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638902411;
        bh=ILmDEX7ThAV4WS/jNr/jBBecP8tMHp+dApEK+/6VC8Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D806Oot+ukqAe2IOOu/ymmRPC5f8qmg0736iQbtTQjlCRNKCLI7GyD2agVcBFjQH8
         44SNDgxSXkltVzgGR/CDGB7c3F7S+9MlboSbX9J2KK5H7XAeoTaH3i7wImVodj8CYJ
         fChei1+kXe94q44uxVbzUM8KF3h7HlCCNJXAmSECJe+MVxBm6JAP+JZHgSMugi/kiQ
         PHC15RK+aEMJ0d6i9puiZYaGa73LZLsQh2EhnKGwRli0wzIP6LjH0J//JDopMFrbek
         UjfFdt8Vu4oKUa9MqoBOcBJozqMfOM+tLipViATF3/a/8FvUE2qUmyJVlwMEVCub3f
         XMudnn/hcWHRw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BEFF3609D8;
        Tue,  7 Dec 2021 18:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/9] can: pch_can: pch_can_rx_normal: fix use after free
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163890241077.29949.3491385738739624114.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Dec 2021 18:40:10 +0000
References: <20211207102420.120131-2-mkl@pengutronix.de>
In-Reply-To: <20211207102420.120131-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        mailhol.vincent@wanadoo.fr, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Tue,  7 Dec 2021 11:24:12 +0100 you wrote:
> From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> 
> After calling netif_receive_skb(skb), dereferencing skb is unsafe.
> Especially, the can_frame cf which aliases skb memory is dereferenced
> just after the call netif_receive_skb(skb).
> 
> Reordering the lines solves the issue.
> 
> [...]

Here is the summary with links:
  - [net,1/9] can: pch_can: pch_can_rx_normal: fix use after free
    https://git.kernel.org/netdev/net/c/94cddf1e9227
  - [net,2/9] can: sja1000: fix use after free in ems_pcmcia_add_card()
    https://git.kernel.org/netdev/net/c/3ec6ca6b1a8e
  - [net,3/9] can: m_can: Disable and ignore ELO interrupt
    https://git.kernel.org/netdev/net/c/f58ac1adc76b
  - [net,4/9] can: m_can: m_can_read_fifo: fix memory leak in error branch
    https://git.kernel.org/netdev/net/c/31cb32a590d6
  - [net,5/9] can: m_can: pci: fix iomap_read_fifo() and iomap_write_fifo()
    https://git.kernel.org/netdev/net/c/d737de2d7cc3
  - [net,6/9] can: m_can: pci: fix incorrect reference clock rate
    https://git.kernel.org/netdev/net/c/8c03b8bff765
  - [net,7/9] Revert "can: m_can: remove support for custom bit timing"
    https://git.kernel.org/netdev/net/c/ea768b2ffec6
  - [net,8/9] can: m_can: make custom bittiming fields const
    https://git.kernel.org/netdev/net/c/ea22ba40debe
  - [net,9/9] can: m_can: pci: use custom bit timings for Elkhart Lake
    https://git.kernel.org/netdev/net/c/ea4c1787685d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


