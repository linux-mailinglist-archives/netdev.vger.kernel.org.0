Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2400426CC4
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 16:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241736AbhJHOcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230511AbhJHOcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 30D3261073;
        Fri,  8 Oct 2021 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633703408;
        bh=qfsVNFaHAQWaRIUeU/qMqZpBIZZ4YpOUOHBVkhPOHtk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tn1FWPXonEzy/Xn/bFt1F74NwXs10dhwJ+o012QPloAlxdpkrP3Qe2cvh1EMKvlzS
         9wAww8bQERAoh3X3G3PoFR2Xxy8YuUAbg00CPgDVDNE56yDuAgwhSV/41AtUpNKcRY
         TdDscwrbPCg4zoyepi4I73p2DjKCfeGWV7XF74wTIwcxQ5Ut++/tvu7o3nNDlaegR0
         myeObgtO2fVKqi5zS5f1ck6XNoQHimep9sIwjfI+1zCzna6kM0tez17rfvBK13c0yI
         AEItggInF/3voAUFtmN8UxA0nEjYWi7NNMk1PwFgYndjnFMY5oC33WtUCDK1ioN2+l
         M5uoi5tDzVRCw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1FB7760A44;
        Fri,  8 Oct 2021 14:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: sch_ets: properly init all active DRR
 list handles
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163370340812.9336.2667342606087482562.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 14:30:08 +0000
References: <60d274838bf09777f0371253416e8af71360bc08.1633609148.git.dcaratti@redhat.com>
In-Reply-To: <60d274838bf09777f0371253416e8af71360bc08.1633609148.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Oct 2021 15:05:02 +0200 you wrote:
> leaf classes of ETS qdiscs are served in strict priority or deficit round
> robin (DRR), depending on the value of 'nstrict'. Since this value can be
> changed while traffic is running, we need to be sure that the active list
> of DRR classes can be updated at any time, so:
> 
> 1) call INIT_LIST_HEAD(&alist) on all leaf classes in .init(), before the
>    first packet hits any of them.
> 2) ensure that 'alist' is not overwritten with zeros when a leaf class is
>    no more strict priority nor DRR (i.e. array elements beyond 'nbands').
> 
> [...]

Here is the summary with links:
  - [net-next] net/sched: sch_ets: properly init all active DRR list handles
    https://git.kernel.org/netdev/net-next/c/454d3e1ae057

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


