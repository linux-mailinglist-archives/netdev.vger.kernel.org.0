Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1B639C2EF
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhFDVv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230128AbhFDVvv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 17:51:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C554161415;
        Fri,  4 Jun 2021 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622843404;
        bh=wEGISPwpp3pYI5B6deH40LEMJDeq72dbo/qap1ROPiU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=idgU3/OsrjNCFhH8yC3wNfS8RrA2ooORTrOWmyGjPpJJLV6jvZXgZIuM4uKIQpcZL
         5YyBhwz9e/AzpqRmTv1kwxIa6MgiNh+n0YG7gmPGIXiGwesUYhCshdZLMnvGRFde7Z
         tLOwUqW0aCAuqMf8+aNW9smHeLoB6BjssZmkePheM6sdMB+IvaoWNpUu7VKOjs7lTB
         H+wGHOYE7dBLehTPFrrxdwLmFsVXq58/wHbSulNz4LmIUwMe4F6VxmCZfnsH1aAsjC
         sQAZfQ/5YVJ6NaN8TYmnC5XnB3yVs6xXXndVI9O8gMh6Iq2Z91bZ5uYB2/D+LSctQ9
         BPWidwJSR/9NQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BB5E160CD2;
        Fri,  4 Jun 2021 21:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: mrp: Update ring transitions.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162284340476.5449.16639869522186820582.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Jun 2021 21:50:04 +0000
References: <20210604103747.3824212-1-horatiu.vultur@microchip.com>
In-Reply-To: <20210604103747.3824212-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, UNGLinuxDriver@microchip.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 4 Jun 2021 12:37:47 +0200 you wrote:
> According to the standard IEC 62439-2, the number of transitions needs
> to be counted for each transition 'between' ring state open and ring
> state closed and not from open state to closed state.
> 
> Therefore fix this for both ring and interconnect ring.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: mrp: Update ring transitions.
    https://git.kernel.org/netdev/net-next/c/fcb34635854a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


