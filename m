Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16E849E874
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244332AbiA0RKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244328AbiA0RKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:10:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39F8C06173B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1282CE22EC
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 17:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F32C2C340ED;
        Thu, 27 Jan 2022 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643303410;
        bh=F4MVFMyevWPN72p031WE+ckMOX2A559QrhH9Sn/ZoAU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P/Erdts6yGsobwtfOcz3cnXJ8V6FnxmuBv7c25aydTLG8UAPqSHxUZEmlLO1pJuNd
         DfJS0J3z6blJ6iEZrMFQuHkA6e2fXhPQ5261juYb8dchd7y5Tar/ZAHW+X3fStT9tc
         Xp7Xmgasnnsr+lLpBw8Vxn2/B62pbkplNtE5BDfAZtFqQlQxcqx3veIJX3nCw7YKcF
         QWVhIvtb5rgvQ1z5gQFAvTfO56zmDNsULJ/gB579hWlQPXAluoxY5MZN7nK0jVWvDn
         wpnj++0uuy4vJK/+iMB5FYGbWSTLmF1cKqLpexzkMXYv0DflTq4UHPFukLzbF3VS0s
         rtSc0w4mYmpzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1FE0E5D091;
        Thu, 27 Jan 2022 17:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 0/2] ipv4: less uses of shared IP generator
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164330340985.19448.25977212444003179.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 17:10:09 +0000
References: <20220127011022.1274803-1-eric.dumazet@gmail.com>
In-Reply-To: <20220127011022.1274803-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 26 Jan 2022 17:10:20 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We keep receiving research reports based on linux IPID generation.
> 
> Before breaking part of the Internet by switching to pure
> random generator, this series reduces the need for the
> shared IP generator for TCP sockets.
> 
> [...]

Here is the summary with links:
  - [v2,net,1/2] ipv4: tcp: send zero IPID in SYNACK messages
    https://git.kernel.org/netdev/net/c/970a5a3ea86d
  - [v2,net,2/2] ipv4: avoid using shared IP generator for connected sockets
    https://git.kernel.org/netdev/net/c/23f57406b82d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


