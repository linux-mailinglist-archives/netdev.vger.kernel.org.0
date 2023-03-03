Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7DF6A9C35
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 17:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjCCQu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 11:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbjCCQu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 11:50:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAF99ECC;
        Fri,  3 Mar 2023 08:50:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B89A3B817F6;
        Fri,  3 Mar 2023 16:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74D0BC4339B;
        Fri,  3 Mar 2023 16:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677862220;
        bh=8xWNjy4woa7jnd3rYthsoAMiOcOr7pkQtBdjCC1LPMA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EFiDguaCoYDwA/dtVXiSEiwjXdGkTnOHL/q0Hq7KaI8daknInLIZXkcqcQSVya4Tf
         q9RMUsFnbH7BVGfELzbwV/t0p3b4SwCiL8DSfUWQFByh4AgWKQ8kxYUmRFBC/aHPTy
         5EaHvAbvvR+Wsvxi3ILEq7c0rWP6n6M+47h8oJ6U44iJYU5v6eVcvxgHQZdR2uN+3C
         +oiiLBJuoV/v9fCIbvS0IR5WdS96VFO9yTSxErh5kDfuMheHH6+uuVkAcYiiN4oGUI
         foNqhgXIBuM+VsOW4H1H8M+tL1oWYvZsydlfqvkXAIDagB1nf63CyJU0wnidzpgfc+
         L7qwGWNk+7Vew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 574EBE68D5C;
        Fri,  3 Mar 2023 16:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 bpf-next 0/6] bpf: Introduce kptr RCU.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167786222035.26859.4386915483809485037.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Mar 2023 16:50:20 +0000
References: <20230303041446.3630-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20230303041446.3630-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        tj@kernel.org, memxor@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu,  2 Mar 2023 20:14:40 -0800 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> v4->v5:
> fix typos, add acks.
> 
> v3->v4:
> - patch 3 got much cleaner after BPF_KPTR_RCU was removed as suggested by David.
> 
> [...]

Here is the summary with links:
  - [v5,bpf-next,1/6] bpf: Rename __kptr_ref -> __kptr and __kptr -> __kptr_untrusted.
    https://git.kernel.org/bpf/bpf-next/c/03b77e17aeb2
  - [v5,bpf-next,2/6] bpf: Mark cgroups and dfl_cgrp fields as trusted.
    https://git.kernel.org/bpf/bpf-next/c/8d093b4e95a2
  - [v5,bpf-next,3/6] bpf: Introduce kptr_rcu.
    https://git.kernel.org/bpf/bpf-next/c/20c09d92faee
  - [v5,bpf-next,4/6] selftests/bpf: Add a test case for kptr_rcu.
    https://git.kernel.org/bpf/bpf-next/c/838bd4ac9aa3
  - [v5,bpf-next,5/6] selftests/bpf: Tweak cgroup kfunc test.
    https://git.kernel.org/bpf/bpf-next/c/0047d8343f60
  - [v5,bpf-next,6/6] bpf: Refactor RCU enforcement in the verifier.
    https://git.kernel.org/bpf/bpf-next/c/6fcd486b3a0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


