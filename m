Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C352E02DD
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 00:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgLUXUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 18:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgLUXUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 18:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D708722B2B;
        Mon, 21 Dec 2020 23:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608592806;
        bh=gK1v5qqxd6m3tc6iP+qCwFz0RPLnflRc1oB2q97r2nE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XsX5c/o4CMSp2kF66P+KtcWgAb5JJW/tVbSLojFeI7Piar1YDnWV68W0g9HBdi65p
         qMIVzd24+muJ/qWjQ3v2d67kXuwdHWDEbhwW+HkmSsoxeNwafahLrksX5JFHyWsziy
         Z6o9zOWWgtrSHSBcxhmwwQbz/dD1rInR1n/YpPiQbZXqARqhjOF2MCpZKy0ffvcEC4
         Ou3favpEC4mMAf2y2L7Qp0ueIDxtatwxAWvUe07R33L5kd/rg2EweCtINkezeTYYsj
         hWjL9jl12XL3Bi9asFH7NtGx+VaCXtsHojSndjtbs9OGL2apBOtyt4PlSg6FMCo2fh
         +OXMxQj7On7nQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id CDF97603F8;
        Mon, 21 Dec 2020 23:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpf: add schedule point in htab_init_buckets()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160859280683.6367.2124284778827327704.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Dec 2020 23:20:06 +0000
References: <20201221192506.707584-1-eric.dumazet@gmail.com>
In-Reply-To: <20201221192506.707584-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, bpf@vger.kernel.org,
        jsperbeck@google.com, songliubraving@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Mon, 21 Dec 2020 11:25:06 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We noticed that with a LOCKDEP enabled kernel,
> allocating a hash table with 65536 buckets would
> use more than 60ms.
> 
> htab_init_buckets() runs from process context,
> it is safe to schedule to avoid latency spikes.
> 
> [...]

Here is the summary with links:
  - [bpf] bpf: add schedule point in htab_init_buckets()
    https://git.kernel.org/bpf/bpf/c/e7e518053c26

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


