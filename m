Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAB2623A6F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 04:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbiKJDaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 22:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbiKJDaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 22:30:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A341A225;
        Wed,  9 Nov 2022 19:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8711B61D65;
        Thu, 10 Nov 2022 03:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3FCAC4347C;
        Thu, 10 Nov 2022 03:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668051018;
        bh=YhDBP6aqc9PFkctA4gMXiqYT1uDDiUPBIpCi9juW/0w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RB5GPccg8QNzi3c3lXFpqUaPSr+3G0gvmAH7kh4ymXP3/3tSLoEAoXijz/FaIZbmr
         7cE+KL1XoaN1sdQ/IFtdtmQMZL1klEA5T6a2WKRCf08ZO4k+/VBf8n7Ryghy9KPBq/
         YlRKU88GFrTTqhQsiWYrszL3wwgttUZ5e29JM0XA8hwVj739K9JL7uiLUjfc4Gz1U2
         ofUhBpWTCChKXUO5tp/iqOOrkTnjpdRIIZ+2WPVeSElHshkYwCHIC5vptvPQwzfXKf
         vjvbwKvSEcLOg2fp+4jO4ClDWT6tYM7Z2GBFp9HJMx0fEYzkTbCiYB6ls4JY+oFRVn
         hv5FvAme2br5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B062CE21EFF;
        Thu, 10 Nov 2022 03:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: phy: dp83867: add TI PHY loopback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166805101870.26797.14285445603030575804.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 03:30:18 +0000
References: <20221108101527.612723-1-michael.wei.hong.sit@intel.com>
In-Reply-To: <20221108101527.612723-1-michael.wei.hong.sit@intel.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tee.min.tan@intel.com,
        hong.aun.looi@intel.com, weifeng.voon@intel.com,
        muhammad.husaini.zulkifli@intel.com, yi.fang.gan@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  8 Nov 2022 18:15:27 +0800 you wrote:
> From: Tan Tee Min <tee.min.tan@linux.intel.com>
> 
> The existing genphy_loopback() is not working for TI DP83867 PHY as it
> will disable autoneg support while another side is still enabling autoneg.
> This is causing the link is not established and results in timeout error
> in genphy_loopback() function.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: phy: dp83867: add TI PHY loopback
    https://git.kernel.org/netdev/net-next/c/13bd85580b85

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


