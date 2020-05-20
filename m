Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5451DB566
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgETNnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:43:55 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:60529 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726443AbgETNny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:43:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 93F705808EA;
        Wed, 20 May 2020 09:43:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 20 May 2020 09:43:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=e+eMsg
        yG+LcgBAs/MoVcHL8ZAHYBWt7V364UQT0ClkU=; b=kNGEGIHPbZus+C5FZxC9WB
        1DdB1rRZwdEThJVp5dpxpKTkiR13SaP10o9CoZd/h66f6+r7evzSbtChlIzrLdId
        otubpaL7W5XiQJ4EVBT0ZcfHgrEZUYO3GYyDg3LbNRgr21iPn7nKp/igagahWMZS
        /fDUrb0+9/KFFMncew1UHjdxpQzTmgvr6cY3b0Ge52lvc7ao+VS7QrTbHsQWvQG1
        NcgfGEDvpfYVbNO9AI5Nabvoe2b1NjetuECD0/eO0c9Qa4qVGdLkPSvH+FOXIYUe
        R55nj6KgsoxT+sXVGL0YpEn2XvITMo6UUY38DsI3EeNxKUD3rtuEitd4twmJ/QUQ
        ==
X-ME-Sender: <xms:FTTFXgmz8ssprT5lYdqW8PXrv9U68ID8Rrx2rKqgXM4Czzig8IIwGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtledgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeejhedufeelkeefveekieeiieeffeetjeeigeduveeikedvteeileekgffhgfel
    vdenucffohhmrghinhepmhgvlhhlrghnohigrdgtohhmnecukfhppeejledrudejiedrvd
    egrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:FTTFXv1scgV5KNmBEf750lJYsJxW5jjEhDBh9QPenx48FH6kdBDuPw>
    <xmx:FTTFXuoNQPaKOTOgU7MHXghoQm-W4tMKOd2qf590jN8bRoWsl9kPHw>
    <xmx:FTTFXsmUYWrhsapmKUqs6nxWPg1-iH4wziddIG0YlKo5ZtD5_hP49A>
    <xmx:FzTFXrs9pjswbsrodlPcOG_u-pYLg536OU4xOIVqqmXI7-7JkrteHQ>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2E4D23280060;
        Wed, 20 May 2020 09:43:48 -0400 (EDT)
Date:   Wed, 20 May 2020 16:43:40 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, danieller@mellanox.com, mlxsw@mellanox.com,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, snelson@pensando.io,
        drivers@pensando.io, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/3] selftests: net: Add port split test
Message-ID: <20200520134340.GA1050786@splinter>
References: <20200519134032.1006765-1-idosch@idosch.org>
 <20200519134032.1006765-4-idosch@idosch.org>
 <20200519141541.GJ624248@lunn.ch>
 <20200519185642.GA1016583@splinter>
 <20200519193306.GB652285@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519193306.GB652285@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 09:33:06PM +0200, Andrew Lunn wrote:
> > It's basically the number of lanes
> 
> Then why not call it lanes? It makes it clearer how this maps to the
> hardware?

I'm not against it. We discussed it and decided to go with width. Jiri /
Danielle, are you OK with changing to lanes?

> 
> > > Is it well defined that all splits of the for 2, 4, 8 have to be
> > > supported?
> > 
> > That I don't actually know. It is true for Mellanox and I can only
> > assume it holds for other vendors. So far beside mlxsw only nfp
> > implemented port_split() callback. I see it has this check:
> > 
> > ```
> >         if (eth_port.is_split || eth_port.port_lanes % count) {
> >                 ret = -EINVAL;
> >                 goto out;
> >         }
> > ```
> > 
> > So it seems to be consistent with mlxsw. Jakub will hopefully chime in
> > and keep me honest.
> > 
> > > Must all 40Gbps ports with a width of 4, be splitable to 2x
> > > 20Mps? It seems like some hardware might only allow 4x 10G?
> > 
> > Possible. There are many vendor-specific quirks in this area, as I'm
> > sure you know :)
> 
> So this makes me wonder if the API is sufficient. Do we actually want
> to enumerate what is possible, rather than leave the user to guess,
> trial and error?

The API is merely a read-only number which represents the number of
lanes. It's useful on its own without relation to split because it
allows you to debug issues such as "why port X does not support speed
Y". I actually wrote an ugly drgn script to pull this info from mlxsw
once:

```
#!/usr/bin/env drgn

import drgn
from drgn.helpers.linux import list_first_entry

devlink = list_first_entry(prog['devlink_list'].address_of_(),
                           'struct devlink', 'list')
mlxsw_core = drgn.reinterpret(prog.type("struct mlxsw_core"), devlink.priv)
mlxsw_sp = drgn.reinterpret(prog.type("struct mlxsw_sp"),
                            mlxsw_core.driver_priv)

max_ports = mlxsw_core.max_ports.value_() - 1
for i in range(0, max_ports):
    if mlxsw_sp.ports[i].value_() == 0:
        continue

    print("local_port=%d module=%d width=%d" %
          (mlxsw_sp.ports[i].local_port.value_(),
          mlxsw_sp.ports[i].mapping.module.value_(),
          mlxsw_sp.ports[i].mapping.width.value_()))
```

> 
> > I assume you're asking because you are trying to see if the test is not
> > making some vendor-specific assumptions?
> 
> Not just the test, but also the API itself. Is the API generic enough?
> Should we actually be able to indicate a 40G port cannot be used as 2x
> 20G? But 4x 10G is O.K?

We can do it, but I prefer to wait with new uAPI until we actually see a
need for it. We currently only expose width/lanes which is useful on its
own and infer from it how a port can be split. If this assumption turns
out to be wrong, we can add new attributes to answer the questions you
posed.

> The PDF you gave a link to actually says nothing about 2x 50G, or 2x
> 20G. There is a cable which does support 2x 50G. Does the firmware do
> any sanity checking and return errors if you ask it to do something
> which does not make sense with the cable currently inserted in the
> SFP cage?

Wait, I linked to a 4x splitter, not to 2x. This is a 2x:
https://www.mellanox.com/related-docs/prod_cables/PB_MCP7H00-G0xxxxxxx_100GbE_QSFP28_to_2x50GbE_2xQSFP28_DAC_Splitter.pdf

Complete list is here:
https://www.mellanox.com/products/interconnect/ethernet-copper-splitter

The firmware does not really care if it's a split or not. Software just
maps {module, width/lanes} -> local_port where each local_port is
represented by a netdev.

The supported speeds are set according to the width/lanes of the port.
If you requested a speed that is not supported or cannot be handled by
the cable you are using, then you will not be able to negotiate a link,
but it's the same regardless if the port is split or not.
