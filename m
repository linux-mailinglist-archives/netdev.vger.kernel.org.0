Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C9553885D
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 23:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238332AbiE3VAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 17:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiE3VAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 17:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449C691552;
        Mon, 30 May 2022 14:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E328B80F6F;
        Mon, 30 May 2022 21:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FEEDC34119;
        Mon, 30 May 2022 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653944413;
        bh=KnLcGa8uT4mDL9pauNRzvEuxlMfsU4gFkddnssg+gyk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cqpMULpacTG0sPd1SAx2v9AZ8/kpViOVtVxdO6Mu1HcuHNEhmAmvesPhRcTuQc2uP
         qD1Bdaz1HaoTqvSy0WxpqBvQlz6SYg9csQxo4eqx1oXdv1VQowvluEBHYUkl7yskYs
         bVo2W8XbtBBYA0IAycRVB1G95R9b800X1KPxGNWfJvP1F90mUgjghOQEGHJdCtYarc
         YfOS0b/ePUcKafAOty3pSRvly18GLs3AD06NIKlVsooJiLro6WRM6n1M1kxigVYgrq
         Qmtis2W1UgkPsxf7OGjEdMWJ8Dz7gvf4hyou8hxH+LT7c4NXiKzHNlacvXCJ0r7Nj8
         BLeQ2z9WGrc1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E148AF03944;
        Mon, 30 May 2022 21:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 0/6] Support riscv jit to provide
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165394441291.12813.18139846661607728867.git-patchwork-notify@kernel.org>
Date:   Mon, 30 May 2022 21:00:12 +0000
References: <20220530092815.1112406-1-pulehui@huawei.com>
In-Reply-To: <20220530092815.1112406-1-pulehui@huawei.com>
To:     Pu Lehui <pulehui@huawei.com>
Cc:     bpf@vger.kernel.org, linux-riscv@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        bjorn@kernel.org, luke.r.nels@gmail.com, xi.wang@gmail.com,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Mon, 30 May 2022 17:28:09 +0800 you wrote:
> patch 1 fix an issue that could not print bpf line info due
> to data inconsistency in 32-bit environment.
> 
> patch 2 add support for riscv jit to provide bpf_line_info.
> "test_progs -a btf" and "test_bpf.ko" all test pass, as well
> as "test_verifier" and "test_progs" with no new failure ceses.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/6] bpf: Unify data extension operation of jited_ksyms and jited_linfo
    (no matching commit)
  - [bpf-next,v3,2/6] riscv, bpf: Support riscv jit to provide bpf_line_info
    https://git.kernel.org/bpf/bpf-next/c/b863b163aa8a
  - [bpf-next,v3,3/6] bpf: Correct the comment about insn_to_jit_off
    https://git.kernel.org/bpf/bpf-next/c/4b4b4f94a4f6
  - [bpf-next,v3,4/6] libbpf: Unify memory address casting operation style
    (no matching commit)
  - [bpf-next,v3,5/6] selftests/bpf: Unify memory address casting operation style
    (no matching commit)
  - [bpf-next,v3,6/6] selftests/bpf: Remove the casting about jited_ksyms and jited_linfo
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


