Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D6747098
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 17:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfFOPEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 11:04:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43854 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfFOPEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Jun 2019 11:04:36 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8F0B059451;
        Sat, 15 Jun 2019 15:04:34 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-63.rdu2.redhat.com [10.10.112.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BFFA7C5E3;
        Sat, 15 Jun 2019 15:04:33 +0000 (UTC)
Message-ID: <348d854d2717899906ad8779270449a06b5701de.camel@redhat.com>
Subject: Re: [PATCH 2/2] ipoib: show VF broadcast address
From:   Doug Ledford <dledford@redhat.com>
To:     Denis Kirjanov <kirjanov@gmail.com>
Cc:     Denis Kirjanov <kda@linux-powerpc.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        mkubecek@suse.cz
Date:   Sat, 15 Jun 2019 11:04:30 -0400
In-Reply-To: <CAHj3AVny9PijUD7_bWM2-fDNF9n4YZ5xgnG-_O9rZhr1cNVicw@mail.gmail.com>
References: <20190614133249.18308-1-dkirjanov@suse.com>
         <20190614133249.18308-2-dkirjanov@suse.com>
         <f91615fe4a883ccb6490aec11ef4ae64cdd9e494.camel@redhat.com>
         <CAHj3AVny9PijUD7_bWM2-fDNF9n4YZ5xgnG-_O9rZhr1cNVicw@mail.gmail.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-VLNM8+Kt3BokOZUjxe4Y"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Sat, 15 Jun 2019 15:04:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-VLNM8+Kt3BokOZUjxe4Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2019-06-15 at 11:49 +0300, Denis Kirjanov wrote:
> On 6/14/19, Doug Ledford <dledford@redhat.com> wrote:
> > On Fri, 2019-06-14 at 15:32 +0200, Denis Kirjanov wrote:
> > > in IPoIB case we can't see a VF broadcast address for but
> > > can see for PF
> > >=20
> > > Before:
> > > 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc
> > > pfifo_fast
> > > state UP mode DEFAULT group default qlen 256
> > >     link/infiniband
> > > 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> > > 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
> > >     vf 0 MAC 14:80:00:00:66:fe, spoof checking off, link-state
> > > disable,
> > > trust off, query_rss off
> > > ...
> >=20
> > The above Before: output should be used as the After: portion of
> > the
> > previous commit message.  The previos commit does not fully resolve
> > the
> > problem, but yet the commit message acts as though it does.
> >=20
> > > After:
> > > 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc
> > > pfifo_fast
> > > state UP mode DEFAULT group default qlen 256
> > >     link/infiniband
> > > 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> > > 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
> > >     vf 0     link/infiniband
> > > 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> > > 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
> > > spoof
> > > checking off, link-state disable, trust off, query_rss off
> >=20
> > Ok, I get why the After: should have a valid broadcast.  What I
> > don't
> > get is why the Before: shows a MAC and the After: shows a
> > link/infiniband?  What change in this patch is responsible for that
> > difference?  I honestly expect, by reading this patch, that you
> > would
> > have a MAC and Broadcast that look like Ethernet, not that the full
> > issue would be resolved.
>=20
> Hi Doug,
> it's the patch for iproute2 that I'm going to send

Ahh, ok, then please mention that in the commit message or else the
commit message and the patch won't quite make sense together.  Maybe do
a before: and after: without the iproute2 patch, then a after-with-
userspace-fix: that is the final result and mention the fix to iproute2
to print out the right link layer and size of address/broadcast.

> > > v1->v2: add the IFLA_VF_BROADCAST constant
> > > v2->v3: put IFLA_VF_BROADCAST at the end
> > > to avoid KABI breakage and set NLA_REJECT
> > > dev_setlink
> > >=20
> > > Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> > > ---
> > >  include/uapi/linux/if_link.h | 5 +++++
> > >  net/core/rtnetlink.c         | 5 +++++
> > >  2 files changed, 10 insertions(+)
> > >=20
> > > diff --git a/include/uapi/linux/if_link.h
> > > b/include/uapi/linux/if_link.h
> > > index 5b225ff63b48..6f75bda2c2d7 100644
> > > --- a/include/uapi/linux/if_link.h
> > > +++ b/include/uapi/linux/if_link.h
> > > @@ -694,6 +694,7 @@ enum {
> > >  	IFLA_VF_IB_NODE_GUID,	/* VF Infiniband node GUID */
> > >  	IFLA_VF_IB_PORT_GUID,	/* VF Infiniband port GUID */
> > >  	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for
> > > QinQ */
> > > +	IFLA_VF_BROADCAST,	/* VF broadcast */
> > >  	__IFLA_VF_MAX,
> > >  };
> > >=20
> > > @@ -704,6 +705,10 @@ struct ifla_vf_mac {
> > >  	__u8 mac[32]; /* MAX_ADDR_LEN */
> > >  };
> > >=20
> > > +struct ifla_vf_broadcast {
> > > +	__u8 broadcast[32];
> > > +};
> > > +
> > >  struct ifla_vf_vlan {
> > >  	__u32 vf;
> > >  	__u32 vlan; /* 0 - 4095, 0 disables VLAN filter */
> > > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > > index cec60583931f..8ac81630ab5c 100644
> > > --- a/net/core/rtnetlink.c
> > > +++ b/net/core/rtnetlink.c
> > > @@ -908,6 +908,7 @@ static inline int rtnl_vfinfo_size(const
> > > struct
> > > net_device *dev,
> > >  		size +=3D num_vfs *
> > >  			(nla_total_size(0) +
> > >  			 nla_total_size(sizeof(struct ifla_vf_mac)) +
> > > +			 nla_total_size(sizeof(struct
> > > ifla_vf_broadcast)) +
> > >  			 nla_total_size(sizeof(struct ifla_vf_vlan)) +
> > >  			 nla_total_size(0) + /* nest IFLA_VF_VLAN_LIST
> > > */
> > >  			 nla_total_size(MAX_VLAN_LIST_LEN *
> > > @@ -1197,6 +1198,7 @@ static noinline_for_stack int
> > > rtnl_fill_vfinfo(struct sk_buff *skb,
> > >  	struct ifla_vf_vlan vf_vlan;
> > >  	struct ifla_vf_rate vf_rate;
> > >  	struct ifla_vf_mac vf_mac;
> > > +	struct ifla_vf_broadcast vf_broadcast;
> > >  	struct ifla_vf_info ivi;
> > >=20
> > >  	memset(&ivi, 0, sizeof(ivi));
> > > @@ -1231,6 +1233,7 @@ static noinline_for_stack int
> > > rtnl_fill_vfinfo(struct sk_buff *skb,
> > >  		vf_trust.vf =3D ivi.vf;
> > >=20
> > >  	memcpy(vf_mac.mac, ivi.mac, sizeof(ivi.mac));
> > > +	memcpy(vf_broadcast.broadcast, dev->broadcast, dev->addr_len);
> > >  	vf_vlan.vlan =3D ivi.vlan;
> > >  	vf_vlan.qos =3D ivi.qos;
> > >  	vf_vlan_info.vlan =3D ivi.vlan;
> > > @@ -1247,6 +1250,7 @@ static noinline_for_stack int
> > > rtnl_fill_vfinfo(struct sk_buff *skb,
> > >  	if (!vf)
> > >  		goto nla_put_vfinfo_failure;
> > >  	if (nla_put(skb, IFLA_VF_MAC, sizeof(vf_mac), &vf_mac) ||
> > > +	    nla_put(skb, IFLA_VF_BROADCAST, sizeof(vf_broadcast),
> > > &vf_broadcast) ||
> > >  	    nla_put(skb, IFLA_VF_VLAN, sizeof(vf_vlan), &vf_vlan) ||
> > >  	    nla_put(skb, IFLA_VF_RATE, sizeof(vf_rate),
> > >  		    &vf_rate) ||
> > > @@ -1753,6 +1757,7 @@ static const struct nla_policy
> > > ifla_info_policy[IFLA_INFO_MAX+1] =3D {
> > >=20
> > >  static const struct nla_policy ifla_vf_policy[IFLA_VF_MAX+1] =3D {
> > >  	[IFLA_VF_MAC]		=3D { .len =3D sizeof(struct ifla_vf_mac)
> > > },
> > > +	[IFLA_VF_BROADCAST]	=3D { .type =3D NLA_REJECT },
> > >  	[IFLA_VF_VLAN]		=3D { .len =3D sizeof(struct
> > > ifla_vf_vlan) },
> > >  	[IFLA_VF_VLAN_LIST]     =3D { .type =3D NLA_NESTED },
> > >  	[IFLA_VF_TX_RATE]	=3D { .len =3D sizeof(struct ifla_vf_tx_rate)
> > > },
> >=20
> > --
> > Doug Ledford <dledford@redhat.com>
> >     GPG KeyID: B826A3330E572FDD
> >     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
> > 2FDD
> >=20
>=20
>=20

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
2FDD

--=-VLNM8+Kt3BokOZUjxe4Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl0FCP4ACgkQuCajMw5X
L90jxQ//ZmDmaE0Zwa1LEJDfgNHOz4QPU4vszfGyKI7PxZEp3vg2DzChw0i3C0R/
MLKfUHNIEkn13XV4wxyQn7reNOAN0en3kcygUXd5RPzerxFX8FVbREi4FOtE7riN
r610Qp3uzKeJkhJHiBXxYj7i1jwyoT2jDKYc3SoY34TtjFQAV1m36sxrzIrE/zyU
6fjK3G7jItQ2dlfKCFG8gtBjKPQEuX2PcnYyGZ2wIgJ1Gn5z2rZkRQIy4cqCokrU
8EP7nytEyOIAhL9UrQJTDhkkNjrz83X/IVmRLckKmjOKtPuVg/g8Trs4Ja9uvmO5
93ooqhGzaF0uSGVfTp/WSaNWhiGqZYaW74Jwu9Dz14DQzDkYK4uZR3lvsvyErHhH
Lnp+lQMBqEduw63Q6yCG0/PwZRNqKpnz88FpIvf2L+ubpHaeticQD0g7FUFidIF5
tIi0m4ntukMbcbTgPLJ+hWb6LxgW9gjCXUeq7AcEt+offatpdItg2gNpCPXk7/P9
fnr52Wmgeetvhnte/qnpz3QbskiIMTH45z7OAcZKm0+NQ2Z1C4xGvsCwk6ccO7kV
2iUo2CEsuOFRGa8BjOQ42MVuGGco1ddGfhHE28LelcRAwY29eedMAo1O5IbNcoxE
8v7KHAzEwpR33uTuYmeRmUMbUo+HKSF43caIIQ4HgoYI0U+331s=
=QyNF
-----END PGP SIGNATURE-----

--=-VLNM8+Kt3BokOZUjxe4Y--

