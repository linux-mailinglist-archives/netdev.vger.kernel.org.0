Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FCE5A86BC
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiHaTaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiHaTaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:30:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1460553000
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 12:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7A9CB82296
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 19:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A53EFC433C1;
        Wed, 31 Aug 2022 19:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661974214;
        bh=Q8bjw6U0uMIRz6FH16Yvq3uY0oT0OobK+1qiaO7CjKE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I9nhLEjw0Euwlf7Yh4RW2PA6Dl1wCYsUo5kIx+vKTpGBzGcMjmyFyifbnJfAqubfp
         T09RDDTOoVWYleeq19cG5QtV1VhFstldJtj5S1NbuwFF1pPeFdT78A7P3BZjKamKCz
         h4lWCkPaA2zC5ZV62oJRmR0T5dGLI0Fi2s5MTFTU3xB1i7lmXz7nBFvkS3k6veDqFQ
         JXVIflp7zP8e+UGdgG0DUBQbenyunmR4aWXkqOMqR7mhfxbHLT1ad3yoJ+iHMDIX4L
         2umMLvMPGWJGJvlKVriURATJIniHqkxkQHsu5fujpvg5rGYMJY2T1DuiBSKR/p+tga
         9lOGndlaPslfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89087E924D6;
        Wed, 31 Aug 2022 19:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: smsc: use device-managed clock API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166197421455.10446.3807259893192563791.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 19:30:14 +0000
References: <b222be68-ba7e-999d-0a07-eca0ecedf74e@gmail.com>
In-Reply-To: <b222be68-ba7e-999d-0a07-eca0ecedf74e@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
        andrew@lunn.ch
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 28 Aug 2022 19:26:55 +0200 you wrote:
> Simplify the code by using the device-managed clock API.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/smsc.c | 30 +++++-------------------------
>  1 file changed, 5 insertions(+), 25 deletions(-)

Here is the summary with links:
  - [net-next] net: phy: smsc: use device-managed clock API
    https://git.kernel.org/netdev/net-next/c/8af1a9afe100

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


