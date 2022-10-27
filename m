Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F3260EE9C
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbiJ0DbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbiJ0Dao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:30:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966A625E86;
        Wed, 26 Oct 2022 20:30:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F0BDB824D8;
        Thu, 27 Oct 2022 03:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0753CC43143;
        Thu, 27 Oct 2022 03:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666841425;
        bh=8vSZi6wVr8ddNvQowjQKzq7Y/LsrBq97jyZukE3QGKk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rFHvI1j57UiFIVtKeUdO497/TVwRqU0utUYjr+covVF1X+ctadAgP5o2QyZIrLJt8
         5LxKxpfsg6jiagHjrBYfPhZ3+mDX5ovzRP5ezK6ttXNEKdfQJVZWeZsbh5unRge0Nd
         RUeSvvbtLAlQyPQWJbOIxaRV4OqT3tqhcA9xBldo/M4Sa3jhR+bLMBYRs7tVS+kEzt
         sqFM++ZlZqscTuIEoeUHpRpAu6TSjUQblk13CANKDiBE4neX+K106EpCqj+8UiiiAU
         Gy+j4y6m4pBiy4Gpdy8hTK9fW1E95KRNCiaCCS6WuGFWGpJItuEM13auauJjE+LCnK
         ZfQzd96u4608A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0A9CC4166D;
        Thu, 27 Oct 2022 03:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ave: Remove duplicate phy_resume()
 calls
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166684142491.32384.12608650847239016524.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 03:30:24 +0000
References: <20221024072314.24969-1-hayashi.kunihiko@socionext.com>
In-Reply-To: <20221024072314.24969-1-hayashi.kunihiko@socionext.com>
To:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 24 Oct 2022 16:23:14 +0900 you wrote:
> ave_open() in ave_resume() executes __phy_resume() via phy_start(), so no
> need to call phy_resume() explicitly. Remove it.
> 
> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> ---
>  drivers/net/ethernet/socionext/sni_ave.c | 6 ------
>  1 file changed, 6 deletions(-)

Here is the summary with links:
  - [net-next] net: ethernet: ave: Remove duplicate phy_resume() calls
    https://git.kernel.org/netdev/net-next/c/3a6573b7a218

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


