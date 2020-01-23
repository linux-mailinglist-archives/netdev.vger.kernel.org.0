Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 423F614653A
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 10:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgAWJ7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 04:59:16 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46459 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgAWJ7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 04:59:16 -0500
Received: by mail-pf1-f195.google.com with SMTP id n9so1284201pff.13
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 01:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z8ZWSHcUTzslDxY5hj3lTCOu9WUB9+TBnVQFyBBpbvA=;
        b=QnJnFyUgNG0Jdpn3IUQbCEXfe6GMGfY42hK7+F8NDVYw9w/kxZ3RC7IJ5alWMdNRzo
         eoybJDnZCSPY9nWolu6XP+J1jTIZ8sPuhD/y8aJaKRo/koXhQ91qx9iG1+J4g7bGvLz9
         43pCYvQ8WhXYhlOLQAurVQuKSv8kLPFhJ6HSEbjMUZAi+Ku78AuTsF+FMQh1JtWehhry
         Ug3YUe6nNEEc1DKzMD5H9bgdXO13paViVolL5fiW6KCynLBnkzeCiutE8kczSKJQWAgK
         8VXfiEM9E7NWk6gcRUGckwWDqu7jBOrq2vFbidiVEXv3KlSpKab4aQGxx0ybzaZHbSjm
         +TAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=z8ZWSHcUTzslDxY5hj3lTCOu9WUB9+TBnVQFyBBpbvA=;
        b=h744UjHWDrOjvoKZAcYXT8iL0BKsD5MgNXsF+BmDcFCBix1a7/JN/F5usyxO2fsZ04
         41QkdcC4Tl88ynbq9WaHH3eUofMoi8JU6VPsoLvSUl4gJbUEqXDoLByE/FeUa3iClM0A
         48MQ8Y903K9M+czVOTDoJpQIPIMjkG2lEHcfw94pE7YdCwPGH0qy1SduJcbfx+YHs9PW
         PC0L8376Cok+0X+h5Vs3pwoCf47ZvROHcAG2Cj4vbFQZMBacpF4QwcvMVABhBG8sCumx
         sPbETcXKGeZVJ6DO8ypUyycw0MdbBmVazk0DEtvJlmnUiVi6D4+1pm6yAIcgBIX1W8ES
         7YeA==
X-Gm-Message-State: APjAAAUK43OCbMOI3cVC2DUoTg9dpziW7sVBvEkkBvkBq3OAPIvI2M2u
        H7uS3sPguVfk4jxGl/dSD1oLNpWI
X-Google-Smtp-Source: APXvYqyl0rMtMUtfWSze4Jc+hsDowl5SLV08y/Y1NRZw2fPifX5xBuSMPLo7HdyR1eV6cdS/t1MSgg==
X-Received: by 2002:aa7:991e:: with SMTP id z30mr6538903pff.259.1579773555127;
        Thu, 23 Jan 2020 01:59:15 -0800 (PST)
Received: from martin-VirtualBox ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id m15sm2104835pgi.91.2020.01.23.01.59.14
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 23 Jan 2020 01:59:14 -0800 (PST)
Date:   Thu, 23 Jan 2020 15:29:11 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next v4 1/2] net: UDP tunnel encapsulation module for
Message-ID: <20200123095911.GA6331@martin-VirtualBox>
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
The term l3 device is from OVS may be.What i meant is we no longer
needed the dummy ethernet header and the device works with l3 packet.
 
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
Noted
> > +static int bareudp_change_mtu(struct net_device *dev, int new_mtu)
> > +{
> > +       dev->mtu = new_mtu;
> > +       return 0;
> > +}
> 
> If your ndo_change_mtu does nothing special, it can just rely on the
> assignment in __dev_set_mtu
> 
Yes we could remove the ndo_change_mtu implementation as it is redundant
But i would like to retain bareudp_change_mtu and also to add a validation 
code in the function as no validation is done in the rtnetlink layer during newlink create

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
Noted

Thanks for your time.The code look really better from the v1 version.
