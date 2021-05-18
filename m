Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C89387E29
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 19:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351057AbhERRDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 13:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351051AbhERRDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 13:03:45 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D161C061573;
        Tue, 18 May 2021 10:02:26 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b17so12102399ede.0;
        Tue, 18 May 2021 10:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xkwOYgQBRIpM16uMwoU+mUrmHBsuGWAbr73e2ncPA0g=;
        b=sT7fAyu4QfLljdQWFeOwDudseO9RbNBpyFab8AqpAV7vjWXQn4yNdTLoVZkZWw5OFi
         o1QmudE/Lcw9PWbZC+4HZip153Bii520ydGlx6+y9CvxpgMkTUL/bXufsFD68eboyZdc
         TrNiFD+ZZrTbgsvVEu3z3InVBbg5UdmQ6XanjhCW6VhmFrFBLevC4BiqB0btxeOhAQNR
         OwU+QtR1jTbVNapZwXZVyvApfj4qca+suat4h53tzit/GSuJv2wMiO6aVemUGOYUmTMK
         qWIRgi3WoGH+EjJuq0vO7McYQi0jPmcP/FSUUxN5zqJmUjW1pjh9vm7AOlzjRxpWjitI
         t+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xkwOYgQBRIpM16uMwoU+mUrmHBsuGWAbr73e2ncPA0g=;
        b=Sc0FGy5UAWBdu5cdGcRnQIM8PPS+c9F+C2zHLXbKz1x/JeuRUe66WGNcRXvA187goC
         Bz4RMSzCvqjE01YdZMPs6j72uCU9M5W2efVHtDl10qHCoICFTkP3ehL5wr5c8hF2HkF+
         u9HPM2NMeMSaIUeunvhtcoq7zfEN8rW1s9CPWtmZ8/aBwMnzKkRpfZ/51IcTpw+9VMuy
         1w+LoNlJedrv7fNPc+jMPUqGN1hkvnUXUADZKbWwvBsPut0Y2LHt+BcMcQOhf12krtGR
         p2pRSf1gAZDX5rXZCckZOKwyHCZxkWcwv88mit21PCCx5+n+CMwx4pq9V3rqzX67lFN0
         fERQ==
X-Gm-Message-State: AOAM533xnyEOuTIOG0f3RJAYz6fQ2iezEXgW2s8vNqr7xjPKdZm8oBdH
        X59lB0ZRPT7dodLG1NYOVbU=
X-Google-Smtp-Source: ABdhPJw81MW0rCrNornXhuZKtlng8yDEqdUawUTdWwLI8y2RX7EnkE6M1XbkYHBQAepBnN9GIVu73A==
X-Received: by 2002:aa7:c150:: with SMTP id r16mr8020182edp.82.1621357344981;
        Tue, 18 May 2021 10:02:24 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id v1sm10451510ejw.117.2021.05.18.10.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:02:24 -0700 (PDT)
Date:   Tue, 18 May 2021 20:02:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: linux-next: Tree for May 18 (drivers/net/dsa/qca8k.c)
Message-ID: <20210518170223.pcd32732m2uixfgg@skbuf>
References: <20210518192729.3131eab0@canb.auug.org.au>
 <785e9083-174e-5287-8ad0-1b5b842e2282@infradead.org>
 <20210518164348.vbuxaqg4s3mwzp4e@skbuf>
 <1e431580-37e5-dc80-8307-eb79125f9b75@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e431580-37e5-dc80-8307-eb79125f9b75@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 09:57:13AM -0700, Randy Dunlap wrote:
> On 5/18/21 9:43 AM, Vladimir Oltean wrote:
> > Hi Randy,
> > 
> > Would something like this work?
> > 
> > -----------------------------[ cut here ]-----------------------------
> > From 36c0b3f04ebfa51e52bd1bc2dc447d12d1c6e119 Mon Sep 17 00:00:00 2001
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Date: Tue, 18 May 2021 19:39:18 +0300
> > Subject: [PATCH] net: mdio: provide shim implementation of
> >  devm_of_mdiobus_register
> > 
> > Similar to the way in which of_mdiobus_register() has a fallback to the
> > non-DT based mdiobus_register() when CONFIG_OF is not set, we can create
> > a shim for the device-managed devm_of_mdiobus_register() which calls
> > devm_mdiobus_register() and discards the struct device_node *.
> > 
> > In particular, this solves a build issue with the qca8k DSA driver which
> > uses devm_of_mdiobus_register and can be compiled without CONFIG_OF.
> > 
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  include/linux/of_mdio.h | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
> > index 2b05e7f7c238..da633d34ab86 100644
> > --- a/include/linux/of_mdio.h
> > +++ b/include/linux/of_mdio.h
> > @@ -72,6 +72,13 @@ static inline int of_mdiobus_register(struct mii_bus *mdio, struct device_node *
> >  	return mdiobus_register(mdio);
> >  }
> >  
> > +static inline int devm_of_mdiobus_register(struct device *dev,
> > +					   struct mii_bus *mdio,
> > +					   struct device_node *np)
> > +{
> > +	return devm_mdiobus_register(dev, mdio);
> > +}
> > +
> >  static inline struct mdio_device *of_mdio_find_device(struct device_node *np)
> >  {
> >  	return NULL;
> > -----------------------------[ cut here ]-----------------------------
> > 
> 
> Yes, that's all good. Thanks.
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks. Waiting for a little bit longer for somebody a little more
authoritative on the MDIO/PHY topic, will submit formally afterwards.
