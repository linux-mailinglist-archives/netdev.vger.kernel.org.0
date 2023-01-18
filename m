Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4B3671FDF
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjAROkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjAROjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:39:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7009418B06;
        Wed, 18 Jan 2023 06:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 155C361842;
        Wed, 18 Jan 2023 14:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 752DFC4339C;
        Wed, 18 Jan 2023 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674052217;
        bh=CBGsf02SRTiLNhRyXP4NFFsNWoN1o5BXvck1WnKrXpY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SmgbMy/HCiBLBtcueTOfmEo4O4uREjyyYuCw0f+1IdxvO1tpf9VaQeGrc9B45Ef1v
         9OKwFvcot81/95hjjC1d0/km6HoAkDgegW4Cfa0i6Qa57K0A/w4E14I2CYzxBEaNh9
         2AD5ToICIk0U7CwfVLK8F9KzZZz68doO69fzKAVoUNgsqeYefVrv3v90ckAdHCnA7J
         UDjUcdm10YYmFMSvq7JMoncMFWCRvPC4oswGAnCBJwZ8XpbAC1m1PIBnNh0gk/Htnn
         JHpYjDzg3mgmtrNMvqU6zuKOvUMtyMZxrDGVwV8hKstmq7XaIx9l8xXu6U4kmmhAeb
         mQ8X4V8oSuJrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60785C5C7C4;
        Wed, 18 Jan 2023 14:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] r8152: avoid to change cfg for all devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167405221739.16594.5372337991173989926.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 14:30:17 +0000
References: <20230117030344.4581-396-nic_swsd@realtek.com>
In-Reply-To: <20230117030344.4581-396-nic_swsd@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, bjorn@mork.no
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

On Tue, 17 Jan 2023 11:03:44 +0800 you wrote:
> The rtl8152_cfgselector_probe() should set the USB configuration to the
> vendor mode only for the devices which the driver (r8152) supports.
> Otherwise, no driver would be used for such devices.
> 
> Fixes: ec51fbd1b8a2 ("r8152: add USB device driver for config selection")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] r8152: avoid to change cfg for all devices
    https://git.kernel.org/netdev/net-next/c/0d4cda805a18

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


