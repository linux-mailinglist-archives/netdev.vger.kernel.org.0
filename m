Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774F7652905
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 23:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbiLTW0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 17:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbiLTW0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 17:26:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210D5E00F;
        Tue, 20 Dec 2022 14:25:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A767DB8136B;
        Tue, 20 Dec 2022 22:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98090C433D2;
        Tue, 20 Dec 2022 22:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671575132;
        bh=/WLECdTWypMK29cx8baP/3PviucI5f926j7QQ7kIpWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jN17SU3eEeEq72Wc07MXrAXVN4QYdX4hwE01ZHx7LxpzkECzT2aHGT1aeNWVNhwEI
         BeLPOFqFdqO/lYXavYNyIvuw+5zrLkh0GtMWazQ92ysgDrjqpNIfmisqs+lfKh+ufr
         4EL57lxUsT3wvHUp8wh5pCNOS1HWwqqRPTZjpUYXWxpQaIftJM/V/mv8DuwzUzH0Q8
         6pNzdcuvWGRFWGTLIjXtnhDzOnwLc69YUfcEo1P/B+APbSU4GX91h6mKirvAX+JzpG
         rC53b0FQfKV9cUp3wzNLSuQTTfOy+tGsVhbnn3TdpaYMyM5z3NHjkIsKdmy+US3JpT
         SuJU2N6Cx3Pew==
Date:   Tue, 20 Dec 2022 23:25:27 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Marek Majtyka <alardam@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, saeedm@nvidia.com,
        anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        grygorii.strashko@ti.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [RFC bpf-next 2/8] net: introduce XDP features flag
Message-ID: <Y6I2VyBCz7YRxxTR@localhost.localdomain>
References: <cover.1671462950.git.lorenzo@kernel.org>
 <43c340d440d8a87396198b301c5ffbf5ab56f304.1671462950.git.lorenzo@kernel.org>
 <Y6DDfVhOWRybVNUt@google.com>
 <CAAOQfrFGArAYPyBX_kw4ZvFrTjKXf-jG-2F2y69nOs-oQ8Onwg@mail.gmail.com>
 <CAKH8qBuktjBcY_CuqqkWs74oBB8Mnkm638Cb=sF38H4kPAx3NQ@mail.gmail.com>
 <Y6GKN/1iOC9eTsEE@lore-desk>
 <CAKH8qBts19wxSDAKk0SBk76ftvdK+sW6d3ufcBWoV5cMa2ENpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2lNipPbgN3x5Io4s"
Content-Disposition: inline
In-Reply-To: <CAKH8qBts19wxSDAKk0SBk76ftvdK+sW6d3ufcBWoV5cMa2ENpA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2lNipPbgN3x5Io4s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Dec 20, 2022 at 2:11 AM Lorenzo Bianconi
> <lorenzo.bianconi@redhat.com> wrote:
> >
> > On Dec 19, Stanislav Fomichev wrote:
> > > On Mon, Dec 19, 2022 at 3:51 PM Marek Majtyka <alardam@gmail.com> wro=
te:
> > > >
> > > > At the time of writing, I wanted to be able to read additional info=
rmation about the XDP capabilities of each network interface using ethtool.=
 This change was intended for Linux users/admins, and not for XDP experts w=
