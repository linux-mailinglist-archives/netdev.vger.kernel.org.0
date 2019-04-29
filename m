Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A897E810
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 18:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfD2Qpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 12:45:41 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:33551 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728629AbfD2Qpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 12:45:40 -0400
Received: by mail-yw1-f66.google.com with SMTP id q11so3954003ywb.0;
        Mon, 29 Apr 2019 09:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g1Yba+QgALlemKiNnIFJPcJGdSg5qg6+Ws/obYqZr2s=;
        b=vG2JaxvrLJn69v0XTXrXGlmN7IJahwJEOOqEOu+kB3/39GuWdeiYXPiHPidkJII8At
         7RoI+VAoMqr1UNqDPAzhaUIEMu74at7sr1iZ3DAUjdDa6hQ5yiocFV6yGmZWdcrRqc7u
         +YWqYlKEua2bWFGRJBHOPzynYB0unnK+aSDzHsE7zgA/vxKIlJ/3ofJNX6I43nFto35L
         OQfDM3zmImtw3raJOjTCZZ7cayzEOCpLyr3z2xopByyrjVJ9J9R8QH4SBrKvJQkgP+IC
         O4nZP7P8TzzQLNDS08vMLbh+sIZEBE4HfgWr3bjtxHV7WCJFV2u/Mc6MrVPBrMc1sRFx
         gl6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g1Yba+QgALlemKiNnIFJPcJGdSg5qg6+Ws/obYqZr2s=;
        b=CXjkWAO6v0P+9YFK2iJuNe3m+KwMZktaCbP6tcP4TDO1LbXg8UgChboUEoCeVbMFR+
         8FrVAs9WByH0+X5RwGgG+Rau/Xv9b5zNuuuFJAvEFK7Cc44KuOubRuFsM6JMXLHw4+dA
         hLdlZSeLu/RlNgkXb2FVHSJPd0dbDSh3rBBvNg8k5C7yjq9rhuCoVLpqzcXGJQkuVgRQ
         4iAQoAA2pomPqyyNFVzoq4kseBehVUrUaMGYtAO+rWOvneTNCf/qGa0gmbaklt0NYRK3
         nXsgnshUE35NSBcGe/XKpvEldwYVToBjNzbvsH3Wp1eoTKJDcG/UI+gXdSAmPVc6DCqk
         CdJg==
X-Gm-Message-State: APjAAAVj8Coiy+9x0n8YzwSiUlpCpVkmpC5R1Exx4hhVNOzdPw4+qiOj
        SjM+8zMgAwJF9MMlTvlUreRpLr2SEFg7QkXXwv01/r8AAf8=
X-Google-Smtp-Source: APXvYqzByaqDq/lpvzDC/2ukc1ZkxWus1THiiXBmzPw+9WYzGRKw4P0GFUHrZKBL20xJMVCBqIp0HNOj15fNiQoBZow=
X-Received: by 2002:a81:b653:: with SMTP id h19mr41969960ywk.253.1556556339615;
 Mon, 29 Apr 2019 09:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190429060107.10245-1-zajec5@gmail.com> <20190429092027.6013677d@hermes.lan>
In-Reply-To: <20190429092027.6013677d@hermes.lan>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Mon, 29 Apr 2019 18:45:28 +0200
Message-ID: <CACna6rykbCkYjoTDP7wumBYVbHkQBCKBfZEq1-fWFrVTC==QNg@mail.gmail.com>
Subject: Re: [PATCH] net-sysfs: expose IRQ number
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Apr 2019 at 18:20, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Mon, 29 Apr 2019 08:01:07 +0200
> Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
>
> > From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >
> > Knowing IRQ number makes e.g. reading /proc/interrupts much simpler.
> > It's more reliable than guessing device name used by a driver when
> > calling request_irq().
> >
> > Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> > ---
> > I found a script parsing /proc/interrupts for a given interface name. I=
t wasn't
> > working for me as it assumed request_irq() was called with a device nam=
e. It's
> > not a case for all drivers.
> >
> > I also found some other people looking for a proper solution for that:
> > https://unix.stackexchange.com/questions/275075/programmatically-determ=
ine-the-irqs-associated-with-a-network-interface
> > https://stackoverflow.com/questions/7516984/retrieving-irq-number-of-a-=
nic
> >
> > Let me know if this solution makes sense. I can say it works for me ;)
> > ---
> >  Documentation/ABI/testing/sysfs-class-net |  7 +++++++
> >  net/core/net-sysfs.c                      | 16 ++++++++++++++++
> >  2 files changed, 23 insertions(+)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/=
ABI/testing/sysfs-class-net
> > index 664a8f6a634f..33440fe77ca7 100644
> > --- a/Documentation/ABI/testing/sysfs-class-net
> > +++ b/Documentation/ABI/testing/sysfs-class-net
> > @@ -301,3 +301,10 @@ Contact: netdev@vger.kernel.org
> >  Description:
> >               32-bit unsigned integer counting the number of times the =
link has
> >               been down
> > +
> > +What:                /sys/class/net/<iface>/irq
> > +Date:                April 2019
> > +KernelVersion:       5.2
> > +Contact:     netdev@vger.kernel.org
> > +Description:
> > +             IRQ number used by device
> > diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> > index e4fd68389d6f..a3eb7c3f1f37 100644
> > --- a/net/core/net-sysfs.c
> > +++ b/net/core/net-sysfs.c
> > @@ -512,6 +512,21 @@ static ssize_t phys_switch_id_show(struct device *=
dev,
> >  }
> >  static DEVICE_ATTR_RO(phys_switch_id);
> >
> > +static ssize_t irq_show(struct device *dev, struct device_attribute *a=
ttr,
> > +                     char *buf)
> > +{
> > +     const struct net_device *netdev =3D to_net_dev(dev);
> > +     ssize_t ret;
> > +
> > +     if (!rtnl_trylock())
> > +             return restart_syscall();
> > +     ret =3D sprintf(buf, "%d\n", netdev->irq);
> > +     rtnl_unlock();
> > +
> > +     return ret;
> > +}
> > +static DEVICE_ATTR_RO(irq);
> > +
> >  static struct attribute *net_class_attrs[] __ro_after_init =3D {
> >       &dev_attr_netdev_group.attr,
> >       &dev_attr_type.attr,
> > @@ -542,6 +557,7 @@ static struct attribute *net_class_attrs[] __ro_aft=
er_init =3D {
> >       &dev_attr_proto_down.attr,
> >       &dev_attr_carrier_up_count.attr,
> >       &dev_attr_carrier_down_count.attr,
> > +     &dev_attr_irq.attr,
> >       NULL,
> >  };
> >  ATTRIBUTE_GROUPS(net_class);
>
> Can't you find this on the PCI side already?
> $ ls /sys/class/net/eno1/device/msi_irqs/
> 37  38  39  40  41

I'm dealing with bgmac supported ethernet device on bcma bus (not
PCI). I could make bcma bus provide IRQ numbers, but I thought
something at net subsystem level will be more generic.

I'm going to review Willem's solution/idea for now.

--=20
Rafa=C5=82
