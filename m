Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB2D6E878B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjDTBkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDTBkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25708527E;
        Wed, 19 Apr 2023 18:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B224264445;
        Thu, 20 Apr 2023 01:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19ABCC4339B;
        Thu, 20 Apr 2023 01:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681954819;
        bh=r7qVX9qGsmOWWLQDayPwGsCzNcTHfczV7tgHUV3+CVQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vM7e/Bv9pKu0zosM0P9XMMxk16Z3ccp5DvF2lbPHOnfNrQhtcM3AZpKZud7gpuDre
         As8QnO4J5gGpwBe3OnQbEdVz5VGq99sxm5cvR/5MIHb1TgLAjjnWBOpyRbZfWdKDB9
         7zVYLOSEVPm0CIapid7DiQEOrWOyuJk9v/MPK6crfpEvzHKxWNyVEKOlcgirw5G5A2
         07Cg1Q01LUIOzw8Py1KxzNOcViQXCp50UhtLt+xzCD2ksqECiOBRqNXw39Ij3COa2b
         No9shPBp94MaA1NHt5nWqQoGknfjJ+Aib6qcB52pBx/huyH7RxDqhdJjOVVgV6ObS/
         vyG95CDaJDTVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2FEFE4D033;
        Thu, 20 Apr 2023 01:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2023-04-19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168195481898.9323.9043605519254747807.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 01:40:18 +0000
References: <20230419195847.27060-1-daniel@iogearbox.net>
In-Reply-To: <20230419195847.27060-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
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

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Apr 2023 21:58:47 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 3 non-merge commits during the last 6 day(s) which contain
> a total of 3 files changed, 34 insertions(+), 9 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2023-04-19
    https://git.kernel.org/netdev/net/c/9d94769081a6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


