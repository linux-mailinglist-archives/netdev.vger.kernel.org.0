Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2F479082
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbfG2QNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:13:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45246 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbfG2QN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 12:13:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QYrvNb79Rt5AwwY/wRq3Oon8YU+En/xnuZjb5gkSTYg=; b=hd7PN0C/N/8Oy91rFqnSAtKouM
        xWA/jAjyxM+wO4EN9+Ny5GtNAGPncviqEdE5yZ4t8sp8e19tdDvwejqH+UTgw77ZiZUEeHESVoRON
        WsRWrfybFd6YaW7NfR0J4SdGivexrV3kN13qQWY2zFVWiqDn1iceKEy/NMLOj9c03MrM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hs7gK-0002Tp-Ps; Mon, 29 Jul 2019 17:35:24 +0200
Date:   Mon, 29 Jul 2019 17:35:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/4] enetc: Add mdio bus driver for the PCIe
 MDIO endpoint
Message-ID: <20190729153524.GG4110@lunn.ch>
References: <1564394627-3810-1-git-send-email-claudiu.manoil@nxp.com>
 <1564394627-3810-3-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564394627-3810-3-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	hw->port = pci_iomap(pdev, 0, 0);
> +	if (!bus->priv) {

hw->port ??

	 Andrew
