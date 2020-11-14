Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A422C2B2A07
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgKNAkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgKNAkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 19:40:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605314405;
        bh=xAg9nuWRDww5yEWzkrEMowKkStHRVPFNcyOOq3vc5i8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bNlcny4V0YjrgOHdmzCWD17HCxawZwc2xO7xT+fhJnoHRDVC15M1C/sxrwxAZKQBi
         1pM6f6o6ufU26Ry8jNxEdvESaTyt5P5UktKYNj/DwrcpMQ5TmN3SN8smsJNdOPSnSI
         5Hsu5dxvrYCBp3AG949ZE9nZoeTW3flCxESBrQmg=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: stmmac: platform: use optional clk/reset
 get APIs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160531440558.7757.14538401894553749571.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Nov 2020 00:40:05 +0000
References: <20201112092606.5173aa6f@xhacker.debian>
In-Reply-To: <20201112092606.5173aa6f@xhacker.debian>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, p.zabel@pengutronix.de,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 12 Nov 2020 09:27:37 +0800 you wrote:
> Use the devm_reset_control_get_optional() and devm_clk_get_optional()
> rather than open coding them.
> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> ---
> Since v1:
>  - keep wrapped as suggested by Jakub
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: stmmac: platform: use optional clk/reset get APIs
    https://git.kernel.org/netdev/net-next/c/bb3222f71b57

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


