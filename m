Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF8769448D
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 12:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjBMLav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 06:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjBMLaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 06:30:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBB44EE2;
        Mon, 13 Feb 2023 03:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49517B81193;
        Mon, 13 Feb 2023 11:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11B2CC433D2;
        Mon, 13 Feb 2023 11:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676287818;
        bh=SMomGZUWf/X7WdKybml+B0OSPVKkL3Uyt487pPjNiNQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WyfCEEShHQ6AW/TKI7y3OTF57IPygN6yBnstNojtQ+WQCKMOFjfqXEj8CRoNeIeEy
         BO5cGSpxa1E8L2D/ROKoamQoIX0eCvu4JdFSc8ganfCywJCIwMIyQU2lJqrnl4fi53
         5dkOHtw7zSJieAFSURqUP2QGIkzc3UPYSL0mcA1GYGkCqSu1Ku+Ujc3Vsif/MIgUJr
         qH0jdrBxij5BrEeHVzchjW502aaBbpNxkSClxGTsolR/rZF7k3QjVhgE42SXv7GDPD
         C7z+bkLuGAGLDrJ5TDw7QUdN5GhBGzMJKgaapIxAYY9zr3ZKViWMAp5C0CDq1nH/lD
         afgprwGZ9K9gQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ECA2DE68D2E;
        Mon, 13 Feb 2023 11:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8 0/9] net: add EEE support for KSZ9477 switch
 family
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167628781796.3463.3151948451131518084.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 11:30:17 +0000
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
In-Reply-To: <20230211074113.2782508-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wei.fang@nxp.com,
        hkallweit1@gmail.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 11 Feb 2023 08:41:04 +0100 you wrote:
> changes v8:
> - fix comment for linkmode_to_mii_eee_cap1_t() function
> - add Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> - add Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> 
> changes v7:
> - update documentation for genphy_c45_eee_is_active()
> - address review comments on "net: dsa: microchip: enable EEE support"
>   patch
> 
> [...]

Here is the summary with links:
  - [net-next,v8,1/9] net: dsa: microchip: enable EEE support
    https://git.kernel.org/netdev/net-next/c/69d3b36ca045
  - [net-next,v8,2/9] net: phy: add genphy_c45_read_eee_abilities() function
    https://git.kernel.org/netdev/net-next/c/14e47d1fb8f9
  - [net-next,v8,3/9] net: phy: micrel: add ksz9477_get_features()
    https://git.kernel.org/netdev/net-next/c/48fb19940f2b
  - [net-next,v8,4/9] net: phy: export phy_check_valid() function
    https://git.kernel.org/netdev/net-next/c/cf9f60796968
  - [net-next,v8,5/9] net: phy: add genphy_c45_ethtool_get/set_eee() support
    https://git.kernel.org/netdev/net-next/c/022c3f87f88e
  - [net-next,v8,6/9] net: phy: c22: migrate to genphy_c45_write_eee_adv()
    https://git.kernel.org/netdev/net-next/c/9b01c885be36
  - [net-next,v8,7/9] net: phy: c45: migrate to genphy_c45_write_eee_adv()
    https://git.kernel.org/netdev/net-next/c/5827b168125d
  - [net-next,v8,8/9] net: phy: migrate phy_init_eee() to genphy_c45_eee_is_active()
    https://git.kernel.org/netdev/net-next/c/6340f9fd43d5
  - [net-next,v8,9/9] net: phy: start using genphy_c45_ethtool_get/set_eee()
    https://git.kernel.org/netdev/net-next/c/8b68710a3121

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


