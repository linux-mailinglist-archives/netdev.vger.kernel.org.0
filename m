Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F494C3E0A
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 06:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237623AbiBYFus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 00:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiBYFur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 00:50:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DDFB820E
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 21:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D026DB82B43
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 05:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B8F0C340E8;
        Fri, 25 Feb 2022 05:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645768213;
        bh=80Po2n9ApP12RROLetizT0+ctJekA+Yt7UdfUizkk58=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XKRZLzQRev73Z1nNSvg5db2WOJxgxf4TDFfChmvwKgHxMXBRYKrOuKRcyxI28KcMT
         qWEsXGkMS9LYRWPFdt/yRO9YalGLYWxI5SSrkb+Ex3sRiulNFUeM3Ua0OoYtU0uFR/
         eWswMb8PND8nvgFxohOclB1nwDjkS8ejciJ7mQA1LT0FoAJwvww4Gv/aUYYx9qW5rx
         sWr2md3blKk8mftSkk6jDsGJGhrx+lEpD8NpD1VIbZHnRSbpUckk0+c9FvCYFbR9Mf
         b7eWIPuxyXbz4z9bgxD2OJnpcWmH6iBAoIn9uT7FohcNPch8V5mtniK2zBMkK95/CD
         bAuUMTq8XfGdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5F4BBE6D4BB;
        Fri, 25 Feb 2022 05:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 00/11] FDB entries on DSA LAG interfaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164576821338.17067.9276747625667386675.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 05:50:13 +0000
References: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, ansuelsmth@gmail.com, tobias@waldekranz.com,
        dqfext@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        jiri@resnulli.us, ivecera@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 23 Feb 2022 16:00:43 +0200 you wrote:
> v4->v5:
> - resent v4, which was marked as non applicable in patchwork (due to
>   other patches getting accepted in the meanwhile, the offsets of some
>   hunks changed a little, no other changes)
> v3->v4:
> - avoid NULL pointer dereference in dsa_port_lag_leave() when the LAG is
>   not offloaded (thanks to Alvin Šipraga)
> - remove the "void *ctx" left over in struct dsa_switchdev_event_work
> - make sure the dp->lag assignment is last in dsa_port_lag_create()
> v2->v3:
> - Move the complexity of iterating over DSA slave interfaces that are
>   members of the LAG bridge port from dsa_slave_fdb_event() to
>   switchdev_handle_fdb_event_to_device().
> 
> [...]

Here is the summary with links:
  - [v5,net-next,01/11] net: dsa: rename references to "lag" as "lag_dev"
    https://git.kernel.org/netdev/net-next/c/46a76724e4c9
  - [v5,net-next,02/11] net: dsa: mv88e6xxx: rename references to "lag" as "lag_dev"
    https://git.kernel.org/netdev/net-next/c/e23eba722861
  - [v5,net-next,03/11] net: dsa: qca8k: rename references to "lag" as "lag_dev"
    https://git.kernel.org/netdev/net-next/c/066ce9779c7a
  - [v5,net-next,04/11] net: dsa: make LAG IDs one-based
    https://git.kernel.org/netdev/net-next/c/3d4a0a2a46ab
  - [v5,net-next,05/11] net: dsa: mv88e6xxx: use dsa_switch_for_each_port in mv88e6xxx_lag_sync_masks
    https://git.kernel.org/netdev/net-next/c/b99dbdf00bc1
  - [v5,net-next,06/11] net: dsa: create a dsa_lag structure
    https://git.kernel.org/netdev/net-next/c/dedd6a009f41
  - [v5,net-next,07/11] net: switchdev: remove lag_mod_cb from switchdev_handle_fdb_event_to_device
    https://git.kernel.org/netdev/net-next/c/ec638740fce9
  - [v5,net-next,08/11] net: dsa: remove "ds" and "port" from struct dsa_switchdev_event_work
    https://git.kernel.org/netdev/net-next/c/e35f12e993d4
  - [v5,net-next,09/11] net: dsa: call SWITCHDEV_FDB_OFFLOADED for the orig_dev
    https://git.kernel.org/netdev/net-next/c/93c798230af5
  - [v5,net-next,10/11] net: dsa: support FDB events on offloaded LAG interfaces
    https://git.kernel.org/netdev/net-next/c/e212fa7c5418
  - [v5,net-next,11/11] net: dsa: felix: support FDB entries on offloaded LAG interfaces
    https://git.kernel.org/netdev/net-next/c/961d8b699070

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


