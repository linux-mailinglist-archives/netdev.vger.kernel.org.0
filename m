Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4FA4EB93D
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242484AbiC3EMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241839AbiC3EMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:12:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6832417A2C7;
        Tue, 29 Mar 2022 21:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A56D1B81B37;
        Wed, 30 Mar 2022 04:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34D5FC340F0;
        Wed, 30 Mar 2022 04:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648613412;
        bh=804OV+2+ISnJ2s6ayuzj78xs8bDaV3N8vGXMKtMpxrA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rv36/AWbJsh0M46bvJU20Wnoy2SAFrhnijSdrYiURYKuGw9gulY76BYMPpFv1xglo
         zoJbG6ipPF7x04dXu1ve65ZbcvavQu0ChJg/axQq7wjtaaQEOS8j4mDtBgGJgl0/88
         jpCDt2POaDnkR0Nt8XQDdzW/LK9kPJ0DVXPBc6eGdcAcgNC1lVM9U9n6HjSE/WatEt
         pd2AV1+q1rCc8SVTvc0pjlaoAujQLvSR5dGFZ+wZ0uHNdwfFa/rRKXXCV5mrNvG+Uc
         SIX07DHCsQAzddG98U6rnBk3ryhhVFEPTfc6mISyB52+IedxSiexj7uH+QKvOojpul
         hq+pW+p8ME4WA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15E5DF03848;
        Wed, 30 Mar 2022 04:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-03-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164861341208.12150.15315859068081009865.git-patchwork-notify@kernel.org>
Date:   Wed, 30 Mar 2022 04:10:12 +0000
References: <20220329234924.39053-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20220329234924.39053-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, peterz@infradead.org,
        mhiramat@kernel.org, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
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

This pull request was applied to bpf/bpf.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 29 Mar 2022 16:49:24 -0700 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 16 non-merge commits during the last 1 day(s) which contain
> a total of 24 files changed, 354 insertions(+), 187 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-03-29
    https://git.kernel.org/bpf/bpf/c/77c9387c0c5b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


