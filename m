Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF78544209
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 05:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237621AbiFIDkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 23:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbiFIDkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 23:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518451B9FA8;
        Wed,  8 Jun 2022 20:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAA5161C19;
        Thu,  9 Jun 2022 03:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42935C3411F;
        Thu,  9 Jun 2022 03:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654746013;
        bh=kiLOIP5WjeZDVO35apta6hCF/6orpsY3bqoJ/fTHDio=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HFmKH1iP2Wx4nMg/8lacqY/KZOeDzD2q7v6H5mIrwRiEJdkohvjLAzVR/jGldya91
         awvCr0ZqUZLDnCJfzluQ22zAfhyvkCv+QkZ/O05SjIagn9GSfuJR6K0NO0hdgDs3Wd
         c9fZdxs+RNY0tgCJHktRvJY0gihb99gBXtTrwfwdw2HTaBPmcuVo4IdokxnU58Y3TM
         389eED3M40HkPutdYt6U5vFaIC50ypOD99IHXymEcHU8kv1sd/1A7lx4EAP/gV6H+Q
         spZo6267fq5cGGsDwgLXKnr2dUKxPkUW/cg4B/UghhvY/sm+JJEvjy6sqNDLwMiRsV
         ZrF8Rx785sFAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 264A3E737F6;
        Thu,  9 Jun 2022 03:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-06-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165474601315.17710.6777625210369645593.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 03:40:13 +0000
References: <20220608234133.32265-1-daniel@iogearbox.net>
In-Reply-To: <20220608234133.32265-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Jun 2022 01:41:33 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 6 non-merge commits during the last 2 day(s) which contain
> a total of 8 files changed, 49 insertions(+), 15 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-06-09
    https://git.kernel.org/netdev/net/c/d5d4c36398ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


