Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CA51B280A
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgDUNfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728519AbgDUNfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 09:35:51 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1816EC061A10;
        Tue, 21 Apr 2020 06:35:51 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id k22so5897154eds.6;
        Tue, 21 Apr 2020 06:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BLQDNAuvH+mmBxzp8zXWscwYeRoxDbrIpyjNqdhp4xc=;
        b=Ksnc7upICOS18e31lHFtJIN5mjX4AClAiqKIZQ8MBdQmyanG7D7U9cAY4iDhRgvWBQ
         7pDx4iqEtXXnYZe6hHmTDPC8MnTBYgo4CeTY/lBvrFey7iJGJ2yBU7LtMkM5VSvkTHyA
         afXf0abexFyZdZ3PkOtsSvmWavBatjq0bL/zgDWSbzDIjPk/biyk9XODFHW2k6clICqf
         ss6UhIh4gXSAttrenyaeSFY+p2Ig3vtMPIvEz5JwUPSSLDIJ+F2OKWviIosWdCt2nXGU
         r0TES0pPBzqpRzsRHr7VbHK2epK6W+ET2t4T/2pCfMfVr45/3XdeHxlPZUAuutcxBN9L
         tuQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BLQDNAuvH+mmBxzp8zXWscwYeRoxDbrIpyjNqdhp4xc=;
        b=CvjC7odOixSEB6hxyMVuMMd7ixKvfEaNxjRsI64dEuOUf0vhibNieVgWnqomyqwmtG
         RzHTWexjQET94/5pYHCz5f+mw99I51qVPxLBdmc7yPaYJkRMlxoXixGxz/UzLmT0O+kj
         uXuUkTNG0lWt44gpp1JRsc+BrUBNcfAH4CF3KiJMjZ2U4BkY8ERc3rBpXV/2meFc8WpX
         s2Qz5i9gHLCcmNAaBJdNiZ+92xOXAAiFpLIPdbZp7ZfDITbHFwjqVQH9kKZHCafqz5UX
         NN/SPpUg93Xa/+sAnAikvYQbadWycX/Wd2L8t0+BBAcSwl/XsRTpszQeGQIw7XAUdbT/
         RLQg==
X-Gm-Message-State: AGi0PuZv+BqmHpcY4C6wkgPpsJ3vE/PNk/jOeVNJqYcAbO5zAcaXNUn8
        PAF+yRoiFF1dS4KfzNQm0U3E4DDrUTXW6J9j3h0=
X-Google-Smtp-Source: APiQypJ2dyJzCOGH+eeAPWl1+OLIkd+h4bnkMfY2KVb5ffM8FvTAPOhLIxcv86n3se/TxUsI3Gei07wBFoyHqUw3xlY=
X-Received: by 2002:a50:f288:: with SMTP id f8mr14096159edm.337.1587476149783;
 Tue, 21 Apr 2020 06:35:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200421113324.vxh2lyasylf5kgkz@pengutronix.de>
 <CA+h21ho2YnUfzMja1Y7=B7Yrqk=WD6jm-OoKKzX4uS3WJiU5aw@mail.gmail.com>
 <20200421125828.jb44qzfzgd7sh436@pengutronix.de> <20200421132732.GC937199@lunn.ch>
In-Reply-To: <20200421132732.GC937199@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 21 Apr 2020 16:35:40 +0300
Message-ID: <CA+h21hoH4u4TGMPPGpuF9dgW5SHd3DYm4mR8AMmuVs=nevYSYg@mail.gmail.com>
Subject: Re: dsa: sja1105: regression after patch: "net: dsa: configure the
 MTU for switch ports"
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, mkl@pengutronix.de,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        David Jander <david@protonic.nl>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Apr 2020 at 16:27, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > The code which is causing problems seems to be this one:
> > >
> > >     mtu_limit = min_t(int, master->max_mtu, dev->max_mtu);
> > >     old_master_mtu = master->mtu;
> > >     new_master_mtu = largest_mtu + cpu_dp->tag_ops->overhead;
> > >     if (new_master_mtu > mtu_limit)
> > >         return -ERANGE;
> > >
> > > called from
> > >
> > >     rtnl_lock();
> > >     ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
> > >     rtnl_unlock();
> > >     if (ret && ret != -EOPNOTSUPP) {
> > >         dev_err(ds->dev, "error %d setting MTU on port %d\n",
> > >             ret, port->index);
> > >         goto out_free;
> > >     }
> > >
> > > Before this patch, it was silently failing, now it's preventing the
> > > probing of the ports which I might agree with you is not better.
> > > Andrew warned about this, and I guess that during probe, we should
> > > warn but ignore any nonzero return code, not just EOPNOTSUPP. I'll
> > > send a patch out shortly to correct this.
> > >
> > > Out of curiosity, what DSA master port do you have? Does it not
> > > support an MTU of 1504 bytes? Does MTU-sized traffic pass correctly
> > > through your interface? (you can test with iperf3)
> >
> > It is FEC@iMX6QP attached to the port 4 of the sja1105 switch.
> > I'll try to make some tests tomorrow.
>
> Ah, interesting. I've been testing recently on a Vybrid, so also
> FEC. I had the warning, but it kept going.
>
> I don't particularly like this warning in this case. We have hardware
> which happy works, but is now issuing a warning on boot. I would
> prefer if it warned when only trying to configure an MTU bigger than
> the minimum needed for DSA, i.e. only the jumbo use case.
>
>     Andrew

Looks like FEC is one of those drivers that don't touch
netdev->max_mtu. So I sent a patch to reduce your switch MTU to 1496
or whereabouts. About the error, I caved in and turned it into an
warning, but with the new logic of limiting the MTU on bootup to the
limit given by the master there is really no reason to fail now, so I
think we shouldn't remove the print.

Thanks,
-Vladimir
