Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C954BA2A0
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241754AbiBQOKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:10:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbiBQOK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:10:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACBB2B164A
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 06:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF1D661D62
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5233AC340F1;
        Thu, 17 Feb 2022 14:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645107012;
        bh=RoKRMH4PL74XtucUBCfghyFfOuVsAkNMrUQS6yBGKMU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DctC25WqAqPdyJDazIeaTJDkKUs/ifEtEzOlRuVphxd3Y20m2j6UEDu7oufi1kZBP
         Ylx9pVN3TY2aRCzEKGVMRXRqmrbpezmLg4jeccDz4X5Ynini47+NacA6iwNRP7cMuh
         h5ACDXr2z17Rbh6wqHsOZqQ9CoyGVU5h9PiMBNPY12AXveR/WCn4d/W7/IiXPdO3Xq
         LwBDp2dLa3IJFZNGSl2yivEf3ub3xG4iDCEaCz/E6+PbNj3yjRiWRJFPphkq+7F43Y
         6SragIG0JDpk6njNe/1Xu5FSwJYIIakrbUz2rOcoQ5FlSU3AQDdvCSUkq5g4MmiUXz
         98amAsctwzalw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39F96E7BB07;
        Thu, 17 Feb 2022 14:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] Support PTP over UDP with the ocelot-8021q DSA
 tagging protocol
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164510701223.18867.7803262646113080201.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 14:10:12 +0000
References: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, michael@walle.cc
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 16 Feb 2022 16:30:03 +0200 you wrote:
> The alternative tag_8021q-based tagger for Ocelot switches, added here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210129010009.3959398-1-olteanv@gmail.com/
> 
> gained support for PTP over L2 here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210213223801.1334216-1-olteanv@gmail.com/
> 
> mostly as a minimum viable requirement. That PTP support was mostly
> self-contained code that installed some rules to replicate PTP packets
> on the CPU queue, in felix_setup_mmio_filtering().
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] net: mscc: ocelot: use a consistent cookie for MRP traps
    https://git.kernel.org/netdev/net-next/c/e3c02b7c655c
  - [net-next,02/11] net: mscc: ocelot: consolidate cookie allocation for private VCAP rules
    https://git.kernel.org/netdev/net-next/c/c518afec2883
  - [net-next,03/11] net: mscc: ocelot: delete OCELOT_MRP_CPUQ
    https://git.kernel.org/netdev/net-next/c/36fac35b2907
  - [net-next,04/11] net: mscc: ocelot: use a single VCAP filter for all MRP traps
    https://git.kernel.org/netdev/net-next/c/b9bace6e534d
  - [net-next,05/11] net: mscc: ocelot: avoid overlap in VCAP IS2 between PTP and MRP traps
    https://git.kernel.org/netdev/net-next/c/85ea0daabe5a
  - [net-next,06/11] net: dsa: felix: use DSA port iteration helpers
    https://git.kernel.org/netdev/net-next/c/2960bb14ea27
  - [net-next,07/11] net: mscc: ocelot: keep traps in a list
    https://git.kernel.org/netdev/net-next/c/e42bd4ed09aa
  - [net-next,08/11] net: mscc: ocelot: annotate which traps need PTP timestamping
    https://git.kernel.org/netdev/net-next/c/9d75b8818537
  - [net-next,09/11] net: dsa: felix: remove dead code in felix_setup_mmio_filtering()
    https://git.kernel.org/netdev/net-next/c/d78637a8a061
  - [net-next,10/11] net: dsa: felix: update destinations of existing traps with ocelot-8021q
    https://git.kernel.org/netdev/net-next/c/993480043655
  - [net-next,11/11] net: dsa: tag_ocelot_8021q: calculate TX checksum in software for deferred packets
    https://git.kernel.org/netdev/net-next/c/29940ce32a2d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


