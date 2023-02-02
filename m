Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D07687434
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 05:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjBBEAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 23:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjBBEAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 23:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50777A486;
        Wed,  1 Feb 2023 20:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E516B8240A;
        Thu,  2 Feb 2023 04:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D156C4339B;
        Thu,  2 Feb 2023 04:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675310418;
        bh=VjpBLORqwq4aylwtZAQuIn0MU94w07qlzoRRp+0m6oM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c9vT4S4al9trpb79ihL6Ls2JGo2Thx7Od2+SuWEIE1VrTUjogFnd640pLGHFUrvVP
         aJeCnzTXGr8giziQVr8y8I9Qh1BCgAe4q/PnutTYiwlKuJbPEcCgsZZ2CgnIzwElOO
         CmtOzzvCNj2SBZnop3WD6EQHF8pIPauQzd2NSgLSfZovWW5Hd4H9c4m1LzIt4T/2J4
         0nGa9YN7QgVPjhCmIJUd8C5mb6yERPaK2GPScgMLa2iCVDHKBng5AgkcCpDwSOd9to
         NGFk5i4U/MtO5wCWYmkfSLmsX+QFdHuwq/FV0ayTrrL8p0zHO/Q1zwQfgMqRgpt5f6
         70hypU31sUx/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6EFFE270CC;
        Thu,  2 Feb 2023 04:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 0/2] ip/ip6_gre: Fix GRE tunnels not generating IPv6 link
 local addresses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167531041794.2562.11007852335746128637.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 04:00:17 +0000
References: <20230131034646.237671-1-Thomas.Winter@alliedtelesis.co.nz>
In-Reply-To: <20230131034646.237671-1-Thomas.Winter@alliedtelesis.co.nz>
To:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, edumazet@google.com, kuba@kernel.org,
        a@unstable.cc, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 31 Jan 2023 16:46:44 +1300 you wrote:
> For our point-to-point GRE tunnels, they have IN6_ADDR_GEN_MODE_NONE
> when they are created then we set IN6_ADDR_GEN_MODE_EUI64 when they
> come up to generate the IPv6 link local address for the interface.
> Recently we found that they were no longer generating IPv6 addresses.
> 
> Also, non-point-to-point tunnels were not generating any IPv6 link
> local address and instead generating an IPv6 compat address,
> breaking IPv6 communication on the tunnel.
> 
> [...]

Here is the summary with links:
  - [v5,1/2] ip/ip6_gre: Fix changing addr gen mode not generating IPv6 link local address
    https://git.kernel.org/netdev/net/c/23ca0c2c9340
  - [v5,2/2] ip/ip6_gre: Fix non-point-to-point tunnel not generating IPv6 link local address
    https://git.kernel.org/netdev/net/c/30e2291f61f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


