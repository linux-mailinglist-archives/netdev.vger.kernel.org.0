Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8F13F0E4A
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 00:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhHRWkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 18:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232456AbhHRWkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 18:40:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 33D0A6108B;
        Wed, 18 Aug 2021 22:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629326406;
        bh=rpH07toMkyUa4SU29qgQ5rbYk0DjTSEbT1X0U1mDRts=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OHGUzGE+sxlmXXSLaAXwOxb2wkIbkJQ2z/+CaZIEsIlTQdy+UJzWM57jutW8qml76
         aHmHJVnelqICzA3oNQhTRzC88YDd5IdQLhcC8xC1csQdquKKvSnyUu+BY8w0T7jLGf
         ZYULqcvzwcQI2wqXllEvoaszLgas8TckLsXqgZZ2V2nvv17/WPei2Guv5nwgd4Uj4X
         zxZs/jPTGm5hPMSrNWAPdMeY81IrguyKs0kMd1dP+7r12u7igISFwdAzb2+x6e7Zsw
         93usWvfFnsxhXQHIfMw8tmINLEUszmlGTCr6RF+VKcxagD+Uhk20VWbkoO+WcwjxOO
         LH8TZZSs/dMmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 26E6060A2E;
        Wed, 18 Aug 2021 22:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/2] bpf: Allow bpf_get_netns_cookie in
 BPF_PROG_TYPE_SOCK_OPS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162932640615.7744.7394691791287169298.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 22:40:06 +0000
References: <20210818105820.91894-1-liuxu623@gmail.com>
In-Reply-To: <20210818105820.91894-1-liuxu623@gmail.com>
To:     Xu Liu <liuxu623@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 18 Aug 2021 18:58:18 +0800 you wrote:
> v2: Added selftests
> 
> Xu Liu (2):
>   bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SOCK_OPS
>   selftests/bpf: Test for get_netns_cookie
> 
>  net/core/filter.c                             | 14 +++++
>  .../selftests/bpf/prog_tests/netns_cookie.c   | 61 +++++++++++++++++++
>  .../selftests/bpf/progs/netns_cookie_prog.c   | 39 ++++++++++++
>  3 files changed, 114 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/netns_cookie.c
>  create mode 100644 tools/testing/selftests/bpf/progs/netns_cookie_prog.c

Here is the summary with links:
  - [bpf-next,v2,1/2] bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SOCK_OPS
    https://git.kernel.org/bpf/bpf-next/c/6cf1770d63dd
  - [bpf-next,v2,2/2] selftests/bpf: Test for get_netns_cookie
    https://git.kernel.org/bpf/bpf-next/c/374e74de9631

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


