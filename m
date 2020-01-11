Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6AE1383E8
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 00:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731645AbgAKXIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 18:08:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731633AbgAKXIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 18:08:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA14215A0B3CE;
        Sat, 11 Jan 2020 15:08:09 -0800 (PST)
Date:   Sat, 11 Jan 2020 15:08:07 -0800 (PST)
Message-Id: <20200111.150807.963654509739345915.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     sd@queasysnail.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com,
        Igor.Russkikh@aquantia.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v5 00/15] net: macsec: initial support for
 hardware offloading
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200110162010.338611-1-antoine.tenart@bootlin.com>
References: <20200110162010.338611-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 11 Jan 2020 15:08:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Fri, 10 Jan 2020 17:19:55 +0100

> td;dr: When applying this series, do not apply patches 12 to 14.
> 
> This series intends to add support for offloading MACsec transformations
> to hardware enabled devices. The series adds the necessary
> infrastructure for offloading MACsec configurations to hardware drivers,
> in patches 1 to 6; then introduces MACsec offloading support in the
> Microsemi MSCC PHY driver, in patches 7 to 11.
> 
> The remaining 4 patches, 12 to 14, are *not* part of the series but
> provide the mandatory changes needed to support offloading MACsec
> operations to a MAC driver. Those patches are provided for anyone
> willing to add support for offloading MACsec operations to a MAC, and
> should be part of the first series adding a MAC as a MACsec offloading
> provider.

You say four 4 patches, but 12 to 14 is 3.  I think you meant 12 to 15
because 15 depends upon stuff added in 12 :-)

I applied everything except patch #7, which had the unnecessary phy
exports, and also elided 12 to 15.

Thanks.
