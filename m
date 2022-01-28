Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410EF49FBA8
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349068AbiA1OaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 09:30:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51188 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbiA1OaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E60861E01;
        Fri, 28 Jan 2022 14:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 735D0C340E6;
        Fri, 28 Jan 2022 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643380210;
        bh=zzgUTbKru7JboFcmHQ9V+BrizFopS8lz1g5MEzPE/tA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GL2aWND2pUdNRiakgo0skfdZIrKEflYA4+iqV97dlCUYSGTeEsv6uR99gSMK8/szu
         6eWk0gFm6a4WStz3xCgW24NjItNuVYj3M4McnyGsSImUSyxrCBR0HZbRetueaLcIZA
         2laYs1DBP+CGNkNYYmmEkp/vCVTAtNpRLl3PxDk8E807oFOsEIooFYu+1IYSMxVI5W
         psJqKHRg/XMmt4s4wErORaCD2JAlnzBdqwIwtwXCtl4qpckvoRGXPw9KfgbKD5M2fm
         F1Q0Rkw+XDsw4IHwk5zulwkmW3eqR5lhjPyiO0+JcJ5ngaOwiKyT26R3gQ4BKk4Zg1
         uUhLXuIUipRBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 52F02E5D084;
        Fri, 28 Jan 2022 14:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/1] net: stmmac: dwmac-visconti: Avoid updating hardware
 register for unexpected speed requst
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338021033.15816.13738860195654864475.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 14:30:10 +0000
References: <20220127121714.22915-1-yuji2.ishikawa@toshiba.co.jp>
In-Reply-To: <20220127121714.22915-1-yuji2.ishikawa@toshiba.co.jp>
To:     Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
Cc:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, nobuhiro1.iwamatsu@toshiba.co.jp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Jan 2022 21:17:13 +0900 you wrote:
> Function visconti_eth_fix_mac_speed() should not change a register when an unexpected speed value is passed.
> 
> Yuji Ishikawa (1):
>   net: stmmac: dwmac-visconti: No change to ETHER_CLOCK_SEL for
>     unexpected speed request.
> 
>  drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [1/1] net: stmmac: dwmac-visconti: No change to ETHER_CLOCK_SEL for unexpected speed request.
    https://git.kernel.org/netdev/net/c/928d6fe996f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


