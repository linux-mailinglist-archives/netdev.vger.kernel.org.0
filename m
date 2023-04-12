Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C206DF160
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 12:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjDLKA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 06:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjDLKAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 06:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6728A76A8;
        Wed, 12 Apr 2023 03:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E18B163287;
        Wed, 12 Apr 2023 10:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41DBFC4339B;
        Wed, 12 Apr 2023 10:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681293618;
        bh=0USKzQ/BAHRd3fJC/Zv9GU2+CGfcNJ9zDtL52XWxtyg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q/sc5DhkpbN6bky4c27vZiqWxTQKCJxqwvfujU68npFflFRT6MrGFpDou4/pbCjji
         QzcuRRHPvv0n7GnTDzRaFvRuGu1riYtoYpOOumx5pzURyNfpJW1d4Ce0zl5Oj+tfyg
         7vbfmPojnptNKjhIR6yE2UIdZuxsaq4Vji48LEHcw8X1ANmUzNSSO871vhF/oMp9Ji
         BKYtxVvzClNNGscyxapT8VbvIUW/4AI06mdgMZLDT7ctWjP6Gg9yQ8GTkGFOO6PhRz
         Sf9GSrgZNxupVy1R9zjDc8K0vSh09Qj7ZO2nk2Oyec94lyEJ9+5N637sTlh67GBIbC
         6EgD59MQrXt/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2AE42E5244C;
        Wed, 12 Apr 2023 10:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ti/cpsw: Add explicit platform_device.h and
 of_platform.h includes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168129361817.28470.10368266921365115970.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Apr 2023 10:00:18 +0000
References: <20230410232719.1561950-1-robh@kernel.org>
In-Reply-To: <20230410232719.1561950-1-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 10 Apr 2023 18:27:19 -0500 you wrote:
> TI CPSW uses of_platform_* functions which are declared in of_platform.h.
> of_platform.h gets implicitly included by of_device.h, but that is going
> to be removed soon. Nothing else depends on of_device.h so it can be
> dropped. of_platform.h also implicitly includes platform_device.h, so
> add an explicit include for it, too.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> 
> [...]

Here is the summary with links:
  - net: ti/cpsw: Add explicit platform_device.h and of_platform.h includes
    https://git.kernel.org/netdev/net/c/136f36c74b03

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


