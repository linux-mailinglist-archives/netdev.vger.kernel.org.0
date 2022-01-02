Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6FA482B07
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 13:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiABMUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 07:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiABMUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 07:20:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD32C061574
        for <netdev@vger.kernel.org>; Sun,  2 Jan 2022 04:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96AD960E8F
        for <netdev@vger.kernel.org>; Sun,  2 Jan 2022 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 056E4C36AF5;
        Sun,  2 Jan 2022 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641126011;
        bh=DLg1Mf6ItR1QtI7JXxDhAhn90Tnps9O/ZUq+74toKKk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ROELZnEx8KgEtGGEIRiF07rcf7Xeuj4pAzWXhnJX1iebE35PwBIsifyF9FFIPX4QQ
         0RHD2yNWzJ37YmudJUf66tljhQ+X3kqTAIZ2SGz92yl9l7NdyOMlKrDhXRuIC3MZvI
         xmx8YNHPaHSbIPWDieobfh9dZozucglr0BLnUEf74yBAg5dgJxh/cGxJ0ce9Iwec3B
         ie7wuWNnTu+TPKWRpq/taPyyZGJLrPSuVBux/pmpLMFq52nEjkazAZ+vlnGME7zy4T
         lImlqYBrG1MuJvEhErBtph09nO0t4HiXQhZnz7QTR9DvYlHjpVMATEtxQireCBzH1s
         wv6FwNzJAh3QQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E582BC395EB;
        Sun,  2 Jan 2022 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] ipv6: ioam: Support for Queue depth data field
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164112601093.23508.16111518599190103199.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 12:20:10 +0000
References: <20211230171004.16368-1-justin.iurman@uliege.be>
In-Reply-To: <20211230171004.16368-1-justin.iurman@uliege.be>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org, idosch@idosch.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Dec 2021 18:10:04 +0100 you wrote:
> v3:
>  - Report 'backlog' (bytes) instead of 'qlen' (number of packets)
> 
> v2:
>  - Fix sparse warning (use rcu_dereference)
> 
> This patch adds support for the queue depth in IOAM trace data fields.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] ipv6: ioam: Support for Queue depth data field
    https://git.kernel.org/netdev/net-next/c/b63c5478e9cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


