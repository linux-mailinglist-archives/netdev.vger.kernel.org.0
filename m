Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3B501226EF
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 09:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfLQIsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 03:48:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56744 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfLQIsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 03:48:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fk5coEWZoUakPk9isbntxQ0NicFavEX2mmDm+uQBIiQ=; b=z4B7Ahn8JD/hrye1oKWmadAPos
        3OZnYX1pT/yRZ+Cfe6409GGxguO6FkAkKR2HRulNd/qSrncFt05MVxSJ/ZgUt56okqEFU9TNxnpsP
        binVEkk3HFMEaYtdxlZ1GAZXnnKSrNBnW9qpHt1Tu9JsbnS2IcyfGq3rUncZv4LHNCgg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ih8WT-00029X-9z; Tue, 17 Dec 2019 09:48:05 +0100
Date:   Tue, 17 Dec 2019 09:48:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v5 2/5] dt-bindings: net: dsa: qca,ar9331 switch
 documentation
Message-ID: <20191217084805.GD6994@lunn.ch>
References: <20191216074403.313-1-o.rempel@pengutronix.de>
 <20191216074403.313-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216074403.313-3-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 08:44:00AM +0100, Oleksij Rempel wrote:
> Atheros AR9331 has built-in 5 port switch. The switch can be configured
> to use all 5 or 4 ports. One of built-in PHYs can be used by first built-in
> ethernet controller or to be used directly by the switch over second ethernet
> controller.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
