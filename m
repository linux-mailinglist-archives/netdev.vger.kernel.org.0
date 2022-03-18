Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACED04DD3B8
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 04:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbiCRDvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 23:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiCRDvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 23:51:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8F12A1E86;
        Thu, 17 Mar 2022 20:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F0E1617D0;
        Fri, 18 Mar 2022 03:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD85BC340EF;
        Fri, 18 Mar 2022 03:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647575417;
        bh=Uww6/9D2y4nrBnsntLSUJMYy+n/up9CmgOV1aFDe+/Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dOv/Uujl9pEJcAqB+LODtHpJLJ80rxhJeDXwyrL9JTkTVz14Umc0lowWy421cDpAo
         Hj/dH7hksmsbKo6HaZ10YjT2YXDANizwe57mdiWiZU1jjI/A9CBt4/Vz4cQqQg4Ee3
         JbxqLcEZFQIw4zO9AtV/S+jAGhUTKMIXJFGdxcsEYrsXxqwsqQp10Cs2ouGoZ8+xdr
         gZvtbVSYpVMJb+Woczqqmd/DZSiIdCjcoVYTFNN8E/6VO2BM8RwXbCPXR1xe5qh72U
         +In97hQSh8/xWOGxQmTL1JXfqUwrn0M9kayGy8U6b3NvTDrk8eCh+K+HFX6635V+xp
         x6kH4Ilo+Ajog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA1F9F03841;
        Fri, 18 Mar 2022 03:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v12 bpf-next 00/12] fprobe: Introduce fprobe function
 entry/exit probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164757541675.26179.17727138330733641017.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 03:50:16 +0000
References: <164735281449.1084943.12438881786173547153.stgit@devnote2>
In-Reply-To: <164735281449.1084943.12438881786173547153.stgit@devnote2>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     jolsa@kernel.org, ast@kernel.org, andrii.nakryiko@gmail.com,
        daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, rostedt@goodmis.org,
        naveen.n.rao@linux.ibm.com, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net
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

On Tue, 15 Mar 2022 23:00:14 +0900 you wrote:
> Hi,
> 
> Here is the 12th version of fprobe. This version fixes a possible gcc-11 issue which
> was reported as kretprobes on arm issue, and also I updated the fprobe document.
> 
> The previous version (v11) is here[1];
> 
> [...]

Here is the summary with links:
  - [v12,bpf-next,01/12] ftrace: Add ftrace_set_filter_ips function
    https://git.kernel.org/bpf/bpf-next/c/4f554e955614
  - [v12,bpf-next,02/12] fprobe: Add ftrace based probe APIs
    https://git.kernel.org/bpf/bpf-next/c/cad9931f64dc
  - [v12,bpf-next,03/12] rethook: Add a generic return hook
    https://git.kernel.org/bpf/bpf-next/c/54ecbe6f1ed5
  - [v12,bpf-next,04/12] rethook: x86: Add rethook x86 implementation
    https://git.kernel.org/bpf/bpf-next/c/75caf33eda24
  - [v12,bpf-next,05/12] arm64: rethook: Add arm64 rethook implementation
    https://git.kernel.org/bpf/bpf-next/c/83acdce68949
  - [v12,bpf-next,06/12] powerpc: Add rethook support
    https://git.kernel.org/bpf/bpf-next/c/02752bd99dc2
  - [v12,bpf-next,07/12] ARM: rethook: Add rethook arm implementation
    https://git.kernel.org/bpf/bpf-next/c/515a49173b80
  - [v12,bpf-next,08/12] fprobe: Add exit_handler support
    https://git.kernel.org/bpf/bpf-next/c/5b0ab78998e3
  - [v12,bpf-next,09/12] fprobe: Add sample program for fprobe
    https://git.kernel.org/bpf/bpf-next/c/6ee64cc3020b
  - [v12,bpf-next,10/12] fprobe: Introduce FPROBE_FL_KPROBE_SHARED flag for fprobe
    https://git.kernel.org/bpf/bpf-next/c/ab51e15d535e
  - [v12,bpf-next,11/12] docs: fprobe: Add fprobe description to ftrace-use.rst
    https://git.kernel.org/bpf/bpf-next/c/aba09b44a985
  - [v12,bpf-next,12/12] fprobe: Add a selftest for fprobe
    https://git.kernel.org/bpf/bpf-next/c/f4616fabab39

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


