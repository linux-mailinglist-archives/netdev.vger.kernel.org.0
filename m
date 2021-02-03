Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FE930E442
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhBCUvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 15:51:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232608AbhBCUur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 15:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 005A664F7E;
        Wed,  3 Feb 2021 20:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612385407;
        bh=NT8HrXI4fXmk3jqxMrnzHBAXe64jbdpAS0IFdSI+89k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KsZHGOBK9x18lfH2CzRIiNcDxk3G1QUBtTHgcRa5i4d4q2n6tD3vz2iQ3sNGnZ1Wr
         cJI5IBdpsk/KkrA0WeYPrlVbwhPt1gN5v/H+XZ6c+CBO35euy4rqL7ytcFHra+QXRF
         KuX1QZa1VDdKcVS2VJhnsB1I+ZkWqXys30zWmRCKBX5/65ZnSweIfPnF09XlBTexA0
         TitY7IHegy8r0zBVHAeJaku3YSumXxaZybudJdaiTrq7ZkfQ3PhMcsUeENZe1PARnn
         Ktyv/FXPcKEogHPpnrI/W+rVZHRM3ZGS9rxxvgrlEprPP9ADoF8MLRGelqXrHErr6Z
         IlBcZDGyqU3kQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E74C4609E5;
        Wed,  3 Feb 2021 20:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: Check for integer overflow when using
 roundup_pow_of_two()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161238540694.20292.1378146389500411389.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Feb 2021 20:50:06 +0000
References: <20210127063653.3576-1-minhquangbui99@gmail.com>
In-Reply-To: <20210127063653.3576-1-minhquangbui99@gmail.com>
To:     Bui Quang Minh <minhquangbui99@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed, 27 Jan 2021 06:36:53 +0000 you wrote:
> On 32-bit architecture, roundup_pow_of_two() can return 0 when the argument
> has upper most bit set due to resulting 1UL << 32. Add a check for this
> case.
> 
> Fixes: d5a3b1f ("bpf: introduce BPF_MAP_TYPE_STACK_TRACE")
> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
> 
> [...]

Here is the summary with links:
  - bpf: Check for integer overflow when using roundup_pow_of_two()
    https://git.kernel.org/bpf/bpf/c/6183f4d3a0a2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


