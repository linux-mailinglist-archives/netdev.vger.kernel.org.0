Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC3732421D
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 17:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbhBXQcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 11:32:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234550AbhBXQa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 11:30:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 97F2D64EF5;
        Wed, 24 Feb 2021 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614184207;
        bh=OMhXm5ZVyPVie1aLAhvh4d2VYevjXQzY2G8Smlm23GU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EyHPM90NueT4KwbJipUNDgDCH52VqIDo1do7Za+OZpezopDkptXNMFkneVbotuAEY
         7LoVvY4IOUJcohMv32ofoijbLwZEQwdG8ho0AGBqE6giF+almblhXHz+1B3chVeQTr
         F7LZaZw+m+B0TfYrreSwMs37+XtCZdRDucuxvUnAYzg0lqT67XjRarBUGKtzX3wfXm
         VqsuESZTMYoN5a0vc91xUeMRScoKQMMDk3qHV/NNpEnbWbJfKKi976Flite6daFfGg
         51RuOGwrjHcpE34VG5KoUQFFMralAXXjzobQyURSZ/MzEANf+X2e3TgKu2eXZkDtiy
         TPAlqo/tnfjFQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8511A609F2;
        Wed, 24 Feb 2021 16:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 bpf-next] bpf: remove blank line in bpf helper description
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161418420754.20888.13845403637156552812.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Feb 2021 16:30:07 +0000
References: <20210223131457.1378978-1-liuhangbin@gmail.com>
In-Reply-To: <20210223131457.1378978-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        brouer@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue, 23 Feb 2021 21:14:57 +0800 you wrote:
> Commit 34b2021cc616 ("bpf: Add BPF-helper for MTU checking") added an
> extra blank line in bpf helper description. This will make
> bpf_helpers_doc.py stop building bpf_helper_defs.h immediately after
> bpf_check_mtu, which will affect future add functions.
> 
> Fixes: 34b2021cc616 ("bpf: Add BPF-helper for MTU checking")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [PATCHv2,bpf-next] bpf: remove blank line in bpf helper description
    https://git.kernel.org/bpf/bpf/c/a7c9c25a99bb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


