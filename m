Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB6C6EA258
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 05:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbjDUDaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 23:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjDUDaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 23:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D6310C1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 20:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D006264B89
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 03:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22397C433D2;
        Fri, 21 Apr 2023 03:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682047819;
        bh=XAYEvGilh7Mmiel+zNVeb/aISPjiDUSrAYIQN7zPnGg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U20mX/r2l/u5sdry0FB69PvaALsziI6JoE1qa1o/15vkkKHKAv/bfgSyMYlPYOqmX
         HN5ia7vtfeKN+RIZwqsAsuFEf5Dc+wxiFpN2U3NQX085q9OhOB8Ib8tqSeySwWNZh2
         6d5RoqF3+hqMLykvf/nO3JR1UKIDKiZZYyha6yctd6f5kEorrDUW63PwbSGOExbQPc
         D5Z0EOZ3tM063XXNjeuyFP5vvk/LLm53b8tbuybOapWfjGORI9mwQJaahZ/XdqZabf
         h5wj68TP1WqtPqtTxalfe0h1ORVKc0N9zRoofcn5vO0myA45WFpJDElGJT3c8rHTFp
         xBqTlZQ9PVmrw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F41C8C395EA;
        Fri, 21 Apr 2023 03:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 next] ipv6: add icmpv6_error_anycast_as_unicast for ICMPv6
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168204781899.6790.87891683637213829.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 03:30:18 +0000
References: <20230419013238.2691167-1-maheshb@google.com>
In-Reply-To: <20230419013238.2691167-1-maheshb@google.com>
To:     =?utf-8?b?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+?=@ci.codeaurora.org,
        =?utf-8?b?4KSwKSA8bWFoZXNoYkBnb29nbGUuY29tPg==?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, mahesh@bandewar.net, kuniyu@amazon.com,
        maze@google.com
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

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Apr 2023 18:32:38 -0700 you wrote:
> ICMPv6 error packets are not sent to the anycast destinations and this
> prevents things like traceroute from working. So create a setting similar
> to ECHO when dealing with Anycast sources (icmpv6_echo_ignore_anycast).
> 
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> CC: Maciej Żenczykowski <maze@google.com>
> 
> [...]

Here is the summary with links:
  - [PATCHv2,next] ipv6: add icmpv6_error_anycast_as_unicast for ICMPv6
    https://git.kernel.org/netdev/net-next/c/7ab75456be14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


