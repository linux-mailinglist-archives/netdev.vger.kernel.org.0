Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E68F5A1D33
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 01:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244467AbiHYXaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 19:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiHYXaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 19:30:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82BE6717F;
        Thu, 25 Aug 2022 16:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CD99B82EFE;
        Thu, 25 Aug 2022 23:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DF6CC433D6;
        Thu, 25 Aug 2022 23:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661470215;
        bh=jt+4LYK8PPeOfOQ0Q0Vn2HJibPOUmVb9FhkcwNuZLPI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oLkKN3kUvRS2X+jzVpt4zrw1aF+lAlloul1Q8AxANLyjHKxioJRbnJhmtMWbN+c5p
         bLYb1BTiEOprCPZRjswEGnfDXHDl46X/UZFBiOETqGIReivIQbYPnodiykuc6V4TQr
         5Nrur34Lym6piokZ/pXPwbgwGjjqiHoIbge+znLnhui92fT0qPIiGYyKI1OucNP5fb
         uV48Gc2IQ9U1jYkuuYd7gAnHjiG+JdBiVskg7Acy3b+NLNusBZf923ElscuRAKXKqc
         3qrOdSm+0OLq6EmRWYq8MoP1MfL/SsjdjWHF6DQlQnVqeeP2VZmhiFXb7BJwgWAezb
         nMzgCCvGq+QEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 010EFE2A040;
        Thu, 25 Aug 2022 23:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] bpf: Add CGROUP prefix to cgroup_iter_order
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166147021499.17452.10347661300375640851.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 23:30:14 +0000
References: <20220825223936.1865810-1-haoluo@google.com>
In-Reply-To: <20220825223936.1865810-1-haoluo@google.com>
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        daniel@iogearbox.net, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, john.fastabend@gmail.com,
        jolsa@kernel.org, sdf@google.com, yosryahmed@google.com
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

This patch was applied to bpf/bpf-next.git (master)
by Martin KaFai Lau <kafai@fb.com>:

On Thu, 25 Aug 2022 15:39:36 -0700 you wrote:
> bpf_cgroup_iter_order is globally visible but the entries do not have
> CGROUP prefix. As requested by Andrii, put a CGROUP in the names
> in bpf_cgroup_iter_order.
> 
> This patch fixes two previous commits: one introduced the API and
> the other uses the API in bpf selftest (that is, the selftest
> cgroup_hierarchical_stats).
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] bpf: Add CGROUP prefix to cgroup_iter_order
    https://git.kernel.org/bpf/bpf-next/c/d4ffb6f39f1a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


