Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0D967731B
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 00:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjAVXAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 18:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjAVXAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 18:00:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862D618ABD;
        Sun, 22 Jan 2023 15:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E07DB80AD7;
        Sun, 22 Jan 2023 23:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28557C433D2;
        Sun, 22 Jan 2023 23:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674428419;
        bh=l6sVcqmyQgy5kjC6EfqdlezzQu1gDTlLgDSd7U2cr58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WfR7vjIzJ9uGSElCjnLKxQq4fB3r1scO0Iql0EGNmSod+foUQpKcrurt58tKZL5PG
         jjnVeWbnbo7GyiEDNsNMaroIV9YZuPT9dTzC+Q9Vdwyc2H+kx7Iad3m4HwZlf6Gb3i
         0k0t66tEB4dHWooYdjTxGqImNx0meH57RMOH0U1lBF3S08n4q1k0C1SdKpmliazwEG
         c/OgeLPmIHSz2xrkcHKWLcwANcX1NDztI0gJbJbbH+B+Q+LfeR61IyRLtnKiQZMZQG
         GhGg47OrVdiW+4pININTNVpU9UVyxkg7p9yIiyJ5Mo3R6ordXXnkf7aKCYfFIaZTQ+
         VEpvFYGdD4trw==
Date:   Mon, 23 Jan 2023 00:00:15 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, niklas.soderlund@corigine.com
Subject: Re: [PATCH bpf-next 1/7] netdev-genl: create a simple family for
 netdev stuff
Message-ID: <Y82//2EX6QQoZkV/@lore-desk>
References: <cover.1674234430.git.lorenzo@kernel.org>
 <272fa19f57de2d14e9666b4cd9b1ae8a61a94807.1674234430.git.lorenzo@kernel.org>
 <20230120191126.06c9d514@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Tja5EzIgFqyLPfdS"
Content-Disposition: inline
In-Reply-To: <20230120191126.06c9d514@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Tja5EzIgFqyLPfdS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 20 Jan 2023 18:16:50 +0100 Lorenzo Bianconi wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> >=20
> > Add a Netlink spec-compatible family for netdevs.
> > This is a very simple implementation without much
> > thought going into it.
> >=20
> > It allows us to reap all the benefits of Netlink specs,
> > one can use the generic client to issue the commands:
> >=20
> >   $ ./gen.py --spec netdev.yaml --do dev_get --json=3D'{"ifindex": 2}'
> >   {'ifindex': 2, 'xdp-features': 31}
> >=20
> >   $ ./gen.py --spec netdev.yaml --dump dev_get
> >   [{'ifindex': 1, 'xdp-features': 0}, {'ifindex': 2, 'xdp-features': 31=
}]
>=20
> In the meantime I added support for rendering enums in Python.
> So you can show names in the example. eg:
>=20
> $ ./cli.py --spec netdev.yaml --dump dev_get=20
> [{'ifindex': 1, 'xdp-features': set()},
>  {'ifindex': 2,
>   'xdp-features': {'ndo-xmit', 'pass', 'redirect', 'aborted', 'drop'}},
>  {'ifindex': 3, 'xdp-features': {'rx-sg'}}]
>=20
> > the generic python library does not have flags-by-name
> > support, yet, but we also don't have to carry strings
> > in the messages, as user space can get the names from
> > the spec.
> >=20
> > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Co-developed-by: Marek Majtyka <alardam@gmail.com>
> > Signed-off-by: Marek Majtyka <alardam@gmail.com>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  Documentation/netlink/specs/netdev.yaml |  72 ++++++++++
>=20
> FWIW I'm not 100% sure if we should scope the family to all of netdev
> or just xdp. Same for the name of the op, should we call the op dev_get
> or dev_xdp_get..

is it likely we are going to add non-xdp info here in the near future? If n=
ot
I would say we can target just xdp for the moment.

>=20
> > diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> > new file mode 100644
> > index 000000000000..254fc336d469
> > --- /dev/null
> > +++ b/include/uapi/linux/netdev.h
> > @@ -0,0 +1,66 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +/* Do not edit directly, auto-generated from: */
>=20
> Like this line says, you can't hand edit this file.
> Next time someone adds an attribute all your changes will be wiped.

ack, right.

