Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE102D459B
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgLIPkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729864AbgLIPkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 10:40:49 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607528408;
        bh=ENzQseSpwLC+UlxidcAUN1RJneqHZ/Lzqb+IrjF1GEI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=djCaFAgycIX1SwwgIHg55OiHNJNddqlUO0w3xX+7lpks6e5duKlrmYq0oK17ytnOd
         udzKtVKXuv6EQnI849kMZ9zG5ScmEdTns1d89j9YQ7nHZXis3H4NBU5REUN4dUJFJ7
         qtiqP1kpGVEw4WtBQbFIh0kVOG9XUKoVSWNZ2/blWELVsL+PnuwQ0feFJ7FstfL/oo
         1bLsbUV6HfaMTaHqNAgl9A95yXQ6zPSi+9gOa/hMEvitAHOaeRPcZ0t19otgVwOQhl
         wjcxlYyIE/f9VZ5kNE+s4u4FG7DoY26fqguNS9FFBtvsMFskrWrb2XRb7vWc7igQMm
         MnGldRaRV+VFA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v4 0/7] selftests/bpf: Restore test_offload.py to working
 order
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160752840844.5298.9932139292063598694.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Dec 2020 15:40:08 +0000
References: <160752225643.110217.4104692937165406635.stgit@toke.dk>
In-Reply-To: <160752225643.110217.4104692937165406635.stgit@toke.dk>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     kuba@kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        ast@kernel.org, andriin@fb.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, hawk@kernel.org, mst@redhat.com,
        romain.perier@gmail.com, apais@linux.microsoft.com,
        grygorii.strashko@ti.com, simon.horman@netronome.com,
        gustavoars@kernel.org, lorenzo@kernel.org, weiyongjun1@huawei.com,
        jbenc@redhat.com, oss-drivers@netronome.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (refs/heads/master):

On Wed, 09 Dec 2020 14:57:36 +0100 you wrote:
> This series restores the test_offload.py selftest to working order. It seems a
> number of subtle behavioural changes have crept into various subsystems which
> broke test_offload.py in a number of ways. Most of these are fairly benign
> changes where small adjustments to the test script seems to be the best fix, but
> one is an actual kernel bug that I've observed in the wild caused by a bad
> interaction between xdp_attachment_flags_ok() and the rework of XDP program
> handling in the core netdev code.
> 
> [...]

Here is the summary with links:
  - [bpf,v4,1/7] xdp: remove the xdp_attachment_flags_ok() callback
    https://git.kernel.org/bpf/bpf/c/998f17296234
  - [bpf,v4,2/7] selftests/bpf/test_offload.py: Remove check for program load flags match
    https://git.kernel.org/bpf/bpf/c/0b5b6e747c86
  - [bpf,v4,3/7] netdevsim: Add debugfs toggle to reject BPF programs in verifier
    https://git.kernel.org/bpf/bpf/c/e4ff5aa46940
  - [bpf,v4,4/7] selftests/bpf/test_offload.py: only check verifier log on verification fails
    https://git.kernel.org/bpf/bpf/c/d8b5e76ae4e0
  - [bpf,v4,5/7] selftests/bpf/test_offload.py: fix expected case of extack messages
    https://git.kernel.org/bpf/bpf/c/852c2ee338f0
  - [bpf,v4,6/7] selftests/bpf/test_offload.py: reset ethtool features after failed setting
    https://git.kernel.org/bpf/bpf/c/766e62b7fcd2
  - [bpf,v4,7/7] selftests/bpf/test_offload.py: filter bpftool internal map when counting maps
    https://git.kernel.org/bpf/bpf/c/8158cad13435

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


