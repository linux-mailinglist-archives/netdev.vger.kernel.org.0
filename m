Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95CA1E79D
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 18:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbfD2QUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 12:20:31 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40851 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbfD2QUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 12:20:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id u17so1591454pfn.7
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 09:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iuoLsJiPnw/JXgOxrXpRVQgpAhR00WHi9L2khmPRaTU=;
        b=iSPjnQYQaqRrj0IHGTf3wsrwbk+JHEPAnXZITG0ikQDFPK8m3yc1CaalbhvyWR29bk
         7s8DH8X3ZDDWG/U3DkDT2ILEuyvYtDJbtVoEcQehKE+SO7r4a7BVvPYm93YjJXf44gAt
         mmtBl9dwWu5XnlfvLh2TZ6HbgAuf7JsrwV9UPy/H4vHnSdMACAHADCOrUGgIQhj2fuG1
         OnyL+pWRN6HKmyp0DO5QVVNopshYK8xfvD4WgvzMYPNxCXy5P5M/NEhXraBMf2zB2UZH
         TB9+8Z87rIw+oorbIcLiXJHaJwyPgykxBTLQMWunRVfyEO0pP+vzOkiBAupgCdfc8yye
         Gr0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iuoLsJiPnw/JXgOxrXpRVQgpAhR00WHi9L2khmPRaTU=;
        b=Ba2SI2kJoLb6ueACo39XneNcrF7G3dR+pbrxzmN6ZtUJ+ol16GYFUBZfUuSnjzhb15
         5l2l3s6rs/hChJH6zZcXX2fufLsgQkytNkNdDE+DPf7suTH0FpPlCDuK39y9dgnVMeJ+
         jmolFb5m9lmqzhjpWHt9APeE3o2wn9AA+SXzdT1moBjj3DP9ZTtbGyy0NXkJyykpUnre
         /YwEeLpEotLl+fScwB8LUU0LaIw245f8nlxgcG00SyHt+/iHgGn8MbdnwwGktgJpKILS
         u0NVvXDpbll/xZEMTM0GU/3cokBPvsFgIGE0Bb50cxKLR4h9jraGyPSY9W5+Cy9QIYo9
         ZT4Q==
X-Gm-Message-State: APjAAAUqLTyFm72CQpnVniNSpHP+XA2TTayL5Rhgdq/PqFS9M9PRWRvj
        JvCIlbL/qVZB8UBC+imdaLfRiw==
X-Google-Smtp-Source: APXvYqy3R91vdFUP7MKOE9lK74Z9U5vcLN6dC1ce1iC0TEnZ1uYEIe4JQCIqgHZKe27Fn8Hxbq0p3A==
X-Received: by 2002:a62:5707:: with SMTP id l7mr65700691pfb.205.1556554829368;
        Mon, 29 Apr 2019 09:20:29 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s187sm38235391pgb.13.2019.04.29.09.20.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 09:20:29 -0700 (PDT)
Date:   Mon, 29 Apr 2019 09:20:27 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH] net-sysfs: expose IRQ number
Message-ID: <20190429092027.6013677d@hermes.lan>
In-Reply-To: <20190429060107.10245-1-zajec5@gmail.com>
References: <20190429060107.10245-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Apr 2019 08:01:07 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>=20
> Knowing IRQ number makes e.g. reading /proc/interrupts much simpler.
> It's more reliable than guessing device name used by a driver when
> calling request_irq().
>=20
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> ---
> I found a script parsing /proc/interrupts for a given interface name. It =
wasn't
> working for me as it assumed request_irq() was called with a device name.=
 It's
> not a case for all drivers.
>=20
> I also found some other people looking for a proper solution for that:
> https://unix.stackexchange.com/questions/275075/programmatically-determin=
e-the-irqs-associated-with-a-network-interface
> https://stackoverflow.com/questions/7516984/retrieving-irq-number-of-a-nic
>=20
> Let me know if this solution makes sense. I can say it works for me ;)
> ---
>  Documentation/ABI/testing/sysfs-class-net |  7 +++++++
>  net/core/net-sysfs.c                      | 16 ++++++++++++++++
>  2 files changed, 23 insertions(+)
>=20
> diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/AB=
I/testing/sysfs-class-net
> index 664a8f6a634f..33440fe77ca7 100644
> --- a/Documentation/ABI/testing/sysfs-class-net
> +++ b/Documentation/ABI/testing/sysfs-class-net
> @@ -301,3 +301,10 @@ Contact:	netdev@vger.kernel.org
>  Description:
>  		32-bit unsigned integer counting the number of times the link has
>  		been down
> +
> +What:		/sys/class/net/<iface>/irq
> +Date:		April 2019
> +KernelVersion:	5.2
> +Contact:	netdev@vger.kernel.org
> +Description:
> +		IRQ number used by device
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index e4fd68389d6f..a3eb7c3f1f37 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -512,6 +512,21 @@ static ssize_t phys_switch_id_show(struct device *de=
v,
>  }
>  static DEVICE_ATTR_RO(phys_switch_id);
> =20
> +static ssize_t irq_show(struct device *dev, struct device_attribute *att=
r,
> +			char *buf)
> +{
> +	const struct net_device *netdev =3D to_net_dev(dev);
> +	ssize_t ret;
> +
> +	if (!rtnl_trylock())
> +		return restart_syscall();
> +	ret =3D sprintf(buf, "%d\n", netdev->irq);
> +	rtnl_unlock();
> +
> +	return ret;
> +}
> +static DEVICE_ATTR_RO(irq);
> +
>  static struct attribute *net_class_attrs[] __ro_after_init =3D {
>  	&dev_attr_netdev_group.attr,
>  	&dev_attr_type.attr,
> @@ -542,6 +557,7 @@ static struct attribute *net_class_attrs[] __ro_after=
_init =3D {
>  	&dev_attr_proto_down.attr,
>  	&dev_attr_carrier_up_count.attr,
>  	&dev_attr_carrier_down_count.attr,
> +	&dev_attr_irq.attr,
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(net_class);

Can't you find this on the PCI side already?
$ ls /sys/class/net/eno1/device/msi_irqs/
37  38  39  40  41

