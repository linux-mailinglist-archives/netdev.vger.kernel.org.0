Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E752731A8BD
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhBMAUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:20:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229903AbhBMAUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 19:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 455DD64EA0;
        Sat, 13 Feb 2021 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613175609;
        bh=A4jer86Cc9fL9qc19r8SQiSGOBNrgfoe3WMMmyDsMVg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bO6ONXXco2qEOxK+ow7/pa66iZ/5Z/fuwfwbDS/zeWaJi040i6XwW/nUYq7eSEwoS
         318f2PbOjEyaKVfd678pSCvhT6rfHrQGOZrepy8NQnWbPhB/cfwoHgkN5gJkq9Rcx9
         750wUYivI00IKn5bSzraSUhuFxC2WPm/yHY+z0bjeFaUSmZa84G81MiSX6FbYTnwhu
         lC/ZHtysjwzkomB2hBG5BqLi1+YwDumH1DzP5KpAWOHPK+nAe7jSyMC3WPb95EHLzN
         KUOhOurvDM0TqSynbyNnUhYbokKgeH4F8mUzHwdjdqzDayUk3Xq3iVOhsdB/dZdVmY
         PF4TBi04AclzA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3784160A2A;
        Sat, 13 Feb 2021 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next V16 0/7] bpf: New approach for BPF MTU handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161317560922.26527.12147444743341964387.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Feb 2021 00:20:09 +0000
References: <161287779408.790810.15631860742170694244.stgit@firesoul>
In-Reply-To: <161287779408.790810.15631860742170694244.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        borkmann@iogearbox.net, alexei.starovoitov@gmail.com,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        lorenzo@kernel.org, marek@cloudflare.com, john.fastabend@gmail.com,
        kuba@kernel.org, eyal.birger@gmail.com, colrack@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 09 Feb 2021 14:38:04 +0100 you wrote:
> This patchset drops all the MTU checks in TC BPF-helpers that limits
> growing the packet size. This is done because these BPF-helpers doesn't
> take redirect into account, which can result in their MTU check being done
> against the wrong netdev.
> 
> The new approach is to give BPF-programs knowledge about the MTU on a
> netdev (via ifindex) and fib route lookup level. Meaning some BPF-helpers
> are added and extended to make it possible to do MTU checks in the
> BPF-code.
> 
> [...]

Here is the summary with links:
  - [bpf-next,V16,1/7] bpf: Remove MTU check in __bpf_skb_max_len
    https://git.kernel.org/bpf/bpf-next/c/6306c1189e77
  - [bpf-next,V16,2/7] bpf: fix bpf_fib_lookup helper MTU check for SKB ctx
    https://git.kernel.org/bpf/bpf-next/c/2c0a10af688c
  - [bpf-next,V16,3/7] bpf: bpf_fib_lookup return MTU value as output when looked up
    https://git.kernel.org/bpf/bpf-next/c/e1850ea9bd9e
  - [bpf-next,V16,4/7] bpf: add BPF-helper for MTU checking
    https://git.kernel.org/bpf/bpf-next/c/34b2021cc616
  - [bpf-next,V16,5/7] bpf: drop MTU check when doing TC-BPF redirect to ingress
    https://git.kernel.org/bpf/bpf-next/c/5f7d57280c19
  - [bpf-next,V16,6/7] selftests/bpf: use bpf_check_mtu in selftest test_cls_redirect
    https://git.kernel.org/bpf/bpf-next/c/6b8838be7e21
  - [bpf-next,V16,7/7] selftests/bpf: tests using bpf_check_mtu BPF-helper
    https://git.kernel.org/bpf/bpf-next/c/b62eba563229

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


