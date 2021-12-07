Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B814046C7FB
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 00:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238180AbhLGXIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 18:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238150AbhLGXIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 18:08:46 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA1FC061574;
        Tue,  7 Dec 2021 15:05:15 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id j140-20020a1c2392000000b003399ae48f58so2890865wmj.5;
        Tue, 07 Dec 2021 15:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=daT0BRDRC5WhA1yaih6/jyrYlJJtWyQd9d5tZI5Lpqw=;
        b=Cc51MmOVkKzHPu9rIIIy3/afv7cjzxca/DoylPsojJhjV4aySiPob3b/5VG53IvAfC
         0wjxbr9Q+XmCE+YrxChrbRNZF7VjXqINbyepW4CVCmS6+kO3RxltC/VFDvTq3BIXVPPz
         SQBljUdc0ZTihmXPVC4M10IJuWXGV2pgrlRURPMGkD3+la7DlhBVBhhkL5eGaDktPwwZ
         BnMrnNLD+c+j0+HHQUilz67vIqP5iRhQZ22or7L90wu/fQ956Ulmlt0CLi/tJitExtip
         IdVs4AsU3+lkhF6Hmn6+NWrYz7oyb7wpR9sFZiZVGIi05N5r0GEYmY9Hm30Y/Or2I3Aw
         WhdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=daT0BRDRC5WhA1yaih6/jyrYlJJtWyQd9d5tZI5Lpqw=;
        b=hdhlyD1TOBH7N1gL1b4RirlDtZqZU7Rd77/Nf/30ijZuB0BhjarM7CkwCbURoBllXl
         K8cYZhz+Dple+mhfpX0MjDur56AHTSdKYdyg7xmjTw2BGb0aIVnNF2nALY2KaMPusbC8
         UDZn2qkwilttd/bwFqQWWCs1ir73jEsem7v2yslU1rQHlTt8SrD995Y9BLHE6zZhUv0J
         Xe9NiOLKbJnc2KaoBwG4N8Ux1axBNSmeMOFyaHV6UUzB8YcwDCg67uYsuJ0lcdPA+TtB
         R263LQPJTQH1iTRxy50xz0oEuY44Pt8uko8aKr5/IqRilDVx2Y5tQR3dJtshFTZToL0J
         Sw0w==
X-Gm-Message-State: AOAM530dHxu/sRZyxV8J8LbUbO7ipGUc/5lEZLVliOPsxXw8E65DtjdD
        lxEpCJ7wG+oFVbsCks9nhew=
X-Google-Smtp-Source: ABdhPJwfTn93GsBbFV3BLkJZQcqdTUsCQqfv72kAbzwTlGAYD1nR7qwL4CKjDIh4RTVPyhX/4JulUA==
X-Received: by 2002:a1c:1bd8:: with SMTP id b207mr10934553wmb.114.1638918313387;
        Tue, 07 Dec 2021 15:05:13 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id l11sm985336wrp.61.2021.12.07.15.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 15:05:13 -0800 (PST)
Message-ID: <61afe8a9.1c69fb81.897ba.6022@mx.google.com>
X-Google-Original-Message-ID: <Ya/op2cIvOZaLYFN@Ansuel-xps.>
Date:   Wed, 8 Dec 2021 00:05:11 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <20211207224525.ckdn66tpfba5gm5z@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207224525.ckdn66tpfba5gm5z@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 12:45:25AM +0200, Vladimir Oltean wrote:
> On Tue, Dec 07, 2021 at 10:47:59PM +0100, Ansuel Smith wrote:
> > The main problem here is that we really need a way to have shared data
> > between tagger and dsa driver. I also think that it would be limiting
> > using this only for mdio. For example qca8k can autocast mib with
> > Ethernet port and that would be another feature that the tagger would
> > handle.
> 
> This is cool. I suppose this is what QCA_HDR_RECV_TYPE_MIB is for.

Exactly that.

> But it wouldn't work with your design because the tagger doesn't hold
> any queues, it is basically a request/response which is always initiated
> by the switch driver. The hardware can't automatically push anything to
> software on its own. Maybe if the tagger wouldn't be stateless, that
> would be better? What if the qca8k switch driver would just provide some
> function pointers to the switch driver (these would be protocol
> sub-handlers for QCA_HDR_RECV_TYPE_MIB, QCA_HDR_RECV_TYPE_RW_REG_ACK
> etc), and your completion structure would be both initialized, as well
> as finalized, all from within the switch driver itself?
> 

Hm. Interesting idea. So qca8k would provide the way to parse the packet
and made the request. The tagger would just detect the packet and
execute the dedicated function.
About mib considering the driver autocast counter for every port and
every packet have the relevant port to it (set in the qca tag), the
idea was to put a big array and directly write the data. The ethtool
function will then just read the data and report it. (or even work
directly on the ethtool data array).

