Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A836FD9BB7
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 22:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394692AbfJPUYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 16:24:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49306 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388251AbfJPUYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 16:24:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lp9sGSeBUfNCINz8D0KXuszYBQzAqsZQkv+K4LudJSs=; b=l+GxzaXFjS8l3ToLipq/WrGhgo
        8vvhof4mQ7FXr+CAR85chuh6HDr9DMnMBjTDb1eTmX4fZ9vysDuZgTkA5SGMU7GoKLD5AhbLjPWYb
        yV1LrfjlU0Zo0E10BjUkZs0FtGhiCZOT9eUBDaPhWb0PNQHYKhZ9PvGMLMhosMCtMYqs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKpps-00017G-Bz; Wed, 16 Oct 2019 22:23:56 +0200
Date:   Wed, 16 Oct 2019 22:23:56 +0200
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
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 2/4] dt-bindings: net: dsa: qca,ar9331 switch
 documentation
Message-ID: <20191016202356.GM17013@lunn.ch>
References: <20191014061549.3669-1-o.rempel@pengutronix.de>
 <20191014061549.3669-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014061549.3669-3-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 08:15:47AM +0200, Oleksij Rempel wrote:
> Atheros AR9331 has built-in 5 port switch. The switch can be configured
> to use all 5 or 4 ports. One of built-in PHYs can be used by first built-in
> ethernet controller or to be used directly by the switch over second ethernet
> controller.

Hi Oleksij

How exactly is this phy sharing controlled? I did not see anything in
the driver. Is there a mux we need to set?

    Andrew
