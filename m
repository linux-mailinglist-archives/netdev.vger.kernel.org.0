Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BD24E2964
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 15:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348711AbiCUODt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 10:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349021AbiCUODP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 10:03:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F55B3FDB9;
        Mon, 21 Mar 2022 07:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2481B611D5;
        Mon, 21 Mar 2022 14:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 765B9C340ED;
        Mon, 21 Mar 2022 14:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647871211;
        bh=bVBvrrpl/LVzJIr8s5SQNGr1DSNPmf7L8H5CSTrC3ys=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sTgD81bnayUrxx68z75eNF9OP+2f7A4tthAj2k6fu6sodlCoVg+IgBtcOwQ3kc2X8
         ppsxhBBlWQ2VYIAO1Rj1LPMxzltd+N7lCdbkAbF+7V28FNSwJYAT/67qV4bp3UMbIR
         eZvYJ3jn+2wqKjnz6kwRPoI7Q+FNjRFM3M800N0H9D/E7ZIVj00bY1xp2hVv2ve+AJ
         bPfuP+QZq7nJmGPcWlZ1p2totMSaP41maS40gWt2Weqj2bwxz/Is9XWFDsHwZPOfYF
         UIRtHN032YV3yrgJoqbzGs7BdgTRPpN/df1X9mQErMHLazsKS6LatT+fuxYi1oUQg9
         t+pRCL2HD41Fg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C3A0E7BB0B;
        Mon, 21 Mar 2022 14:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/2] bpf: Fix kprobe_multi return probe backtrace
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164787121130.8124.16949440007845247535.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 14:00:11 +0000
References: <20220321070113.1449167-1-jolsa@kernel.org>
In-Reply-To: <20220321070113.1449167-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        mhiramat@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 21 Mar 2022 08:01:11 +0100 you wrote:
> hi,
> Andrii reported that backtraces from kprobe_multi program attached
> as return probes are not complete and showing just initial entry [1].
> 
> Sending the fix together with bpf_get_func_ip inline revert, which is
> no longer suitable.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] Revert "bpf: Add support to inline bpf_get_func_ip helper on x86"
    https://git.kernel.org/bpf/bpf-next/c/f705ec764b34
  - [bpf-next,2/2] bpf: Fix kprobe_multi return probe backtrace
    https://git.kernel.org/bpf/bpf-next/c/f70986902c86

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


