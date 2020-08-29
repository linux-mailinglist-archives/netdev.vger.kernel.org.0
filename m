Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0796256AB9
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 01:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgH2XQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 19:16:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60240 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728095AbgH2XQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 19:16:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kCA5I-00CRqS-AN; Sun, 30 Aug 2020 01:16:32 +0200
Date:   Sun, 30 Aug 2020 01:16:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adam =?utf-8?Q?Rudzi=C5=84ski?= <adam.rudzinski@arf.net.pl>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, robh+dt@kernel.org,
        frowand.list@gmail.com
Subject: Re: drivers/of/of_mdio.c needs a small modification
Message-ID: <20200829231632.GB2966560@lunn.ch>
References: <20200828222846.GA2403519@lunn.ch>
 <dcfea76d-5340-76cf-7ad0-313af334a2fd@arf.net.pl>
 <20200828225353.GB2403519@lunn.ch>
 <6eb8c287-2d9f-2497-3581-e05a5553b88f@arf.net.pl>
 <891d7e82-f22a-d24b-df5b-44b34dc419b5@gmail.com>
 <113503c8-a871-1dc0-daea-48631e1a436d@arf.net.pl>
 <20200829151553.GB2912863@lunn.ch>
 <76f88763-54b0-eb03-3bc8-3e5022173163@arf.net.pl>
 <20200829160047.GD2912863@lunn.ch>
 <79bcab16-5802-c075-1615-06c64078b6c9@arf.net.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79bcab16-5802-c075-1615-06c64078b6c9@arf.net.pl>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I meant that with the split description of the mdio node the mdio bus for
> use in the system would be selected almost automatically. Suppose that I can
> do the device tree "my way":
> &fec2 {
> ...
>     mdio { phy2 ... };
> ...
> };
> &fec1 {
> ...
>     mdio { phy1 ... };
> ...
> };
> This emphasizes which PHY is intended for use by which FEC, that's why it
> looks more natural for me.

And it looks really wrong to me. It suggests there are two busses, and
each PHY is on its own bus. When in fact there is one MDIO bus with
two PHYs. Device tree should represents the real hardware, not some
pseudo description.

     Andrew
