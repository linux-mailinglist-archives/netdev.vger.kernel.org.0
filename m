Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953DB1ED2A0
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 16:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgFCOwq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Jun 2020 10:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgFCOwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 10:52:46 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977F3C08C5C0;
        Wed,  3 Jun 2020 07:52:45 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=roelofs-mbp.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jgUkr-0002jQ-92; Wed, 03 Jun 2020 16:52:33 +0200
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] lan743x: Added fixed link and RGMII support / BROKEN
 PATCH
From:   Roelof Berg <rberg@berg-solutions.de>
In-Reply-To: <20200601.115136.1314501977250032604.davem@davemloft.net>
Date:   Wed, 3 Jun 2020 16:52:32 +0200
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D784BC1B-D14C-4FE4-8FD8-76BEBE60A39D@berg-solutions.de>
References: <20200529193003.3717-1-rberg@berg-solutions.de>
 <20200601.115136.1314501977250032604.davem@davemloft.net>
To:     David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1591195965;eb131c3d;
X-HE-SMSGID: 1jgUkr-0002jQ-92
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TEST REPORT: BROKEN PATCH

Thanks to everyone for working on the fixed link feature of lan743x eth driver.

I received more test hardware today, and one piece of hardware (EVBlan7430) becomes incompatible by the patch. We need to roll back for now. Sorry.

I’ll discuss about options of how to proceed in a second e-mail.

Thank you and best regards,
Roelof


> David Miller <davem@davemloft.net>:
> 
>> Microchip lan7431 is frequently connected to a phy. However, it
>> can also be directly connected to a MII remote peer without
>> any phy in between. For supporting such a phyless hardware setup
>> in Linux we utilized phylib, which supports a fixed-link
>> configuration via the device tree. And we added support for
>> defining the connection type R/GMII in the device tree.
> ...
> 
> Applied, thank you.
> 

