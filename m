Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE5E560FE8
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 06:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiF3EKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 00:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiF3EKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 00:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34302FFDD
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 21:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F955B82718
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 04:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C443C341CA;
        Thu, 30 Jun 2022 04:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656562213;
        bh=J/x/iqmxSiTV2RL1YRKKwJrZpEv92MsafQRCFMRosa0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A5itLe7H8UyJXjkrnHft03xQg76fT9i23ObVlj6/UNbTYvOpCs7IFFRfGeufODuih
         Xj/KSiNnn7y3T6fI+G3/Cj4Vc00qs4td3DYfiBFuC0z586aj2j1UN5JoNa2B5kRudH
         FDqEJGI57oowhJxBLR2MYPZazi/mHIcqGrWH6btZhuvk2VuwaR4c3EGsLcKpV4NZZJ
         3AWWv7sgteMVEW/VuCkXmYewETUasC8jtW/x7YcPR3sD0Iu4S4sWaPc/PoylwKHK1T
         tPv1r5zZq5GRExNp6fa81/L4eMML2EhldwKGAhxKxc1zP0vSG5Kh/SVOun1gWDbUqc
         oI1kiNgz0a6uw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E46EDE49FA0;
        Thu, 30 Jun 2022 04:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8] net: txgbe: Add build support for txgbe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165656221293.5522.3655865265786820028.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 04:10:12 +0000
References: <20220628095530.889344-1-jiawenwu@trustnetic.com>
In-Reply-To: <20220628095530.889344-1-jiawenwu@trustnetic.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Jun 2022 17:55:30 +0800 you wrote:
> Add doc build infrastructure for txgbe driver.
> Initialize PCI memory space for WangXun 10 Gigabit Ethernet devices.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
> Change log:
> v8: address comments:
>     Jakub Kicinski: https://lore.kernel.org/netdev/20220621223716.5b936d93@kernel.org/
> v7: address comments:
>     Andrew Lunn & Jakub Kicinski: https://lore.kernel.org/netdev/20220616132908.789b9be4@kernel.org/
> v6: address comments:
>     Jakub Kicinski: make it build cleanly with W=1 C=1
> v5: address comments:
>     Andrew Lunn: repost the patch
> v4: address comments:
>     Leon Romanovsky: remove unused data setting, add PCI quirk
>     Andrew Lunn: remove devm_iounmap(), use module_pci_driver()
> v3: address comments:
>     Andrew Lunn: https://lore.kernel.org/netdev/YoRkONdJlIU0ymd6@lunn.ch/
> v2: address comments:
>     Andrew Lunn & Jakub Kicinski: https://lore.kernel.org/netdev/Yn2E8X6f8PJ0c4CB@lunn.ch/
> 
> [...]

Here is the summary with links:
  - [net-next,v8] net: txgbe: Add build support for txgbe
    https://git.kernel.org/netdev/net-next/c/3ce7547e5b71

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


