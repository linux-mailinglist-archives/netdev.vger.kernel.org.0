Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2ED58E037
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344680AbiHITaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344658AbiHITaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE50B8E
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 12:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3281B6133B
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 19:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C575C433D7;
        Tue,  9 Aug 2022 19:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660073414;
        bh=2EsoD9lgDsmTm/oxaVt/pmJXXqTljzsyY/Ct9U9QQI0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mpy58Qlc0k6UAFb6oz/ZZ/AFuwGbJNBu7j1pu9HSGPK7SoXJXgNie5FAleruel/00
         cRlXgFb/wRQEE1FKD9Z/J+vWwyyvBVNYkwn8t+YUIqFRDKP68a/Fujq3DC98Uh+Ges
         Gpj9Zxwi8Qq3dd+I0eH4rWaQg+2X7S2JD9LMv/KgVfRYZsmHMY/5iCQE5p9w/DWzgJ
         gH6na98UfCrZx8PfQ8JvLp8WxycvZRqifRk1wZ9mUcHJ7vRSMd85blsrana+PUe0Wy
         fDO2oMhVCTMRPZfRXtekKNnPr4Pf/7/urLUQWPsXx9sfz0hShOATZ1qqJ27M7bt3YI
         b2NXHw89BBIkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D710C43143;
        Tue,  9 Aug 2022 19:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] plip: avoid rcu debug splat
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166007341444.32181.11157538559525066008.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Aug 2022 19:30:14 +0000
References: <20220807115304.13257-1-fw@strlen.de>
In-Reply-To: <20220807115304.13257-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net, oliver.sang@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  7 Aug 2022 13:53:04 +0200 you wrote:
> WARNING: suspicious RCU usage
> 5.2.0-rc2-00605-g2638eb8b50cfc #1 Not tainted
> drivers/net/plip/plip.c:1110 suspicious rcu_dereference_check() usage!
> 
> plip_open is called with RTNL held, switch to the correct helper.
> 
> Fixes: 2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net] plip: avoid rcu debug splat
    https://git.kernel.org/netdev/net/c/bc3c8fe3c79b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


