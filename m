Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F084A44E9F1
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhKLPXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:23:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhKLPW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 10:22:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C46F761039;
        Fri, 12 Nov 2021 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636730407;
        bh=BupmhtmIu0gjIqcH5mLgMP9lAuZOf0PLxLlfbquSS1k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TvU0PKAS+gdn6gZ+J1D5WLsZJ07krXNhGZrSeVnNAKbwyvaFbPkz0WhRqqVDjUyIN
         I+xA50VGNPRQE5YvwLj5VG5NwDPS/8XwZ1jL222kd8vz/BhKOdK3LUsejn5kFnsfxO
         joiM8akuHiI7rBVHGes1zpETkUZfYMbVClG8E25YPZm3Im2W912oRBeFzQ4FOEZ0Pe
         z/cqU74rgm7xfKl+6ujfh+OGD4uu29n2UMo84CQIHqwq4Bpn88vnEbP/O8kHSIWbpJ
         BhJGE1TBqqlKpZRWnLwb+Kg2zyTyt19R32JQvz31LyODfTmGbjjf/V1JVbvViHztKj
         9ZN7pMUKqlxTA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B705C609F7;
        Fri, 12 Nov 2021 15:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpf: Fix inner map state pruning regression.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163673040774.12963.2114401773647308255.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Nov 2021 15:20:07 +0000
References: <20211110172556.20754-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20211110172556.20754-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, lmb@cloudflare.com,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 10 Nov 2021 09:25:56 -0800 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Introduction of map_uid made two lookups from outer map to be distinct.
> That distinction is only necessary when inner map has an embedded timer.
> Otherwise it will make the verifier state pruning to be conservative
> which will cause complex programs to hit 1M insn_processed limit.
> Tighten map_uid logic to apply to inner maps with timers only.
> 
> [...]

Here is the summary with links:
  - [bpf] bpf: Fix inner map state pruning regression.
    https://git.kernel.org/bpf/bpf/c/b5634057b30f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


