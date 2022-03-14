Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD9E4D804D
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 12:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238750AbiCNLBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 07:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236034AbiCNLBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 07:01:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFEF43EF5
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 04:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77C9261035
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4878C340F4;
        Mon, 14 Mar 2022 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647255613;
        bh=cfGNx0qi47+lsUGrUkG4PXB7snsRJGVYBHoVFkeRchE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A/OuFRvTMohd+jV7bKNyWkbu3BIW22Birwb8i1iOglKkR1kV1LSiQWqxwuR3IvuQ3
         UHs35jC7jNvAENuEIzTdtfGrrwvpntsThTYxweCCj9uvIH6G2npQxA2YDS1vAC3Mwl
         wuHwHO2Y2A1PINFfC7KLRVO4lhlv2LBUIcrFDZPyindpXm4/rv0iKs1GPWOHRrboB1
         Z2HzB9br7rVLJhxl12+U84h9ikCQ2b0rf03jCB8WephoVqdddXhqRQ9EJpyeECKAtC
         nHMVQKWNWGvQ/h93H1fPRMZm+mAjo0pO0LuZS3ia5zo+dssFRgVjClqDIp0IgJx7V3
         eBY7GqG9FSEBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B17E6E6D3DE;
        Mon, 14 Mar 2022 11:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Basic QoS classification on Felix DSA switch
 using dcbnl
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164725561372.8211.12671050911325501685.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Mar 2022 11:00:13 +0000
References: <20220311211520.2543260-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220311211520.2543260-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        petrm@nvidia.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Mar 2022 23:15:17 +0200 you wrote:
> Basic QoS classification for Ocelot switches means port-based default
> priority, DSCP-based and VLAN PCP based. This is opposed to advanced QoS
> classification which is done through the VCAP IS1 TCAM based engine.
> 
> The patch set is a logical continuation of this RFC which attempted to
> describe the default-prio as a matchall entry placed at the end of a
> series of offloaded tc filters:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210113154139.1803705-1-olteanv@gmail.com/
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: dsa: report and change port default priority using dcbnl
    https://git.kernel.org/netdev/net-next/c/d538eca85c2a
  - [net-next,2/3] net: dsa: report and change port dscp priority using dcbnl
    https://git.kernel.org/netdev/net-next/c/47d75f782206
  - [net-next,3/3] net: dsa: felix: configure default-prio and dscp priorities
    https://git.kernel.org/netdev/net-next/c/978777d0fb06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


