Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE58456E9F
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 13:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbhKSMDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 07:03:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234665AbhKSMDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 07:03:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0CAC861AA3;
        Fri, 19 Nov 2021 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637323213;
        bh=OUAe1Pb1sQuHDgq/6kYeATO52RwFgt62DiQhofN0138=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ARVf4ZN5eSTqR38OFBpHblS1qZ/Sv87cqA1Cxr59cgIpcv1cY0oylkuNXsuaQQlSL
         xjDy2Oe2BbJb4ujQzIh3Bve6mU4xkPby+KHA0gM54QzSwV2adYdAzegO6Ao+X4yWy9
         vdMFGJpMKG2ifAWFvAeiawkIgwFRE3GPsJCw2YuA5I+P/IX6XOTMrKSsKJNOhGHFMr
         ULvw6+85JJEzHD7k2ixebRu5z8njxy6yoLO3oYeVqOdcBqpInlYlH9j0uORMQm9qWL
         gZHyGPW2hyScAKwTsCu/JopmKirewZ+Robv3y9majg4WWaZy55vRDHrOjMMTIa/zsE
         baImecm3092qA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F159660A0F;
        Fri, 19 Nov 2021 12:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: Use memset_after() to zero rt6_info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732321298.14736.16066190721054866054.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 12:00:12 +0000
References: <20211118203241.1287533-1-keescook@chromium.org>
In-Reply-To: <20211118203241.1287533-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 12:32:41 -0800 you wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Use memset_after() to clear everything after the dst_entry member of
> struct rt6_info.
> 
> [...]

Here is the summary with links:
  - ipv6: Use memset_after() to zero rt6_info
    https://git.kernel.org/netdev/net-next/c/8f2a83b454c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


