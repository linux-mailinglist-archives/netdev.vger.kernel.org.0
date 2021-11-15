Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7B3452854
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 04:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238974AbhKPDSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 22:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbhKPDR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 22:17:56 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1607C043193;
        Mon, 15 Nov 2021 15:45:49 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r11so15423913edd.9;
        Mon, 15 Nov 2021 15:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hvMLW+1fEeSE2j4ofzxMa1EFtQorNCxPN7SvY+4csoQ=;
        b=iv/0b7C/mWXCvUCEKp/92nOuVFKckxb0xiPZ67bOdd4NUtyUGGhup6AKkft3GFSmRK
         aVjIL5jH0GAtBT+TZGkq1+lMmFL/boYhhZdkjvhiqPHk7XOgcPEEDwLQgHfus8hnYVvn
         jjfh36TfcFd6rSOpHjMIfVCKpoUGUBnl5Blo3rOgEJj1Gf73pWHqmoEajU+AYFsDsP5M
         o5kOzWKuUud71BDjruRpyQ4SeyGy+/t1iJ+OBZK/huSIl1WqkIT/NDogj5Lc/0V8+b8x
         zoq5iaAuabEBNXwt+XhCFCckujRIux6yN/HTjmM0+tihskuTdKBlbK3ziOk5B2druSjK
         XD+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hvMLW+1fEeSE2j4ofzxMa1EFtQorNCxPN7SvY+4csoQ=;
        b=N+HgoeGbxXo11DKlO9++LE/w/FUrVLV9ylMUYth28EsKC5u2R6s8QRHFBrULSH/5BH
         dIwkllobljgIFjv6189j/5IPp8XCmQhqU7TwJZm6fK+fm43YFs/KoDJjw4vKVDK7BkH0
         PqoSR20F6WyWeyoJeQcTqQcgftlSbq634ARTYA3109fHk5PiC2rkM7w5CI0S/0Jm+dlh
         Nn2zDnwvOBrRQjFfhKfmU7snFGbcgvXeyUpNMDZdilUQevPRrmgw3qMyHTyEIsE1i8jN
         4dUTSRyQma+I9aXzhH58tiAxBXehEU6wxLGrvaDtuniqRBNCkuB5fn7QQt3fpTJvpPs1
         xJVg==
X-Gm-Message-State: AOAM530hVWLGXNqMjbSdcIWyQuKQ9uwP5HV6xgmSmNVEGqszgjE76sPw
        R3XY9E+2pz/g8U60CpLtBLdYyacsLPk=
X-Google-Smtp-Source: ABdhPJwyuMzphOXOmMTNF+MeDQ7TxDrz0zy1e2htZhRB5s1OvI6bL9HaIJqHA0H+iBAvpwdbVa1EVA==
X-Received: by 2002:a17:906:3745:: with SMTP id e5mr3750975ejc.400.1637019948132;
        Mon, 15 Nov 2021 15:45:48 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id qf8sm7280490ejc.8.2021.11.15.15.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 15:45:47 -0800 (PST)
Date:   Tue, 16 Nov 2021 01:45:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next] net: dsa: microchip: implement multi-bridge
 support
Message-ID: <20211115234546.spi7hz2fsxddn4dz@skbuf>
References: <20211108111034.2735339-1-o.rempel@pengutronix.de>
 <20211110123640.z5hub3nv37dypa6m@skbuf>
 <20211112075823.GJ12195@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211112075823.GJ12195@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 08:58:23AM +0100, Oleksij Rempel wrote:
> On Wed, Nov 10, 2021 at 02:36:40PM +0200, Vladimir Oltean wrote:
> > On Mon, Nov 08, 2021 at 12:10:34PM +0100, Oleksij Rempel wrote:
> > > Current driver version is able to handle only one bridge at time.
> > > Configuring two bridges on two different ports would end up shorting this
> > > bridges by HW. To reproduce it:
> > > 
> > > 	ip l a name br0 type bridge
> > > 	ip l a name br1 type bridge
> > > 	ip l s dev br0 up
> > > 	ip l s dev br1 up
> > > 	ip l s lan1 master br0
> > > 	ip l s dev lan1 up
> > > 	ip l s lan2 master br1
> > > 	ip l s dev lan2 up
> > > 
> > > 	Ping on lan1 and get response on lan2, which should not happen.
> > > 
> > > This happened, because current driver version is storing one global "Port VLAN
> > > Membership" and applying it to all ports which are members of any
> > > bridge.
> > > To solve this issue, we need to handle each port separately.
> > > 
> > > This patch is dropping the global port member storage and calculating
> > > membership dynamically depending on STP state and bridge participation.
> > > 
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > ---
> > 
> > Because there wasn't any restriction in the driver against multiple
> > bridges, I would be tempted to send to the "net" tree and provide a
> > Fixes: tag.
> 
> This patch looks too intrusive to me. It will be hard to backport it to
> older versions. How about have two patches: add limit to one bridge for
> net and add support for multiple bridges for net-next?

