Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30F465FB63
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjAFGVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbjAFGUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:20:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0887E6E40D
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7004B81BFD
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BE3BC433EF;
        Fri,  6 Jan 2023 06:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672986018;
        bh=x2z8/EpGQc2LkpHVWixivXW+Q/U0vkCA8gbE55MjCJw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sQGHWH4Axd4U8degOl5SWDNM0+yeDANyX2BJ0wmTLaKARo30njQqKQwhZgXo/uXI8
         k5NjC/5pCbYnxRUcn0+yCaGBoyDtj7udQvEK+eBNqHK253R44hUf42mEjqDxXWUO3d
         EelADgL2du6fGvQk6vTEHymN24W0watXFLZWVOb16NFZjY1G8YYebSBKISicM9rDEt
         VnTnZXoKOK2ltOkwXZUGUBITfUaJMX3Y7L17yuBIECn5U9ZZyGjahwbcqGApWR5m4I
         KryyOjQxJnq9NJ6NGB+MbGpGz3A7U0Meu0xxib44fpN4lStbR3qF2xiKYZTWs5X/6x
         QH0trxY3pCTEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 546F0E21EEB;
        Fri,  6 Jan 2023 06:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/15]  devlink: code split and structured
 instance walk
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167298601834.4609.10563145944962909204.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Jan 2023 06:20:18 +0000
References: <20230105040531.353563-1-kuba@kernel.org>
In-Reply-To: <20230105040531.353563-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, jiri@resnulli.us
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 Jan 2023 20:05:16 -0800 you wrote:
> Split devlink.c into a handful of files, trying to keep the "core"
> code away from all the command-specific implementations.
> The core code has been quite scattered until now. Going forward we can
> consider using a source file per-subobject, I think that it's quite
> beneficial to newcomers (based on relative ease with which folks
> contribute to ethtool vs devlink). But this series doesn't split
> everything out, yet - partially due to backporting concerns,
> but mostly due to lack of time. Bulk of the netlink command
> handling is left in a leftover.c file.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/15] devlink: move code to a dedicated directory
    (no matching commit)
  - [net-next,v2,02/15] devlink: rename devlink_netdevice_event -> devlink_port_netdevice_event
    https://git.kernel.org/netdev/net-next/c/e50ef40f9a9a
  - [net-next,v2,03/15] devlink: split out core code
    (no matching commit)
  - [net-next,v2,04/15] devlink: split out netlink code
    https://git.kernel.org/netdev/net-next/c/623cd13b1654
  - [net-next,v2,05/15] netlink: add macro for checking dump ctx size
    https://git.kernel.org/netdev/net-next/c/2c7bc10d0f7b
  - [net-next,v2,06/15] devlink: use an explicit structure for dump context
    https://git.kernel.org/netdev/net-next/c/3015f8224961
  - [net-next,v2,07/15] devlink: remove start variables from dumps
    https://git.kernel.org/netdev/net-next/c/20615659b514
  - [net-next,v2,08/15] devlink: drop the filter argument from devlinks_xa_find_get
    https://git.kernel.org/netdev/net-next/c/8861c0933c78
  - [net-next,v2,09/15] devlink: health: combine loops in dump
    https://git.kernel.org/netdev/net-next/c/a0e13dfdc391
  - [net-next,v2,10/15] devlink: restart dump based on devlink instance ids (simple)
    https://git.kernel.org/netdev/net-next/c/731d69a6bd13
  - [net-next,v2,11/15] devlink: restart dump based on devlink instance ids (nested)
    https://git.kernel.org/netdev/net-next/c/a8f947073f4a
  - [net-next,v2,12/15] devlink: restart dump based on devlink instance ids (function)
    https://git.kernel.org/netdev/net-next/c/c9666bac537e
  - [net-next,v2,13/15] devlink: uniformly take the devlink instance lock in the dump loop
    https://git.kernel.org/netdev/net-next/c/e4d5015bc11b
  - [net-next,v2,14/15] devlink: add by-instance dump infra
    https://git.kernel.org/netdev/net-next/c/07f3af66089e
  - [net-next,v2,15/15] devlink: convert remaining dumps to the by-instance scheme
    https://git.kernel.org/netdev/net-next/c/5ce76d78b996

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


