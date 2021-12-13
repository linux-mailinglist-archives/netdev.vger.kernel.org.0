Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF30A472C4A
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 13:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbhLMMaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 07:30:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40702 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbhLMMaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 07:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CBF8B80D95;
        Mon, 13 Dec 2021 12:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60A48C34603;
        Mon, 13 Dec 2021 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639398609;
        bh=9eGLtXiu5M4VNtcNibnrFxohOc50ULA+g7RYgEmpgXc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q8mvooINToLmsou5RUA1XWJAxG/rQZQ4RvnuNdqiy7VJuty+Bo3SU+ivTRf/+IuFX
         Ncf4gA7k7hBhstYM325rqs4vYa9fJI7HVaH/gSFabuFwQXu9bnZDjl4UGwdRto+3ka
         KE884T4GsM4Y4Pebk9b1U3I/AOTbf8xRTXJJqGqw/OheWZ5cRV+i3/O23KyGeySszL
         EP5mdT0atCq2uk4t8nIBaFDqQyzPWYoKQ3mT94igAjJztPKGpPEaIjMcNA5pHjcdN2
         w2DZr78xJF/SUUPSDv3EhyOw9F6vswzB+nFETUguZs8Fwks+8K9iIbVyNa3eY7ZJLO
         DcdG+7oi9uoaw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 42E6D609D6;
        Mon, 13 Dec 2021 12:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: bump tc when get underflow error from
 DMA descriptor
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163939860926.21128.12756625004904393893.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 12:30:09 +0000
References: <20211208100651.19369-1-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20211208100651.19369-1-xiaoliang.yang_1@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        qiangqing.zhang@nxp.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        yannick.vignon@nxp.com, boon.leong.ong@intel.com,
        Jose.Abreu@synopsys.com, mst@redhat.com, sonic.zhang@analog.com,
        Joao.Pinto@synopsys.com, mingkai.hu@nxp.com, leoyang.li@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  8 Dec 2021 18:06:51 +0800 you wrote:
> In DMA threshold mode, frame underflow errors may sometimes occur when
> the TC(threshold control) value is not enough. The TC value need to be
> bumped up in this case.
> 
> There is no underflow interrupt bit on DMA_CH(#i)_Status of dwmac4, so
> the DMA threshold cannot be bumped up in stmmac_dma_interrupt(). The
> i.mx8mp board observed an underflow error while running NFS boot, the
> NFS rootfs could not be mounted.
> 
> [...]

Here is the summary with links:
  - [net-next] net: stmmac: bump tc when get underflow error from DMA descriptor
    https://git.kernel.org/netdev/net-next/c/3a6c12a0c6c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


