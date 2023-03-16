Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7096BD74A
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjCPRlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjCPRlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:41:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3F31ADCC
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 10:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1B8B620B9
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 17:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F6A1C433A7;
        Thu, 16 Mar 2023 17:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678988418;
        bh=mHlIN80lM89x49SwJnDDOJ5px4eScubR8UqsMY5usew=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gXsPNlLWrDWy3Rzza5BUUh3WdLfBcM40uRhL5GS3yRwx9yq4lmwN5ieAxV+qT0Lm0
         2nURLR+xUxHjpRIloCjuimImGGofsDFX3YZLy3xAlmefP+RjY1XYE3/YGHlnGS3f54
         Izn8wsQ0D4K9epIMJBu6FnVi3XirDhr9IQR6ThoEkBaAAG9d1FXKHgj28/bFwoOYlW
         zpf/fu7Ggc2pnCJ+dD608aZrTX8jPBBZPloYIb3wcBvFT8HO5yE+Sr0h7GW8zrzSyU
         DHyn7q+62dqrcoi+u9ub3T30iCBNrsu/+3bOy+JfsHFaEVgcXTGyE/djiPXzsmZwH5
         WIDDL7hZVC+kg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07BA2E29F32;
        Thu, 16 Mar 2023 17:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5] net: phy: mxl-gpy: enhance delay time required by
 loopback disable function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167898841801.29063.7860389499742389129.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 17:40:18 +0000
References: <20230314163023.36637-1-lxu@maxlinear.com>
In-Reply-To: <20230314163023.36637-1-lxu@maxlinear.com>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        hmehrtens@maxlinear.com, tmohren@maxlinear.com,
        rtanwar@maxlinear.com, mohammad.athari.ismail@intel.com,
        edumazet@google.com, michael@walle.cc, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Mar 2023 00:30:23 +0800 you wrote:
> GPY2xx devices need 3 seconds to fully switch out of loopback mode
> before it can safely re-enter loopback mode. Implement timeout mechanism
> to guarantee 3 seconds waited before re-enter loopback mode.
> 
> Signed-off-by: Xu Liang <lxu@maxlinear.com>
> ---
> v2 changes:
>  Update comments.
> 
> [...]

Here is the summary with links:
  - [net-next,v5] net: phy: mxl-gpy: enhance delay time required by loopback disable function
    https://git.kernel.org/netdev/net-next/c/0ba13995be9b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


