Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61D54B6F4B
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 15:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238796AbiBOOk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:40:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238774AbiBOOkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EF91029C9
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59394B81A6A
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06038C340F8;
        Tue, 15 Feb 2022 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644936011;
        bh=xhpRA9A6/zSXIm+tpDOrnyWtIUPtpoiM1oUEEAH1lOQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NjCW93vogFW98e0Mue8BfSrWRmIFcJizI80eVJGcfKrSqP0aFicDDPH/F9cBMIUPJ
         LbTJFaINeYJ+lzR07t1TNto21u+g4cSmOpuGNFWF9QQ0J18QevMMbbdXTcmtvKvW3T
         3o6+gnGRGwjo+9Ogj0As6zNOAZZDRn2CwUjiZVI3BIEqTV8+jIW4F8+Xqr+lOxWUpz
         dFcptWaIUWH0rBZQMTbRB8aM+oOvwTMB4t75I+Q5muLE4CFXbTqqVrsaQNcO1YJuvG
         TIlSwS4AUAoEUAWENkHEDzw8Wj7nG7jNXMfneF5r2aIYYUMPAme1TOE9nS3j1fan/E
         5Olgsc9SW0r2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E65CCE6BBD2;
        Tue, 15 Feb 2022 14:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mscc: ocelot: fix use-after-free in
 ocelot_vlan_del()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164493601093.31968.5280162375440741536.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 14:40:10 +0000
References: <20220214234200.1594787-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220214234200.1594787-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 15 Feb 2022 01:42:00 +0200 you wrote:
> ocelot_vlan_member_del() will free the struct ocelot_bridge_vlan, so if
> this is the same as the port's pvid_vlan which we access afterwards,
> what we're accessing is freed memory.
> 
> Fix the bug by determining whether to clear ocelot_port->pvid_vlan prior
> to calling ocelot_vlan_member_del().
> 
> [...]

Here is the summary with links:
  - [net] net: mscc: ocelot: fix use-after-free in ocelot_vlan_del()
    https://git.kernel.org/netdev/net/c/ef5764057540

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


