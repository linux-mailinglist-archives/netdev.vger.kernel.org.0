Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448C04AF237
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbiBINAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiBINAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:00:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6303C05CBB0
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46BDAB82103
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0653BC340EB;
        Wed,  9 Feb 2022 13:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644411610;
        bh=X5uyIyMmQAVEsf6bAqVY0iQv12AMKbfrJDMBFlPPexI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CDaeGN9Ep/IqwR4ubPQ0uwumq2Aw+7Dws70qLr+Abp6tddM6R1azam0koCFAOgHL6
         QFs9T69MdwjrZIePIRbdY3bVUzmQ99AwkpMXncEs8WdGq6QkqZ+23RpxCl/sWmftjJ
         h3PVpLSAdVDQbaWhRr9oFbstxTWmzJ27PsQ5iefz0zN6Bfx/Ul3JRwIIIIdpYMDtXw
         rWJhkFcuOBHAX2oVhu8vh5MC+FYpwjAOuVDCYVub056Q09svyHYNPQIc4MZTMCpYfU
         08IGjB1iCrUSpEXcK3D06l982s3F0ZpTksmtnGy/QEvnmQH7h1vB0rjfKngT6mr9c6
         76zTgZkG0LlKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DDCA8E6D458;
        Wed,  9 Feb 2022 13:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: amd-xgbe: disable interrupts during pci removal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164441160990.8299.1367888794996416900.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 13:00:09 +0000
References: <20220209043201.1365811-1-Raju.Rangoju@amd.com>
In-Reply-To: <20220209043201.1365811-1-Raju.Rangoju@amd.com>
To:     Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     thomas.lendacky@amd.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Selwin.Sebastian@amd.com
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

On Wed, 9 Feb 2022 10:02:01 +0530 you wrote:
> Hardware interrupts are enabled during the pci probe, however,
> they are not disabled during pci removal.
> 
> Disable all hardware interrupts during pci removal to avoid any
> issues.
> 
> Fixes: e75377404726 ("amd-xgbe: Update PCI support to use new IRQ functions")
> Suggested-by: Selwin Sebastian <Selwin.Sebastian@amd.com>
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
> 
> [...]

Here is the summary with links:
  - [net] net: amd-xgbe: disable interrupts during pci removal
    https://git.kernel.org/netdev/net/c/68c2d6af1f1e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


