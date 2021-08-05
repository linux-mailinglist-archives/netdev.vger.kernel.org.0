Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658A73E14BC
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241384AbhHEMaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240887AbhHEMaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 08:30:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E1CAF61154;
        Thu,  5 Aug 2021 12:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628166606;
        bh=J4VgCz/RFtte9IHmBasq7s6Uw3UIpVc82NtiLAdi4/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kivyHesbA97cMkokUqhxUHmArz6LwT2JYcxovPzK+FxD2uM7J60fORkrIPiOVmi7/
         e0UGCX9eEfqbLTrva250iLXHvMkyjlJrsVhKPObN0+3DE4zDi+tuBiOKmk4n74CM5I
         hK1lhGYehN7cmxOO/HTUQHsjkELA6rXnoOvKycGRarmlAPFBBT3BvpQG44g0NjOmlp
         BiSBiyV6EZ8koNyowh4n0HJ5S0kU4R8Xn/3WOmxTJHSAbyvebxWkzyVoY3VpIm5tlj
         R9tzIzTAshpObYH88DR/VPjpOG4ZW0OxTZVztWlwx40JSc0lrXq6smdXz8Cr43Rft3
         S+rk33owBQM5g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D7E7A60A7C;
        Thu,  5 Aug 2021 12:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netdevice: add the case if dev is NULL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162816660687.5517.14280451425614767063.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 12:30:06 +0000
References: <20210805115434.19248-1-yajun.deng@linux.dev>
In-Reply-To: <20210805115434.19248-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  5 Aug 2021 19:54:34 +0800 you wrote:
> Add the case if dev is NULL in dev_{put, hold}, so the caller doesn't
> need to care whether dev is NULL or not.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  include/linux/netdevice.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] netdevice: add the case if dev is NULL
    https://git.kernel.org/netdev/net-next/c/b37a46683739

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


