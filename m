Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4672C68E786
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 06:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjBHFaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 00:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjBHFaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 00:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA1693CF;
        Tue,  7 Feb 2023 21:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F9A761419;
        Wed,  8 Feb 2023 05:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1228C433D2;
        Wed,  8 Feb 2023 05:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675834217;
        bh=Sbwp6bk3yq+2Gihsh+3y6AUdSmobR4ucTlz8pYf+S80=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WF0xihe7NeVI7xlkvWGdslbgq3/4CZoqaNZ2bVZu7yclJh4o2tgcvnb2jHsB/7E3o
         mgmzAMBQ9mZSEscHoNZsOTZO9oR06B9E2wu/Y91ZbFLjHlByMzNEiuRfkMyGoTYFKT
         F1RRFkOfv2nwwYGluZXG4npsRH5SZIMyw1JlGf6xaPQYzpmFmUz4l0BH5Aks3B8+lE
         ZKAPn1UTtPIr8fxscFEyUx3/E1989s9so9RDQ+fckeuc3NRzLr5PRqgLHYJjhKplBI
         mvxbUnUiIvPFWDQCFco84nJjXCPcTP/Zoy4ZGk1NCA0+dWpmKCqbMkeAv4Yyht09UX
         Ji/DycffpEZCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B51E8E55F06;
        Wed,  8 Feb 2023 05:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] can: j1939: do not wait 250 ms if the same addr was
 already claimed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167583421773.16532.4513589437331313526.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 05:30:17 +0000
References: <20230207140514.2885065-2-mkl@pengutronix.de>
In-Reply-To: <20230207140514.2885065-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        devid.filoni@egluetechnologies.com, o.rempel@pengutronix.de,
        stable@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Tue,  7 Feb 2023 15:05:14 +0100 you wrote:
> From: Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
> 
> The ISO 11783-5 standard, in "4.5.2 - Address claim requirements", states:
>   d) No CF shall begin, or resume, transmission on the network until 250
>      ms after it has successfully claimed an address except when
>      responding to a request for address-claimed.
> 
> [...]

Here is the summary with links:
  - [net] can: j1939: do not wait 250 ms if the same addr was already claimed
    https://git.kernel.org/netdev/net/c/4ae5e1e97c44

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


