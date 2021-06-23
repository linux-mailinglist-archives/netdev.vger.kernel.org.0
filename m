Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C213B2177
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 22:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhFWUC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 16:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWUCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 16:02:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 25C8161185;
        Wed, 23 Jun 2021 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624478405;
        bh=hVCBY7QfK0vAo7AjFAw6puD6+nQO1/E5ur3q5kjlXJc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JRftS1U9DySw+hSOzxLC5iagcBBtzdeaK5zb+2mU38PiXR4HflBKaTXYGpEhVS/3F
         HzJnObJ8aBDuZsHBXDt7EfduasHX0yyWbSxWIpTcG3IaepPA2szYfKCOL0WC4NKQed
         upQ07UyIr/6GH03/7PuQ7AxTq76f7kTk0kYjlMi7UP9gj+r7Exf6of07BMp0yTwmXo
         uU1r4UKGCoB1kKrheuJphA3Ix1bYEZB5X8+oCCj9YVN4jmjZmV8i5eXkdltN286XDD
         dLFwZaqJZ0emp5rzoM0AITJmoqNOTNrZKZo/8976/cWZtZJ7ZEftp0+o2AoEcIYblZ
         p0HpZHnY8I+fw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 17FFD60A2F;
        Wed, 23 Jun 2021 20:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: Add stats for socket migration.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162447840509.26653.11794900341617628039.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Jun 2021 20:00:05 +0000
References: <20210622233529.65158-1-kuniyu@amazon.co.jp>
In-Reply-To: <20210622233529.65158-1-kuniyu@amazon.co.jp>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        ycheng@google.com, kafai@fb.com, kuni1840@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 23 Jun 2021 08:35:29 +0900 you wrote:
> This commit adds two stats for the socket migration feature to evaluate the
> effectiveness: LINUX_MIB_TCPMIGRATEREQ(SUCCESS|FAILURE).
> 
> If the migration fails because of the own_req race in receiving ACK and
> sending SYN+ACK paths, we do not increment the failure stat. Then another
> CPU is responsible for the req.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: Add stats for socket migration.
    https://git.kernel.org/netdev/net-next/c/55d444b310c6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


