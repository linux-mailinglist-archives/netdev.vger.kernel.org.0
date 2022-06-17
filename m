Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9043A54EFC4
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 05:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379812AbiFQCux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 22:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379823AbiFQCup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 22:50:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264D86620B;
        Thu, 16 Jun 2022 19:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6BDF61D0A;
        Fri, 17 Jun 2022 02:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2326CC3411C;
        Fri, 17 Jun 2022 02:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655434214;
        bh=/9ka6KX+DtuVeeL1Q+48YoPiCR6JqGjx2YfTEqmj2B8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MJoLvwvPvHtdggwhpsWss9agtvR047SoNsKrd81OtvQdMJ3riHJtGNr1dKj0tpz6B
         77klexpFwo0KMZ9uuZo7JfcNvMkBULPW3GvcrVUhJzemovYasiY6fhJcA5eOa0VC9e
         JM+0rR5yqyzmRm0jd/YlNwpJrzBj0M53+EiOJweI54SGhScu0RrKzkOuEu9tnmfrWr
         nHd03QgcCIG9cW2PZKl6iBL3NCB8rX//N86rkR5bENNKH5aCkDdi378RwqdWjkjNBQ
         JWtCZFxLzcjNVw69BHh3IRrCIQMghC5hDkld4iO+GaZ5Daxx+jTIfVcRZmqDFnxPU4
         KThN6lB2QUxoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 06C1EFD99FB;
        Fri, 17 Jun 2022 02:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 bpf 0/4] bpf: Fix cookie values for kprobe multi
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165543421402.9013.17384793233209616966.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 02:50:14 +0000
References: <20220615112118.497303-1-jolsa@kernel.org>
In-Reply-To: <20220615112118.497303-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org, mhiramat@kernel.org
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

This series was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Wed, 15 Jun 2022 13:21:14 +0200 you wrote:
> hi,
> there's bug in kprobe_multi link that makes cookies misplaced when
> using symbols to attach. The reason is that we sort symbols by name
> but not adjacent cookie values. Current test did not find it because
> bpf_fentry_test* are already sorted by name.
> 
> v3 changes:
>   - fixed kprobe_multi bench test to filter out invalid entries
>     from available_filter_functions
> 
> [...]

Here is the summary with links:
  - [PATCHv3,bpf,1/4] selftests/bpf: Shuffle cookies symbols in kprobe multi test
    https://git.kernel.org/bpf/bpf/c/ad8848535e97
  - [PATCHv3,bpf,2/4] ftrace: Keep address offset in ftrace_lookup_symbols
    https://git.kernel.org/bpf/bpf/c/eb1b2985fe5c
  - [PATCHv3,bpf,3/4] bpf: Force cookies array to follow symbols sorting
    https://git.kernel.org/bpf/bpf/c/eb5fb0325698
  - [PATCHv3,bpf,4/4] selftest/bpf: Fix kprobe_multi bench test
    https://git.kernel.org/bpf/bpf/c/730067022c01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


