Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D015F74DF
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 09:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiJGHuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 03:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJGHuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 03:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD41D6171A;
        Fri,  7 Oct 2022 00:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF3D261C21;
        Fri,  7 Oct 2022 07:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B75DC43470;
        Fri,  7 Oct 2022 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665129016;
        bh=1nUBHpGUxvugnyP17SSmTV7ldBfoTwF3/yGzMclH4/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eCTA0VLoTfVPuR994GyowOA4W1rSJ7Ndb1c59U2PHtcIB0+k/x1ahUiNbLzSDMccB
         0Oir5450OKkIHd/W3cV7g7bK3kMERGmD+IIyMaYcERcuRmldZSTWqndMEJ+UvKXeFY
         ub5RUcYnwIsJdbs3NFvqLI6UhJ8/kdshQHsNiYMTg1fo86ttrCB3zN2ulNoHWVl7mS
         l/hKp7Toc7jYEcwt8Bcj2nekGzmOX/4b0YFAAhIu4btRGQtuPCZuzLx7NE+lHYpr0/
         h5k6o2IyPLDkIh2N75FczQf63zlF4RRyWOInKyxrVkt+b3PVFPpzdJMMfZ370e3Iw4
         bZdh7n1g6rpwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F21ADE43EFE;
        Fri,  7 Oct 2022 07:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net OR wpan] net: ieee802154: return -EINVAL for unknown addr
 type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166512901598.847.2508780876971390849.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Oct 2022 07:50:15 +0000
References: <20221006020237.318511-1-aahringo@redhat.com>
In-Reply-To: <20221006020237.318511-1-aahringo@redhat.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     tcs.kernel@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
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

On Wed,  5 Oct 2022 22:02:37 -0400 you wrote:
> This patch adds handling to return -EINVAL for an unknown addr type. The
> current behaviour is to return 0 as successful but the size of an
> unknown addr type is not defined and should return an error like -EINVAL.
> 
> Fixes: 94160108a70c ("net/ieee802154: fix uninit value bug in dgram_sendmsg")
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net,OR,wpan] net: ieee802154: return -EINVAL for unknown addr type
    https://git.kernel.org/netdev/net/c/30393181fdbc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


