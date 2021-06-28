Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7083B5F5D
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 15:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhF1Nwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 09:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232095AbhF1Nw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 09:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2BA2D61C77;
        Mon, 28 Jun 2021 13:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624888203;
        bh=9HPRI9DaXKR/s8cm3cxQYIMeQMrbIEzHSAlcbNsfFgQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BNQP+2nPE3tiYWw6ZRmWq6VFn8QRxTvXTjNxtRGpYe5bHWRubjWlQQ8+iJTpXseCh
         pJ5q066kk+Qs+Yl3zpuR30coqEClne2oXR8xeRYq2mAQaULl+BWwMCsqdyY+Jsi1dB
         pCL+5+Lr9clRYyW8yTOIa7siz6PuMa5OjvCAyx+0kMoF77e53VJOSEY0KykX4oSl56
         LZyq4jdhrtFsBOwGifKnLF8KhXfHWS6zG6Idb8W05QhAE58h5a6MJPS7P/nnMtBxWs
         KV6Y9nzXdablHKt4mu764td4RVopPC3MHA4ReDdmhXJzzXJCkydA62spvDcR8kCMIV
         Pm5c9wgIrLOaw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1DB2260A3A;
        Mon, 28 Jun 2021 13:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: Allow bpf_get_current_ancestor_cgroup_id for tracing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162488820311.25678.12475103487123481913.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 13:50:03 +0000
References: <20210627153627.824198-1-namhyung@kernel.org>
In-Reply-To: <20210627153627.824198-1-namhyung@kernel.org>
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, acme@kernel.org,
        jolsa@redhat.com, rostedt@goodmis.org, mingo@kernel.org,
        irogers@google.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Sun, 27 Jun 2021 08:36:27 -0700 you wrote:
> Allow the helper to be called from tracing programs.  This is needed
> to handle cgroup hiererachies in the program.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/bpf_trace.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - bpf: Allow bpf_get_current_ancestor_cgroup_id for tracing
    https://git.kernel.org/bpf/bpf-next/c/95b861a7935b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


