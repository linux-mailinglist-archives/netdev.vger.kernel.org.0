Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B9552E22E
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344619AbiETBuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236600AbiETBuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D8BDFF5B;
        Thu, 19 May 2022 18:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14D7461BCB;
        Fri, 20 May 2022 01:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E8E2C34119;
        Fri, 20 May 2022 01:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653011413;
        bh=UgQsreDLSY7xypK5YeRjfLDhZyP1S/w1RAFeT8UNwrM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lxcZ18HGdRuzdUKkuFcivSyrpKzPt9vD3Q4KrP5/qC6rzGq3jFIl/VDg+b9lALDyB
         QO95cj5Gjiz4G5atpONKcrOiWsjtqI/I01C9PO/fQ3zi+/5a1+LY7fsNgaQZGcJcAJ
         U45MJUhv1BK7Fp5PcYYQYDoZjW2QkSAK74UkpR1g5/213sI33Vsb23idtywwl5Eeh5
         gq/0dYZmCAJUbIcK/5hDehQYNLXljYnE0FOk7zsL77HqokQr6iZeXyACSLIMljnlDW
         T3ecKXl3ZuXBdtzBal8sOGF3e20N83okuZhmGp/8ixE4RF0OLnuupunsBtPfXMIsPg
         JEOS/oEeSn8KQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 53149F03937;
        Fri, 20 May 2022 01:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] lantiq_gswip: Two small fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165301141333.6731.4185077110831875405.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 01:50:13 +0000
References: <20220518220051.1520023-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20220518220051.1520023-1-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 19 May 2022 00:00:49 +0200 you wrote:
> While updating the Lantiq target in OpenWrt to Linux 5.15 I came across
> an FDB related error message. While that still needs to be solved I
> found two other small issues on the way.
> 
> This series fixes the two minor issues found while revisiting the FDB
> code in the lantiq_gswip driver:
> - The first patch fixes the start index used in gswip_port_fdb() to
>   find the entry with the matching bridge. The updated logic is now
>   consistent with the rest of the driver.
> - The second patch fixes a typo in a dev_err() message.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: dsa: lantiq_gswip: Fix start index in gswip_port_fdb()
    https://git.kernel.org/netdev/net-next/c/7b4149bdee6a
  - [net-next,v2,2/2] net: dsa: lantiq_gswip: Fix typo in gswip_port_fdb_dump() error print
    https://git.kernel.org/netdev/net-next/c/4951995dbe9d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


