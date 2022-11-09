Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946CF622D0D
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 15:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiKIOAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 09:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiKIOAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 09:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D339655A;
        Wed,  9 Nov 2022 06:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7297561ADE;
        Wed,  9 Nov 2022 14:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C40A3C433D7;
        Wed,  9 Nov 2022 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668002415;
        bh=erS5kY4vTEVms0VEBKv5IC3Caijsud/hgU5fAzX+jso=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lHTMZA9lKYvl5BKzkSeYjaEsxAPjntFP+f91FXlzu193PQyHUlzbDuMRQi7MwEgIl
         OjwkIJOSZ7M9bNPW0nGlj3CFbUrWgjn3b7hgJiiWF6qoTKEeDQzRxgcZMz29i0RfWj
         pAxG3leaakvt6kWyTHLY5DBS08YvY3Sv16fBaUCFN14m5MK6EGeMwuN5JcgDG7nqlt
         oNMxYnUUUFyUnhRbJW2UAFPg7OSa9QXzqOE81ZddCIMPkGu9LL4frQm+KTRAIL92aH
         VaWUUZ26OG11sv8cbrO14PyXKMTNOE3imaJAY7/d8hPBdN7mm5BMeGuMC24NtnXv/v
         4XLKxQMrD1hLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA6A4C395F7;
        Wed,  9 Nov 2022 14:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net/core: Allow live renaming when an interface
 is up
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166800241569.22395.12507776446911406225.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Nov 2022 14:00:15 +0000
References: <20221107174242.1947286-1-andy.ren@getcruise.com>
In-Reply-To: <20221107174242.1947286-1-andy.ren@getcruise.com>
To:     Andy Ren <andy.ren@getcruise.com>
Cc:     netdev@vger.kernel.org, richardbgobert@gmail.com,
        davem@davemloft.net, wsa+renesas@sang-engineering.com,
        edumazet@google.com, petrm@nvidia.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, andrew@lunn.ch,
        dsahern@gmail.com, sthemmin@microsoft.com, idosch@idosch.org,
        sridhar.samudrala@intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, roman.gushchin@linux.dev
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  7 Nov 2022 09:42:42 -0800 you wrote:
> Allow a network interface to be renamed when the interface
> is up.
> 
> As described in the netconsole documentation [1], when netconsole is
> used as a built-in, it will bring up the specified interface as soon as
> possible. As a result, user space will not be able to rename the
> interface since the kernel disallows renaming of interfaces that are
> administratively up unless the 'IFF_LIVE_RENAME_OK' private flag was set
> by the kernel.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net/core: Allow live renaming when an interface is up
    https://git.kernel.org/netdev/net-next/c/bd039b5ea2a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


