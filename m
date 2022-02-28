Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DB74C6AE0
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbiB1Lkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiB1Lkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:40:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCE271C8B;
        Mon, 28 Feb 2022 03:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC88C61011;
        Mon, 28 Feb 2022 11:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F70CC340F7;
        Mon, 28 Feb 2022 11:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646048412;
        bh=IzGbTcTkn5OvqXsg1RVWTdhXpQHp9xW7OhzybEz8rpU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e1gFUPQUj5F8Ws2RJTAXFNXtmCaDhftLa229YVLX5lNSzPulcT08lXnFoqCrgH9IE
         xXtc6XhB+IbXJWLSkyRCaia5XQL9UOaG23tH/ALexH2oqJgal7i3toSFxrEIJccWS8
         NQ5dNPCTTHyf5/LZgsnkCuHzLf+nLdh5/OU5V6VY9UkJTVsnydCkNpY9ex2UqTtaQx
         EFtvnO6sOT2JtCDIhSgkykHAKWzULvKmKfh1HXg97L0HlZmE9E/YhhY5ehnmmlxRir
         cNDHsg7L+Lw5m8Nd9IDl1yCxqhZqQpfu9QjTUFBvtf2Ix91l774ww/54eFZ23iV2K4
         01V9V8ID1840A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ED73BE5D087;
        Mon, 28 Feb 2022 11:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/2] flow_offload: add tc police parameters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164604841196.9255.14955309839209917682.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 11:40:11 +0000
References: <20220224102908.5255-1-jianbol@nvidia.com>
In-Reply-To: <20220224102908.5255-1-jianbol@nvidia.com>
To:     Jianbo Liu <jianbol@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com,
        claudiu.manoil@nxp.com, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        simon.horman@corigine.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        baowen.zheng@corigine.com, louis.peens@netronome.com,
        peng.zhang@corigine.com, oss-drivers@corigine.com, roid@nvidia.com
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

On Thu, 24 Feb 2022 10:29:06 +0000 you wrote:
> As a preparation for more advanced police offload in mlx5 (e.g.,
> jumping to another chain when bandwidth is not exceeded), extend the
> flow offload API with more tc-police parameters. Adjust existing
> drivers to reject unsupported configurations.
> 
> Changes since v2:
>   * Rename index to extval in exceed and notexceed acts.
>   * Add policer validate functions for all drivers.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] net: flow_offload: add tc police action parameters
    https://git.kernel.org/netdev/net-next/c/b8cd5831c61c
  - [net-next,v3,2/2] flow_offload: reject offload for all drivers with invalid police parameters
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


