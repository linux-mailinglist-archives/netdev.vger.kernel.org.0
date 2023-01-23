Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F88E677C11
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbjAWNA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbjAWNAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67B9EC69;
        Mon, 23 Jan 2023 05:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4932660F16;
        Mon, 23 Jan 2023 13:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6719C4339E;
        Mon, 23 Jan 2023 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674478818;
        bh=Gztr/MVHCRjc4ugMLOsn6VGCdHf7ad01uj2K2ys0X8M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rYcf2S6yKobqeuSjW3ZpUWORoIQQfNllUPwHCDaK8VyOTMMzV29nyy212Mr3Zaqcb
         PwG9M8zEABikbkijskkEPEj05GoCcNkPWAwJ4GLscnvJEw2CIl2zqDvyH3v+Zwhu5J
         +2STXcGWo4cH+x6eCodKKlkSUa05yhuSf2b3EA6axnsb5nJY2G50wcbke1D94uAJgo
         GgGJBjCHiqpwbUXYwr/d6TfPqvUaNDaGkFFXgroCivcgpkjAXmWLxCSlbf/i0i4EwT
         iyWk0UsCbj0Yw1ixXyoxrNZwtB+BD9ZpMLnPGG7DK+UC1FPo/1YGw0kHCz3RvqZRDk
         OK7OMvYvtKnCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84899E5256F;
        Mon, 23 Jan 2023 13:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 00/12] ethtool support for IEEE 802.3 MAC Merge
 layer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167447881853.32642.15428522709608275315.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Jan 2023 13:00:18 +0000
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

This series was applied to netdev/net-next.git (master)
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
    (no matching commit)
  - [v4,net-next,02/12] net: ethtool: add support for MAC Merge layer
    https://git.kernel.org/netdev/net-next/c/2b30f8291a30
  - [v4,net-next,03/12] docs: ethtool-netlink: document interface for MAC Merge layer
    https://git.kernel.org/netdev/net-next/c/3700000479f0
  - [v4,net-next,04/12] net: ethtool: netlink: retrieve stats from multiple sources (eMAC, pMAC)
    https://git.kernel.org/netdev/net-next/c/04692c9020b7
  - [v4,net-next,05/12] docs: ethtool: document ETHTOOL_A_STATS_SRC and ETHTOOL_A_PAUSE_STATS_SRC
    https://git.kernel.org/netdev/net-next/c/c319df10a4c8
  - [v4,net-next,06/12] net: ethtool: add helpers for aggregate statistics
    https://git.kernel.org/netdev/net-next/c/449c5459641a
  - [v4,net-next,07/12] net: ethtool: add helpers for MM fragment size translation
    https://git.kernel.org/netdev/net-next/c/dd1c41645039
  - [v4,net-next,08/12] net: dsa: add plumbing for changing and getting MAC merge layer state
    https://git.kernel.org/netdev/net-next/c/5f6c2d498ad9
  - [v4,net-next,09/12] net: mscc: ocelot: allow ocelot_stat_layout elements with no name
    https://git.kernel.org/netdev/net-next/c/1a733bbddfad
  - [v4,net-next,10/12] net: mscc: ocelot: hide access to ocelot_stats_layout behind a helper
    https://git.kernel.org/netdev/net-next/c/497eea9f8ed5
  - [v4,net-next,11/12] net: mscc: ocelot: export ethtool MAC Merge stats for Felix VSC9959
    https://git.kernel.org/netdev/net-next/c/ab3f97a9610a
  - [v4,net-next,12/12] net: mscc: ocelot: add MAC Merge layer support for VSC9959
    https://git.kernel.org/netdev/net-next/c/6505b6805655

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


