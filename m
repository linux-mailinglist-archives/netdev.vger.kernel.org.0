Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A7F28D8EB
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 05:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgJNDKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 23:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbgJNDKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 23:10:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602645004;
        bh=yPqLs2wAIvyF3pA3dn9Yd3UgrIM0FXUNnxGByOtSHPs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M7CzLO1eT4jQWPUMd6lsUL6oa5uI0d8tzMif+C99EFwg5EQv+G+MBQWfWAdhEqVeq
         i6i2xY/ubV6C4ZN1j4LW/+KRzLEeXxFMNCYeWFws48dvp0rSPfrmS+uKw/Bo3S72+N
         /YEJ9Ha6ULKO6fNsNuqPqThm3nXajFGHw1XJOZyc=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/4] selftests: netfilter: extend nfqueue test case
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160264500396.16242.4118606759773056907.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Oct 2020 03:10:03 +0000
References: <20201013234559.15113-2-pablo@netfilter.org>
In-Reply-To: <20201013234559.15113-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Oct 2020 01:45:56 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> add a test with re-queueing: usespace doesn't pass accept verdict,
> but tells to re-queue to another nf_queue instance.
> 
> Also, make the second nf-queue program use non-gso mode, kernel will
> have to perform software segmentation.
> 
> [...]

Here is the summary with links:
  - [1/4] selftests: netfilter: extend nfqueue test case
    https://git.kernel.org/netdev/net/c/ea2f7da1799b
  - [2/4] ipvs: clear skb->tstamp in forwarding path
    https://git.kernel.org/netdev/net/c/7980d2eabde8
  - [3/4] netfilter: nftables: extend error reporting for chain updates
    https://git.kernel.org/netdev/net/c/98a381a7d489
  - [4/4] netfilter: nf_log: missing vlan offload tag and proto
    https://git.kernel.org/netdev/net/c/0d9826bc18ce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


