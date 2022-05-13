Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4959D526059
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379559AbiEMKkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344990AbiEMKkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514082878F1;
        Fri, 13 May 2022 03:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D639560BD4;
        Fri, 13 May 2022 10:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3351EC34118;
        Fri, 13 May 2022 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652438416;
        bh=w70scybEJH1nL6/MKcUPce/sdlRZTexlC2RJSFDc+z4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VMr7KegNknNioDV69uZXeN66fhfiHkGGUqpJu+e1Ss3j8rm11u4tmKCNFy1RFCSw6
         zXdxIdQWqPuOf1pUg1KvNiCVU74+avy6e57jo+4AnoS4WgOWMwkU+HxZjWMD3ORD0W
         ID3APp8qhh2lF2PmrfyPpnI567yIKDxllvev48rve8ySNLM7dBZTuRIXh387M17tvd
         Zeg1L92pMDuSgylGpHSX/x8xl9cMbsUIwHTDclKaC4N/RPgQjOZM4NClHCHond8Sns
         1m+W7K4B+x3STW1H98EJ0w2H6do8ZsgYIxlr1T0Lng7uk/Xw3TN/NStShOHSsuzdu1
         c4GJTtJK8hPrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A231F03934;
        Fri, 13 May 2022 10:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/7] Polling be gone on LAN95xx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165243841603.19214.4066003517532596557.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 10:40:16 +0000
References: <cover.1652343655.git.lukas@wunner.de>
In-Reply-To: <cover.1652343655.git.lukas@wunner.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, steve.glendinning@shawell.net,
        UNGLinuxDriver@microchip.com, oneukum@suse.com,
        andre.edich@microchip.com, linux@rempel-privat.de,
        martyn.welch@collabora.com, ghojda@yo2urs.ro,
        chf.fritz@googlemail.com, LinoSanfilippo@gmx.de,
        p.rosenberger@kunbus.com, hkallweit1@gmail.com, andrew@lunn.ch,
        linux@armlinux.org.uk, fntoth@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Thu, 12 May 2022 10:42:00 +0200 you wrote:
> Do away with link status polling on LAN95xx USB Ethernet
> and rely on interrupts instead, thereby reducing bus traffic,
> CPU overhead and improving interface bringup latency.
> 
> Link to v2:
> https://lore.kernel.org/netdev/cover.1651574194.git.lukas@wunner.de/
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/7] usbnet: Run unregister_netdev() before unbind() again
    https://git.kernel.org/netdev/net-next/c/d1408f6b4dd7
  - [net-next,v3,2/7] usbnet: smsc95xx: Don't clear read-only PHY interrupt
    https://git.kernel.org/netdev/net-next/c/3108871f1922
  - [net-next,v3,3/7] usbnet: smsc95xx: Don't reset PHY behind PHY driver's back
    https://git.kernel.org/netdev/net-next/c/14021da69811
  - [net-next,v3,4/7] usbnet: smsc95xx: Avoid link settings race on interrupt reception
    https://git.kernel.org/netdev/net-next/c/8960f878e39f
  - [net-next,v3,5/7] usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling
    https://git.kernel.org/netdev/net-next/c/1ce8b37241ed
  - [net-next,v3,6/7] net: phy: smsc: Cache interrupt mask
    https://git.kernel.org/netdev/net-next/c/7e8b617eb93f
  - [net-next,v3,7/7] net: phy: smsc: Cope with hot-removal in interrupt handler
    https://git.kernel.org/netdev/net-next/c/1e7b81edebc1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


