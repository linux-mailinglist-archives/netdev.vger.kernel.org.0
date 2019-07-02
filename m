Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1915D591
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 19:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfGBRrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 13:47:17 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43621 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfGBRrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 13:47:17 -0400
Received: by mail-qt1-f194.google.com with SMTP id w17so19454982qto.10
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 10:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=5mRc/loyS1lK1v5UFOL02pvAf/1UCF0nrKUwEs2bpNs=;
        b=njermmfhY+nZUJk67TAMtvcCqzgfDu4XstOlYEqpjiQ6BxOz4iW00KDZqhGAX8U8oJ
         q3FWC9asXdRFScTDuAlxz0Xw0/cG6xyhyWGw8prEC5gxAojxrjfAfnWL/Eae6Mfs16sS
         77yCUVrYhNG9g0iFhv1YmEI/+4ajtBAMSXtyhiRA/j/DmXfmWhWUYp3Tws78ogz/wIFa
         uHDpb5bfntag6nbk6BzDeKh3TkgYqXseJf9Cwbor4gHU6dHLh0MHNLBxf4ZNXNqy1fnm
         GL2pXqJ5UG9PchM0hDFwbh5HNgQKKfY720pDbsEYomDut3Zlx1RGkef7/gghsEN9ZyzS
         UMtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5mRc/loyS1lK1v5UFOL02pvAf/1UCF0nrKUwEs2bpNs=;
        b=E3JR+roFJ2aHJyY/qUne7oF/emPZKWMNBxbnUeanMNJ3bTOOogT1NMZj628f1vSSEm
         FlO3UXKt8bAC9ds5qEecHY4Qhzsyl1DECy239BqBFMGfj3qD/15yII0dNDXf7Nd22csd
         vZiiaugLgxYGaNbID6+pMZIGGnG/0EreUQ8mERt9OPzH1+o/iSUoFG/ELpK0Gwq2b1x5
         6ugJbXpOZx1Y0AONh1f1n6KbopWI/FLqTJT7L6QIE4Mss6rHcs8NWhADK3O73RFF8YQm
         blf9FBp+7zdRZS6RhkCzb/+iB29oBFX23rLQRzUH6qyW4u51duLpjCIBLz+42cukWWju
         u0nQ==
X-Gm-Message-State: APjAAAWVmLrS/mEyqY03FozvlQLtbtirmFx7ea0dlLQEkceKZT5RyTsr
        JinfsmEXeojLHTxFjex5itZIyJosQ8Q=
X-Google-Smtp-Source: APXvYqzn4bCK8s2mLX1vD3XtieHCgr/rbxs0S9f5j3ACAqPtwi+POh/jLTHGNb6Nga8uFhwZbGwr2g==
X-Received: by 2002:ac8:2410:: with SMTP id c16mr26150911qtc.108.1562089636595;
        Tue, 02 Jul 2019 10:47:16 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a54sm7051848qtk.85.2019.07.02.10.47.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 10:47:16 -0700 (PDT)
Date:   Tue, 2 Jul 2019 10:47:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Message-ID: <20190702104711.77618f6a@cakuba.netronome.com>
In-Reply-To: <AM0PR05MB4866085BC8B082EFD5B59DD2D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190701122734.18770-2-parav@mellanox.com>
        <20190701162650.17854185@cakuba.netronome.com>
        <AM0PR05MB4866085BC8B082EFD5B59DD2D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jul 2019 04:26:47 +0000, Parav Pandit wrote:
> > On Mon,  1 Jul 2019 07:27:32 -0500, Parav Pandit wrote: =20
> > > In an eswitch, PCI PF may have port which is normally represented
> > > using a representor netdevice.
> > > To have better visibility of eswitch port, its association with PF, a
> > > representor netdevice and port number, introduce a PCI PF port flavour
> > > and port attriute.
> > >
> > > When devlink port flavour is PCI PF, fill up PCI PF attributes of the
> > > port.
> > >
> > > Extend port name creation using PCI PF number on best effort basis.
> > > So that vendor drivers can skip defining their own scheme.
> > >
> > > $ devlink port show
> > > pci/0000:05:00.0/0: type eth netdev eth0 flavour pcipf pfnum 0
> > >
> > > Acked-by: Jiri Pirko <jiri@mellanox.com>
> > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > diff --git a/include/net/devlink.h b/include/net/devlink.h index
> > > 6625ea068d5e..8db9c0e83fb5 100644
> > > --- a/include/net/devlink.h
> > > +++ b/include/net/devlink.h
> > > @@ -38,6 +38,10 @@ struct devlink {
> > >  	char priv[0] __aligned(NETDEV_ALIGN);  };
> > >
> > > +struct devlink_port_pci_pf_attrs { =20
> >=20
> > Why the named structure?  Anonymous one should be just fine?
> > =20
> No specific reason for this patch. But named structure allows to
> extend it more easily with code readability.=20

I'd argue the readability - I hove to scroll up/look up the structure
just to see it has a single member.  But no big deal :)

> Such as subsequently we want to add the peer_mac etc port attributes.
> Named structure to store those attributes are helpful.=20

It remains to be seen if peer attributes are flavour specific =F0=9F=A4=94
I'd imagine most port types would have some form of a peer (other
than a network port, perhaps).  But perhaps different peer attributes.

> > > diff --git a/net/core/devlink.c b/net/core/devlink.c index
> > > 89c533778135..001f9e2c96f0 100644
> > > --- a/net/core/devlink.c
> > > +++ b/net/core/devlink.c
> > > @@ -517,6 +517,11 @@ static int devlink_nl_port_attrs_put(struct sk_b=
uff *msg, =20
> > >  		return -EMSGSIZE;
> > >  	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs->port_number))
> > >  		return -EMSGSIZE; =20
> >=20
> > Why would we report network port information for PF and VF port
> > flavours? =20
>
> I didn't see any immediate need to report, at the same time didn't
> find any reason to treat such port flavours differently than existing
> one. It just gives a clear view of the device's eswitch. Might find
> it useful during debugging while inspecting device internal tables..

PFs and VFs ports are not tied to network ports in switchdev mode.
You have only one network port under a devlink instance AFAIR, anyway.

> > > +	if (devlink_port->attrs.flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF)=
 {
> > > +		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
> > > +				attrs->pci_pf.pf))
> > > +			return -EMSGSIZE;
> > > +	}
> > >  	if (!attrs->split)
> > >  		return 0;
> > >  	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_GROUP, attrs->port_num=
ber)) =20
