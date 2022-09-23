Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A135E7200
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 04:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiIWCkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 22:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbiIWCkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 22:40:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C3C50528
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 19:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1DAA62312
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 02:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E49BC433D7;
        Fri, 23 Sep 2022 02:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663900820;
        bh=7YZ1pervJjPr2GI0RRnw4+wFi6YVsGJa5VSrrMjqjbM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DyCFWwTmFyxuuNZKZt6+oYyXsfWTzFP9hsal527Uiq2RNH+VeScusKL1/Cx9mSqfu
         xgzC8o2PXx9k1xOQ7bPDdhH5axsBOnFVtfgo1m80U28TfYIapyzt1GFP+98XeiVGqJ
         Jmz4tr8o1pTrKTnCY28VNUblN11qjZXNwN1HaBDuRPrgUsoz2H5qi1QnyhIhgL63M/
         IdDWIgeMZko0uPcT7WOjUez6SMQqVMHevoH28HUW08wAuQlIcfNNvqZRzZH9h0RpFJ
         SmYYSojEg0i9f+jcaTeu2MvQcj7m55mxVegHNJbNmOOqgrRsyZf7PZuhJDD9p01EmO
         vwKn6lU2MYhjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 382F6E4D03D;
        Fri, 23 Sep 2022 02:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/18] net: dsa: remove unnecessary set_drvdata()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166390082022.27582.5926073089069587652.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 02:40:20 +0000
References: <20220921140524.3831101-1-yangyingliang@huawei.com>
In-Reply-To: <20220921140524.3831101-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, kurt@linutronix.de,
        hauke@hauke-m.de, Woojung.Huh@microchip.com,
        sean.wang@mediatek.com, linus.walleij@linaro.org,
        clement.leger@bootlin.com, george.mccollister@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 21 Sep 2022 22:05:06 +0800 you wrote:
> In this patch set, I removed all set_drvdata(NULL) functions in ->remove() in
> drivers/net/dsa/.
> 
> The driver_data will be set to NULL in device_unbind_cleanup() after calling ->remove(),
> so all set_drvdata(NULL) functions in ->remove() is redundant, they can be removed.
> 
> Here is the previous patch set:
> https://lore.kernel.org/netdev/facfc855-d082-cc1c-a0bc-027f562a2f45@huawei.com/T/
> 
> [...]

Here is the summary with links:
  - [net-next,01/18] net: dsa: b53: remove unnecessary set_drvdata()
    https://git.kernel.org/netdev/net-next/c/764a73b43c36
  - [net-next,02/18] net: dsa: bcm_sf2: remove unnecessary platform_set_drvdata()
    https://git.kernel.org/netdev/net-next/c/47f6aa145036
  - [net-next,03/18] net: dsa: loop: remove unnecessary dev_set_drvdata()
    https://git.kernel.org/netdev/net-next/c/c1816b201415
  - [net-next,04/18] net: dsa: hellcreek: remove unnecessary platform_set_drvdata()
    https://git.kernel.org/netdev/net-next/c/8668cfc6db48
  - [net-next,05/18] net: dsa: lan9303: remove unnecessary dev_set_drvdata()
    https://git.kernel.org/netdev/net-next/c/2697085007f0
  - [net-next,06/18] net: dsa: lantiq_gswip: remove unnecessary platform_set_drvdata()
    https://git.kernel.org/netdev/net-next/c/f6ddabca45f6
  - [net-next,07/18] net: dsa: microchip: remove unnecessary set_drvdata()
    https://git.kernel.org/netdev/net-next/c/3525ecc127d8
  - [net-next,08/18] net: dsa: mt7530: remove unnecessary dev_set_drvdata()
    https://git.kernel.org/netdev/net-next/c/ebe48922c0c4
  - [net-next,09/18] net: dsa: mv88e6060: remove unnecessary dev_set_drvdata()
    https://git.kernel.org/netdev/net-next/c/92f529b7a3b7
  - [net-next,10/18] net: dsa: mv88e6xxx: remove unnecessary dev_set_drvdata()
    https://git.kernel.org/netdev/net-next/c/b25a575c9cd0
  - [net-next,11/18] net: dsa: ocelot: remove unnecessary set_drvdata()
    https://git.kernel.org/netdev/net-next/c/f66d1ecc1ad4
  - [net-next,12/18] net: dsa: ar9331: remove unnecessary dev_set_drvdata()
    https://git.kernel.org/netdev/net-next/c/14b29ece30e5
  - [net-next,13/18] net: dsa: qca8k: remove unnecessary dev_set_drvdata()
    https://git.kernel.org/netdev/net-next/c/68c4e297e09c
  - [net-next,14/18] net: dsa: realtek: remove unnecessary set_drvdata()
    https://git.kernel.org/netdev/net-next/c/24d64ced1bf8
  - [net-next,15/18] net: dsa: rzn1-a5psw: remove unnecessary platform_set_drvdata()
    https://git.kernel.org/netdev/net-next/c/4f6ee77aebf1
  - [net-next,16/18] net: dsa: sja1105: remove unnecessary spi_set_drvdata()
    https://git.kernel.org/netdev/net-next/c/ee08bf0d0a3a
  - [net-next,17/18] net: dsa: vitesse-vsc73xx: remove unnecessary set_drvdata()
    https://git.kernel.org/netdev/net-next/c/774b060debb1
  - [net-next,18/18] net: dsa: xrs700x: remove unnecessary dev_set_drvdata()
    https://git.kernel.org/netdev/net-next/c/24aeeb107f07

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


