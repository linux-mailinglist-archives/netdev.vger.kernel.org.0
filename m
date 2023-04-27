Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2766F04A2
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 13:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243290AbjD0LAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 07:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243201AbjD0LAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 07:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A2F49C4;
        Thu, 27 Apr 2023 04:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8304563CA4;
        Thu, 27 Apr 2023 11:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D919FC4339B;
        Thu, 27 Apr 2023 11:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682593221;
        bh=ubbLu6X3aIhQ9+1d6ymWr2oTVqOZVAFne6Q7DPVakj0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U36Gj3m6C1BZBsjjJL4XbHc3U2LJbYPWQiToq+9OX/Uqw+rgkiL5go68j/iX+FMF3
         1jazZESyusQEelFIa5KaEXMPWb0OrfK0/XZ9CAVV5RfIyGBpiR682aVvcX/ZqDrz3P
         B+bT9AeN8Li0ZVwBBxR28l3LQLoV0grsSsQsJHYMQHOFGbnA2+yj/FIsUJkoqWRTfo
         lefNx65E6ENA3gL3BBdZwRUj+Hd4jxVcEqvzz5WNneV5wWbEmFWfVXNvAHBdeWH8EC
         YwXnwJ44Wp1NaRtXqobtbQtE9SUTadMvic86io5DiwlUS74BESGTkjxxObe52vZFzj
         d4DR71AVLniMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B217FE270D6;
        Thu, 27 Apr 2023 11:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH v2 0/9] Macsec fixes for CN10KB
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168259322172.9282.1522773230038872936.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Apr 2023 11:00:21 +0000
References: <20230426062528.20575-1-gakula@marvell.com>
In-Reply-To: <20230426062528.20575-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com, sgoutham@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 26 Apr 2023 11:55:19 +0530 you wrote:
> This patch set has fixes for the issues encountered while
> testing macsec on CN10KB silicon. Below is the description
> of patches:
> 
> Patch 1: For each LMAC two MCSX_MCS_TOP_SLAVE_CHANNEL_CFG registers exist
> 	 in CN10KB. Bypass has to be disabled in two registers.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/9] octeonxt2-af: mcs: Fix per port bypass config
    https://git.kernel.org/netdev/net/c/c222b292a356
  - [net,v2,2/9] octeontx2-af: mcs: Write TCAM_DATA and TCAM_MASK registers at once
    https://git.kernel.org/netdev/net/c/b51612198603
  - [net,v2,3/9] octeontx2-af: mcs: Config parser to skip 8B header
    https://git.kernel.org/netdev/net/c/65cdc2b637a5
  - [net,v2,4/9] octeontx2-af: mcs: Fix MCS block interrupt
    https://git.kernel.org/netdev/net/c/b8aebeaaf9ff
  - [net,v2,5/9] octeontx2-pf: mcs: Fix NULL pointer dereferences
    https://git.kernel.org/netdev/net/c/699af748c615
  - [net,v2,6/9] octeontx2-pf: mcs: Match macsec ethertype along with DMAC
    https://git.kernel.org/netdev/net/c/57d00d4364f3
  - [net,v2,7/9] octeontx2-pf: mcs: Clear stats before freeing resource
    https://git.kernel.org/netdev/net/c/815debbbf7b5
  - [net,v2,8/9] octeontx2-pf: mcs: Fix shared counters logic
    https://git.kernel.org/netdev/net/c/9bdfe61054fb
  - [net,v2,9/9] octeontx2-pf: mcs: Do not reset PN while updating secy
    https://git.kernel.org/netdev/net/c/3c99bace4ad0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


