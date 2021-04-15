Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12435361447
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236219AbhDOVkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 17:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236148AbhDOVkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 17:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 84BF5610CC;
        Thu, 15 Apr 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618522809;
        bh=AinOT/YfM148cjBjj0Zpcr1i5gy+AuLqehfsOo+NC3A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eqhJ5h6+enisF74bb2ZZMthC2/RSsplIavkxwxoiQsACtRBStW8Z7gREnSLIfWu69
         adjtinmBpXkG+x/I/eX9Aw1FPo85J+lrgtyMhv+ye+qRS/ITy0GREByx+f8QeU5Fk8
         yoN6YbTCAMZxI4/QR/LXvapTl4s3qr+w6yY5/U96HFrUNqi8fVSNvEwB/MDq0cNaJn
         slJ36qKvOHps4V7h5mqygD/QfTeWGNwIZ0tTGLQ5jpjpop6ShTOeRKEU/qF4PXyHA0
         muSW7/m038uNipAR4WhcPaDsrO/CNw9csArcuO9jnQsz8jkxJjLo4Schjk7+Q+PclS
         29YgeoLdzY1yw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 70FFE60CD6;
        Thu, 15 Apr 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] i40e: fix the panic when running bpf in xdpdrv mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161852280945.6246.15751888474800396126.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Apr 2021 21:40:09 +0000
References: <20210414023428.10121-1-kerneljasonxing@gmail.com>
In-Reply-To: <20210414023428.10121-1-kerneljasonxing@gmail.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xingwanli@kuaishou.com, lishujin@kuaishou.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Apr 2021 10:34:28 +0800 you wrote:
> From: Jason Xing <xingwanli@kuaishou.com>
> 
> Fix this panic by adding more rules to calculate the value of @rss_size_max
> which could be used in allocating the queues when bpf is loaded, which,
> however, could cause the failure and then trigger the NULL pointer of
> vsi->rx_rings. Prio to this fix, the machine doesn't care about how many
> cpus are online and then allocates 256 queues on the machine with 32 cpus
> online actually.
> 
> [...]

Here is the summary with links:
  - [net,v3] i40e: fix the panic when running bpf in xdpdrv mode
    https://git.kernel.org/netdev/net/c/4e39a072a6a0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


