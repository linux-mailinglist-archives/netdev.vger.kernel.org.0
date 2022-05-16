Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A39529135
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 22:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiEPU2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347220AbiEPUZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:25:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBBD4B860
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A50260EC4
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C886C34115;
        Mon, 16 May 2022 20:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652731812;
        bh=zQ1fmhz+HkjzROw40/AsiQbJjBYha0LVLimbCadjaME=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uqEF6iTlVv4wRNtil2gbitOb+h7ytPFfMtROFyH25gACxtyAZOCWTMMZ5YKrKtX33
         kJY1xU1pkhq55iwmfJNbNKHUuCFWjlvh8EMJag2TqsM6Wst0EYR0r2vMEspAh/h7aX
         SvIDEwIqui1uCOmFyAk9xhZdBXl60QEM4w+5/O2I5v4XvbWlIIPDema3Zj6kL4/1ul
         QbMI9QeYcILAiIQmKwQuI+8Mw2NJgoxiLH/2brEzVGbGLaIL7t2MtlswnmFKAOBKhq
         By5HcwCBMd2o7EYeZvIhzvbNzi7Q9StqTWES9c0COK3k4jmfCN1pl5hOBGZA1LYA/R
         u5DOb5/qNMdhw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 606B1E8DBDA;
        Mon, 16 May 2022 20:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] net: phy: micrel: Allow probing without
 .driver_data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165273181239.30267.5350054361391896735.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 20:10:12 +0000
References: <20220513114613.762810-1-festevam@gmail.com>
In-Reply-To: <20220513114613.762810-1-festevam@gmail.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        netdev@vger.kernel.org, festevam@denx.de
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 13 May 2022 08:46:12 -0300 you wrote:
> From: Fabio Estevam <festevam@denx.de>
> 
> Currently, if the .probe element is present in the phy_driver structure
> and the .driver_data is not, a NULL pointer dereference happens.
> 
> Allow passing .probe without .driver_data by inserting NULL checks
> for priv->type.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: phy: micrel: Allow probing without .driver_data
    https://git.kernel.org/netdev/net-next/c/f2ef6f7539c6
  - [net-next,2/2] net: phy: micrel: Use the kszphy probe/suspend/resume
    https://git.kernel.org/netdev/net-next/c/8e6004dfecb7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


