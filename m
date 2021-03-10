Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E9B334CB4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbhCJXkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:40:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233178AbhCJXkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 18:40:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0B22564FD3;
        Wed, 10 Mar 2021 23:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615419613;
        bh=gjCxAQDBap3KHJcV4IolkBV5Xis867A37FP3FRUS2eQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CuNK3SoaHkGwqR70jTUJ3uri02xvzS/AmDefIImLizjYVc4TPJgA3GO2laOE4BXPO
         2REBc7sVn4snY8gKMdsxpb0KsN84FD04wMu4B8WtcZwxgQUbNg6oyb8ujyCfaTWyh0
         FDUKXcJY73G5E2Tc+j9CAsCWLY2mclDbBtvJerdB1c7AI6ewKUkJ3Z05CCo7SoSmru
         9fL5/VY9kLXqOuJY/MhX2YYazxdd8sgg/Q5leStqGj3NBioejHj0jRUjUkMvkI/TGW
         UfTQTXYGErj6PiYPEvBWfJA7O3PG2tVJf7WYZaf8mpsuOMMkZ0+AcYHKGMdk2YDOSa
         5702tu8/oa3dw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0508D6096F;
        Wed, 10 Mar 2021 23:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipv4: route.c: fix space before tab
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541961301.10035.11482265875642472221.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 23:40:13 +0000
References: <20210310211343.rpmffzhwhf7nogp7@kewl-virtual-machine>
In-Reply-To: <20210310211343.rpmffzhwhf7nogp7@kewl-virtual-machine>
To:     Shubhankar Kuranagatti <shubhankarvk@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bkkarthik@pesu.pes.edu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Mar 2021 02:43:43 +0530 you wrote:
> The extra space before tab space has been removed.
> 
> Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
> ---
>  net/ipv4/route.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Here is the summary with links:
  - net: ipv4: route.c: fix space before tab
    https://git.kernel.org/netdev/net-next/c/6b9c8f46af9d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


