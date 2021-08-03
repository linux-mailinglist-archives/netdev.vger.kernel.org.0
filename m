Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BBD3DF703
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhHCVkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232844AbhHCVkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 17:40:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B25E61100;
        Tue,  3 Aug 2021 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628026806;
        bh=HSjp7yTfMWSo9/m1hJfmmC8BGuirWnw6EQI7FTh6pEs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mOB5Q5w+z/9ybQugkcsUY8cOW0Z1G/NW4j2vNzu3XQYLBtOHk985RWvmuruHyg97D
         wsMN/qvlC6jhTngfO9ZTtfP182PVQyAIIHcoD0K6Vj10ryexoVT1BvZa3Ur8FeZ2FL
         nu3QqFvSnR3C+G+QtUHVZUCJoVxWpIK+yZUU+/SgMZhkn9sYS1j4DWHb3/H27cYUSZ
         FeLDOezR0epEQDEEmz0pB3cdJ1oiDxAJsahd0iXJbpYVKc3jlwivTwh08qWNG94xHb
         JOAv5smT3ohBrL1P25oq5oyDfuUZkTjqyfYL8vXT7W968kOXHbeJNFASAf955ObFVB
         zDW6zef5SFRvg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 73A5460A45;
        Tue,  3 Aug 2021 21:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: switchdev: fix incorrect use of FDB
 flags when picking the dst device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162802680646.18812.7948023061004183994.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 21:40:06 +0000
References: <20210802113633.189831-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210802113633.189831-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        jiri@resnulli.us, idosch@idosch.org, roopa@nvidia.com,
        nikolay@nvidia.com, bridge@lists.linux-foundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  2 Aug 2021 14:36:33 +0300 you wrote:
> Nikolay points out that it is incorrect to assume that it is impossible
> to have an fdb entry with fdb->dst == NULL and the BR_FDB_LOCAL bit in
> fdb->flags not set. This is because there are reader-side places that
> test_bit(BR_FDB_LOCAL, &fdb->flags) without the br->hash_lock, and if
> the updating of the FDB entry happens on another CPU, there are no
> memory barriers at writer or reader side which would ensure that the
> reader sees the updates to both fdb->flags and fdb->dst in the same
> order, i.e. the reader will not see an inconsistent FDB entry.
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: switchdev: fix incorrect use of FDB flags when picking the dst device
    https://git.kernel.org/netdev/net-next/c/2e19bb35ce15

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


