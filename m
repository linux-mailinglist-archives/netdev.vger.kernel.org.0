Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C52C4E7DD8
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbiCYXnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 19:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbiCYXnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 19:43:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DC8171EDA
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 16:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BB536177D
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 23:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5ED2DC340F3;
        Fri, 25 Mar 2022 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648251611;
        bh=lvZertzMdPWs1zTFOP75i0Qj1U0A8Wq49xf4O5hyjCE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=orDXQFB9BfOeCxqB30D886Uqm6lQROjl+Bnh0HCKmC4/XBxzWzs8bp8MK4EWq1Jfx
         qM5ki4eDYoLJ6N1Wit4NwQNLFlOmkHYZW3+p/do7S6IwOSEplWUaIsf1LVwn3anHEK
         TZdI+0e7ta8JdLCJRyzJfDQ9XxQSljD+PJ39PlQ5vaxM/nWba8JSWVpTWMdfIPR1IB
         CtbrAB75Zn6y8+FOf0QBdvSm+U2idhpkbKL/bgEQswgMhy8YiYpNuQVnoJ+t604+iv
         Q0gOfulx1QlImmQsCgiU2t3W4gajNQXRKxabD8VdF6F4YDJYZipJOVjARK35zWJGXp
         hEk7CG/QykdgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 489EDF03847;
        Fri, 25 Mar 2022 23:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: sparx5: Refactor based on feedback on
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164825161129.19572.17152636195212033950.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Mar 2022 23:40:11 +0000
References: <20220324113853.576803-1-casper.casan@gmail.com>
In-Reply-To: <20220324113853.576803-1-casper.casan@gmail.com>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 24 Mar 2022 12:38:51 +0100 you wrote:
> This is a follow up to a previous patch that was merged
> before manufacturer could give feedback. This addresses
> the feedback. See link below for previous patch series.
> https://lore.kernel.org/netdev/20220322081823.wqbx7vud4q7qtjuq@wse-c0155/T/#t
> 
> Casper Andersson (2):
>   net: sparx5: Remove unused GLAG handling in PGID
>   net: sparx5: Refactor mdb handling according to feedback
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: sparx5: Remove unused GLAG handling in PGID
    https://git.kernel.org/netdev/net/c/264a9c5c9dff
  - [net-next,2/2] net: sparx5: Refactor mdb handling according to feedback
    https://git.kernel.org/netdev/net/c/ad238fc6de7d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


