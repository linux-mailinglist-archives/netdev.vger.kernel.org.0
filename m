Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE598415296
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 23:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbhIVVVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 17:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238071AbhIVVVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 17:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C39A561107;
        Wed, 22 Sep 2021 21:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632345606;
        bh=w664FpmrmowUhcCmmUDVNbylaY3LbtUghqdC+fnWTEo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VpoT4XISYBN2QIGeeuT09KOtFxSoatbjocMf/xvE0E+mQanBkeQvVHJr2mo57xGyk
         XIhQKE4WbF4SHOpsl3+p8NQwCf3RouBb1sMG9NpHWlLXWQaI81gBfp1dF0Um5pmfwm
         u54JMCxoWubTGJ1ZnP4A20Fj/gjXv2V6m9M7+jrkegpwH4z8pacFoP46kTU0nkKe7Q
         mXG01Rtd4e4byMysvyaM8XSkhiUM9kbALrSxT75FbqwwaIMywPvVqUxEpvyWjWmu3d
         FYhcmyKNvuE0HAGSabDCr0vuTQYZXcEhigq049HfzgS1o5O4xq6Ef+hDIM8Vt2tAg+
         fmnMvvvvViMvg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B63BF60A88;
        Wed, 22 Sep 2021 21:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next] bpf: Document BPF licensing.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163234560674.6042.16266775340906798652.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Sep 2021 21:20:06 +0000
References: <20210917230034.51080-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20210917230034.51080-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Fri, 17 Sep 2021 16:00:34 -0700 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Document and clarify BPF licensing.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Acked-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Joe Stringer <joe@cilium.io>
> Acked-by: Lorenz Bauer <lmb@cloudflare.com>
> Acked-by: Dave Thaler <dthaler@microsoft.com>
> Acked-by: Stephen Hemminger <stephen@networkplumber.org>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Acked-by: KP Singh <kpsingh@kernel.org>
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next] bpf: Document BPF licensing.
    https://git.kernel.org/bpf/bpf-next/c/c86216bc96aa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


