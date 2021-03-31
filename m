Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20DB350A29
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhCaWVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230380AbhCaWUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:20:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 89A2361090;
        Wed, 31 Mar 2021 22:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617229218;
        bh=manWhZhu/NQAbHmtzEDKxvO3sIpDmPpIR4Wb97E++h0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JkU6l4959Uh72ZihQaglWFBFE6/bSkJALLtL/AOfUzSbpa68I0bK1MutdiqZgpXpa
         /k1EyLXkToc8CBCguYRV78RgsqxhsXb4oUtzr07mMl1AvDPa4h7hSuOYU7CZTg8pR+
         0K9X2p0BcRQfKCDZx0uRyascdoggwlNfbazb1Ik5p3/Vg0wvA+tC7bSQtFFNdhqw+r
         +50fgAh0N5TVYXTGhvcue751tNPFJXc/1x9qyV4PPXKFeoUa4+AXWlcbvRUFHQuQ7A
         /Bea1AquyiAL23Y26Lv+fjCoRqwlowPTyOs05InU9E3PUpI1eIYDgt76GOUSnL7c6m
         oqWhd+M/O8HOA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 80633608FD;
        Wed, 31 Mar 2021 22:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: stmmac: enable MTL ECC Error Address Status
 Over-ride by default
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722921852.2890.11864817205968379354.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 22:20:18 +0000
References: <20210331161825.32100-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210331161825.32100-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        vee.khee.wong@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  1 Apr 2021 00:18:25 +0800 you wrote:
> From: Voon Weifeng <weifeng.voon@intel.com>
> 
> Turn on the MEEAO field of MTL_ECC_Control_Register by default.
> 
> As the MTL ECC Error Address Status Over-ride(MEEAO) is set by default,
> the following error address fields will hold the last valid address
> where the error is detected.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: stmmac: enable MTL ECC Error Address Status Over-ride by default
    https://git.kernel.org/netdev/net-next/c/b494ba5a3cf8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


