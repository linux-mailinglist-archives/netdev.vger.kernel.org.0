Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34EC65CEF1
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 10:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238930AbjADJBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 04:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbjADJAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 04:00:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83751CB39
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 01:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 194E8615B3
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 09:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79FBAC433F1;
        Wed,  4 Jan 2023 09:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672822817;
        bh=FAY8MSQKqmlLkB9CaFxDUGxbZnU+D61GEKD4jMq66oc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q+WOiHp2u+q7xFBsqrrIFghaeRQbuRr88lpg2/0FOClHlOrgBV2ldVXNcts1VP/uG
         c2Q86ZSjHG03a+c7Vy3qL3vkTEIA5+ZfOuac3+bLjYsG4zKdT9Ivc26R0iy/YT79Xz
         Ot9k/kHCcJoQwt0a+jjiAlJ3QjVb0miONKk+Y/9Vq3XRKSQrXMM6HYlXsUc6zFWznd
         R6vIdDZlQ68DnaZPtmlgUZ0u6kAMkvAnWKWEXMnuTZ4u+Qz0bsNdpbXOTjDuJJ8qOQ
         RYxNhnXw6m4jSkMbp9czt8ujDb1Q97DJ3KZNnX4RprMGCQDDS5+s9ngjym5TbwfafQ
         AYg6v2+SurHGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63D96C395DF;
        Wed,  4 Jan 2023 09:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] Intel Wired LAN Driver Updates
 2023-01-03 (igc)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167282281740.15758.215696871696602852.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Jan 2023 09:00:17 +0000
References: <20230103230503.1102426-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230103230503.1102426-1-anthony.l.nguyen@intel.com>
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

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue,  3 Jan 2023 15:05:00 -0800 you wrote:
> Muhammad Husaini Zulkifli says:
> 
> Improvements to the Time-Sensitive Networking (TSN) Qbv Scheduling
> capabilities were included in this patch series for I226 SKU.
> 
> An overview of each patch series is given below:
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] igc: remove I226 Qbv BaseTime restriction
    https://git.kernel.org/netdev/net-next/c/b8897dc54e3b
  - [net-next,2/3] igc: enable Qbv configuration for 2nd GCL
    https://git.kernel.org/netdev/net-next/c/5ac1231ac14d
  - [net-next,3/3] igc: Remove reset adapter task for i226 during disable tsn config
    https://git.kernel.org/netdev/net-next/c/1d1b4c63ba73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


