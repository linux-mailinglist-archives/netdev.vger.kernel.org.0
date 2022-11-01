Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F9F614262
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 01:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiKAAkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 20:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiKAAkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 20:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21F315FCD;
        Mon, 31 Oct 2022 17:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B69F61510;
        Tue,  1 Nov 2022 00:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9AC0CC433D6;
        Tue,  1 Nov 2022 00:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667263215;
        bh=f3yp9gSZpqCwzysRf9CVBNxwQkpIzXMBd64xXjHPGME=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tLeb9Op0CaypLiqtcjzHr++aj2FoYnn+99MWa3fbrG8XgVDjFEFxt72MXk1H4gwah
         0+bKuQkyn8werUubaZzwegOHkB7/k6YLoqjgcijgIOsUYNqS3Zlxp6jMS3wiK8HRHx
         wYR8ZW4HSfA5Ow6XhU3Q3xkYp8D12/w52UG/D89ZmiNA6KTcVJcm3XSGNiOi/t/NvQ
         WESOJITglCArpPW+c4Oh1LcRESOMdouL+D28irYf7tjSAAF4x0R+PyhzVHIyIV2liv
         jyAKfvhazpVUTUdGduzt3O82aExVJrb9o3fWWtN9+VEkM/H+HFcFWEbdSpd+twwVNj
         ddIH/Zm152FCA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7BDC2E270D6;
        Tue,  1 Nov 2022 00:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dpaa2: Add some debug prints on deferred probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166726321550.27623.3048945703712604517.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Nov 2022 00:40:15 +0000
References: <20221027190005.400839-1-sean.anderson@seco.com>
In-Reply-To: <20221027190005.400839-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ioana.ciornei@nxp.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Oct 2022 15:00:05 -0400 you wrote:
> When this device is deferred, there is often no way to determine what
> the cause was. Add some debug prints to make it easier to figure out
> what is blocking the probe.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> [...]

Here is the summary with links:
  - net: dpaa2: Add some debug prints on deferred probe
    https://git.kernel.org/netdev/net-next/c/37fe9b981667

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


