Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDDE6DED9D
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 10:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjDLIaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 04:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDLIaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 04:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CF499
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 01:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8C5662F92
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 08:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 129C5C433D2;
        Wed, 12 Apr 2023 08:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681288219;
        bh=2AyDyNespsJJVqrjeoKZVFkq9HuIA9TKeoEDYlNRUl0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EjEQoMPzMtDWBjeAJ+ZDkAdKSntdMBf4y3jSeiouQG0BLanDpypFvJ4J6uFp2cGiK
         WjcigS3AZlEtqv/8RUipl8wqtTlpj5utpmUPzetu3ITVtUdvEp1GoD31/00UZ2tG2B
         /bOJiW1X/K1tTwOvBWHfkwJzEQ916wvuZuqa6Ufv80QhmbjXvwqt/C98Us42TnRvGp
         IBmcxZKhTg9h9mENBV7F0oJ5np/tz9q7bZbgG4CKAtfWnZsCxold2we1Y3kBw4hd2S
         K91m5IA/zi+hGGtQwpSKwPvuB3mXMZFdmkfaJd5V782N8uwr8flYAal/Ygwv5+nCWV
         S7VW8UeZOGYUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1620E5244E;
        Wed, 12 Apr 2023 08:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] DSA trace events
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168128821891.29681.7497576129473533718.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Apr 2023 08:30:18 +0000
References: <20230407141451.133048-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230407141451.133048-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, andrew@lunn.ch,
        f.fainelli@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  7 Apr 2023 17:14:49 +0300 you wrote:
> This series introduces the "dsa" trace event class, with the following
> events:
> 
> $ trace-cmd list | grep dsa
> dsa
> dsa:dsa_fdb_add_hw
> dsa:dsa_mdb_add_hw
> dsa:dsa_fdb_del_hw
> dsa:dsa_mdb_del_hw
> dsa:dsa_fdb_add_bump
> dsa:dsa_mdb_add_bump
> dsa:dsa_fdb_del_drop
> dsa:dsa_mdb_del_drop
> dsa:dsa_fdb_del_not_found
> dsa:dsa_mdb_del_not_found
> dsa:dsa_lag_fdb_add_hw
> dsa:dsa_lag_fdb_add_bump
> dsa:dsa_lag_fdb_del_hw
> dsa:dsa_lag_fdb_del_drop
> dsa:dsa_lag_fdb_del_not_found
> dsa:dsa_vlan_add_hw
> dsa:dsa_vlan_del_hw
> dsa:dsa_vlan_add_bump
> dsa:dsa_vlan_del_drop
> dsa:dsa_vlan_del_not_found
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: add trace points for FDB/MDB operations
    https://git.kernel.org/netdev/net-next/c/9538ebce88ff
  - [net-next,2/2] net: dsa: add trace points for VLAN operations
    https://git.kernel.org/netdev/net-next/c/02020bd70fa6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


