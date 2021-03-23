Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D99346B5D
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 22:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbhCWVuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 17:50:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233645AbhCWVuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 17:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A8690619B3;
        Tue, 23 Mar 2021 21:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616536208;
        bh=LUEaRCP6eNioqAWV9oLNRy9ysDa7RpWX9hgu0PfbMmE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sfgMkn3CbZfanNryaiFrawFYiHXNmCp46/v+GgHmNNqxz0aElvRB9DZZdS4BUCTyy
         E6M3Aj8e3f7SKcJFTxniD/RQMoiuo29w9Nr6/xpQoJ4jXrRpptTX3tR/SwBS5Dxnoi
         RS+OlXDqA+wBp4KG8jIlYzJp7Nnkg6H2tnjbBY1++fnyDIduxpTjhNLmeEnH5fwJ95
         Y7GosZtM360C4hxfydDqss3WEamHPz8scM8IjEdU5Bz45cMJoZ9xzcArreUO/bgwNv
         bkOL2dgal5S9yxhykUDaWsmd/j676GxIwnW7w/CN1BN47NT0e1Vxyj29Slh/BC8qUU
         l939RfDRdpNbA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9B57B6096E;
        Tue, 23 Mar 2021 21:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bridge: don't notify switchdev for local FDB
 addresses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161653620863.18437.15979008122969485775.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Mar 2021 21:50:08 +0000
References: <20210322182108.4121827-1-olteanv@gmail.com>
In-Reply-To: <20210322182108.4121827-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        tobias@waldekranz.com, netdev@vger.kernel.org, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@resnulli.us, idosch@idosch.org,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 22 Mar 2021 20:21:08 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As explained in this discussion:
> https://lore.kernel.org/netdev/20210117193009.io3nungdwuzmo5f7@skbuf/
> 
> the switchdev notifiers for FDB entries managed to have a zero-day bug.
> The bridge would not say that this entry is local:
> 
> [...]

Here is the summary with links:
  - [net] net: bridge: don't notify switchdev for local FDB addresses
    https://git.kernel.org/netdev/net/c/6ab4c3117aec

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


