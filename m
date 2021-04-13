Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664E135E8CF
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348576AbhDMWKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231648AbhDMWKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 18:10:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D606861249;
        Tue, 13 Apr 2021 22:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618351810;
        bh=FSLHKB18JSSgjogb29XxS0VuBaUCWkBk7hZ8VUgrRkg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BPw910v5yOEtt9nWt01ryGQB7wRe8IBSuf6TxfvpyriWcV6iWe43QvbtkOoniZ4Wl
         9JLgpGfmt+j1IVjXxN6txmlpUXOEQ3anpj5Qkc2Px1QZuLx8FeOgGpZvqzkLjGyvFa
         Oh7Zd2pzDvadK0Kx4TB4VpR6dVYKvAazmetMp4iYeQTNmIhEUcPAfrEE+ZCjR/vrcs
         uqwAVAEwYxG2zJa3o90eFRnKgwXJqb3NdpWcAyCZ/Y+675nUWoAPbQqlz0awTGB2tT
         vuSLVU77+Z+VZvrGI1Z4IkxDC+75PzqfrOf7SKnyIgGEHeAFTMzeZ+8rkhffc8sAQ3
         aYQa94FH4k2DA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CE1BC60CCF;
        Tue, 13 Apr 2021 22:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/7] stmmac: add XDP ZC support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835181083.31494.7438008757120147305.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 22:10:10 +0000
References: <20210413093626.3447-1-boon.leong.ong@intel.com>
In-Reply-To: <20210413093626.3447-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, alexandre.torgue@foss.st.com,
        mcoquelin.stm32@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 13 Apr 2021 17:36:19 +0800 you wrote:
> Hi,
> 
> This is the v2 patch series to add XDP ZC support to stmmac driver.
> 
> Summary of v2 patch change:-
> 
> 6/7: fix synchronize_rcu() is called stmmac_disable_all_queues() that is
>      used by ndo_setup_tc().
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/7] net: stmmac: rearrange RX buffer allocation and free functions
    https://git.kernel.org/netdev/net-next/c/4298255f26fa
  - [net-next,v2,2/7] net: stmmac: introduce dma_recycle_rx_skbufs for stmmac_reinit_rx_buffers
    https://git.kernel.org/netdev/net-next/c/80f573c995fc
  - [net-next,v2,3/7] net: stmmac: refactor stmmac_init_rx_buffers for stmmac_reinit_rx_buffers
    https://git.kernel.org/netdev/net-next/c/da5ec7f22a0f
  - [net-next,v2,4/7] net: stmmac: rearrange RX and TX desc init into per-queue basis
    https://git.kernel.org/netdev/net-next/c/de0b90e52a11
  - [net-next,v2,5/7] net: stmmac: Refactor __stmmac_xdp_run_prog for XDP ZC
    https://git.kernel.org/netdev/net-next/c/bba71cac680f
  - [net-next,v2,6/7] net: stmmac: Enable RX via AF_XDP zero-copy
    https://git.kernel.org/netdev/net-next/c/bba2556efad6
  - [net-next,v2,7/7] net: stmmac: Add TX via XDP zero-copy socket
    https://git.kernel.org/netdev/net-next/c/132c32ee5bc0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


