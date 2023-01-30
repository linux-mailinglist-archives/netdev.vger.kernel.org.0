Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A7C680679
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 08:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbjA3Ha0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 02:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235504AbjA3HaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 02:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE46D199FC;
        Sun, 29 Jan 2023 23:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E026B80E70;
        Mon, 30 Jan 2023 07:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDB83C4339C;
        Mon, 30 Jan 2023 07:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675063817;
        bh=WOD2U5lQ+hwvvOMVYrmYpOd4TwUw/RM+//cvlTMLC1I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s8zAAZtzV0xpd6E6m6MojaV5fA7UigD8jgMvGULqzaqcbRc6HQqvxoyVajb8EGy0r
         0T5ZataW2JFBbQgccK3KlM+oq5WT3iZM3J+vv69TSCThzfD+qQh10gPCKZXRiMeX7d
         8tghDJox8wgBtnenbMISlMd1uNoe4W4rvigjF7DMqW0UJMtW8NTnWgsQA/KQGInE5T
         hJI0806xDN3sCEp0RTaeITRLH/2AYGueBWWIC5/yaOoXRHDzoINoQc3036dcF9IIku
         rJMvpH0BmqN+7YndxDsecome3USjEnvgl9Kun8CAV2+C5y2NagjiWfy/M3JMwD7Fg8
         SKcnV+VWZY9VA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7E0AE21ED8;
        Mon, 30 Jan 2023 07:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [v2] fec: convert to gpio descriptor
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167506381688.14069.1265117096695356615.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Jan 2023 07:30:16 +0000
References: <20230126210648.1668178-1-arnd@kernel.org>
In-Reply-To: <20230126210648.1668178-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     wei.fang@nxp.com, kuba@kernel.org, arnd@arndb.de,
        shenwei.wang@nxp.com, xiaoning.wang@nxp.com, linux-imx@nxp.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        andrew@lunn.ch, netdev@vger.kernel.org,
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 26 Jan 2023 22:05:59 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The driver can be trivially converted, as it only triggers the gpio
> pin briefly to do a reset, and it already only supports DT.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> [...]

Here is the summary with links:
  - [v2] fec: convert to gpio descriptor
    https://git.kernel.org/netdev/net-next/c/468ba54bd616

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


