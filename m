Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219DF51B6B5
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 05:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241832AbiEEDx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 23:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241726AbiEEDxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 23:53:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A961BD4
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 20:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9464615BD
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 03:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B333C385B0;
        Thu,  5 May 2022 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651722614;
        bh=G6poZnM/z5fqpfGXQnf6/QKqcEZVUTovNYMbhMVz+QE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gLElxz+u070rPejozAHBzKkjTghxZ68L08/n9+5xeOG7hme9rNEI+80yC2UHfdneS
         X6OhWrfcE8W5eu1Nj+BtU1oTknyE2y34yE7LEteqb+3G2E9z6WpS4bC1sTKV9JgPJA
         L3/6MIB3EI39ekVYRwpU5RRKPVYaSK5Mwqx0WZgw6nW6psqKbZQiEz72uPnkWzAe2j
         Nsm28p4E/nlGL70ZT2neTckZ1xjFS1UcJ/2uBy7qEDt7v83eIeWPQQ4CXP1SP+RhDv
         u5S0QgO0XlCPVbxfYVsxTx7/nsmESJXAkIogy8gDMZx5eeqq1vkwUYYu/eOx0MQxuH
         CGqyWjy7tlM7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EC3F5F03848;
        Thu,  5 May 2022 03:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] Ocelot VCAP cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165172261396.3043.16471282366265202769.git-patchwork-notify@kernel.org>
Date:   Thu, 05 May 2022 03:50:13 +0000
References: <20220503120150.837233-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220503120150.837233-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, xiaoliang.yang_1@nxp.com,
        colin.foster@in-advantage.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  3 May 2022 15:01:45 +0300 you wrote:
> This is a series of minor code cleanups brought to the Ocelot switch
> driver logic for VCAP filters.
> 
> - don't use list_for_each_safe() in ocelot_vcap_filter_add_to_block
> - don't use magic numbers for OCELOT_POLICER_DISCARD
> 
> Vladimir Oltean (5):
>   net: mscc: ocelot: use list_add_tail in
>     ocelot_vcap_filter_add_to_block()
>   net: mscc: ocelot: add to tail of empty list in
>     ocelot_vcap_filter_add_to_block
>   net: mscc: ocelot: use list_for_each_entry in
>     ocelot_vcap_filter_add_to_block
>   net: mscc: ocelot: drop port argument from qos_policer_conf_set
>   net: mscc: ocelot: don't use magic numbers for OCELOT_POLICER_DISCARD
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: mscc: ocelot: use list_add_tail in ocelot_vcap_filter_add_to_block()
    https://git.kernel.org/netdev/net-next/c/0a448bba5009
  - [net-next,2/5] net: mscc: ocelot: add to tail of empty list in ocelot_vcap_filter_add_to_block
    https://git.kernel.org/netdev/net-next/c/3825a0d02748
  - [net-next,3/5] net: mscc: ocelot: use list_for_each_entry in ocelot_vcap_filter_add_to_block
    https://git.kernel.org/netdev/net-next/c/09fd1e0d1481
  - [net-next,4/5] net: mscc: ocelot: drop port argument from qos_policer_conf_set
    https://git.kernel.org/netdev/net-next/c/8e90c499bd68
  - [net-next,5/5] net: mscc: ocelot: don't use magic numbers for OCELOT_POLICER_DISCARD
    https://git.kernel.org/netdev/net-next/c/91d350d661bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


