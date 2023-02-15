Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17156981FD
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjBORaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 12:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBORaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E02206A6;
        Wed, 15 Feb 2023 09:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25DC0B8232C;
        Wed, 15 Feb 2023 17:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA9B2C4339B;
        Wed, 15 Feb 2023 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676482216;
        bh=z3uWxTlToaVBmoiI1IYV1dpdl0MsT4CcLOi9JY3NZpk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rd136B2Cww9MmkP4H/HPFZsJQ87zRJHOgy5vdHoMzoDSIf5eyDYzzJOqgWsmtI7wn
         0YaPmhFBn/d6miWzlylqZ+YXgELkbwo1KD4+/dgPeo5NoK3dywz6QSzC47lPwBzqqK
         B0QulNaR2GxN2RWDcBl2PevF/beHbpBJMhZRMCmjAiUHfmhwY/iRfAlKhYp9pm6e2j
         m1cRClcHxtNc25/E8J44SGxsJ5PAnFjckBSVhhmLX08Ph4CJIccCkDkdjguF5Z0nyP
         38JcJ75X/035jO7/WxyZMyI/gVAdLD3Licf2rLrBFwW1z8CvzXiuuRyBYr1AHEvzOn
         uXlrWC83+DI6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BC48AC4166F;
        Wed, 15 Feb 2023 17:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix map_kptr test.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167648221676.27629.12132836025087563682.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 17:30:16 +0000
References: <20230214235051.22938-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20230214235051.22938-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, memxor@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Tue, 14 Feb 2023 15:50:51 -0800 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The compiler is optimizing out majority of unref_ptr read/writes, so the test
> wasn't testing much. For example, one could delete '__kptr' tag from
> 'struct prog_test_ref_kfunc __kptr *unref_ptr;' and the test would still "pass".
> 
> Convert it to volatile stores. Confirmed by comparing bpf asm before/after.
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: Fix map_kptr test.
    https://git.kernel.org/bpf/bpf-next/c/62d101d5f422

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


