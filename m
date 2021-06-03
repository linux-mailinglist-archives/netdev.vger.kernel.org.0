Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BEC39AE2F
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhFCWl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:41:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229746AbhFCWlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:41:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2CCD36140A;
        Thu,  3 Jun 2021 22:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622760006;
        bh=4sJr6/wrBhScPOqAT5+rR2J9OjmxsVirijeLB/+47yc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HTXaDfWMy4qxh8p1Ql69XsGNbOzhhdmqdXVON6Br4JI4JmsDxxMBfXHOzrAthuMa5
         SFusx6UxzTKjhuzyA61lKJ0sGBi3GrwJnegFMzoPjjtEc1bxdgSe715CtO/dBwZwyk
         6yqtVUqLcNfB0WHdK6jFmKBakvozL0evvJLw8d6ZW6FqJT8NuwrzXrxxFLWwBTI7jv
         W0ITYR1ShozHeFhY2b7NXobd8dJTL3qskMxy/w6V2PSgIS3GybqA2l24SaAjLibrf1
         AcAntdp9lffrtzQ5ojVx5ziBLqHn2RSpM7Y8kIeGEWS+hq3unDR5+U8sJ59Kp4hFbS
         WYCLfeI+sMNnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1848660BCF;
        Thu,  3 Jun 2021 22:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] icmp: fix lib conflict with trinity
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162276000609.13062.5920077176509341487.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:40:06 +0000
References: <20210603212211.335237-1-andreas.a.roeseler@gmail.com>
In-Reply-To: <20210603212211.335237-1-andreas.a.roeseler@gmail.com>
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        kuba@kernel.org, willemdebrujin.kernel@gmail.com,
        fweimer@sourceware.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  3 Jun 2021 16:22:11 -0500 you wrote:
> Including <linux/in.h> and <netinet/in.h> in the dependencies breaks
> compilation of trinity due to multiple definitions. <linux/in.h> is only
> used in <linux/icmp.h> to provide the definition of the struct in_addr,
> but this can be substituted out by using the datatype __be32.
> 
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] icmp: fix lib conflict with trinity
    https://git.kernel.org/netdev/net-next/c/e32ea44c7ae4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


