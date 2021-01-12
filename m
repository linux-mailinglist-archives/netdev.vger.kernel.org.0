Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A2B2F3458
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391881AbhALPkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:40:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391743AbhALPkA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 10:40:00 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kzLlH-000BIW-Ox; Tue, 12 Jan 2021 16:39:11 +0100
Date:   Tue, 12 Jan 2021 16:39:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v1 2/2] sfp: add support for 100 base-x SFPs
Message-ID: <X/3Cn5kxsaFhQvG0@lunn.ch>
References: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
 <20210111130657.10703-3-bjarni.jonasson@microchip.com>
 <20210111142245.GW1551@shell.armlinux.org.uk>
 <d7f934f9b4f45661e41fe7a35a044ea5e8ec1cad.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7f934f9b4f45661e41fe7a35a044ea5e8ec1cad.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Not sure what you mean, the patch is above the comment (line 265 vs
> 345).  The patch is on top of 5.10, is that the issue?

All networking patches for the next merge window should be against
net-next. Please see:

https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

which talks about the different trees.

      Andrew
