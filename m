Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1598D6E0BD3
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjDMKu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjDMKus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:50:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8A69EEF;
        Thu, 13 Apr 2023 03:50:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F71C63D8A;
        Thu, 13 Apr 2023 10:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB187C4339C;
        Thu, 13 Apr 2023 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681383018;
        bh=WekY1dxMI6x03YLBhtaw3ya9K+MiR4WZQfAVmkrZp4A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eKJqVkjAAFlDiJXR3dWYtaI0DKiC6r+KQAlVoWZQU40SL+8r3S6izQEoz4ug9XBdm
         ndiXSoJo4oSHMesIiD9lNdpPiBCgo9ZAZ95HsaR5xb9r6lGkNCwSVyT/BimCqymobM
         15/lV+ifzMZOSKakkBzSTEYdykII12qNyMCF8ljYRhxbqSCvpCyh5eYRsvl0QIBHrX
         hghKVu2lLB+lpX4LXS/eTciTrz8CDoNASNtxbhsyc3CB1CG9Lzo1QumHivEbuNa6np
         vNDI+r61uz3qf4s1eenqB1mzjMSSl8XB7bHYT+YQtVpINykH09QSzRtQZpQzIOraZG
         dnaoMXtUOPhsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D0D3CC395C5;
        Thu, 13 Apr 2023 10:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: enetc: workaround for unresponsive pMAC after
 receiving express traffic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168138301785.25026.13407418336043218299.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 10:50:17 +0000
References: <20230411192645.1896048-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230411192645.1896048-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 11 Apr 2023 22:26:45 +0300 you wrote:
> I have observed an issue where the RX direction of the LS1028A ENETC pMAC
> seems unresponsive. The minimal procedure to reproduce the issue is:
> 
> 1. Connect ENETC port 0 with a loopback RJ45 cable to one of the Felix
>    switch ports (0).
> 
> 2. Bring the ports up (MAC Merge layer is not enabled on either end).
> 
> [...]

Here is the summary with links:
  - [net] net: enetc: workaround for unresponsive pMAC after receiving express traffic
    https://git.kernel.org/netdev/net/c/5b7be2d4fd6e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


