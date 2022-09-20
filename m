Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E4F5BDE2C
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 09:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiITHaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 03:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiITHaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 03:30:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D854731DEA
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 00:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FDD7B82534
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 07:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 563D2C433D6;
        Tue, 20 Sep 2022 07:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663659016;
        bh=8dW6bHl7uoCi3EkQnNXQQIHo4wJhWW64+Xk3quzV9lY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AExTZVGB14+L4cXhkaGKQdIr9c0PSLYKw9grQCh96UrSx0ualqWDwaW5m7jzl5mUR
         /+MHY70GrfrgoBtSSz9Ev/IURtfrPnjtN614GnclM0+jYsGWxmcW9Fwsh7isDNcMww
         DnTMexPS8br2+RVthNRdzELdXAYieXsSEoSw+urCe+uNTchE5WfqwvEdV3IHU8PsfW
         TgCPE1UFyGcEf7Le3glV6jauPT2c+TnppTNJZOsEJfwCxlH1It9xRqb/QwYjwg7344
         HrSYNIPc7GWBccXtYJ8/B0+cSJzoLodfb5d/sT85WYQ5W6ZNX2haVpko0V1p3Q+1Q8
         Gz1KyA24x6zgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 373B2E21ED2;
        Tue, 20 Sep 2022 07:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 0/5][pull request] ice: L2TPv3 offload support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166365901622.22752.10799448124008445080.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 07:30:16 +0000
References: <20220908171644.1282191-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220908171644.1282191-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        wojciech.drewek@intel.com, simon.horman@corigine.com,
        kurt@linutronix.de, komachi.yoshiki@gmail.com,
        jchapman@katalix.com, boris.sukholitko@broadcom.com,
        louis.peens@corigine.com, gnault@redhat.com, vladbu@nvidia.com,
        pablo@netfilter.org, baowen.zheng@corigine.com,
        maksym.glubokiy@plvision.eu, jiri@resnulli.us, paulb@nvidia.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com
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

On Thu,  8 Sep 2022 10:16:39 -0700 you wrote:
> Wojciech Drewek says:
> 
> Add support for dissecting L2TPv3 session id in flow dissector. Add support
> for this field in tc-flower and support offloading L2TPv3. Finally, add
> support for hardware offload of L2TPv3 packets based on session id in
> switchdev mode in ice driver.
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/5] uapi: move IPPROTO_L2TP to in.h
    https://git.kernel.org/netdev/net-next/c/65b32f801bfb
  - [net-next,v1,2/5] flow_dissector: Add L2TPv3 dissectors
    https://git.kernel.org/netdev/net-next/c/dda2fa08a13c
  - [net-next,v1,3/5] net/sched: flower: Add L2TPv3 filter
    https://git.kernel.org/netdev/net-next/c/8b189ea08c33
  - [net-next,v1,4/5] flow_offload: Introduce flow_match_l2tpv3
    https://git.kernel.org/netdev/net-next/c/2c1befaced50
  - [net-next,v1,5/5] ice: Add L2TPv3 hardware offload support
    https://git.kernel.org/netdev/net-next/c/cd63454902d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


