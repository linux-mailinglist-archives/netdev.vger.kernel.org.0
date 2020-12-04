Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44092CF0E5
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 16:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbgLDPjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 10:39:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38730 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728950AbgLDPje (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 10:39:34 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1klDAY-00AEK1-Kz; Fri, 04 Dec 2020 16:38:50 +0100
Date:   Fri, 4 Dec 2020 16:38:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: sfp: relax bitrate-derived mode check
Message-ID: <20201204153850.GD2400258@lunn.ch>
References: <20201204143451.GL1551@shell.armlinux.org.uk>
 <E1klCBD-0001si-Qj@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1klCBD-0001si-Qj@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 02:35:27PM +0000, Russell King wrote:
> Do not check the encoding when deriving 1000BASE-X from the bitrate
> when no other modes are discovered. Some GPON modules (VSOL V2801F
> and CarlitoxxPro CPGOS03-0490 v2.0) indicate NRZ encoding with a
> 1200Mbaud bitrate, but should be driven with 1000BASE-X on the host
> side.

Seems like somebody could make a nice side line writing SFP EEPROM
validation tools. There obviously are none in widespread use!

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
