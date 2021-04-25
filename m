Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E0C36A3B4
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 02:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhDYAiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 20:38:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39578 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229687AbhDYAiC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Apr 2021 20:38:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1laSlq-000tTD-Vf; Sun, 25 Apr 2021 02:37:10 +0200
Date:   Sun, 25 Apr 2021 02:37:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/3 net-next v3] net: ethernet: ixp4xx: Add DT bindings
Message-ID: <YIS5trXADzDb/yJz@lunn.ch>
References: <20210423082208.2244803-1-linus.walleij@linaro.org>
 <YILeb1OyrE0k0PyY@lunn.ch>
 <CACRpkdZp8OYyQtuhRqGmjc2gVpmjyBMFivHbk3xBiQk5NKbbww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZp8OYyQtuhRqGmjc2gVpmjyBMFivHbk3xBiQk5NKbbww@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 02:24:26AM +0200, Linus Walleij wrote:
> On Fri, Apr 23, 2021 at 4:49 PM Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > (...) it should be impossible for multiple devices to
> > instantiate an MDIO bus. But with device tree, is that still true?
> > Should there be validation that only one device has an MDIO bus in its
> > device tree?
> 
> This would be more of a question to Rob.

Hi Linus

Sorry. I was thinking C code. The driver already has the global
variable mdio_bus. It is initially a NULL pointer. It gets sent when
the first MDIO bus driver probes. If it is not NULL when an MDIO bus
driver probes, throw an error.

       Andrew
