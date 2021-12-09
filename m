Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD9946E315
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 08:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbhLIHXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 02:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbhLIHXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 02:23:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA715C061746;
        Wed,  8 Dec 2021 23:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 03289CE24E6;
        Thu,  9 Dec 2021 07:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E30CC341CA;
        Thu,  9 Dec 2021 07:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639034409;
        bh=6/kEL/vxLq6HMreH4kJ6g4q4mgZ6JNAdEloe850tIfM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RwdkY9DKRqBHqV260LPI0X89FxrcMs4ulmEviSejHxM5ctCvgEWXiQ71BHm2xsRYQ
         JSdgEzYDTuZoFyBKHNhRKz75p5UbZf8s0KT2e+4pat1PhBX1JeRtZTwE3kwWoBUSWr
         FR62dXxOueJA+pJWzmeopBttm+3CEk7nrHoPSSlk8kTt4zJ7hZHe0gVLgBmCGfn4VH
         dUhuG89xKynA/TzJpQhpDePe3896oQauTkKBEPJEWsYI/Slao2kho3Jiuz5+9TNijG
         iPRj/fdT4FCFEoCpeSiB0CQLpSLk09U5SwonsNYGD1vDxBTiyHU64WkFh6n1vUF4A9
         KAtnP+Gpby65A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1529C60A4D;
        Thu,  9 Dec 2021 07:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: remove redundant assignment to pointer t
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163903440908.13982.14751517115928786084.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 07:20:09 +0000
References: <20211207224718.59593-1-colin.i.king@gmail.com>
In-Reply-To: <20211207224718.59593-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Tue,  7 Dec 2021 22:47:18 +0000 you wrote:
> The pointer t is being initialized with a value that is never read. The
> pointer is re-assigned a value a littler later on, hence the initialization
> is redundant and can be removed.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  kernel/bpf/btf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - bpf: remove redundant assignment to pointer t
    https://git.kernel.org/bpf/bpf-next/c/73b6eae583f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


