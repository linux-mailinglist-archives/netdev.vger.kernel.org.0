Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F137F536481
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 17:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352654AbiE0PKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 11:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241203AbiE0PKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 11:10:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E4A41F9E;
        Fri, 27 May 2022 08:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C114B8255C;
        Fri, 27 May 2022 15:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A8F3C34113;
        Fri, 27 May 2022 15:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653664212;
        bh=ovoahaMNfS6UEYpJPEXiV4cUjWIsZMQP/Yr3pKFPIIE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YGFZbVLVmOWGVlQF/KzJQXegksOK1TyK/20YBLM1PFXpH/e13w1qHVEUjaXRuQwWx
         7HNhmXzA1puvZRH1s8G3EFAQwDpeBDquQtc5GmFp+IFkYLQwpCOrRfIs6PNx9QdGJo
         JxHBgH2ZYbGUvlqmut910/6iCcbKVT7qMBYL/i+4P3W6XQB2e5zS1qeYBCInpJaZvH
         RPY7CPLY2aLo8FTY0bY1TSgC1N79jQFrqZTNmb3L0aEgg3b3ERJTo0ZqlDI9ObnusD
         G/DPyMWe5c4M0TsWnyV0XyDtSk85guuWJsKJqq7R0+Lq9K8cjgSrnVFzrgvBwgori/
         +BCKEusyx/SNg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E057AF03947;
        Fri, 27 May 2022 15:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] selftests/bpf: fix stacktrace_build_id with missing
 kprobe/urandom_read
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165366421191.28804.10243668813609197004.git-patchwork-notify@kernel.org>
Date:   Fri, 27 May 2022 15:10:11 +0000
References: <20220526191608.2364049-1-song@kernel.org>
In-Reply-To: <20220526191608.2364049-1-song@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kernel-team@fb.com,
        mykolal@fb.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 26 May 2022 12:16:08 -0700 you wrote:
> Kernel function urandom_read is replaced with urandom_read_iter.
> Therefore, kprobe on urandom_read is not working any more:
> 
> [root@eth50-1 bpf]# ./test_progs -n 161
> test_stacktrace_build_id:PASS:skel_open_and_load 0 nsec
> libbpf: kprobe perf_event_open() failed: No such file or directory
> libbpf: prog 'oncpu': failed to create kprobe 'urandom_read+0x0' \
>         perf event: No such file or directory
> libbpf: prog 'oncpu': failed to auto-attach: -2
> test_stacktrace_build_id:FAIL:attach_tp err -2
> 161     stacktrace_build_id:FAIL
> 
> [...]

Here is the summary with links:
  - [bpf] selftests/bpf: fix stacktrace_build_id with missing kprobe/urandom_read
    https://git.kernel.org/bpf/bpf/c/59ed76fe2f98

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


