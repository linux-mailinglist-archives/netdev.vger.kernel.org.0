Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C8E522690
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 00:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbiEJWAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 18:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiEJWAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 18:00:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F93D2983B4;
        Tue, 10 May 2022 15:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 661DECE2147;
        Tue, 10 May 2022 22:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFFC1C385CF;
        Tue, 10 May 2022 22:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652220013;
        bh=Ql106IKmSrLUywqq3cLeq/ZDlfMLp7KO5hOWfSSdZEA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FZSuhUkfjDOeLJ7exG6eEswPNzHc9adEo+q/HnV0YZltUldaELT4wnWCbhQDWUzfi
         Wc5fzbRT24b6ihn+OkjT9gLI+OTkSvUnu7210OibpsEWP19tuyTN5BgmXqvHQiXXLr
         4B4v17gm1Mgt6cmxCrbEniBMOPpH9re9JxODD/Y/0AO72Xyc+gWkuNae3Faiq5eLND
         UpSZb70VjpKDlVeGUkeeCLqeW5YR+WGqHBzp9nAbINYhXLY8UT9S1DXnqO+55NnBUM
         G2nEGTUY1p9dg3p24An63XVQ+YHMrYzq+tOnd1442d1RipKb34x3Nxp/H4yJJ6/658
         h1SiCnpQS7b8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C390F03930;
        Tue, 10 May 2022 22:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv6 bpf-next 0/5] bpf: Speed up symbol resolving in kprobe multi
 link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165222001363.27377.6392947791230691855.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 22:00:13 +0000
References: <20220510122616.2652285-1-jolsa@kernel.org>
In-Reply-To: <20220510122616.2652285-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        mhiramat@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org, hch@lst.de
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
by Alexei Starovoitov <ast@kernel.org>:

On Tue, 10 May 2022 14:26:11 +0200 you wrote:
> hi,
> sending additional fix for symbol resolving in kprobe multi link
> requested by Alexei and Andrii [1].
> 
> This speeds up bpftrace kprobe attachment, when using pure symbols
> (3344 symbols) to attach:
> 
> [...]

Here is the summary with links:
  - [PATCHv6,bpf-next,1/5] kallsyms: Make kallsyms_on_each_symbol generally available
    https://git.kernel.org/bpf/bpf-next/c/d721def7392a
  - [PATCHv6,bpf-next,2/5] ftrace: Add ftrace_lookup_symbols function
    https://git.kernel.org/bpf/bpf-next/c/bed0d9a50dac
  - [PATCHv6,bpf-next,3/5] fprobe: Resolve symbols with ftrace_lookup_symbols
    https://git.kernel.org/bpf/bpf-next/c/8be9253344a1
  - [PATCHv6,bpf-next,4/5] bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link
    https://git.kernel.org/bpf/bpf-next/c/0236fec57a15
  - [PATCHv6,bpf-next,5/5] selftests/bpf: Add attach bench test
    https://git.kernel.org/bpf/bpf-next/c/5b6c7e5c4434

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


