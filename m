Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A169438076
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhJVXMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231134AbhJVXMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:12:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F382560F25;
        Fri, 22 Oct 2021 23:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634944207;
        bh=5xYKVWnMh6ZunL8Pv3pRq8PpMAvPwX/8WNtzzuZ2RC4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oySeyaHEI+Hgz/yuKCz8HWHhDt5YUfJWlU/BVoYyg01IquWK9A3g7AAJ3v2G+6T5j
         m4rqYx9TApqLsMaPBjqlWNBO2PHljtzCNUfOH0qsgg1Ipavzha0CMm4lAOtrwLNe9A
         vqnSaMwmadK/cZEoptlLovAkhKCI+evX2896xrMskFE3q4DbqJymjLEcBIRSKBcAq7
         uc0sWSe5CHJgTfKN/nVRksXM+uAFLYdkqym4ZLIJnavw1YzePngRwOZfRkSjUoiBHZ
         iaQ+yljs4+xyeh6Xix4kiaUkPZSteQK7che9CjHyChRmQdeHBlTWRROsllY6r8+hnL
         zazOHz4DR4V7Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E62C2609E2;
        Fri, 22 Oct 2021 23:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] libbpf: fix memory leak in btf__dedup()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163494420693.19598.6158579807891111574.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Oct 2021 23:10:06 +0000
References: <20211022202035.48868-1-mauricio@kinvolk.io>
In-Reply-To: <20211022202035.48868-1-mauricio@kinvolk.io>
To:     =?utf-8?q?Mauricio_V=C3=A1squez_=3Cmauricio=40kinvolk=2Eio=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Fri, 22 Oct 2021 15:20:35 -0500 you wrote:
> Free btf_dedup if btf_ensure_modifiable() returns error.
> 
> Fixes: 919d2b1dbb07 ("libbpf: Allow modification of BTF and add btf__add_str API")
> 
> Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
> ---
>  tools/lib/bpf/btf.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [bpf-next] libbpf: fix memory leak in btf__dedup()
    https://git.kernel.org/bpf/bpf-next/c/1000298c7683

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


