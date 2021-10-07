Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A724253FD
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241444AbhJGN1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbhJGN1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:27:30 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8268C061570;
        Thu,  7 Oct 2021 06:25:36 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id v18so23189841edc.11;
        Thu, 07 Oct 2021 06:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZtaAQUcIMAxwmN/4pd2KyUfGo5ZqQSY8rbyvPPScUUo=;
        b=Xm1SX2ysSVEfGgCINe/ENA/iSoFbIyj1gorUkdZtdfQ6DBiSFEsrtQQcTHU3/UxkQl
         5jVFR9vi1SkN3Rfs6xYuBjv8Pte1xg/i6rBRyCUICzKH8tFYERvO8704Tn0xBNStoT1l
         ZQ7iKoTTv3jNdWyVEdLftTo2v1GBHUKWRWStaI6PFov4qT1XMIx0Kgwba+pAjtt8Kfpd
         KLcnToA794UC2J9tKJ0gr81XRj+iTMkEIp/RRxPcgJ4/Ojyttk24KI24T1/HTqEeybOo
         oBBTOwNQZ87jrfAlCzDFWFhKlcTb/z+yvrazzlIhY5mZXty4OWNXeCJ5ervILn6emAMC
         RpIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZtaAQUcIMAxwmN/4pd2KyUfGo5ZqQSY8rbyvPPScUUo=;
        b=7GH6zm+tZmL3sxHndVmJkWSDqZ7o9mDm9hutZQPyV6qMkKBZUOBvx3WY+RO1e302B7
         7CdAjLU54xcTTAX7oxkyow3DzTgpQbiXwTNFwZ+itihoFuT7UBiOmVCMWEZsiDmdFB3C
         UbIb0hYW5ZaCsvFF0Hlq/Df2955lbc+IbQMGB4vdKD8oU5zB8reGScItY+/n4ttP97AD
         64YduWIEnqTn/QXPoq9X4Ur/A8oTunxRvhqeRwevWW0A185C7Z0/JQjGJUCcJSLvtNJF
         5Pj2sQECxET1pQ8RMsL8GfydY/zy7CSdcGizf+E97ZglRgZqv88KnxJe1XUeKcTZ4NS0
         YVYg==
X-Gm-Message-State: AOAM5334e0uoL6RZPhyPoSzEVC4Qgyca4vgcZtVuw6cc7yd7EV2Fr5U0
        0KqAnczvOn65BdXQi5Sex2Y=
X-Google-Smtp-Source: ABdhPJxXUzW/7r/ROuBTG2S2BtbY3zXzRrX1UFoZrW7TMnMowtCxZmU6F5irOgPstO+ySO+UqFBYMg==
X-Received: by 2002:a17:906:b254:: with SMTP id ce20mr5767002ejb.306.1633613135214;
        Thu, 07 Oct 2021 06:25:35 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id ay19sm8572792edb.20.2021.10.07.06.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 06:25:34 -0700 (PDT)
Date:   Thu, 7 Oct 2021 15:25:32 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 06/13] Documentation: devicetree: net: dsa:
 qca8k: document rgmii_1_8v bindings
Message-ID: <YV71TCksnbixsYI0@Ansuel-xps.localdomain>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-7-ansuelsmth@gmail.com>
 <YV46wJYlJZHAZLyD@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV46wJYlJZHAZLyD@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 02:09:36AM +0200, Andrew Lunn wrote:
> On Thu, Oct 07, 2021 at 12:35:56AM +0200, Ansuel Smith wrote:
> > Document new qca,rgmii0_1_8v and qca,rgmii56_1_8v needed to setup
> > mac_pwr_sel register for ar8327 switch.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > index 8c73f67c43ca..1f6b7d2f609e 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > @@ -13,6 +13,8 @@ Required properties:
> >  Optional properties:
> >  
> >  - reset-gpios: GPIO to be used to reset the whole device
> > +- qca,rgmii0-1-8v: Set the internal regulator to supply 1.8v for MAC0 port
> > +- qca,rgmii56-1-8v: Set the internal regulator to supply 1.8v for MAC5/6 port
> 
> What is the consumer of these 1.8v? The MACs are normally internal,
> the regulators are internal, so why is a DT property needed?
> 
>     Andrew

Only some device require this, with these bit at 0, the internal
regulator provide 1.5v. It's not really a on/off but a toggle of the
different operating voltage. Some device require this and some doesn't.

-- 
	Ansuel
