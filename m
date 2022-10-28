Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD63611C8B
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 23:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJ1VnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 17:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ1VnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 17:43:23 -0400
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 284FB23B692;
        Fri, 28 Oct 2022 14:43:20 -0700 (PDT)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 8A5F14C2A;
        Fri, 28 Oct 2022 23:43:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202205; t=1666993396;
        bh=y7K9PONvKZDYwapSJD9Iz8C+eQXsRfCdkof021u6vt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dbm0L4V+CNKuQ54YVvLyu0D+VLCzvNpX1f3J0lDst91HxwVwVdIWXiJUfCn13xDWZ
         qbXa8KdajCif3F+87ENtYv3WdiSQCi+qrMhME72Mdmh/kMgKNrg7+7SpjbnoHGaO9D
         7fEI45YYd9dd5F4RREyHkG6gXCsYb4yCWyxz7sxXKeS9ilZzIzxZ7JKb07d9+5+o4s
         BVuxDV0L0rNKOgaQmrNSCFRCPUZgpJTKV95ZJcVqBGpOeXYeje44CqQxDmUR0S5IEJ
         mRQ5ZKYi0C3j0UXbq6RrUgxj+4V8LgkvsQ4yXOxkDT4QO7j2PHEGGnGZbBy5XzwfKY
         LQz/quOTz7ImpQth1okIFc3/TEONMrIYjGfVfUIgal9O62mlTrdrcCj81G2R8VLIT/
         BsLXeKFYYzy4GWXoA0sdt4/UWPy6aLXaAWLoK+sSKDsY51OvzOIvl/q4b2ZBh7/aPn
         HlvdOZ1feskHfM6P0+/Evu3tMnzCA6eJ68k2eXdglejfbEgaE2AfW+0ZuxrUuO9CkR
         2rbfFB7ZWnSz2scC9rRebWVx6JnrUGjb2BAwMuBrDWHeWZRwxD1O7gs0YjVSn5WoB+
         2hsTrZqY9V9wYmjc9BUu0amkVwOsykWnl9P/lVAeW/SKDq67YV72Ge0DXqn+a6y2OM
         dCjuPx6Qi4ddAUws7I/yE8os=
Date:   Fri, 28 Oct 2022 23:43:15 +0200
From:   =?utf-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub =?utf-8?B?S2ljacWEc2tp?= <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 01/15] hamradio: baycom: remove BAYCOM_MAGIC
Message-ID: <20221028214315.eca73g3c2z6w7kq2@tarta.nabijaczleweli.xyz>
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
 <47c2bffb-6bfe-7f5d-0d2d-3cbb99d31019@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yloaufuzlogzmaxw"
Content-Disposition: inline
In-Reply-To: <47c2bffb-6bfe-7f5d-0d2d-3cbb99d31019@gmail.com>
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yloaufuzlogzmaxw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 28, 2022 at 08:13:49PM +0700, Bagas Sanjaya wrote:
> On 10/27/22 05:42, =D0=BD=D0=B0=D0=B1 wrote:
> > Since defanging in v2.6.12-rc1 it's set exactly once per port on probe
> > and checked exactly once per port on unload: it's useless. Kill it.
> >=20
>=20
> What do you mean by defanging in that release?

Before v2.6.12-rc1, there were baycom_paranoia_check{,_void}() macros
(which logged at KERN_ERR and returned an error),
used before each netdev_priv(); after, this is reduced to the single
check in the cleanup we observe presently.

I've rephrased the message to make it more palatable.

Best,

--yloaufuzlogzmaxw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNcTPMACgkQvP0LAY0m
WPFpWA//XYPw3pazlJArbmYFjmqdw+ksxt3w4aGfsvnRxLacZpXj78QSTw8iY/bA
aQYkiXn39/o4WCBaP5v/8mTQRPAgSgJKapWe4i0kosBxJMaDh/S4SCbE99Y1UuzM
p0AZEOl1zuWhpvzPrejnuQaaPOLQ5qpyMTYoQonRsTDn+FNs9G0br1rN3eQ5sp0d
k73XujMsnLl1MEnZQXwrShrBH5fjebiEUEPiKmml5vg+Lpe8K37YjPdhXlQp3Svy
CLINbuZnqgEeUeDYjZs6yUQy4ZfMO3e97k+F/SY3RDIxGQahiTyN6NSDDR/jN0cL
gyDPMj2sEtHk+bIkbWyZ75nfbF3xx2J1/Er8oZOkwLOHhAa1XQb721xMCITbT2pw
FrUnGpQd8dT18nToQqFQ9bcTlOCFcW1kwAHxkH8wMvqcj39/6VNtjn48wDE3qJpE
Lzo5oP6JYOeHNk0O1h1FLFmR1oAG/Q9Bc13+kPo++KUAeSs5872eVsA7C4HkRI83
2pPcP+gUdLlJbKdBK0U+9Eo3pnEGevDkV/cBBZX4c0o3XtkKAlIEc3iZxbTrbOc2
FWPe6jhP9Uijjlq4aUfAnxK1ZWr3P0mXB3pjOW9POz3nZcNb75x37J3Rxb0lqqvX
KNqUjcesaCfTkRYJFZvcvHPxvxOoq783njwfYWYNYDCPnjzzEd4=
=DS+Y
-----END PGP SIGNATURE-----

--yloaufuzlogzmaxw--
