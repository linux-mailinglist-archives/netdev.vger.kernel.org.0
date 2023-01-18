Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3CB6711F9
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjARDaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjARDaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6863803F;
        Tue, 17 Jan 2023 19:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FEC2B81B03;
        Wed, 18 Jan 2023 03:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83CB9C43398;
        Wed, 18 Jan 2023 03:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674012617;
        bh=czsil1PzGLTB+Wz/L1hFQX9kEjb+CR5HK78rmDnTkkY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PjcDJUhOV9chtMleq3j09kQQCGfAwHGoAHtf6imxsBedwmb83LPBpYatdTdSRaawJ
         DCARg8s8Yaav1DyF2rOd0bCGa3kH+BYh67O4VNioKZTwzRyt39AZ8DEUHUgQu0pK6h
         coKMYpY5B4XWp0Tw+Mb5eUPYZQQ7afaIkWznYE98cDZd5yuz0/lHtLVlhMTmbUqSiQ
         /kThuItZ9EaC+KaG4aUwyJciTgdCzU4JpwnTsOY1qFzOarGsiC0Nlv6K3V5xx6RJ5t
         QFo2v+AVhWtRMEzBfPPlqr/TEEA+DKwNOIOBsVG0xrZUAaVK0JNBm9ivneaadUtDzT
         HWzDVWykAjBVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 722B8C43159;
        Wed, 18 Jan 2023 03:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PULL REQUEST] i2c-fwnode-api-2023017 for netdev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167401261746.15291.7007939318996100610.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 03:30:17 +0000
References: <Y8ZhI4g0wsvpjokd@ninjato>
In-Reply-To: <Y8ZhI4g0wsvpjokd@ninjato>
To:     Wolfram Sang <wsa@kernel.org>
Cc:     netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
        rmk+kernel@armlinux.org.uk
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 17 Jan 2023 09:49:39 +0100 you wrote:
> Hi,
> 
> here is an immtuable branch from I2C requested by Russell King. This
> allows him to rework SFP code further.
> 
> Please pull.
> 
> [...]

Here is the summary with links:
  - [PULL,REQUEST] i2c-fwnode-api-2023017 for netdev
    https://git.kernel.org/netdev/net-next/c/f3a1e0c896e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


