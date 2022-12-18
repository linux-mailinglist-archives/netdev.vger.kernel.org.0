Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D29E6504B2
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 22:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiLRVKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 16:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLRVKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 16:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EB660E1
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 13:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5147DB80BE8
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 21:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7F75C433F0;
        Sun, 18 Dec 2022 21:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671397816;
        bh=Klxe49QHSjp2uR4JLHIsnYT/LZz1cwpTTwouI9wPAns=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SrL/KzkniI6BjuUNW95Nxcm7Es7EkwOozWBW+HLo3JsvN3ExW7NDn+SpKJCyUfDq+
         rNKVxICt+LmGn/Gc0SUofWaViQeVSWrZhxKOCYMRnEwy8gKkTtc8UrQjk7JTH7UZpH
         YXN1z7eMSlMOeL5hotTq0AAjCQYWI6VxXZDgIEYFl+wixheTAsNB/7mQQ0D0GPjHPg
         jZI4zHUnG/lWoSEu6NWUDaQtJ8M6Dn4cBt2/Wfg9gO4Sz3S346HJDWDyoze0dQtaBY
         Iz60zs9UCjUu3EIgxStH0g4dKkBFh6Lb0app03dBumY2gWQlrH8cXBkFVvNAquxg2x
         GG/4aAUtbFrSg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF86CE4D00B;
        Sun, 18 Dec 2022 21:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6][pull request] Intel Wired LAN Driver Updates
 2022-12-15 (igc)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167139781678.5499.8858653473176134127.git-patchwork-notify@kernel.org>
Date:   Sun, 18 Dec 2022 21:10:16 +0000
References: <20221215230758.3595578-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221215230758.3595578-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        muhammad.husaini.zulkifli@intel.com, sasha.neftin@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 15 Dec 2022 15:07:52 -0800 you wrote:
> Muhammad Husaini Zulkifli says:
> 
> This patch series fixes bugs for the Time-Sensitive Networking(TSN)
> Qbv Scheduling features.
> 
> An overview of each patch series is given below:
> 
> [...]

Here is the summary with links:
  - [net,1/6] igc: Enhance Qbv scheduling by using first flag bit
    https://git.kernel.org/netdev/net/c/db0b124f02ba
  - [net,2/6] igc: Use strict cycles for Qbv scheduling
    https://git.kernel.org/netdev/net/c/d8f45be01dd9
  - [net,3/6] igc: Add checking for basetime less than zero
    https://git.kernel.org/netdev/net/c/3b61764fb49a
  - [net,4/6] igc: allow BaseTime 0 enrollment for Qbv
    https://git.kernel.org/netdev/net/c/e17090eb2494
  - [net,5/6] igc: recalculate Qbv end_time by considering cycle time
    https://git.kernel.org/netdev/net/c/6d05251d537a
  - [net,6/6] igc: Set Qbv start_time and end_time to end_time if not being configured in GCL
    https://git.kernel.org/netdev/net/c/72abeedd8398

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


