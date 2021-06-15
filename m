Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4263A8776
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 19:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhFOR0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 13:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhFOR0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 13:26:52 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2348C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 10:24:46 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ho18so23835139ejc.8
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 10:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kRdmCDT7po6dQZbE57Jaf4zZ4lE4ahzYN42FeuXTcCY=;
        b=Tg7i+XA3thgc4QtfPQlWopefjwwtrAsMs6TeyDSQrlYK1ySXlTzy6fhoBZSeyWhqQD
         SF602UV6nqMJQh5jMWKr+AD3+IDdvIqeF1D0+hMSgeMBRYLBrCKWozTV8BUh/kvPiHQi
         ZgAVYICLEmHpMoeoZS6/ZbkzvtAfrGZfsrXfb5KBPPaNIDi0FZe6KvQp6C2z4g8dM4fc
         pzJQleMsq0k6EM8jCn8JvniSuc+7Tu0CN/x9mw79yV9VlV3G/NnOBgf0xsVF8onvNX4U
         1WSnjQOCV0e+HCAHKtvseOKg+JRlC4u2bKAcmdp3WyWcfmY46sXFTR4SW85LmtmgChpV
         QFcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kRdmCDT7po6dQZbE57Jaf4zZ4lE4ahzYN42FeuXTcCY=;
        b=oLHGqtjzdjochztAPUWFpd/TU5Xu/A3jcBqahg+zx0l09aXL34cU3VE5z1SjYg2GMS
         Z+Nx3KcaYdsQW7IR6Hb4i8IZqitQNDFo/nnBzYAj+sQiAfCKketvYd2bTJMx15p9pEIK
         GZrgeR2i0hqr8MN988ySJN4RqziRG1rtrOV8UzAe1t6ooBQpUu4Qr1D7R51rNAL8EDoo
         1lH0BDcspRQJzdhCSUHdBq4QwJVbLDrGqZVa5B1nO+QBQQ5YFTMz9AOLeBlgpTCXrZdZ
         TmAFEGb31vHvf7KE+sj8GQSKKx/QHaYJvaaUTOAgXwP750Z6ZiqmS+A7dh4D+BC/ZT7f
         Ws1Q==
X-Gm-Message-State: AOAM5324joQxfi8ypXA2kf7l9/jdp1k2EIHk5pem6bIgGi24PqBww6YC
        Do26qVvl7R/7w36YeeuKdvE=
X-Google-Smtp-Source: ABdhPJxkfSNqRWSmLzoleNvAWFI4TvIp67/kFcNrpbQc9z3+ikIbJ7SNjEwLBINe+qerJXFRElds3w==
X-Received: by 2002:a17:906:919:: with SMTP id i25mr647880ejd.171.1623777885547;
        Tue, 15 Jun 2021 10:24:45 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id d17sm10248954ejp.90.2021.06.15.10.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 10:24:45 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Tue, 15 Jun 2021 20:24:44 +0300
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        calvin.johnson@oss.nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] mdio: mdiobus: setup of_node for the MDIO device
Message-ID: <20210615172444.dirudehe3vzis2kw@skbuf>
References: <20210615154401.1274322-1-ciorneiioana@gmail.com>
 <20210615171330.GW22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615171330.GW22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 06:13:31PM +0100, Russell King (Oracle) wrote:
> On Tue, Jun 15, 2021 at 06:44:01PM +0300, Ioana Ciornei wrote:
> > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > 
> > By mistake, the of_node of the MDIO device was not setup in the patch
> > linked below. As a consequence, any PHY driver that depends on the
> > of_node in its probe callback was not be able to successfully finish its
> > probe on a PHY, thus the Generic PHY driver was used instead.
> > 
> > Fix this by actually setting up the of_node.
> > 
> > Fixes: bc1bee3b87ee ("net: mdiobus: Introduce fwnode_mdiobus_register_phy()")
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> >  drivers/net/mdio/fwnode_mdio.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> > index e96766da8de4..283ddb1185bd 100644
> > --- a/drivers/net/mdio/fwnode_mdio.c
> > +++ b/drivers/net/mdio/fwnode_mdio.c
> > @@ -65,6 +65,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
> >  	 * can be looked up later
> >  	 */
> >  	fwnode_handle_get(child);
> > +	phy->mdio.dev.of_node = to_of_node(child);
> >  	phy->mdio.dev.fwnode = child;
> 
> Yes, this is something that was missed, but let's first look at what
> other places to when setting up a device:
> 
>         pdev->dev.fwnode = pdevinfo->fwnode;
>         pdev->dev.of_node = of_node_get(to_of_node(pdev->dev.fwnode));
>         pdev->dev.of_node_reused = pdevinfo->of_node_reused;
> 
>         dev->dev.of_node = of_node_get(np);
>         dev->dev.fwnode = &np->fwnode;
> 
>         dev->dev.of_node = of_node_get(node);
>         dev->dev.fwnode = &node->fwnode;
> 
> That seems to be pretty clear that an of_node_get() is also needed.
> 

I'm not convinced that an of_node_get() is needed besides the
fwnode_handle_get() call that's already there.

The fwnode_handle_get() will call the get callback for that particular
fwnode_handle. When we are in the OF case, the of_fwnode_get() will be
invoked which in turn does of_node_get().

Am I missing something here?

Ioana