ho mostly don't need it and prefer tasting XDP with netlink and bpf rather =
than reading network interface features with ethtool.
> > >
> > > Anything preventing ethtool from doing probing similar to 'bpftool
> > > feature probe'?
> > > The problem with these feature bits is that they might diverge and/or
> > > not work at all for the backported patches (where the fix/feature has
> > > been backported, but the part that exports the bit hasn't) :-(
> > > OTOH, I'm not sure we can probe everything from your list, but we
> > > might try and see what's missing..
> >
> > Hi Stanislav,
> >
> > I have not added the ethtool support to this series yet since userspace=
 part is
> > still missing but I think we can consider XDP as a sort of sw offload s=
o it
> > would be nice for the user/sysadmin (not xdp or bpf developer) to check=
 the NIC
> > XDP capabilities similar to what we can already do for other hw offload
> > features.
>=20
> [..]
>=20
> > Moreover let's consider XDP_REDIRECT of a scatter-gather XDP frame into=
 a
> > devmap. I do not think there is a way to test if the 'target' device su=
pports
> > SG and so we are forced to disable this feature until all drivers suppo=
rt it.
>=20
> See below for more questions, but why "target device has prog
> installed and the aux->xdp_has_frags =3D=3D true" won't work for the
> internal kernel consumers?

There are some drivers (e.g. all intel ones) that currently do not support
non-linear xdp buff in the driver napi callback (XDP_FRAG_RX) but implement
non-linear xdp buff support in ndo_xdp_xmit callback (XDP_FRAG_TARGET).
Moreover, I guess for a sysadmin it would be better to check NIC capabiliti=
es in
the same way he/she is used to with other features (e.g. ethool -k ...).

>=20
> > Introducing XDP features we can enable it on per-driver basis.
> > I think the same apply for other capabilities as well and just assuming=
 a given
> > feature is not supported if an e2e test is not working seems a bit inac=
curate.
>=20
> Ok, I see that these bits are used in the later patches in xsk and
> devmap. But I guess I'm still confused about why we add all these
> flags, but only use mostly XDP_F_REDIRECT_TARGET; maybe start with
> that one? And why does it have to be exposed to the userspace?
> (userspace can still probe per-device features by trying to load
> different progs?)

There are some drivers (e.g. ixgbevf or cavium thunder) that do not support
XDP_REDIRECT but just XDP_PASS, XDP_DROP and XDP_TX, so I think we should
differentiate between XDP_BASIC (XDP_PASS | XDP_DROP | XDP_TX) and XDP_FULL
(XDP_BASIC | XDP_REDIRECT).

>=20
> Also, it seems like XDP_F_REDIRECT_TARGET really means "the bpf
> program has been installed on this device". Instead of a flag, why not
> explicitly check whether the target device has a prog installed (and,
> if needed, whether the installed program has frags support)?

XDP_F_REDIRECT_TARGET is used to inform if netdev implements ndo_xdp_xmit
callback (most of the XDP drivers do not require to load a bpf program to
XDP_REDIRECT into them).

Regards,
Lorenzo

>=20
> > Regards,
> > Lorenzo
> >
> > >
> > > > On Mon, Dec 19, 2022 at 9:03 PM <sdf@google.com> wrote:
> > > >>
> > > >> On 12/19, Lorenzo Bianconi wrote:
> > > >> > From: Marek Majtyka <alardam@gmail.com>
> > > >>
> > > >> > Implement support for checking what kind of XDP features a netdev
> > > >> > supports. Previously, there was no way to do this other than to =
try to
> > > >> > create an AF_XDP socket on the interface or load an XDP program =
and see
> > > >> > if it worked. This commit changes this by adding a new variable =
which
> > > >> > describes all xdp supported functions on pretty detailed level:
> > > >>
> > > >> >   - aborted
> > > >> >   - drop
> > > >> >   - pass
> > > >> >   - tx
> > > >> >   - redirect
> > > >> >   - sock_zerocopy
> > > >> >   - hw_offload
> > > >> >   - redirect_target
> > > >> >   - tx_lock
> > > >> >   - frag_rx
> > > >> >   - frag_target
> > > >>
> > > >> > Zerocopy mode requires that redirect XDP operation is implemente=
d in a
> > > >> > driver and the driver supports also zero copy mode. Full mode re=
quires
> > > >> > that all XDP operation are implemented in the driver. Basic mode=
 is just
> > > >> > full mode without redirect operation. Frag target requires
> > > >> > redirect_target one is supported by the driver.
> > > >>
> > > >> Can you share more about _why_ is it needed? If we can already obt=
ain
> > > >> most of these signals via probing, why export the flags?
> > > >>
> > > >> > Initially, these new flags are disabled for all drivers by defau=
lt.
> > > >>
> > > >> > Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > >> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > >> > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > >> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > >> > Signed-off-by: Marek Majtyka <alardam@gmail.com>
> > > >> > ---
> > > >> >   .../networking/netdev-xdp-features.rst        | 60 +++++++++++=
++++++
> > > >> >   include/linux/netdevice.h                     |  2 +
> > > >> >   include/linux/xdp_features.h                  | 64 +++++++++++=
++++++++
> > > >> >   include/uapi/linux/if_link.h                  |  7 ++
> > > >> >   include/uapi/linux/xdp_features.h             | 34 ++++++++++
> > > >> >   net/core/rtnetlink.c                          | 34 ++++++++++
> > > >> >   tools/include/uapi/linux/if_link.h            |  7 ++
> > > >> >   tools/include/uapi/linux/xdp_features.h       | 34 ++++++++++
> > > >> >   8 files changed, 242 insertions(+)
> > > >> >   create mode 100644 Documentation/networking/netdev-xdp-feature=
s.rst
> > > >> >   create mode 100644 include/linux/xdp_features.h
> > > >> >   create mode 100644 include/uapi/linux/xdp_features.h
> > > >> >   create mode 100644 tools/include/uapi/linux/xdp_features.h
> > > >>
> > > >> > diff --git a/Documentation/networking/netdev-xdp-features.rst
> > > >> > b/Documentation/networking/netdev-xdp-features.rst
> > > >> > new file mode 100644
> > > >> > index 000000000000..1dc803fe72dd
> > > >> > --- /dev/null
> > > >> > +++ b/Documentation/networking/netdev-xdp-features.rst
> > > >> > @@ -0,0 +1,60 @@
> > > >> > +.. SPDX-License-Identifier: GPL-2.0
> > > >> > +
> > > >> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >> > +Netdev XDP features
> > > >> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >> > +
> > > >> > + * XDP FEATURES FLAGS
> > > >> > +
> > > >> > +Following netdev xdp features flags can be retrieved over route=
 netlink
> > > >> > +interface (compact form) - the same way as netdev feature flags.
> > > >> > +These features flags are read only and cannot be change at runt=
ime.
> > > >> > +
> > > >> > +*  XDP_ABORTED
> > > >> > +
> > > >> > +This feature informs if netdev supports xdp aborted action.
> > > >> > +
> > > >> > +*  XDP_DROP
> > > >> > +
> > > >> > +This feature informs if netdev supports xdp drop action.
> > > >> > +
> > > >> > +*  XDP_PASS
> > > >> > +
> > > >> > +This feature informs if netdev supports xdp pass action.
> > > >> > +
> > > >> > +*  XDP_TX
> > > >> > +
> > > >> > +This feature informs if netdev supports xdp tx action.
> > > >> > +
> > > >> > +*  XDP_REDIRECT
> > > >> > +
> > > >> > +This feature informs if netdev supports xdp redirect action.
> > > >> > +It assumes the all beforehand mentioned flags are enabled.
> > > >> > +
> > > >> > +*  XDP_SOCK_ZEROCOPY
> > > >> > +
> > > >> > +This feature informs if netdev driver supports xdp zero copy.
> > > >> > +It assumes the all beforehand mentioned flags are enabled.
> > > >> > +
> > > >> > +*  XDP_HW_OFFLOAD
> > > >> > +
> > > >> > +This feature informs if netdev driver supports xdp hw oflloadin=
g.
> > > >> > +
> > > >> > +*  XDP_TX_LOCK
> > > >> > +
> > > >> > +This feature informs if netdev ndo_xdp_xmit function requires l=
ocking.
> > > >> > +
> > > >> > +*  XDP_REDIRECT_TARGET
> > > >> > +
> > > >> > +This feature informs if netdev implements ndo_xdp_xmit callback.
> > > >> > +
> > > >> > +*  XDP_FRAG_RX
> > > >> > +
> > > >> > +This feature informs if netdev implements non-linear xdp buff s=
upport in
> > > >> > +the driver napi callback.
> > > >> > +
> > > >> > +*  XDP_FRAG_TARGET
> > > >> > +
> > > >> > +This feature informs if netdev implements non-linear xdp buff s=
upport in
> > > >> > +ndo_xdp_xmit callback. XDP_FRAG_TARGET requires XDP_REDIRECT_TA=
RGET is
> > > >> > properly
> > > >> > +supported.
> > > >> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice=
=2Eh
> > > >> > index aad12a179e54..ae5a8564383b 100644
> > > >> > --- a/include/linux/netdevice.h
> > > >> > +++ b/include/linux/netdevice.h
> > > >> > @@ -43,6 +43,7 @@
> > > >> >   #include <net/xdp.h>
> > > >>
> > > >> >   #include <linux/netdev_features.h>
> > > >> > +#include <linux/xdp_features.h>
> > > >> >   #include <linux/neighbour.h>
> > > >> >   #include <uapi/linux/netdevice.h>
> > > >> >   #include <uapi/linux/if_bonding.h>
> > > >> > @@ -2362,6 +2363,7 @@ struct net_device {
> > > >> >       struct rtnl_hw_stats64  *offload_xstats_l3;
> > > >>
> > > >> >       struct devlink_port     *devlink_port;
> > > >> > +     xdp_features_t          xdp_features;
> > > >> >   };
> > > >> >   #define to_net_dev(d) container_of(d, struct net_device, dev)
> > > >>
> > > >> > diff --git a/include/linux/xdp_features.h b/include/linux/xdp_fe=
atures.h
> > > >> > new file mode 100644
> > > >> > index 000000000000..4e72a86ef329
> > > >> > --- /dev/null
> > > >> > +++ b/include/linux/xdp_features.h
> > > >> > @@ -0,0 +1,64 @@
> > > >> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > > >> > +/*
> > > >> > + * Network device xdp features.
> > > >> > + */
> > > >> > +#ifndef _LINUX_XDP_FEATURES_H
> > > >> > +#define _LINUX_XDP_FEATURES_H
> > > >> > +
> > > >> > +#include <linux/types.h>
> > > >> > +#include <linux/bitops.h>
> > > >> > +#include <asm/byteorder.h>
> > > >> > +#include <uapi/linux/xdp_features.h>
> > > >> > +
> > > >> > +typedef u32 xdp_features_t;
> > > >> > +
> > > >> > +#define __XDP_F_BIT(bit)     ((xdp_features_t)1 << (bit))
> > > >> > +#define __XDP_F(name)                __XDP_F_BIT(XDP_F_##name##=
_BIT)
> > > >> > +
> > > >> > +#define XDP_F_ABORTED                __XDP_F(ABORTED)
> > > >> > +#define XDP_F_DROP           __XDP_F(DROP)
> > > >> > +#define XDP_F_PASS           __XDP_F(PASS)
> > > >> > +#define XDP_F_TX             __XDP_F(TX)
> > > >> > +#define XDP_F_REDIRECT               __XDP_F(REDIRECT)
> > > >> > +#define XDP_F_REDIRECT_TARGET        __XDP_F(REDIRECT_TARGET)
> > > >> > +#define XDP_F_SOCK_ZEROCOPY  __XDP_F(SOCK_ZEROCOPY)
> > > >> > +#define XDP_F_HW_OFFLOAD     __XDP_F(HW_OFFLOAD)
> > > >> > +#define XDP_F_TX_LOCK                __XDP_F(TX_LOCK)
> > > >> > +#define XDP_F_FRAG_RX                __XDP_F(FRAG_RX)
> > > >> > +#define XDP_F_FRAG_TARGET    __XDP_F(FRAG_TARGET)
> > > >> > +
> > > >> > +#define XDP_F_BASIC          (XDP_F_ABORTED | XDP_F_DROP |   \
> > > >> > +                              XDP_F_PASS | XDP_F_TX)
> > > >> > +
> > > >> > +#define XDP_F_FULL           (XDP_F_BASIC | XDP_F_REDIRECT)
> > > >> > +
> > > >> > +#define XDP_F_FULL_ZC                (XDP_F_FULL | XDP_F_SOCK_Z=
EROCOPY)
> > > >> > +
> > > >> > +#define XDP_FEATURES_ABORTED_STR             "xdp-aborted"
> > > >> > +#define XDP_FEATURES_DROP_STR                        "xdp-drop"
> > > >> > +#define XDP_FEATURES_PASS_STR                        "xdp-pass"
> > > >> > +#define XDP_FEATURES_TX_STR                  "xdp-tx"
> > > >> > +#define XDP_FEATURES_REDIRECT_STR            "xdp-redirect"
> > > >> > +#define XDP_FEATURES_REDIRECT_TARGET_STR     "xdp-redirect-targ=
et"
> > > >> > +#define XDP_FEATURES_SOCK_ZEROCOPY_STR               "xdp-sock-=
zerocopy"
> > > >> > +#define XDP_FEATURES_HW_OFFLOAD_STR          "xdp-hw-offload"
> > > >> > +#define XDP_FEATURES_TX_LOCK_STR             "xdp-tx-lock"
> > > >> > +#define XDP_FEATURES_FRAG_RX_STR             "xdp-frag-rx"
> > > >> > +#define XDP_FEATURES_FRAG_TARGET_STR         "xdp-frag-target"
> > > >> > +
> > > >> > +#define DECLARE_XDP_FEATURES_TABLE(name, length)               =
              \
