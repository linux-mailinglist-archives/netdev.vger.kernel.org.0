Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B310677A0A
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 12:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbjAWLU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 06:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbjAWLUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 06:20:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BA32366A;
        Mon, 23 Jan 2023 03:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E512AB80D36;
        Mon, 23 Jan 2023 11:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8083DC433EF;
        Mon, 23 Jan 2023 11:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674472817;
        bh=gvu8MOwX+WDMn+kwuopZOpUipzUb8AzPeT4Cc+3zxmQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IHFsXpFmh0Ue7xGiQwjc4gOoN5dyAFKHonwiuuSr9lzbtUua94zf+KmBL5CAgEg0V
         IU5aswmY2ciX+IqmeckWzTU5iAD6F6adb6hQbaha6Ib4TQ/QvwBKiqYkLDysSx9UOq
         ouH2ctfMEvbgY8XukYGjeVByXn3pv9roGYwzPL4ws9oyDZKj/MRmjJYtWQclrP/GMd
         9Hvjr8zvrRJIEwsXL2YKlfp/r4ZTpFpUWWw8CQTvrgeuD34fZjobpWHbmTnn58uJ1z
         4ftAgK4ipC0YL7Nrx6SdpmcvJVrnC+WRvFhrglpOocI2o8ZgeUiUklfxHKyDpXgyP6
         ctvENKRerWAVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63882F83ECD;
        Mon, 23 Jan 2023 11:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 00/12] ethtool support for IEEE 802.3 MAC Merge
 layer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167447281740.14272.16385016041138908700.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Jan 2023 11:20:17 +0000
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230119122705.73054-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mkubecek@suse.cz, claudiu.manoil@nxp.com,
        vinicius.gomes@intel.com, xiaoliang.yang_1@nxp.com,
        kurt@linutronix.de, rui.sousa@nxp.com, ferenc.fejes@ericsson.com,
        pranavi.somisetty@amd.com, harini.katakam@amd.com,
        colin.foster@in-advantage.com, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 19 Jan 2023 14:26:52 +0200 you wrote:
> Change log
> ----------
> 
> v3->v4:
> - add missing opening bracket in ocelot_port_mm_irq()
> - moved cfg.verify_time range checking so that it actually takes place
>   for the updated rather than old value
> v3 at:
> https://patchwork.kernel.org/project/netdevbpf/cover/20230117085947.2176464-1-vladimir.oltean@nxp.com/
> 
> [...]

Here is the summary with links:
  - [v4,net-next,01/12] net: ethtool: netlink: introduce ethnl_update_bool()
    https://git.kernel.org/netdev/net/c/7c494a7749a7
  - [v4,net-next,02/12] net: ethtool: add support for MAC Merge layer
    (no matching commit)
  - [v4,net-next,03/12] docs: ethtool-netlink: document interface for MAC Merge layer
    (no matching commit)
  - [v4,net-next,04/12] net: ethtool: netlink: retrieve stats from multiple sources (eMAC, pMAC)
    (no matching commit)
  - [v4,net-next,05/12] docs: ethtool: document ETHTOOL_A_STATS_SRC and ETHTOOL_A_PAUSE_STATS_SRC
    (no matching commit)
  - [v4,net-next,06/12] net: ethtool: add helpers for aggregate statistics
    (no matching commit)
  - [v4,net-next,07/12] net: ethtool: add helpers for MM fragment size translation
    (no matching commit)
  - [v4,net-next,08/12] net: dsa: add plumbing for changing and getting MAC merge layer state
    (no matching commit)
  - [v4,net-next,09/12] net: mscc: ocelot: allow ocelot_stat_layout elements with no name
    (no matching commit)
  - [v4,net-next,10/12] net: mscc: ocelot: hide access to ocelot_stats_layout behind a helper
    (no matching commit)
  - [v4,net-next,11/12] net: mscc: ocelot: export ethtool MAC Merge stats for Felix VSC9959
    (no matching commit)
  - [v4,net-next,12/12] net: mscc: ocelot: add MAC Merge layer support for VSC9959
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


