Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7D2456816
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbhKSCcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbhKSCcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:32:11 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C546BC061574;
        Thu, 18 Nov 2021 18:29:10 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id r11so35969244edd.9;
        Thu, 18 Nov 2021 18:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=aG2Yj59nIaRzrSClFOXtJKgWrhU22xZoqjGdW6CQ8kU=;
        b=ZidQeL6Fp6gdmIm+mXIaymrLbrbA9uTJau1C+Kvmzx5QEE8wH8H7817zbQVOVhdMgm
         muClmtk+p5MmtaWWZBZ8JWCCinXDTl4Md12PhVDKNd8DJaKCccSjX2t131dQBv9KAoam
         Cp63JwR4+HBCk7JsJtNqqHRg8aJ4zMyLS6aCI0aleNLqsXVjdWh5uyguMHmsb5IcYa7Y
         u/rfQUyBpEENoRk97umQRSBBRqt/hamA1aEfdIim9+1awEKpl/NP+LW34Eq7/YjlV5B4
         U1kcVlKhw1HGX7BXGDsaNxM84TiCfM+NNqSDR1DoAHSEZYhb08Lh7xZOs9cVdrG0y6lV
         mV7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=aG2Yj59nIaRzrSClFOXtJKgWrhU22xZoqjGdW6CQ8kU=;
        b=YyMiPGkgEYALqFlaqiJHJVZ5E6zDmS6mE3pcfdBp7jbr60S0G7CXy17S35LKVCThO0
         LWjR/DfYTt92kTgMyOCp8EwZBR4K+uwU2beufXSdmlvqElGw1TiC/g6wyULiQ0G5k+3z
         DARql6QVcxg/sqc7MIDeXynYNYSVwaYTIeyvVohohv70J9OIzcEqR6eJXIvBDD93cgTV
         oHBQZWHwKRM/lmYxUQIKeRZrKfeYwGVqRU7AiBh5p3o6B4Rf98jut4gjZ7Jd3Z8r+nPp
         Ial0GJ4gh4WnG4zveEMxM5RU+qrGBzFUCTlxF1dQilP9GmXEI3O3AyJ2CLFAvfWM7vFJ
         ZGjQ==
X-Gm-Message-State: AOAM531AuSDJD6aCNEpsJFLlEuV1Zoi4yufZTaYrqTD5lYvdPcRmQ+F0
        +tFHvKLvou8GrPIksyWe6MLtz1B/MeM=
X-Google-Smtp-Source: ABdhPJwQmQMw6GD0Reo7mdpt8C6rGS6emF0zhBHLQCFCuwhVyXYgrnwGE0lXP426txoK5xsLf8FLmg==
X-Received: by 2002:a17:907:7d88:: with SMTP id oz8mr3022651ejc.173.1637288949314;
        Thu, 18 Nov 2021 18:29:09 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id q7sm781727edr.9.2021.11.18.18.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:29:09 -0800 (PST)
Message-ID: <61970bf5.1c69fb81.6852b.3a87@mx.google.com>
X-Google-Original-Message-ID: <YZcL4FpHFZw7gRJb@Ansuel-xps.>
Date:   Fri, 19 Nov 2021 03:28:48 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 16/19] net: dsa: qca8k: enable
 mtu_enforcement_ingress
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-17-ansuelsmth@gmail.com>
 <20211119022008.d6nnf4aqnvkaykk3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119022008.d6nnf4aqnvkaykk3@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 04:20:08AM +0200, Vladimir Oltean wrote:
> On Wed, Nov 17, 2021 at 10:04:48PM +0100, Ansuel Smith wrote:
> > qca8k have a global MTU. Inform DSA of this as the change MTU port
> > function checks the max MTU across all port and sets the max value
> > anyway as this switch doesn't support per port MTU.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index c3234988aabf..cae58753bb1f 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -1315,6 +1315,9 @@ qca8k_setup(struct dsa_switch *ds)
> >  	/* Set max number of LAGs supported */
> >  	ds->num_lag_ids = QCA8K_NUM_LAGS;
> >  
> > +	/* Global MTU. Inform dsa that per port MTU is not supported */
> > +	ds->mtu_enforcement_ingress = true;
> > +
> >  	return 0;
> >  }
> >  
> > -- 
> > 2.32.0
> > 
> 
> This doesn't do what you think it does. If you want the dev->mtu of all
> interfaces to get updated at once, you need to do that yourself. Setting
> ds->mtu_enforcement_ingress will only update the MTU for ports belonging
> to the same bridge, and for a different reason. Or I'm missing the
> reason why you're making this change now.

Got confused by the Documentation. Just to confirm in DSA we don't have
a way to handle the case where we have one MTU reg that is applied to
every port, correct?

We already handle this by checking the max MTU set to all port in the
port_change_mtu but I was searching a cleaner way to handle this as
currently we use an array to store the MTU of all port and seems a bit
hacky and a waste of space. 

-- 
	Ansuel
