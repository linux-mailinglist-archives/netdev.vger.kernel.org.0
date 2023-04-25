Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C0B6EDE0A
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbjDYIa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233659AbjDYIaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:30:04 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D5040E0;
        Tue, 25 Apr 2023 01:30:01 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1prE3Z-0001vV-1h;
        Tue, 25 Apr 2023 10:29:49 +0200
Date:   Tue, 25 Apr 2023 09:27:56 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
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
Subject: Re: [PATCH v2] net: phy: add driver for MediaTek SoC built-in GE PHYs
Message-ID: <ZEePDK2oW5xkiEIv@makrotopia.org>
References: <ZEPU6oahOGwknkSc@makrotopia.org>
 <20230424183755.3fac65b0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424183755.3fac65b0@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 06:37:55PM -0700, Jakub Kicinski wrote:
> On Sat, 22 Apr 2023 13:36:58 +0100 Daniel Golle wrote:
> > Some of MediaTek's Filogic SoCs come with built-in gigabit Ethernet
> > PHYs which require calibration data from the SoC's efuse.
> > Despite the similar design the driver doesn't share any code with the
> > existing mediatek-ge.c, so add support for these PHYs by introducing a
> > new driver for only MediaTek's ARM64 SoCs.
> 
> Andrew, Heiner, how do you feel about this driver?
> 
> Daniel, is it high prio for you to get it into 6.4 or 6.5 is okay?

No rush, as this is mostly relevant for OpenWrt the thing which matters
most to me is having it in the next LTS kernel, so 6.5 should still be
fine I suppose.

> 
> I'm trying to get a read on whether we should merge it because it's 
> kind of on the goal line for this merge window. 
> 
> If nobody feels strongly we can do this the traditional way - I'll 
> just complain about RCT, hence kicking it back out into the field :)

I understand Andrew's concerns and will resubmit for the next merge
window in 2 weeks, and without the LED part for now until PHY LED
infrastructure is more ready (ie. able to offload 'netdev' trigger
to hardware)

