Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6466941DADE
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350913AbhI3NVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348765AbhI3NVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 09:21:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1F04B61882;
        Thu, 30 Sep 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633008008;
        bh=0pemjILUKW3P8ap2Jjm3YvSixx5+FFMy1g4WdQOdk4Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h5ay83ItK8/eXeyvw+cL9+XSXxEJ0/fT/PYGAAlvYiI/yD+TWtghCOZGVKZwN/p4O
         PX3sGpYlpnGW6o4JrlphfVOZpZqpLFeOtQwVIz0eftowlBqDJachVxTwkXadg997gI
         1KaHC9S2OG0FlvITSGR8QqHZzao3HPfQQIYVvaM/U65yXrPEj/05CcBRQ2erZ8TjPM
         /C1ecbWwbr5B/iYekkBHTCudpynZnx/6kuQAHL5KhhVmWIC4H437wafuYkxdQAf+Kb
         fdbozgOFCmaJlgEbUGqnd0XWe6IpCt0cA6zY2FKYni6/myU2j3WXAZeDp0/qEbxB7u
         Er3zoR8rGGioA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0E51260A7E;
        Thu, 30 Sep 2021 13:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1 1/1] net: stmmac: fix EEE init issue when paired with
 EEE capable PHYs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300800805.14372.10172640805730469120.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 13:20:08 +0000
References: <20210930064436.1502516-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210930064436.1502516-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        michael.wei.hong.sit@intel.com, veekhee@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 30 Sep 2021 14:44:36 +0800 you wrote:
> When STMMAC is paired with Energy-Efficient Ethernet(EEE) capable PHY,
> and the PHY is advertising EEE by default, we need to enable EEE on the
> xPCS side too, instead of having user to manually trigger the enabling
> config via ethtool.
> 
> Fixed this by adding xpcs_config_eee() call in stmmac_eee_init().
> 
> [...]

Here is the summary with links:
  - [net,v1,1/1] net: stmmac: fix EEE init issue when paired with EEE capable PHYs
    https://git.kernel.org/netdev/net/c/656ed8b015f1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


