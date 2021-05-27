Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D9B393869
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 23:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbhE0Vvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 17:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233203AbhE0Vvk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 17:51:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D8E5613E2;
        Thu, 27 May 2021 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622152207;
        bh=13ll+OKhkr3oOV335Yql+Ygvc6MrlaBCSnocZOBHL34=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CBDAKmj4twVEdsQthSEelolL1d3X5bY3MmdpTKAO64pEgoeJfZ54fW2z10eEL/Q7F
         FxT74xpyFnF5r2KqH+uopFOeeOutw8pp1W3/ReygYUdqQGqoZApdq7NWHqBDFUsI0T
         lR+lznDPmkrnkdj83Nj8wXYFJ90xMd+0WkNiclU5wumn73qRODt1BkL2T3AQRMdWn6
         0WVoz0fEhPu/XLB3PAc3wr1symletOKNaBUnDvsl1el7rmD0E2gz/gd9M7H331ALgk
         kiKgSf4XOXI880sMqfBn4sHSIY7TXeNP8zxXhJqTlYvpg5aJEe4+cgN5FqSqtWsJB9
         uBJqpZgN9G3Fg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 01AC060BD8;
        Thu, 27 May 2021 21:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next] selftests: devlink_lib: add check for devlink device
 existence
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162215220700.21706.6018214826729074927.git-patchwork-notify@kernel.org>
Date:   Thu, 27 May 2021 21:50:07 +0000
References: <20210527105515.790330-1-jiri@resnulli.us>
In-Reply-To: <20210527105515.790330-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mlxsw@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 27 May 2021 12:55:15 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> If user passes devlink handle over DEVLINK_DEV variable, check if the
> device exists.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: devlink_lib: add check for devlink device existence
    https://git.kernel.org/netdev/net-next/c/557c4d2f780c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


