Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 627958F6A3
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 23:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732202AbfHOVvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 17:51:21 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50549 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730540AbfHOVvV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 17:51:21 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 468gBY0dN6z9s3Z;
        Fri, 16 Aug 2019 07:51:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565905878;
        bh=D+ELwaVyIIz8spsmBayHPt+P+ZTD1zlrhRDPMcXTkHg=;
        h=Date:From:To:Cc:Subject:From;
        b=WbRsblL0o5Btr5Be3FfRreD6NIMy0kw+VTjPzHzrYVqTs6DumNSR6kFC3ksU7mBMt
         O2tpY3uVJ2I70ioxn0eq4eM0z6jvzbVjCT/k8wYcJzFJR5SYp1Y3GN9MDOTuyQPWou
         ktv6iHIFYX12Zvi0U4CRrQEmMWIE0m7RDFEzIuMNsAEGbNS6UTyHD3JU/TVJO1PeKD
         UCTcNCpx2n9j0nrnCCL6HFr2OefYaputNM0/DoYCcZBmZ+Esgjad57eX4ya04dTPnV
         kycHL2lQ2AzVPD4wm1Y2i6iljrWlJUUZ6quEEixALoUcDdzneSa5900chUKmW8Wvji
         dvDDyFJy5T2hw==
Date:   Fri, 16 Aug 2019 07:51:14 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Venkatesh Yadav Abbarapu <venkatesh.abbarapu@xilinx.com>
Subject: linux-next: Fixes tags need some work in the net-next tree
Message-ID: <20190816075114.47adad49@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WogXi2_SFYamG6kz2d/J8jB";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/WogXi2_SFYamG6kz2d/J8jB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  3e994ff28f86 ("can: xilinx_can: xcan_set_bittiming(): fix the data phase =
btr1 calculation")

Fixes tag

  Fixes: c223da6 ("can: xilinx_can: Add support for CANFD FD frames")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

In commit

  9d06bcb9aa48 ("can: xilinx_can: xcan_rx_fifo_get_next_frame(): fix FSR re=
gister FL and RI mask values for canfd 2.0")

Fixes tag

  Fixes: c223da6 ("can: xilinx_can: Add support for CANFD FD frames")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

In commit

  e6997dd26884 ("can: xilinx_can: fix the data update logic for CANFD FD fr=
ames")

Fixes tag

  Fixes: c223da6 ("can: xilinx_can: Add support for CANFD FD frames")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

In commit

  93bbd6c5eeb1 ("can: xilinx_can: xcanfd_rx(): fix FSR register handling in=
 the RX path")

Fixes tag

  Fixes: c223da6 ("can: xilinx_can: Add support for CANFD FD frames")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

In commit

  6b0d35891c83 ("can: xilinx_can: xcan_probe(): skip error message on defer=
red probe")

Fixes tag

  Fixes: b1201e44 ("can: xilinx CAN controller support")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/WogXi2_SFYamG6kz2d/J8jB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1V09IACgkQAVBC80lX
0Gy2jgf/bogX50EuUskAvUUzV5VCuMdGwcfAteWLW+2CVEyzRwGwBL8Iug8515lP
lE8GWKHchyMmH3i3DWgeSiabKyUI6K/WOCgXEi4elFBIsh+KkGwKI+0sGfYH97rN
hHc/G7oJhbUnOjtjPhpt+BcPX7knkyK5xDZznz/fHR4qTwe06g/Ogzw4wWgsWJzQ
exKgiJtg+CPE5ZLPlyM58+bf9qzaXJqoN5OR+Tj22UY7dcB5k5ehbb7+O7E66Viv
aamXbRJCkCmXmpLqGbyANOmirnbpKvWThBufvx9u1Esn6ogZ/DaUXUF9bWcW+oJ9
SAGRtMfhbyeK8qnlpkDrM3qHz3X2hw==
=zLfw
-----END PGP SIGNATURE-----

--Sig_/WogXi2_SFYamG6kz2d/J8jB--
