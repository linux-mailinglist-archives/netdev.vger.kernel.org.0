Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466BF6C00B5
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 12:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjCSLKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 07:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCSLKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 07:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B2217CD4
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 04:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 822E5B806A1
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 11:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1774CC433D2;
        Sun, 19 Mar 2023 11:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679224217;
        bh=ZYDDRcTcbZsNJMAa653RXISy9gFw8sE/JS+fSTfrbEA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ol4C+VKVtzyBOspwQx4e9jGGBuuFCROMlIeX5xBBTGP6LeaStRolbRUiW6UKS1qNx
         KrmLD7Mdc50/helrnBHgO24L23/UoK1BpOndQ1qpPRrVRHvvPGLD16BAghYUWo0lfk
         fouZ0ZWoE/3v3u8cKOyOQU9Yn1dJ8ldOPzGVPVFeMbarB/ePkGWhQNummEmu4MOz28
         p7GUQR7L6LZcIhqUBul7UNV900aSiOh7rP+9FkEBvhIvBsYtqyuxhTy096yLdShenI
         nT92aoWog0DFyd7fexbbEFtFniHqrynu90WufQwobeC7D8R/HT1sagyb5Yc9g/Qgel
         nAskng+N5H78Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1512E21EE6;
        Sun, 19 Mar 2023 11:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sfp: fix state loss when updating state_hw_mask
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167922421698.31905.11495733031560601244.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 11:10:16 +0000
References: <E1pd4VM-00DjWW-2N@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pd4VM-00DjWW-2N@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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

On Fri, 17 Mar 2023 07:28:00 +0000 you wrote:
> Andrew reports that the SFF modules on one of the ZII platforms do not
> indicate link up due to the SFP code believing that LOS indicating that
> there is no signal being received from the remote end, but in fact the
> LOS signal is showing that there is signal.
> 
> What makes SFF modules different from SFPs is they typically have an
> inverted LOS, which uncovered this issue. When we read the hardware
> state, we mask it with state_hw_mask so we ignore anything we're not
> interested in. However, we don't re-read when state_hw_mask changes,
> leading to sfp->state being stale.
> 
> [...]

Here is the summary with links:
  - [net] net: sfp: fix state loss when updating state_hw_mask
    https://git.kernel.org/netdev/net/c/04361b8bb818

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


