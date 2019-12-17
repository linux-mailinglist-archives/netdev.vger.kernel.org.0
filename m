Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8C91226F9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 09:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfLQItg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 03:49:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56764 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfLQItg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 03:49:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GEzuIqBB9GHmUpKlQQKk2nCJPFeO/xJkUuSKHVRTwII=; b=ydYNa7K/raguYbkq9lGxyoGQtu
        WNucqrX26OMvpQWiba2xXIuxgxMelaXr9Ssrylu2yMXdsdfET8za0ZCEZsueTwT9WsSvwGSv1Ahld
        MMzruhOzv61MH+1kEmA4LgxrBh9pixCCrqlYwPOr5vDF7U4rauQiyTz/h4FexVyhhVrQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ih8Xn-0002BC-FL; Tue, 17 Dec 2019 09:49:27 +0100
Date:   Tue, 17 Dec 2019 09:49:27 +0100
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
Subject: Re: [PATCH v5 3/5] MIPS: ath79: ar9331: add ar9331-switch node
Message-ID: <20191217084927.GE6994@lunn.ch>
References: <20191216074403.313-1-o.rempel@pengutronix.de>
 <20191216074403.313-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216074403.313-4-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 08:44:01AM +0100, Oleksij Rempel wrote:
> Add switch node supported by dsa ar9331 driver.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
