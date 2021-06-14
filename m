Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EC23A6F45
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbhFNTmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234280AbhFNTmG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:42:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AD95761185;
        Mon, 14 Jun 2021 19:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623699603;
        bh=V0+zvvuQEvR0FvNctCho6EV9BV9t+fFhEhlfXym9zFM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tdygEU5gJOARpwxEPguUT1HXvzP7i1592tc4nXHJ3tQe5VfrIzXjEr4EZSbR6t5oU
         dqd1MKqXjm6cAM7Bd6iZwChzeFkhluXSzi2BLwYxZT1MHz43Xch88pPY3R0xEiE7Xn
         /qHfGgfLlr3b/yeTi0fKr1Smf0czQXb1EveO3PYRypGJjVdr5gwU8S/VgBMohE0sO/
         Lhk7OUKKwyydLQeExtPuNebnRfmtW6VCcwA3Swe7z8GoY5rGmcYrdlD5vzkL2gn5tG
         zKhM2l+7NG6A5OB2+LwPZgFchgZF8LvLzHOWznzlS5w7oZju27A1yKM9mzqEkkK2Cs
         pdZ+l5wtY6O6w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9B53C609D8;
        Mon, 14 Jun 2021 19:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv4: Fix device used for dst_alloc with local routes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162369960363.4485.4512356875648220527.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 19:40:03 +0000
References: <20210613002500.63438-1-dsahern@kernel.org>
In-Reply-To: <20210613002500.63438-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        oliver.peter.herms@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 12 Jun 2021 18:24:59 -0600 you wrote:
> Oliver reported a use case where deleting a VRF device can hang
> waiting for the refcnt to drop to 0. The root cause is that the dst
> is allocated against the VRF device but cached on the loopback
> device.
> 
> The use case (added to the selftests) has an implicit VRF crossing
> due to the ordering of the FIB rules (lookup local is before the
> l3mdev rule, but the problem occurs even if the FIB rules are
> re-ordered with local after l3mdev because the VRF table does not
> have a default route to terminate the lookup). The end result is
> is that the FIB lookup returns the loopback device as the nexthop,
> but the ingress device is in a VRF. The mismatch causes the dst
> alloc against the VRF device but then cached on the loopback.
> 
> [...]

Here is the summary with links:
  - [net] ipv4: Fix device used for dst_alloc with local routes
    https://git.kernel.org/netdev/net/c/b87b04f5019e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


