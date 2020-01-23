Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132A1146BC1
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 15:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgAWOu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 09:50:28 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40591 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbgAWOu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 09:50:28 -0500
Received: by mail-pf1-f194.google.com with SMTP id q8so1646905pfh.7
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 06:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1whnJYGOepXNJZRHwatWDt+Dv5wLgMGe8VwAGYBnpLo=;
        b=hDASi5lyOTjpLwme5BJgTC9WWrDy2oIKmaH7DaOExyvxOwdXVWp6IzBUMsCwVcZrYU
         1lYDZDQAgVtupWQBP3ACNcsBDC7A/s/iF0sjReK5T7dp0LaazeEcSkPPa5rP0vuQn1ZH
         dqECqhWDUPZy1LYeyYdYZ0lErgMiwp7yihWrZ5Jo0v3rMPbXlpcY6WeGyDJ3REpuhfdR
         tEhViYO7BxEOt5tRybPBqFWeDNF2jM8512HwbqwebQ+YXiZONg02SVhzTJDLuKYTgTOc
         ktH34tm5C6QQsN50oAgADeYi5ZRDMiTQM6RAGxh0+HAnrbBxCV4ELZU/w+5WGDsUOy9T
         0J6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1whnJYGOepXNJZRHwatWDt+Dv5wLgMGe8VwAGYBnpLo=;
        b=BQepEeLYVWJxAhzSiCGCfPqbF7xoa7Y1PaMJY8BGpkddPQkYtxpl05nB40UI7eT3Z9
         pbF7F4Mt0AjamaviDZAcgrc4tIGUqNYv0+xoLsBCNylIy3ANQSRODh3svKEJHM9LE6Mr
         n6LYvAtfaFNY9u+N0doT3+xZeOKEXyHElsf6ae8YVLur1y+KIfU0Dmuv/l4ZGEMIcKGV
         6U29FmQfDy3UbVmdxBMudg9WbI8ZCkQiHt76jj1McnO5GNaVlhEsHB98u2NgX7RdNTJp
         6R+Tp43fUqg0jV937OPOV+dP2VsDOe+MFFctJJAk2hIpmi2xR8sIrSJd4lOWNFD9Stn2
         VOfg==
X-Gm-Message-State: APjAAAVQmaer5aoHLWM3NLHfOBbenKh3+QmdRRO9maKytV9q8lcP+ZXp
        okN3SBGPc2/j9S+3VGqPzeM=
X-Google-Smtp-Source: APXvYqycD3a8sr8cNlecNvN/bg9ViPkmRFQWNrwdhQvNJ3XkaH53JI1Kh8K24+wbV5Gp5wWpkC4pNg==
X-Received: by 2002:a63:5fce:: with SMTP id t197mr2527634pgb.173.1579791027061;
        Thu, 23 Jan 2020 06:50:27 -0800 (PST)
Received: from martin-VirtualBox ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id a16sm3230351pgb.5.2020.01.23.06.50.25
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 23 Jan 2020 06:50:26 -0800 (PST)
Date:   Thu, 23 Jan 2020 20:20:23 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next v4 1/2] net: UDP tunnel encapsulation module for
Message-ID: <20200123145023.GA6743@martin-VirtualBox>
References: <cover.1579624762.git.martin.varghese@nokia.com>
 <d08b50ebd2f088b099fdaaaac2f9115d6e4dda5c.1579624762.git.martin.varghese@nokia.com>
 <CA+FuTSfK0OxM8X2_n5GJOrYOpaxX6EFm4KW5j+Lzf5QqFp3hSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfK0OxM8X2_n5GJOrYOpaxX6EFm4KW5j+Lzf5QqFp3hSg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 01:29:32PM -0500, Willem de Bruijn wrote:
> On Tue, Jan 21, 2020 at 12:51 PM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > From: Martin Varghese <martin.varghese@nokia.com>
> >
> > The Bareudp tunnel module provides a generic L3 encapsulation
> > tunnelling module for tunnelling different protocols like MPLS,
> > IP,NSH etc inside a UDP tunnel.
> >
> > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> 
> This addresses the main points I raised. A few small points below,
> nothing serious. It could use more eye balls, but beyond those Acked
> from me.
> 
> > ---
> > Changes in v2:
> >      - Fixed documentation errors.
> >      - Converted documentation to rst format.
> >      - Moved ip tunnel rt lookup code to a common location.
> >      - Removed seperate v4 and v6 socket.
> >      - Added call to skb_ensure_writable before updating ethernet header.
> >      - Simplified bareudp_destroy_tunnels as deleting devices under a
> >        namespace is taken care be the default pernet exit code.
> >      - Fixed bareudp_change_mtu.
> >
> > Changes in v3:
> >      - Re-sending the patch again.
> >
> > Changes in v4:
> >      - Converted bareudp device to l3 device.
> 
> I didn't quite get this statement, but it encompasses the change to
> ARPHRD_NONE and introduction of gro_cells, I guess?
> 
> >      - Removed redundant fields in bareudp device.
> 
> > diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
> > index d07d985..ea3d604 100644
> > --- a/Documentation/networking/index.rst
> > +++ b/Documentation/networking/index.rst
> > @@ -33,6 +33,7 @@ Contents:
> >     tls
> >     tls-offload
> >     nfc
> > +   bareudp
> 
> if respinning: this list is mostly alphabetically ordened, perhaps
> insert before batman-adv
> 
> > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > index dee7958..9726447 100644
> > --- a/drivers/net/Kconfig
> > +++ b/drivers/net/Kconfig
> > @@ -258,6 +258,19 @@ config GENEVE
> >           To compile this driver as a module, choose M here: the module
> >           will be called geneve.
> >
> > +config BAREUDP
> > +       tristate "Bare UDP Encapsulation"
> > +       depends on INET && NET_UDP_TUNNEL
> > +       depends on IPV6 || !IPV6
> > +       select NET_IP_TUNNEL
> > +       select GRO_CELLS
> 
> Depends on NET_UDP_TUNNEL plus selects NET_IP_TUNNEL seems odd.
> 
> NET_UDP_TUNNEL itself selects NET_IP_TUNNEL, so perhaps just select
> NET_UDP_TUNNEL.
> 
> I had to make that change to be able to get it in a .config after make
> defconfig.
> 
> 
> > +static int bareudp_change_mtu(struct net_device *dev, int new_mtu)
> > +{
> > +       dev->mtu = new_mtu;
> > +       return 0;
> > +}
> 
> If your ndo_change_mtu does nothing special, it can just rely on the
> assignment in __dev_set_mtu
>
yes.
we could  set dev_set_mtu in all the cases.ignore my previous reply
> > +/* Initialize the device structure. */
> > +static void bareudp_setup(struct net_device *dev)
> > +{
> > +       dev->netdev_ops = &bareudp_netdev_ops;
> > +       dev->needs_free_netdev = true;
> > +       SET_NETDEV_DEVTYPE(dev, &bareudp_type);
> > +       dev->features    |= NETIF_F_SG | NETIF_F_HW_CSUM;
> > +       dev->features    |= NETIF_F_RXCSUM;
> > +       dev->features    |= NETIF_F_GSO_SOFTWARE;
> > +       dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
> > +       dev->hw_features |= NETIF_F_GSO_SOFTWARE;
> > +       dev->hard_header_len = 0;
> > +       dev->addr_len = 0;
> > +       dev->mtu = 1500;
> 
> ETH_DATA_LEN?
