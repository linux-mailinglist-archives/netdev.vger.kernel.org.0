Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9B3423E26
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 14:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238563AbhJFMwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 08:52:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhJFMv7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 08:51:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 194E661039;
        Wed,  6 Oct 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633524607;
        bh=pzsIB7UpOT0THyk19409PpMWyAd/f6qZTTR4CE2NX4w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f7hZLJzmGhS+v8H5F+LIKdVInK5ldouNIWL+F4XzbtzdVtzeqLWXtW2/bBSJEi3xl
         Sc32BiRjL/xAyW2G/kMAHP4+KtBK5OrKww/jPsmI9pSHYw0qm8BUQaV7hsapxILn2K
         hTcbRUTuaNR8QCn09Nl5NvNto1lUA9njpa0Hfvse9mN2403fUoVyJhzxXDYmmpruMe
         xsSVtSjTaN74w8oLpM8gCk0hLIohd8PoGPVDTXohvxSx5MmuaOFMc8yBnUy55AiFr4
         tz06E7fvvJCgRy7st8arx9+vF4C9oH/BFcssfP51FywyUdo/L0YoAg9VvHtkoCurLU
         dfvh082vkhr+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0969B6094F;
        Wed,  6 Oct 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v1] unix: fix an issue in unix_shutdown causing the other
 end read/write failures
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163352460703.1778.3585956058369560371.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 12:50:07 +0000
References: <20211004232530.2377085-1-jiang.wang@bytedance.com>
In-Reply-To: <20211004232530.2377085-1-jiang.wang@bytedance.com>
To:     Jiang Wang <jiang.wang@bytedance.com>
Cc:     bpf@vger.kernel.org, cong.wang@bytedance.com,
        casey@schaufler-ca.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com,
        christian.brauner@ubuntu.com, Rao.Shoaib@oracle.com,
        kuniyu@amazon.co.jp, jakub@cloudflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Mon,  4 Oct 2021 23:25:28 +0000 you wrote:
> Commit 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
> sets unix domain socket peer state to TCP_CLOSE
> in unix_shutdown. This could happen when the local end is shutdown
> but the other end is not. Then the other end will get read or write
> failures which is not expected.
> 
> Fix the issue by setting the local state to shutdown.
> 
> [...]

Here is the summary with links:
  - [bpf,v1] unix: fix an issue in unix_shutdown causing the other end read/write failures
    https://git.kernel.org/bpf/bpf/c/d0c6416bd709

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


