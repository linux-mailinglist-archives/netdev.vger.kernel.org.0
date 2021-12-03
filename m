Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7F4467616
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 12:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351732AbhLCLXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 06:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243475AbhLCLXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 06:23:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AE8C06173E
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 03:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FFEF62A23
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 11:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FE3BC53FC7;
        Fri,  3 Dec 2021 11:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638530410;
        bh=5/E/YhKcV6KAnD4WPZ0G2XvoYr7zYmdXssAR+MLQVc4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jTVaeWvqaHhCFlSJDx82EQ/9SMDDiEb8h3iUz1cpBfN4EdtXl+ufjfZshPFyhPgzN
         3ljvQcJBoVOsyRpcOPSjd0OzvBXh6O27wjqrbSh1Hhmt6F9jgvSfzWIIlu5Zxd/s34
         vb35hJRPDB88rg5KnK7eyAaNP/UCeX/w0KO7oTMmwyW0oDJnWQvoVQOsYcWeJSqgm4
         jNvv+OhmhsehRlzLPNu6ALJisVUfOMGEXOXKrv1uDhlpQCIz0s+tqIa8hoh4l3t+Nn
         bm+ZdsKlFaGS83fCZFPZQ8KorpREwqo90UHObQzEWWqRCZjTngYMyMLGqMM9uVaHm1
         n7sflqcC0y47g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8317660A90;
        Fri,  3 Dec 2021 11:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: act_ct: Offload only ASSURED connections
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163853041053.14824.14102664105699413112.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 11:20:10 +0000
References: <20211201133153.17884-1-cmi@nvidia.com>
In-Reply-To: <20211201133153.17884-1-cmi@nvidia.com>
To:     Chris Mi <cmi@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ozsh@nvidia.com, roid@nvidia.com, paulb@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 1 Dec 2021 15:31:53 +0200 you wrote:
> Short-lived connections increase the insertion rate requirements,
> fill the offload table and provide very limited offload value since
> they process a very small amount of packets. The ct ASSURED flag is
> designed to filter short-lived connections for early expiration.
> 
> Offload connections when they are ESTABLISHED and ASSURED.
> 
> [...]

Here is the summary with links:
  - [net-next] net/sched: act_ct: Offload only ASSURED connections
    https://git.kernel.org/netdev/net-next/c/43332cf97425

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


