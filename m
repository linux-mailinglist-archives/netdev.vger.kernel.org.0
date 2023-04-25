Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6360D6EDDC8
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbjDYIO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbjDYIO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:14:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B986049FA
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682410447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mgI1o43gyckgzjzYFpcttmorjF8ge3lEz7iYMeO/Rzc=;
        b=dg1QulyB0DAr8vpKxjomiWA6lHgX4azmJ/QMX826TEpXuUNGcZhI5Xl1hjGkCIG3e9Jt5h
        3bt+di/JYEq1n1TT/SbpxlK1PrVffqSLQ4N8tB68g2IHcPj+jHhLSp4er7MDzpLcURP9kF
        7td+vkt4hJTjH8TFBQz8ZaNlNsZDIp0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-sOdXaOE1N_SD9R7YB3Tigw-1; Tue, 25 Apr 2023 04:14:03 -0400
X-MC-Unique: sOdXaOE1N_SD9R7YB3Tigw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D67A811E7C;
        Tue, 25 Apr 2023 08:14:03 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.194.190])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 939872027043;
        Tue, 25 Apr 2023 08:14:02 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 79B22A80CB2; Tue, 25 Apr 2023 10:14:01 +0200 (CEST)
Date:   Tue, 25 Apr 2023 10:14:01 +0200
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: allow ethtool action on PCI
 devices if device is down
Message-ID: <ZEeLyVNgsFmRvour@calimero.vinschen.de>
Mail-Followup-To: Heiner Kallweit <hkallweit1@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
References: <20230331092341.268964-1-vinschen@redhat.com>
 <45c43618-3368-f780-c8bb-68db4ed5760f@gmail.com>
 <ZCqfwxr2I7xt6zon@calimero.vinschen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZCqfwxr2I7xt6zon@calimero.vinschen.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

is that patch still under review or is it refused, given the
current behaviour is not actually incorrect?


Thanks,
Corinna


On Apr  3 11:43, Corinna Vinschen wrote:
> On Mar 31 12:48, Heiner Kallweit wrote:
> > On 31.03.2023 11:23, Corinna Vinschen wrote:
> > > So far stmmac is only able to handle ethtool commands if the device
> > > is UP.  However, PCI devices usually just have to be in the active
> > > state for ethtool commands.
> > > 
> > What do mean with "active state" here? D0? Or, as you say "connected
> > to PCI" a few lines later, do you refer to hot-plugging?
> > 
> > PCI being in D0 often isn't sufficient, especially if interface is down.
> > Then required resources like clocks may be disabled by the driver.
> > 
> > A driver may runtime-suspend a device for multiple reasons, e.g.
> > interface down or link down. Then the device may be put to D3hot
> > to save power.
> > If we say that it's worth to wake a device for an ethtool command,
> > then I wonder whether this is something that should be done in net
> > core. E.g. calling pm_runtime_get_sync() in __dev_ethtool, similar to
> > what we do in __dev_open() to deal with run-time suspended and
> > therefore potentially detached devices.
> 
> Actually, I'm not sure how to reply to your question.  I replicated the
> behaviour of the igb and igc drivers, because that looked like the right
> thing to do for a PCIe device.  It seems a bit awkward that the UP/DOWN
> state allows or denies device settings.  
> 
> 
> Corinna
> 
> 
> 
> > 
> > > Rename stmmac_check_if_running to stmmac_ethtool_begin and add a
> > > stmmac_ethtool_complete action.  Check if the device is connected
> > > to PCI and if so, just make sure the device is active.  Reset it
> > > to idle state as complete action.
> > > 
> > > Tested on Intel Elkhart Lake system.
> > > 
> > > Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> > > ---
> > >  .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 20 +++++++++++++++++--
> > >  1 file changed, 18 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> > > index 35c8dd92d369..5a57970dc06a 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> > > @@ -14,6 +14,7 @@
> > >  #include <linux/mii.h>
> > >  #include <linux/phylink.h>
> > >  #include <linux/net_tstamp.h>
> > > +#include <linux/pm_runtime.h>
> > >  #include <asm/io.h>
> > >  
> > >  #include "stmmac.h"
> > > @@ -429,13 +430,27 @@ static void stmmac_ethtool_setmsglevel(struct net_device *dev, u32 level)
> > >  
> > >  }
> > >  
> > > -static int stmmac_check_if_running(struct net_device *dev)
> > > +static int stmmac_ethtool_begin(struct net_device *dev)
> > >  {
> > > +	struct stmmac_priv *priv = netdev_priv(dev);
> > > +
> > > +	if (priv->plat->pdev) {
> > > +		pm_runtime_get_sync(&priv->plat->pdev->dev);
> > > +		return 0;
> > > +	}
> > >  	if (!netif_running(dev))
> > >  		return -EBUSY;
> > >  	return 0;
> > >  }
> > >  
> > > +static void stmmac_ethtool_complete(struct net_device *dev)
> > > +{
> > > +	struct stmmac_priv *priv = netdev_priv(dev);
> > > +
> > > +	if (priv->plat->pdev)
> > > +		pm_runtime_put(&priv->plat->pdev->dev);
> > > +}
> > > +
> > >  static int stmmac_ethtool_get_regs_len(struct net_device *dev)
> > >  {
> > >  	struct stmmac_priv *priv = netdev_priv(dev);
> > > @@ -1152,7 +1167,8 @@ static int stmmac_set_tunable(struct net_device *dev,
> > >  static const struct ethtool_ops stmmac_ethtool_ops = {
> > >  	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
> > >  				     ETHTOOL_COALESCE_MAX_FRAMES,
> > > -	.begin = stmmac_check_if_running,
> > > +	.begin = stmmac_ethtool_begin,
> > > +	.complete = stmmac_ethtool_complete,
> > >  	.get_drvinfo = stmmac_ethtool_getdrvinfo,
> > >  	.get_msglevel = stmmac_ethtool_getmsglevel,
> > >  	.set_msglevel = stmmac_ethtool_setmsglevel,

