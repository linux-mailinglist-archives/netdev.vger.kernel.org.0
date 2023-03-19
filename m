Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577FB6C0094
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 11:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjCSKuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 06:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCSKuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 06:50:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661A5136DA;
        Sun, 19 Mar 2023 03:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B22A560F9A;
        Sun, 19 Mar 2023 10:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A209C433A0;
        Sun, 19 Mar 2023 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679223019;
        bh=453PK2PCxTyZSXXMXs81JsNYdPM7EbZLWZB1pEswKJs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xhdvqv2yxNVRDMjMhXQS6d2H1ba4qZr0lf7cpGNpooq4qOZxBvUHUzlxqXBB+cJ2b
         ooIcD/dlGKWCaztXjku9VRGC7xyDdhk8Tg5Oc4nZhpjJIirXwgHVH2NtB6zllHkJAj
         xa8LATJJPrDKjbsf3WnfYvEULo3s2tDf0sOayDrRzqHmbJQ9ZFDiAC3jCD4q/48ylK
         3BvAvn3w6pujIZNMdVrl98GxVm9aEBQB1JCMDK7dbg0urjL/ewoYmpYqa5uBWiHy9X
         8SW52vZrGU3/q9t+XdFOKtJueBaPNRMTwnYtav0pKoFuyiUN31ZP0427ntW8zzRDSD
         43vHDj5CrQx0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7BA6E21EE9;
        Sun, 19 Mar 2023 10:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: Ensure state transitions are processed from
 phy_stop()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167922301888.22899.1199680876721811339.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 10:50:18 +0000
References: <20230316203325.2026217-1-f.fainelli@gmail.com>
In-Reply-To: <20230316203325.2026217-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Mar 2023 13:33:24 -0700 you wrote:
> In the phy_disconnect() -> phy_stop() path, we will be forcibly setting
> the PHY state machine to PHY_HALTED. This invalidates the old_state !=
> phydev->state condition in phy_state_machine() such that we will neither
> display the state change for debugging, nor will we invoke the
> link_change_notify() callback.
> 
> Factor the code by introducing phy_process_state_change(), and ensure
> that we process the state change from phy_stop() as well.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: Ensure state transitions are processed from phy_stop()
    https://git.kernel.org/netdev/net/c/4203d84032e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


