Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929902B55A3
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731018AbgKQAUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:20:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgKQAUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 19:20:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605572405;
        bh=25vUk7yO2qnrkC0/w/M4EXstmgZtbuRhKhxNkt5NBJ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d0Aq1m6s6KbrfvkIt5/gkjcbRbQFsG202eztDSmZWDSCxxluHWTnhZbxgd4u2WorZ
         +No9tZ/qzq447y+WabhpteRO49PuWaKc6HI9UmtMgEiA23UmLTNnIhLELQdNCY1Dz1
         YwONCxdll37wtNGchosUuSolgzhRddzqHgFX1I38=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 1/1] net: stmmac: Use rtnl_lock/unlock on
 netif_set_real_num_rx_queues() call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160557240545.2440.6875630063431997815.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Nov 2020 00:20:05 +0000
References: <20201115074210.23605-1-vee.khee.wong@intel.com>
In-Reply-To: <20201115074210.23605-1-vee.khee.wong@intel.com>
To:     Wong Vee Khee <vee.khee.wong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com,
        christophe.roullier@st.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 15 Nov 2020 15:42:10 +0800 you wrote:
> Fix an issue where dump stack is printed on suspend resume flow due to
> netif_set_real_num_rx_queues() is not called with rtnl_lock held().
> 
> Fixes: 686cff3d7022 ("net: stmmac: Fix incorrect location to set real_num_rx|tx_queues")
> Reported-by: Christophe ROULLIER <christophe.roullier@st.com>
> Tested-by: Christophe ROULLIER <christophe.roullier@st.com>
> Cc: Alexandre TORGUE <alexandre.torgue@st.com>
> Reviewed-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
> 
> [...]

Here is the summary with links:
  - [v2,net,1/1] net: stmmac: Use rtnl_lock/unlock on netif_set_real_num_rx_queues() call
    https://git.kernel.org/netdev/net/c/8e5debed3901

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


