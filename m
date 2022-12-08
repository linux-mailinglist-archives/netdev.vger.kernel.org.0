Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B475647453
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiLHQaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiLHQaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E902CE1B;
        Thu,  8 Dec 2022 08:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6611B824D5;
        Thu,  8 Dec 2022 16:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7BFF4C433F0;
        Thu,  8 Dec 2022 16:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670517015;
        bh=jIHClrtH+bsQzKWr6c4SJ0wAfJTGHritbW/XGWOr/gs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N3MwQqJfZMDqApiqxx0dWfd9Q+OjgaFcZNKbNYkwjlsHJBy8PguoqI/AY7aWQc/39
         jyez09SrzReqd7Olw73+BsP3zSPg7CvfUNBuGD5N9pqRYykMCd/g5Uhcj+QAsu3Z+u
         bTOw9hBoLyUN4/Fiz9HMM8DTFa6Uj+EzPL9yOLiD5dlpoLMWv4Lk2SnwrdXHz8OOkw
         kjWk073dMBk2SjWAgYv2rlokZCBxeM1WII7utv5GMW6TewIXQzWs9BFXMOEv9asZXQ
         x2QRYw3a7TI823PCgghP4qkBSUL9h5wWSoQftK1VlDS2hM1+LCs+U6t6jnBzvQ8CcE
         zK9CHJzKUE+Qg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5FDFDE1B4D9;
        Thu,  8 Dec 2022 16:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: add stats64 support for
 ksz8 series of switches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167051701538.25268.9186895326935961207.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 16:30:15 +0000
References: <20221205052904.2834962-1-o.rempel@pengutronix.de>
In-Reply-To: <20221205052904.2834962-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
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

On Mon,  5 Dec 2022 06:29:04 +0100 you wrote:
> Add stats64 support for ksz8xxx series of switches.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz_common.c | 87 ++++++++++++++++++++++++++
>  drivers/net/dsa/microchip/ksz_common.h |  1 +
>  2 files changed, 88 insertions(+)

Here is the summary with links:
  - [net-next,v1,1/1] net: dsa: microchip: add stats64 support for ksz8 series of switches
    https://git.kernel.org/netdev/net-next/c/bde55dd9ccda

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


