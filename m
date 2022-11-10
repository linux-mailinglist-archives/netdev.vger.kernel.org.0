Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BBF624538
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 16:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiKJPKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 10:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiKJPKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 10:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1663B27CF5;
        Thu, 10 Nov 2022 07:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC846B8222C;
        Thu, 10 Nov 2022 15:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67D4AC433D6;
        Thu, 10 Nov 2022 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668093015;
        bh=pEgm6CnPHt3MYp/jsUpZiXwiuhhwWFJC99daNpvZqxE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aFJ6Qo51PeQc3m/FkUMEETXYqMyWnDOm1USkiM3f8GA6hjhTCkO1KdiTEnNIAvvpe
         QDkqi6BuBLFvUslt58x7OAzLldkMlMfxWrR8yRScuFTtCrHBIGeCwTQBLmSIOmh9bK
         0TDzCXCJzoIP2JF1UVYZNazqTCs8mJqeM2Iv7L58+sfbAn7jUxy6zVq0sUoZMMRxNI
         VBpWK2tpJvLYVskqY+HF7vIPw8HeroWLAABflt0v1fheKoS6aZKyiK/iHOMxqX57/L
         Vc3uXxvk477hQ/77LAv5TYZ9oAQTlkgJhY+KKxbAcAnhtjHdmpJ4zalYOZ3etw5b/c
         waroIk6KDm/Hg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 51877E270C5;
        Thu, 10 Nov 2022 15:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macvlan: fix memory leaks of macvlan_common_newlink
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166809301533.30495.18109627091458304827.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 15:10:15 +0000
References: <20221109090735.690500-1-nashuiliang@gmail.com>
In-Reply-To: <20221109090735.690500-1-nashuiliang@gmail.com>
To:     Chuang W <nashuiliang@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, fgao@ikuai8.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed,  9 Nov 2022 17:07:34 +0800 you wrote:
> kmemleak reports memory leaks in macvlan_common_newlink, as follows:
> 
>  ip link add link eth0 name .. type macvlan mode source macaddr add
>  <MAC-ADDR>
> 
> kmemleak reports:
> 
> [...]

Here is the summary with links:
  - net: macvlan: fix memory leaks of macvlan_common_newlink
    https://git.kernel.org/netdev/net/c/23569b5652ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


