Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3FFF9CDE
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 23:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKLWUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 17:20:05 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37264 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfKLWUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 17:20:04 -0500
Received: by mail-lf1-f68.google.com with SMTP id b20so183963lfp.4
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 14:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=FaG/Lq6UjFSgxoe0xQS6nnz6Kfzut+QfDC31o6BtulQ=;
        b=ZGv5/eyhYasg2ZW1/Ml5E4wctqkAD97f8ARHlPqWQbFJno3AQahj2Ydx65cV6yynAs
         2MR8XL4/YujjIp2qY6HTKGdhNwJOTQqg/DZQA7BWHoRuOT/c9jQad0enTlgHhkA7kEdq
         zgI5d+79Fd/ZkpaaxuheRWoMSqpgZX8pr1d1YgiXD7TE9tT1img/RjOQQ3BjmdQYQoSm
         p6eI7Gb8IPP77rH9dxWN5lxIUNSrORX22Og4EWgH1rWZEpW55y1E/yZgMdS11pTg7aGq
         Q53C+OH75m6tdilo6QT/YVrHkUy4hHsCl/yzeEN5Nmuakla5gjoOmZLwfjkneCeSG2qZ
         JF/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=FaG/Lq6UjFSgxoe0xQS6nnz6Kfzut+QfDC31o6BtulQ=;
        b=fD96iqXBW/1u1AX9T/+tOew0+t02OXzjVNMCahRb7gb47aYG73BgVeHNJS4gVgPioO
         ThUsWEelRET2RGm9VgoP1/l4aO9vyoLNrXc7vhsic6E2kJOYdRw/4kZ10GeLK3BiyLF8
         arWK4Y6AW49OSAsDIpMwX/HZzdL6+MwsgK7YO/b/fD5yRUCKhmvtsJH+QlpxK4LJFN/j
         u13wMpaDn70TV1a44m2Ogx9NupSUQxMLEOWBuOdCqaMm/yvbd/b7Y9COSUFHkb5RsgoO
         8ffxYLgqCeIMMyJD8+GofxHPr3BByclv6MZDDTpWKZn3aCkbjRgShJ1B+beJVV7ThaKk
         ar8Q==
X-Gm-Message-State: APjAAAX8A9zaPDk9Luq+oXxf+WmN/TFRMo3pVY1GTcAYZJfyQ+XwbH+K
        Xfb1ss3s3cbTsduhl0kfydpwLaAdRxE=
X-Google-Smtp-Source: APXvYqzvyo4zrAiQUXlbWAeyIJ7T/fogtTvVpdwqpW6K3h3Ze+7AfZccSm3h2F7yn/uBEb9DTUX7lQ==
X-Received: by 2002:a19:6a03:: with SMTP id u3mr127156lfu.25.1573597201931;
        Tue, 12 Nov 2019 14:20:01 -0800 (PST)
Received: from cakuba ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 77sm50589lfj.67.2019.11.12.14.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 14:20:01 -0800 (PST)
Date:   Tue, 12 Nov 2019 14:19:54 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yuval Avnery <yuvalav@mellanox.com>
Cc:     Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next v2 00/10] devlink subdev
Message-ID: <20191112141954.371e8cd2@cakuba>
In-Reply-To: <AM6PR05MB5142D1ADB06CB0D5FF646F46C5770@AM6PR05MB5142.eurprd05.prod.outlook.com>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
        <20191111100004.683b7320@cakuba>
        <AM6PR05MB5142D5C8B186A50D49D857ABC5740@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191112145542.GA6619@C02YVCJELVCG>
        <AM6PR05MB5142D1ADB06CB0D5FF646F46C5770@AM6PR05MB5142.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 18:35:26 +0000, Yuval Avnery wrote:
