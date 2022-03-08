Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C21D4D1389
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 10:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240425AbiCHJlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 04:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235743AbiCHJlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 04:41:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835F23137A
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 01:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F2756144A
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 09:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A828C340F5;
        Tue,  8 Mar 2022 09:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646732410;
        bh=Nmo1N3L96wUjTfFCwXLMCmkplu7Sw6/wAkNlV3L5jso=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ole2LrSLi8Nm9eSE37PJ9EOFTqxH89NW/yTFVJ/Ipk2YbU3YfVtBHTnWNuDDwsOW1
         /B+ufQ+n6spCEYn88LDtZptV6717gbtzMaS3xm/BDRnjhUR8BmO8k7VhOJNLbLZA0P
         jeDObNtoMpQe+ofUUV2hRGyXrgXnK7Rb58YrIQWpRRdNZwNnEkJGudJs58ad3WFTux
         904HAuYkee7aQVPVOt1pWXBokntlXfJU5/H1M3cH8O2mLYBHb80eu+HtWuUvA9sLw0
         Dg5H0EnzAQePoNe33+dRdnfiYinl+JWF8/S6c8cw7umBjQfvIqW0CDQoeph28g8as0
         RVnMho0YiQPLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58F81F0383B;
        Tue,  8 Mar 2022 09:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mdio-mux: add bus name to bus id
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164673241036.2138.12004932515706799898.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Mar 2022 09:40:10 +0000
References: <00b4bb1e-98f9-b4e7-5549-e095a4701f66@gmail.com>
In-Reply-To: <00b4bb1e-98f9-b4e7-5549-e095a4701f66@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 6 Mar 2022 15:22:34 +0100 you wrote:
> In case of DT-configured systems it may be hard to identify the PHY
> interrupt in the /proc/interrupts output. Therefore add the name to
> the id to make clearer that it's about a device on a muxed mdio bus.
> In my case:
> 
> Now: mdio_mux-0.e40908ff:08
> Before: 0.e40908ff:08
> 
> [...]

Here is the summary with links:
  - [net-next] net: mdio-mux: add bus name to bus id
    https://git.kernel.org/netdev/net-next/c/1416ea0ddc14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


