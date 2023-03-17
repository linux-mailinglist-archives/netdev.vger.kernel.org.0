Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D994A6BE39A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjCQIdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjCQIck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:32:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53DF1969E
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 01:31:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 009E4B824F6
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FAE1C433D2;
        Fri, 17 Mar 2023 08:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679041821;
        bh=FUA7T+U2SlDsLW1xiq88PEc3ZuWL77xYjFP9UeGM8J8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RYsDJGaXFLLC3PaKUdGDSOgPOAzE6SHw/mDTMSfFSg6iguPe6dScURE/dk6OFozfL
         1HwVGghwOZQtEeYXSZ/Exx18phVIHB2uxA5R0ebPSwIsJRW6Mpz7o2Uh32uWGl6lOl
         NIt4QVx65h6z4wYeon5b9ZDiYjkVbWjAiwpRNwZ3JXsuB3ymOlWSlZgv6dutb7Mrj4
         Z4mR3Up7X82HPbc2SyWTXbfU+/U8zea46ebwVS28pH4SW3xl8zL8cXpO8C1WZcCfVb
         FZ8IaP9r59GwK3iVkTHgUALJ1C+rKKnQywGH7Anvwro+LMby+PAy8JrzDxt4c7ubWZ
         4UcGcmuQEWegA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B3FFE21EE6;
        Fri, 17 Mar 2023 08:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Minor fixes for pcs_get_state() implementations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167904182150.13932.9999321687826516284.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 08:30:21 +0000
References: <ZBHaQDM+G/o/UW3i@shell.armlinux.org.uk>
In-Reply-To: <ZBHaQDM+G/o/UW3i@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, ioana.ciornei@nxp.com, noodles@earth.li,
        Jose.Abreu@synopsys.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Mar 2023 14:46:24 +0000 you wrote:
> Hi,
> 
> This series contains a number fixes for minor issues with some
> pcs_get_state() implementations, particualrly for the phylink
> state->an_enabled member. As they are minor, I'm suggesting we
> queue them in net-next as there is follow-on work for these, and
> there is no urgency for them to be in -rc.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: pcs: xpcs: remove double-read of link state when using AN
    https://git.kernel.org/netdev/net-next/c/ef63461caf42
  - [net-next,2/2] net: pcs: lynx: don't print an_enabled in pcs_get_state()
    https://git.kernel.org/netdev/net-next/c/ecec0ebbc638

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


