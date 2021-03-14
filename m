Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF5633A253
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 03:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbhCNCKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 21:10:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232431AbhCNCKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Mar 2021 21:10:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3172164ECE;
        Sun, 14 Mar 2021 02:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615687808;
        bh=0Ltd7ABkEJ0W33cjVaYlQ82uDAkSeGqOj0zFiXfcTiE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DydDAzGhv+0c/LPxfjj0onV1wv89NX3A2uMl46wCMjOSLFE50vMQUwjkQ0uYIWZZK
         yPEjRb/nbNguagrNptYDDkyMShMjegpedrxj0SfTOVYEvvvYvocZdVDLTvarvTACL2
         krDBIYiaLTXnw0hsS0Qrmz75281zhaX8KovxHDf6IbWAvATWu196T4zRxHFLip/ToX
         wx1JtsWcFMkEJ1nMmd6URJ4DF/G4HKlPPnNj5Y65c3aTV5aXBDlGUxr+an6bEpf2vE
         GDNWvb7nYwz1DTPAy5ZUH6v6E8WgIzAqNpSjaih2F9OToCNVWfxj/1uOz/l3DBBqk/
         YXhCB8w2KrZJQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 21F7760A6A;
        Sun, 14 Mar 2021 02:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: Set FIFO sizes for ipq806x
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161568780813.10930.14410536335791157714.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Mar 2021 02:10:08 +0000
References: <20210313131826.GA17553@earth.li>
In-Reply-To: <20210313131826.GA17553@earth.li>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 13 Mar 2021 13:18:26 +0000 you wrote:
> Commit eaf4fac47807 ("net: stmmac: Do not accept invalid MTU values")
> started using the TX FIFO size to verify what counts as a valid MTU
> request for the stmmac driver.  This is unset for the ipq806x variant.
> Looking at older patches for this it seems the RX + TXs buffers can be
> up to 8k, so set appropriately.
> 
> (I sent this as an RFC patch in June last year, but received no replies.
> I've been running with this on my hardware (a MikroTik RB3011) since
> then with larger MTUs to support both the internal qca8k switch and
> VLANs with no problems. Without the patch it's impossible to set the
> larger MTU required to support this.)
> 
> [...]

Here is the summary with links:
  - [net-next] net: stmmac: Set FIFO sizes for ipq806x
    https://git.kernel.org/netdev/net-next/c/e127906b68b4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


