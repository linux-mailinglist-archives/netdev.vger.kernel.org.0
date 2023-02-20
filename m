Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268D969C633
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjBTIAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBTIAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:00:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486895275;
        Mon, 20 Feb 2023 00:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD5FCB80AD1;
        Mon, 20 Feb 2023 08:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 967B1C4339C;
        Mon, 20 Feb 2023 08:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676880016;
        bh=XujvieMAEC4B+AOSju1R6qposK5OMwwTc/kV+9CBGdU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ovGu0kh3wbB7nlAnGYnHtDPErrdIsv37K1UeOdSLB9a4Sqvy5ERJjF5LkR/XqJE1V
         CVZ0OAlU6bS7zDuSjiT7/cS4/7SQbwmY/rDPjoQmN5rAFRnUbra16PpgkGkzec9Vr4
         +YoYdyvSQvHX6zwcnlG07JPovr1/9R5ntuOLXPgGp6tHJGngJ6OhWKCkN62O2c4zqE
         el2B82kPMGb5iZ8Bqwg37uzE7LHX58wgX6t2aKYkoOAAg72C8uNTj8UzueXzY+6ik0
         +G34aVG9GabXjHAse6ZqqYkJdXoe98eoLLSdkZRJxOHKrNgLC+fP6gSNhBotLip9Ue
         0j9zA3FvFb9UA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 75CB1E68D20;
        Mon, 20 Feb 2023 08:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] taprio queueMaxSDU fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167688001647.8258.280190584176814049.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 08:00:16 +0000
References: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vinicius.gomes@intel.com, kurt@linutronix.de,
        gerhard@engleder-embedded.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 16 Feb 2023 00:46:29 +0200 you wrote:
> This fixes 3 issues noticed while attempting to reoffload the
> dynamically calculated queueMaxSDU values. These are:
> - Dynamic queueMaxSDU is not calculated correctly due to a lost patch
> - Dynamically calculated queueMaxSDU needs to be clamped on the low end
> - Dynamically calculated queueMaxSDU needs to be clamped on the high end
> 
> Vladimir Oltean (3):
>   net/sched: taprio: fix calculation of maximum gate durations
>   net/sched: taprio: don't allow dynamic max_sdu to go negative after
>     stab adjustment
>   net/sched: taprio: dynamic max_sdu larger than the max_mtu is
>     unlimited
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net/sched: taprio: fix calculation of maximum gate durations
    https://git.kernel.org/netdev/net-next/c/09dbdf28f9f9
  - [net-next,2/3] net/sched: taprio: don't allow dynamic max_sdu to go negative after stab adjustment
    https://git.kernel.org/netdev/net-next/c/bdf366bd867c
  - [net-next,3/3] net/sched: taprio: dynamic max_sdu larger than the max_mtu is unlimited
    https://git.kernel.org/netdev/net-next/c/64cb6aad1232

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


