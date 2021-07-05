Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB35D3BC236
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 19:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhGERWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 13:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229693AbhGERWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 13:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CDB9C6196C;
        Mon,  5 Jul 2021 17:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625505603;
        bh=Kdm1QRA1v5jpFpHW2SlQG+K4nJeQ/1fZZM9yGGKe6lw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZZR4oEAWlOS7sY1Ot72plRxmYtSYA0xOiqrjnMMotM5eLSgDWFbqRbGfwZ/X/uMqM
         Ka8s30NIy1uAQFMPk7+oSGrKobHA8I+QbKgZmh16yyXVfAfEx0HRsq5uc0ZuZL5sqt
         vZqRJNUYZ/z2RE18ilwSo03RxcTUPppsFDhs/FOzDtm5ljy5lsd1xQKi8YoVBiEufU
         qFyfQbTaJYkt4lOUCwX8ki4RCV/zfWkXpk7WWV/uXeRJDSMPHz22y+zABlk9qjyu3M
         8h5VB8X7zsC/VOCPnMw/zWug0gBoOctzYjJLLPOv7OFw7RRWKiG7KQV/0twnXQ/u9E
         TbeGO3/SwH0gg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BB2A1609EF;
        Mon,  5 Jul 2021 17:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/3] net: stmmac: re-configure tas basetime after
 ptp time adjust
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162550560376.14411.831006675509469053.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Jul 2021 17:20:03 +0000
References: <20210705102655.6280-1-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210705102655.6280-1-xiaoliang.yang_1@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, joabreu@synopsys.com, kuba@kernel.org,
        alexandre.torgue@st.com, peppe.cavallaro@st.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com,
        vee.khee.wong@intel.com, tee.min.tan@intel.com,
        mohammad.athari.ismail@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        leoyang.li@nxp.com, qiangqing.zhang@nxp.com, rui.sousa@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon,  5 Jul 2021 18:26:52 +0800 you wrote:
> If the DWMAC Ethernet device has already set the Qbv EST configuration
> before using ptp to synchronize the time adjustment, the Qbv base time
> may change to be the past time of the new current time. This is not
> allowed by hardware.
> 
> This patch calculates and re-configures the Qbv basetime after ptp time
> adjustment.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/3] net: stmmac: separate the tas basetime calculation function
    https://git.kernel.org/netdev/net/c/81c52c42afd9
  - [v2,net-next,2/3] net: stmmac: add mutex lock to protect est parameters
    https://git.kernel.org/netdev/net/c/b2aae654a479
  - [v2,net-next,3/3] net: stmmac: ptp: update tas basetime after ptp adjust
    https://git.kernel.org/netdev/net/c/e9e3720002f6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


