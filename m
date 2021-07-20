Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2181F3D0394
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 23:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhGTUX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 16:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234895AbhGTUTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 16:19:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 484766108B;
        Tue, 20 Jul 2021 21:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626814805;
        bh=WxMeLILetqKHSu3Ff6iGX+X8CqMXnNbq3/InNkGye1M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QpSKs/P6Udh3Sw9AhM4LZAZDuyNNYbnHVy6gZczUD/+u2aEPT4aaby6TVv7GDuXy9
         6Iro38KM5HhxCjiZPYMVJAyzP/a3Kl47fLfPlXv5mYy9RzomP//FJQIpN6yblwD6S5
         XHaKFXLicrQ1kEP2T2CJyy0BL92V16kiVfz8jkyf0LXUPJOxrv4PAzusWGsnHZdADv
         fi2ip1hSv7b4rcJ9ZlhELyuhLejGb94FGozoYwbUop5hc1KYuLH1chtxq4ScrufV44
         Wrxrd9x5sQKY13UJ/cTYsXDVQBzK1hYONa72T9l/o7LgK5EBKpwnwBtP3/CJ1KZx1I
         /zF9P6qUbxkAw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 39F9E60A5C;
        Tue, 20 Jul 2021 21:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 0/3] libbpf: btf typed data dumping fixes
 (__int128 usage, error propagation)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162681480523.17696.5006485416633503610.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 21:00:05 +0000
References: <1626770993-11073-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1626770993-11073-1-git-send-email-alan.maguire@oracle.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 20 Jul 2021 09:49:50 +0100 you wrote:
> This series aims to resolve further issues with the BTF typed data
> dumping interfaces in libbpf.
> 
> Compilation failures with use of __int128 on 32-bit platforms were
> reported [1].  As a result, the use of __int128 in libbpf typed data
> dumping is replaced with __u64 usage for bitfield manipulations.
> In the case of 128-bit integer values, they are simply split into
> two 64-bit hex values for display (patch 1).
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,1/3] libbpf: avoid use of __int128 in typed dump display
    https://git.kernel.org/bpf/bpf-next/c/a1d3cc3c5eca
  - [v2,bpf-next,2/3] selftests/bpf: add __int128-specific tests for typed data dump
    https://git.kernel.org/bpf/bpf-next/c/a17553dde294
  - [v2,bpf-next,3/3] libbpf: propagate errors when retrieving enum value for typed data display
    https://git.kernel.org/bpf/bpf-next/c/720c29fca9fb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


