Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6795D44F12A
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 05:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbhKMEXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 23:23:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232723AbhKMEXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 23:23:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A2323610A1;
        Sat, 13 Nov 2021 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636777209;
        bh=I8bJuQQgK9xosNwCUgTRXodM4UNkeuqEWne4emt+vKM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g2irtq8o5Uc8TpH/CFnVjwQAB1i4F87IFs6qNxQ8UVUsH/JtifK/Mogh5Kjzo8vm4
         knyRVue0F2Sou7bgVBvwup+UV8mw7Ka9iYxebJEqEOwL7VxB1BaE7hZJ1Tmo5c/GwB
         uJ30s3y6cmOrV7/K0E+h7R8Hknxq0+BUk95QS1ye35eeipCNPdHwIt/g0MuzqfNiQI
         MTWuQRBz9VOPlDwnFYPDHhDeNMFAOzlL7SfvIwTIuYDLBTbkyuXdhuiFn0SLsialvD
         llyzzYxce8PPxepK+uPR6I93R1hScEba9qjMk7Uq0ZwSHdejkGRC6k13Le14t2cwV6
         NMXk4P+Tq0oTQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8A18760721;
        Sat, 13 Nov 2021 04:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: net: switch to socat in the GSO GRE test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163677720956.27008.7630813556418977041.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Nov 2021 04:20:09 +0000
References: <20211111162929.530470-1-kuba@kernel.org>
In-Reply-To: <20211111162929.530470-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        andrea.righi@canonical.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 11 Nov 2021 08:29:29 -0800 you wrote:
> Commit a985442fdecb ("selftests: net: properly support IPv6 in GSO GRE test")
> is not compatible with:
> 
>   Ncat: Version 7.80 ( https://nmap.org/ncat )
> 
> (which is distributed with Fedora/Red Hat), tests fail with:
> 
> [...]

Here is the summary with links:
  - [net] selftests: net: switch to socat in the GSO GRE test
    https://git.kernel.org/netdev/net/c/0cda7d4bac5f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


