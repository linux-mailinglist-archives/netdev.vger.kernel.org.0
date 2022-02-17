Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13AA4B9816
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 06:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbiBQFUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 00:20:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbiBQFUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 00:20:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C732A598E
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 21:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64E34B82121
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 05:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 099A6C340F4;
        Thu, 17 Feb 2022 05:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645075211;
        bh=4XCOYbJV9P+dK8ulyZs0e1D+tjREdhW1QvMkf9FD5X0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CHrnhFE/QVeNTgoFZIBkvlMKpzHcCJWmQtqeJCe+U3LPV6cLmmjhGd3sncda5wPwl
         lhQ9aK9CStzQTlOguLKTdvLPXDvvLFIeACxtEfWbL0VksimHKSI2NRc1La+VXnIt+f
         dO4n5/DBoPxIC13sU90tHwhXrIx7dXjBwYn2I2F5bilvgQM8tAb5tUMXlzkY9eEbXf
         ELuhZk8Vu39PejBiS8SOuF2/6PFB4fO7FVCyzAI/LQVMoe0xdWj/F19dOjRuDjzTMa
         gsZe9drHdg/WI1PS+SUY85n7dptM5aCaPpnZGz2UK46zC+GtmkQS+TRpGByXRUIThm
         gNxBEwC1dYjvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0E45E7BB0B;
        Thu, 17 Feb 2022 05:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ipv6: per-netns exclusive flowlabel checks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164507521091.4843.2205863752404721765.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 05:20:10 +0000
References: <20220215160037.1976072-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20220215160037.1976072-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com, liu3101@purdue.edu
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Feb 2022 11:00:37 -0500 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Ipv6 flowlabels historically require a reservation before use.
> Optionally in exclusive mode (e.g., user-private).
> 
> Commit 59c820b2317f ("ipv6: elide flowlabel check if no exclusive
> leases exist") introduced a fastpath that avoids this check when no
> exclusive leases exist in the system, and thus any flowlabel use
> will be granted.
> 
> [...]

Here is the summary with links:
  - [net,v2] ipv6: per-netns exclusive flowlabel checks
    https://git.kernel.org/netdev/net/c/0b0dff5b3b98

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


