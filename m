Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32BC2C35AA
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 01:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgKYAd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 19:33:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48576 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727688AbgKYAd3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 19:33:29 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1khikD-008huN-Sk; Wed, 25 Nov 2020 01:33:13 +0100
Date:   Wed, 25 Nov 2020 01:33:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        pavana.sharma@digi.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v5 1/4] net: dsa: mv88e6xxx: Don't force link
 when using in-band-status
Message-ID: <20201125003313.GB2075216@lunn.ch>
References: <20201124043440.28400-1-chris.packham@alliedtelesis.co.nz>
 <20201124043440.28400-2-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124043440.28400-2-chris.packham@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 05:34:37PM +1300, Chris Packham wrote:
> When a port is configured with 'managed = "in-band-status"' switch chips
> like the 88E6390 need to propagate the SERDES link state to the MAC
> because the link state is not correctly detected. This causes problems
> on the 88E6185/88E6097 where the link partner won't see link state
> changes because we're forcing the link.
> 
> To address this introduce a new device specific op port_sync_link() and
> push the logic from mv88e6xxx_mac_link_up() into that. Provide an
> implementation for the 88E6185 like devices which doesn't force the
> link.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
