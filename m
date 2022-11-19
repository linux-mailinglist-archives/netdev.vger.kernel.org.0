Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789BA630CBE
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 07:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbiKSGuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 01:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiKSGuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 01:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6A91704F;
        Fri, 18 Nov 2022 22:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0B52B80D1E;
        Sat, 19 Nov 2022 06:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5944BC433D6;
        Sat, 19 Nov 2022 06:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668840616;
        bh=ak6M5fgrTHQ1MM2vf+n5AubLq+AMYqmK/RRzz3/3gig=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=seXipkg9CAyFA9/DRpiD01V8ITXAB4g0Feuk+M72plAUXo40561rs1dMVurztjC0R
         UGqXlOdf3JC5VrI2IWVezRWqsbHRKhLTyD3mEBicEAh2WBWvOY+SAmQ5aoJgjdz1Vk
         5aq4YUvgNncdPRSw5IsP6xY0s8PudX8SdTsR/EyWyOmZxNi+pkZtOu70losD9BrvnB
         Du21LerJzoVvVs4d9eSLNMvDcUU7T0jOw29zyRduMgSnRBWCRcfu03u6uXJN2UHbLy
         DMpzJwBt86Z35Odc5hTd6y/3r7eqH4zheZmOWuKtOuYVHcjUBHn5l00sWabdAIfdsG
         FRNiHf2EtKUDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 37F78E29F44;
        Sat, 19 Nov 2022 06:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 000/606] i2c: Complete conversion to i2c_probe_new
From:   patchwork-bot+chrome-platform@kernel.org
Message-Id: <166884061622.19423.870710096225259467.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Nov 2022 06:50:16 +0000
References: <20221118224540.619276-1-uwe@kleine-koenig.org>
In-Reply-To: <20221118224540.619276-1-uwe@kleine-koenig.org>
To:     =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cuwe=40kleine-koenig=2Eorg=3E?=@ci.codeaurora.org
Cc:     ang.iglesiasg@gmail.com, lee.jones@linaro.org,
        grant.likely@linaro.org, wsa@kernel.org, linux-i2c@vger.kernel.org,
        kernel@pengutronix.de, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-gpio@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-leds@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-media@vger.kernel.org, patches@opensource.cirrus.com,
        linux-actions@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-amlogic@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-pm@vger.kernel.org, kernel@puri.sm,
        linux-pwm@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-watchdog@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to chrome-platform/linux.git (for-kernelci)
by Tzung-Bi Shih <tzungbi@kernel.org>:

On Fri, 18 Nov 2022 23:35:34 +0100 you wrote:
> Hello,
> 
> since commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
> call-back type") from 2016 there is a "temporary" alternative probe
> callback for i2c drivers.
> 
> This series completes all drivers to this new callback (unless I missed
> something). It's based on current next/master.
> A part of the patches depend on commit 662233731d66 ("i2c: core:
> Introduce i2c_client_get_device_id helper function"), there is a branch that
> you can pull into your tree to get it:
> 
> [...]

Here is the summary with links:
  - [512/606] platform/chrome: cros_ec: Convert to i2c's .probe_new()
    https://git.kernel.org/chrome-platform/c/f9e510dc92df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


