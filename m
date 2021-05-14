Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E784380126
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 02:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhENAbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 20:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229956AbhENAbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 20:31:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 602E461405;
        Fri, 14 May 2021 00:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620952210;
        bh=9MFuNvGSOAwrodeAbdeG0i+f3QKA48tKobXyxMcysg8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JmNq7P0UlHpM4+B3x9XtTSnd+iy0TQc7Jct5IdYC0wJrVP6dyACU1KjCMfmrswERd
         Pe7dzvy50o4zU02vJhIWxnYFWA7JA10WNcd2WRLfAJhShAZ8Z9h1wNmYNkb0nw7OCS
         tzR4LAtLE/NqYBcObTXpOkSDLLYb6Tyh3e5iNzmV4RcWvkDSHK+9KkuSQimP8T/28Q
         QrU2SsbgldWTvz0hkcuEZWvcNSzct1s4NbO3wlAH3dRAJNd6RklsRfWCCKi+SKRJyh
         IN2ChCzxG3OIDwO1n8hAN4uBPq8AjnbnZfajfEP90T8sFEKNNrXEDEA4RNbf+Ft6eL
         NO0CMf74Dy2jQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5492D60A47;
        Fri, 14 May 2021 00:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 1/2] selftests/bpf: validate skeleton gen handles
 skipped fields
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162095221034.8993.13986640817268863049.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 00:30:10 +0000
References: <20210513233643.194711-1-andrii@kernel.org>
In-Reply-To: <20210513233643.194711-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 13 May 2021 16:36:42 -0700 you wrote:
> Adjust static_linked selftests to test a mix of global and static variables
> and their handling of bpftool's skeleton generation code.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/testing/selftests/bpf/prog_tests/static_linked.c  | 4 ++--
>  tools/testing/selftests/bpf/progs/linked_maps1.c        | 2 +-
>  tools/testing/selftests/bpf/progs/test_static_linked1.c | 2 +-
>  tools/testing/selftests/bpf/progs/test_static_linked2.c | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [v2,bpf-next,1/2] selftests/bpf: validate skeleton gen handles skipped fields
    https://git.kernel.org/bpf/bpf-next/c/9e9b451593b1
  - [v2,bpf-next,2/2] libbpf: reject static maps
    https://git.kernel.org/bpf/bpf-next/c/c1cccec9c636

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


