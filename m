Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502D62EC72E
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 01:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbhAGAAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 19:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbhAGAAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 19:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1A56A23339;
        Thu,  7 Jan 2021 00:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609977609;
        bh=QQarzWU58nUeLLbA8+ra+b13JGDQPwHyKYcLmcgiZhM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tgQzlAZz/3kzpwDchaHFaT0UnX+X1R/Xmglyw/neSEeA87Ot98SeO28dgcNHz2+a6
         IMgztVVthve2XzGNPN2QdOSA3mmFrYvtsiihj38PgzJUUSseY7Xdf6k/EWJRQB3SxB
         bUR8yKmWe3WwEa0lxIpR32GfnJk0ycudn7BejdjNpOJXcA+abPE42K3RKJKoL3JkGj
         8Hh6Tn58dBn2mdP7+BY2HOHERyyVOaLgne2b40LnsUCk1dSjrT4bAlcef5RYwCucpI
         y+z+vZlY1o/zYsA/qY51WfrbJNuuqsVvVf5NylHhRJiXZ+/K5FcuPFNefPl/1xVb+x
         vXoGYDJtP9Juw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 0B1BC60597;
        Thu,  7 Jan 2021 00:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: bareudp: add missing error handling for
 bareudp_link_config()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160997760904.9755.10137771245387922413.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jan 2021 00:00:09 +0000
References: <20210105190725.1736246-1-kuba@kernel.org>
In-Reply-To: <20210105190725.1736246-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        martin.varghese@nokia.com, willemb@google.com,
        xiyou.wangcong@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  5 Jan 2021 11:07:25 -0800 you wrote:
> .dellink does not get called after .newlink fails,
> bareudp_newlink() must undo what bareudp_configure()
> has done if bareudp_link_config() fails.
> 
> v2: call bareudp_dellink(), like bareudp_dev_create() does
> 
> Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: bareudp: add missing error handling for bareudp_link_config()
    https://git.kernel.org/netdev/net/c/94bcfdbff0c2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


