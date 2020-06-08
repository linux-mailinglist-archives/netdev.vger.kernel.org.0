Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A671F1B83
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 16:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbgFHO5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 10:57:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgFHO5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 10:57:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pxY+k1EDOGmASjIgfSa3YXyUmL2DqkU4/aox1YMvk6I=; b=2CXriWfrKP1Fl1stlshdbKaz2m
        OfGHmEc7e9keimnc6B1dDuLMA6W2Q3LLtqe0b748WjJw0/OkXJdNpHwFSBUa71VtgqlTzrFh2/AU6
        KcM4j01FXNpS3I0NCGVqADFVUqXE49yVSqMa/bIYOu9G5jtJ3MnjK8wN4LJwtXs/ZvgM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jiJDV-004PYI-4V; Mon, 08 Jun 2020 16:57:37 +0200
Date:   Mon, 8 Jun 2020 16:57:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: ethernet: mvneta: add support for 2.5G DRSGMII mode
Message-ID: <20200608145737.GG1006885@lunn.ch>
References: <20200608074716.9975-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608074716.9975-1-s.hauer@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 09:47:16AM +0200, Sascha Hauer wrote:
> The Marvell MVNETA Ethernet controller supports a 2.5 Gbps SGMII mode
> called DRSGMII.
> 
> This patch adds a corresponding phy-mode string 'drsgmii' and parses it
> from DT. The MVNETA then configures the SERDES protocol value
> accordingly.
> 
> It was successfully tested on a MV78460 connected to a FPGA.

Hi Sascha

Is this really overclocked SGMII, or 2500BaseX? How does it differ
from 2500BaseX, which mvneta already supports?

Also, does comphy need extensions to support this?

      Andrew
