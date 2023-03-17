Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117866BF5E6
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 00:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjCQXCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 19:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjCQXBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 19:01:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE67E3A866;
        Fri, 17 Mar 2023 16:01:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B5B2B82711;
        Fri, 17 Mar 2023 23:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1AA8C433D2;
        Fri, 17 Mar 2023 23:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679094018;
        bh=TNjYMlwUwxYrb8PSLkTjpQTmT+vkUUXDyi3/PMI8X6k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZQciSjRe8WKx8Es1Ko5lU11at3zxs4XveXdgqAfV1dDJEYMJt2nhSM+78RSmJ74Z6
         EK/QJQWki1+5nJvAmP43UmnLPy5Pz2hdyvTDjMW9FK5AVJ73TWVb35GIVZi3jKN6u4
         lI4xn+Pj87uamd3E3aCVvUGKFIpeO2T++xax8a8PX3zWYPbZIX5vU/JyGh5D/fi2dY
         1H32gItUo3GV/w+B0LtqLuDTm3/TFYkDyzn7zSD2Y7hH8csB+DWwpZGSYaSMtV6RCP
         k86HnYoqO0iCi9FHV/70Zjxzedtp9txCh01efe8R0FeYNljfywlHVksBupeL9CkqaC
         L14rFbuSvapOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F68CE66CBF;
        Fri, 17 Mar 2023 23:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 0/4] bpf: Add detection of kfuncs.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167909401858.5252.11781424904586437290.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 23:00:18 +0000
References: <20230317201920.62030-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20230317201920.62030-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        tj@kernel.org, memxor@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Fri, 17 Mar 2023 13:19:16 -0700 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Allow BPF programs detect at load time whether particular kfunc exists.
> 
> Patch 1: Allow ld_imm64 to point to kfunc in the kernel.
> Patch 2: Fix relocation of kfunc in ld_imm64 insn when kfunc is in kernel module.
> Patch 3: Introduce bpf_ksym_exists() macro.
> Patch 4: selftest.
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,1/4] bpf: Allow ld_imm64 instruction to point to kfunc.
    https://git.kernel.org/bpf/bpf-next/c/58aa2afbb1e6
  - [v2,bpf-next,2/4] libbpf: Fix relocation of kfunc ksym in ld_imm64 insn.
    https://git.kernel.org/bpf/bpf-next/c/5fc13ad59b60
  - [v2,bpf-next,3/4] libbpf: Introduce bpf_ksym_exists() macro.
    https://git.kernel.org/bpf/bpf-next/c/5cbd3fe3a91d
  - [v2,bpf-next,4/4] selftests/bpf: Add test for bpf_ksym_exists().
    https://git.kernel.org/bpf/bpf-next/c/95fdf6e313a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


