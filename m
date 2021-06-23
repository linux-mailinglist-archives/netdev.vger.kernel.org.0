Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754E83B22A1
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFWVok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 17:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWVoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 17:44:39 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD7BC061574;
        Wed, 23 Jun 2021 14:42:21 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id s15so5467247edt.13;
        Wed, 23 Jun 2021 14:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0VC9Ek5ExN6JOEboE9Ozw+f8JeU9+JNx65ZbKxvmGhg=;
        b=ajswzxc6OiQ3iQSIlE0HIGwHl3cbWlZBnIUAbCtOFSf0OrEdKfTg1kSXr0EgzrlTSt
         cjKMWqipPf5+vtAxk0ML26GMjQ72NfI+oiVYW91zk84T4ZHS8EHvBZZ1h/nerGeYlsCm
         OU5Zd+7Y7oF9fDO1Qc+un3BoKdB8l9mU6VMiW58+11nUMNPY0yBboKMHhGkDtaBaLzky
         +4O+WfvW5lwYnqvFBPJ8g3nm4UrqR623j7FPFNe5X8WImKinjaxgF8Z/lDRJYkRk2qv9
         8iuuZ/mtyK2l+7WvlMWTQ4V8cy1y5S5SK+q/aT0xSG6aKOfHYu9sxB6b/jcZUTlYdYB1
         42hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0VC9Ek5ExN6JOEboE9Ozw+f8JeU9+JNx65ZbKxvmGhg=;
        b=VCCGUMvkLbR58dc2xfmP7cCSkfAhZtJvoav1/VhRStEEa6oesnwiXzPrCa+Y7eZjMZ
         V5wILaVGxacvFTArxsGdmmG5yFii//k5MxmbUdQQD+C2u6c3AUMpgn8oaQZBqIvsr13h
         pfrr7oGVJPWPdajl9rukGTQBKh99wKAycfASJd3D/xPWclfWpm7lopwwpz3yXShleXnq
         TdNWaS1nMuJkCqTedQOmxbxITbs91NC9+z0s0xkQLEGesYrQH3wPee4DBZ7l8zt4odQX
         hh/QwOIXQI0itQfUPnT8qAsDYRMj0wcHsji4K41vEWTBhrLceRBRD6w8npkW+BnhwqwI
         bO0A==
X-Gm-Message-State: AOAM533VzvINhqNf5TJwfw1cbpvgl1AgJXMABwWcgOyIajmiqJRSuIZV
        YuBH60KNJAhg7iI25yjORDg=
X-Google-Smtp-Source: ABdhPJxviUA06rWOgoKJnHt1Drevr1ETYlMZZJwbqYE9NBDAs9pJ9GL8OnUD7ASRDAi7UisYCVOANQ==
X-Received: by 2002:a05:6402:501:: with SMTP id m1mr2460727edv.163.1624484540297;
        Wed, 23 Jun 2021 14:42:20 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id a2sm379066ejp.1.2021.06.23.14.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 14:42:19 -0700 (PDT)
Date:   Thu, 24 Jun 2021 00:42:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marcin Wojtas <mw@semihalf.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, jaz@semihalf.com, gjb@semihalf.com,
        upstream@semihalf.com, Samer.El-Haj-Mahmoud@arm.com,
        jon@solid-run.com, tn@semihalf.com, rjw@rjwysocki.net,
        lenb@kernel.org
Subject: Re: [net-next: PATCH v3 1/6] Documentation: ACPI: DSD: describe
 additional MAC configuration
Message-ID: <20210623214218.eaq4uflmxnkbl4dw@skbuf>
References: <20210621173028.3541424-1-mw@semihalf.com>
 <20210621173028.3541424-2-mw@semihalf.com>
 <YNOW+mQNEmSRx/6V@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNOW+mQNEmSRx/6V@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Jun 23, 2021 at 10:18:02PM +0200, Andrew Lunn wrote:
> > +MAC node example with a "fixed-link" subnode.
> > +---------------------------------------------
> > +
> > +.. code-block:: none
> > +
> > +	Scope(\_SB.PP21.ETH1)
> > +	{
> > +	  Name (_DSD, Package () {
> > +	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +		 Package () {
> > +		     Package () {"phy-mode", "sgmii"},
> > +		 },
> > +	    ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
> > +		 Package () {
> > +		     Package () {"fixed-link", "LNK0"}
> > +		 }
> > +	  })
> 
> At least in the DT world, it is pretty unusual to see both fixed-link
> and phy-mode. You might have one of the four RGMII modes, in order to
> set the delays when connecting to a switch. But sgmii and fixed link
> seems very unlikely, how is sgmii autoneg going to work?

SGMII autoneg is supposed to be disabled if you have a fixed-link, and
there is nothing unusual in that kind of setup.
There are 3 types of phylink setups:

MLO_AN_INBAND: there might or might not be a phy-handle, but SGMII
               autoneg should be enabled and the MAC should be
               reconfigured automatically (in hardware) to the right
               speed/duplex based on that
MLO_AN_PHY: there is a phy-handle but SGMII autoneg should be disabled*
            and the MAC should be reconfigured (forced) in software to
            the speed/duplex determined by reading the PHY MDIO
            registers
MLO_AN_FIXED: there is no phy-handle or phy_device, but the driver
              should do the same thing, the speed/duplex is configured
              by management (in this case DT/ACPI)

*there appears to be some debate here, since the "managed" property is
phylink-specific and therefore a phylib driver will not necessarily
disable its in-band autoneg, but this is what the existing phylink_pcs
drivers in drivers/net/pcs/ do and I think there's nothing wrong with
settling on that if phylink is being used. It does create some interesting
questions though when a driver is being converted from phylib to phylink,
since the meaning of the existing firmware bindings suddenly changes.

An SGMII link with MLO_AN_FIXED is nothing unusual, it is in fact very
widespread as a way to reduce pin count compared to the parallel RGMII.
I suspect there are more DSA setups in the field with an SGMII fixed-link
than with RGMII fixed-link, due to practicality.

The 2 characteristic features of SGMII compared to 1000base-X are:
- customization of the 16-bit configuration word communicated via the
  clause 37 state machines. Those are bypassed in MLO_AN_PHY and
  MLO_AN_FIXED modes, true
- symbol replication at 10/100 speeds.

So since it is equally valid to have an SGMII fixed-link at 100Mbps or
10Mbps, it is just as valid to have an SGMII fixed-link at 1Gbps with
in-band autoneg disabled.
