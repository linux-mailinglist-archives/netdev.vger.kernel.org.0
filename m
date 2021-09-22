Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172394145B5
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbhIVKEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:04:33 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:41944 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234585AbhIVKEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 06:04:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632304982; x=1663840982;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o84MUAaAl22mDdS3oZhqYx+P4ZTe4XQ7zU9iNgirFVY=;
  b=MLRqOUFT9kEO8oDbXwjM0fzdt0hwECAj5ObSh37H5Us6cf5z3Q3iGMle
   WlWIw0Rcxq2hUxWgTcCUp6i4SyTnXHmqZmoaCqPCM8GHgoQvyuHO9AHiF
   MDK/1dZYceHQVHKZ4Xo/+36pwFUVGDA2o8KzAxJdh3KreJUuq+peHea0R
   TR2qj6eZgld+EqfdWqvQGa8NtLxwtTMc8zX1ooBt04I0q7Mj0TAPZ8WIY
   H6Mh5miu4xBxZX7+zIHvxiUh9TNZ0saMPapGQ39WhiDrxR9RKn9+tolfe
   IlHvXI0J4BUshk/P5snk3Jh7fFJiHMyKx42YVvd1UEIdeFkAiI+ttMwPz
   g==;
IronPort-SDR: ibErfwqDhJ2fywgCsuET4CuoS29yy35I7mKoyFBQW1zywnFbkk+Yr2ECx85/edn8JqYt9AP9kK
 TIKixxgFOCBk89BZNjDdZ3Egk9JxiA77bBYa50SQKGAy9nJl75iGTRv0nE8HYjAo5zBMcRDfBh
 DMNk6F3O86owaY9pjc6ZMRic1MTZYgcm2aVdLD/byVg1MkN81qvoGsxxVbYfFcunyQRADFnUHW
 tiPtl31s3soIxQJTwI7dVJPts1sEO4klwtaDI1+kDO5/Hp8Ea6rO4oiZZ3H+bG6f7vljcmDy28
 BkItikD+KqPesWVE6CDRB//W
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="132710408"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Sep 2021 03:03:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 22 Sep 2021 03:03:00 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Wed, 22 Sep 2021 03:03:00 -0700
Date:   Wed, 22 Sep 2021 12:04:29 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 03/12] phy: Add lan966x ethernet serdes PHY
 driver
Message-ID: <20210922100429.pjrd2s4y3jbxpjjt@soft-dev3-1.localhost>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
 <20210920095218.1108151-4-horatiu.vultur@microchip.com>
 <YUiPqJjsoBg99VbR@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YUiPqJjsoBg99VbR@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/20/2021 14:42, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, Sep 20, 2021 at 11:52:09AM +0200, Horatiu Vultur wrote:
> > +static int lan966x_calc_sd6g40_setup_lane(struct lan966x_sd6g40_setup_args config,
> > +                                       struct lan966x_sd6g40_setup *ret_val)
> > +{
> > +     struct lan966x_sd6g40_mode_args sd6g40_mode;
> > +     struct lan966x_sd6g40_mode_args *mode_args = &sd6g40_mode;
> > +
> > +     if (lan966x_sd6g40_get_conf_from_mode(config.mode, config.refclk125M,
> > +                                           mode_args))
> > +             return -1;
> 
> This needs fixing to be a real negative error number.
> lan966x_sd6g40_setup_lane() propagates this functions non-zero
> return value, which is then propagated through lan966x_sd6g40_setup(),
> and then through serdes_set_mode() to the PHY layer.
> 
> In general, I would suggest that _all_ int-returning functions in the
> kernel that return a negative failure value _should_ _always_ return a
> negative error code, so that your reviewers don't have to chase code
> paths to work out whether a mistake such as the above exists.
> 
> To put it another way: never use "return -1" in the kernel.

Hi Russell,

Thanks for the suggestion. I will fix this in the next version.

> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
/Horatiu
