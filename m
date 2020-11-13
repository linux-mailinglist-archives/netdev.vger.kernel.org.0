Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65732B244B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgKMTKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:10:33 -0500
Received: from sender11-of-o52.zoho.eu ([31.186.226.238]:21315 "EHLO
        sender11-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgKMTKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 14:10:33 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1605294589; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=OzTAj37sL9DNssltwDz3e3rN+AsMD/K9n97SOgjg5fAXYy1wO104X1vSmsnM6XmeGb12RuDSQZeZuzGq4NyASqsfrN1+p39q/U+nWm2RjpXdBjU6yCj/1ceMfSusEUXLC0JRhnJRWurZxakRPIyqcLsYh28usl3urx+w96DwX4c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1605294589; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=tvD4wWar86pTP/G4jJYNNyxJfymK+KPFfhKCCxWIcPc=; 
        b=EZRNOKu/J1G6PT/MF6tm7L8j6j8ltxkTzALdMr06mgxJfJttk3DGtxwWLC3ni/AU30vaA7HzMQYsq/KE7LpFCo2hyWWHlj8V/DyBcgmnVa9fLGP5Yr7eQIbiwbgG7IG8uvdvKqEySJehpR0emIWkjag7o8jYizblAFDKNtfsls4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net> header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1605294589;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=tvD4wWar86pTP/G4jJYNNyxJfymK+KPFfhKCCxWIcPc=;
        b=QRFpkDiN9C40MpKpdk1Ovi8xc/8aTrh6zbsV45k/KGdeN2vkeIai2yHAsJwgqPg7
        QgF//2xidggNBR1qcsjxBCXWSpdA6+UVYyG4oiFrPvidm2pUZ00rgKfoA7KDH0zUt1K
        2llBIcR2E/bKeA0eznxH4YU8Bt9ibAksVjtF+KEs=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1605294583384891.1387554495267; Fri, 13 Nov 2020 20:09:43 +0100 (CET)
Date:   Fri, 13 Nov 2020 20:09:43 +0100
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "Hideaki Yoshifuji" <hideaki.yoshifuji@miraclelinux.com>
Cc:     "kuba" <kuba@kernel.org>, "kuznet" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <175c3036e56.c134a30a177674.8041366564060302157@shytyi.net>
In-Reply-To: <CAPA1RqC+wgi+fQ4A3GiwnLpGZ=5PfDF7kZUKkoYyXA2FN+4oyw@mail.gmail.com>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
 <202011110944.7zNVZmvB-lkp@intel.com> <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
 <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net> <CAPA1RqC+wgi+fQ4A3GiwnLpGZ=5PfDF7kZUKkoYyXA2FN+4oyw@mail.gmail.com>
Subject: Re: [PATCH net-next V4] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

---- On Fri, 13 Nov 2020 13:38:02 +0100 Hideaki Yoshifuji <hideaki.yoshifuj=
i@miraclelinux.com> wrote ----

 > Hi,=20
 > =20
 > 2020=E5=B9=B411=E6=9C=8813=E6=97=A5(=E9=87=91) 10:57 Dmytro Shytyi <dmyt=
ro@shytyi.net>:=20
 > >=20
 > > Variable SLAAC: SLAAC with prefixes of arbitrary length in PIO (random=
ly=20
 > > generated hostID or stable privacy + privacy extensions).=20
 > > The main problem is that SLAAC RA or PD allocates a /64 by the Wireles=
s=20
 > > carrier 4G, 5G to a mobile hotspot, however segmentation of the /64 vi=
a=20
 > > SLAAC is required so that downstream interfaces can be further subnett=
ed.=20
 > > Example: uCPE device (4G + WI-FI enabled) receives /64 via Wireless, a=
nd=20
 > > assigns /72 to VNF-Firewall, /72 to WIFI, /72 to VNF-Router, /72 to=20
 > > Load-Balancer and /72 to wired connected devices.=20
 > > IETF document that defines problem statement:=20
 > > draft-mishra-v6ops-variable-slaac-problem-stmt=20
 > > IETF document that specifies variable slaac:=20
 > > draft-mishra-6man-variable-slaac=20
 > >=20
 > > Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>=20
 > > ---=20
 > > diff -rupN net-next-5.10.0-rc2/net/ipv6/addrconf.c net-next-patch-5.10=
.0-rc2/net/ipv6/addrconf.c=20
 > > --- net-next-5.10.0-rc2/net/ipv6/addrconf.c     2020-11-10 08:46:01.07=
5193379 +0100=20
 > > +++ net-next-patch-5.10.0-rc2/net/ipv6/addrconf.c       2020-11-13 02:=
30:25.552724864 +0100=20
 > > @@ -1315,10 +1322,14 @@ static int ipv6_create_tempaddr(struct i=20
 > >         struct ifa6_config cfg;=20
 > >         long max_desync_factor;=20
 > >         struct in6_addr addr;=20
 > > -       int ret =3D 0;=20
 > > +       int ret;=20
 > > +       struct in6_addr net_mask;=20
 > > +       struct in6_addr temp;=20
 > > +       struct in6_addr ipv6addr;=20
 > > +       int i;=20
 > >=20
 > >         write_lock_bh(&idev->lock);=20
 > > -=20
 > > +       ret =3D 0;=20
 > >  retry:=20
 > >         in6_dev_hold(idev);=20
 > >         if (idev->cnf.use_tempaddr <=3D 0) {=20
 > > @@ -1340,9 +1351,26 @@ retry:=20
 > >                 goto out;=20
 > >         }=20
 > >         in6_ifa_hold(ifp);=20
 > > -       memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);=20
 > > -       ipv6_gen_rnd_iid(&addr);=20
 > >=20
 > > +       if (ifp->prefix_len =3D=3D 64) {=20
 > > +               memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);=20
 > > +               ipv6_gen_rnd_iid(&addr);=20
 > > +       } else if (ifp->prefix_len > 0 && ifp->prefix_len <=3D 128) {=
=20
 > > +               memcpy(addr.s6_addr32, ifp->addr.s6_addr, 16);=20
 > > +               get_random_bytes(temp.s6_addr32, 16);=20
 > > +=20
 > > +               /* tranfrom prefix len into mask */=20
 > > +               ipv6_plen_to_mask(ifp->prefix_len, &net_mask);=20
 > > +=20
 > > +               for (i =3D 0; i < 4; i++) {=20
 > > +                       /* network prefix */=20
 > > +                       ipv6addr.s6_addr32[i] =3D addr.s6_addr32[i] & =
net_mask.s6_addr32[i];=20
 > > +                       /* host id */=20
 > > +                       ipv6addr.s6_addr32[i] |=3D temp.s6_addr32[i] &=
 ~net_mask.s6_addr32[i];=20
 > > +               }=20
 > > +=20
 > > +               memcpy(addr.s6_addr, ipv6addr.s6_addr32, 16);=20
 > >=20
 > =20
 > ipv6_addr_copy() and then ipv6_addr_prefix_copy()=20

 [Dmytro] Understood. Migrating to ipv6_addr_prefix_copy()

 > +       }=20
 > >         age =3D (now - ifp->tstamp) / HZ;=20
 > >=20
 > >         regen_advance =3D idev->cnf.regen_max_retry *=20
 > > @@ -2576,9 +2604,57 @@ int addrconf_prefix_rcv_add_addr(struct=20
 > >                                  u32 addr_flags, bool sllao, bool toke=
nized,=20
 > >                                  __u32 valid_lft, u32 prefered_lft)=20
 > >  {=20
 > > -       struct inet6_ifaddr *ifp =3D ipv6_get_ifaddr(net, addr, dev, 1=
);=20
 > > +       struct inet6_ifaddr *ifp =3D NULL;=20
 > >         int create =3D 0;=20
 > >=20
 > > +       if ((in6_dev->if_flags & IF_RA_VAR_PLEN) =3D=3D IF_RA_VAR_PLEN=
 &&=20
 > > +           in6_dev->cnf.addr_gen_mode !=3D IN6_ADDR_GEN_MODE_STABLE_P=
RIVACY) {=20
 > > +               struct inet6_ifaddr *result =3D NULL;=20
 > > +               struct inet6_ifaddr *result_base =3D NULL;=20
 > > +               struct in6_addr net_mask;=20
 > > +               struct in6_addr net_prfx;=20
 > > +               struct in6_addr curr_net_prfx;=20
 > > +               bool prfxs_equal;=20
 > > +               int i;=20
 > > +=20
 > > +               result_base =3D result;=20
 > > +               rcu_read_lock();=20
 > > +               list_for_each_entry_rcu(ifp, &in6_dev->addr_list, if_l=
ist) {=20
 > > +                       if (!net_eq(dev_net(ifp->idev->dev), net))=20
 > > +                               continue;=20
 > > +=20
 > > +                       /* tranfrom prefix len into mask */=20
 > > +                       ipv6_plen_to_mask(pinfo->prefix_len, &net_mask=
);=20
 > > +                       /* Prepare network prefixes */=20
 > > +                       for (i =3D 0; i < 4; i++) {=20
 > > +                               /* Received/new network prefix */=20
 > > +                               net_prfx.s6_addr32[i] =3D=20
 > > +                                       pinfo->prefix.s6_addr32[i] & n=
et_mask.s6_addr32[i];=20
 > > +                               /* Configured/old IPv6 prefix */=20
 > > +                               curr_net_prfx.s6_addr32[i] =3D=20
 > > +                                       ifp->addr.s6_addr32[i] & net_m=
ask.s6_addr32[i];=20
 > > +                       }=20
 > > +                       /* Compare network prefixes */=20
 > > +                       prfxs_equal =3D 1;=20
 > > +                       for (i =3D 0; i < 4; i++) {=20
 > > +                               if ((net_prfx.s6_addr32[i] ^ curr_net_=
prfx.s6_addr32[i]) !=3D 0)=20
 > > +                                       prfxs_equal =3D 0;=20
 > > +                       }=20
 > =20
 > ipv6_prefix_equal()
 [Dmytro] Understood. Migrating to ipv6_prefix_equal()
 > =20
 > > +                       if (prfxs_equal && pinfo->prefix_len =3D=3D if=
p->prefix_len) {=20
 > > +                               result =3D ifp;=20
 > > +                               in6_ifa_hold(ifp);=20
 > > +                               break;=20
 > > +                       }=20
 > > +               }=20
 > > +               rcu_read_unlock();=20
 > > +               if (result_base !=3D result)=20
 > > +                       ifp =3D result;=20
 > > +               else=20
 > > +                       ifp =3D NULL;=20
 > > +       } else {=20
 > > +               ifp =3D ipv6_get_ifaddr(net, addr, dev, 1);=20
 > > +       }=20
 > > +=20
 > >         if (!ifp && valid_lft) {=20
 > >                 int max_addresses =3D in6_dev->cnf.max_addresses;=20
 > >                 struct ifa6_config cfg =3D {=20
 > > @@ -2781,9 +2857,35 @@ void addrconf_prefix_rcv(struct net_devi=20
 > >                                 dev_addr_generated =3D true;=20
 > >                         }=20
 > >                         goto ok;=20
 > > +               goto put;=20
 > > +               } else if (((in6_dev->if_flags & IF_RA_VAR_PLEN) =3D=
=3D IF_RA_VAR_PLEN) &&=20
 > > +                         pinfo->prefix_len > 0 && pinfo->prefix_len <=
=3D 128) {=20
 > > +                       /* SLAAC with prefixes of arbitrary length (Va=
riable SLAAC).=20
 > > +                        * draft-mishra-6man-variable-slaac=20
 > > +                        * draft-mishra-v6ops-variable-slaac-problem-s=
tmt=20
 > > +                        * Contact: Dmytro Shytyi.=20
 > > +                        */=20
 > > +                       memcpy(&addr, &pinfo->prefix, 16);=20
 > > +                       if (in6_dev->cnf.addr_gen_mode =3D=3D IN6_ADDR=
_GEN_MODE_STABLE_PRIVACY) {=20
 > > +                               if (!ipv6_generate_address_variable_pl=
en(&addr,=20
 > > +                                                                     =
   0,=20
 > > +                                                                     =
   in6_dev,=20
 > > +                                                                     =
   pinfo->prefix_len,=20
 > > +                                                                     =
   true)) {=20
 > > +                                       addr_flags |=3D IFA_F_STABLE_P=
RIVACY;=20
 > > +                                       goto ok;=20
 > > +                       }=20
 > > +                       } else if (!ipv6_generate_address_variable_ple=
n(&addr,=20
 > > +                                                                     =
  0,=20
 > > +                                                                     =
  in6_dev,=20
 > > +                                                                     =
  pinfo->prefix_len,=20
 > > +                                                                     =
  false)) {=20
 > > +                               goto ok;=20
 > > +                       }=20
 > > +               } else {=20
 > > +                       net_dbg_ratelimited("IPv6: Prefix with unexpec=
ted length %d\n",=20
 > > +                                           pinfo->prefix_len);=20
 > >                 }=20
 > > -               net_dbg_ratelimited("IPv6 addrconf: prefix with wrong =
length %d\n",=20
 > > -                                   pinfo->prefix_len);=20
 > >                 goto put;=20
 > >=20
 > >  ok:=20
 > > @@ -3264,6 +3366,118 @@ retry:=20
 > >         return 0;=20
 > >  }=20
 > >=20
 > > +static void ipv6_plen_to_mask(int plen, struct in6_addr *net_mask)=20
 > > +{=20
 > > +       int i, plen_bytes;=20
 > > +       char bit_array[7] =3D {0b10000000,=20
 > > +                            0b11000000,=20
 > > +                            0b11100000,=20
 > > +                            0b11110000,=20
 > > +                            0b11111000,=20
 > > +                            0b11111100,=20
 > > +                            0b11111110};=20
 > > +=20
 > > +       if (plen <=3D 0 || plen > 128)=20
 > > +               pr_err("Unexpected plen: %d", plen);=20
 > > +=20
 > > +       memset(net_mask, 0x00, sizeof(*net_mask));=20
 > > +=20
 > > +       /* We set all bits =3D=3D 1 of s6_addr[i] */=20
 > > +       plen_bytes =3D plen / 8;=20
 > > +       for (i =3D 0; i < plen_bytes; i++)=20
 > > +               net_mask->s6_addr[i] =3D 0xff;=20
 > > +=20
 > > +       /* We add bits from the bit_array to=20
 > > +        * netmask starting from plen_bytes position=20
 > > +        */=20
 > > +       if (plen % 8)=20
 > > +               net_mask->s6_addr[plen_bytes] =3D bit_array[(plen % 8)=
 - 1];=20
 > > +       memcpy(net_mask->s6_addr32, net_mask->s6_addr, 16);=20
 > > +}=20
 > =20
 > I don't think we need this function.
[Dmytro] Indeed.=20
 > If needed, we could introduce ipv6_addr_host() (like ipv6_addr_prefix())=
=20
 > in include/net/ipv6.h.=20
[Dmytro] Maybe, we will see...
