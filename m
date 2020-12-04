Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1342CF0C2
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 16:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgLDPck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 10:32:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38706 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgLDPck (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 10:32:40 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1klD3o-00AEGc-9K; Fri, 04 Dec 2020 16:31:52 +0100
Date:   Fri, 4 Dec 2020 16:31:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: sfp: VSOL V2801F / CarlitoxxPro
 CPGOS03-0490 v2.0 workaround
Message-ID: <20201204153152.GC2400258@lunn.ch>
References: <20201204143451.GL1551@shell.armlinux.org.uk>
 <E1klCB8-0001sW-Ma@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1klCB8-0001sW-Ma@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Some modules (Nokia 3FE46541AA) lock up if byte 0x51 is read as a
> + * single read. Switch back to reading 16 byte blocks unless we have
> + * a CarlitoxxPro module (rebranded VSOL V2801F). Even more annoyingly,
> + * some VSOL V2801F have the vendor name changed to OEM.

Hi Russell

I guess it is more likely, the vendor name has not been changed _from_
OEM.

Otherwise, this looks good.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
