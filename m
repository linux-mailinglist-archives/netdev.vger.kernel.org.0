Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743C04D5411
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344224AbiCJWBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343730AbiCJWBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:01:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8CA194A9C;
        Thu, 10 Mar 2022 14:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F29D6B82846;
        Thu, 10 Mar 2022 22:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C96BC340EC;
        Thu, 10 Mar 2022 22:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646949611;
        bh=5Hq1OmCrjsAfyPCGsq9sp2LgMKXFkgePqVetfaDFa7Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MmzOwFPTCMzlx7ateei1JH/2bQMToWr1ccdgSFy4ulwRR9mO3xK55lnx0E2AmNhnC
         Fuaw5ApCWHkWayIjJsYMijJoeSfKHya6wm0qRKYyVd3RBgdvEZpUenp/+8FVc/zSvp
         muOwVtmGM6HCn+Df25RqJzGO8Q/c5zGc/myZ6trShMFs5u8UQfojn6p2Y6A2a+fTXB
         mAYzlPurNzPfdsRbhMbfyTyyKVYmPElCuu7sLhwWJM+OIaIH2Z2FqnYbkPFkN2sdJn
         GCe0Nc4/CEX2Ox8PFKuVZWkdwOJjVodByX4mu8qfpNst1eRo59/2N3K3EHC75UeXoj
         LrpfvipCEpX0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C893E5D087;
        Thu, 10 Mar 2022 22:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/5] bpf: Follow up on bpf __sk_buff->tstamp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164694961150.7517.4845832258567131034.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 22:00:11 +0000
References: <20220309090444.3710464-1-kafai@fb.com>
In-Reply-To: <20220309090444.3710464-1-kafai@fb.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        daniel@iogearbox.net, kernel-team@fb.com, netdev@vger.kernel.org
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 9 Mar 2022 01:04:44 -0800 you wrote:
> This set is a follow up on the bpf side based on discussion [0].
> 
> Patch 1 is to remove some skbuff macros that are used in bpf filter.c
> 
> Patch 2 and 3 are to simplify the bpf insn rewrite on __sk_buff->tstamp.
> 
> Patch 4 is to simplify the bpf uapi by modeling the __sk_buff->tstamp
> and __sk_buff->tstamp_type (was delivery_time_type) the same as its kernel
> counter part skb->tstamp and skb->mono_delivery_time.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/5] bpf: net: Remove TC_AT_INGRESS_OFFSET and SKB_MONO_DELIVERY_TIME_OFFSET macro
    https://git.kernel.org/bpf/bpf-next/c/3b5d4ddf8fe1
  - [bpf-next,2/5] bpf: Simplify insn rewrite on BPF_READ __sk_buff->tstamp
    https://git.kernel.org/bpf/bpf-next/c/539de9328e3a
  - [bpf-next,3/5] bpf: Simplify insn rewrite on BPF_WRITE __sk_buff->tstamp
    https://git.kernel.org/bpf/bpf-next/c/9d90db97e4d4
  - [bpf-next,4/5] bpf: Remove BPF_SKB_DELIVERY_TIME_NONE and rename s/delivery_time_/tstamp_/
    https://git.kernel.org/bpf/bpf-next/c/9bb984f28d5b
  - [bpf-next,5/5] bpf: selftests: Update tests after s/delivery_time/tstamp/ change in bpf.h
    https://git.kernel.org/bpf/bpf-next/c/3daf0896f3f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


