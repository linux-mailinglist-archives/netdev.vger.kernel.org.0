Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE273FB383
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 12:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbhH3KBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 06:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235950AbhH3KBA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 06:01:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E554C61076;
        Mon, 30 Aug 2021 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630317606;
        bh=EMljaQJ/hYz+7LPscSCU+AIZGZsC/CcVGaugvSVLMYc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ht8nB33CL+upu/rtmYLJGGCN0HvYAQKlDEqDN1gf6bySRRgpSb1h574JlC2d7ucjY
         PoGG8SqwErd8ff50oKYrcV6OHFC24PtVrY2Qd1IiFL4fsTi1GfImS0HweVEmglSGIm
         aTi1pD+iRaXOlMgViUW1bU6igsXfXa4aCoZ/uF7TPL4MeCP6ikfJEbL4UrROol1Tbs
         ptqF5SGPYHVMZkaQAteXsPF43/idjXcW7xAs87roxNE+InvTlKHnMNms6ufkl7Q/3k
         IMtKkQlo+6pP2CEwx62WtHeZWSGwS2bebz6nknPkCtl0AiPAsg4mJUs32cLoX8WFYL
         W1kgbdF8eaeFg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D8BB260A6C;
        Mon, 30 Aug 2021 10:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/8] netfilter: ecache: remove one indent level
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163031760688.27483.14106552894924526730.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Aug 2021 10:00:06 +0000
References: <20210830093852.21654-2-pablo@netfilter.org>
In-Reply-To: <20210830093852.21654-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 30 Aug 2021 11:38:45 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> nf_conntrack_eventmask_report and nf_ct_deliver_cached_events shared
> most of their code.  This unifies the layout by changing
> 
>  if (nf_ct_is_confirmed(ct)) {
>    foo
>  }
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] netfilter: ecache: remove one indent level
    https://git.kernel.org/netdev/net-next/c/478374a3c15f
  - [net-next,2/8] netfilter: ecache: remove another indent level
    https://git.kernel.org/netdev/net-next/c/9291f0902d0c
  - [net-next,3/8] netfilter: ecache: add common helper for nf_conntrack_eventmask_report
    https://git.kernel.org/netdev/net-next/c/b3afdc175863
  - [net-next,4/8] netfilter: ecache: prepare for event notifier merge
    https://git.kernel.org/netdev/net-next/c/b86c0e6429da
  - [net-next,5/8] netfilter: ecache: remove nf_exp_event_notifier structure
    https://git.kernel.org/netdev/net-next/c/bd1431db0b81
  - [net-next,6/8] netfilter: ctnetlink: missing counters and timestamp in nfnetlink_{log,queue}
    https://git.kernel.org/netdev/net-next/c/6c89dac5b985
  - [net-next,7/8] netfilter: x_tables: handle xt_register_template() returning an error value
    https://git.kernel.org/netdev/net-next/c/7bc416f14716
  - [net-next,8/8] netfilter: add netfilter hooks to SRv6 data plane
    https://git.kernel.org/netdev/net-next/c/7a3f5b0de364

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


