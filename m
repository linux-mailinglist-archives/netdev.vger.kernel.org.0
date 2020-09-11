Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0952655EC
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 02:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgIKADp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 20:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgIKADl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 20:03:41 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54483C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 17:03:41 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id t16so8166008edw.7
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 17:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=NeSdp/fg3QXvMyZnmr5BWmlJC/yw0O/4Iec7N7cFJjQ=;
        b=QU9kDEg/gO8rm2qoGaMZ/Cp4JLVeWXHsAYn9zjLYZFFSAbfpvzS59bv/MVBnVhjCB+
         P1vTaoVOVBRNeJzRNSHDDVfn6Gtr1Naz5Sz2jcs67xHkgHca45KGo4lKanQ44Zjzj2NE
         UYOxor4KrJ0ecCa7Pi1cZLPjgwV++EXRFxoW+ecV/sqKfs/5T246nEYkad3J3Gaz9hVE
         47Ey4rU/j6nxT9iWCQevVC2SjkyDiE9I8JF0ciBv/58StzHjoGShMB5bV/olCD+cXmjl
         07fzGUKRJ9m08fRDPEJUvzNAOcr/9vTKerID8FYDKz3/ie1mcgv7e8QcDgmbFDwLPhky
         vBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NeSdp/fg3QXvMyZnmr5BWmlJC/yw0O/4Iec7N7cFJjQ=;
        b=pnEbNgXoQT0zLemSrT2y9luhhcQUDxbP/irZ7m1QI1H75KsbcdjwHYbrSXVinUU7rR
         Gw2qoBonXQmimNMZpshbQFVXfumTlbDlZbtbv6FLLFHcuZWeQOCfUPiEO8xkX2jcyYDV
         j1hVT9b3ttez92xOQK+av/3x7qgydZKLXJe/b4xlMxvr9nquLdRx7XuFH2DSAD7zzEU2
         EMEzvkmwGowRHncOQmIG+yScoT+nBkQitR8oPQW3E2cqx7+QZqgyyASxEF3utNLq/R57
         WVxPcDbzZN45eabNpap+8V9sc3ilpc7RBHSoViAZwO62WLD5paeDjD7QuIzbrsR5iBw/
         MBLw==
X-Gm-Message-State: AOAM530cuQc+ku43VgIjEzPNSqMxl2FquWjEEP2B2f1emjKii67JE3Ej
        3sXOBoqG7kVgmhD57p7ChFE=
X-Google-Smtp-Source: ABdhPJzH62Mij9tAmO9j1ZJvdsq9sYkoJbjeHTbMsbGC6VSFbLty36cFuAw7PUMyA+epG3t/Z/5gdg==
X-Received: by 2002:a50:aa94:: with SMTP id q20mr11740982edc.119.1599782619801;
        Thu, 10 Sep 2020 17:03:39 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id t12sm329131edy.61.2020.09.10.17.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 17:03:39 -0700 (PDT)
Date:   Fri, 11 Sep 2020 03:03:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <20200911000337.htwr366ng3nc3a7d@skbuf>
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-5-olteanv@gmail.com>
 <961ac1bd-6744-23ef-046f-4b7d8c4413a4@gmail.com>
 <a5e6cb01-88d0-a479-3262-b53dec0682cd@gmail.com>
 <f0217ae5-7897-17e2-a807-fc0ba0246c74@gmail.com>
 <20200909163105.nynkw5jvwqapzx2z@skbuf>
 <11268219-286d-7daf-9f4e-50bdc6466469@gmail.com>
 <20200909175325.bshts3hl537xtz2q@skbuf>
 <5edf3aa2-c417-e708-b259-7235de7bc8d2@gmail.com>
 <7e45b733-de6a-67c8-2e28-30a5ba84f544@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e45b733-de6a-67c8-2e28-30a5ba84f544@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 02:58:04PM -0700, Florian Fainelli wrote:
> On 9/9/2020 11:34 AM, Florian Fainelli wrote:
> > On 9/9/2020 10:53 AM, Vladimir Oltean wrote:
> > > On Wed, Sep 09, 2020 at 10:22:42AM -0700, Florian Fainelli wrote:
> > > > How do you make sure that the CPU port sees the frame untagged
> > > > which would
> > > > be necessary for a VLAN-unaware bridge? Do you have a special remapping
> > > > rule?
> > >
> > > No, I don't have any remapping rules that would be relevant here.
> > > Why would the frames need to be necessarily untagged for a VLAN-unaware
> > > bridge, why is it a problem if they aren't?
> > >
> > > bool br_allowed_ingress(const struct net_bridge *br,
> > >             struct net_bridge_vlan_group *vg, struct sk_buff *skb,
> > >             u16 *vid, u8 *state)
> > > {
> > >     /* If VLAN filtering is disabled on the bridge, all packets are
> > >      * permitted.
> > >      */
> > >     if (!br_opt_get(br, BROPT_VLAN_ENABLED)) {
> > >         BR_INPUT_SKB_CB(skb)->vlan_filtered = false;
> > >         return true;
> > >     }
> > >
> > >     return __allowed_ingress(br, vg, skb, vid, state);
> > > }
> > >
> > > If I have a VLAN on a bridged switch port where the bridge is not
> > > filtering, I have an 8021q upper of the bridge with that VLAN ID.
> >
> > Yes that is the key right there, you need an 8021q upper to pop the VLAN
> > ID or push it, that is another thing that users need to be aware of
> > which is a bit awkward, most expect things to just work. Maybe we should
> > just refuse to have bridge devices that are not VLAN-aware, because this
> > is just too cumbersome to deal with.
>
> With the drivers that you currently maintain and with the CPU port being
> always tagged in the VLANs added to the user-facing ports, when you are
> using a non-VLAN aware bridge, do you systematically add an br0.1 upper
> 802.1Q device to pop/push the VLAN tag?

