Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16AE14CBFDE
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbiCCOVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbiCCOVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:21:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F0A1405D8
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8795661B8A
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 14:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6663C340F0;
        Thu,  3 Mar 2022 14:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646317213;
        bh=G2cIYFsZ0CPFwvvO65hTSHeYiz1CAxNROOWBD+m0PAY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fgqTzya2V/qw94fj6mgyC5S3PiV67TkP2OQYX611pfzgilpf4t8TbUl2csveC2WQu
         CFi3/Db5z/Qqex8GHHul0Pd6v2CceDno1bIJK2dFBiHBws2/FPzlS9Ih3/wjlb9XlH
         1IbRRX3zWY/5s9V4lPqQzZ/ogSNLFIpe/OiJ/dy0aYxaZMUnMh8hCLgYKXxWI7tSJl
         DJm5OfRlXt8HzeB5ivLqhcgyZY/Z4WnhQ1XVrDeS2YR6Dcndep5+AKz4NoLn+MA2MS
         gLecKDXMUi9FuZp7n1JTz8btbBNUp0Bs0vkGl2iGS05ibTIg9FAC4TEfNGEdaWlzlf
         NuxHwvOtMUWnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C953CEAC096;
        Thu,  3 Mar 2022 14:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] DSA unicast filtering
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164631721281.14029.14160275266943530830.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 14:20:12 +0000
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, idosch@nvidia.com, tobias@waldekranz.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  2 Mar 2022 21:14:07 +0200 you wrote:
> This series doesn't attempt anything extremely brave, it just changes
> the way in which standalone ports which support FDB isolation work.
> 
> Up until now, DSA has recommended that switch drivers configure
> standalone ports in a separate VID/FID with learning disabled, and with
> the CPU port as the only destination, reached trivially via flooding.
> That works, except that standalone ports will deliver all packets to the
> CPU. We can leverage the hardware FDB as a MAC DA filter, and disable
> flooding towards the CPU port, to force the dropping of packets with
> unknown MAC DA.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] net: dsa: remove workarounds for changing master promisc/allmulti only while up
    https://git.kernel.org/netdev/net-next/c/35aae5ab9121
  - [net-next,02/10] net: dsa: rename the host FDB and MDB methods to contain the "bridge" namespace
    https://git.kernel.org/netdev/net-next/c/68d6d71eafd1
  - [net-next,03/10] net: dsa: install secondary unicast and multicast addresses as host FDB/MDB
    https://git.kernel.org/netdev/net-next/c/5e8a1e03aa4d
  - [net-next,04/10] net: dsa: install the primary unicast MAC address as standalone port host FDB
    https://git.kernel.org/netdev/net-next/c/499aa9e1b332
  - [net-next,05/10] net: dsa: manage flooding on the CPU ports
    https://git.kernel.org/netdev/net-next/c/7569459a52c9
  - [net-next,06/10] net: dsa: felix: migrate host FDB and MDB entries when changing tag proto
    https://git.kernel.org/netdev/net-next/c/f9cef64fa23f
  - [net-next,07/10] net: dsa: felix: migrate flood settings from NPI to tag_8021q CPU port
    https://git.kernel.org/netdev/net-next/c/b903a6bd2e19
  - [net-next,08/10] net: dsa: felix: start off with flooding disabled on the CPU port
    https://git.kernel.org/netdev/net-next/c/90897569beb1
  - [net-next,09/10] net: dsa: felix: stop clearing CPU flooding in felix_setup_tag_8021q
    https://git.kernel.org/netdev/net-next/c/0cc369800e5f
  - [net-next,10/10] net: mscc: ocelot: accept configuring bridge port flags on the NPI port
    https://git.kernel.org/netdev/net-next/c/ac4552096023

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


