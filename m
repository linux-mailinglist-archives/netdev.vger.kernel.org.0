Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61144192FB
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 13:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbhI0LVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 07:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233897AbhI0LVo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 07:21:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BA9C760F4A;
        Mon, 27 Sep 2021 11:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632741606;
        bh=13JozM+bkGJYFMrtg/NZ/ZRNHf+LNanb6nh66NXetP0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nqO+/2/IkVYwqyf+0PuB+iJjLPiwiWWqr8DPbhanbQOSI61HMGD0JsUk+FgKyqhnD
         0YLc34sOkmns2XDttBr3WkYr4QqH+OzbqApJfQRCKX8nL8IFZsonoXUwo9N1sZxAWM
         DdgJC8rEsRDcq5WWQXQ4bFg4212L0D8WkqcT5ympzyArdHV78IKc1KniKOsSVjKU7P
         T+jZK6LS+ko0vBFtUJjwNyxuet+9iqa/Wov8dd+h1au1sZprz9xeCb2MTFYa2FSf0Y
         eNgaQH+h/a+ns3aRNds0VrscGZPGWAbiUQewrPruXpoOQO5RJiNZrRGOBm4YmvL5j+
         /8rSSyNBaj9Ng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC0DD60A3E;
        Mon, 27 Sep 2021 11:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: net: fib_nexthops: Wait before checking
 reported idle time
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274160669.1534.16948830320310763673.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 11:20:06 +0000
References: <7e30b8e01fdfb76ff6f4e071348829e2f56767e8.1632477544.git.petrm@nvidia.com>
In-Reply-To: <7e30b8e01fdfb76ff6f4e071348829e2f56767e8.1632477544.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 24 Sep 2021 12:04:27 +0200 you wrote:
> The purpose of this test is to verify that after a short activity passes,
> the reported time is reasonable: not zero (which could be reported by
> mistake), and not something outrageous (which would be indicative of an
> issue in used units).
> 
> However, the idle time is reported in units of clock_t, or hundredths of
> second. If the initial sequence of commands is very quick, it is possible
> that the idle time is reported as just flat-out zero. When this test was
> recently enabled in our nightly regression, we started seeing spurious
> failures for exactly this reason.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: net: fib_nexthops: Wait before checking reported idle time
    https://git.kernel.org/netdev/net-next/c/b69c99463d41

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


