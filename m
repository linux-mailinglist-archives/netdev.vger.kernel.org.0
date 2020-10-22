Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDBD295D9D
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 13:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897475AbgJVLnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 07:43:10 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46798 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2897425AbgJVLnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 07:43:09 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D62BA1C0B7D; Thu, 22 Oct 2020 13:43:06 +0200 (CEST)
Date:   Thu, 22 Oct 2020 13:43:06 +0200
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
Subject: Re: [PATCH v6 5/6] can: ctucanfd: CTU CAN FD open-source IP core -
 platform/SoC support.
Message-ID: <20201022114306.GA31933@duo.ucw.cz>
References: <cover.1603354744.git.pisa@cmp.felk.cvut.cz>
 <2a90e1a7d57f0fec42604cd399acf25af5689148.1603354744.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <2a90e1a7d57f0fec42604cd399acf25af5689148.1603354744.git.pisa@cmp.felk.cvut.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> +++ b/drivers/net/can/ctucanfd/Kconfig
> @@ -21,4 +21,15 @@ config CAN_CTUCANFD_PCI
>  	  PCIe board with PiKRON.com designed transceiver riser shield is avail=
able
>  	  at https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd .
> =20
> +config CAN_CTUCANFD_PLATFORM
> +	tristate "CTU CAN-FD IP core platform (FPGA, SoC) driver"
> +	depends on OF || COMPILE_TEST
> +	help

This is likely wrong, as it can enable config of CAN_CTUCANFD=3DM,
CAN_CTUCANFD_PLATFORM=3Dy, right?

> @@ -8,3 +8,6 @@ ctucanfd-y :=3D ctu_can_fd.o ctu_can_fd_hw.o
> =20
>  obj-$(CONFIG_CAN_CTUCANFD_PCI) +=3D ctucanfd_pci.o
>  ctucanfd_pci-y :=3D ctu_can_fd_pci.o
> +
> +obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) +=3D ctucanfd_platform.o
> +ctucanfd_platform-y +=3D ctu_can_fd_platform.o

Can you simply add right object files directly?

Best regards,
							Pavel

--=20
http://www.livejournal.com/~pavelmachek

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX5FwSgAKCRAw5/Bqldv6
8mBXAJ9Yxu3KDocmwXzDJ/UqfZEfhPYP5gCgl2ZrvqWyvIfc1oyXbUGzvVfe5YM=
=ILp2
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
