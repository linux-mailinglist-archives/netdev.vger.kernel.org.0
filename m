Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6361342752
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhCSVAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230453AbhCSVAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 160C56196E;
        Fri, 19 Mar 2021 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616187609;
        bh=plvMQbtQNGCxO10lqp8q08imJA8nh32wQTnFtQLWYeM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BikuHaR81qb7nBuJjuwTJzkTj5VjX8oMd1A/567RTj9+UMQhyq10xpkvcA1vwSKZP
         K2UcTOiwB9oBPYFC6FEsPo4tQNDlMhIEwB0vhj6nu6Iej2qN14bxBsIRXDaw0D2KDS
         yd6yav5OJMZbN84c+DZ3uCl6TpPdS0V6RIwMi74fyqpoRPZIqbL5BgoEdEJGYx/7Tk
         v584mAPPhbDEs5S3L4BmzubcIhtXqN0TO6BzNVvhl7F8ECHDENy+obdc3f60F4iIIw
         UGsdnHIIZX6dSSe+QE1Wq1QswGQk3p3cEjLe83A4CJI8YgoYdh0jFtXI1dQMEn6wpj
         IyLEgJSE5sudg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 07C4E626ED;
        Fri, 19 Mar 2021 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mptcp: Change mailing list address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618760902.12397.8037848408394783798.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 21:00:09 +0000
References: <20210319183302.137063-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210319183302.137063-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mptcp@lists.01.org, mptcp@lists.linux.dev,
        matthieu.baerts@tessares.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 19 Mar 2021 11:33:02 -0700 you wrote:
> The mailing list for MPTCP maintenance has moved to the
> kernel.org-supported mptcp@lists.linux.dev address.
> 
> Complete, combined archives for both lists are now hosted at
> https://lore.kernel.org/mptcp
> 
> Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net] mptcp: Change mailing list address
    https://git.kernel.org/netdev/net/c/ef2ef02cd9c2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


