Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58D05122723
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 09:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfLQI4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 03:56:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56792 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfLQI4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 03:56:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Rb0YZBuF7fyymuJc9F5dt+KrT6e7je4rrQTXU1u/Fns=; b=h/O3F2cMuzQs9kWWtp0mZ9Y8AT
        ZPV6k3hZ9LS6BQ/tiBQzBib2NSRvrVKCzZzUz51FaXjhMdjMo8XsqR+DHG2mNuo7k864TUBs0FBWR
        lvj0erRYQOKxcJjzkcydl8CT9Ww4uMh957VKhLXwlUvCUZsXv7wWd/Au5cObY6U8k+XM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ih8e6-0002Gn-79; Tue, 17 Dec 2019 09:55:58 +0100
Date:   Tue, 17 Dec 2019 09:55:58 +0100
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
Subject: Re: [PATCH v5 5/5] net: dsa: add support for Atheros AR9331 built-in
 switch
Message-ID: <20191217085558.GF6994@lunn.ch>
References: <20191216074403.313-1-o.rempel@pengutronix.de>
 <20191216074403.313-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216074403.313-6-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 08:44:03AM +0100, Oleksij Rempel wrote:
> Provide basic support for Atheros AR9331 built-in switch. So far it
> works as port multiplexer without any hardware offloading support.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> +
> +/* dummy reg to change page */
> +#define AR9331_SW_REG_PAGE			BIT(18)

Nit pick: It seems odd to define a register number using a BIT macro.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
