Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9607446C978
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 01:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhLHAqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 19:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhLHAqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 19:46:43 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44222C061574;
        Tue,  7 Dec 2021 16:43:12 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id d9so1142152wrw.4;
        Tue, 07 Dec 2021 16:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=rNVsWOs9u9ywd9rpfX+xxCh7W3ttJ/TcFfD+ZIoOpHk=;
        b=qwTpv2akm4lVbsEdLpK/gYppyWuUY6ur5FoWBswrI3F9J59H92DsV4UHdiwXP+K5Aj
         +u0sx0QMLfHgcsCiqotPZwV41mzgcKTan92grdMAiRZV0iHroVktNMqU2kE45pUIdg++
         l9WVKJLrIiv+HxeMWv5Mwu9FQpi1w57VzgPRcgjTiP/Qpk4E5Hk8S38HhEHQok9ADWS/
         HQLTlLJYKZyhFoxdV2webn4u298AjgY95drVo4zs5SjWGsOmPnFC47npdSY1PO2mMLp8
         vT+DKHLi0WDLiQ7On+/rMOwHoFC4mmzoXC5XBa9qSxyY+/fECrA4DpcJcwyO7Mvhj/z6
         FQxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=rNVsWOs9u9ywd9rpfX+xxCh7W3ttJ/TcFfD+ZIoOpHk=;
        b=6xqm9htfWMTvarjwkjxJubFd2OlXRjWE2COdsmMZyaoL1To92T4wFS8cynMGTAnUuc
         jVIK+oZmXW8a8wqhoCldhbZmpoksUWnEK+Fj0xMOIJkuV7kwFNzVGlSStczt5fpUDvDH
         rAYl36NX/sq6AGUULbzxj9YuQefyncxlyRajVVheGn9VRuO9H5m4dwc20COR04bt73vq
         u5g1CJ9brSNdt9uEyTRiyUK/JNiXjHY2P5waPC6sHLPI/TLKxRP0HlFceGBfP1dtkaaN
         QPMAHFrCwqth4ts+lu8glWXXmqUGWYwP1RVd8tLVYo3eCLFF1flJswglHa4aIHKDa6mQ
         saiA==
X-Gm-Message-State: AOAM531T5I2PBxQGiju/kLhxj9wHb+ntbFHbvQtBd+bGevKw9glvyq9Q
        p3L1zmCkI7vQhVqI/T1Ip0Q=
X-Google-Smtp-Source: ABdhPJyGQvsdmG/3JfatcpWn9T4XwA0kxyf/jM+I293ioERC+FPeSNEsc6JSm7VAVtRqKfDtaKqK0A==
X-Received: by 2002:a5d:53c9:: with SMTP id a9mr53037241wrw.119.1638924190622;
        Tue, 07 Dec 2021 16:43:10 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id q4sm1156123wrs.56.2021.12.07.16.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 16:43:10 -0800 (PST)
Message-ID: <61afff9e.1c69fb81.92f07.6e7d@mx.google.com>
X-Google-Original-Message-ID: <Ya//k194fhulC57w@Ansuel-xps.>
Date:   Wed, 8 Dec 2021 01:42:59 +0100
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
References: <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <Ya/esX+GTet9PM+D@lunn.ch>
 <20211207234736.vpqurmattqx4a76h@skbuf>
 <20211208000432.5nq47bjz3aqjvilp@skbuf>
 <20211208004051.bx5u7rnpxxt2yqwc@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208004051.bx5u7rnpxxt2yqwc@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 02:40:51AM +0200, Vladimir Oltean wrote:
> On Wed, Dec 08, 2021 at 02:04:32AM +0200, Vladimir Oltean wrote:
> > On Wed, Dec 08, 2021 at 01:47:36AM +0200, Vladimir Oltean wrote:
> > > > 2) is harder. But as far as i know, we have an 1:N setup.  One switch
> > > > driver can use N tag drivers. So we need the switch driver to be sure
> > > > the tag driver is what it expects. We keep the shared state in the tag
> > > > driver, so it always has valid data, but when the switch driver wants
> > > > to get a pointer to it, it needs to pass a enum dsa_tag_protocol and
> > > > if it does not match, the core should return -EINVAL or similar.
> > > 
> > > In my proposal, the tagger will allocate the memory from its side of the
> > > ->connect() call. So regardless of whether the switch driver side
> > > connects or not, the memory inside dp->priv is there for the tagger to
> > > use. The switch can access it or it can ignore it.
> > 
> > I don't think I actually said something useful here.
> > 
> > The goal would be to minimize use of dp->priv inside the switch driver,
> > outside of the actual ->connect() / ->disconnect() calls.
> > For example, in the felix driver which supports two tagging protocol
> > drivers, I think these two methods would be enough, and they would
> > replace the current felix_port_setup_tagger_data() and
> > felix_port_teardown_tagger_data() calls.
> > 
> > An additional benefit would be that in ->connect() and ->disconnect() we
> > get the actual tagging protocol in use. Currently the felix driver lacks
> > there, because felix_port_setup_tagger_data() just sets dp->priv up
> > unconditionally for the ocelot-8021q tagging protocol (luckily the
> > normal ocelot tagger doesn't need dp->priv).
> > 
> > In sja1105 the story is a bit longer, but I believe that can also be
> > cleaned up to stay within the confines of ->connect()/->disconnect().
> > 
> > So I guess we just need to be careful and push back against dubious use
> > during review.
> 
> I've started working on a prototype for converting sja1105 to this model.
> It should be clearer to me by tomorrow whether there is anything missing
> from this proposal.

I'm working on your suggestion and I should be able to post another RFC
this night if all works correctly with my switch.

-- 
	Ansuel
