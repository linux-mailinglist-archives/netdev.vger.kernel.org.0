Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7986BB6749
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 17:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731696AbfIRPkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 11:40:08 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37102 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727609AbfIRPkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 11:40:08 -0400
Received: by mail-lj1-f195.google.com with SMTP id l21so408452lje.4;
        Wed, 18 Sep 2019 08:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7XkoLICcoVg3xNydqf6sD/sVuORqqcpyFXgJUDYstHs=;
        b=SYD1i/894hBQ4pSRvbwodu1FTgcGr8PyJR0IX1MX28JW0UTLHS67zDoCfWFi/CnCnu
         WRfSo4eN4rHJLtS1KExCqQXC9IwgXJXNB+Nwn/x7cquWzqLgVR15a06LchJEtzcQ/lWh
         s1pFHqX8dXXqVKgpMCdjMJFdeHaSUbeJ4HbBZ4EnzthjcEZU78+8O4Ap/bfp3hsvLdj3
         QSZd20AHPM9K0NQpF19s+p8yZFynPwWed7W18DJINz7KHWxFTt8CNmWKdDJDRsx/AXM2
         gecObI4YJ+dnpMu7LtYYghR/cWN91Lsfw58ms6QXgSZK5VaLcwrrvdHoZna2u+9VSi2m
         rEKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7XkoLICcoVg3xNydqf6sD/sVuORqqcpyFXgJUDYstHs=;
        b=DST3WSMwbQ8EIcB1MUQWXUwXj1LyfATaiVYmokjGWaev52vmRv8QcHzmScY2wrrRW7
         wXrHzuTaSD0inz/xefcKpci10vM62dxe4FfbvEqJEURr545MgMNyaoNXG38g4qz351yV
         izz5DVHX5wCYOxx07xghmKRa55jrZuMj2ElnMDf3ur7psW1a5Zy5pPR/cF25K7gaMk1Y
         vfCXKXy2qwNnFhvqSIIzaI4CMGBxSt6x4ax3YMx77imVMptlbDUkut4tU1h7n9HAje8W
         E6DFozriPKsI7LWfkq4Pqk8VK5vz4R0VS5aN3PQczTBBRj9PCEq9mHCZRMfBf6GBkUId
         v6aA==
X-Gm-Message-State: APjAAAUi5hA1Vx+pcGHPVLHRohCwwAGs+7nYClrIt5rWsLL7maZ4+Ozu
        YldQ1fKFCo3Q2dJ575O6vOU=
X-Google-Smtp-Source: APXvYqyQO8EqyJhUu47Su+eqj4a08VUFUdk2tFTIYsVOzXynUhSOGpqk975Yqz6jFFBklHjjg7Hdow==
X-Received: by 2002:a2e:b1d0:: with SMTP id e16mr2715998lja.0.1568821205917;
        Wed, 18 Sep 2019 08:40:05 -0700 (PDT)
Received: from localhost.localdomain (t109.niisi.ras.ru. [193.232.173.109])
        by smtp.gmail.com with ESMTPSA id q1sm1063390lfb.30.2019.09.18.08.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 08:40:05 -0700 (PDT)
Date:   Wed, 18 Sep 2019 18:40:03 +0300
From:   Peter Mamonov <pmamonov@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net/phy: fix DP83865 10 Mbps HDX loopback disable
 function
Message-ID: <20190918154003.GB2493@localhost.localdomain>
References: <20190918141931.GK9591@lunn.ch>
 <20190918144825.23285-1-pmamonov@gmail.com>
 <20190918152646.GL9591@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918152646.GL9591@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Sep 18, 2019 at 05:26:46PM +0200, Andrew Lunn wrote:
> On Wed, Sep 18, 2019 at 05:48:25PM +0300, Peter Mamonov wrote:
> > According to the DP83865 datasheet "The 10 Mbps HDX loopback can be
> > disabled in the expanded memory register 0x1C0.1." The driver erroneously
> > used bit 0 instead of bit 1.
> 
> Hi Peter
> 
> This is version 2, not 1. Or if you want to start counting from 0, it
> would be good to put v0 in your first patch :-)
> 
> It is also normal to put in the commit message what changed from the
> previous version.
> 
> This is a fix. So please add a Fixes: tag, with the hash of the commit
> which introduced the problem.
> 
> And since this is a fix, it should be against DaveM net tree, and you
> indicate this in the subject line with [PATCH net v3].

Thanks for the tips! Will submit new version soon.

Regards,
Peter

> 
> Thanks
> 	Andrew
> 
> > 
> > Signed-off-by: Peter Mamonov <pmamonov@gmail.com>
> > ---
> >  drivers/net/phy/national.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/phy/national.c b/drivers/net/phy/national.c
> > index 2addf1d3f619..3aa910b3dc89 100644
> > --- a/drivers/net/phy/national.c
> > +++ b/drivers/net/phy/national.c
> > @@ -110,14 +110,17 @@ static void ns_giga_speed_fallback(struct phy_device *phydev, int mode)
> >  
> >  static void ns_10_base_t_hdx_loopack(struct phy_device *phydev, int disable)
> >  {
> > +	u16 lb_dis = BIT(1);
> > +
> >  	if (disable)
> > -		ns_exp_write(phydev, 0x1c0, ns_exp_read(phydev, 0x1c0) | 1);
> > +		ns_exp_write(phydev, 0x1c0,
> > +			     ns_exp_read(phydev, 0x1c0) | lb_dis);
> >  	else
> >  		ns_exp_write(phydev, 0x1c0,
> > -			     ns_exp_read(phydev, 0x1c0) & 0xfffe);
> > +			     ns_exp_read(phydev, 0x1c0) & ~lb_dis);
> >  
> >  	pr_debug("10BASE-T HDX loopback %s\n",
> > -		 (ns_exp_read(phydev, 0x1c0) & 0x0001) ? "off" : "on");
> > +		 (ns_exp_read(phydev, 0x1c0) & lb_dis) ? "off" : "on");
> >  }
> >  
> >  static int ns_config_init(struct phy_device *phydev)
> > -- 
> > 2.23.0
> > 
