Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DD53319B3
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 22:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhCHVu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 16:50:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232086AbhCHVuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 16:50:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0EF8865253;
        Mon,  8 Mar 2021 21:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615240208;
        bh=xDeWOxAckgx6RrgEbP2YW8WLHfyiP9s2ztk/gN1CayE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SL9e+53alxH491rgE5ufIrI+npEyHa9dDZQbNAVt8dZd46AEuk5N66AoyU0vQ3shI
         mIJ3wSabE5d0h23CJpoD/9Td85tNVs8YA9DnydqORUmL4ao6JWECCGy+WjTzoOUHCh
         OdRDEr5durBXlvJ5J2uj+eMUUD0LOKXTJEUKswH+o5EBlDq/2IhKEO9sX1vdlw3GIg
         yOfI7aIIGLvqTXwQIelSz+w33bCP24iV9NBWkmGMV2tiKiClx2BZZ9ntVaKwc+tAoh
         cIq8UiYsNxWJREHWWcyfpBuk8NK+ThyMkQ5pwd85UmwhNnfxI0DTwVHGwf9OUFRIKE
         phTLRXjZ1Whyg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 01AF760952;
        Mon,  8 Mar 2021 21:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf V3 0/2] bpf: Updates for BPF-helper bpf_check_mtu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161524020800.4974.10097073720039114900.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Mar 2021 21:50:08 +0000
References: <161521552920.3515614.3831682841593366034.stgit@firesoul>
In-Reply-To: <161521552920.3515614.3831682841593366034.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        borkmann@iogearbox.net, alexei.starovoitov@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (refs/heads/master):

On Mon, 08 Mar 2021 15:59:13 +0100 you wrote:
> The FIB lookup example[1] show how the IP-header field tot_len
> (iph->tot_len) is used as input to perform the MTU check. The recently
> added MTU check helper bpf_check_mtu() should also support this type
> of MTU check.
> 
> Lets add this feature before merge window, please. This is a followup
> to 34b2021cc616 ("bpf: Add BPF-helper for MTU checking").
> 
> [...]

Here is the summary with links:
  - [bpf,V3,1/2] bpf: BPF-helper for MTU checking add length input
    https://git.kernel.org/bpf/bpf/c/e5e35e754c28
  - [bpf,V3,2/2] selftests/bpf: Tests using bpf_check_mtu BPF-helper input mtu_len param
    https://git.kernel.org/bpf/bpf/c/e5e010a3063a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


