Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B593D50EB96
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 00:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbiDYWYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 18:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343547AbiDYVdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 17:33:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D272252B0;
        Mon, 25 Apr 2022 14:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B7086147E;
        Mon, 25 Apr 2022 21:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B94CC385A9;
        Mon, 25 Apr 2022 21:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650922211;
        bh=xjGNuD4uYKuUJzeSWkeUROx9AjVzUsYZauu252ps7hA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o5/CTEh74uaRaH5Ud3HV7kLOj26y3kIMWCY264ki2VM42SPKZ4nWKneMlP7pmHKIh
         AOaCqYnCMFO+7YoTQwCKX1jbmKAgNqaPk5ab19LVT4ooDQFtpuUfe5n0l5DRWzck0K
         lici1u7haemSOUF+aK1By7NSC05214+Fi+PR8P8uPziE8m4/wMpw4g2Vr+Lkw69RDv
         5BaGiEeU4m9uz9JY0O7UVayL5cRQxT/8kA32YIS/b+FpkPAybjL7pWYiGlSM2Bh1gb
         mHAsANM8WmK+srNoQPvtVYJfFif66M6ymN4qKLDvaOYRulbCzc1ST5dYQATPh0g/fx
         wYUVMoUYDb2Hg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 41137E6D402;
        Mon, 25 Apr 2022 21:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/4] tools/bpf: allow building with musl
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165092221126.11408.5748679293507022115.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 21:30:11 +0000
References: <20220424051022.2619648-1-asmadeus@codewreck.org>
In-Reply-To: <20220424051022.2619648-1-asmadeus@codewreck.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kpsingh@kernel.org,
        john.fastabend@gmail.com, yhs@fb.com, songliubraving@fb.com,
        kafai@fb.com, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Sun, 24 Apr 2022 14:10:18 +0900 you wrote:
> Hi,
> 
> I'd like to build bpftool on alpine linux, which is musl based.
> 
> There are a few incompatibilities with it, I've commented on each patch
> when I could think of alternative solutions.
> 
> [...]

Here is the summary with links:
  - [1/4] tools/bpf/runqslower: musl compat: explicitly link with libargp if found
    (no matching commit)
  - [2/4] tools/bpf: musl compat: do not use DEFFILEMODE
    (no matching commit)
  - [3/4] tools/bpf: musl compat: replace nftw with FTW_ACTIONRETVAL
    https://git.kernel.org/bpf/bpf-next/c/93bc2e9e943d
  - [4/4] tools/bpf: replace sys/fcntl.h by fcntl.h
    https://git.kernel.org/bpf/bpf-next/c/246bdfa52f33

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


