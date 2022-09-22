Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB785E5857
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 04:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiIVCA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 22:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiIVCAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 22:00:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D813274E26
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 19:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D7DDBCE1B64
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48B65C43140;
        Thu, 22 Sep 2022 02:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663812018;
        bh=s7sJ3rW2p4XEQ4Pz0yvKzajJFv9xZG7Tz+N0ky4DrIA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ys0fZPmQ3zxv91FVylimRTnLfkqvi8LBgzfsp8YdET45N9OUmbjKJyi6X3vEXS28m
         PGT2OLtT7uZBneS6DGJMiM5+Ck6hsABoNdXroYquvYE5AC8WyD+OJG5A4O6zcUzJs6
         d2TeGRIO6UbLo6d34fTuZCvc5YCfK9tvnna8BuVHGp5swQpdaELf/cdIdMARIcTS2+
         aqUbgkUY1kLvWSSYK79o5EinDz6RFWIeaiXLShc9JvViPluj1au1tsUU/G75wCrwQt
         8a6IhH0u4PeVpOLhNeIyr1cWZGgzTYqWmIcw7d2ggom4ZRy6TnRooj05X1QOVf/yYL
         ueiblntn4Rs6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D731E4D03C;
        Thu, 22 Sep 2022 02:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethernet: tundra: Drop forward declaration of static
 functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166381201717.16388.5438467641121690961.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 02:00:17 +0000
References: <20220919131515.885361-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20220919131515.885361-1-u.kleine-koenig@pengutronix.de>
To:     =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@ci.codeaurora.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, kernel@pengutronix.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 19 Sep 2022 15:15:15 +0200 you wrote:
> Usually it's not necessary to declare static functions if the symbols are
> in the right order. Moving the definition of tsi_eth_driver down in the
> compilation unit allows to drop two such declarations.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/net/ethernet/tundra/tsi108_eth.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 
> [...]

Here is the summary with links:
  - [net-next] ethernet: tundra: Drop forward declaration of static functions
    https://git.kernel.org/netdev/net-next/c/393d34cb862e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


