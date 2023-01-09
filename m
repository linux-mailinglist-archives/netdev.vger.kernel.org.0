Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7711F662256
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 11:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbjAIKCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 05:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbjAIKBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 05:01:44 -0500
X-Greylist: delayed 389 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 09 Jan 2023 02:01:39 PST
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0CB530A
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 02:01:37 -0800 (PST)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id CB1AC83288;
        Mon,  9 Jan 2023 09:55:06 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1673258107; bh=5uHc/RjYjIJ4W5dN43QMh92n28CCPm20KvZgEz1TmN0=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Mon,=209=20Jan=202023=2009:55:06=20+0000|From:=20Tom=20Pa
         rkin=20<tparkin@katalix.com>|To:=20Guillaume=20Nault=20<gnault@red
         hat.com>|Cc:=20Cong=20Wang=20<xiyou.wangcong@gmail.com>,=20netdev@
         vger.kernel.org,=0D=0A=09g.nault@alphalink.fr,=20Cong=20Wang=20<co
         ng.wang@bytedance.com>,=0D=0A=09Tetsuo=20Handa=20<penguin-kernel@i
         -love.sakura.ne.jp>,=0D=0A=09Jakub=20Sitnicki=20<jakub@cloudflare.
         com>,=0D=0A=09Eric=20Dumazet=20<edumazet@google.com>|Subject:=20Re
         :=20[Patch=20net=201/2]=20l2tp:=20convert=20l2tp_tunnel_list=20to=
         20idr|Message-ID:=20<20230109095506.GA29862@katalix.com>|Reference
         s:=20<20230105191339.506839-1-xiyou.wangcong@gmail.com>=0D=0A=20<2
         0230105191339.506839-2-xiyou.wangcong@gmail.com>=0D=0A=20<Y7nMo02W
         WWwoGmv0@debian>|MIME-Version:=201.0|Content-Disposition:=20inline
         |In-Reply-To:=20<Y7nMo02WWWwoGmv0@debian>;
        b=CRWiVw7ZezxsoFbCgLqOg/LYB4gkyZmmfEf6BQuVUSiK+jFXUHdJpwWeExFFRenBi
         P8uz0WeKDbDHXVVoVekjwH+8UimkGeS3mmmHV0XRK5qhiQQqb+b06jp+wtc6soBLrq
         zMEFsrdWvvxs8ZyPNTXMn4uo2XFHHmXwjpDmdZe+CzDFMxYvo3A24JVWxmend/bvtp
         UtjZ4KzfVnpEwCabxJlODL2k3RRBoi9M2oaEQF5rL49wBsWC+Lru1LBUJFtIILO00n
         QoMXxcAw7pdPpuK5hZfQr+IpzQnI0tGx5DQrnnTw+Jat/6k9o0PVgKBPl87nt5DTl9
         bwX+awQCbDOIw==
Date:   Mon, 9 Jan 2023 09:55:06 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        g.nault@alphalink.fr, Cong Wang <cong.wang@bytedance.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net 1/2] l2tp: convert l2tp_tunnel_list to idr
Message-ID: <20230109095506.GA29862@katalix.com>
References: <20230105191339.506839-1-xiyou.wangcong@gmail.com>
 <20230105191339.506839-2-xiyou.wangcong@gmail.com>
 <Y7nMo02WWWwoGmv0@debian>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <Y7nMo02WWWwoGmv0@debian>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Sat, Jan 07, 2023 at 20:48:51 +0100, Guillaume Nault wrote:
> On Thu, Jan 05, 2023 at 11:13:38AM -0800, Cong Wang wrote:
> > +int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunne=
l_id,
> > +		       u32 peer_tunnel_id, struct l2tp_tunnel_cfg *cfg,
> > +		       struct l2tp_tunnel **tunnelp)
> >  {
> >  	struct l2tp_tunnel *tunnel =3D NULL;
> >  	int err;
> >  	enum l2tp_encap_type encap =3D L2TP_ENCAPTYPE_UDP;
> > +	struct l2tp_net *pn =3D l2tp_pernet(net);
> > =20
> >  	if (cfg)
> >  		encap =3D cfg->encap;
> > =20
> > +	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
> > +	err =3D idr_alloc_u32(&pn->l2tp_tunnel_idr, NULL, &tunnel_id, tunnel_=
id,
> > +			    GFP_ATOMIC);
> > +	if (err) {
> > +		spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
> > +		return err;
> > +	}
> > +	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
>=20
> Why reserving the tunnel_id in l2tp_tunnel_create()? This function is
> supposed to just allocate a structure and pre-initialise some fields.
> The only cleanup required upon error after this call is to kfree() the
> new structure. So I can't see any reason to guarantee the id will be
> accepted by the future l2tp_tunnel_register() call.
>=20
> Looks like you could reserve the id at the beginning of
> l2tp_tunnel_register() instead. That'd avoid changing the API and thus
> the side effects on l2tp_{ppp,netlink}.c. Also we wouldn't need create
> l2tp_tunnel_remove().
>=20

FWIW I also think that'd make more sense, and leave callsites will
less tidyup to do on behalf of l2tp_core.

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmO75HYACgkQlIwGZQq6
i9ASmAf/c59PRMPkTW1kfnu6YQFL/rVThTA6yWpPHPsAZBVw4znaPeKRs+ZutJd9
qN2fDdPyd7tigUvE/D6nc60hdu8+3qspMdqZKGWlgHhckofzwrUvX7Rn96yjXPDo
c7+Jbgp76BwoiCOX2ZR60mPIfg2L+btamRetZbS2AHWqRoLzezLsjDcSYMDu0We0
2H21crmUfqjqNlrVw0fa6/ztV23lUyCCLeAh7cQz7sa/vxFrJYmhnNwx3O3sRxRD
/T7qc1z2XRPYqAnpBVU5gxTW5EeaheIe+O/N4pPLuQVhYi6XcbYKGuEXSB8ukefK
eDTf41VOSnEEcVcYal0OCUm3ggtT5w==
=48oS
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
