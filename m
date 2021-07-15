Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0EB3CA4DA
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 20:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbhGOSC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 14:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236777AbhGOSC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 14:02:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9D5D2611F1;
        Thu, 15 Jul 2021 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626372005;
        bh=4jreQNy/qjGBI10Uizj8fbZtQpSLfWcOFBu2BKfxtmA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dcfu/wMFGWRgcqogjvuvMRmQAAbemdwBuurwdBI41eOabu7Wghf0Kpi3N6+QcgxUx
         eaSM9F8ccuM0ULifXK0b2w/8cEtl1ohxWhgamK65azLZfW2b6IYb9lzRDRLldzJpWg
         LiBPWPc9oe4qWmrLJ+dPIO2/XJmpKAxLQExfrVrU8shlGVzuOc81mXCZF5QOmsGqrG
         Jlkv1Plbmd8wmcNLSam+2x3IZ3pLUQPR5S+hYOu6BQ/yWFdWV9qqGCJ+u/rgrwhaZJ
         XP8/32jSN3IJX6HjwEkQMB/+yTW7JGZhJoUlK3ScjgrQULa/xYBqPA0I05g//EShoW
         E6E8GJGIF951Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7FB4860A0C;
        Thu, 15 Jul 2021 18:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2] bpf, sockmap,
 udp: sk_prot needs inuse_idx set for proc stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162637200551.28238.8602014526032832150.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Jul 2021 18:00:05 +0000
References: <20210714154750.528206-1-jakub@cloudflare.com>
In-Reply-To: <20210714154750.528206-1-jakub@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net, lmb@cloudflare.com,
        ast@kernel.org, andrii@kernel.org, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed, 14 Jul 2021 17:47:50 +0200 you wrote:
> Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
> We currently do not set this correctly from sockmap side. The result is
> reading sock stats '/proc/net/sockstat' gives incorrect values. The
> socket counter is incremented correctly, but because we don't set the
> counter correctly when we replace sk_prot we may omit the decrement.
> 
> To get the correct inuse_idx value move the core_initcall that initializes
> the udp proto handlers to late_initcall. This way it is initialized after
> UDP has the chance to assign the inuse_idx value from the register protocol
> handler.
> 
> [...]

Here is the summary with links:
  - [bpf,v2] bpf, sockmap, udp: sk_prot needs inuse_idx set for proc stats
    https://git.kernel.org/bpf/bpf/c/54ea2f49fd94

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


