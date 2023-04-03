Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29EC76D4026
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbjDCJU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbjDCJUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:20:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC83CC1B
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 02:20:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC3DAB81630
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 09:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51152C433D2;
        Mon,  3 Apr 2023 09:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680513625;
        bh=fL3QVhMoCHdOO+4IFvoWKxLN51UNcomzKchux2u1W7Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rux2gjhDGxkVzI+vYVDUUa+WZCg1KrI1exjEf4UCBl4lCpbqzsgj4d0nWdKtkfmL5
         delI3p2EZBxUIWMjiL0gHBCBTD85ppHMxhZCO4CUQ2J5si7TKyZTiOdsbgYkigZF/v
         PfM2hRILWSO1mi9lK6JmMzCqVPOXL6A9Q5ThZeqXGPSi6HjXmnSOyLNhg2NNG3qgOQ
         rDYwVih1SHzIMT/KrcCA5Z/Vj9LBQewcNRUHgPQbdeEohKjTN+sLZiqpRPXkh3HbrM
         kUIJkxlet3DJzJ8GggBBN/I2xU4U0UkLSWZNhTtnbr+MMd3tZvqOFpj5XwYUakIGw+
         Ov0lp+1wXyDpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 390FBE5EA82;
        Mon,  3 Apr 2023 09:20:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/7] net: phy: smsc: add support for edpd tunable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168051362522.15794.1695880460690842406.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Apr 2023 09:20:25 +0000
References: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
In-Reply-To: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, edumazet@google.com,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        cphealy@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Sun, 2 Apr 2023 17:10:34 +0200 you wrote:
> This adds support for the EDPD PHY tunable.
> Per default EDPD is disabled in interrupt mode, the tunable can be used
> to override this, e.g. if the link partner doesn't use EDPD.
> The interval to check for energy can be chosen between 1000ms and
> 2000ms. Note that this value consists of the 1000ms phylib interval
> for state machine runs plus the time to wait for energy being detected.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/7] net: phy: smsc: rename flag energy_enable
    https://git.kernel.org/netdev/net-next/c/fc281d78b686
  - [net-next,v2,2/7] net: phy: smsc: add helper smsc_phy_config_edpd
    https://git.kernel.org/netdev/net-next/c/89946e31ff4f
  - [net-next,v2,3/7] net: phy: smsc: clear edpd_enable if interrupt mode is used
    https://git.kernel.org/netdev/net-next/c/d56417ad1133
  - [net-next,v2,4/7] net: phy: smsc: add flag edpd_mode_set_by_user
    https://git.kernel.org/netdev/net-next/c/a62051108096
  - [net-next,v2,5/7] net: phy: smsc: prepare for making edpd wait period configurable
    https://git.kernel.org/netdev/net-next/c/1ce658693b08
  - [net-next,v2,6/7] net: phy: smsc: add support for edpd tunable
    https://git.kernel.org/netdev/net-next/c/657de1cf258d
  - [net-next,v2,7/7] net: phy: smsc: enable edpd tunable support
    https://git.kernel.org/netdev/net-next/c/3c4c3b3e6d41

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


