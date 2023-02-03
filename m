Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7E2688D1A
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 03:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjBCCdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 21:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjBCCdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 21:33:15 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1016C1F4A3;
        Thu,  2 Feb 2023 18:33:12 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P7KSy3YQ9z4xP9;
        Fri,  3 Feb 2023 13:33:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1675391586;
        bh=0d4/aEilgXUqCbcBQslhSsYyGVYHLsagJzjvXC+oH/M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L/BgImaGy8COTEl8cGbc9FskqOm3LNE0RFi1YLJZJacCQef1K9WbtmylyxrzceaR9
         dXYVICpAimvkH8Bwt9s1PRjmLQCZSb26rQYds2uI4LFaLeu2kX8pfTb9d/lrBfB+4d
         pm3E7releT0zox4krMyEzyLxJtZOdLn28zZd7KwAu8jcquAKP4j7GoLfe5uRpEgsFL
         JXcvJcnTaDgNLr8RsNXh2RSGTJng0aqaywAy09UAO0z19GMCduX9/I6mQD9sjb0Svf
         EsCCMX0jPxkqRiCAfSSJqqKE7MgPdZEpygotVhAhVmMoCIW8VV1wyL3Ao6jMKqb4XW
         8Yj261YD8L4eA==
Date:   Fri, 3 Feb 2023 13:33:03 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: duplicate patches in the vhost tree
Message-ID: <20230203133303.5cf19f41@canb.auug.org.au>
In-Reply-To: <20230203132629.30cf161c@canb.auug.org.au>
References: <20230203132629.30cf161c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/dNwk3utDlF9WMRTzWwsknp7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/dNwk3utDlF9WMRTzWwsknp7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 3 Feb 2023 13:26:29 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>=20
> The following commits are also in Linus Torvalds' tree as different
                                    ^^^^^^^^^^^^^^^
Actually not in Linus' tree, just the net-next tree (semi-automation
sometimes fails :-)).

> commits (but the same patches):
>=20
>   022659ee3363 ("virtio_net: notify MAC address change on device initiali=
zation")
>   d0aa1f8e8d63 ("virtio_net: disable VIRTIO_NET_F_STANDBY if VIRTIO_NET_F=
_MAC is not set")
>=20
> These are commits
>=20
>   9f62d221a4b0 ("virtio_net: notify MAC address change on device initiali=
zation")
>   7c06458c102e ("virtio_net: disable VIRTIO_NET_F_STANDBY if VIRTIO_NET_F=
_MAC is not set")
>=20
> in the net-next tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/dNwk3utDlF9WMRTzWwsknp7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPccl8ACgkQAVBC80lX
0Gy8vggAn0ZmROJMK6ri6+d4xnjtqdOpgq1wps7KXuPMEfYvcUlu4tTLZqctkz2W
Lgnrcm2NBYzXIB6yy1gZgRGMLDhyP0AqpC3PCFW8u88RpRdEOuQIGqkDQ5GsMmKJ
u8DQQIN2ShhJR9wKHz/frgyh9NN0UJBfPjEpGQHW5QVHFomAMMHvwIIrLl+FN/O4
t3NRLq5nDlCm1xwk/cP08cwzloGHyn5mNGcDU/HDX1oAix2AvUXH+FRkUGC1Oayq
Id7bF9UPsic51aqyOag/yhKZV1J5gfOpSKo5uGl+Ec+jWz1ViuoHqU47LceQ1nU1
lWKLCiFptFCgwcBYdeGW9mSez0/n0Q==
=NedD
-----END PGP SIGNATURE-----

--Sig_/dNwk3utDlF9WMRTzWwsknp7--
