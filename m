Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B90A179080
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbfG2QN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:13:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45246 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728903AbfG2QN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 12:13:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=E8+StAJi8iR+10hnQNem7TjVI3Aa8ZKLhuLix4pgEFU=; b=Glj5iqr8L2yWUK8p+I64wgdP9q
        DZOE9qPw6xIsieVDpKTkB1Y/FmeR8En9e9crk2+PXwgDl7axcaxmAX9YslGJySYLZbDIsuh1p89rQ
        Ps3ONpBtXfyrGD5OoRmNMw7K0SJagtQkNh7iJv97bmLTOSbF7YvCilxzuOkF0y/TrHs4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hs7ib-0002Wc-2C; Mon, 29 Jul 2019 17:37:45 +0200
Date:   Mon, 29 Jul 2019 17:37:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/4] arm64: dts: fsl: ls1028a: Enable eth
 port1 on the ls1028a QDS board
Message-ID: <20190729153745.GI4110@lunn.ch>
References: <1564394627-3810-1-git-send-email-claudiu.manoil@nxp.com>
 <1564394627-3810-5-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564394627-3810-5-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 01:03:47PM +0300, Claudiu Manoil wrote:
> LS1028a has one Ethernet management interface. On the QDS board, the
> MDIO signals are multiplexed to either on-board AR8035 PHY device or
> to 4 PCIe slots allowing for SGMII cards.
> To enable the Ethernet ENETC Port 1, which can only be connected to a
> RGMII PHY, the multiplexer needs to be configured to route the MDIO to
> the AR8035 PHY.  The MDIO/MDC routing is controlled by bits 7:4 of FPGA
> board config register 0x54, and value 0 selects the on-board RGMII PHY.
> The FPGA board config registers are accessible on the i2c bus, at address
> 0x66.
> 
> The PF3 MDIO PCIe integrated endpoint device allows for centralized access
> to the MDIO bus.  Add the corresponding devicetree node and set it to be
> the MDIO bus parent.
> 
> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
