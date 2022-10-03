Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704165F39BA
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 01:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJCXUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 19:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJCXUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 19:20:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAA517067;
        Mon,  3 Oct 2022 16:20:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6992FB8167C;
        Mon,  3 Oct 2022 23:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C05BC433D6;
        Mon,  3 Oct 2022 23:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664839238;
        bh=k425Xjxkin7H+lrC5qeqR8mR6OOZLhlcwBQDRdFJ83k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S77kczZywGXNkYCfG3CfgW+7jmUuej/hZE4JVzRjgpwFYV6JVSjtCcYP4BYLzvRB4
         GK7axcN9p4Ewi2xBZhXPblv3Zm/R/EMeTFWgiI0ATBPMsFtW2o9qk9PQudLHlTr7v6
         81uuxip79gZZjWVsG1/Kk3aQT03qbi3WGMvrfZoiApk07mvnrYr+8/BPsyVmNL/HfM
         QCv65vmD6RFYz9V1uWjgz4qXK1WzhJOVJpo+YO8kFiv6YHMYn3qvyHLiUtaVYvp4j+
         6cknYjbEyYLQ3ZM7tygXiXpRXPj3HvMCAaXSxVDLB7eaQo4FjYU3Og4CosruGm0x9S
         /UMSFK7OJK2og==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 100E5E49FA3;
        Mon,  3 Oct 2022 23:20:38 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-10-03
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166483923806.13941.4495861277266405348.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 23:20:38 +0000
References: <20221003194915.11847-1-daniel@iogearbox.net>
In-Reply-To: <20221003194915.11847-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  3 Oct 2022 21:49:15 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 143 non-merge commits during the last 27 day(s) which contain
> a total of 151 files changed, 8321 insertions(+), 1402 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-10-03
    https://git.kernel.org/netdev/net-next/c/a08d97a1935b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


