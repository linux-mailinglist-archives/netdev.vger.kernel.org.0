Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CB562D770
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbiKQJuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiKQJuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D012F9;
        Thu, 17 Nov 2022 01:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B91662171;
        Thu, 17 Nov 2022 09:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA694C433D7;
        Thu, 17 Nov 2022 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668678615;
        bh=iixO4WSEABlonLogHoTjUuZ6GuM67L5sYdIDSCBSlNw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cXqNqZmZVbaW50/hM2JgvcTbt3/Z+HAd1iFQkDmX7L1BM3G9l8jAAUptf53FLGGrJ
         gGdoOJ1drP1SmIhABYY4MJvSbRAXhmEjgsQsCqAYyNX3hktt4HWqghlbv36780evii
         R1wzmnRPnQdGv2m09S6SPb2nHzaJuvqVFj0mOtHvzJsRvU+luS7ReL7CiBk7CsKRzs
         CahTxmF1aP5t08RUa9nI/XN9/W4TtnptvRWO+fOUZnzkMOK5ho9dbwTfWLITyZNtnG
         MrpkFh3ElvErYCblGjFV0SZG1EckZnQWeY2/IGUUtZ6to0Y7lSG64oAl728Dg3ZbX2
         vA1VXuVAv9syw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C00C9C395F5;
        Thu, 17 Nov 2022 09:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net v2 0/1] net: usb: smsc95xx: fix external PHY reset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166867861578.7943.2668743187142010173.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Nov 2022 09:50:15 +0000
References: <20221115114434.9991-1-alexandru.tachici@analog.com>
In-Reply-To: <20221115114434.9991-1-alexandru.tachici@analog.com>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        andre.edich@microchip.com, linux-usb@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 15 Nov 2022 13:44:33 +0200 you wrote:
> An external PHY needs settling time after power up or reset.
> In the bind() function an mdio bus is registered. If at this point
> the external PHY is still initialising, no valid PHY ID will be
> read and on phy_find_first() the bind() function will fail.
> 
> If an external PHY is present, wait the maximum time specified
> in 802.3 45.2.7.1.1.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] net: usb: smsc95xx: fix external PHY reset
    https://git.kernel.org/netdev/net/c/809ff97a677f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


