Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692374DDA2A
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 14:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236529AbiCRNLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 09:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiCRNLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 09:11:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563B72D107F;
        Fri, 18 Mar 2022 06:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E618161977;
        Fri, 18 Mar 2022 13:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 496C1C340EC;
        Fri, 18 Mar 2022 13:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647609011;
        bh=xnMWuLF9xSFJMO3TGwEUDhW3UfmSCfHpcVnzIfEHNlM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j1UAcvtbfjY470z4Mks0igshJJP48H70SIJR1EwD1tCdXEoZ2knZMXSg/6Vn0vYfX
         GCSlnO9+c+CAKz6Fsl/0SypohjqB8JwuIk3+IyIZpWpsbdCLy/qqhqK+6qcYT/b1xn
         MNXCGYQ/Xofg0Pkz+1MRpBxyyVI26l5dikswXs6HEyL8pP6u5fFanWGtm+ItdlbY5C
         Y/ZaVnLkIEJg6cHm2i++DD7/H6vRqc3M87ZHFtY16FCdcHzHVyFklx6dtuWmU/Gsg1
         4TqDE877q2p43zldEWqNKNkJYEt6Qq6l5UoFYjGASUpLGbSEZoCE1zgRWxL633R5zH
         cKUAVSIPZC6BA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2F450E6D44B;
        Fri, 18 Mar 2022 13:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V1 0/5]net: lan743x: PCI11010 / PCI11414 devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164760901119.17174.13182986404331791545.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 13:10:11 +0000
References: <20220317104310.61091-1-Raju.Lakkaraju@microchip.com>
In-Reply-To: <20220317104310.61091-1-Raju.Lakkaraju@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        richardcochran@gmail.com, UNGLinuxDriver@microchip.com,
        Ian.Saturley@microchip.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Mar 2022 16:13:05 +0530 you wrote:
> This patch series continues with the addition of supported features
> for the Ethernet function of the PCI11010 / PCI11414 devices to
> the LAN743x driver.
> 
> Raju Lakkaraju (5):
>   net: lan743x: Add support to display Tx Queue statistics
>   net: lan743x: Add support for EEPROM
>   net: lan743x: Add support for OTP
>   net: lan743x: Add support for PTP-IO Event Input External Timestamp
>     (extts)
>   net: lan743x: Add support for PTP-IO Event Output (Periodic Output)
> 
> [...]

Here is the summary with links:
  - [net-next,V1,1/5] net: lan743x: Add support to display Tx Queue statistics
    https://git.kernel.org/netdev/net-next/c/bc1962e52333
  - [net-next,V1,2/5] net: lan743x: Add support for EEPROM
    https://git.kernel.org/netdev/net-next/c/cdea83cc103a
  - [net-next,V1,3/5] net: lan743x: Add support for OTP
    https://git.kernel.org/netdev/net-next/c/d808f7ca8d23
  - [net-next,V1,4/5] net: lan743x: Add support for PTP-IO Event Input External Timestamp (extts)
    https://git.kernel.org/netdev/net-next/c/60942c397af6
  - [net-next,V1,5/5] net: lan743x: Add support for PTP-IO Event Output (Periodic Output)
    https://git.kernel.org/netdev/net-next/c/e432dd3bee2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


