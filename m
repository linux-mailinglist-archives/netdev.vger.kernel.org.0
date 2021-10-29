Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CB943FCD2
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 15:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhJ2NCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 09:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231367AbhJ2NCf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 09:02:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F0B8660F23;
        Fri, 29 Oct 2021 13:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635512407;
        bh=EjgqJvYcxzTW4ZFSj8a1Nqzq1SYLWuXllXv8KvZGmr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hRWdlxWFL/R3pDTGk9bPc7Q4DdE6CXpvwNgH6qe6iGgDHhvZ/NRzbtbwG151cPySS
         aTypMFFIRdw52+uPB2Er7BI4Ab/zOhFfTlsb9eyMjs27nYyiHHdDO5nXfbeO6eHCwx
         cZBX/CPgedYQqzTInZNhUdrR9o7F538PROmfvOIrKavCUghBKjAcmC/xKn9FQa8p76
         KH7taMk3aD5bE/XXlJ+khY7HyXRlFZM6cNy84lJH2qktVlcS+EOs26FabH9pjspdre
         ffZ9L3ILnuI/5AYn7TydPkEPqLJ3BZL16emUmaMqV+eCDnHVGXP0IPuCRC9otkNSYb
         iMfQfwlEuNIww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E2E9E60A1B;
        Fri, 29 Oct 2021 13:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] selftests: net: bridge: update IGMP/MLD membership
 interval value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163551240692.5054.16014732669098206950.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 13:00:06 +0000
References: <20211029120527.2716884-1-razor@blackwall.org>
In-Reply-To: <20211029120527.2716884-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Oct 2021 15:05:27 +0300 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> When I fixed IGMPv3/MLDv2 to use the bridge's multicast_membership_interval
> value which is chosen by user-space instead of calculating it based on
> multicast_query_interval and multicast_query_response_interval I forgot
> to update the selftests relying on that behaviour. Now we have to
> manually set the expected GMI value to perform the tests correctly and get
> proper results (similar to IGMPv2 behaviour).
> 
> [...]

Here is the summary with links:
  - [net,v2] selftests: net: bridge: update IGMP/MLD membership interval value
    https://git.kernel.org/netdev/net/c/34d7ecb3d4f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


