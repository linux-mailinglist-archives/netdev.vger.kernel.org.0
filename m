Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C643C286660
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 20:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgJGSAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 14:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727866AbgJGSAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 14:00:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602093603;
        bh=susdN368wWkchFoMk0u0q7tBkFlvuib7RNuXyUSOHWE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H0ePnCp3kCFtti/lnnfwCnJZBAF8/rjZQijWMVIGrx8DYowBvv2//Bj9zmIO+gwPe
         pXF6gJwo5UiJs6aWzD7hlrgYem/W5YAuAp2o7Wx8WE7GREc+XRCSL5YoreVyCfJC82
         H7HL150sTRmpnnhHtPxqhnWhtnbhXWuV3nzJBuj8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] kernel/bpf/verifier: fix build when NET is not
 enabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160209360332.7046.6469450811216137483.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Oct 2020 18:00:03 +0000
References: <20201007021613.13646-1-rdunlap@infradead.org>
In-Reply-To: <20201007021613.13646-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kafai@fb.com,
        linux-next@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue,  6 Oct 2020 19:16:13 -0700 you wrote:
> Fix build errors in kernel/bpf/verifier.c when CONFIG_NET is
> not enabled.
> 
> ../kernel/bpf/verifier.c:3995:13: error: ‘btf_sock_ids’ undeclared here (not in a function); did you mean ‘bpf_sock_ops’?
>   .btf_id = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> 
> ../kernel/bpf/verifier.c:3995:26: error: ‘BTF_SOCK_TYPE_SOCK_COMMON’ undeclared here (not in a function); did you mean ‘PTR_TO_SOCK_COMMON’?
>   .btf_id = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> 
> [...]

Here is the summary with links:
  - [bpf-next] kernel/bpf/verifier: fix build when NET is not enabled
    https://git.kernel.org/bpf/bpf-next/c/49a2a4d4163f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


