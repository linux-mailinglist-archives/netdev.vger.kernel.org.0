Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8C8119CFE
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfLJWfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:35:04 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:35805 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727427AbfLJWfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 17:35:03 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47XZcx5kMkz9sS8;
        Wed, 11 Dec 2019 09:34:57 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1576017300;
        bh=jMelgaoY2YVu2U1fG/AHlQ4glmuVPCJvHyn0RjP4iOo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q2RFFgseM6kD3z7fostLllZY/5UCm67D4hQss4rwT7awNS0TvHiOFE3j902qDWO3L
         gOoEJ9anWy0fFyzVm37l3xkdzh2p5LBZ2HLmsxN9iz38lJslK97BSFUIknMNUlDuTB
         gIxCNPulcTiL7Ro3PaevaJfGkMUy1UMZLGGLZop690Q+2ABuUW8wgf7FBIV13VpSLj
         OIdJKYkAl0v6gXvKrjyWI9S4TYNW6TTx4WmGvGqMJp72743c/tNbYlGMW4aoYBklph
         LG3qmF7hWHdeHr8jv5pSMAoDOW9K4h9HLhNGnAETws26bUY27mPQHvF2EsWgirDlNW
         uEZJohI+/5L2Q==
Date:   Wed, 11 Dec 2019 09:34:49 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: linux-next: Tree for Dec 10 (ethernet/8390/8390p.c)
Message-ID: <20191211093449.0932cef4@canb.auug.org.au>
In-Reply-To: <ce89aa80-558c-1ccb-afbe-0af6bc4f3e19@infradead.org>
References: <20191210140225.1aa0c90e@canb.auug.org.au>
        <ce89aa80-558c-1ccb-afbe-0af6bc4f3e19@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7LARfLRMNLloF/0HH__5J_H";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/7LARfLRMNLloF/0HH__5J_H
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Mon, 9 Dec 2019 23:13:34 -0800 Randy Dunlap <rdunlap@infradead.org> wrot=
e:
>
> On 12/9/19 7:02 PM, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Changes since 20191209:
> >  =20
>=20
> on i386:
>=20
> ../drivers/net/ethernet/8390/8390p.c:44:6: error: conflicting types for =
=E2=80=98eip_tx_timeout=E2=80=99
>  void eip_tx_timeout(struct net_device *dev, unsigned int txqueue)
>       ^~~~~~~~~~~~~~
> In file included from ../drivers/net/ethernet/8390/lib8390.c:75:0,
>                  from ../drivers/net/ethernet/8390/8390p.c:12:
> ../drivers/net/ethernet/8390/8390.h:53:6: note: previous declaration of =
=E2=80=98eip_tx_timeout=E2=80=99 was here
>  void eip_tx_timeout(struct net_device *dev);
>       ^~~~~~~~~~~~~~

Looks like this has been fixed for today (in the vhost tree).
--=20
Cheers,
Stephen Rothwell

--Sig_/7LARfLRMNLloF/0HH__5J_H
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3wHYkACgkQAVBC80lX
0Gy1zQf/XBlLXFyjf2UIu0lqNQyKeWdtnjgqXuqcFOQtDqhdZ1u1ulVlNP6DQllI
oS7FFzxgOUf/yj1rWFLc/MoXE9Gx7TxwiSwphiGgw1A1/2mpD3ARKhVnwUeConM/
uJnBvgvWbpKnkuEdxl/HmAf31/R3eqrKwjOBvDb0eutvuFVr0dzkg8fadtu7zqRz
gRBVxsmqtP7KNfHjBtTZu4AyarX57ry7bZ+zTal9zvML7kKCyYYRp0xtqkn30EWC
jNkvGM9HDbKT7MSLoxctSTYvW4I+OQKfJSZQFPFPCIYEtnHw7SPtUGzq44O2Z+hs
a90M1MwaouLwQLFDfghQRpHmWRwPgA==
=9FkA
-----END PGP SIGNATURE-----

--Sig_/7LARfLRMNLloF/0HH__5J_H--
