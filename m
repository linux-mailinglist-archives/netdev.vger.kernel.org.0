Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732392ED4CC
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 17:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbhAGQwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 11:52:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55394 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbhAGQwR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 11:52:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxYVW-00GiDa-Ot; Thu, 07 Jan 2021 17:51:30 +0100
Date:   Thu, 7 Jan 2021 17:51:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] net: sfp: add mode quirk for GPON module Ubiquiti
 U-Fiber Instant
Message-ID: <X/c8EoDjpj3PgSkI@lunn.ch>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-4-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210106153749.6748-4-pali@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 04:37:49PM +0100, Pali Rohár wrote:
> SFP GPON module Ubiquiti U-Fiber Instant has in its EEPROM stored nonsense
> information. It claims that support all transceiver types including 10G
> Ethernet which is not truth. So clear all claimed modes and set only one
> mode which module supports: 1000baseX_Full.
> 
> Also this module have set SFF phys_id in its EEPROM. Kernel SFP subsustem
> currently does not allow to use SFP modules detected as SFF. Therefore add
> and exception for this module so it can be detected as supported.
> 
> This change finally allows to detect and use SFP GPON module Ubiquiti
> U-Fiber Instant on Linux system.
> 
> EEPROM content of this SFP module is (where XX is serial number):
> 
> 00: 02 04 0b ff ff ff ff ff ff ff ff 03 0c 00 14 c8    ???........??.??
> 10: 00 00 00 00 55 42 4e 54 20 20 20 20 20 20 20 20    ....UBNT
> 20: 20 20 20 20 00 18 e8 29 55 46 2d 49 4e 53 54 41        .??)UF-INSTA
> 30: 4e 54 20 20 20 20 20 20 34 20 20 20 05 1e 00 36    NT      4   ??.6
> 40: 00 06 00 00 55 42 4e 54 XX XX XX XX XX XX XX XX    .?..UBNTXXXXXXXX
> 50: 20 20 20 20 31 34 30 31 32 33 20 20 60 80 02 41        140123  `??A
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