> > > >> > +     const char name[][length] =3D {                           =
                \
> > > >> > +             [XDP_F_ABORTED_BIT] =3D XDP_FEATURES_ABORTED_STR, =
                \
> > > >> > +             [XDP_F_DROP_BIT] =3D XDP_FEATURES_DROP_STR,       =
                \
> > > >> > +             [XDP_F_PASS_BIT] =3D XDP_FEATURES_PASS_STR,       =
                \
> > > >> > +             [XDP_F_TX_BIT] =3D XDP_FEATURES_TX_STR,           =
                \
> > > >> > +             [XDP_F_REDIRECT_BIT] =3D XDP_FEATURES_REDIRECT_STR=
,               \
> > > >> > +             [XDP_F_REDIRECT_TARGET_BIT] =3D XDP_FEATURES_REDIR=
ECT_TARGET_STR, \
> > > >> > +             [XDP_F_SOCK_ZEROCOPY_BIT] =3D XDP_FEATURES_SOCK_ZE=
ROCOPY_STR,     \
> > > >> > +             [XDP_F_HW_OFFLOAD_BIT] =3D XDP_FEATURES_HW_OFFLOAD=
_STR,           \
> > > >> > +             [XDP_F_TX_LOCK_BIT] =3D XDP_FEATURES_TX_LOCK_STR, =
                \
> > > >> > +             [XDP_F_FRAG_RX_BIT] =3D XDP_FEATURES_FRAG_RX_STR, =
                \
> > > >> > +             [XDP_F_FRAG_TARGET_BIT] =3D XDP_FEATURES_FRAG_TARG=
ET_STR,         \
> > > >> > +     }
> > > >> > +
> > > >> > +#endif /* _LINUX_XDP_FEATURES_H */
> > > >> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/i=
f_link.h
> > > >> > index 1021a7e47a86..971c658ceaea 100644
> > > >> > --- a/include/uapi/linux/if_link.h
> > > >> > +++ b/include/uapi/linux/if_link.h
> > > >> > @@ -374,6 +374,8 @@ enum {
> > > >>
> > > >> >       IFLA_DEVLINK_PORT,
> > > >>
> > > >> > +     IFLA_XDP_FEATURES,
> > > >> > +
> > > >> >       __IFLA_MAX
> > > >> >   };
> > > >>
> > > >> > @@ -1318,6 +1320,11 @@ enum {
> > > >>
> > > >> >   #define IFLA_XDP_MAX (__IFLA_XDP_MAX - 1)
> > > >>
> > > >> > +enum {
> > > >> > +     IFLA_XDP_FEATURES_WORD_UNSPEC =3D 0,
> > > >> > +     IFLA_XDP_FEATURES_BITS_WORD,
> > > >> > +};
> > > >> > +
> > > >> >   enum {
> > > >> >       IFLA_EVENT_NONE,
> > > >> >       IFLA_EVENT_REBOOT,              /* internal reset / reboot=
 */
> > > >> > diff --git a/include/uapi/linux/xdp_features.h
> > > >> > b/include/uapi/linux/xdp_features.h
> > > >> > new file mode 100644
> > > >> > index 000000000000..48eb42069bcd
> > > >> > --- /dev/null
> > > >> > +++ b/include/uapi/linux/xdp_features.h
> > > >> > @@ -0,0 +1,34 @@
> > > >> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > > >> > +/*
> > > >> > + * Copyright (c) 2020 Intel
> > > >> > + */
> > > >> > +
> > > >> > +#ifndef __UAPI_LINUX_XDP_FEATURES__
> > > >> > +#define __UAPI_LINUX_XDP_FEATURES__
> > > >> > +
> > > >> > +enum {
> > > >> > +     XDP_F_ABORTED_BIT,
> > > >> > +     XDP_F_DROP_BIT,
> > > >> > +     XDP_F_PASS_BIT,
> > > >> > +     XDP_F_TX_BIT,
> > > >> > +     XDP_F_REDIRECT_BIT,
> > > >> > +     XDP_F_REDIRECT_TARGET_BIT,
> > > >> > +     XDP_F_SOCK_ZEROCOPY_BIT,
> > > >> > +     XDP_F_HW_OFFLOAD_BIT,
> > > >> > +     XDP_F_TX_LOCK_BIT,
> > > >> > +     XDP_F_FRAG_RX_BIT,
> > > >> > +     XDP_F_FRAG_TARGET_BIT,
> > > >> > +     /*
> > > >> > +      * Add your fresh new property above and remember to update
> > > >> > +      * documentation.
> > > >> > +      */
> > > >> > +     XDP_FEATURES_COUNT,
> > > >> > +};
> > > >> > +
> > > >> > +#define XDP_FEATURES_WORDS                   ((XDP_FEATURES_COU=
NT + 32 - 1) / 32)
> > > >> > +#define XDP_FEATURES_WORD(blocks, index)     ((blocks)[(index) =
/ 32U])
> > > >> > +#define XDP_FEATURES_FIELD_FLAG(index)               (1U << (in=
dex) % 32U)
> > > >> > +#define XDP_FEATURES_BIT_IS_SET(blocks, index)        \
> > > >> > +     (XDP_FEATURES_WORD(blocks, index) & XDP_FEATURES_FIELD_FLA=
G(index))
> > > >> > +
> > > >> > +#endif  /* __UAPI_LINUX_XDP_FEATURES__ */
> > > >> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > > >> > index 64289bc98887..1c299746b614 100644
> > > >> > --- a/net/core/rtnetlink.c
> > > >> > +++ b/net/core/rtnetlink.c
> > > >> > @@ -1016,6 +1016,14 @@ static size_t rtnl_xdp_size(void)
> > > >> >       return xdp_size;
> > > >> >   }
> > > >>
> > > >> > +static size_t rtnl_xdp_features_size(void)
> > > >> > +{
> > > >> > +     size_t xdp_size =3D nla_total_size(0) +   /* nest IFLA_XDP=
_FEATURES */
> > > >> > +                       XDP_FEATURES_WORDS * nla_total_size(4);
> > > >> > +
> > > >> > +     return xdp_size;
> > > >> > +}
> > > >> > +
> > > >> >   static size_t rtnl_prop_list_size(const struct net_device *dev)
> > > >> >   {
> > > >> >       struct netdev_name_node *name_node;
> > > >> > @@ -1103,6 +1111,7 @@ static noinline size_t if_nlmsg_size(const=
 struct
> > > >> > net_device *dev,
> > > >> >              + rtnl_prop_list_size(dev)
> > > >> >              + nla_total_size(MAX_ADDR_LEN) /* IFLA_PERM_ADDRESS=
 */
> > > >> >              + rtnl_devlink_port_size(dev)
> > > >> > +            + rtnl_xdp_features_size() /* IFLA_XDP_FEATURES */
> > > >> >              + 0;
> > > >> >   }
> > > >>
> > > >> > @@ -1546,6 +1555,27 @@ static int rtnl_xdp_fill(struct sk_buff *=
skb,
> > > >> > struct net_device *dev)
> > > >> >       return err;
> > > >> >   }
> > > >>
> > > >> > +static int rtnl_xdp_features_fill(struct sk_buff *skb, struct n=
et_device
> > > >> > *dev)
> > > >> > +{
> > > >> > +     struct nlattr *attr;
> > > >> > +
> > > >> > +     attr =3D nla_nest_start_noflag(skb, IFLA_XDP_FEATURES);
> > > >> > +     if (!attr)
> > > >> > +             return -EMSGSIZE;
> > > >> > +
> > > >> > +     BUILD_BUG_ON(XDP_FEATURES_WORDS !=3D 1);
> > > >> > +     if (nla_put_u32(skb, IFLA_XDP_FEATURES_BITS_WORD, dev->xdp=
_features))
> > > >> > +             goto err_cancel;
> > > >> > +
> > > >> > +     nla_nest_end(skb, attr);
> > > >> > +
> > > >> > +     return 0;
> > > >> > +
> > > >> > +err_cancel:
> > > >> > +     nla_nest_cancel(skb, attr);
> > > >> > +     return -EMSGSIZE;
> > > >> > +}
> > > >> > +
> > > >> >   static u32 rtnl_get_event(unsigned long event)
> > > >> >   {
> > > >> >       u32 rtnl_event_type =3D IFLA_EVENT_NONE;
> > > >> > @@ -1904,6 +1934,9 @@ static int rtnl_fill_ifinfo(struct sk_buff=
 *skb,
> > > >> >       if (rtnl_fill_devlink_port(skb, dev))
> > > >> >               goto nla_put_failure;
> > > >>
> > > >> > +     if (rtnl_xdp_features_fill(skb, dev))
> > > >> > +             goto nla_put_failure;
> > > >> > +
> > > >> >       nlmsg_end(skb, nlh);
> > > >> >       return 0;
> > > >>
> > > >> > @@ -1968,6 +2001,7 @@ static const struct nla_policy
> > > >> > ifla_policy[IFLA_MAX+1] =3D {
> > > >> >       [IFLA_TSO_MAX_SIZE]     =3D { .type =3D NLA_REJECT },
> > > >> >       [IFLA_TSO_MAX_SEGS]     =3D { .type =3D NLA_REJECT },
> > > >> >       [IFLA_ALLMULTI]         =3D { .type =3D NLA_REJECT },
> > > >> > +     [IFLA_XDP_FEATURES]     =3D { .type =3D NLA_NESTED },
> > > >> >   };
> > > >>
> > > >> >   static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+=
1] =3D {
> > > >> > diff --git a/tools/include/uapi/linux/if_link.h
> > > >> > b/tools/include/uapi/linux/if_link.h
> > > >> > index 82fe18f26db5..994228e9909a 100644
> > > >> > --- a/tools/include/uapi/linux/if_link.h
> > > >> > +++ b/tools/include/uapi/linux/if_link.h
> > > >> > @@ -354,6 +354,8 @@ enum {
> > > >>
> > > >> >       IFLA_DEVLINK_PORT,
> > > >>
> > > >> > +     IFLA_XDP_FEATURES,
> > > >> > +
> > > >> >       __IFLA_MAX
> > > >> >   };
> > > >>
> > > >> > @@ -1222,6 +1224,11 @@ enum {
> > > >>
> > > >> >   #define IFLA_XDP_MAX (__IFLA_XDP_MAX - 1)
> > > >>
> > > >> > +enum {
> > > >> > +     IFLA_XDP_FEATURES_WORD_UNSPEC =3D 0,
> > > >> > +     IFLA_XDP_FEATURES_BITS_WORD,
> > > >> > +};
> > > >> > +
> > > >> >   enum {
> > > >> >       IFLA_EVENT_NONE,
> > > >> >       IFLA_EVENT_REBOOT,              /* internal reset / reboot=
 */
> > > >> > diff --git a/tools/include/uapi/linux/xdp_features.h
> > > >> > b/tools/include/uapi/linux/xdp_features.h
> > > >> > new file mode 100644
> > > >> > index 000000000000..48eb42069bcd
> > > >> > --- /dev/null
> > > >> > +++ b/tools/include/uapi/linux/xdp_features.h
> > > >> > @@ -0,0 +1,34 @@
> > > >> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > > >> > +/*
> > > >> > + * Copyright (c) 2020 Intel
> > > >> > + */
> > > >> > +
> > > >> > +#ifndef __UAPI_LINUX_XDP_FEATURES__
> > > >> > +#define __UAPI_LINUX_XDP_FEATURES__
> > > >> > +
> > > >> > +enum {
> > > >> > +     XDP_F_ABORTED_BIT,
> > > >> > +     XDP_F_DROP_BIT,
> > > >> > +     XDP_F_PASS_BIT,
> > > >> > +     XDP_F_TX_BIT,
> > > >> > +     XDP_F_REDIRECT_BIT,
> > > >> > +     XDP_F_REDIRECT_TARGET_BIT,
> > > >> > +     XDP_F_SOCK_ZEROCOPY_BIT,
> > > >> > +     XDP_F_HW_OFFLOAD_BIT,
> > > >> > +     XDP_F_TX_LOCK_BIT,
> > > >> > +     XDP_F_FRAG_RX_BIT,
> > > >> > +     XDP_F_FRAG_TARGET_BIT,
> > > >> > +     /*
> > > >> > +      * Add your fresh new property above and remember to update
> > > >> > +      * documentation.
> > > >> > +      */
> > > >> > +     XDP_FEATURES_COUNT,
> > > >> > +};
> > > >> > +
> > > >> > +#define XDP_FEATURES_WORDS                   ((XDP_FEATURES_COU=
NT + 32 - 1) / 32)
> > > >> > +#define XDP_FEATURES_WORD(blocks, index)     ((blocks)[(index) =
/ 32U])
> > > >> > +#define XDP_FEATURES_FIELD_FLAG(index)               (1U << (in=
dex) % 32U)
> > > >> > +#define XDP_FEATURES_BIT_IS_SET(blocks, index)        \
> > > >> > +     (XDP_FEATURES_WORD(blocks, index) & XDP_FEATURES_FIELD_FLA=
G(index))
> > > >> > +
> > > >> > +#endif  /* __UAPI_LINUX_XDP_FEATURES__ */
> > > >> > --
> > > >> > 2.38.1
> > > >>
> > >

--2lNipPbgN3x5Io4s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY6I2UwAKCRA6cBh0uS2t
rI8SAP0Rks4RjZXJgMS9v+cDn/l5aBpGeaG6xJdEAbiCiJ3mgAEArOzUwXGj3kR/
oVilRuZdDqan/DvK+NRXbXCmWrNu6wg=
=5QFn
-----END PGP SIGNATURE-----

--2lNipPbgN3x5Io4s--
