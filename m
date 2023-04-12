Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5996DEA86
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjDLEaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDLEaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645E2469D
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0069662DE4
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61011C433A7;
        Wed, 12 Apr 2023 04:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681273819;
        bh=coZnWxkTjz/xrWliIup5323Ki1XDPpMThn634ezvPpE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZKHA98Yg26xykA51HafXwmmoKSp3Cg0qQpiEBgt9tFOYrWk9kKgGxr6VH5c5mhTUM
         0pxRk6F2WKO5ZBy3h4cwN6MvkS1nDt0+5FhcMC/ZgAg8/5V2vYt9kzzI7ig7PefI/g
         mnAE5mYeioFN8j0YWspicKiemv7ejnpNOhMIkDeLopdXf9mjLYLaShRPnPg/xZjIdi
         A18vziYumDkX5UOSUGTzHH86Z26vsBhke+DLWp5/mdHUsGzlKwSYwY4E6fPsYzWlcC
         i9ESfil0bYysSVLCHa38/ZwhXjeKqsihlxJ7JREvy96i0M+dWfUde0sQIpOvQIx+lR
         K1T855TFcTLhg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4936CE52447;
        Wed, 12 Apr 2023 04:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Correct cmode to PHY_INTERFACE_
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168127381929.9603.10340764048663154241.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Apr 2023 04:30:19 +0000
References: <20230411023541.2372609-1-andrew@lunn.ch>
In-Reply-To: <20230411023541.2372609-1-andrew@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, vladimir.oltean@nxp.com,
        rmk+kernel@armlinux.org.uk, netdev@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 11 Apr 2023 04:35:41 +0200 you wrote:
> The switch can either take the MAC or the PHY role in an MII or RMII
> link. There are distinct PHY_INTERFACE_ macros for these two roles.
> Correct the mapping so that the `REV` version is used for the PHY
> role.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: mv88e6xxx: Correct cmode to PHY_INTERFACE_
    https://git.kernel.org/netdev/net-next/c/18bb56ab4477

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


