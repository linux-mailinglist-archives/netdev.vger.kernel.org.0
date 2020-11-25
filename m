Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FC42C3631
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 02:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgKYBVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 20:21:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48628 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727692AbgKYBVD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 20:21:03 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1khjUG-008iCJ-SG; Wed, 25 Nov 2020 02:20:48 +0100
Date:   Wed, 25 Nov 2020 02:20:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        pavana.sharma@digi.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v5 3/4] net: dsa: mv88e6xxx: Add serdes
 interrupt support for MV88E6097
Message-ID: <20201125012048.GD2075216@lunn.ch>
References: <20201124043440.28400-1-chris.packham@alliedtelesis.co.nz>
 <20201124043440.28400-4-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124043440.28400-4-chris.packham@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 05:34:39PM +1300, Chris Packham wrote:
> The MV88E6097 presents the serdes interrupts for ports 8 and 9 via the
> Switch Global 2 registers. There is no additional layer of
> enablinh/disabling the serdes interrupts like other mv88e6xxx switches.

enabling

> Even though most of the serdes behaviour is the same as the MV88E6185
> that chip does not provide interrupts for serdes events so unlike
> earlier commits the functions added here are specific to the MV88E6097.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
