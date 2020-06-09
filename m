Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955111F3B80
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 15:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgFINMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 09:12:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41540 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728404AbgFINMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 09:12:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=T5qZZZONjhOyZmzsYwxogqZVynVoTskOeNFAgtVitgc=; b=0kT+i8bG4gJ9YNgZTit0buJYCX
        2qKIXFpSv1dv/f1KOB1LgmNQD0/+namhgfd9+b1HqSPiPqIfpSYY8G8TA6yoIElSoHuD6Wog52UkJ
        no6a7ZwRv6rKmWDmE7UTvQKa7kvzgR84SKAA9hSB0PpG340P16NmV+uv64+nvte0hASU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jie36-004Vx2-MB; Tue, 09 Jun 2020 15:12:16 +0200
Date:   Tue, 9 Jun 2020 15:12:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        devicetree@vger.kernel.org, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: ethernet: mvneta: add support for 2.5G DRSGMII mode
Message-ID: <20200609131216.GJ1022955@lunn.ch>
References: <20200608074716.9975-1-s.hauer@pengutronix.de>
 <20200608145737.GG1006885@lunn.ch>
 <20200609125535.GK11869@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609125535.GK11869@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 02:55:35PM +0200, Sascha Hauer wrote:
> On Mon, Jun 08, 2020 at 04:57:37PM +0200, Andrew Lunn wrote:
> > On Mon, Jun 08, 2020 at 09:47:16AM +0200, Sascha Hauer wrote:
> > > The Marvell MVNETA Ethernet controller supports a 2.5 Gbps SGMII mode
> > > called DRSGMII.
> > > 
> > > This patch adds a corresponding phy-mode string 'drsgmii' and parses it
> > > from DT. The MVNETA then configures the SERDES protocol value
> > > accordingly.
> > > 
> > > It was successfully tested on a MV78460 connected to a FPGA.
> > 
> > Hi Sascha
> > 
> > Is this really overclocked SGMII, or 2500BaseX? How does it differ
> > from 2500BaseX, which mvneta already supports?
> 
> I think it is overclocked SGMII or 2500BaseX depending on the Port MAC
> Control Register0 PortType setting bit.
> As said to Russell we have a fixed link so nobody really cares if it's
> SGMII or 2500BaseX. This boils down the patch to fixing the Serdes
> configuration setting for 2500BaseX.

Hi Sascha

Does 2500BaseX work for your use case? Since this drsmgii mode is not
well defined, i would prefer to not add it, unless it is really
needed.

	Andrew