That would work.

> > > +	dp = dsa_to_port(ds, port);
> > > +
> > > +	for (i = 0; i < ds->num_ports; i++) {
> > > +		const struct dsa_port *dpi = dsa_to_port(ds, i);
> > 
> > Other drivers name this "other_dp", I don't think that name is too bad.
> > Also, you can use "dsa_switch_for_each_user_port", which is also more
> > efficient, although you can't if you target 'stable' with this change,
> > since it has been introduced rather recently.
> 
> ok
> 
> > > +		struct ksz_port *pi = &dev->ports[i];
> > 
> > and this could be "other_p" rather than "pi".
> 
> ok
> 
> > > +		u8 val = 0;
> > > +
> > > +		if (!dsa_is_user_port(ds, i))
> > >  			continue;
> > > -		p = &dev->ports[i];
> > > -		if (!(dev->member & (1 << i)))
> > > +		if (port == i)
> > >  			continue;
> > > +		if (!dp->bridge_dev || dp->bridge_dev != dpi->bridge_dev)
> > > +			continue;
> > > +
> > > +		pi = &dev->ports[i];
> > > +		if (pi->stp_state != BR_STATE_DISABLED)
> > > +			val |= BIT(dsa_upstream_port(ds, i));
> > >  
> > 
> > This is saying:
> > For each {user port, other port} pair, if the other port isn't DISABLED,
> > then allow the user port to forward towards the CPU port of the other port.
> > What sense does that make? You don't support multiple CPU ports, so this
> > port's CPU port is that port's CPU port, and you have one more (broken)
> > forwarding rule towards the CPU port below.
> 
> Ok, understand.
> 
> > > -		/* Port is a member of the bridge and is forwarding. */
> > > -		if (p->stp_state == BR_STATE_FORWARDING &&
> > > -		    p->member != dev->member)
> > > -			dev->dev_ops->cfg_port_member(dev, i, dev->member);
> > > +		if (pi->stp_state == BR_STATE_FORWARDING &&
> > > +		    p->stp_state == BR_STATE_FORWARDING) {
> > > +			val |= BIT(port);
> > > +			port_member |= BIT(i);
> > > +		}
> > > +
> > > +		dev->dev_ops->cfg_port_member(dev, i, val);
> > >  	}
> > > +
> > > +	if (p->stp_state != BR_STATE_DISABLED)
> > > +		port_member |= BIT(dsa_upstream_port(ds, port));
> > 
> > Why != DISABLED? I expect that dev_ops->cfg_port_member() affects only
> > data packet forwarding, not control packet forwarding, right?
> 
> No. According to the KSZ9477S datasheet:
> "The processor should program the “Static MAC Table” with the entries that it
> needs to receive (for example, BPDU packets). The “overriding” bit should be set
> so that the switch will forward those specific packets to the processor. The
> processor may send packets to the port(s) in this state. Address learning is
> disabled on the port in this state."
> 
> This part is not implemented.
> 
> In current driver implementation (before or after this patch), all
> packets are forwarded. It looks like, current STP implementation in this driver
> is not complete. If I create a loop, the bridge will permanently toggle one of
> ports between blocking and listening. 
> 
> Currently I do not know how to proceed with it. Remove stp callback and
> make proper, straightforward bride_join/leave? Implement common soft STP
> for all switches without HW STP support?

What does "soft STP" mean? You need to have a port state in which data
plane packets are blocked, but BPDUs can pass. Unless you trap all
packets to the CPU and make the selection in software (therefore,
including the forwarding, I don't know if that is so desirable), you
don't have much of a choice except to do what you've said above, program
the static MAC table with entries for 01-80-c2-00-00-0x which trap those
link-local multicast addresses to the CPU and set the STP state override
bit for them and for them only.

BTW, see the "bridge link set" section in "man bridge" for a list of
what you should do in each STP state.
