Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C6F4F7512
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 07:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbiDGFMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 01:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbiDGFMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 01:12:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7D9954AB;
        Wed,  6 Apr 2022 22:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3778C61CC6;
        Thu,  7 Apr 2022 05:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BED6C385A5;
        Thu,  7 Apr 2022 05:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649308213;
        bh=RSPFt/HMdA5eiShPoKdzFpSnShwvwYpz6UhBEvoK49Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oI+sGOyG3Edy51diiqARRriQV+Y+NZJwETYKEOZjirkfbAXchGUN7Z9LIJ6TjLRiv
         PNs1jpOTYErbUbQabFV/bWtAkgtUyn5e3XbqYM3JzsD27hrqbpbdetE7JIkWT7vVi5
         E97Lozw5EZsFo191ilIE2g38/OWMfob9Qp2aR/qPeHs97HEMlguiruKatFNZHKGoUw
         FXHMHloolsn839dkKNNnjEoM2FSsFTYBI0hjLcrLg8nVqd+By+Ro1xZIxKZjumoFOg
         TKInHPiVNdsrW35DQEjjD1LKjWY4AYJCBaW1zCVyf9gP2t74Jh+wbQsAEoZH+9TuYb
         9kP4LC27OgBuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C08CE8DD18;
        Thu,  7 Apr 2022 05:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-04-06
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164930821343.29337.12454340062796757954.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Apr 2022 05:10:13 +0000
References: <20220407031245.73026-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20220407031245.73026-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, kuba@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
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

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  6 Apr 2022 20:12:45 -0700 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 8 non-merge commits during the last 8 day(s) which contain
> a total of 9 files changed, 139 insertions(+), 36 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-04-06
    https://git.kernel.org/netdev/net/c/8e9d0d7a76c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


