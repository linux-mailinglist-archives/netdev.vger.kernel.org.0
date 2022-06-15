Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159CB54BF9E
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 04:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241912AbiFOCUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 22:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiFOCUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 22:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29A7240BC;
        Tue, 14 Jun 2022 19:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CDA760ABC;
        Wed, 15 Jun 2022 02:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE1C7C3411D;
        Wed, 15 Jun 2022 02:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655259613;
        bh=uPEEwjLiSZlWAzbmcpBvclNzANe0R8TJss1a0eazzDc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G4DnXh2r5eBbYX0V086xH8wd6wX9ZBon9nV7uCVn9MYLCQemTjEcSwIfxR7N+QMqc
         mWlA6Gj3dDl7L5nubP/EIbEIjb8j0IqmhGMq7pD0SPDBVPG2zfV253//K1tT6kikqU
         ZCaPGbGr8Xa3XxKz1EJKOjgx6vVtE/tCLpYxtHZir4T8a5xVQY5aHb9avLuKFNQhBx
         cBUq8nXkiqhlGvsQlGCyMvjz07SCOrDY/exLYbNLvOGblzrS+4KHzOGvLjYLsnxkg7
         caPtfFyzqeYjNoaP2r+hL23UNzL7JxczSuvSyRPya1wwEZB6jfgP13jR1psyS6VfEK
         KJ/3QJ67Wt5Bw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9089DE6D482;
        Wed, 15 Jun 2022 02:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bgmac: Fix an erroneous kfree() in bgmac_remove()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165525961358.10274.17222690616315537427.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 02:20:13 +0000
References: <a026153108dd21239036a032b95c25b5cece253b.1655153616.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <a026153108dd21239036a032b95c25b5cece253b.1655153616.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 13 Jun 2022 22:53:50 +0200 you wrote:
> 'bgmac' is part of a managed resource allocated with bgmac_alloc(). It
> should not be freed explicitly.
> 
> Remove the erroneous kfree() from the .remove() function.
> 
> Fixes: 34a5102c3235 ("net: bgmac: allocate struct bgmac just once & don't copy it"
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - net: bgmac: Fix an erroneous kfree() in bgmac_remove()
    https://git.kernel.org/netdev/net/c/d7dd6eccfbc9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


