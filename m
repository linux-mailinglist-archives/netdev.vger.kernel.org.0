Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EFF4796FB
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 23:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhLQWUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 17:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhLQWUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 17:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D72C061574;
        Fri, 17 Dec 2021 14:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D09F62411;
        Fri, 17 Dec 2021 22:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A20CAC36AE8;
        Fri, 17 Dec 2021 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639779610;
        bh=Kum7r0wTtsWIkvSn2t0rm2SvGvxHdbz+bkHQHaazmqA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OkJGksF+fKmA7OXDjNT2FU4sUMZGgakjKg4ihA4vUHhXrAtgQg6AXUvTSjyaYMzyF
         b7tAN+nVOqbgRh9DDLqM9wzaed9eUaYDFWmZvIESN+W719XU6yfwhrtDsXSEPZSdti
         QAIAJqi8fME6VFSc/rNOy7cPhv6uUzp3rr/LXQ7ngj/hj0inNo09HUPHLpcDB6GxSm
         bA9bGBUlr03wXjcBmCXVT4CoZW4sHzN2VmVy1DoN3tNre/JTUDLDyooebHH2DGYXmv
         kgsKA9J84Wm4o9r/rYn/6SOzls+qwzeQHfPNvGGo6Slnp2t3pt4hlfuxj9eW/8a+5C
         auor5t46Mcp4A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D62360A3C;
        Fri, 17 Dec 2021 22:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] bpf,
 selftests: Fix spelling mistake "tained" -> "tainted"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163977961050.17343.6487483630157192212.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Dec 2021 22:20:10 +0000
References: <20211217182400.39296-1-colin.i.king@gmail.com>
In-Reply-To: <20211217182400.39296-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 17 Dec 2021 18:24:00 +0000 you wrote:
> There appears to be a spelling mistake in a bpf test message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] bpf, selftests: Fix spelling mistake "tained" -> "tainted"
    https://git.kernel.org/bpf/bpf/c/819d11507f66

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


