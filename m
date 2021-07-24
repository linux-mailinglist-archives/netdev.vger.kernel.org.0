Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A5A3D48B3
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 19:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhGXQWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 12:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhGXQWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 12:22:42 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A02DC061575;
        Sat, 24 Jul 2021 10:03:13 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n12so2193643wrr.2;
        Sat, 24 Jul 2021 10:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yDHcOTToBqs7w6wQps432x/oWcA2vi+afsM+JxLzc90=;
        b=XxUNVGUnSVvHCNaM/cYzYmkYEE9sPe2ia/RwP6nCogXwL2wQhU0gdGBgHxfL0CmkYs
         SEmzaxC5DDvYNL65H9CsWyN9vbSFc9gPfa5RkVcqbuTGmmE1evShaAr+gUBsHG6xmwEZ
         eqlPAD9wVn4Agd8l4IN4HCi+UY1PveznjXGtlhW5Bl20e17ugjHsQfuLOd3kFiJTbhfc
         rs3i3AIoTbglAQcqBeo6e1wtc9WKfWRRkNPAyZmI+r6wTiHOeamjNwHr3gAxkK96lMn/
         64f6OcklHDP1g8wa1LOI4G/zdhTFNxKpi3xG6N/0ZxB1Z03hntMTutybV7Q8JpBnubsl
         EHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yDHcOTToBqs7w6wQps432x/oWcA2vi+afsM+JxLzc90=;
        b=WgQ6w8C+yYsyr8OBbOamD2HNh3zyQiTHgr7Y06sdAiMAictxdgcE3F11wuLCB6pv/2
         yebtv2bvU3xrVDaGOswsJjoc0gslGTIzAoQUN3CKNkFovec7U1/YdFXF/IgCWqqrTYd9
         7fiQeaJ/VkPFxXArNANFpCxZCINAd2CwKzPD9aDuphqph1H+r1IkDiX7clZMVJvmrKcA
         INWKnXAbNdAYyF0wFbgFzd7hpd+Iu1sIvKjLztJoRSTh3yP8E80Q30eckh+Ea3fZRON0
         COlLZSA2eKfhz5Hd1hSi7S4svj5Dn/H+vqYb5DX1ZZnha1llgSFyGbFLy52YQlpa6wmy
         tv2Q==
X-Gm-Message-State: AOAM533mXFvXumljIGuWDXR3ThvgQNQ3lmtjQbpE+uFLMfUsO/BKGl9i
        +jrcAddK39hMaKc/rC18M2U=
X-Google-Smtp-Source: ABdhPJze+QN1Vh7PNyKNbw8GNjjkhbsAZayu/kZkcomPcbckVlUgTtWNGicCK0BlIjNFq40KmxLjhQ==
X-Received: by 2002:a5d:438c:: with SMTP id i12mr10762739wrq.99.1627146192044;
        Sat, 24 Jul 2021 10:03:12 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id e3sm36706806wra.15.2021.07.24.10.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 10:03:11 -0700 (PDT)
Date:   Sat, 24 Jul 2021 20:03:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Fabio Estevam <festevam@gmail.com>, davem@davemloft.net,
        shawnguo@kernel.org, linux-arm-kernel@lists.infradead.org,
        qiangqing.zhang@nxp.com, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next] ARM: dts: imx6qdl: Remove unnecessary mdio
 #address-cells/#size-cells
Message-ID: <20210724170310.ylouwttmutkpin42@skbuf>
References: <20210723112835.31743-1-festevam@gmail.com>
 <20210723130851.6tfl4ijl7hkqzchm@skbuf>
 <9455e5b8-d994-732f-2c3d-88c7a98aaf86@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9455e5b8-d994-732f-2c3d-88c7a98aaf86@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 24, 2021 at 09:37:35AM -0700, Florian Fainelli wrote:
> On 7/23/2021 6:08 AM, Vladimir Oltean wrote:
> > Hi Fabio,
> >
> > On Fri, Jul 23, 2021 at 08:28:35AM -0300, Fabio Estevam wrote:
> > > Since commit dabb5db17c06 ("ARM: dts: imx6qdl: move phy properties into
> > > phy device node") the following W=1 dtc warnings are seen:
> > >
> > > arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi:323.7-334.4: Warning (avoid_unnecessary_addr_size): /soc/bus@2100000/ethernet@2188000/mdio: unnecessary #address-cells/#size-cells without "ranges" or child "reg" property
> > >
> > > Remove the unnecessary mdio #address-cells/#size-cells to fix it.
> > >
> > > Fixes: dabb5db17c06 ("ARM: dts: imx6qdl: move phy properties into phy device node")
> > > Signed-off-by: Fabio Estevam <festevam@gmail.com>
> > > ---
> >
> > Are you actually sure this is the correct fix? If I look at mdio.yaml, I
> > think it is pretty clear that the "ethernet-phy" subnode of the MDIO
> > controller must have an "@[0-9a-f]+$" pattern, and a "reg" property. If
>
> It is valid to omit the "reg" property of an Ethernet PHY which the kernel
> will then dynamically scan for. If you know the Ethernet PHY address it's
> obviously better to set it so you avoid scanning and the time spent in doing
> that. The boot loader could (should?) also provide that information to the
> kernel for the same reasons.

Interesting, but brittle I suppose (it only works reliably with a single
PHY on a shared MDIO bus). NXP has "QDS" boards for internal development
and these have multi-port riser cards with various PHYs for various
SERDES protocols, and we have a really hard time describing the hardware
in DT (we currently use overlays applied by U-Boot), so we would like
some sort of auto-detection of PHYs if that was possible, but I think
that for anything except the simplest of cases it isn't. For example
what happens if you unbind and rebind two net devices in a different
order - they will connect to a PHY at a different address, won't they?

Anyway, I was wrong, ok, but I think the point still stands that
according to mdio.yaml this DT description is not valid. So after your
explanation, it is the DT schema that we should update.
