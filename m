Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE872F1C06
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389256AbhAKRO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389213AbhAKRO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:14:28 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33027C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:13:48 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g24so497333edw.9
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eCr6Q3C2LFwWqF1Dvzjhe7LbSvf7Xj64Wzj8qap1D1c=;
        b=QcN7Afs/UeyTfd/40uAs3KzCMDeJ+IpAJ74C80I9IfMYCrVAM6f2JnX6cVQkXzAInV
         dU0PSpILP2esvHdqtD/38oSg3vbQDeOPFl9n7/LLCOy/D7dzLhxFJgQKQuQziO6850Kw
         uO9bWQ5SeaOS0DMPO/tre7roD/m5tV/h2GCfYzsQRxKVu0LbaKD6VPLBaVdH33lumYCS
         5MgDrEUnOtsIdKZpWQw75PUqUNZugswphIYsifMuVxBOPtfJ9J4mmyp6jlX3B7cCP53l
         HZzQz+6CZDDQt7ZeyJGpSI7VTIaEnltLal92TUjbz0sqy4RYBoswXTAW1xHrs57U/fJC
         hLEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eCr6Q3C2LFwWqF1Dvzjhe7LbSvf7Xj64Wzj8qap1D1c=;
        b=GHMCoGzH5f83d/wADwAehc2O/Da39ocRfBMfrGXRqZwrgNDPHI6Y4y6+mcasuCWMWt
         h9DLpdI4B3TS3UgWgLtCA01FVT7quTwxU0XpY6TnmioJ0DzJsv2lGYmHNtolgPl/YWd+
         gzC8on+UgEH5tWMqXM5TEs2DVgdENHSacoS47D7/4EQPTHRiHntwoAA7NNGithM7b46C
         XsW8xf+ABtP1AWGtH5o9mINIu3xKa7GQ6eFzIzv9jc242TxYj3r6B8bgBClEJxgqNCIb
         HVreTSVNb18iwpf18zkRjOqV8Dmlru7IBhEaAHKtsAU5Lbo0bUJZYYqpQGfp7JBtnOl6
         j6iw==
X-Gm-Message-State: AOAM5319fVmIxbc7uy84vPcPL7hZGTNs3iwm5rkwHShNg92VhPmXSEEQ
        /UrV2nAvznBGb2FAQ+aUIU8=
X-Google-Smtp-Source: ABdhPJzSwXocJNyWbPNJHohRJlAHhHrtnHc+5WzAukjhg4lvkhEIRqHJv511kFB+ZBuSL7XUX5k6eQ==
X-Received: by 2002:a50:b944:: with SMTP id m62mr295191ede.182.1610385226884;
        Mon, 11 Jan 2021 09:13:46 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id v18sm101540ejw.18.2021.01.11.09.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:13:46 -0800 (PST)
Date:   Mon, 11 Jan 2021 19:13:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 08/10] net: mscc: ocelot: register devlink
 ports
Message-ID: <20210111171344.j6chsp5djr5t5ykk@skbuf>
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-9-olteanv@gmail.com>
 <20210109174439.404713f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109174439.404713f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 09, 2021 at 05:44:39PM -0800, Jakub Kicinski wrote:
> On Fri,  8 Jan 2021 19:59:48 +0200 Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Add devlink integration into the mscc_ocelot switchdev driver. Only the
> > probed interfaces are registered with devlink, because for convenience,
> > struct devlink_port was included into struct ocelot_port_private, which
> > is only initialized for the ports that are used.
> > 
> > Since we use devlink_port_type_eth_set to link the devlink port to the
> > net_device, we can as well remove the .ndo_get_phys_port_name and
> > .ndo_get_port_parent_id implementations, since devlink takes care of
> > retrieving the port name and number automatically, once
> > .ndo_get_devlink_port is implemented.
> > 
> > Note that the felix DSA driver is already integrated with devlink by
> > default, since that is a thing that the DSA core takes care of. This is
> > the reason why these devlink stubs were put in ocelot_net.c and not in
> > the common library.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> > diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> > index 2bd2840d88bd..d0d98c6adea8 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_net.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> > @@ -8,6 +8,116 @@
> >  #include "ocelot.h"
> >  #include "ocelot_vcap.h"
> >  
> > +struct ocelot_devlink_private {
> > +	struct ocelot *ocelot;
> > +};
> 
> Why not make struct ocelot part of devlink_priv?

