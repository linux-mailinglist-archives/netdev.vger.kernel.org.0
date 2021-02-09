Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065E1315726
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhBITrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:47:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:55520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233465AbhBITkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 14:40:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7256064E7D;
        Tue,  9 Feb 2021 19:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612899608;
        bh=GYh9ZNQPzRNcxCVq/BL7td6/nX51t11yEMQyl5LTtkA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c+BhAOWXQDxQZ4KYEYU0dnrxmrGgq8rmwQ1pM5GcefDEaMZEQ4Ni5TtV36kw25Tdt
         y9HKqQnJ6yrIv5rjOxtRsvZyidJyTchtA/2BDhI+U26ZIQrycvvr/AkLwPg5eIg8xq
         LHnW2yRw60hXDfILrSe+DrzpJhFQJ92AIrRHD2gB5Db0Z/S1hlWcnS8J1zW+4t9Vnj
         4e4DZmkHyGhPd7aU8/kFLJlRQlSoqBYBpcesBYNocNRpVt/ABVaCe7oKG/+p1u1NpM
         49X6/DAHMhRIPOj887xr8kQ3J8V5TGdm7oDhs0iVBhyMAz4SR4XPG6F4RtDkxkyXPR
         ATqDmfsKfYXxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 604BB60974;
        Tue,  9 Feb 2021 19:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/4] xfrm: interface: enable TSO on xfrm interfaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161289960838.17865.2730121968590897635.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 19:40:08 +0000
References: <20210209094305.3529418-2-steffen.klassert@secunet.com>
In-Reply-To: <20210209094305.3529418-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 9 Feb 2021 10:43:02 +0100 you wrote:
> From: Eyal Birger <eyal.birger@gmail.com>
> 
> Underlying xfrm output supports gso packets.
> Declare support in hw_features and adapt the xmit MTU check to pass GSO
> packets.
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> [...]

Here is the summary with links:
  - [1/4] xfrm: interface: enable TSO on xfrm interfaces
    https://git.kernel.org/netdev/net-next/c/18f976960bca
  - [2/4] net: Simplify the calculation of variables
    https://git.kernel.org/netdev/net-next/c/0c87b1ac6045
  - [3/4] esp: Simplify the calculation of variables
    https://git.kernel.org/netdev/net-next/c/bf3da527bbc9
  - [4/4] xfrm: Return the correct errno code
    https://git.kernel.org/netdev/net-next/c/4ac7a6eecbec

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


