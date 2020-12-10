Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8D62D60C7
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 17:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392169AbgLJQBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 11:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392107AbgLJQAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 11:00:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607616007;
        bh=0K9RcpBcRAh/PIz7zBPxOkK7aB9AGuaNAdXK4neMAeE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bb7xD7sip1XtCUll0COJ1gdVcldvmK5d/5QuD/+qjSPnUTkmA9DMhAaZb20e0zLK9
         w9X9whlWKULYEg5JwsB9pzle3x5+M4JGMxRqAHWfvMpcFRb47yqiSu0c0NW0FLmomR
         sPcznz848NcfYguCVMleniTDLOT1/gZ2K47xkntNiUXcl2KYIMUY/+s2XXVtpnZ4v+
         1ximgbs1piSuvvGVfvzf6tlDx3enub/mOCxtF9Ojif39yjPJFHgsS3pdTgoJqpOSkD
         to+FmVMHyTz60e5fxWuMxP4lVSL96nKPYkZ3vXJF+DVDLVR8XM8fD/59RTLqvzglOl
         IiqHMvjjH1uVA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix selftest compilation on clang 11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160761600775.26295.7600785069556551635.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Dec 2020 16:00:07 +0000
References: <20201209142912.99145-1-jolsa@kernel.org>
In-Reply-To: <20201209142912.99145-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed,  9 Dec 2020 15:29:12 +0100 you wrote:
> We can't compile test_core_reloc_module.c selftest with clang 11,
> compile fails with:
> 
>   CLNG-LLC [test_maps] test_core_reloc_module.o
>   progs/test_core_reloc_module.c:57:21: error: use of unknown builtin \
>   '__builtin_preserve_type_info' [-Wimplicit-function-declaration]
>    out->read_ctx_sz = bpf_core_type_size(struct bpf_testmod_test_read_ctx);
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: Fix selftest compilation on clang 11
    https://git.kernel.org/bpf/bpf-next/c/41003dd0241c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


