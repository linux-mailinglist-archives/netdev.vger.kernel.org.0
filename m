Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D9F52F5E1
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353966AbiETWuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiETWuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC07179C1A;
        Fri, 20 May 2022 15:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3843D61E0C;
        Fri, 20 May 2022 22:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9309CC385A9;
        Fri, 20 May 2022 22:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653087013;
        bh=A8RWvekcx4RmGO2brYMW6iEm9xD2F42vcItroHyoy5I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LG+rMkIsglJjeCus4oOvXhkO7SJKINzjglzEBzSR6yW6QgZ5uIyNRPRXe8owjV0lu
         +Jrdb57AWq32/VzEGDQXGuavZyJh05mBubXBK+eJW39yWvEUUgsvFe37M3Oe61vbWE
         baWkmb/f+xL0wHE9i9UksxHQibztKUAOUeZNq51ZOelhlSJ6xKUWUvs+sF+wzs4ZAX
         LZEFpqL5TwoLkcxUyMXOGUzFOZvQA1auGOK2UCWAD52Y/hG5McDHzYs2K6OFGg2Iag
         Q4OYgbwjktJL/NK6FLTbDYcMTblYi2iXFpijtY5xcP5r40JktQrLm5oQ3V140SXYSD
         L8t5ED9iqLtzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A9EEF0389D;
        Fri, 20 May 2022 22:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v5 0/7] bpf: mptcp: Support for mptcp_sock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165308701349.8703.10845303624586414440.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 22:50:13 +0000
References: <20220519233016.105670-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220519233016.105670-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, geliang.tang@suse.com,
        mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 19 May 2022 16:30:09 -0700 you wrote:
> This patch set adds BPF access to mptcp_sock structures, along with
> associated self tests. You may recognize some of the code from earlier
> (https://lore.kernel.org/bpf/20200918121046.190240-6-nicolas.rybowski@tessares.net/)
> but it has been reworked quite a bit.
> 
> 
> v1 -> v2: Emit BTF type, add func_id checks in verifier.c and bpf_trace.c,
> remove build check for CONFIG_BPF_JIT, add selftest check for CONFIG_MPTCP,
> and add a patch to include CONFIG_IKCONFIG/CONFIG_IKCONFIG_PROC for the
> BPF self tests.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v5,1/7] bpf: add bpf_skc_to_mptcp_sock_proto
    https://git.kernel.org/bpf/bpf-next/c/3bc253c2e652
  - [bpf-next,v5,2/7] selftests/bpf: Enable CONFIG_IKCONFIG_PROC in config
    https://git.kernel.org/bpf/bpf-next/c/d3294cb1e06d
  - [bpf-next,v5,3/7] selftests/bpf: add MPTCP test base
    https://git.kernel.org/bpf/bpf-next/c/8039d353217c
  - [bpf-next,v5,4/7] selftests/bpf: test bpf_skc_to_mptcp_sock
    https://git.kernel.org/bpf/bpf-next/c/3bc48b56e345
  - [bpf-next,v5,5/7] selftests/bpf: verify token of struct mptcp_sock
    https://git.kernel.org/bpf/bpf-next/c/026622346772
  - [bpf-next,v5,6/7] selftests/bpf: verify ca_name of struct mptcp_sock
    https://git.kernel.org/bpf/bpf-next/c/ccc090f46900
  - [bpf-next,v5,7/7] selftests/bpf: verify first of struct mptcp_sock
    https://git.kernel.org/bpf/bpf-next/c/4f90d034bba9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


