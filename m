Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1539F626377
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 22:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbiKKVUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 16:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiKKVUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 16:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702C75BD5B;
        Fri, 11 Nov 2022 13:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03176620E3;
        Fri, 11 Nov 2022 21:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4087AC433D7;
        Fri, 11 Nov 2022 21:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668201616;
        bh=BAiyIB5ibIysagB+Z7g8kr/m6WtRxGfA+9x4Pd7SpWU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C3HqC8D8OvOK5WSr/5W1wVcci1bjWuZD7RpZk8GIR0joathVu7CPUwbM08qr3IJBB
         aN4MKi6DJEvusWV7VwnW0s1Af37BXiJCD9oVdvVVdaAb4tFTBDGBEfeFAjxJsU0mQq
         n+ceJoFGL8wTwJBKnIu2S7xQrBgBg3kNTVlOF7QDv5Ai6tH/nt7igstc/cg0ytDVZy
         OY8ZpLeaZH4qzaQsfu1tsAigYphu23ybK0ztpDI4o8SgxjQUzvx1rVqRSDsaBHvPfA
         9eA6C0mMB3VytqJncdhyBNThHmZs1W/o+zFve+8ZGI9qyI3GIULYBlJnsURjlm3/vE
         xS8+B/xl0IwAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21520C395FE;
        Fri, 11 Nov 2022 21:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: Add hwtstamp field for the sockops prog
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166820161613.22359.18424848164891774925.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Nov 2022 21:20:16 +0000
References: <20221107230420.4192307-1-martin.lau@linux.dev>
In-Reply-To: <20221107230420.4192307-1-martin.lau@linux.dev>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, kernel-team@meta.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon,  7 Nov 2022 15:04:17 -0800 you wrote:
> From: Martin KaFai Lau <martin.lau@kernel.org>
> 
> The bpf-tc prog has already been able to access the
> skb_hwtstamps(skb)->hwtstamp.  This set extends the same hwtstamp
> access to the sockops prog.
> 
> v2:
> - Fixed the btf_dump selftest which depends on the
>   last member of 'struct bpf_sock_ops'.
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,1/3] bpf: Add hwtstamp field for the sockops prog
    https://git.kernel.org/bpf/bpf-next/c/9bb053490f1a
  - [v2,bpf-next,2/3] selftests/bpf: Fix incorrect ASSERT in the tcp_hdr_options test
    https://git.kernel.org/bpf/bpf-next/c/52929912d7bd
  - [v2,bpf-next,3/3] selftests/bpf: Test skops->skb_hwtstamp
    https://git.kernel.org/bpf/bpf-next/c/8cac7a59b252

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


