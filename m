Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B184DD3BB
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 04:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbiCRDvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 23:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbiCRDvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 23:51:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB492A2651;
        Thu, 17 Mar 2022 20:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50B29B82166;
        Fri, 18 Mar 2022 03:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7755C340F0;
        Fri, 18 Mar 2022 03:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647575417;
        bh=LEiMT59/2YFc/7LAvIr3W6UgC5OV1lpHHRpACr2rNjE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UN47j4RO75dObL4Bn9pBCY0fOsj/ybrQECwC6LiWWGdWNsznrOkqkTal0UEJBEul4
         Np4qGnl3rSzImmOWlPIiE2jwxqVpzUYys89GwsNNN7kUwANapTDp9XuVXVEwBSuBum
         ofJ1FXQcwg6kB+o0iiOU1KxEAyUzPYa4AnKhatDxuW3Dy9aROJ0lnxQMx7DAz5WOFq
         nfULCRZGgZCj1+hvv1UeYVTNjDzTQW9fPq7SO3z+Gef2nKper7hp6N91BSORx1JpV6
         dewlnwdP9mg39a/VElqqanGmzYaKtiHYMU//AutvfoYUpkR1D2I68oiE90VjedE3Dh
         /CxhYSbI2ozUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C34FFE6BBCA;
        Fri, 18 Mar 2022 03:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 bpf-next 00/13] bpf: Add kprobe multi link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164757541679.26179.4546063131743440246.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 03:50:16 +0000
References: <20220316122419.933957-1-jolsa@kernel.org>
In-Reply-To: <20220316122419.933957-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        mhiramat@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Mar 2022 13:24:06 +0100 you wrote:
> hi,
> this patchset adds new link type BPF_TRACE_KPROBE_MULTI that attaches
> kprobe program through fprobe API [1] instroduced by Masami.
> 
> The fprobe API allows to attach probe on multiple functions at once very
> fast, because it works on top of ftrace. On the other hand this limits
> the probe point to the function entry or return.
> 
> [...]

Here is the summary with links:
  - [PATCHv3,bpf-next,01/13] lib/sort: Add priv pointer to swap function
    https://git.kernel.org/bpf/bpf-next/c/a0019cd7d41a
  - [PATCHv3,bpf-next,02/13] kallsyms: Skip the name search for empty string
    https://git.kernel.org/bpf/bpf-next/c/aecf489f2ce5
  - [PATCHv3,bpf-next,03/13] bpf: Add multi kprobe link
    https://git.kernel.org/bpf/bpf-next/c/0dcac2725406
  - [PATCHv3,bpf-next,04/13] bpf: Add bpf_get_func_ip kprobe helper for multi kprobe link
    https://git.kernel.org/bpf/bpf-next/c/42a5712094e8
  - [PATCHv3,bpf-next,05/13] bpf: Add support to inline bpf_get_func_ip helper on x86
    https://git.kernel.org/bpf/bpf-next/c/97ee4d20ee67
  - [PATCHv3,bpf-next,06/13] bpf: Add cookie support to programs attached with kprobe multi link
    https://git.kernel.org/bpf/bpf-next/c/ca74823c6e16
  - [PATCHv3,bpf-next,07/13] libbpf: Add libbpf_kallsyms_parse function
    https://git.kernel.org/bpf/bpf-next/c/85153ac06283
  - [PATCHv3,bpf-next,08/13] libbpf: Add bpf_link_create support for multi kprobes
    https://git.kernel.org/bpf/bpf-next/c/5117c26e8773
  - [PATCHv3,bpf-next,09/13] libbpf: Add bpf_program__attach_kprobe_multi_opts function
    https://git.kernel.org/bpf/bpf-next/c/ddc6b04989eb
  - [PATCHv3,bpf-next,10/13] selftests/bpf: Add kprobe_multi attach test
    https://git.kernel.org/bpf/bpf-next/c/f7a11eeccb11
  - [PATCHv3,bpf-next,11/13] selftests/bpf: Add kprobe_multi bpf_cookie test
    https://git.kernel.org/bpf/bpf-next/c/2c6401c966ae
  - [PATCHv3,bpf-next,12/13] selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts
    https://git.kernel.org/bpf/bpf-next/c/9271a0c7ae7a
  - [PATCHv3,bpf-next,13/13] selftests/bpf: Add cookie test for bpf_program__attach_kprobe_multi_opts
    https://git.kernel.org/bpf/bpf-next/c/318c812cebfc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


