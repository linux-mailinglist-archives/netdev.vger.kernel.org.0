Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47195172831
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 19:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgB0Sz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 13:55:29 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:53003 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729564AbgB0Sz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 13:55:28 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id C27771C0003;
        Thu, 27 Feb 2020 18:55:26 +0000 (UTC)
Date:   Thu, 27 Feb 2020 19:55:26 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Quentin Schulz <foss@0leil.net>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: phy: mscc: implement RGMII skew delay
 configuration
Message-ID: <20200227185526.GE1686232@kwain>
References: <20200227152859.1687119-1-antoine.tenart@bootlin.com>
 <20200227152859.1687119-4-antoine.tenart@bootlin.com>
 <1f267571ddd9d1caf3e95afe31e47e30@0leil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f267571ddd9d1caf3e95afe31e47e30@0leil.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Quentin,

On Thu, Feb 27, 2020 at 05:21:58PM +0100, Quentin Schulz wrote:
> On 2020-02-27 16:28, Antoine Tenart wrote:
> > 
> > +	if (of_find_property(dev->of_node, "vsc8584,rgmii-skew-rx", NULL) ||
> > +	    of_find_property(dev->of_node, "vsc8584,rgmii-skew-tx", NULL)) {
> > +		of_property_read_u32(dev->of_node, "vsc8584,rgmii-skew-rx",
> > &skew_rx);
> > +		of_property_read_u32(dev->of_node, "vsc8584,rgmii-skew-tx",
> > &skew_tx);
> > +
> 
> Reading the code, I think **!**of_property_read_u32 could directly replace
> of_find_property in your condition and spare you two calls to that function.

Sure.

> Final nitpick: I would see a check of the skew_rx/tx from DT before you put
> them in the following line, they could be drastically different from 0-8
> value set that you expect considering you're reading a u32 (pass them
> through a GENMASK at least?)

That makes sense, I can add a check.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
