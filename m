Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561D82AA88D
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 01:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgKHAUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 19:20:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgKHAUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 19:20:04 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604794804;
        bh=VrFPOva6ikR5xt+0caMzsE0TfHfCkHNpLJdyh/JG3pI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=0HmQTEeCv2ziNYxuqrYU2UrNJDDXbn4b3k6yIeCWPlPtTCZu8l3J78z1rt10bIgWP
         dVwEzO5egm4qEw9DBvgXUVLEMhuqZFPhuXiQCxfLnrorKvXjBQ99NVgo8hFISQE3lB
         hmUCQWZTHLFzzIzKg98L02vCmtA46gtZopjOsLb8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] stmmac: intel: change all EHL/TGL to auto detect
 phy addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160479480419.12285.2221862141442440852.git-patchwork-notify@kernel.org>
Date:   Sun, 08 Nov 2020 00:20:04 +0000
References: <20201106094341.4241-1-vee.khee.wong@intel.com>
In-Reply-To: <20201106094341.4241-1-vee.khee.wong@intel.com>
To:     Wong Vee Khee <vee.khee.wong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  6 Nov 2020 17:43:41 +0800 you wrote:
> From: Voon Weifeng <weifeng.voon@intel.com>
> 
> Set all EHL/TGL phy_addr to -1 so that the driver will automatically
> detect it at run-time by probing all the possible 32 addresses.
> 
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] stmmac: intel: change all EHL/TGL to auto detect phy addr
    https://git.kernel.org/netdev/net-next/c/bff6f1db91e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


