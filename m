Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDCA5BE239
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbiITJkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiITJkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:40:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD16A48CBD;
        Tue, 20 Sep 2022 02:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8A7C62796;
        Tue, 20 Sep 2022 09:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E189C433C1;
        Tue, 20 Sep 2022 09:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663666817;
        bh=3kY2LpMlTuaxvaHh4kVf+yHDFvzvWV9yHrL63uHqlrk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nFkS14OGZFPytyy9b0b98xomGhh6dXZhGq3bm5tXS3g09s7LkSHnwQjqe9FEHpe4L
         ZocZDpsXmoqgSxUS9xic2uApeCL7NkzNnN6qsErJ9Y80xg3fSOAysoXc1ReN/kUbGA
         k051kf4bqSdCaFRBLDny5IksLpv1yB6aiRgvACfAof80n5Lrkff6wSQvSo3WvDiqUB
         mZHyWjcfLBrZqiqLIFPcjkhRpv6U10R9Eg8/O+v1ZQQVUd1vQ7eWVoHL2rUNVIO/4h
         zC8utZ3CuiYVWzlCgznUWv+AbXib2VvhaeLoVJIObIvPOIMWIGTkgEeVYXaiCnQUWK
         wACEOMNZ8nQSg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0E3E5E21EE0;
        Tue, 20 Sep 2022 09:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 00/10] DSA changes for multiple CPU ports (part 4)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166366681705.19165.10240342144188805698.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 09:40:17 +0000
References: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        andrew@lunn.ch, olteanv@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        colin.foster@in-advantage.com, roopa@nvidia.com,
        razor@blackwall.org, tobias@waldekranz.com, kabel@kernel.org,
        ansuelsmth@gmail.com, dqfext@gmail.com, alsi@bang-olufsen.dk,
        linus.walleij@linaro.org, luizluca@gmail.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, dsahern@kernel.org,
        stephen@networkplumber.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 11 Sep 2022 04:06:56 +0300 you wrote:
> Those who have been following part 1:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220511095020.562461-1-vladimir.oltean@nxp.com/
> part 2:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220521213743.2735445-1-vladimir.oltean@nxp.com/
> and part 3:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220819174820.3585002-1-vladimir.oltean@nxp.com/
> will know that I am trying to enable the second internal port pair from
> the NXP LS1028A Felix switch for DSA-tagged traffic via "ocelot-8021q".
> 
> [...]

Here is the summary with links:
  - [v2,net-next,01/10] net: introduce iterators over synced hw addresses
    https://git.kernel.org/netdev/net-next/c/db01868bf2e9
  - [v2,net-next,02/10] net: dsa: introduce dsa_port_get_master()
    https://git.kernel.org/netdev/net-next/c/8f6a19c0316d
  - [v2,net-next,03/10] net: dsa: allow the DSA master to be seen and changed through rtnetlink
    https://git.kernel.org/netdev/net-next/c/95f510d0b792
  - [v2,net-next,04/10] net: dsa: don't keep track of admin/oper state on LAG DSA masters
    https://git.kernel.org/netdev/net-next/c/6e61b55c6d7f
  - [v2,net-next,05/10] net: dsa: suppress appending ethtool stats to LAG DSA masters
    https://git.kernel.org/netdev/net-next/c/cfeb84a52fcb
  - [v2,net-next,06/10] net: dsa: suppress device links to LAG DSA masters
    https://git.kernel.org/netdev/net-next/c/13eccc1bbb2e
  - [v2,net-next,07/10] net: dsa: propagate extack to port_lag_join
    https://git.kernel.org/netdev/net-next/c/2e359b00a117
  - [v2,net-next,08/10] net: dsa: allow masters to join a LAG
    https://git.kernel.org/netdev/net-next/c/acc43b7bf52a
  - [v2,net-next,09/10] docs: net: dsa: update information about multiple CPU ports
    https://git.kernel.org/netdev/net-next/c/0773e3a851c8
  - [v2,net-next,10/10] net: dsa: felix: add support for changing DSA master
    https://git.kernel.org/netdev/net-next/c/eca70102cfb1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


