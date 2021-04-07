Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC29357704
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 23:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbhDGVkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 17:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233670AbhDGVkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 17:40:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2ADEB61165;
        Wed,  7 Apr 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617831609;
        bh=71crzu6Oy2w99gLpv57xwURV2LYqBBTBQstUISuLFLc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BYZL2i7uvycn1fI+dbFI4/lrbhvVm0ECp2NT8eGM8K4OlxmqotNtcYgBhBUQ1I/9/
         6uXX0gu2ZtKETRATIX6nX7llRGkDDgVp3FskWEXw3LwoX3aL2KAOE/0duF1v4expNW
         rTPngYC5LfeDw0bUJbaBzSB35SpZRECyem2UasTD4kt2qZTVm0eTai199zktu+86lI
         4LAMBgUNWMba1Y0vsTlLtKoHioUUDg1ksO4sBB0sZpGHz9Lx9xyaKGoQWcD+YnDpVT
         NLiEbx9HvvGbcVihlrBT352DdcwQAmsZ8dYcZO7V440jchY2m3qY7rZNKhO1tzvqQi
         PVYgRPOM/qdaw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 193EB609D8;
        Wed,  7 Apr 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] stmmac: intel: Enable SERDES PHY rx clk for PSE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783160909.25121.17977461740067314533.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 21:40:09 +0000
References: <20210406013250.17171-1-weifeng.voon@intel.com>
In-Reply-To: <20210406013250.17171-1-weifeng.voon@intel.com>
To:     Voon@ci.codeaurora.org, Weifeng <weifeng.voon@intel.com>
Cc:     davem@davemloft.net, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joabreu@synopsys.com, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, boon.leong.ong@intel.com,
        vee.khee.wong@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  6 Apr 2021 09:32:50 +0800 you wrote:
> EHL PSE SGMII mode requires to ungate the SERDES PHY rx clk for power up
> sequence and vice versa.
> 
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> ---
> Changes:
>  v1 -> v2
>  -change subject from "net: intel" to "stmmac: intel"
> 
> [...]

Here is the summary with links:
  - [v2,net-next] stmmac: intel: Enable SERDES PHY rx clk for PSE
    https://git.kernel.org/netdev/net-next/c/017d6250ad71

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


