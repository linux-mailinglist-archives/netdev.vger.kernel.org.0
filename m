Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983B6428123
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 14:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhJJMNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 08:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbhJJMNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 08:13:49 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BE5C061570;
        Sun, 10 Oct 2021 05:11:50 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r18so55819467edv.12;
        Sun, 10 Oct 2021 05:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fJ6kaV8bcdv5Zt4pSqpABLt7WYhvyccXqerlD+DDAng=;
        b=ZOewO46GQqyDxTqKPsKLKlGbRzulv0+Z4Lsd8soCpYX1IiuJERI66/ENouWuJIPSLA
         Q5dQnTRiqHpk2ixWyxelbtYQqRRUR6TrY4GyxektiMpDEBxuHepesYlCfVZm95ocPQbz
         KodihQr21IkzUM/6DCYAuii2PH2wrA3jHCPp3mV709B6vNsbcF42DhxmfhKER2xxA7p7
         QupCqL2ztRVwsvQXSX9uah/5UOi5Aw4jN/PhQqUmWtcOGT2C3zyNuxmm1tWhJp0wNLnm
         MovQBZv/9NbEooHqd2/BvAyDiNfEFLOJAjF8F76aarXNmqjaozGs0EZLTSCbEZBPdU5C
         781A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fJ6kaV8bcdv5Zt4pSqpABLt7WYhvyccXqerlD+DDAng=;
        b=HOZZ4MeWDJIuQyZonjqh+kuw8yIC02KILzC6M+79CLma2smrKUAaVRCx5PITuvWq8W
         aPr4Dzs6hdMmYbtsox3MrX6GD5wuNKhvb+Fam0auZ8/+kDczsQXIZHj7AQVGnqFbwv7+
         kmTQMPkBNYPqDnVLeJD3iATQeXZmds3GUC1565gQiWgwugBbvh8+lWeKMOdSnYJ/5wKg
         aG6Pl0vldokFKsNVJNaptU4i35wVC0B2oBIFs2kHxnQBOCNF63htQ8+LcVD7n7ndT08x
         ThMHHWXHx4RtkVz7RCbK3nS55wn2yZtWRSY46J0/0f11TuddEz4L/eHTVztamV68CnPv
         /0+A==
X-Gm-Message-State: AOAM533vJxEXTZHr5qqwd9z50SYp4O2yo6/sISOkUc5BpVK0hGbKrw4N
        jtfP6YNTRdEaLedWIX7o434=
X-Google-Smtp-Source: ABdhPJyzUTAZK8Ygbv79B9odsuZfuNXkkNWmKizOibLzZRDvgyxfsGbmsEWIfPanKT9Vg5IEvkccMg==
X-Received: by 2002:a50:bf08:: with SMTP id f8mr31245921edk.400.1633867909000;
        Sun, 10 Oct 2021 05:11:49 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id b13sm2538452ede.97.2021.10.10.05.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 05:11:48 -0700 (PDT)
Date:   Sun, 10 Oct 2021 14:11:46 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH v4 03/13] dt-bindings: net: dsa: qca8k: Add MAC
 swap and clock phase properties
Message-ID: <YWLYguB8jIN8QXK4@Ansuel-xps.localdomain>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-4-ansuelsmth@gmail.com>
 <20211010120728.da56if3z7rtzb6hu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010120728.da56if3z7rtzb6hu@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 03:07:28PM +0300, Vladimir Oltean wrote:
> On Sun, Oct 10, 2021 at 01:15:46PM +0200, Ansuel Smith wrote:
> > Add names and descriptions of additional PORT0_PAD_CTRL properties.
> > qca,sgmii-(rx|tx)clk-falling-edge are for setting the respective clock
> > phase to failling edge.
> > 
> > Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > index 8c73f67c43ca..cc214e655442 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > @@ -37,6 +37,10 @@ A CPU port node has the following optional node:
> >                            managed entity. See
> >                            Documentation/devicetree/bindings/net/fixed-link.txt
> >                            for details.
> > +- qca,sgmii-rxclk-falling-edge: Set the receive clock phase to falling edge.
> > +                                Mostly used in qca8327 with CPU port 0 set to
> > +                                sgmii.
> > +- qca,sgmii-txclk-falling-edge: Set the transmit clock phase to falling edge.
> >  
> >  For QCA8K the 'fixed-link' sub-node supports only the following properties:
> >  
> > -- 
> > 2.32.0
> > 
> 
> Must first document, then use.
> Also, would you care converting qca8k.txt to qca8k.yaml?

Ow ok, will swap alle the patch.
About converting... Hard task will try but it will be a nightmare. Sad
me.

-- 
	Ansuel
