Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255A427D686
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 21:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgI2TMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 15:12:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34242 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728166AbgI2TMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 15:12:15 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNL2X-00GnK7-0X; Tue, 29 Sep 2020 21:11:53 +0200
Date:   Tue, 29 Sep 2020 21:11:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        devicetree@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 devicetree 2/2] powerpc: dts: t1040rdb: add ports for
 Seville Ethernet switch
Message-ID: <20200929191153.GF3996795@lunn.ch>
References: <20200929113209.3767787-1-vladimir.oltean@nxp.com>
 <20200929113209.3767787-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929113209.3767787-3-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +&seville_port0 {
> +	managed = "in-band-status";
> +	phy-handle = <&phy_qsgmii_0>;
> +	phy-mode = "qsgmii";
> +	/* ETH4 written on chassis */
> +	label = "swp4";

If ETH4 is on the chassis why not use ETH4?

   Andrew
