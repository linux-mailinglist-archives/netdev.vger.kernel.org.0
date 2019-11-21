Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A65C1048C4
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 03:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfKUC4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 21:56:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48922 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbfKUC4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 21:56:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tHff8yLVcaE8TMTvwAjzjBhJUzckKAjVkorXlk/oom0=; b=3rF4LKf/hzt5hHnkKLDPaRyHf5
        Vk5+eAx/zgu89QhgGxfsagQKA6v2X8/YNq7FK8LANfH6p0Un8NI7fhj7dWBRkOZ8uOFDdlfA26/GA
        XX2D3jKI0V3ZG3EqaV5Ppb47HlqTtGLRikZiabdq6rHhmjfwIwqMpjJ+jUnf2f9QPsBo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iXcde-0007Cl-LI; Thu, 21 Nov 2019 03:56:10 +0100
Date:   Thu, 21 Nov 2019 03:56:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 5/5] net: dsa: ocelot: add hardware timestamping support
 for Felix
Message-ID: <20191121025610.GO18325@lunn.ch>
References: <20191120082318.3909-1-yangbo.lu@nxp.com>
 <20191120082318.3909-6-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120082318.3909-6-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static irqreturn_t felix_irq_handler(int irq, void *data)
> +{
> +	struct ocelot *ocelot = (struct ocelot *)data;
> +
> +	/* The INTB interrupt is used for both PTP TX timestamp interrupt
> +	 * and preemption status change interrupt on each port.
> +	 *
> +	 * - Get txtstamp if have
> +	 * - TODO: handle preemption. Without handling it, driver may get
> +	 *   interrupt storm.
> +	 */

I assume there are no register bits to enable/disable these two
interrupt sources?

What is preemption?

     Andrew
