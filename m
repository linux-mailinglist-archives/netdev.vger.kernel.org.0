Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020082A15D6
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 12:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgJaLiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 07:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbgJaLf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 07:35:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D66C0613D9
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 04:35:56 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kYpAO-00078k-71; Sat, 31 Oct 2020 12:35:28 +0100
Received: from [IPv6:2a03:f580:87bc:d400:dcc0:5662:7742:3902] (unknown [IPv6:2a03:f580:87bc:d400:dcc0:5662:7742:3902])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EC59F587078;
        Sat, 31 Oct 2020 11:35:15 +0000 (UTC)
Subject: Re: [PATCH v7 0/6] CTU CAN FD open-source IP core SocketCAN driver,
 PCI, platform integration and documentation
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>, linux-can@vger.kernel.org,
        devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Drew Fustini <pdp7pdp7@gmail.com>
References: <cover.1604095004.git.pisa@cmp.felk.cvut.cz>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <2ccec201-1a84-1837-15a8-d2ad05f5753c@pengutronix.de>
Date:   Sat, 31 Oct 2020 12:35:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <cover.1604095004.git.pisa@cmp.felk.cvut.cz>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="04tgLaBHSWFaV1pFRgNILpZYRaA30DPBv"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--04tgLaBHSWFaV1pFRgNILpZYRaA30DPBv
Content-Type: multipart/mixed; boundary="UpDqIxknZHkUw6dX1i9CjvnpV77RuuRWi";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>, linux-can@vger.kernel.org,
 devicetree@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
 David Miller <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
 mark.rutland@arm.com, Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Marin Jerabek <martin.jerabek01@gmail.com>,
 Ondrej Ille <ondrej.ille@gmail.com>, Jiri Novak <jnovak@fel.cvut.cz>,
 Jaroslav Beran <jara.beran@gmail.com>, Petr Porazil <porazil@pikron.com>,
 Pavel Machek <pavel@ucw.cz>, Drew Fustini <pdp7pdp7@gmail.com>
Message-ID: <2ccec201-1a84-1837-15a8-d2ad05f5753c@pengutronix.de>
Subject: Re: [PATCH v7 0/6] CTU CAN FD open-source IP core SocketCAN driver,
 PCI, platform integration and documentation
References: <cover.1604095004.git.pisa@cmp.felk.cvut.cz>
In-Reply-To: <cover.1604095004.git.pisa@cmp.felk.cvut.cz>

--UpDqIxknZHkUw6dX1i9CjvnpV77RuuRWi
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 10/30/20 11:19 PM, Pavel Pisa wrote:
> This driver adds support for the CTU CAN FD open-source IP core.

Please fix the following checkpatch warnings/errors:

----------------------------------------
drivers/net/can/ctucanfd/ctucanfd_base.c
----------------------------------------
WARNING: Possible repeated word: 'the'
#296: FILE: drivers/net/can/ctucanfd/ctucanfd_base.c:296:
+ * This check the drivers state and calls the
+ * the corresponding modes to set.

WARNING: Possible repeated word: 'the'
#445: FILE: drivers/net/can/ctucanfd/ctucanfd_base.c:445:
+ * This is the CAN error interrupt and it will check the the type of err=
or

