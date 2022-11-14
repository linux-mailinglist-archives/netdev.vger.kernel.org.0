Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721A9627B4F
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbiKNLAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236316AbiKNLAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:00:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB0413DC3;
        Mon, 14 Nov 2022 03:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA8DEB80DE5;
        Mon, 14 Nov 2022 11:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D0EDC433C1;
        Mon, 14 Nov 2022 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668423615;
        bh=Cj0yQirWkhy+hOqreE4W7OWgmkh55/IWdv3p1IKoh+Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d8wxtKp+pyP1UotQNQIapZdgQdWaE1JTTIzxdZ3gW5b1nJkpQ8jBt3HZqxeB0Wx4u
         VBHlCs287nvLAQoyK3HSAT9eqj+u53ZjpkXc7KxqiLoc/glvuRNvqOePMzCjOcVKGl
         Yy9052vM6jXxWoNXEfQHs6XrdfF+SzvwxdipyPfXzPPMfkGv8N8B2eC+qaZ873TpS2
         tOcNf43RZKZMbP2ea3/evGupViU3+CvILBc3tNoBU0Jr/GyLDX/QksMvNymKbepwz1
         K5OhD/r4ZyMH/Lm3EOhcYeU9zf8qK/JCetcrhV996BrAs6PYh4eA2Wmly7U8sqVQi9
         dhnjRXVqrm5Yw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65BBCE4D021;
        Mon, 14 Nov 2022 11:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: macvlan: Use built-in RCU list checking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166842361541.12717.15432029079052853751.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 11:00:15 +0000
References: <20221111014131.693854-1-nashuiliang@gmail.com>
In-Reply-To: <20221111014131.693854-1-nashuiliang@gmail.com>
To:     Chuang Wang <nashuiliang@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, michael-dev@fami-braun.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Nov 2022 09:41:30 +0800 you wrote:
> hlist_for_each_entry_rcu() has built-in RCU and lock checking.
> 
> Pass cond argument to hlist_for_each_entry_rcu() to silence false
> lockdep warning when CONFIG_PROVE_RCU_LIST is enabled.
> 
> Execute as follow:
> 
> [...]

Here is the summary with links:
  - [net,v2] net: macvlan: Use built-in RCU list checking
    https://git.kernel.org/netdev/net/c/5df1341ea822

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


