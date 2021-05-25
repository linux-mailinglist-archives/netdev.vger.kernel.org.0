Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34B0390C19
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 00:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbhEYWVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 18:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232342AbhEYWVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 18:21:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1491C61423;
        Tue, 25 May 2021 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621981210;
        bh=fwVHU1uBa7Vpr+/uRB6znaYmLQxd5Erz1HlLuv1+X7c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uv4vfzWyXkoR4s3pfoa+wSDGriYPZkPoxZHHYu/6r5WKnH4aiBxeK08Yyct90YT/R
         3R4TxJTmhE3JxsNkZ2jRRF94tzt05vtlwmmJ2CoToiVyJzYr8amJn0v9EsA+nt+3Xq
         kSjVxwsEeTaKGY+ykKyqRM5K2m0iAgLmUm36ezP9ltQAWDKmUbu8k8Es6ZUGAhpu3t
         w7UztCNHWzu9u06taMGzRoEY1fwKEIe/STpvGUFmo2Ir+bMRO9cNJq3VbRWGEsADv+
         AtncYcsB1AnX3m+uOFQUFhm0wcFDeskSlf4paa9M6ZGJBtmbTQVlp/xY7APgyfXLtx
         1z6G6ky79QjPA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0456560C29;
        Tue, 25 May 2021 22:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: fix the proc_handler for sysctl encap_port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162198121001.14309.14324631465451775260.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 22:20:10 +0000
References: <deeba1bfa2edb3f83fd1b8ad3bf6b6f5bce264dd.1621910982.git.lucien.xin@gmail.com>
In-Reply-To: <deeba1bfa2edb3f83fd1b8ad3bf6b6f5bce264dd.1621910982.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 24 May 2021 22:49:42 -0400 you wrote:
> proc_dointvec() cannot do min and max check for setting a value
> when extra1/extra2 is set, so change it to proc_dointvec_minmax()
> for sysctl encap_port.
> 
> Fixes: e8a3001c2120 ("sctp: add encap_port for netns sock asoc and transport")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] sctp: fix the proc_handler for sysctl encap_port
    https://git.kernel.org/netdev/net/c/b2540cdce6e2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


