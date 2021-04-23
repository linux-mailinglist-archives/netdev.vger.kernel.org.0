Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17176369B4F
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 22:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243969AbhDWUav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 16:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232200AbhDWUaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 16:30:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9AD7261458;
        Fri, 23 Apr 2021 20:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619209809;
        bh=aoqS7P/8ZfPna4brzERZq7nuNJe7PM/uvZLtCVYSgIs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q8U8bo13x8A4FLvULOykwygE6ccVEJHfHjL8Z7Rq3xbLslzBCqGh/6go2Rfq91Lwq
         aR+W5fbJC7bsb9cV+z4BvlD0amXjYeUJfI/xs/j7pP1bm/Zx+Ru/RiM/wrzhB4JbLy
         TurjGfgk/SILL0nH4YikaNZXMkC9Y+BIQoLZq1Gda4FvblMh6kB99VSWwNbOQ/CGfY
         1rA0D79aZtnt0WHlH8oP+9EgRadk1rvoEDzz+SEhcdQTnREGyn1KUvp5a8JtkWKmT9
         7LFnE8l3DWHc+3wKtlP3/mVTCDukWDTChS+8UfHo7qObqw3k8CKn/Z8+Z6lhaXxhqf
         vjIjqksC1N0Jg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9432060A53;
        Fri, 23 Apr 2021 20:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mana: Use int to check the return value of
 mana_gd_poll_cq()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161920980960.7001.3474811538584488537.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 20:30:09 +0000
References: <20210422200816.11100-1-decui@microsoft.com>
In-Reply-To: <20210422200816.11100-1-decui@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sthemmin@microsoft.com, wei.liu@kernel.org, liuwe@microsoft.com,
        netdev@vger.kernel.org, dan.carpenter@oracle.com,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Apr 2021 13:08:16 -0700 you wrote:
> mana_gd_poll_cq() may return -1 if an overflow error is detected (this
> should never happen unless there is a bug in the driver or the hardware).
> 
> Fix the type of the variable "comp_read" by using int rather than u32.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mana: Use int to check the return value of mana_gd_poll_cq()
    https://git.kernel.org/netdev/net-next/c/d90a94680bc0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