> > It feels a bit 'unconstrained' to me as well.  As Jakub said you added =
some
> > documentation, but the direction of this long-term is not clear.
> > What seems to happen too often is that we skip creating better infra for
> > existing devices and create it only for the newest shiniest object.
> > These changes are what garners the most attention from those who grant
> > permission to push things upstream (*cough* managers *cough*), but it's
> > not the right choice in this case.  I'm not sure if that is part of wha=
t bothers
> > Jakub, but it is one thing that bothers me and why this feels incomplet=
e.
> >=20
> > The thing that has been bouncing around in my head about this (and unti=
l I
> > was in front of a good text-based MUA I didn't dare respond) is that we=
 seem
> > to have an overlap in functionality between what you are proposing and
> > existing virtual device configuration, but you are completely ignoring
> > improving upon the existing creation methods.
> > Whether dealing with a SmartNIC (which I used to describe a NIC with
> > general purpose processors that could be running Linux and I think you =
do,
> > too) or a regular NIC it seems like we should use devlink to create and
> > configure a variety of devices these could be:
> >=20
> > 1.  Number of PFs (there are cases where more than 1 PF per uplink port
> >     is required for command/control of the SmartNIC or where a single
> >     PCI b/d/f may have many uplink ports that need to be addressed
> >     separately) =20
>=20
> Yes, uplink ports can be addressed using "devlink port".
>=20
> Multiple pfs are already supported.
>=20
> $ devlink subdev show
> pci/0000:03:00.0/1: flavour pcipf pf 0
> pci/0000:03:00.0/1: flavour pcipf pf 1
> pci/0000:03:00.0/1: flavour pcivf pf 1 vf 0

I don't think that covers what Andy was taking about.

> > 2.  Device-specific SR-IOV VFs visible to server 3.  mdev devices that =
_may_
> > have representers on the embedded cores of
> >     the NIC =20
>=20
> Yes, Is also planned for current interface. (will need to add mdev flavor=
 in the future)
>=20
> > 4.  Hardware VirtIO-net devices supported 5.  Other non-network devices
> > (storage given as the first example) 6.  ... =20
>=20
> All is up to driver - what to expose and what flavor to grant the subdev.
>=20
> > We cannot get rid of the methods for creating hardware VFs via sysfs, b=
ut
> > now that we are seeing lots of different flavors of devices that might =
be
> > created we should start by making sure at a minimum we can create exist=
ing
> > hardware devices (VFs) with this devlink interface and move from there.=
  Is
> > there a plan to use this interface to create subdevs that are VFs or ju=
st new
> > subdev flavors?  I could start to get behind an interface like this if =
the patches
> > showed that devlink would be the one place where device creation and
> > control could be done for all types of subdevs, but that isn't clear th=
at it is
> > your direction based on the patches. =20
>=20
> I don=E2=80=99t see how the SmartNic can force the host PF to create new =
VFs.
> Isn=E2=80=99t that the host PF responsibility? Doesn't make sense to me.
> Do we want to have an interface that works only for NICs and not from
> the SmartNic embedded system?
>
> What we do here is expose all the PFS and potential VFs/mdevs that the ho=
st can enable.
> Unlike ip link which exposes only enabled VFs, here (in mlx5
> implementation) we expose all the VFs that the host PF _can_ enable.
> This allows, for example, to set the MAC of a VF before it is enabled.

So subdev will never be used to create interfaces? Just expose all
_possible_? Ugh. Wouldn't that be something to document?

How things are configured matters. This patch set throws some basics
together to get you the hw_addr from the SmartNIC side, and then you
start talking big plans like NVMe and PCIe control which you don't seem
to have thought through.

How does the PF in your diagram magically have different types of VFs?
PCIe SR-IOV cap has VF device vendor:product, you won't have NVMe VFs
hanging off the main PF like that in a normal world :/

Jiri pitched the subdev object as the "other side of the wire" but you
are back to arguing that you think it's actually the same as the port,
just more general. How does the hw_addr belongs to the ASIC side then?

And for PCIe you'd use this new interface for MSI-X or other resource
allocation. Say VFs. Who controls that in a SmartNIC scenario? Is the
host not allowed to move them around? This starts to touch multi-host
use case which Linux networking never begun to address.

You're creating a new object type with no clear semantics just to throw
in one feature - namely the hw_addr. If this is the quality of design
we can expect - just add the hw addr to devlink ports and let's move on.

> > So just to make sure this is clear, what I'm proposing that devlink
> > is used to create and configure all types of devices that it may be
> > possible to create, =20
>=20
> More flavors can be defiantly added in the future. About creation,
> see my comment above. Actually flavor is the only required attribute
> for registration. The rest is optional.=20
> > configure, or address from a PF and the starting place should be
> > standard, hardware VFs.  If that can be done right and we can
> > address some of the issues with the current implementation (more
> > than one hw addr is a _great_ example) then adding new flavours for
> > the server devices and and adding new flavors for SmartNIC-based
> > devices should be easy and feel natural. =20
>=20
> So what you are saying that allowing multiple addresses per subdev
> will make a strong case for this patch set?
