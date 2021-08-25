Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080913F741B
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 13:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240109AbhHYLKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 07:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236783AbhHYLKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 07:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A6934610E5;
        Wed, 25 Aug 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629889806;
        bh=drbUEnJsqrU00lvwvDB9o4JaN9qrl49HDQWau9FDYmw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rZn53sOkb16txwTi1WboTEcWaBcWnManLBYeCS1hbh9Iy7KoZ2NzHu2ApMo7QuiV1
         PSsVmJ+dPZT8j4c0ZmLB8nSU83U7PuXcw6rxhe+zoq24v10p+ypglchZkZi8o3mhmL
         gthubYWPVhh3Y9auEbFQatMM95FUEhLzGqpZpQCxGWv9dpY0CQsQPfimAy5fm8qm+P
         dWavLhn15AZdAeYTPAGQ5HAw0yx5Z+0rFV6hpqv3g6Na4w7lwMAz0oNbAoHYlb208M
         cAyIJEDdMpnafDcCa3IloYyrq4qxM0yUsKbfpQ54N+Yg5RXs1vEK3XyUgubfNzBCEs
         hyf+Otgf4BbEg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 967766097B;
        Wed, 25 Aug 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-af: Change the order of queue work and interrupt
 disable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988980661.32654.5737067175350371547.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 11:10:06 +0000
References: <20210825053904.3700-1-gakula@marvell.com>
In-Reply-To: <20210825053904.3700-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, ndabilpuram@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Aug 2021 11:09:04 +0530 you wrote:
> From: Nithin Dabilpuram <ndabilpuram@marvell.com>
> 
> Clear and disable interrupt before queueing work as there might be
> a chance that work gets completed on other core faster and
> interrupt enable as a part of the work completes before
> interrupt disable in the interrupt context. This leads to
> permanent disable of interrupt.
> 
> [...]

Here is the summary with links:
  - octeontx2-af: Change the order of queue work and interrupt disable
    https://git.kernel.org/netdev/net-next/c/906999c9b653

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


