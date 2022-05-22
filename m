Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9BB5305FE
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 22:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351367AbiEVUuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 16:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351314AbiEVUuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 16:50:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EA52A274
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 13:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 959E7B80DC8
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 20:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A5F8C385B8;
        Sun, 22 May 2022 20:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653252612;
        bh=iHAWonTRTUD7TjX45AcMcaZOMtvdbjFxOqWaafz61Zg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pktrYl2CgWkLFJdYIUQyg/X9BF5+CL0rM+G0O2SbCfG/zkUE/3cYMj78Xdb9DrR0C
         qfv/Bu48pmuug0dgaI0EV8a3tYl3kMIA00krMAw+L/h9reOfOT+QqwljfTxZpH0FST
         5vdGnqZqEst7hkP+GzlUN7F6OWwM0GX4PXd2DJ7HWT3UhG0ZB0ZZ6D7eyTS4QtOYtp
         ujWWbViiy1mHeGb3dnrn8MmCrO9maKEr6oZx94PF27/mJXQvfMPLNkxlKaSa8ev2Lg
         vfY59o5jg6lED345Ov3YiInpHoxof572mc3RheW6oJAsFZ0lQI6ZQpse+OOhELcD+j
         l8VQktvuoWyFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30949F03943;
        Sun, 22 May 2022 20:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: fec: Do proper error checking for optional clks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165325261219.21066.18372735683595603664.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 20:50:12 +0000
References: <20220521083425.787204-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20220521083425.787204-1-u.kleine-koenig@pengutronix.de>
To:     =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@ci.codeaurora.org
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-imx@nxp.com, kernel@pengutronix.de,
        andrew@lunn.ch
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 21 May 2022 10:34:25 +0200 you wrote:
> An error code returned by devm_clk_get() might have other meanings than
> "This clock doesn't exist". So use devm_clk_get_optional() and handle
> all remaining errors as fatal.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> [...]

Here is the summary with links:
  - [v2] net: fec: Do proper error checking for optional clks
    https://git.kernel.org/netdev/net/c/43252ed15f46

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


