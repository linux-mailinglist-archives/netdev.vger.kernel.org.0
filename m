Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B72D295D88
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 13:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897425AbgJVLjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 07:39:55 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46450 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503003AbgJVLjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 07:39:55 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 17B051C0B7D; Thu, 22 Oct 2020 13:39:53 +0200 (CEST)
Date:   Thu, 22 Oct 2020 13:39:52 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>,
        Drew Fustini <pdp7pdp7@gmail.com>
Subject: Re: [PATCH v6 4/6] can: ctucanfd: CTU CAN FD open-source IP core -
 PCI bus support.
Message-ID: <20201022113952.GC30566@duo.ucw.cz>
References: <cover.1603354744.git.pisa@cmp.felk.cvut.cz>
 <9783a6d0a3e79ca4106cf1794aa06c8436700137.1603354744.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="32u276st3Jlj2kUU"
Content-Disposition: inline
In-Reply-To: <9783a6d0a3e79ca4106cf1794aa06c8436700137.1603354744.git.pisa@cmp.felk.cvut.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!


> @@ -12,4 +12,13 @@ config CAN_CTUCANFD
> =20
>  if CAN_CTUCANFD
> =20
> +config CAN_CTUCANFD_PCI
> +	tristate "CTU CAN-FD IP core PCI/PCIe driver"
> +	depends on PCI
> +	help
> +	  This driver adds PCI/PCIe support for CTU CAN-FD IP core.
> +	  The project providing FPGA design for Intel EP4CGX15 based DB4CGX15
> +	  PCIe board with PiKRON.com designed transceiver riser shield is avail=
able
> +	  at https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd .
> +
>  endif

Ok, now the if in the first patch makes sense. It can stay.

And it is separate module, so EXPORT_SYMBOLs make sense. Ok.

> +#ifndef PCI_VENDOR_ID_TEDIA
> +#define PCI_VENDOR_ID_TEDIA 0x1760
> +#endif

> +#define PCI_DEVICE_ID_ALTERA_CTUCAN_TEST  0xCAFD
> +#define PCI_DEVICE_ID_TEDIA_CTUCAN_VER21 0xff00

These should go elsewhere.

> +static bool use_msi =3D 1;
> +static bool pci_use_second =3D 1;

true?

Best regards,
							Pavel
--=20
http://www.livejournal.com/~pavelmachek

--32u276st3Jlj2kUU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX5FviAAKCRAw5/Bqldv6
8uDPAJ9N8U7LTRinG5wknzSv9xu+BsSDhwCfdYHxBEZ0QWL9qQdQ9DF/src6zvU=
=1hJA
-----END PGP SIGNATURE-----

--32u276st3Jlj2kUU--
