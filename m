Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD035128FA
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 03:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240753AbiD1Bni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 21:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiD1Bnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 21:43:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901AB2AE21;
        Wed, 27 Apr 2022 18:40:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC506B82B33;
        Thu, 28 Apr 2022 01:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A456C385AD;
        Thu, 28 Apr 2022 01:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651110020;
        bh=vqbWvgbz+j9aa9Q8rxnapDHy0No/QsvbZP4PNniZuBQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KP0wtdF3ojY6nrIDpOUEz6KmBzTCLJthfkEzDsrkBGrin30og++nfNYcn1yCDWq2I
         MWYmtWvBZhqY6wYPNDkQ3G/x29pz6qGiWqXXg38YIKjJnR3rd0Yl2eBFxykF9AEY3N
         pMdgJ/D0TG3Y7gFqbWln4BjvOoz0/sCITp/Uiph4OANHde8q2GY+lZh59mADjH/7dh
         Vs/u1w1R1hNIy9QPRX4tGEH3mES+H/EH1FzCC6ItBwSTF1VPIYz0BF2/du3A8yuGKx
         Q9Q95Hni+X/1faJOXq7lTubRhYinrFpGyJuAEGkRcEasP9y3VWmAZNVKSweVDx+hmp
         zn6omhyzx9AlA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 694E8E8DD67;
        Thu, 28 Apr 2022 01:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next] net: dsa: ksz9477: move get_stats64 to ksz_common.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165111002042.8802.13473539294257415179.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 01:40:20 +0000
References: <20220426091048.9311-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220426091048.9311-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        olteanv@gmail.com, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        andrew@lunn.ch, UNGLinuxDriver@microchip.com,
        woojung.huh@microchip.com, o.rempel@pengutronix.de
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 26 Apr 2022 14:40:48 +0530 you wrote:
> The mib counters for the ksz9477 is same for the ksz9477 switch and
> LAN937x switch. Hence moving it to ksz_common.c file in order to have it
> generic function. The DSA hook get_stats64 now can call ksz_get_stats64.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: ksz9477: move get_stats64 to ksz_common.c
    https://git.kernel.org/netdev/net-next/c/c6101dd7ffb8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


