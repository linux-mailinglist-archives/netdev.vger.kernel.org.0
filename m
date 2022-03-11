Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6704D6069
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 12:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348162AbiCKLLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 06:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346011AbiCKLLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 06:11:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6EA18DAB5
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 03:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E32D3B82B3E
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 11:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D33EC340E9;
        Fri, 11 Mar 2022 11:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646997014;
        bh=tZxriWrx/W59muoLwXRgsNRDyIku917D4DImw14tAYE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aEuYgbCcjezUIE9uhQly765Brz07KAa3YfGRYMCjQTkaV7x/eqAnoBzD7ANISNCgO
         EIYKgVqdTfKuW+tx3GwAZ8M8tpqud0Wwdk2xphFcWY2TawR+Yw5r7xx1zkqUPECXMX
         BZ4iTqMUzxOtR1JQefG1pMCOnnNUIv9OxgKvq4P7Pl5wvnhfnAjqPtKriWJZ/lCWBs
         N9Vt4/t1ZSK2meYpvWhBm6I6nN4jcY8EtFtbu4KHMdRWUC+uWo9Ckj1c4D95AWXa7w
         SuYaEmUeK/TmGYYyEWP3X2NTdTWicpuZ7ty8mHE5Q6pM75hHaF9NA3K+91YTSb87fg
         rw8tkLnAF3iKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72A11EAC095;
        Fri, 11 Mar 2022 11:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] flow_dissector: Add support for HSRv0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164699701446.2968.604423540394564185.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 11:10:14 +0000
References: <20220310073505.49990-1-kurt@linutronix.de>
In-Reply-To: <20220310073505.49990-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        alobakin@pm.me, vladimir.oltean@nxp.com, edumazet@google.com,
        paulb@nvidia.com, komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        claudiajkang@gmail.com, ennoerlangen@gmail.com,
        george.mccollister@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, anthony.harivel@linutronix.de
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 10 Mar 2022 08:35:05 +0100 you wrote:
> Commit bf08824a0f47 ("flow_dissector: Add support for HSR") added support for
> HSR within the flow dissector. However, it only works for HSR in version
> 1. Version 0 uses a different Ether Type. Add support for it.
> 
> Reported-by: Anthony Harivel <anthony.harivel@linutronix.de>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next] flow_dissector: Add support for HSRv0
    https://git.kernel.org/netdev/net-next/c/f65e58440d4f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


