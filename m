Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F35952BE86
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 07:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfE1FRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 01:17:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43627 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfE1FRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 01:17:53 -0400
Received: by mail-pf1-f195.google.com with SMTP id c6so10706825pfa.10;
        Mon, 27 May 2019 22:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mKaPfFoMgZ6osRPfuPIOP5JhdlSjCFeF1t4XR4tTYHI=;
        b=hnICLvwD/M457vOxbo8q1yDL1dnwaUsid/QN2S3YXwveLha0EGo86s7GpUiQsdUj6o
         N6+KtEZ8mX4tpc+Q+mqGmkTlllRA1RiP/zwYdHJqy6hVfC13ONdxRqewXQypaYadIZnJ
         S4zwgskyd2atId1PWZ5FFZE0B5IIxq/B7yLQTvTQE9S1infjgFYeeUGrdStBvyEIBSxs
         uBLBDkY0WUKkVM0GsYAyq8BmIDaKEkGx8sQNxzk/DlP8GeiwSFD5SXR5ylh7xE+pqCt5
         7v5DQvL6ZkmBPCeEtGIcbgbOOqMbv66ZLUIeLjLavNrzdGqdKwVO0Kl8MBy38QNdLZz4
         dyBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mKaPfFoMgZ6osRPfuPIOP5JhdlSjCFeF1t4XR4tTYHI=;
        b=lJWzJ0I/Cx2t7u+Pa7IgPeGWcEnJvZnCToXsrcWRkkqnna0Gh0zF6P8RdpQwTz9qKH
         6NCESNeKH8+KyvtMe814Tgo8qXJ86bkqRbk1zdo4/g1AUpNPNLP1CbQT3F/lG/Jckxo0
         /oaGlO15rI3uKcXSqpZy2h7m7bQbxdGca84zwpf5Yo+V7oHTlmlsYGfgVR7YPM7DHBAX
         vFgZUZoYz2uI1TBMYKIQloomEdtC4eklXE5z2D7qJlSHZE18jt6CM/Y8QcJ4jpqeTuUG
         Pp1m53/dXV48Flby8mf3Ih+oDU2fY8j6YL/BP1g7mu07RjYxKLhjBCXrKVIH8i2+U3Jb
         RUEA==
X-Gm-Message-State: APjAAAV9rl3NlcxXqaRVG9ZmdNUQoLvt4dL4FUz4FDsL5zhwzQniYZtI
        1N0LpvSK+HKvR5FjmyfchBc=
X-Google-Smtp-Source: APXvYqzciIaRUcWOzvOoSbGNsmIRqCUNjbjR2WztgFRVBuSusyc+TzYbb6dzdyham9P2o7zatU4Bfw==
X-Received: by 2002:a62:5306:: with SMTP id h6mr40384218pfb.29.1559020673137;
        Mon, 27 May 2019 22:17:53 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id h123sm13675852pfe.80.2019.05.27.22.17.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 22:17:52 -0700 (PDT)
Date:   Mon, 27 May 2019 22:17:50 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V3 net-next 2/6] net: Introduce a new MII time stamping
 interface.
Message-ID: <20190528051750.ub4urccdwmkg2u3c@localhost>
References: <20190521224723.6116-3-richardcochran@gmail.com>
 <20190522005823.GD6577@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522005823.GD6577@lunn.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 02:58:23AM +0200, Andrew Lunn wrote:
> > -static int dp83640_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
> > +static int dp83640_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
> >  {
> > -	struct dp83640_private *dp83640 = phydev->priv;
> > +	struct dp83640_private *dp83640 =
> > +		container_of(mii_ts, struct dp83640_private, mii_ts);
> >  	struct hwtstamp_config cfg;
> >  	u16 txcfg0, rxcfg0;
> 
> Hi Richard
> 
> David might complain about reverse christmas tree. Maybe define a
> macro, to_dp83640() which takes mii_ts?

That is nice idea for another series, I think.  For now this matches
the existing 'container_of' usage within the driver.
 
> > +/**
> > + * struct mii_timestamper - Callback interface to MII time stamping devices.
> > + *
> > + * @rxtstamp:	Requests a Rx timestamp for 'skb'.  If the skb is accepted,
> > + *		the MII time stamping device promises to deliver it using
> > + *		netif_rx() as soon as a timestamp becomes available. One of
> > + *		the PTP_CLASS_ values is passed in 'type'.  The function
> > + *		must return true if the skb is accepted for delivery.
> > + *
> > + * @txtstamp:	Requests a Tx timestamp for 'skb'.  The MII time stamping
> > + *		device promises to deliver it using skb_complete_tx_timestamp()
> > + *		as soon as a timestamp becomes available. One of the PTP_CLASS_
> > + *		values is passed in 'type'.
> > + *
> > + * @hwtstamp:	Handles SIOCSHWTSTAMP ioctl for hardware time stamping.
> > + * @link_state:	Allows the device to respond to changes in the link state.
> > + * @ts_info:	Handles ethtool queries for hardware time stamping.
> > + *
> > + * Drivers for PHY time stamping devices should embed their
> > + * mii_timestamper within a private structure, obtaining a reference
> > + * to it using container_of().
> > + */
> 
> I wonder if it is worth mentioning that link_state() is called with
> the phy lock held, but none of the others are?

Will do.

Thanks,
Richard
