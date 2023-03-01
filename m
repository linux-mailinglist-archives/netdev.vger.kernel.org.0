Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103256A7216
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 18:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjCARaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 12:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjCARaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 12:30:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE5136442
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 09:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3A9B6142D
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 17:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F879C4339C;
        Wed,  1 Mar 2023 17:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677691818;
        bh=HMEe4PlVHicWcoy0Tmu7E6ih18u4zdzdAJYCC2BRRn8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mbA8epOhkt4PgORHG+yxUzbFUkhhbYrITmVhlTsbIZZOErgkWD0Z7jO3c/E1CZCqe
         tcpmNDj28jati/HkDxA5FKj0xvkTlkE+hasRbcqemyL17Q373WxeyAh8jSTK9tiC+I
         dcjl4Sts+6aWkrzXcIRVvRPoTO5p/mdi6OhfGiBa+isPZWtmsO9d8b+ZHkaje5g8GH
         aMFn5XRYXPdd9X8yD7w+EjlmKZ5aQSRKbiszJTIFngzQTkAHqp3aDdnM94ec3LzFKA
         HZ+gP1MhG77HuFjmXbiTxjUQW6VDVy5d70j+0aPWUttHE6kPFuGhD1lU9MaVPz+3pp
         md7qJpMytcN+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ECBB4E450A6;
        Wed,  1 Mar 2023 17:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/sched: act_connmark: handle errno on
 tcf_idr_check_alloc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167769181796.25108.9399430215071565822.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Mar 2023 17:30:17 +0000
References: <20230227152352.266109-1-pctammela@mojatatu.com>
In-Reply-To: <20230227152352.266109-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, error27@gmail.com,
        simon.horman@corigine.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Feb 2023 12:23:52 -0300 you wrote:
> Smatch reports that 'ci' can be used uninitialized.
> The current code ignores errno coming from tcf_idr_check_alloc, which
> will lead to the incorrect usage of 'ci'. Handle the errno as it should.
> 
> Fixes: 288864effe33 ("net/sched: act_connmark: transition to percpu stats and rcu")
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net/sched: act_connmark: handle errno on tcf_idr_check_alloc
    https://git.kernel.org/netdev/net/c/fb07390463c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


