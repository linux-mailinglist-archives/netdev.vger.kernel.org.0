Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666F6618FDC
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 06:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiKDFKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 01:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiKDFKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 01:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B2027FEF;
        Thu,  3 Nov 2022 22:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7E5F6209A;
        Fri,  4 Nov 2022 05:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DFEBC433C1;
        Fri,  4 Nov 2022 05:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667538618;
        bh=ShXYUOj5Y1kvMFVLzsmxD2jL6MySsFMQncmLY/rxE6c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PfyZmPs6qZ6uCYp0BcIl2WeoFisqhTCnqnVJHMtAHyASc5bTxBpp3djVkfHyap9aM
         uUL+0GZwXACmda6Bo3/c/Jpz+XERqFzjUOk2sqO1KhGV9DItJIlO5G3rPbftKIMruQ
         kKEKWcrXEE0Azr0QoBTyU6FIRWt+j+u7wbDB5p4SR2ImLGuSplLioPrJ0Z637wJURN
         EYYYbxdR39eEXOg4lWgrIY8+BG/oIjEIlfTEfJ6yYok9TxmK1h4zMUI47LSsoNnZB0
         DJxTvKq+o/ay3BGTS1jvtn4cqOj/Cbh6YUZ59qsL6A2AWLFzdqJK1B3tXQ+81zIA9M
         /FfFLJVHDKYeg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E57BEE270EA;
        Fri,  4 Nov 2022 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 00/10] veristat: replay, filtering, sorting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166753861793.32177.1498265265265978934.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 05:10:17 +0000
References: <20221103055304.2904589-1-andrii@kernel.org>
In-Reply-To: <20221103055304.2904589-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, kuba@kernel.org, kernel-team@fb.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Wed, 2 Nov 2022 22:52:54 -0700 you wrote:
> This patch set adds a bunch of new featurs and improvements that were sorely
> missing during recent active use of veristat to develop BPF verifier precision
> changes. Individual patches provide justification, explanation and often
> examples showing how new capabilities can be used.
> 
> Andrii Nakryiko (10):
>   selftests/bpf: add veristat replay mode
>   selftests/bpf: shorten "Total insns/states" column names in veristat
>   selftests/bpf: consolidate and improve file/prog filtering in veristat
>   selftests/bpf: ensure we always have non-ambiguous sorting in veristat
>   selftests/bpf: allow to define asc/desc ordering for sort specs in
>     veristat
>   selftests/bpf: support simple filtering of stats in veristat
>   selftests/bpf: make veristat emit all stats in CSV mode by default
>   selftests/bpf: handle missing records in comparison mode better in
>     veristat
>   selftests/bpf: support stats ordering in comparison mode in veristat
>   selftests/bpf: support stat filtering in comparison mode in veristat
> 
> [...]

Here is the summary with links:
  - [bpf-next,01/10] selftests/bpf: add veristat replay mode
    https://git.kernel.org/bpf/bpf-next/c/9b5e3536c898
  - [bpf-next,02/10] selftests/bpf: shorten "Total insns/states" column names in veristat
    https://git.kernel.org/bpf/bpf-next/c/62d2c08bb91c
  - [bpf-next,03/10] selftests/bpf: consolidate and improve file/prog filtering in veristat
    https://git.kernel.org/bpf/bpf-next/c/10b1b3f3e56a
  - [bpf-next,04/10] selftests/bpf: ensure we always have non-ambiguous sorting in veristat
    https://git.kernel.org/bpf/bpf-next/c/b9670b904a59
  - [bpf-next,05/10] selftests/bpf: allow to define asc/desc ordering for sort specs in veristat
    https://git.kernel.org/bpf/bpf-next/c/d68c07e2dd91
  - [bpf-next,06/10] selftests/bpf: support simple filtering of stats in veristat
    https://git.kernel.org/bpf/bpf-next/c/1bb4ec815015
  - [bpf-next,07/10] selftests/bpf: make veristat emit all stats in CSV mode by default
    https://git.kernel.org/bpf/bpf-next/c/77534401d69c
  - [bpf-next,08/10] selftests/bpf: handle missing records in comparison mode better in veristat
    https://git.kernel.org/bpf/bpf-next/c/a5710848d824
  - [bpf-next,09/10] selftests/bpf: support stats ordering in comparison mode in veristat
    https://git.kernel.org/bpf/bpf-next/c/fa9bb590c289
  - [bpf-next,10/10] selftests/bpf: support stat filtering in comparison mode in veristat
    https://git.kernel.org/bpf/bpf-next/c/d5ce4b892341

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


