Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF50A54C82C
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 14:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344940AbiFOMKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 08:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245720AbiFOMKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 08:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04DF53C7D
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 05:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D4B3618CB
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 12:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB294C341C4;
        Wed, 15 Jun 2022 12:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655295013;
        bh=PKrkujDBxfZJz+Q+ES3c7mxOk+CXS5HEECCQM+tNBt0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vMebQWBo5tBoL6QjkV7S4bNWmhVeJLBi3JgyhtVL+L0oV3dpIxmoQOVxyf7SEd+iC
         v/fG/a89Gr9OYg4B/CTihm3SVuETyZtEhf9xygVUOUCpo7ExTbsJZJZ+GnfB6m1e5F
         n+8W2tXRIucKeJ+SSQvGHf0+FKmDkoDNT8V+Ur5T8wBlZVJvwaJNMg26uV2Sb0Pmbm
         7lA9qzxACd50jgNKgZUYx6VACu2QQT1B3BhdvQujcMepK5qYvKGC5/E0+ukPSn0Wum
         LN77UbkyhawLdz5sdJKNIld6bU47we/CB/8NZj97cbVXg40O1i6vXBpPtO16L27YIg
         KAyu7wmk3QxoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B27B4E6D482;
        Wed, 15 Jun 2022 12:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sparx5: Allow mdb entries to both CPU and ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165529501372.14672.2338931366774698659.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 12:10:13 +0000
References: <20220614092532.3273791-1-casper.casan@gmail.com>
In-Reply-To: <20220614092532.3273791-1-casper.casan@gmail.com>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 14 Jun 2022 11:25:32 +0200 you wrote:
> Allow mdb entries to be forwarded to CPU and be switched at the same
> time. Only remove entry when no port and the CPU isn't part of the group
> anymore.
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---
>  .../microchip/sparx5/sparx5_switchdev.c       | 55 ++++++++++++-------
>  1 file changed, 35 insertions(+), 20 deletions(-)

Here is the summary with links:
  - [net-next] net: sparx5: Allow mdb entries to both CPU and ports
    https://git.kernel.org/netdev/net-next/c/fbb89d02e33a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


