Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307FA6C9BDB
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbjC0HUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbjC0HUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CF11715
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 00:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B2D860FD9
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32EF2C433EF;
        Mon, 27 Mar 2023 07:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679901618;
        bh=a98NZI6xqyMuRSoSTHp8c3vyhrzNvffoeEHIIe+q5L0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SXp4kDuVuAypyKlGtiua7GicZ7QhNXmQG1gWHO1No3SSyJoZsPfao9UMcBZi6I3uw
         yVZ1fqY57dsBaTAQ1XsqICTBzBdeINpu87pQiAbqMFtsHvYfwcNEmnHVj+tTPaSCtH
         waUCpB/uVyRnQhz0pltc5+bxBOpxW8W7H27jtP/XK8Lh0dpForwtByCO95fybLtcbz
         xAjhDvh7bRrUrGRQgav0YfDLSkP14h90NunO/CAeRa6AxgkF7Qrga0JkEYQ5V3bVZX
         SYgs0fv2nI9DcnENZyZkChgkCov/lqG/zHNGTz/+5L7qf7sX1krg74p33zbNHlconB
         PC2wIym8V3a5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 136A3E4D029;
        Mon, 27 Mar 2023 07:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next 0/3] Constify a few sfp/phy fwnodes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167990161807.4487.6574989274256507257.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Mar 2023 07:20:18 +0000
References: <ZB1sBYQnqWbGoasq@shell.armlinux.org.uk>
In-Reply-To: <ZB1sBYQnqWbGoasq@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Mar 2023 09:23:17 +0000 you wrote:
> Hi,
> 
> This series constifies a bunch of fwnode_handle pointers that are only
> used to refer to but not modify the contents of the fwnode structures.
> 
>  drivers/net/phy/phy_device.c | 2 +-
>  drivers/net/phy/sfp-bus.c    | 6 +++---
>  include/linux/phy.h          | 2 +-
>  include/linux/sfp.h          | 5 +++--
>  4 files changed, 8 insertions(+), 7 deletions(-)

Here is the summary with links:
  - [net-next,1/3] net: sfp: make sfp_bus_find_fwnode() take a const fwnode
    https://git.kernel.org/netdev/net/c/a90ac762d345
  - [net-next,2/3] net: sfp: constify sfp-bus internal fwnode uses
    https://git.kernel.org/netdev/net/c/850a8d2dc712
  - [net-next,3/3] net: phy: constify fwnode_get_phy_node() fwnode argument
    https://git.kernel.org/netdev/net/c/4a0faa02d419

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


