Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7971722B9
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 17:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbgB0QDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 11:03:04 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:36777 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729153AbgB0QDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 11:03:04 -0500
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id BE9BF100002;
        Thu, 27 Feb 2020 16:01:49 +0000 (UTC)
Date:   Thu, 27 Feb 2020 17:01:49 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, foss@0leil.net
Subject: Re: [PATCH net-next 3/3] net: phy: mscc: implement RGMII skew delay
 configuration
Message-ID: <20200227160149.GB1686232@kwain>
References: <20200227152859.1687119-1-antoine.tenart@bootlin.com>
 <20200227152859.1687119-4-antoine.tenart@bootlin.com>
 <20200227155128.GB5245@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200227155128.GB5245@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On Thu, Feb 27, 2020 at 04:51:28PM +0100, Andrew Lunn wrote:
> On Thu, Feb 27, 2020 at 04:28:59PM +0100, Antoine Tenart wrote:
> > This patch adds support for configuring the RGMII skews in Rx and Tx
> > thanks to properties defined in the device tree.
> 
> Hi Antoine
> 
> What you are not handling here in this patchset is the four RGMII
> modes, and what they mean in terms of delay:
> 
>         PHY_INTERFACE_MODE_RGMII,
>         PHY_INTERFACE_MODE_RGMII_ID,
>         PHY_INTERFACE_MODE_RGMII_RXID,
>         PHY_INTERFACE_MODE_RGMII_TXID,
> 
> The PHY driver should be adding delays based on these
> values. Generally, that is enough to make the link work. You only need
> additional skew in DT when you need finer grain control than what
> these provide.

Oh, that's right. I'll fix the series and resubmit.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
