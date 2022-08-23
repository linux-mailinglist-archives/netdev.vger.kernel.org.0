Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328B759E411
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 15:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbiHWNKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 09:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240412AbiHWNKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 09:10:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380DF133BBC
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:11:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFDEF61238
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B6BBC43141;
        Tue, 23 Aug 2022 10:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661249418;
        bh=Ha23U3dU1lKaUI9d/wLmyct65n3o243sbAAQP/Lhjlw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VYBFQ0B8ikDWagVVZM86KYHI44sJPqaKFs58iX54st9jURXW9g7wQMXp4SmW3pn7H
         kVYKODzFdFeO4Mw5yoyveyJWIcdapzHEmEldNN9FXnfyH8H1UQ+ov6Hmjw9jgQ8LW9
         ygbY7uE9S150Xgh00FiUx0Ktc/phdNdTN1cfUMRCQfeIvmtCUMGDVnyqvLhG3SeVLv
         neJoZOcgLc/4enIALC54N5uprK6ykRfdk3o7llwdu4WiRoLXMRg5Ry3anC6aNnivuE
         KMOv+t/w5awjjT5SqlNVwQgBLikgtvTRxermbwUk9cqWgD3jNatIuCGB8FscxXiflO
         L2EJkdl+Gc40g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1CE63E2A041;
        Tue, 23 Aug 2022 10:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/9] DSA changes for multiple CPU ports (part 3)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166124941811.27612.2369948958047786064.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 10:10:18 +0000
References: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, colin.foster@in-advantage.com,
        roopa@nvidia.com, razor@blackwall.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 19 Aug 2022 20:48:11 +0300 you wrote:
> Those who have been following part 1:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220511095020.562461-1-vladimir.oltean@nxp.com/
> and part 2:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220521213743.2735445-1-vladimir.oltean@nxp.com/
> will know that I am trying to enable the second internal port pair from
> the NXP LS1028A Felix switch for DSA-tagged traffic via "ocelot-8021q".
> This series represents part 3 of that effort.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/9] net: dsa: walk through all changeupper notifier functions
    https://git.kernel.org/netdev/net-next/c/4c3f80d22b2e
  - [v3,net-next,2/9] net: dsa: don't stop at NOTIFY_OK when calling ds->ops->port_prechangeupper
    https://git.kernel.org/netdev/net-next/c/0498277ee17b
  - [v3,net-next,3/9] net: bridge: move DSA master bridging restriction to DSA
    https://git.kernel.org/netdev/net-next/c/920a33cd7231
  - [v3,net-next,4/9] net: dsa: existing DSA masters cannot join upper interfaces
    https://git.kernel.org/netdev/net-next/c/4f03dcc6b9a0
  - [v3,net-next,5/9] net: dsa: only bring down user ports assigned to a given DSA master
    https://git.kernel.org/netdev/net-next/c/7136097e1199
  - [v3,net-next,6/9] net: dsa: all DSA masters must be down when changing the tagging protocol
    https://git.kernel.org/netdev/net-next/c/f41ec1fd1c20
  - [v3,net-next,7/9] net: dsa: use dsa_tree_for_each_cpu_port in dsa_tree_{setup,teardown}_master
    https://git.kernel.org/netdev/net-next/c/5dc760d12082
  - [v3,net-next,8/9] net: mscc: ocelot: set up tag_8021q CPU ports independent of user port affinity
    https://git.kernel.org/netdev/net-next/c/36a0bf443585
  - [v3,net-next,9/9] net: mscc: ocelot: adjust forwarding domain for CPU ports in a LAG
    https://git.kernel.org/netdev/net-next/c/291ac1517af5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


