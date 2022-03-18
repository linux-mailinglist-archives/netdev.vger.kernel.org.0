Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150F34DD22D
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 02:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiCRBBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 21:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiCRBBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 21:01:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C672571A5
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69F7B615E0
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 01:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6CD5C340EE;
        Fri, 18 Mar 2022 01:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647565211;
        bh=2R5JfZMHGZqmtFB1hb+B1h35QeFb5FzoyK8NEGvgoUU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O/jxA+mQrdruBQDOiifyjTpHi7WvkyThXRACSC4J5XcsH5p4SNJYhpwad7YRdt9OL
         PQvBY2pLGxfUzvmCcKXrMZ3mLkGu/IU8wKV34GWDu4EfLDAHqn+jRg9p5kHUhtT4fi
         yp3RFFWS/EsRngjaZ4PqulsrQDiWu3eJ8ThDqq0qWc1TePOrNzzRH1GhyRDQNqgzEX
         shHeWcnru0dWQZj3ImZqJGJJnB/MurThorew5p05vwU1jypkubQqrZey0jFIceldqY
         FQBy1SgJA7MfdC54ReP27j4W7JNqmGqnO/uVZWb13qOSkKg5RNyqK3YFo6H2A8/zMH
         maUpEoXY8u7GA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 988C4E6D3DD;
        Fri, 18 Mar 2022 01:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] Mirroring for Ocelot switches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164756521161.13563.8145722160745711883.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 01:00:11 +0000
References: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Mar 2022 22:41:38 +0200 you wrote:
> This series adds support for tc-matchall (port-based) and tc-flower
> (flow-based) offloading of the tc-mirred action. Support has been added
> for both the ocelot switchdev driver and felix DSA driver.
> 
> Vladimir Oltean (6):
>   net: mscc: ocelot: refactor policer work out of
>     ocelot_setup_tc_cls_matchall
>   net: mscc: ocelot: add port mirroring support using tc-matchall
>   net: mscc: ocelot: establish functions for handling VCAP aux resources
>   net: mscc: ocelot: offload per-flow mirroring using tc-mirred and VCAP
>     IS2
>   net: dsa: pass extack to dsa_switch_ops :: port_mirror_add()
>   net: dsa: felix: add port mirroring support
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: mscc: ocelot: refactor policer work out of ocelot_setup_tc_cls_matchall
    https://git.kernel.org/netdev/net-next/c/4fa72108029c
  - [net-next,2/6] net: mscc: ocelot: add port mirroring support using tc-matchall
    https://git.kernel.org/netdev/net-next/c/ccb6ed426f10
  - [net-next,3/6] net: mscc: ocelot: establish functions for handling VCAP aux resources
    https://git.kernel.org/netdev/net-next/c/c3d427eac90f
  - [net-next,4/6] net: mscc: ocelot: offload per-flow mirroring using tc-mirred and VCAP IS2
    https://git.kernel.org/netdev/net-next/c/f2a0e216bee5
  - [net-next,5/6] net: dsa: pass extack to dsa_switch_ops :: port_mirror_add()
    https://git.kernel.org/netdev/net-next/c/0148bb50b8fd
  - [net-next,6/6] net: dsa: felix: add port mirroring support
    https://git.kernel.org/netdev/net-next/c/5e497497681e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


