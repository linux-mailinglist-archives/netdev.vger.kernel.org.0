Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697C34A860B
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 15:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351092AbiBCOUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 09:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235184AbiBCOUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 09:20:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF5EC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 06:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 993BFB83440
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6706BC340ED;
        Thu,  3 Feb 2022 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643898010;
        bh=erX62OGm51ozlceRbU95fzzpdgtikOdAH7SqX93HGlQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NBjFwVjxOKeJWkcMohO4cLz0IrIX9ktbTSMRa5WNl0I5WDLgQOFtuxv4GNaqV+Nwd
         wNvr8jJq+BZ43m6CTibXtLmgLISUqE+nkoUSH/0EJzOHN4dhqQ3rOhGJ6bBepJMvWi
         0TeGsZP/5ZLQWx7H3R/F4QwkMjM7Qa8dkKEpsVQwX4SQOVn1DqpM9SVkYS+v3R/wxI
         6SbnNxKOqAVSK//H9G9xrb1j/ZL8E/Ia5A7wGs49jsC1I+L8B/BQjO+0i2INPxjE5T
         7InXSLKNbz1nbjepvTjEiScT3nsVMonVF5WcMjN4OgH7Lo2kyF2paloa3eH43O3Va8
         wCy5HtJWV6gXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50776E6BB30;
        Thu,  3 Feb 2022 14:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: dsa: mv88e6xxx: convert to
 phylink_generic_validate()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164389801032.22502.1096303467123541469.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 14:20:10 +0000
References: <YfvYxNAkOZ6aNxql@shell.armlinux.org.uk>
In-Reply-To: <YfvYxNAkOZ6aNxql@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kabel@kernel.org, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 3 Feb 2022 13:29:40 +0000 you wrote:
> Hi,
> 
> The overall objective of this series is to convert the mv88e6xxx DSA
> driver to use phylink_generic_validate().
> 
> Patch 1 adds a new helper mv88e6352_g2_scratch_port_has_serdes() which
> indicates whether an 88e6352 port has a serdes associated with it. This
> is necessary as ports 4 and 5 will normally be in automedia mode, where
> the CMODE field in the port status register will change e.g. between 15
> (internal PHY) and 9 (1000base-X) depending on whether the serdes has
> link.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: dsa: mv88e6xxx: add mv88e6352_g2_scratch_port_has_serdes()
    https://git.kernel.org/netdev/net-next/c/62001548a6da
  - [net-next,2/4] net: dsa: mv88e6xxx: populate supported_interfaces and mac_capabilities
    https://git.kernel.org/netdev/net-next/c/d4ebf12bcec4
  - [net-next,3/4] net: dsa: mv88e6xxx: convert to phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/2ee84cfefb1e
  - [net-next,4/4] net: dsa: mv88e6xxx: improve 88e6352 serdes statistics detection
    https://git.kernel.org/netdev/net-next/c/7f7d32bc2608

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


