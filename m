Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724F14ACEEF
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345941AbiBHCaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345937AbiBHCaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:30:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B27C06109E;
        Mon,  7 Feb 2022 18:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 136236147C;
        Tue,  8 Feb 2022 02:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72329C340ED;
        Tue,  8 Feb 2022 02:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644287412;
        bh=2NrfmZ5nHmEtw6Xj9n4lzXjnH/mIJFd6e08LaVoVHTA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=haisEjIwxQHs//x1HxPEfguZW7dj1XRID0//W6L8OevWkQM7b3yhKEWew7FrpbFA0
         VOBHUXXX4p880IG+JYY26jwBfAfAKXGrjlm8i5HIGXtHbUPT+LWdgSEjSIS+3fBHKd
         QqcsWJ0nN3o6HoPe2Urws+03yueAuL03859xX9FNsvMAemwnjLgR/1V0LBz1e2OWAD
         Swi39YLTKIxjT07FSThLDul6NhpYHZ6ohIkt22S3yAM+PPpLaLeSbO6fS4X6P2675z
         dcvsqfVr0s8N6J4Ek3GALKJOidPcjeC8Bi/iTrqzFhfQYAdxmrPf4bk4uTzbCjLc8G
         I/E4365Fl5NrA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57C16E6BB76;
        Tue,  8 Feb 2022 02:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v9 bpf-next 0/9] bpf_prog_pack allocator
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164428741235.20223.1353999217126442524.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Feb 2022 02:30:12 +0000
References: <20220204185742.271030-1-song@kernel.org>
In-Reply-To: <20220204185742.271030-1-song@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, peterz@infradead.org,
        x86@kernel.org, iii@linux.ibm.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Fri, 4 Feb 2022 10:57:33 -0800 you wrote:
> Changes v8 => v9:
> 1. Fix an error with multi function program, in 4/9.
> 
> Changes v7 => v8:
> 1. Rebase and fix conflicts.
> 2. Lock text_mutex for text_poke_copy. (Daniel)
> 
> [...]

Here is the summary with links:
  - [v9,bpf-next,1/9] x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
    https://git.kernel.org/bpf/bpf-next/c/fac54e2bfb5b
  - [v9,bpf-next,2/9] bpf: use bytes instead of pages for bpf_jit_[charge|uncharge]_modmem
    https://git.kernel.org/bpf/bpf-next/c/3486bedd9919
  - [v9,bpf-next,3/9] bpf: use size instead of pages in bpf_binary_header
    https://git.kernel.org/bpf/bpf-next/c/ed2d9e1a26cc
  - [v9,bpf-next,4/9] bpf: use prog->jited_len in bpf_prog_ksym_set_addr()
    https://git.kernel.org/bpf/bpf-next/c/d00c6473b1ee
  - [v9,bpf-next,5/9] x86/alternative: introduce text_poke_copy
    https://git.kernel.org/bpf/bpf-next/c/0e06b4037168
  - [v9,bpf-next,6/9] bpf: introduce bpf_arch_text_copy
    https://git.kernel.org/bpf/bpf-next/c/ebc1415d9b4f
  - [v9,bpf-next,7/9] bpf: introduce bpf_prog_pack allocator
    https://git.kernel.org/bpf/bpf-next/c/57631054fae6
  - [v9,bpf-next,8/9] bpf: introduce bpf_jit_binary_pack_[alloc|finalize|free]
    https://git.kernel.org/bpf/bpf-next/c/33c9805860e5
  - [v9,bpf-next,9/9] bpf, x86_64: use bpf_jit_binary_pack_alloc
    https://git.kernel.org/bpf/bpf-next/c/1022a5498f6f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


