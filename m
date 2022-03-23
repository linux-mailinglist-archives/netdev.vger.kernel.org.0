Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24FE4E4C47
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 06:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241112AbiCWFbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 01:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238334AbiCWFbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 01:31:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A9A70CEC
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 22:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74003B81E0A
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 05:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1831AC340F2;
        Wed, 23 Mar 2022 05:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648013410;
        bh=H4S4HaKDNn4Tm/WSo3b9A/lHPKFSh+97c40a1zzbYYM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WerBZaev9GEqX+cusFtowhwGMGI/5L2REBMQaB7piuWNA+JdY+jtov3or4T0YjQAu
         lLhJDabzPK9zjZ+A3Mq04LF5NgKVIT+clXfauUTB1823uk09akLfPjJM0KtCM1iO9q
         aeLXSSM6ZR6FDZ4sPsGAHh72YtgCFPv7sC2gmy4wxfGizu0csdAyKdwbQV2p8xqDa3
         T54/JlcTcmkmGwKG/4nNTfT5ZU+waiIdT8cM9twtCpaIkiXj0PShswzQFqaG7TpSea
         yIsd4enGJn2IYMEhjI1WIL1OkwSL7x3S+SXpdgOYqA7SDOS4MWEm5E4YA6UOXiFPcO
         bomqpTNQhajww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB81EE6D402;
        Wed, 23 Mar 2022 05:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: fix missing host-filtered multicast
 addresses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164801340996.16633.8138127880832215312.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Mar 2022 05:30:09 +0000
References: <20220322003701.2056895-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220322003701.2056895-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 22 Mar 2022 02:37:01 +0200 you wrote:
> DSA ports are stacked devices, so they use dev_mc_add() to sync their
> address list to their lower interface (DSA master). But they are also
> hardware devices, so they program those addresses to hardware using the
> __dev_mc_add() sync and unsync callbacks.
> 
> Unfortunately both cannot work at the same time, and it seems that the
> multicast addresses which are already present on the DSA master, like
> 33:33:00:00:00:01 (added by addrconf.c as in6addr_linklocal_allnodes)
> are synced to the master via dev_mc_sync(), but not to hardware by
> __dev_mc_sync().
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: fix missing host-filtered multicast addresses
    https://git.kernel.org/netdev/net-next/c/5077e2c8cf4d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


