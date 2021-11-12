Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7220144EAEB
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 17:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbhKLQC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 11:02:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229841AbhKLQC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 11:02:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B66C360F5B;
        Fri, 12 Nov 2021 16:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636732807;
        bh=PL2Ra1DzFzkfrpn2P81zJriwN/JiumNQ1gdK3BFiY6E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bTVpn9Ackn407AQI48LTTvJTnjZGryEp24aXXwFM/nik8KyUYHYlia3kF+zGxk3e5
         e99XynmSt9WfuA4+uG0MOAQfPM+BCr5N+R54Ogn1wp6h0rN6PrsR/006au0EjlPhJJ
         SNdrYJ3oik2Aa4HNcPh7upPN0ilIbUfwxjzHaPkgFO/P2g8xUIWnAhio4SO+XIDTap
         qMbN4TQlFZ3ptcQ3gMf0xWwav2GAlAfo8AWUIOQjdxGywA+zURUjkXE/+xrxeR7vVd
         VdpshZN9Q+fMMKD0Ql07LZBCh9MQ1/GqH2g9EvQPMp62uOtsbfBuBoH/Wqxw3JwzD6
         Q/5u62GMsDQOQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A9B6A60A0C;
        Fri, 12 Nov 2021 16:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] bpftool: enable libbpf's strict mode by default
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163673280769.32385.11029693657467793782.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Nov 2021 16:00:07 +0000
References: <20211110192324.920934-1-sdf@google.com>
In-Reply-To: <20211110192324.920934-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, quentin@isovalent.com,
        john.fastabend@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 10 Nov 2021 11:23:24 -0800 you wrote:
> Otherwise, attaching with bpftool doesn't work with strict section names.
> 
> Also:
> 
> - add --legacy option to switch back to pre-1.0 behavior
> - print a warning when program fails to load in strict mode to point
>   to --legacy flag
> - by default, don't append / to the section name; in strict
>   mode it's relevant only for a small subset of prog types
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] bpftool: enable libbpf's strict mode by default
    https://git.kernel.org/bpf/bpf-next/c/314f14abdeca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


