Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95E943D86B
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 03:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhJ1BMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 21:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhJ1BMe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 21:12:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 075F8610E7;
        Thu, 28 Oct 2021 01:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635383408;
        bh=qaaD2IDnK20vD4YEO7HQMxHeJyHt3zSZTEbieY8OUo0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LMnJFZUtVYtl3HYgQeh9mcQPL5b3bA2HhscT4VcQpF1Fpgeh7gNMtjC6ewIifo+Kd
         34owT8wvYKannRFgP/pVPyHOgg0ctwATBQ/3IzVixCk4GixcFYvNVpHdfZ7ZgB+EG4
         iuaogJTrw1ol8KVjHRrC7ZczApxRDdx5CJvUjBZEWnK9OU+lAQRnpUuC7GYwWhOdd+
         56C0ThtoETSyfPAPIHIMcNhh5jYY0aGKoXHOHDu9o+v9UDEYd1PvRwDjmKq9bFG+cs
         K/CuztdcQK8si/ViQvMkfA+YfF6Dl9XSqyOrmcRAsQQNz0+s0WfuIxJJxyvj+nem/w
         YC1LOYa0sgZcw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E076160A17;
        Thu, 28 Oct 2021 01:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: sch: eliminate unnecessary RCU waits in
 mini_qdisc_pair_swap()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163538340791.2556.15839467340042308095.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 01:10:07 +0000
References: <20211026130700.121189-1-seth@forshee.me>
In-Reply-To: <20211026130700.121189-1-seth@forshee.me>
To:     Seth Forshee <seth@forshee.me>
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, paulmck@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Oct 2021 08:06:59 -0500 you wrote:
> From: Seth Forshee <sforshee@digitalocean.com>
> 
> Currently rcu_barrier() is used to ensure that no readers of the
> inactive mini_Qdisc buffer remain before it is reused. This waits for
> any pending RCU callbacks to complete, when all that is actually
> required is to wait for one RCU grace period to elapse after the buffer
> was made inactive. This means that using rcu_barrier() may result in
> unnecessary waits.
> 
> [...]

Here is the summary with links:
  - [v2] net: sch: eliminate unnecessary RCU waits in mini_qdisc_pair_swap()
    https://git.kernel.org/netdev/net-next/c/267463823adb
  - [2/1] net: sch: simplify condtion for selecting mini_Qdisc_pair buffer
    https://git.kernel.org/netdev/net-next/c/85c0c3eb9a66

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


