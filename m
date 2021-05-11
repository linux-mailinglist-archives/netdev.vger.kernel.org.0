Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E8237B209
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhEKXBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhEKXBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 19:01:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 542F361285;
        Tue, 11 May 2021 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620774009;
        bh=2gBzngve8CFKsmMPBEpKRfyOOfRBVzwqxkzGpzHMg+g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V46q5AwpZ8l93x6PWr6XLw0PlL/osjAC3Fzrq2n9qwnswZgOqX5sWbS+4SBiMT7x8
         6fGaZFhafcqtOpJ4oOdcxhxYkisDLsK6+7geqBPga/kslX1VvsK5HhzbnU9fb2TGdi
         ju7LOwwPogEXp0QCu64JxuY9FIaQfiU7OX9/89xBtRen8mivyXrXzB7fqr6CZMeSli
         NcBO7GEUTQNogF2LMbmJ96rYrhAPFSbtOhB4zu2P3q8oZB4isa0oByBHoEVDjzzbWS
         S7PtOoGvL7D2WjatkzuA1k3ebXC8hCkaHA4NmI3tge1JHQAC11dnPVYH+CVjVlob9Z
         1UoWxUxfH0+Ug==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4827C60A71;
        Tue, 11 May 2021 23:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V5 net] net: stmmac: Fix MAC WoL not working if PHY does not
 support WoL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162077400929.5289.11424023848426673687.git-patchwork-notify@kernel.org>
Date:   Tue, 11 May 2021 23:00:09 +0000
References: <20210510065509.27923-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210510065509.27923-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, Jisheng.Zhang@synaptics.com,
        netdev@vger.kernel.org, linux-imx@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 10 May 2021 14:55:09 +0800 you wrote:
> Both get and set WoL will check device_can_wakeup(), if MAC supports PMT, it
> will set device wakeup capability. After commit 1d8e5b0f3f2c ("net: stmmac:
> Support WOL with phy"), device wakeup capability will be overwrite in
> stmmac_init_phy() according to phy's Wol feature. If phy doesn't support WoL,
> then MAC will lose wakeup capability. To fix this issue, only overwrite device
> wakeup capability when MAC doesn't support PMT.
> 
> [...]

Here is the summary with links:
  - [V5,net] net: stmmac: Fix MAC WoL not working if PHY does not support WoL
    https://git.kernel.org/netdev/net/c/576f9eacc680

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


