Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB15C31A5BF
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 21:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhBLUAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 15:00:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229903AbhBLUAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 15:00:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5DB2D64E35;
        Fri, 12 Feb 2021 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613160007;
        bh=JT0+CdhHCdZ/8uAFS6novrYJdVcb5CE13n7f93XfNL8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bX4v7v1uD8Az6qhXEIEfaskfjWww76yRGXQbf73mVicxKZQHCJxYbdpYI91PSRmJI
         dEhEwt1mmqdz5UeCi09Z8ie62EJOYUXCx8EpFYwoKAJ4LJ+bkey6mVvCmXWK4jlxJT
         dfWVZFVg4N7zy64lwrN16aWFOdFawMM4KzvzyfloZH3ondxoLQF1Vp+8rfPV5/hYj7
         hzsXaBlRK2Drs1t3fHtnhKdwpRaTGenivyuIS06q1LzccOR+jOPegCMmOcGsXSH1mV
         Ekq6ao3seyj7Ar/pvCdme6d3TxOYPwatzRi/RFFbPCbWj+YHACHbDxGtFY8ugHTkXc
         5o0pAqulioCJA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4ADF560A2C;
        Fri, 12 Feb 2021 20:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf 1/2] libbpf: Ignore non function pointer member in
 struct_ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161316000730.8234.4257657674013138235.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Feb 2021 20:00:07 +0000
References: <20210212021030.266932-1-kafai@fb.com>
In-Reply-To: <20210212021030.266932-1-kafai@fb.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, netdev@vger.kernel.org, andrii@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 11 Feb 2021 18:10:30 -0800 you wrote:
> When libbpf initializes the kernel's struct_ops in
> "bpf_map__init_kern_struct_ops()", it enforces all
> pointer types must be a function pointer and rejects
> others.  It turns out to be too strict.  For example,
> when directly using "struct tcp_congestion_ops" from vmlinux.h,
> it has a "struct module *owner" member and it is set to NULL
> in a bpf_tcp_cc.o.
> 
> [...]

Here is the summary with links:
  - [v2,bpf,1/2] libbpf: Ignore non function pointer member in struct_ops
    https://git.kernel.org/bpf/bpf-next/c/d2836dddc95d
  - [v2,bpf,2/2] bpf: selftests: Add non function pointer test to struct_ops
    https://git.kernel.org/bpf/bpf-next/c/a79e88dd2ca6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


