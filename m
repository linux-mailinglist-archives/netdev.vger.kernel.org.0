Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CB5530607
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 23:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351232AbiEVVAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 17:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235201AbiEVVAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 17:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8382738DB3;
        Sun, 22 May 2022 14:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B58F60EED;
        Sun, 22 May 2022 21:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 622ABC34117;
        Sun, 22 May 2022 21:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653253212;
        bh=+je1WtpiONe7QXdb5p6y5pwgJ78n2MxgtryLiQhP9d8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cn/MxRME0Fys4R6ZdKoXeENGbz2X9mf94jPO64S04nzDP6YfRy8x9sThTTTEYBs1z
         vAomVSInF1+eUmegilfOfe10PERuV8NLAs+UBvEha3dsF+fTCmjavBdutq3tyS+PIf
         VVctY44FQZNmCMITsYiYIR8y3kRg4jIxO6RYs/r6EPJoX5uwjcnbNRX6eU/CMX8gPf
         36fDXxRH2NQg4oCWMUCxNJDxLPgpGd/5tEmYPinowI5dT5qqMrWioSkNyAKC2+jeh9
         PRjBCXWxKiMDoUAYOndXeg+I2+gyXbJ0Pr1Zk4QqgHXt4b9muCnenCUSRCzFhtc5XK
         XUqhQJqEzey3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 414C2F03944;
        Sun, 22 May 2022 21:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: wrap the wireless pointers in struct
 net_device in an ifdef
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165325321226.25167.8062837622435317741.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 21:00:12 +0000
References: <20220519202054.2200749-1-kuba@kernel.org>
In-Reply-To: <20220519202054.2200749-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, johannes@sipsolutions.net,
        stefan@datenfreihafen.org, sven@narfation.org,
        alex.aring@gmail.com, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc,
        linux-wireless@vger.kernel.org, linux-wpan@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 19 May 2022 13:20:54 -0700 you wrote:
> Most protocol-specific pointers in struct net_device are under
> a respective ifdef. Wireless is the notable exception. Since
> there's a sizable number of custom-built kernels for datacenter
> workloads which don't build wireless it seems reasonable to
> ifdefy those pointers as well.
> 
> While at it move IPv4 and IPv6 pointers up, those are special
> for obvious reasons.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: wrap the wireless pointers in struct net_device in an ifdef
    https://git.kernel.org/netdev/net-next/c/c304eddcecfe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


