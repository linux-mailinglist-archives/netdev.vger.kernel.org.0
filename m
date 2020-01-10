Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A909A13774A
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgAJTdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:33:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60578 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727709AbgAJTdw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 14:33:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Y+GDTn9tkHWTYtCXAFZVZoOP4Q0QrqzM4C7IlKEbmaY=; b=nR2k6fVjFvLF1j/GiSSvtMLFMl
        USN7WfA5tsouTLhDE1FUPbT1Jf5yFAg+ipFsCXEkrBRxOtjgr5tcZ+X5e9aWUrMyxiL9OjG4bdQyR
        9sKV8LVCVE9KQiJUiMDG/STXbtoArq8NmaVG2WeUPxB3jiHsWnvHiM6CQk26lJzpHCXY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iq02T-0003sa-9C; Fri, 10 Jan 2020 20:33:45 +0100
Date:   Fri, 10 Jan 2020 20:33:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andre Przywara <andre.przywara@arm.com>, netdev@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Robert Hancock <hancock@sedsystems.ca>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/14] net: axienet: Fix SGMII support
Message-ID: <20200110193345.GR19739@lunn.ch>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-8-andre.przywara@arm.com>
 <20200110145849.GC25745@shell.armlinux.org.uk>
 <20200110173249.0b086a76@donnerap.cambridge.arm.com>
 <20200110180546.GK25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110180546.GK25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Phylink currently expects the result of the in-band negotiation at
> the MAC PCS to be propagated to the MAC by hardware (as this is what
> happens with mvneta and mvpp2, the first two MACs that phylink
> supports.)  If there is hardware that requires something else, then
> that will need to be revisited, and will result in not only code but
> also documentation updates as well.

Hi Russell

This is an issue i'm having at the moment with Marvell switches. They
do not propagate the results to the MAC. So when i get an interrupt
from the SERDES that the link is up, i'm programming the MAC as
needed.

	Andrew