WARNING: quoted string split across lines
#466: FILE: drivers/net/can/ctucanfd/ctucanfd_base.c:466:
+		netdev_info(ndev, "%s: ISR =3D 0x%08x, rxerr %d, txerr %d,"
+			" error type %u, pos %u, ALC id_field %u, bit %u\n",

CHECK: Alignment should match open parenthesis
#637: FILE: drivers/net/can/ctucanfd/ctucanfd_base.c:637:
+	ctucan_netdev_dbg(ndev, "%s: from 0x%08x to 0x%08x\n",
+		   __func__, priv->txb_prio, prio);

CHECK: Alignment should match open parenthesis
#673: FILE: drivers/net/can/ctucanfd/ctucanfd_base.c:673:
+			ctucan_netdev_dbg(ndev, "TXI: TXB#%u: status 0x%x\n",
+				   txb_idx, status);

CHECK: Alignment should match open parenthesis
#808: FILE: drivers/net/can/ctucanfd/ctucanfd_base.c:808:
+			ctucan_netdev_dbg(ndev, "some ERR interrupt: clearing 0x%08x\n",
+				   icr.u32);

total: 0 errors, 3 warnings, 3 checks, 1142 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inpl=
ace.

drivers/net/can/ctucanfd/ctucanfd_base.c has style problems, please revie=
w.
-----------------------------------------
drivers/net/can/ctucanfd/ctucanfd_frame.h
-----------------------------------------
CHECK: Please don't use multiple blank lines
#46: FILE: drivers/net/can/ctucanfd/ctucanfd_frame.h:46:
+
+

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#49: FILE: drivers/net/can/ctucanfd/ctucanfd_frame.h:49:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#104: FILE: drivers/net/can/ctucanfd/ctucanfd_frame.h:104:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#120: FILE: drivers/net/can/ctucanfd/ctucanfd_frame.h:120:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#128: FILE: drivers/net/can/ctucanfd/ctucanfd_frame.h:128:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#136: FILE: drivers/net/can/ctucanfd/ctucanfd_frame.h:136:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#154: FILE: drivers/net/can/ctucanfd/ctucanfd_frame.h:154:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#172: FILE: drivers/net/can/ctucanfd/ctucanfd_frame.h:172:
+	uint32_t u32;

total: 0 errors, 0 warnings, 8 checks, 189 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inpl=
ace.

drivers/net/can/ctucanfd/ctucanfd_frame.h has style problems, please revi=
ew.
-----------------------------------
drivers/net/can/ctucanfd/ctucanfd.h
-----------------------------------
total: 0 errors, 0 warnings, 0 checks, 87 lines checked

drivers/net/can/ctucanfd/ctucanfd.h has no obvious style problems and is =
ready for submission.
--------------------------------------
drivers/net/can/ctucanfd/ctucanfd_hw.c
--------------------------------------
CHECK: Please don't use multiple blank lines
#30: FILE: drivers/net/can/ctucanfd/ctucanfd_hw.c:30:
+
+

WARNING: Possible repeated word: 'from'
#40: FILE: drivers/net/can/ctucanfd/ctucanfd_hw.c:40:
+ * generated from from IP-XACT/cactus helps to driver to hardware

CHECK: Alignment should match open parenthesis
#98: FILE: drivers/net/can/ctucanfd/ctucanfd_hw.c:98:
+static u32 ctucan_hw_hwid_to_id(union ctu_can_fd_identifier_w hwid,
+				 enum ctu_can_fd_frame_format_w_ide type)

total: 0 errors, 1 warnings, 2 checks, 751 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inpl=
ace.

drivers/net/can/ctucanfd/ctucanfd_hw.c has style problems, please review.=

--------------------------------------
drivers/net/can/ctucanfd/ctucanfd_hw.h
--------------------------------------
WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
#56: FILE: drivers/net/can/ctucanfd/ctucanfd_hw.h:56:
+/*
+ * Status macros -> pass "ctu_can_get_status" result

WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
#84: FILE: drivers/net/can/ctucanfd/ctucanfd_hw.h:84:
+/*
+ * Interrupt macros -> pass "ctu_can_fd_int_sts" result

CHECK: Alignment should match open parenthesis
#759: FILE: drivers/net/can/ctucanfd/ctucanfd_hw.h:759:
+static inline void ctucan_hw_txt_buf_give_command(struct ctucan_hw_priv =
*priv,
+				union ctu_can_fd_tx_command cmd, u8 buf)

total: 0 errors, 2 warnings, 1 checks, 935 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inpl=
ace.

drivers/net/can/ctucanfd/ctucanfd_hw.h has style problems, please review.=

---------------------------------------
drivers/net/can/ctucanfd/ctucanfd_pci.c
---------------------------------------
total: 0 errors, 0 warnings, 0 checks, 316 lines checked

drivers/net/can/ctucanfd/ctucanfd_pci.c has no obvious style problems and=
 is ready for submission.
--------------------------------------------
drivers/net/can/ctucanfd/ctucanfd_platform.c
--------------------------------------------
total: 0 errors, 0 warnings, 0 checks, 142 lines checked

drivers/net/can/ctucanfd/ctucanfd_platform.c has no obvious style problem=
s and is ready for submission.
----------------------------------------
drivers/net/can/ctucanfd/ctucanfd_regs.h
----------------------------------------
CHECK: Please don't use multiple blank lines
#100: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:100:
+
+

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#103: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:103:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#124: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:124:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#217: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:217:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#245: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:245:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#269: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:269:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#305: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:305:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#319: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:319:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#333: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:333:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#347: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:347:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#361: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:361:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#381: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:381:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#407: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:407:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#431: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:431:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#450: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:450:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#465: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:465:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#487: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:487:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#501: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:501:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#515: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:515:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#529: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:529:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#543: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:543:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#557: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:557:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#571: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:571:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#585: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:585:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#599: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:599:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#652: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:652:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#670: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:670:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#688: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:688:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#718: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:718:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#726: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:726:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#756: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:756:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#784: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:784:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#810: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:810:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#863: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:863:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#890: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:890:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#898: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:898:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#906: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:906:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#948: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:948:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#956: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:956:
+	uint32_t u32;

CHECK: Prefer kernel type 'u32' over 'uint32_t'
#964: FILE: drivers/net/can/ctucanfd/ctucanfd_regs.h:964:
+	uint32_t u32;

total: 0 errors, 0 warnings, 40 checks, 971 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inpl=
ace.

drivers/net/can/ctucanfd/ctucanfd_regs.h has style problems, please revie=
w.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--UpDqIxknZHkUw6dX1i9CjvnpV77RuuRWi--

--04tgLaBHSWFaV1pFRgNILpZYRaA30DPBv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl+dS+8ACgkQqclaivrt
76nhYwf+P7IMNmeMji2DGfhN8jcV/uukmdiEsj52/rFN1rviJC5ax/WNCiy0L/+m
EkVV7uzdFv2R2dKHHo7NInXfSmslmIYgNn7hF4syItM3NrNAbSGuNP09tMMlKnVk
TXsLf0ZmvwuGthTO1/Zx/JCgiZwoFSN9dj4xu8ZtmcHNk2tz6vbHLAF30bUiFl8V
pmGIKL4vbfMlzwRfnJNriMl6qG8jcQoX8mvqDimQodxJcLVsUAT48jS8G3ooo1ZF
opuUu2MWeeBuMItqbNIJbVbpenJz5Kmi/t3l0tp1FIrIMM+amDRrBl30vm95U9UL
XnWuPqzf0pLRAHWK4nnSl3SMHJ5P7Q==
=QBMS
-----END PGP SIGNATURE-----

--04tgLaBHSWFaV1pFRgNILpZYRaA30DPBv--
