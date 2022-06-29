Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A2E5600FA
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbiF2NKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbiF2NKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:10:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E460821B8;
        Wed, 29 Jun 2022 06:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 818FE61CB6;
        Wed, 29 Jun 2022 13:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE050C341CE;
        Wed, 29 Jun 2022 13:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656508215;
        bh=QjTsITZLdwtkziEKrM0qlsW2H3uKs8jiR2VAmQfAmYg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HqRZS9f8EbhDU4qRdwZ/4EhKNgO945+1/VHY+Yn7wxNsRO097crle208h/l4841sw
         ePbyWkESI2Rs+XdNl8e2BxfhUtFKIuEmGazQkEs/pcW750i/Xrh2WD77QbO5lp1+5F
         1LjaQ+PC4WTMsHDgWtmIUua1QHXaV+3YoMpnAqCxAyyjGol6CCbystY1xFqtPm8WWG
         cJCurR1w7fe4UyoU2kOVfEQ3qgm5cCyo2VdMJrMORo6Wh0UlzeGUind0RYezoOrb7v
         EmOCCZBumZdUsoQGXF8pDCvzjghXkfthWaV3HR45Jq3sstqrB75MDW9t3+qzz5FqpB
         VWcvSsv0KamBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6032E49BB8;
        Wed, 29 Jun 2022 13:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: forwarding: ethtool_extended_state:
 Convert to busywait
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165650821574.20617.13719931995682250837.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 13:10:15 +0000
References: <b3f4a264c0270f3e4e22e291ee843fbf72d3fc7f.1656412324.git.petrm@nvidia.com>
In-Reply-To: <b3f4a264c0270f3e4e22e291ee843fbf72d3fc7f.1656412324.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        mlxsw@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
        amcohen@nvidia.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 28 Jun 2022 12:37:44 +0200 you wrote:
> Currently, this script sets up the test scenario, which is supposed to end
> in an inability of the system to negotiate a link. It then waits for a bit,
> and verifies that the system can diagnose why the link was not established.
> 
> The wait time for the scenario where different link speeds are forced on
> the two ends of a loopback cable, was set to 4 seconds, which exactly
> covered it. As of a recent mlxsw firmware update, this time gets longer,
> and this test starts failing.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: forwarding: ethtool_extended_state: Convert to busywait
    https://git.kernel.org/netdev/net-next/c/04cfbc1d89d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


