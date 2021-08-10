Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9733E8651
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 01:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbhHJXK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 19:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235192AbhHJXK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 19:10:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A050C60462;
        Tue, 10 Aug 2021 23:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628637005;
        bh=AG5Z2ZzffQsTB0cX7CqgUYcS54apVnOQ780STkEdyhQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GAcdcDSMdPLJBXD/cWn8MaryezdKQ0HSAZzX0sYeycYQXLLR2J0qg7ueiCIKikyFf
         GysA+Dy8DnvRp8NOsXWc1JJ+6wIxSzYLB7LpZHStc33G9ckR1AnApaJhbWYOtDb5Jb
         NgwNpmZZ0cRjJRodNQ0+aytYoebgmE5SyBZUJrn/ofuldMBHXGPvPc8/ZfGZfjd6Xq
         1wJq3yl7NGM7E6O/E6BH1AjAMBKUCU4QZ0kgUvLZ1fyHLxh/X55VXU2mZ/i6qwSZYV
         9xBjiq6i8aqJMMeB9nujCpJncUUzZqSsQFw5XKhakxpwyfvXfK9Rss9irfUdM+kgNi
         Yr/QwGC7LMIkg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 95527609AD;
        Tue, 10 Aug 2021 23:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: Support filtering interfaces on no master
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162863700560.24690.16202000334664708930.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Aug 2021 23:10:05 +0000
References: <20210810090658.2778960-1-lschlesinger@drivenets.com>
In-Reply-To: <20210810090658.2778960-1-lschlesinger@drivenets.com>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 10 Aug 2021 09:06:58 +0000 you wrote:
> Currently there's support for filtering neighbours/links for interfaces
> which have a specific master device (using the IFLA_MASTER/NDA_MASTER
> attributes).
> 
> This patch adds support for filtering interfaces/neighbours dump for
> interfaces that *don't* have a master.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: Support filtering interfaces on no master
    https://git.kernel.org/netdev/net-next/c/d3432bf10f17

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


