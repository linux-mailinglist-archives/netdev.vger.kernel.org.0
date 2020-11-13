Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85612B1380
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgKMAuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:50:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:55746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKMAuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 19:50:24 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605228623;
        bh=Xd5YokKq6qMNa2AmgSJpvd4K27kZW++ocW2O0TBaN0Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KqhUIIpiGFZrKjqFtkgM5TP7U+iOc1h8K+W6vMrzsFYIF/YmPxah8yYKJJpkhzg2K
         FaQoLzjkFrHx9E5IOvCXKy40vqU+mEcTrsHPtmsDfNKueDAWT4LmWm+S9e/gcxnF9t
         7XPrs/WUU7Tt9m/KPSO51Ggn1nSISNPHoZfmZiic=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: Pointers beyond packet end.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160522862359.16152.6052930683052275005.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Nov 2020 00:50:23 +0000
References: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 10 Nov 2020 19:12:10 -0800 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> v1->v2:
> - removed set-but-unused variable.
> - added Jiri's Tested-by.
> 
> In some cases LLVM uses the knowledge that branch is taken to optimze the code
> which causes the verifier to reject valid programs.
> Teach the verifier to recognize that
> r1 = skb->data;
> r1 += 10;
> r2 = skb->data_end;
> if (r1 > r2) {
>   here r1 points beyond packet_end and subsequent
>   if (r1 > r2) // always evaluates to "true".
> }
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,1/3] bpf: Support for pointers beyond pkt_end.
    https://git.kernel.org/bpf/bpf-next/c/6d94e741a8ff
  - [v2,bpf-next,2/3] selftests/bpf: Add skb_pkt_end test
    https://git.kernel.org/bpf/bpf-next/c/9cc873e85800
  - [v2,bpf-next,3/3] selftests/bpf: Add asm tests for pkt vs pkt_end comparison.
    https://git.kernel.org/bpf/bpf-next/c/cb62d34019d9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


