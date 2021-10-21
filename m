Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A0643606A
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 13:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhJULmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 07:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229765AbhJULm2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 07:42:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 326B0610FF;
        Thu, 21 Oct 2021 11:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634816412;
        bh=B69kHncm3+fZAwkbgcBS9BvkN6mONRI9FWmom9jPw/0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UKXtvstloZrrR71cXl1dJV72wTTY/0QtaQDjcwGyBxyCl3BthYaY4bGcOyz/hhD/D
         pMKg2uMSJW0UKb//eSg3pN1ShWrZQryeU9UkEz3zdzmILQheoRP8VyFHQ8x3GlxU+A
         dyPGFuZo+2MjK/n3agE5bzSf0MAEaIIJx2nd+nujLLbSFdKJVHt43SoOLke8GeYkja
         QVdnhSrrMY+EEvPoXbUJrbwmN6xTxA2sAiTHvzU+Rvj09Nh+mIzucVX75WW4jYpdQK
         W6vyQ9DGUus7yLDFgs2OPYgwJo1J0FPqRgUsQvq9SRkgXyx25MSrHzk4G0Y49CUtHq
         3OVYQz942qktg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 274F560A24;
        Thu, 21 Oct 2021 11:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/8] netfilter: xt_IDLETIMER: fix panic that occurs when
 timer_type has garbage value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163481641215.11574.15881715403045755138.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Oct 2021 11:40:12 +0000
References: <20211021100821.964677-2-pablo@netfilter.org>
In-Reply-To: <20211021100821.964677-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 21 Oct 2021 12:08:14 +0200 you wrote:
> From: Juhee Kang <claudiajkang@gmail.com>
> 
> Currently, when the rule related to IDLETIMER is added, idletimer_tg timer
> structure is initialized by kmalloc on executing idletimer_tg_create
> function. However, in this process timer->timer_type is not defined to
> a specific value. Thus, timer->timer_type has garbage value and it occurs
> kernel panic. So, this commit fixes the panic by initializing
> timer->timer_type using kzalloc instead of kmalloc.
> 
> [...]

Here is the summary with links:
  - [net,1/8] netfilter: xt_IDLETIMER: fix panic that occurs when timer_type has garbage value
    https://git.kernel.org/netdev/net/c/902c0b188752
  - [net,2/8] netfilter: Kconfig: use 'default y' instead of 'm' for bool config option
    https://git.kernel.org/netdev/net/c/77076934afdc
  - [net,3/8] netfilter: nf_tables: skip netdev events generated on netns removal
    https://git.kernel.org/netdev/net/c/68a3765c659f
  - [net,4/8] selftests: nft_nat: add udp hole punch test case
    https://git.kernel.org/netdev/net/c/465f15a6d1a8
  - [net,5/8] netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6
    https://git.kernel.org/netdev/net/c/a482c5e00a9b
  - [net,6/8] netfilter: ipvs: make global sysctl readonly in non-init netns
    https://git.kernel.org/netdev/net/c/174c37627894
  - [net,7/8] selftests: netfilter: remove stray bash debug line
    https://git.kernel.org/netdev/net/c/3e6ed7703dae
  - [net,8/8] netfilter: ebtables: allocate chainstack on CPU local nodes
    https://git.kernel.org/netdev/net/c/d9aaaf223297

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