I am not sure what you mean.

> > +static const struct devlink_ops ocelot_devlink_ops = {
> > +};
> > +
> > +static int ocelot_port_devlink_init(struct ocelot *ocelot, int port)
> > +{
> > +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> > +	int id_len = sizeof(ocelot->base_mac);
> > +	struct devlink *dl = ocelot->devlink;
> > +	struct devlink_port_attrs attrs = {};
> > +	struct ocelot_port_private *priv;
> > +	struct devlink_port *dlp;
> > +	int err;
> > +
> > +	if (!ocelot_port)
> > +		return 0;
> > +
> > +	priv = container_of(ocelot_port, struct ocelot_port_private, port);
> > +	dlp = &priv->devlink_port;
> > +
> > +	memcpy(attrs.switch_id.id, &ocelot->base_mac, id_len);
> > +	attrs.switch_id.id_len = id_len;
> > +	attrs.phys.port_number = port;
> > +
> > +	if (priv->dev)
> > +		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
> > +	else
> > +		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
> > +
> > +	devlink_port_attrs_set(dlp, &attrs);
> > +
> > +	err = devlink_port_register(dl, dlp, port);
> > +	if (err)
> > +		return err;
> > +
> > +	if (priv->dev)
> > +		devlink_port_type_eth_set(dlp, priv->dev);
> 
> devlink_port_attrs_set() should be called before netdev is registered,
> and devlink_port_type_eth_set() after. So this sequence makes me a tad
> suspicious.
> 
> In particular IIRC devlink's .ndo_get_phys_port_name depends on it,
> because udev event needs to carry the right info for interface renaming
> to work reliably. No?
> 

If I change the driver's Kconfig from tristate to bool, all is fine,
isn't it?

> > +	return 0;
> > +}
> > +
> > +static void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port)
> > +{
> > +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> > +	struct ocelot_port_private *priv;
> > +	struct devlink_port *dlp;
> > +
> > +	if (!ocelot_port)
> > +		return;
> > +
> > +	priv = container_of(ocelot_port, struct ocelot_port_private, port);
> > +	dlp = &priv->devlink_port;
> > +
> > +	devlink_port_unregister(dlp);
> > +}
> > +
> > +int ocelot_devlink_init(struct ocelot *ocelot)
> > +{
> > +	struct ocelot_devlink_private *dl_priv;
> > +	int port, err;
> > +
> > +	ocelot->devlink = devlink_alloc(&ocelot_devlink_ops, sizeof(*dl_priv));
> > +	if (!ocelot->devlink)
> > +		return -ENOMEM;
> > +	dl_priv = devlink_priv(ocelot->devlink);
> > +	dl_priv->ocelot = ocelot;
> > +
> > +	err = devlink_register(ocelot->devlink, ocelot->dev);
> > +	if (err)
> > +		goto free_devlink;
> > +
> > +	for (port = 0; port < ocelot->num_phys_ports; port++) {
> > +		err = ocelot_port_devlink_init(ocelot, port);
> > +		if (err) {
> > +			while (port-- > 0)
> > +				ocelot_port_devlink_teardown(ocelot, port);
> > +			goto unregister_devlink;
> 
> nit: should this also be on the error path below?
> 
> > +		}
> > +	}
> > +
> > +	return 0;
> > +
> > +unregister_devlink:
> > +	devlink_unregister(ocelot->devlink);
> > +free_devlink:
> > +	devlink_free(ocelot->devlink);
> > +	return err;
> > +}
> 
> > --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > @@ -1293,6 +1293,12 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
> >  		}
> >  	}
> >  
> > +	err = ocelot_devlink_init(ocelot);
> > +	if (err) {
> > +		mscc_ocelot_release_ports(ocelot);
> > +		goto out_ocelot_deinit;
> 
> No need to add ocelot_deinit_timestamp(ocelot); to the error path?

Yes, the error handling could be better.
