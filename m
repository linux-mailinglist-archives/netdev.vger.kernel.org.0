Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847614194B4
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 15:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhI0NBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 09:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234396AbhI0NBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 09:01:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DFD9061052;
        Mon, 27 Sep 2021 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632747607;
        bh=rE68U+DkEgkEMRQCsiTxDWOf9HqvdtdTE2PMw/ic4yo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=COsx+imQ/qvSGVrro5eFCOOQy2+5H/c7ynX+cmMS6+2TMr3MYjIzhXCFofWSTPaad
         vjgsTmi5uVK25Ow9m1eDIYnWc9L1qZIBEUrjXfDa84+DPy9g4g+czNuJx/wSU8EKle
         hHW/NtjOUlh82FZb4nxmwUn29KABptpri0/ZnRB5AbrQrNWOJq4cpgVobL4e2Ryvcr
         t27T17fmsykSb4fjmh8huK7JQF4jaFWpsIulYhnt3Fd/5OMhX9na+4BhkzdPw9PLXM
         NJPMObBpbe3FpXu6+u21lB3b65BaZaQbZamayMCTEbGPqAzMtOWaTlkmzmNYx7VWiH
         vM04lWBtNsApA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D073E60A3E;
        Mon, 27 Sep 2021 13:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [RESEND] net: stmmac: fix gcc-10 -Wrestrict warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274760784.15607.6413113526637884251.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 13:00:07 +0000
References: <20210927100336.1334028-1-arnd@kernel.org>
In-Reply-To: <20210927100336.1334028-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        weifeng.voon@intel.com, boon.leong.ong@intel.com, arnd@arndb.de,
        lkp@intel.com, dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 27 Sep 2021 12:02:44 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc-10 and later warn about a theoretical array overrun when
> accessing priv->int_name_rx_irq[i] with an out of bounds value
> of 'i':
> 
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function 'stmmac_request_irq_multi_msi':
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3528:17: error: 'snprintf' argument 4 may overlap destination object 'dev' [-Werror=restrict]
>  3528 |                 snprintf(int_name, int_name_len, "%s:%s-%d", dev->name, "tx", i);
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3404:60: note: destination object referenced by 'restrict'-qualified argument 1 was declared here
>  3404 | static int stmmac_request_irq_multi_msi(struct net_device *dev)
>       |                                         ~~~~~~~~~~~~~~~~~~~^~~
> 
> [...]

Here is the summary with links:
  - [RESEND] net: stmmac: fix gcc-10 -Wrestrict warning
    https://git.kernel.org/netdev/net-next/c/3e0d5699a975

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


