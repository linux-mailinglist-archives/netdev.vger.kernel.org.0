Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E7F57AB0C
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 02:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237979AbiGTAkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 20:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbiGTAkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 20:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9F24BD34
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 17:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F558616DB
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0F11C341D3;
        Wed, 20 Jul 2022 00:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658277614;
        bh=mhYF+RXH2bZz2NxisfDpP7bXCvKVae458Xn4iKkkzL0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=acrNeAAYsnjwaAVgnSSZjuBT08Oi0coNAWMk0Ob+7CCIDPN9SCY2jPuguiyyEIUxG
         i1f+rciNXCdw/iB5CsFQZ76E5Wak/dcapYPdfBpAvcMzndd9jtsMK9tzsDhvHsBeUQ
         sU7dHTcfarj14FfqG3Fl4Q4ox7zv8u8HOcqedMBI+pMNcAybNlBXSAhjOdtmjPZtDm
         ZdW/JLLBcPHcaXMApjFqaPDFl4I0jfUYKNeSGTJqY7QkmDAoi+iHQ7yuMyyeDsCeFr
         rduE3BdI0VuhiXV1rb8nGsKiO43fQ/RDMh2SsYDyh72F3Cmp3qXzTajIRF/yBhAR89
         KWpawxOGaGyow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D998CE451BC;
        Wed, 20 Jul 2022 00:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: remove qdisc_root_lock() helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165827761388.10063.580570722533348875.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 00:40:13 +0000
References: <703d549e3088367651d92a059743f1be848d74b7.1658133689.git.dcaratti@redhat.com>
In-Reply-To: <703d549e3088367651d92a059743f1be848d74b7.1658133689.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 18 Jul 2022 10:55:12 +0200 you wrote:
> the last caller has been removed with commit 96f5e66e8a79 ("mac80211: fix
> aggregation for hardware with ampdu queues"), so it's safe to remove this
> function.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  include/net/sch_generic.h | 19 -------------------
>  1 file changed, 19 deletions(-)

Here is the summary with links:
  - [net-next] net/sched: remove qdisc_root_lock() helper
    https://git.kernel.org/netdev/net-next/c/ca0cab119288

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


