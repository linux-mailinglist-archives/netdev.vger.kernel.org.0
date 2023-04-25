Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552DC6ED9EB
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbjDYBiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjDYBh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:37:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B05DAF0A;
        Mon, 24 Apr 2023 18:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 021606204F;
        Tue, 25 Apr 2023 01:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC74BC433D2;
        Tue, 25 Apr 2023 01:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682386677;
        bh=Dd+xH5T/3keBxTnmEdhZPmDsUyzc5etpZu0dXdX4naE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L4vUkxIi+otlJp3vwFIi8e/qNDuiVshLO2vgaPDCkmXjSf/qwM0cs2q1xvhr2btt3
         xoab+9Uz+CrwgLN7FduqCb25A01CkLl44UQyCJ42bF2CjCMnSKrJsedY/PzUEDu897
         lwHNrRPpBsvjvjoysVd0VKnj6IAiF6o7mmB93CMWt3e9bJ3jKZQ18GmI5nxtbPWAAi
         I4pTusabu/OfjPAVgt9hjteP+hOfh/2IvUW7HGBTW8U/5dTEi1WHSjv9Pp/a7N/Wgf
         IvS2jlgC5R9BMxYOPq4RYJeVUOaXDeBwVvR0wzBcDWGx1jf5n82CBTqAKtkKZKjb/k
         SLAHkFOx/b7WQ==
Date:   Mon, 24 Apr 2023 18:37:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Qingfang Deng <dqfext@gmail.com>,
        SkyLake Huang <SkyLake.Huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH v2] net: phy: add driver for MediaTek SoC built-in GE
 PHYs
Message-ID: <20230424183755.3fac65b0@kernel.org>
In-Reply-To: <ZEPU6oahOGwknkSc@makrotopia.org>
References: <ZEPU6oahOGwknkSc@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Apr 2023 13:36:58 +0100 Daniel Golle wrote:
> Some of MediaTek's Filogic SoCs come with built-in gigabit Ethernet
> PHYs which require calibration data from the SoC's efuse.
> Despite the similar design the driver doesn't share any code with the
> existing mediatek-ge.c, so add support for these PHYs by introducing a
> new driver for only MediaTek's ARM64 SoCs.

Andrew, Heiner, how do you feel about this driver?

Daniel, is it high prio for you to get it into 6.4 or 6.5 is okay?

I'm trying to get a read on whether we should merge it because it's 
kind of on the goal line for this merge window. 

If nobody feels strongly we can do this the traditional way - I'll 
just complain about RCT, hence kicking it back out into the field :)
