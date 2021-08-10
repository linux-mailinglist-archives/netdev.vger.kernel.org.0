Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287FD3E56AC
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238894AbhHJJVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238857AbhHJJU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 05:20:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3164D60720;
        Tue, 10 Aug 2021 09:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628587205;
        bh=atJY3YVgQQOrKO92x90PUN/0/7Wz+VRdq/HRkQ4i9RM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kGG8IRDsqugSk+2T2Vh27yV4ZPNiHBsro+hvtY0Yc8IatqSslchT1E5j7d8YZNiBJ
         cPvDls7qLzup9VLQjaVE05f5CRiarm+G2z+Azh2TmjhyNpoHF84Vil+e+/kMpaPqwM
         wOwPBMH6XC7E/yWikaSM3XgKey0cxoOjhNY7uC4lStGZNguygygw+NpfqFBYlPVRxx
         JXm97JUqyeGXAsTy1/RbLIDtK1dEgupZLH1RswnHyIGbLHhz9McI/rktFql9F4h+ez
         P5yuLOY0YodL+cqlPlOBtvZ3Lhbq3faAA+ZQMB2n7nN8/04Mlp7Cg6giiSAw08laYF
         0UQENZWSijfhQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1EA2160A3B;
        Tue, 10 Aug 2021 09:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] samples: bpf: add an explict comment to handle nested vlan
 tagging.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162858720512.16976.3579658391820845734.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Aug 2021 09:20:05 +0000
References: <20210809070046.32142-1-falakreyaz@gmail.com>
In-Reply-To: <20210809070046.32142-1-falakreyaz@gmail.com>
To:     Muhammad Falak R Wani <falakreyaz@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, kpsingh@kernel.org,
        yhs@fb.com, songliubraving@fb.com, kafai@fb.com,
        john.fastabend@gmail.com, hawk@kernel.org, kuba@kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon,  9 Aug 2021 12:30:46 +0530 you wrote:
> A codeblock for handling nested vlan trips newbies into thinking it as
> duplicate code. Explicitly add a comment to clarify.
> 
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
>  samples/bpf/xdp1_kern.c | 2 ++
>  samples/bpf/xdp2_kern.c | 2 ++
>  2 files changed, 4 insertions(+)

Here is the summary with links:
  - samples: bpf: add an explict comment to handle nested vlan tagging.
    https://git.kernel.org/bpf/bpf-next/c/d692a637b4c5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


