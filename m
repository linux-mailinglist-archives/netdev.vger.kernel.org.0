Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C139A2B318A
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 01:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgKOAKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 19:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgKOAKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 19:10:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605399004;
        bh=uUKVVimvuZudJEMDjKpPdA9M2QalJ+mdThNBWwucmdw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OSXvUaYcXiW89UaUavuc2MFpCvyfCpo1TbCCeTCY5PZ7VCFnoUdd7o1y9xH125Gv3
         4RIgb6DNdpxHb55o3JQ6K4LowC92OXL/M4tMrOozPB/BtuuvLP/CUwca7PYHZXGgbR
         loaQsCsIs0YgGmjIVPOjEd5R5v3V+xfgJTA39sZ8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: dwmac_lib: enlarge dma reset timeout
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160539900468.21843.5491714824652750943.git-patchwork-notify@kernel.org>
Date:   Sun, 15 Nov 2020 00:10:04 +0000
References: <20201113090902.5c7aab1a@xhacker.debian>
In-Reply-To: <20201113090902.5c7aab1a@xhacker.debian>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 13 Nov 2020 09:09:02 +0800 you wrote:
> If the phy enables power saving technology, the dwmac's software reset
> needs more time to complete, enlarge dma reset timeout to 200000us.
> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: stmmac: dwmac_lib: enlarge dma reset timeout
    https://git.kernel.org/netdev/net/c/56311a315da7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