> > I like the idea of tagger-owend per-switch-tree private data.
> > Do we really need to hook logic?
> > Wonder if something like that would work:
> > 1. Each tagger declare size of his private data (if any).
> > 2. Change tag dsa helper make sure the privata data in dst gets
> >    allocated and freed.
> > 3. We create some helper to get the tagger private data pointer that
> >    dsa driver will use. (an error is returned if no data is present)
> > 4. Tagger will use the dst to access his own data.
> 
> I considered a simplified form like this, but I think the tagger private
> data will still stay in dp->priv, only its ownership will change.
> It is less flexible to just have an autoalloc size. Ok, you allocate a
> structure the size you need, but which dp->priv gets to have it?
> Maybe a certain tagging protocol will need dp1->priv == dp2->priv ==
> dp3->priv == ..., whereas a different tagging protocol will need unique
> different structures for each dp.
> 
> > 
> > In theory that way we should be able to make a ""connection"" between
> > dsa driver and the tagger and prevent any sort of strange stuff that
> > could result in bug/kernel panic.
> > 
> > I mean for the current task (mdio in ethernet packet) we just need to
> > put data, send the skb and wait for a response (and after parsing) get
> > the data from a response skb.
> 
> It would be a huge win IMO if we could avoid managing the lifetime of
> dp->priv _directly_. I'm thinking something along the lines of:
> 
> - every time we make the "dst->tag_ops = tag_ops;" assignment (see dsa2.c)
>   there is a connection event between the switch tree and the tagging
>   protocol (and also a disconnection event, if dst->tag_ops wasn't
>   previously NULL).
> 
> - we could add a new tag_ops->connect(dst) and tag_ops->disconnect(dst)
>   and call them. These could allocate/free the dp->priv memory for each
>   dp in &dst->ports.
> 
> - _after_ the tag_ops->connect() has been called (this makes sure that
>   the tagger memory has been allocated) we could also emit a cross-chip
>   notifier event:
> 
> 	/* DSA_NOTIFIER_TAG_PROTO_CONNECT */
> 	struct dsa_notifier_tag_proto_connect_info {
> 		const struct dsa_device_ops *tag_ops;
> 	};
> 
> 	struct dsa_notifier_tag_proto_connect_info info;
> 
> 	dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO, &info);
> 
>   The role of a cross-chip notifier is to fan-out a call exactly once to
>   every switch within a tree. This particular cross-chip notifier could
>   end up with an implementation in switch.c that lands with a call to:
> 
>   ds->ops->tag_proto_connect(ds, tag_ops);
> 
>   At this point, I'm a bit fuzzy on the details. I'm thinking of
>   something like this:
> 
> 	struct qca8k_tagger_private {
> 		void (*rw_reg_ack_handler)(struct dsa_port *dp, void *buf);
> 		void (*mib_autocast_handler)(struct dsa_port *dp, void *buf);
> 	};
> 
> 	static void qca8k_rw_reg_ack_handler(struct dsa_port *dp, void *buf)
> 	{
> 		... (code moved from tagger)
> 	}
> 
> 	static void qca8k_mib_autocast_handler(struct dsa_port *dp, void *buf)
> 	{
> 		... (code moved from tagger)
> 	}
> 
> 	static int qca8k_tag_proto_connect(struct dsa_switch *ds,
> 					   const struct dsa_device_ops *tag_ops)
> 	{
> 		switch (tag_ops->proto) {
> 		case DSA_TAG_PROTO_QCA:
> 			struct dsa_port *dp;
> 
> 			dsa_switch_for_each_port(dp, ds) {
> 				struct qca8k_tagger_private *priv = dp->priv;
> 
> 				priv->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
> 				priv->mib_autocast_handler = qca8k_mib_autocast_handler;
> 			}
> 
> 			break;
> 		default:
> 			return -EOPNOTSUPP;
> 		}
> 	}
> 
> 	static const struct dsa_switch_ops qca8k_switch_ops = {
> 		...
> 		.tag_proto_connect	= qca8k_tag_proto_connect,
> 	};
> 
>   My current idea is maybe not ideal and a bit fuzzy, because the switch
>   driver would need to be aware of the fact that the tagger private data
>   is in dp->priv, and some code in one folder needs to be in sync with
>   some code in another folder. But at least it should be safer this way,
>   because we are in more control over the exact connection that's being
>   made.
> 
> - to avoid leaking memory, we also need to patch dsa_tree_put() to issue
>   a disconnect event on unbind.
> 
> - the tagging protocol driver would always need to NULL-check the
>   function pointer before dereferencing it, because it may connect to a
>   switch driver that doesn't set them up (dsa_loop):
> 
> 	struct qca8k_tagger_private *priv = dp->priv;
> 
> 	if (priv->rw_reg_ack_handler)
> 		priv->rw_reg_ack_handler(dp, skb_mac_header(skb));

Ok so your idea is to make the driver the one controlling ""everything""
and keep the tagger as dummy as possible. That would also remove all the
need to put stuff in the global include dir. Looks complex but handy. We
still need to understand the state part. Any hint about that?

In the mean time I will try implement this.

-- 
	Ansuel
