Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70230386BD7
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244615AbhEQVBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236014AbhEQVB1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 17:01:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8404461354;
        Mon, 17 May 2021 21:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621285210;
        bh=gSHAdWQ10jgeC4pFoDRAKwiuFVbfyYRgM9DUofxx7/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I+4Dn+xw7XJCP7UDfK3XLzuJ2mVoqQTi8MbZxiqiCsHgKpS2CipM3IKkH+KqbOIOi
         tGBiBWtCWwNaVV5YrdB4irEAMDT2Jld5DAKpH/JaNvJMppw5iYlZfostAqDlPmLCLI
         CIOZp+8eQ5NDRGQYqYWviZgn5FhW4bZpTRLFiLI/zeGr3UqKhIuJEdQEeoa7AtiHWq
         /u3H0ukl1SWW9o/DsjA0sKyjj4ZGP3BQ+HWKNmoTYkIzZYgDrxmUpSsA8ywgCpyGQa
         r+yo9sBQjTrQn6YuT9LjPuQmIiMg2nb22m+KtF5mDfMkNXhI7BOWkaywJqpCk/7vzW
         053LQsBBCVknA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7EA0D60A47;
        Mon, 17 May 2021 21:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH net-next 0/2] Treat IPv4 lowest address as ordinary
 unicast address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162128521051.2358.9331634734737426572.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 21:00:10 +0000
References: <20210513043625.GL1047389@frotz.zork.net>
In-Reply-To: <20210513043625.GL1047389@frotz.zork.net>
To:     Seth David Schoen <schoen@loyalty.org>
Cc:     netdev@vger.kernel.org, gnu@toad.com, dave.taht@gmail.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 12 May 2021 21:36:25 -0700 you wrote:
> Treat the lowest address in a subnet (the address within the subnet
> which contains all 0 bits) as an ordinary unicast address instead
> of as a potential second broadcast address.  For example, in subnet
> 192.168.17.24/29, which contains 8 addresses, make address 192.168.17.24
> usable as a normal unicast address (while continuing to support
> 192.168.17.31 as a broadcast address).
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,1/2] ip: Treat IPv4 segment's lowest address as unicast
    https://git.kernel.org/netdev/net-next/c/94c821c74bf5
  - [RESEND,net-next,2/2] selftests: Lowest IPv4 address in a subnet is valid
    https://git.kernel.org/netdev/net-next/c/6101ca0384e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


