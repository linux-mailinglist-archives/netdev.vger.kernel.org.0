Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C83350A20
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhCaWUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhCaWUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:20:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E041361078;
        Wed, 31 Mar 2021 22:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617229214;
        bh=emkVMfPNBs6VfL684ehH4JMVFlgqaT3Etox40Szo5fc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ggfSqsxqY3UdBekUS7UQ+WrTQDNqajcwkk6yfCx+rmWlEWOtOj34DM5BTy7gHe7gd
         8PEyr+YhqSfNIhu/2ZfSHXaE0npMKXqHZ8ucfLlz8Obam6EmcSb9Sn++SzowpN9/Ou
         osec4i+x86CM/UNIz4GvbmQwoVDBkDbU3Rwfs4TM5Ecdxb+UJNJQ4wDBhBvjB1+NnA
         s+cjOmAq7PPMGmszMG2kDLcUQfyLyUbzU4AL0nAxAhf13hS9who4+vmJ345iBdi+VF
         QYYmdfNJc28KXZRNHOj7xFZJsj2hqIdKbK9mr+cghZn5j4ushOaJ6tS/acFRVOHg2v
         iagDefN6srTHw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D4A6D608FA;
        Wed, 31 Mar 2021 22:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/1] xdp: fix xdp_return_frame() kernel BUG throw for
 page_pool memory model
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722921486.2890.11294519050752062288.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 22:20:14 +0000
References: <20210331132503.15926-1-boon.leong.ong@intel.com>
In-Reply-To: <20210331132503.15926-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        makita.toshiaki@lab.ntt.co.jp, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 31 Mar 2021 21:25:03 +0800 you wrote:
> xdp_return_frame() may be called outside of NAPI context to return
> xdpf back to page_pool. xdp_return_frame() calls __xdp_return() with
> napi_direct = false. For page_pool memory model, __xdp_return() calls
> xdp_return_frame_no_direct() unconditionally and below false negative
> kernel BUG throw happened under preempt-rt build:
> 
> [  430.450355] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/3884
> [  430.451678] caller is __xdp_return+0x1ff/0x2e0
> [  430.452111] CPU: 0 PID: 3884 Comm: modprobe Tainted: G     U      E     5.12.0-rc2+ #45
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] xdp: fix xdp_return_frame() kernel BUG throw for page_pool memory model
    https://git.kernel.org/netdev/net/c/622d13694b5f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


