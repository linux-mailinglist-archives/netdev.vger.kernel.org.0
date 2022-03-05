Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A794CE31E
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 06:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiCEFlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 00:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiCEFlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 00:41:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F31D108C;
        Fri,  4 Mar 2022 21:40:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A5CBB80EFF;
        Sat,  5 Mar 2022 05:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E256DC340EE;
        Sat,  5 Mar 2022 05:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646458812;
        bh=2HcrnRgW8ZpfEDDIcxsOvuz27lZLY3BYbW66qPDaGZU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Iuy4Fa+nqDXxlhNyADipo6pVhuije7pjQYzZ5UM7weoakNHVfEUp3Hb5aUFCtYUtK
         hsQwEnQRkhZgFaO+5TKovGw5HpmiMyRMccAeP0XNBk4dw4Dyg0AiE0FSi1tk7hywqk
         t5ArATkn5EUDVfFCrtH7IDDKnx5lV+l1mSEkxZzN5SHXsQiKSaqD738yOHU09beAv9
         9ZpIojuB6dsTolQYzPBl6Mu3G5j57m7CSsQNvfVlJwD4em/bFMlqwy1g7s0Qx+fFOM
         vHnbU/o9tuNhD5XSUMxVIpvuyrzIyuQzO3QOCxtkdZ+4NJ8nuWgoDbouuYXdwxyOGP
         WKHaqpxWKxXlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C980BF0383A;
        Sat,  5 Mar 2022 05:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bcm63xx_enet: Use platform_get_irq() to get the interrupt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164645881282.22557.2559177652719280936.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Mar 2022 05:40:12 +0000
References: <20220303100815.25605-1-tangmeng@uniontech.com>
In-Reply-To: <20220303100815.25605-1-tangmeng@uniontech.com>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

On Thu,  3 Mar 2022 18:08:15 +0800 you wrote:
> platform_get_resource(pdev, IORESOURCE_IRQ, ..) relies on
> static allocation of IRQ resources in DT core code, this
> causes an issue when using hierarchical interrupt domains
> using "interrupts" property in the node as this bypassed
> the hierarchical setup and messed up the irq chaining.
> 
> In preparation for removal of static setup of IRQ resource
> from DT core code use platform_get_irq().
> 
> [...]

Here is the summary with links:
  - bcm63xx_enet: Use platform_get_irq() to get the interrupt
    https://git.kernel.org/netdev/net-next/c/43ff0d76f235

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