Talking to you, I realized that I confused you uselessly. But in doing
that, I actually cleared up a couple of things for myself. So thanks, I
guess?

This is actually a great question, and it gave me the opportunity to
reflect.  So, only 1 driver that I maintain has the logic of always
marking the CPU port as egress-tagged. And that would be ocelot/felix.

I need to give you a bit of background.
The DSA mode of Ocelot switches is more of an afterthought, and I am
saying this because there is a distinction I need to make between the
"CPU port module" (which is a set of queues that the CPU can inject and
extract frames from), and the "NPI port" (which is an operating mode,
where a regular front-panel Ethernet port is connected internally to the
CPU port module and injection/extraction I/O can therefore be done via
Ethernet, and that's your DSA).
Basically, when the NPI mode is in use, then it behaves less like an
Ethernet port, and more like a set of CPU queues that connect over
Ethernet, if that makes sense.
The port settings for VLAN are bypassed, and the packet is copied as-is
from ingress to the NPI port. The egress-tagged port VLAN configuration
does not actually result in a VLAN header being pushed into the frame,
if that egress port is the NPI port.  Instead, the classified VLAN ID
(i.e. derived from the packet, or from the port-based VLAN, or from
custom VLAN classification TCAM rules) is always kept in a 12-bit field
of the Extraction Frame Header.

Currently I am ignoring the classified VLAN from the Extraction Frame
Header, and simply passing the skb as-is to the stack. As-is, meaning as
the switch ingress port had received it. So, in retrospect, my patch
183be6f967fe ("net: dsa: felix: send VLANs on CPU port as
egress-tagged") is nothing more than a formality to make this piece of
code shut up and not error out:

static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
				       u16 vid)
{
	struct ocelot_port *ocelot_port = ocelot->ports[port];
	u32 val = 0;

	if (ocelot_port->vid != vid) {
		/* Always permit deleting the native VLAN (vid = 0) */
		if (ocelot_port->vid && vid) {
			dev_err(ocelot->dev,
				"Port already has a native VLAN: %d\n",
				ocelot_port->vid);
			return -EBUSY;
		}
		ocelot_port->vid = vid;
	}

It's just now that I connected the dots and realized that.

So, looks like I don't really know what it's like to always have a
tagged skb on ingress, even for egress-tagged VLANs. It must suck, I
guess?

I think if I were in that situation, and the source port would be under
a vlan_filtering=0 bridge, then I would simply pop the tag from the skb
in the DSA rcv function, for all VLANs that I don't have an 8021q upper
for.

Explaining this, it makes a lot of sense to do what Vitesse / Microsemi
/ Microchip is doing, which is to copy the frame as-is to the CPU, and
to also tell you, separately, what the classified VLAN is. For example,
in vlan_filtering=0 mode, the classified VLAN will always be 1,
regardless of how the frame is tagged, because VLAN awareness is truly
turned off for the ingress port, and the port-based VLAN is always used.
In this way, you have the most flexibility: you can either ignore the
classified VLAN and proceed with just what was in the ingress skb (this
way, you'll have a switch that is not VLAN-unaware, just "checking" as
opposed to "secure". It has passed the ingress VLAN filter, but you
still remember what the VLAN ID was.
Or you can have a completely VLAN-unaware switch, if you pop all VLANs
that you can find in the skb, and add a hwaccel tag based on the
classified VLAN, if it isn't equal to the pvid of the port. This is
great for things like compatibility with a vlan_filtering=0 upper bridge
which is what we're talking about.

Basically, this is what, I think, DSA tries to emulate with the rule of
copying the flags of a user port VLAN to the CPU port too. If we had the
API to request an "unmodified" VLAN (not egress-tagged, not
egress-untagged, just the same as on ingress), I'm sure we'd be using
that by default (useful when vlan_filtering is 1). Knowing what the
classified VLAN was also can be very useful at times (like when
vlan_filtering is 0), so if there was an API for that, I'm sure DSA
would have used that as well. With no such APIs, we can only use
approximations.

> I am about ready to submit the changes we discussed to b53, but I am still a
> bit uncomfortable with this part of the change because it will make the CPU
> port follow the untagged attribute of an user-facing port.
>
> @@ -1444,7 +1427,7 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
>                         untagged = true;
>
>                 vl->members |= BIT(port);
> -               if (untagged && !dsa_is_cpu_port(ds, port))
> +               if (untagged)
>                         vl->untag |= BIT(port);
>                 else
>                         vl->untag &= ~BIT(port);
> @@ -1482,7 +1465,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
>                 if (pvid == vid)
>                         pvid = b53_default_pvid(dev);
>
> -               if (untagged && !dsa_is_cpu_port(ds, port))
> +               if (untagged)
>                         vl->untag &= ~(BIT(port));
>

Which is ok, I believe? I mean, that's the default DSA logic. If you
think that isn't ok, we should change it at a more fundamental level.
What we've been discussing so far is akin to your current setup, not
to the one you're planning to change to, isn't it? Are there any
problems with the new setup?

Cheers,
-Vladimir
