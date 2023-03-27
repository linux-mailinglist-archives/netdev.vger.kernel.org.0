Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546DE6C9BD8
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbjC0HUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbjC0HUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C011E3;
        Mon, 27 Mar 2023 00:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AB1B60FE7;
        Mon, 27 Mar 2023 07:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45056C4339B;
        Mon, 27 Mar 2023 07:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679901618;
        bh=BfOZIei1gvMP0ezjzs4MuvP+yciRDQ4wrJvxRReVOek=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Oym0dPkM1D7BImxAFcrv29vNrXC7N39mgOCVQE0t+oPvOm/nrsDN3zJkuiur1+nK9
         qA2kH+fe+fLSUYoHboJWN5vn19ovIHYKhMCb9YkeLDLWOaXstr1SCeJO3TdVtFdYBl
         Kxuh1j1zFZE2kpypkijQrigosrAvu5ZebUmr2h5kP3fJKRPmxdQMrTzBzT0+f4LAYe
         Xuv86CeQKJu1fu8ciowZ1/KfP0Q1eOsFLv8mqXH1Ab08OR6THny6IPMe5tBoPuxOgM
         eaaa+ro79AgnUhMWyFy077Uw6BnqAEAxzoa9zhBHK0hDGSA8NyR2pDe9W+5WRBMCau
         5DIOoYVgNXBJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25DD8E4F0D0;
        Mon, 27 Mar 2023 07:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1 1/1] net: phy: micrel: correct KSZ9131RNX EEE
 capabilities and advertisement
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167990161814.4487.3157195174549060805.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Mar 2023 07:20:18 +0000
References: <20230324133908.2145226-1-o.rempel@pengutronix.de>
In-Reply-To: <20230324133908.2145226-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        marex@denx.de, kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Mar 2023 14:39:08 +0100 you wrote:
> The KSZ9131RNX incorrectly shows EEE capabilities in its registers.
> Although the "EEE control and capability 1" (Register 3.20) is set to 0,
> indicating no EEE support, the "EEE advertisement 1" (Register 7.60) is
> set to 0x6, advertising EEE support for 1000BaseT/Full and
> 100BaseT/Full.
> This inconsistency causes PHYlib to assume there is no EEE support,
> preventing control over EEE advertisement, which is enabled by default.
> 
> [...]

Here is the summary with links:
  - [net,v1,1/1] net: phy: micrel: correct KSZ9131RNX EEE capabilities and advertisement
    https://git.kernel.org/netdev/net/c/f2e9d083f768

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


