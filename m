Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4B528AB5C
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 03:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgJLBUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 21:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727260AbgJLBUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 21:20:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602465603;
        bh=EdKWLWUQZTngeZnTH/B9h8xgH3HT0MewHDyVqYC/23c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bf1Aw53Fqfs2MXrC+SIyRmBsgjW3Np9q91mfbMq6l+uDeEq+dJ4vcDiPEd+XtgkC2
         GPGLaAUqcptmbRjQCqyfW2p8wzA/08p9OSJS0p/TGKleIyFVt69/+0GpKIlx1Yf2YT
         2OQorBAdBRgi+f3K8EH+RNTHplL9wZQJwQb9N3KA=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [bpf-next PATCH 0/4] bpf, sockmap: allow verdict only sk_skb progs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160246560381.10468.3055026584438691079.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Oct 2020 01:20:03 +0000
References: <160239226775.8495.15389345509643354423.stgit@john-Precision-5820-Tower>
In-Reply-To: <160239226775.8495.15389345509643354423.stgit@john-Precision-5820-Tower>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Sat, 10 Oct 2020 22:08:29 -0700 you wrote:
> This allows a sockmap sk_skb verdict programs to run without a parser. For
> some use cases, such as verdict program that support streaming data or a
> l3/l4 proxy that does not use data in packet, loading the nop parser
> 'return skb->len' is an extra unnecessary complexity. With this series we
> simply call the verdict program directly from data_ready instead of
> bouncing through the strparser logic.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/4] bpf, sockmap: check skb_verdict and skb_parser programs explicitly
    https://git.kernel.org/bpf/bpf-next/c/743df8b7749f
  - [bpf-next,2/4] bpf, sockmap: Allow skipping sk_skb parser program
    https://git.kernel.org/bpf/bpf-next/c/ef5659280eb1
  - [bpf-next,3/4] bpf, selftests: Add option to test_sockmap to omit adding parser program
    https://git.kernel.org/bpf/bpf-next/c/cdf43c4bfa1a
  - [bpf-next,4/4] bpf, selftests: Add three new sockmap tests for verdict only programs
    https://git.kernel.org/bpf/bpf-next/c/a24fb420a577

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


