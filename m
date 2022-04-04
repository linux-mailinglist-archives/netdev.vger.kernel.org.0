Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8EA4F1F4F
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 00:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbiDDWsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 18:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237520AbiDDWsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 18:48:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1E222BC5;
        Mon,  4 Apr 2022 15:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95E2A615DD;
        Mon,  4 Apr 2022 22:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F26DEC34112;
        Mon,  4 Apr 2022 22:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649109613;
        bh=dWrz3QED0XPSz2eLg6mzNhE9iIjiNZb/LateXIbjtNg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N2QQsaWHUDO9HLOkMrwkFrKxtOCmeqp3PadKlhvoXXuxlcAmjFBZbPfakjSxj8cQG
         ihux5L8lfpd1WSmaQrpX4iOMMnBWasAkKDh8phrjA1Ik1Bs2Kr0cAbHWXMDLGqL0w0
         gea2eOzj4qEy4M9kYI1QScFyfaMB41cuB2FihM81xh8j1ADbQLlHenmuFJgVZvLVe3
         e5YywrMqaIEmelebRhTevKTkue2mtKsxn+gfMVxkuW8rhCriJLBPhJmBfoQY+KIyJa
         OeKmtGPJczi3bgoC403SKLLzws10sPhXDRJlsNwlBuuKXxYIiz0xwEvqy5dB8UjLE1
         X8E6OQskkjqtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6DBDE85D15;
        Mon,  4 Apr 2022 22:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/3] bpf/bpftool: add program & link type names
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164910961287.9198.15493484782582788851.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Apr 2022 22:00:12 +0000
References: <20220331154555.422506-1-milan@mdaverde.com>
In-Reply-To: <20220331154555.422506-1-milan@mdaverde.com>
To:     Milan Landaverde <milan@mdaverde.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, davemarchevsky@fb.com, sdf@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Andrii Nakryiko <andrii@kernel.org>:

On Thu, 31 Mar 2022 11:45:52 -0400 you wrote:
> With the addition of the syscall prog type we should now
> be able to see feature probe info for that prog type:
> 
>     $ bpftool feature probe kernel
>     ...
>     eBPF program_type syscall is available
>     ...
>     eBPF helpers supported for program type syscall:
>         ...
>         - bpf_sys_bpf
>         - bpf_sys_close
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/3] bpf/bpftool: add syscall prog type
    https://git.kernel.org/bpf/bpf-next/c/380341637ebb
  - [bpf-next,2/3] bpf/bpftool: add missing link types
    https://git.kernel.org/bpf/bpf-next/c/fff3dfab1786
  - [bpf-next,3/3] bpf/bpftool: handle libbpf_probe_prog_type errors
    https://git.kernel.org/bpf/bpf-next/c/7b53eaa656c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


