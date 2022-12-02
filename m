Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831976404E1
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 11:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbiLBKk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 05:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbiLBKkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 05:40:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDD8C4CE2;
        Fri,  2 Dec 2022 02:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75395B82129;
        Fri,  2 Dec 2022 10:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 289D2C433C1;
        Fri,  2 Dec 2022 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669977616;
        bh=9TJWvPBkEqE2daxuJdASbu2lj+aoO2m9KXnJwJTO+K0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rYQkg0Z9zktXtOPN8Bc0oyOE3NYUT38dfpi5aJLMPmthMI3aDLQ9UpBQD4Bwim+Ur
         LUFSKl0YKlGt6qMWDeuZTvjo7M2Ya4+9C6vnk+iEJnfFlt11eqfzWxc+jK2t2y01aQ
         88nbPxSxMned0Uvowvzgz8QWryqZ3cRCiyNOFEg9anhKfyVYDDLvYunCxBLHOsfH2x
         GujXkMo3bguUgSENweCmkFkaHroSFvVgdrtV+al3rGxtEsazBz+ZrLO71c2fBVWZK0
         ICNOmja1EvsRsM+Lb39OLB+E6hQNStluFz1erph0JhUUbjj6pxM8KeCKXijGnm5GJp
         tcZ2Z4oopxNUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0EDB3E450B4;
        Fri,  2 Dec 2022 10:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net  0/2] vmxnet3: couple of fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166997761605.20046.4334047014624425550.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Dec 2022 10:40:16 +0000
References: <20221130082148.9605-1-doshir@vmware.com>
In-Reply-To: <20221130082148.9605-1-doshir@vmware.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        pv-drivers@vmware.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Wed, 30 Nov 2022 00:21:45 -0800 you wrote:
> This series fixes following issues:
> 
> Patch 1:
>   This patch provides a fix to correctly report encapsulated LRO'ed
>   packet.
> 
> Patch 2:
>   This patch provides a fix to use correct intrConf reference.
> 
> [...]

Here is the summary with links:
  - [v2,net,1/2] vmxnet3: correctly report encapsulated LRO packet
    https://git.kernel.org/netdev/net/c/40b8c2a1af03
  - [v2,net,2/2] vmxnet3: use correct intrConf reference when using extended queues
    https://git.kernel.org/netdev/net/c/409e8ec8c582

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


