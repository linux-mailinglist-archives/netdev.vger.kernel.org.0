Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4EEE410BB3
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 15:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhISNLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 09:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229824AbhISNLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 09:11:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EA3136127A;
        Sun, 19 Sep 2021 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632057007;
        bh=GsmDGuPnsB11Q7aTkunZZTCkdpVlkA/FCh7xgnfJxZA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jRZD7lbtZotBKVWRBWkqZtXwxl/je5mZIKpj+uNmvSAJcGorNomt84r5Pe7qEuYkk
         SZht5LvKz9dzCWX97OYpzAwQWZNhx7lXj7l67u3EUcj+EJM2kap0n1WwooJkBaLj2a
         L3oec0pdQ6o2Nues46WY1MaDGawJureg4Imhi+EO+UTpFuXXfX7FUEKKY1T4+hek1f
         tTyBXftycYrxbpp/3hzuvzQ8BKdHbHUWxV6LN4Gz6Nj17949LTwOJE1FjorbVfBoYe
         eioZlBS+a9xH4Wv0zyYxItSI32uc7uiTuiDECmeNk0fWwiHojAAUFonyIyZTng8IBD
         YbbPQ4nzEklKg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DA33860A2A;
        Sun, 19 Sep 2021 13:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] octeontx2-af: verify CQ context updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205700688.29079.17551015849615589599.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 13:10:06 +0000
References: <20210917131024.19352-1-hkelam@marvell.com>
In-Reply-To: <20210917131024.19352-1-hkelam@marvell.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 17 Sep 2021 18:40:24 +0530 you wrote:
> As per HW errata AQ modification to CQ could be discarded on heavy
> traffic. This patch implements workaround for the same after each
> CQ write by AQ check whether the requested fields (except those
> which HW can update eg: avg_level) are properly updated or not.
> 
> If CQ context is not updated then perform AQ write again.
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-af: verify CQ context updates
    https://git.kernel.org/netdev/net-next/c/14e94f9445a9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