>=20
> > +/*	Documentation/netlink/specs/netdev.yaml */
> > +/* YNL-GEN uapi header */
> > +
> > +#ifndef _UAPI_LINUX_NETDEV_H
> > +#define _UAPI_LINUX_NETDEV_H
> > +
> > +#define NETDEV_FAMILY_NAME	"netdev"
> > +#define NETDEV_FAMILY_VERSION	1
> > +
> > +enum netdev_xdp_act {
> > +	NETDEV_XDP_ACT_ABORTED_BIT,
> > +	NETDEV_XDP_ACT_DROP_BIT,
> > +	NETDEV_XDP_ACT_PASS_BIT,
> > +	NETDEV_XDP_ACT_TX_BIT,
> > +	NETDEV_XDP_ACT_REDIRECT_BIT,
> > +	NETDEV_XDP_ACT_NDO_XMIT_BIT,
> > +	NETDEV_XDP_ACT_XSK_ZEROCOPY_BIT,
> > +	NETDEV_XDP_ACT_HW_OFFLOAD_BIT,
> > +	NETDEV_XDP_ACT_RX_SG_BIT,
> > +	NETDEV_XDP_ACT_NDO_XMIT_SG_BIT
>=20
> You need to add -bit to all the enum names in the yaml if you want=20
> to have _BIT in the name here.

ack, I do not think it is needed (according to the comment below).

>=20
> > +};
> > +
> > +#define NETDEV_XDP_ACT_ABORTED		BIT(NETDEV_XDP_ACT_ABORTED_BIT)
> > +#define NETDEV_XDP_ACT_DROP		BIT(NETDEV_XDP_ACT_DROP_BIT)
> > +#define NETDEV_XDP_ACT_PASS		BIT(NETDEV_XDP_ACT_PASS_BIT)
> > +#define NETDEV_XDP_ACT_TX		BIT(NETDEV_XDP_ACT_TX_BIT)
> > +#define NETDEV_XDP_ACT_REDIRECT		BIT(NETDEV_XDP_ACT_REDIRECT_BIT)
> > +#define NETDEV_XDP_ACT_NDO_XMIT		BIT(NETDEV_XDP_ACT_NDO_XMIT_BIT)
> > +#define NETDEV_XDP_ACT_XSK_ZEROCOPY	BIT(NETDEV_XDP_ACT_XSK_ZEROCOPY_BI=
T)
> > +#define NETDEV_XDP_ACT_HW_OFFLOAD	BIT(NETDEV_XDP_ACT_HW_OFFLOAD_BIT)
> > +#define NETDEV_XDP_ACT_RX_SG		BIT(NETDEV_XDP_ACT_RX_SG_BIT)
> > +#define NETDEV_XDP_ACT_NDO_XMIT_SG	BIT(NETDEV_XDP_ACT_NDO_XMIT_SG_BIT)
> > +
> > +#define NETDEV_XDP_ACT_BASIC		(NETDEV_XDP_ACT_DROP |	\
> > +					 NETDEV_XDP_ACT_PASS |	\
> > +					 NETDEV_XDP_ACT_TX |	\
> > +					 NETDEV_XDP_ACT_ABORTED)
> > +#define NETDEV_XDP_ACT_FULL		(NETDEV_XDP_ACT_BASIC |	\
> > +					 NETDEV_XDP_ACT_REDIRECT)
> > +#define NETDEV_XDP_ACT_ZC		(NETDEV_XDP_ACT_FULL |	\
> > +					 NETDEV_XDP_ACT_XSK_ZEROCOPY)
>=20
> These defines don't belong in uAPI. Especially the use of BIT().

since netdev xdp_features is a bitmask, can we use 'flags' as type for defi=
nitions in
netdev.yaml so we can get rid of this BIT() definitions for both user and
kernel space?

>=20
> > +			if (err < 0)
> > +				break;
> > +cont:
> > +			idx++;
> > +		}
> > +	}
> > +
> > +	rtnl_unlock();
> > +
> > +	if (err !=3D -EMSGSIZE)
> > +		return err;
> > +
> > +	cb->args[1] =3D idx;
> > +	cb->args[0] =3D h;
> > +	cb->seq =3D net->dev_base_seq;
> > +	nl_dump_check_consistent(cb, nlmsg_hdr(skb));
>=20
> I think that this line can be dropped.

ack, I will fix it.

Regards,
Lorenzo

>=20
> > +	return skb->len;
> > +}

--Tja5EzIgFqyLPfdS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY82//wAKCRA6cBh0uS2t
rPB3AQDozI0/knJ+CUWwlkYtcNHhL3s7GTUfjpU86CHD012vLAEAhzCxQ0vO1izj
6uyMaGBsZxg3v/0H7LDsPSmw8+lloww=
=aNj9
-----END PGP SIGNATURE-----

--Tja5EzIgFqyLPfdS--
