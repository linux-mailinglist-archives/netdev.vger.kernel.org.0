Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCB364AB8F
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiLLXaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbiLLXaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F7E1AA11
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 15:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6048261295
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 23:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2BA8C433EF;
        Mon, 12 Dec 2022 23:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670887816;
        bh=weMRo2NXwHaY0mc4ZHzfjSrjqqSnDPUi71UGfi8T9D8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eGWG+BApvdCL27I7pKBczu5kfoUyWcyNcZZwOIBnsDbWyEE4ix8Ja0DrtsmKkdYA9
         uL1Nh2aoxku8pVYyAQdfHEQa9xkhPWwVKOaZnDAzETgODwqrwH7ks3vS4oo6vONZDR
         qZwzfY7vFSy9DVgD0GHIqGq04itOH5AFS5AeoXinLoNgfLuIw4YENMAlYMuY9jP6y1
         GdNVvJ4e3JwPtxViAUpFrUnNI+j+bUTRxtOSOpjGTJePeWHvD76NTDH/v5B5qnk2ZO
         yb3LmRxZDwhmRVEd+9/Y6+JAdh1KsvJDtsmQbV5WAelhcE9qod+xKujgLyce2IbYi5
         HbkXpT90So8Gw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97845C41612;
        Mon, 12 Dec 2022 23:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: tag_8021q: avoid leaking ctx on
 dsa_tag_8021q_register() error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088781661.32014.3178523305277313759.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 23:30:16 +0000
References: <20221209235242.480344-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221209235242.480344-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 10 Dec 2022 01:52:42 +0200 you wrote:
> If dsa_tag_8021q_setup() fails, for example due to the inability of the
> device to install a VLAN, the tag_8021q context of the switch will leak.
> Make sure it is freed on the error path.
> 
> Fixes: 328621f6131f ("net: dsa: tag_8021q: absorb dsa_8021q_setup into dsa_tag_8021q_{,un}register")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: tag_8021q: avoid leaking ctx on dsa_tag_8021q_register() error path
    https://git.kernel.org/netdev/net/c/e095493091e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


