Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A3843E480
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhJ1PCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:32928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230258AbhJ1PCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 11:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 90A5D60C40;
        Thu, 28 Oct 2021 15:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635433207;
        bh=i+aGM0vK3WNM6FXAlSTg8Y6qJqfW3TLP/H+DzG+2/is=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hNOjJgMw+ETn/RMqdDb8HJzlkXQ35t9zhSiN0KnwZKxKuOZ/PFwbu4u5p2ebW90Df
         6kAmtHe1IOAn7GHw+cE7T8XqYTSd1J2vzzOpcIHcCKGe7czH+vAyGt7FHnK7uS2MlJ
         DNisXtrW9mgyOT4HiVA2GmDxsLjT6CVsncSSpLv1MzdKdJ5nS63a+TKZxcJYSr+llm
         vxj4CEI7WIizzV3ZOWkTk4aN3S+e7eeTchMuGEFNw5C0duMx33lCqgtd3rpdqMMO3B
         LDAafk1fn5Dit4areaztZgD1RoWxpaEqhLuOvRrMXSsq8TOqSnZuBjzbFvfXLLKvAG
         gwedb9LGlCfJw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 84086609D2;
        Thu, 28 Oct 2021 15:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v2] xfrm: enable to manage default policies
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163543320753.10329.14599195153341139094.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 15:00:07 +0000
References: <20211025081706.6381-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20211025081706.6381-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Mon, 25 Oct 2021 10:17:06 +0200 you wrote:
> Two new commands to manage default policies:
>  - ip xfrm policy setdefault
>  - ip xfrm policy getdefault
> 
> And the corresponding part in 'ip xfrm monitor'.
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v2] xfrm: enable to manage default policies
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=76b30805f9f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


