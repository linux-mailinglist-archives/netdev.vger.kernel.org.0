Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6FC456E75
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhKSLxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233963AbhKSLxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 06:53:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D1A3061AFD;
        Fri, 19 Nov 2021 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637322615;
        bh=ynVmec1MyYwHPOlTcR8rYkXkKx3uUy6dXHzPSS1LH7c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fb8KQHp00WGgcMzFsforc3a1nnXPz7tl9ey2ImeYrWNnN8qqfKSmhG+kplX8SGSXG
         1wxm16M8IOfg/rRt7HP32MkllpvbcsMMdserV/zD5dDg+2Uscuur0fsXHRYV79H7Um
         sN6XwaQum999LQxm4Y2SfuKtWzWqwb1SuaAMfEw3dM4oJhPZYdV3P9Aw6tLmqMxNWM
         htZ2ttaclf2+qv1Kd1xtSnB+N6S0QSBoRphpY/IGlSwr7oKu1XccsixZJr9O0tn+NL
         Rhr8jVy/pc/CH7o/7Q3xl4QSO+woQOjCMNFyojyeVJgrOBKXR2milV5wqxaBHjkwLj
         0BVflY1e62xhw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CC4DA6096E;
        Fri, 19 Nov 2021 11:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: 802: Use memset_startat() to clear struct fields
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732261583.10547.12958105982595496802.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 11:50:15 +0000
References: <20211118203045.1286717-1-keescook@chromium.org>
In-Reply-To: <20211118203045.1286717-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-hippi@sunsite.dk,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 12:30:45 -0800 you wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Use memset_startat() so memset() doesn't get confused about writing
> beyond the destination member that is intended to be the starting point
> of zeroing through the end of the struct.
> 
> [...]

Here is the summary with links:
  - net: 802: Use memset_startat() to clear struct fields
    https://git.kernel.org/netdev/net-next/c/e3617433c3da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


