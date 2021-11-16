Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2084532FF
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 14:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236648AbhKPNnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 08:43:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236765AbhKPNnG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 08:43:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 337E461B49;
        Tue, 16 Nov 2021 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637070009;
        bh=37tZG4elhoAdWVqcl+AIV4z56JHbTshGPOqSm4iZCfM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rwXUdLCKWzM8MefDOObe+lsuScAjOl5EQGc6MjUAMqhMY6yEkiF2uZwCix1zDM5qf
         hx7VAbmfJUZATkc1qzkcghYveFynEDycdjKvMH/HmYeZSR+COZrQ9iUSlqXBUOyENj
         zrt1DiGrnDrqtD8PkFffIemUU8ZuyKv0AC38vt/uwjmro28a+sDjoAMMvdo8kH7WJm
         ktT2tuXHdDcxic+e4FpVH+TdJV8TIfCoja1UES5QS4Wx8s3DplziazZOOgD+9kc4i/
         wJpkWlSUGZJt8rD0aXI25KQIheQ4I94mKykrPuEUWM13xh+MZnjpI4GEQuAmz4U1KN
         zWM0qJ3JBKBYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 27FD160A49;
        Tue, 16 Nov 2021 13:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v6] bpf: Change value of MAX_TAIL_CALL_CNT from 32 to
 33
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163707000915.28808.15563696632863009519.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Nov 2021 13:40:09 +0000
References: <1636075800-3264-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1636075800-3264-1-git-send-email-yangtiezhu@loongson.cn>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, lixuefeng@loongson.cn,
        johan.almbladh@anyfinetworks.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, illusionist.neo@gmail.com, zlim.lnx@gmail.com,
        naveen.n.rao@linux.ibm.com, luke.r.nels@gmail.com,
        xi.wang@gmail.com, bjorn@kernel.org, iii@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, udknight@gmail.com,
        davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri,  5 Nov 2021 09:30:00 +0800 you wrote:
> In the current code, the actual max tail call count is 33 which is greater
> than MAX_TAIL_CALL_CNT (defined as 32), the actual limit is not consistent
> with the meaning of MAX_TAIL_CALL_CNT, there is some confusion and need to
> spend some time to think about the reason at the first glance.
> 
> We can see the historical evolution from commit 04fd61ab36ec ("bpf: allow
> bpf programs to tail-call other bpf programs") and commit f9dabe016b63
> ("bpf: Undo off-by-one in interpreter tail call count limit").
> 
> [...]

Here is the summary with links:
  - [bpf-next,v6] bpf: Change value of MAX_TAIL_CALL_CNT from 32 to 33
    https://git.kernel.org/bpf/bpf-next/c/ebf7f6f0a6cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


