Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD946298E0
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiKOMaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiKOMaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B44E1CB04;
        Tue, 15 Nov 2022 04:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF9DA6171D;
        Tue, 15 Nov 2022 12:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00E23C43470;
        Tue, 15 Nov 2022 12:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668515416;
        bh=RDrvuxjFUp6i9QW7KL1QZyCZe3XLJgNRwHhIsYgr+9Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pehsHjJwAm5ezTK8RwskGP5wGcesefgb1XS8VgyhENEdxN4nqbaHmrBneW92WXs9u
         wC0jSW0QTgaD3ormS7KlrOQNDQrz49NBw18Y7fubFg2RvBnjjK6o1DqLMUAYbtEsCn
         3P5kr5CVr/W4144h/7uspnkd06wBP0+Hfmg0UVJuK0J51sBtIzQURMG8sMDOXYl3QA
         XO4oV/CnGcEkQuw7pnNmpOXWu5WMj37kblFtrKeRmn48o9swi4F9WZwPb6mXX/YP8Q
         y2IkGNGYj2t85MR1ra+5HhGyi4fL/ezHFM/+yYqLwdS6jb6+kWDXDcJ5Am+9kVuqwv
         SZil/h6S/vcWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9083C395F5;
        Tue, 15 Nov 2022 12:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: phy: marvell: add sleep time after enabling the
 loopback bit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166851541587.30368.11058064913336167873.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Nov 2022 12:30:15 +0000
References: <20221114065302.10625-1-aminuddin.jamaluddin@intel.com>
In-Reply-To: <20221114065302.10625-1-aminuddin.jamaluddin@intel.com>
To:     Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mohammad.athari.ismail@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, tee.min.tan@intel.com,
        muhammad.husaini.zulkifli@intel.com, hong.aun.looi@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 14 Nov 2022 14:53:02 +0800 you wrote:
> Sleep time is added to ensure the phy to be ready after loopback
> bit was set. This to prevent the phy loopback test from failing.
> 
> Fixes: 020a45aff119 ("net: phy: marvell: add Marvell specific PHY loopback")
> Cc: <stable@vger.kernel.org> # 5.15.x
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Signed-off-by: Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>
> 
> [...]

Here is the summary with links:
  - [net,v3] net: phy: marvell: add sleep time after enabling the loopback bit
    https://git.kernel.org/netdev/net/c/18c532e44939

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


