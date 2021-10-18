Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2464319D9
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhJRMuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbhJRMuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:50:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361D4C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 05:47:59 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcS3I-0003FV-EQ; Mon, 18 Oct 2021 14:47:40 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-c2ef-28ab-e0cd-e8fd.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:c2ef:28ab:e0cd:e8fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 81EB9696766;
        Mon, 18 Oct 2021 12:47:37 +0000 (UTC)
Date:   Mon, 18 Oct 2021 14:47:36 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     Nishanth Menon <nm@ti.com>, Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v4 0/6] CAN: Add support for CAN in AM65,J721e and AM64
Message-ID: <20211018124736.zr2oavfg6h3tnrgp@pengutronix.de>
References: <20211006055344.22662-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ljji6pbi73l3wne5"
Content-Disposition: inline
In-Reply-To: <20211006055344.22662-1-a-govindraju@ti.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ljji6pbi73l3wne5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06.10.2021 11:23:37, Aswath Govindraju wrote:
> The following series of patches add support for CAN in SoC's AM65, J721e
> and AM64.
>=20
> The following series is dependent on,
> https://patchwork.kernel.org/project/netdevbpf/patch/20210920123344.2320-=
1-a-govindraju@ti.com/

This patch just hit net/master:

| 99d173fbe894 can: m_can: fix iomap_read_fifo() and iomap_write_fifo()
| https://git.kernel.org/netdev/net/c/99d173fbe8944861a00ebd1c73817a1260d21=
e60

and should be part of v5.15.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ljji6pbi73l3wne5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFtbOYACgkQqclaivrt
76n5Jwf/R6q+JD0YwphCt5Ds1vOyuiZPyR4D2wrVSFpT/+l6g00FDgeMztPJT6zN
SYLYIyyceQ3tBP1R+ZBKfM8EdFaA8g6PORPECfUwH12gP6GnvUX+Nsvlgr1XMtOn
9I6ls+J0cFhFoSQ/HVXoRlLsCTXGEk1QLcPUVE/iazvJx7bOy1jbR+sLwINoMn0L
Kf+3/Pae+NhOvELK8HjVFIH1LWAEUpu6sTs81ebL8elGHxgbiGBi8vcWPkorkyfD
DhaLbRCSh1y4uf09YJhU9OzjXIwyVbOJZixDUGgEBDwvjV9BtOyAhsAgQYFZ8IQg
prXTLN1erGJEdGGjZgq/9DPDviN91g==
=H9mY
-----END PGP SIGNATURE-----

--ljji6pbi73l3wne5--
