Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BE3530608
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 23:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351470AbiEVVAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 17:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348694AbiEVVAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 17:00:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C7838DB3
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 14:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1AE3B80DEA
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 21:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BEB1C385B8;
        Sun, 22 May 2022 21:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653253212;
        bh=WwjgA1+Fi78XKQ+ieN00NVds5rakmAAIbSy6uPI1f4g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hRCHfngb/xW4iNbroXRHBvFFa+mfK0k7ZlK9LZweP1MxjXeit1qvYdjNSBhai57QB
         FTkaHJ788USsPAnqqFG9zVbPksyd41M70GrOpDnsDbrrpt1NJJ83mMXNaOwX1YJT4q
         PGThmTLsdGVu5rUV8yghuMPAYWVKFYVtybkOEFIomYojoQhd5m+kPLLObCV/e1p2TT
         7mxyBryW5nl+RgA9RGXUgMzFfOJ7MIfAxSaPpQlFH2Ha8gYpqoz10AXMxGk7V3JAcA
         jLHtNyrb9kJ+Ckg2VMIpAaRPG/0keIrXgXS8FsNnpT72wOo3m8qUgwUzw/HG+gVLgR
         gY8hvzVYbW19Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 37BA6E8DBDA;
        Sun, 22 May 2022 21:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next RESEND] net: fec: Do proper error checking for
 enet_out clk
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165325321222.25167.8440253603266612593.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 21:00:12 +0000
References: <20220520062650.712561-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20220520062650.712561-1-u.kleine-koenig@pengutronix.de>
To:     =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@ci.codeaurora.org
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-imx@nxp.com, kernel@pengutronix.de
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

On Fri, 20 May 2022 08:26:50 +0200 you wrote:
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
  - [net-next,RESEND] net: fec: Do proper error checking for enet_out clk
    https://git.kernel.org/netdev/net-next/c/5ff851b7be75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


