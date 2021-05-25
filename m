Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60279390C42
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 00:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhEYWbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 18:31:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232782AbhEYWbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 18:31:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3B1716142B;
        Tue, 25 May 2021 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621981811;
        bh=OP+2crvbUdflDGJs+DZrs5Hsm5swebZhY7rgc9PlKBE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uM2XgOdHN/pg7sxi8fpJGFYmT7i4nOO8OI0B+IOeEo/J3jta35kTJNQ+aYnQKhP33
         +bXK0zKDrUnUBQOf7ITanU3cLPn1VWEnzHCqeIg+hYjrqNQmTI9gH2bqtcb2GL55Nt
         NAZe58AvHWKBGjxvS6TMpBGAt8IrtZb5TCwCI2gfnQLO+ARQ9HkLTTqI+mBN3XsZ66
         Ls270nYNwvJypzlrjKxy9hzQcDUs+afHRw6X3iSlW6XzmRxv1pqsc5Z6BxjRmDb2zy
         Wb5xUWflAsmVWZQfqNJmJaNUYnBRo/q5+153pwcWghxH85vLxvVmL/CeZu/miDfMWY
         jyqwiJnbL0KzQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 305D360BE2;
        Tue, 25 May 2021 22:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bridge: remove redundant assignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162198181119.18500.5211226351903654537.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 22:30:11 +0000
References: <YKx3ptXPNbd3Bdiq@fedora>
In-Reply-To: <YKx3ptXPNbd3Bdiq@fedora>
To:     Nigel Christian <nigel.l.christian@gmail.com>
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 24 May 2021 23:05:58 -0500 you wrote:
> The variable br is assigned a value that is not being read after
> exiting case IFLA_STATS_LINK_XSTATS_SLAVE. The assignment is
> redundant and can be removed.
> 
> Addresses-Coverity ("Unused value")
> Signed-off-by: Nigel Christian <nigel.l.christian@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: bridge: remove redundant assignment
    https://git.kernel.org/netdev/net-next/c/ccc882f0d838

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


