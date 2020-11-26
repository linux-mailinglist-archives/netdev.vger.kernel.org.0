Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FC42C571D
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 15:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390140AbgKZO2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 09:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389951AbgKZO2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 09:28:15 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F0EC0613D4;
        Thu, 26 Nov 2020 06:28:15 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id jx16so2594016ejb.10;
        Thu, 26 Nov 2020 06:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=afHSQLTHLwScibOaB2/Ixwl6R8JNhm0d7lLRx+ngzZo=;
        b=hBXzxrei/MvFB3OISYjM8bBcdmNgJgNyIrWnesu5+fuGb9qsQA0d+J1zQhrNKAQgGi
         J7dFJ3QFk5vpwND9TzdnX+CTz98JXMuGODmkIoPqFxwqOS5eGuejuqVvvt/BLtRDL6SK
         bkMKkmPO396HDIr5e+W6Shpozz+yEVRQW9QQIbQ3l7HwJY/tErY4SiQAgo8LKxv407zW
         tf9ktLeSsXvEefgjioJRwg20AWGagmzO+b1V6+eDNiH76uP3U2la5cqkMTfTfIzOegw/
         HVnsE6n9bkwjcwD28QipzA7L3ndpx8wA7TpoB36D4uIJemG/ImgFIy7w4jaB+0Az1wL3
         OPsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=afHSQLTHLwScibOaB2/Ixwl6R8JNhm0d7lLRx+ngzZo=;
        b=kcz7A7osut5lnNWuqYRU8PfjtvDkCOwRgukWcWo0np0x3RE9Ta1lY4xriIPkzTaR1a
         +kqM4Q9iJFFC9obhjcF886NxL80MqxWtVduzpV6s5p/ISwRa0D/BHDDCpDZdxnGv2HGi
         ubmwTwCq0enkfsowtgO11WG/nocxKZZjBbEJWbp6TCuAPA9gxY6p9XrKYXi7UDH69xUT
         2fCu4VBKYRYODq+dB4jkc3ke73Px5VMj2NxCYkx+VEoO9/MtDdAknCH+qgy80BlxM2oc
         ltKZrlINYXXLUJY2mpHoffei/vXL7fQaHFMT/BWSLR4g1yXckfdOTPZxb1L52iuI6Gvj
         cjcg==
X-Gm-Message-State: AOAM533HDk5RsCyo4LM9tCGrrmVbnLEH6YAkFV0BJgRkDbCvkc4DbbiQ
        +QY7jnNT/RnaroItyLOQNJw=
X-Google-Smtp-Source: ABdhPJy75OQesPPME0B0LOXYXe0Df/KOFzgYzzK1P20HvvMJ1e3kqn/jdRXdxBruBl8tZBQQzVwvig==
X-Received: by 2002:a17:906:2313:: with SMTP id l19mr2939327eja.443.1606400893991;
        Thu, 26 Nov 2020 06:28:13 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id dk14sm3145765ejb.97.2020.11.26.06.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 06:28:13 -0800 (PST)
Date:   Thu, 26 Nov 2020 16:28:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] dsa: add support for Arrow XRS700x tag
 trailer
Message-ID: <20201126142812.4jr3kskwqf76cx5d@skbuf>
References: <20201125193740.36825-1-george.mccollister@gmail.com>
 <20201125193740.36825-2-george.mccollister@gmail.com>
 <20201125203429.GF2073444@lunn.ch>
 <20201126135004.aq2lruz5kxptmsvl@skbuf>
 <20201126140126.GL2075216@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126140126.GL2075216@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 03:01:26PM +0100, Andrew Lunn wrote:
> On Thu, Nov 26, 2020 at 03:50:04PM +0200, Vladimir Oltean wrote:
> > On Wed, Nov 25, 2020 at 09:34:29PM +0100, Andrew Lunn wrote:
> > > > +static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev,
> > > > +				   struct packet_type *pt)
> > > > +{
> > > > +	int source_port;
> > > > +	u8 *trailer;
> > > > +
> > > > +	if (skb_linearize(skb))
> > > > +		return NULL;
> > >
> > > Something for Vladimir:
> > >
> > > Could this linearise be moved into the core, depending on the
> > > tail_tag?
> > 
> > Honestly I believe that the skb_linearize is not needed at all.
> 
> Humm
> 
> I'm assuming this is here in case the frame is in fragments, and the
> trailer could be spread over two fragments? If so, you cannot access
> the trailer using straight pointers. Linearize should copy it into one
> buffer.
> 
> For the normal case of a 1500 byte frame, i doubt we have hardware
> which uses multiple scatter/gather buffers. But for jumbo frames?

In this particular case, I don't think that one byte can be in multiple
fragments at once, unless it is a quantum byte. So skb_linearize should
still be removed.

Are you saying that we should do something like this? I would need to
performance-test it:

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index a1b1dc8a4d87..4c2065bec8d5 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -212,6 +212,13 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (!skb)
 		return 0;
 
+	if (cpu_dp->tag_ops->tail_tag && cpu_dp->tag_ops->overhead > 1) {
+		if (unlikely(skb_linearize(skb))) {
+			dev_kfree_skb_any(skb);
+			return 0;
+		}
+	}
+
 	nskb = cpu_dp->rcv(skb, dev, pt);
 	if (!nskb) {
 		kfree_skb(skb);

Also, since we are now finally touching the cacheline with tag_ops,
maybe we could remove the copy of rcv() from struct dsa_port? Although
there is a chance that this might destabilize things and could need a
bit of tweaking to get right.

> > > > +	if (pskb_trim_rcsum(skb, skb->len - 1))
> > > > +		return NULL;
> > >
> > > And the overhead is also in dsa_devlink_ops, so maybe this can be
> > > moved as well?
> > 
> > Sorry, I don't understand this comment.
> 
> I'm meaning, could that also be moved into the core? We seem to have
> the needed information to do it in the core.

Ok, I got confused by the devlink reference.
Currently the tag is always stripped by the tagger driver, because there
are 3 cases:
- tag is before Ethernet MAC DA
- tag is before Ethernet Type
- tag is before FCS
We do not have a way to distinguish between cases 1 and 2 such that DSA
could strip the tag in all cases and provide a uniform interface to all
types of taggers.
