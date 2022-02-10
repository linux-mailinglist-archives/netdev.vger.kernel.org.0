Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22054B11AF
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243622AbiBJPaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:30:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiBJPaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:30:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F33C5
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:30:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67B4161C21
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 15:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0CD3C340EE;
        Thu, 10 Feb 2022 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644507008;
        bh=yx5zQpymP+sk0n7HPlzbDhRhBbNSKlFiat+DMUKxQNM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gVX9VstIA8Fgmyk9gHeSm1PBuS7jC3iHPsa9SyQPVVH6DFxeKv8iIY4cHZ7fjywke
         a1kdsaSqZUxTnuYsvcsn0ZnpTaoY3wPQtxnmJPolPRuFFzz9EGIOaOw/O8xo/wK+TV
         ZnRcW1J9/WTtEEoDAFmqrxXtxRegUbOOmFkmLcqHv2X3WlRcCXfyvPLYuoWr0t89MN
         0LOwDdg7VrZcpXtjR9Zyn3fmEwXkH/SWuvjqKCVrfFZLU/aVY9vaYN4kxj8NCn4tHa
         XduI5dx8/eprTfdXtK7841FdquCMPaxfL3yzxL0kK+KOzijdckVNlH+w5ROyZcXlHW
         DgBuc/zzsoc0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9419E5D084;
        Thu, 10 Feb 2022 15:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] dpaa2-eth: unregister the netdev before disconnecting
 from the PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164450700868.11192.6514218932481298042.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 15:30:08 +0000
References: <20220209155743.3167775-1-ioana.ciornei@nxp.com>
In-Reply-To: <20220209155743.3167775-1-ioana.ciornei@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        rafael.richter@gin.de, daniel.klauer@gin.de,
        robert-ionut.alexa@nxp.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  9 Feb 2022 17:57:43 +0200 you wrote:
> From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
> 
> The netdev should be unregistered before we are disconnecting from the
> MAC/PHY so that the dev_close callback is called and the PHY and the
> phylink workqueues are actually stopped before we are disconnecting and
> destroying the phylink instance.
> 
> [...]

Here is the summary with links:
  - [net] dpaa2-eth: unregister the netdev before disconnecting from the PHY
    https://git.kernel.org/netdev/net/c/9ccc6e0c8959

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


