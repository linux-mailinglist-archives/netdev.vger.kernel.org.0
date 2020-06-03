Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F39D1ED84F
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 00:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgFCWCt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Jun 2020 18:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgFCWCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 18:02:49 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1059AC08C5C0;
        Wed,  3 Jun 2020 15:02:49 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=roelofs-mbp.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jgbTB-0003Qr-6b; Thu, 04 Jun 2020 00:02:45 +0200
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] lan743x: Added fixed link and RGMII support / debugging
From:   Roelof Berg <rberg@berg-solutions.de>
In-Reply-To: <20200603180615.GB971209@lunn.ch>
Date:   Thu, 4 Jun 2020 00:02:44 +0200
Cc:     David Miller <davem@davemloft.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <EAE302D7-D2C8-40C5-81DC-E8CC008CE3D2@berg-solutions.de>
References: <20200529193003.3717-1-rberg@berg-solutions.de>
 <20200601.115136.1314501977250032604.davem@davemloft.net>
 <D784BC1B-D14C-4FE4-8FD8-76BEBE60A39D@berg-solutions.de>
 <20200603155927.GC869823@lunn.ch>
 <42337EA1-C7D1-46C6-815F-C619B27A4E77@berg-solutions.de>
 <20200603180615.GB971209@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1591221769;7a04ee88;
X-HE-SMSGID: 1jgbTB-0003Qr-6b
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, I found the cause, the delta patch is submitted. Lan7430 runs now in different speeds, also ‚hot swap‘ between different speeds works well. Normal mode and fixed-phy mode coexist properly.

So, I guess we’re done :) However, I’ll spend some more time testing to ensure we’re really safe.

(I’m sending this e-mail through a Microchip Lan7430 by the way :)

Roelof Berg

> 
> Adding #define DEBUG to the top of drivers/net/phy/phy.c will get you
> some debug info.
> 
> […]

>    Andrew
> 

