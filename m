Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6EA2422827
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhJENpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:45:13 -0400
Received: from mx2.uni-regensburg.de ([194.94.157.147]:36876 "EHLO
        mx2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbhJENpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 09:45:10 -0400
Received: from mx2.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 57734600004A;
        Tue,  5 Oct 2021 15:43:17 +0200 (CEST)
Received: from smtp1.uni-regensburg.de (smtp1.uni-regensburg.de [194.94.157.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "smtp.uni-regensburg.de", Issuer "DFN-Verein Global Issuing CA" (not verified))
        by mx2.uni-regensburg.de (Postfix) with ESMTPS id 15076600004E;
        Tue,  5 Oct 2021 15:43:13 +0200 (CEST)
From:   "Andreas K. Huettel" <andreas.huettel@ur.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kubakici@wp.pl>
Subject: Re: [EXT] Re: [Intel-wired-lan] Intel I350 regression 5.10 -> 5.14 ("The NVM Checksum Is Not Valid") [8086:1521]
Date:   Tue, 05 Oct 2021 15:43:08 +0200
Message-ID: <2944777.ktpJ11cQ8Q@pinacolada>
Organization: Universitaet Regensburg
In-Reply-To: <35dfc9e8-431c-362d-450e-4c6ac1e55434@molgen.mpg.de>
References: <1823864.tdWV9SEqCh@kailua> <20211004074814.5900791a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <35dfc9e8-431c-362d-450e-4c6ac1e55434@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2159422.HovnAMPojK"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart2159422.HovnAMPojK
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: "Andreas K. Huettel" <andreas.huettel@ur.de>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kubakici@wp.pl>
Subject: Re: [EXT] Re: [Intel-wired-lan] Intel I350 regression 5.10 -> 5.14 ("The NVM Checksum Is Not Valid") [8086:1521]
Date: Tue, 05 Oct 2021 15:43:08 +0200
Message-ID: <2944777.ktpJ11cQ8Q@pinacolada>
Organization: Universitaet Regensburg
In-Reply-To: <35dfc9e8-431c-362d-450e-4c6ac1e55434@molgen.mpg.de>
References: <1823864.tdWV9SEqCh@kailua> <20211004074814.5900791a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <35dfc9e8-431c-362d-450e-4c6ac1e55434@molgen.mpg.de>

>=20
> What messages are new compared to the working Linux 5.10.59?
>=20

I've uploaded the full boot logs to https://dev.gentoo.org/~dilfridge/igb/
(both in a version with and without timestamps, for easy diff).

* I can't see anything that immediately points to the igb device (like a PC=
I id etc.) before the module is loaded.=20
* The main difference between the logs is many unrelated (?) i915 warnings =
in 5.10.59 because of the nonfunctional graphics.

The messages easily identifiable are:

huettel@pinacolada ~/tmp $ cat kernel-messages-5.10.59.txt |grep igb
Oct  5 15:11:18 dilfridge kernel: [    2.090675] igb: Intel(R) Gigabit Ethe=
rnet Network Driver
Oct  5 15:11:18 dilfridge kernel: [    2.090676] igb: Copyright (c) 2007-20=
14 Intel Corporation.
Oct  5 15:11:18 dilfridge kernel: [    2.090728] igb 0000:01:00.0: enabling=
 device (0000 -> 0002)
Oct  5 15:11:18 dilfridge kernel: [    2.094438] Modules linked in: igb(+) =
i915(+) iosf_mbi acpi_pad efivarfs
Oct  5 15:11:18 dilfridge kernel: [    2.097287] Modules linked in: igb(+) =
i915(+) iosf_mbi acpi_pad efivarfs
Oct  5 15:11:18 dilfridge kernel: [    2.098492] Modules linked in: igb(+) =
i915(+) iosf_mbi acpi_pad efivarfs
Oct  5 15:11:18 dilfridge kernel: [    2.098787] Modules linked in: igb(+) =
i915(+) iosf_mbi acpi_pad efivarfs
Oct  5 15:11:18 dilfridge kernel: [    2.173386] igb 0000:01:00.0: added PH=
C on eth0
Oct  5 15:11:18 dilfridge kernel: [    2.173391] igb 0000:01:00.0: Intel(R)=
 Gigabit Ethernet Network Connection
Oct  5 15:11:18 dilfridge kernel: [    2.173395] igb 0000:01:00.0: eth0: (P=
CIe:5.0Gb/s:Width x4) 6c:b3:11:23:d4:4c
Oct  5 15:11:18 dilfridge kernel: [    2.173991] igb 0000:01:00.0: eth0: PB=
A No: H47819-001
Oct  5 15:11:18 dilfridge kernel: [    2.173994] igb 0000:01:00.0: Using MS=
I-X interrupts. 8 rx queue(s), 8 tx queue(s)
Oct  5 15:11:18 dilfridge kernel: [    2.174199] igb 0000:01:00.1: enabling=
 device (0000 -> 0002)
Oct  5 15:11:18 dilfridge kernel: [    2.261029] igb 0000:01:00.1: added PH=
C on eth1
Oct  5 15:11:18 dilfridge kernel: [    2.261034] igb 0000:01:00.1: Intel(R)=
 Gigabit Ethernet Network Connection
Oct  5 15:11:18 dilfridge kernel: [    2.261038] igb 0000:01:00.1: eth1: (P=
CIe:5.0Gb/s:Width x4) 6c:b3:11:23:d4:4d
Oct  5 15:11:18 dilfridge kernel: [    2.261772] igb 0000:01:00.1: eth1: PB=
A No: H47819-001
Oct  5 15:11:18 dilfridge kernel: [    2.261776] igb 0000:01:00.1: Using MS=
I-X interrupts. 8 rx queue(s), 8 tx queue(s)
Oct  5 15:11:18 dilfridge kernel: [    2.265376] igb 0000:01:00.1 enp1s0f1:=
 renamed from eth1
Oct  5 15:11:18 dilfridge kernel: [    2.282514] igb 0000:01:00.0 enp1s0f0:=
 renamed from eth0
Oct  5 15:11:31 dilfridge kernel: [   17.585202] igb 0000:01:00.0 enp1s0f0:=
 igb: enp1s0f0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX

huettel@pinacolada ~/tmp $ cat kernel-messages-5.14.9.txt |grep igb
Oct  5 02:38:31 dilfridge kernel: [    2.108606] igb: Intel(R) Gigabit Ethe=
rnet Network Driver
Oct  5 02:38:31 dilfridge kernel: [    2.108608] igb: Copyright (c) 2007-20=
14 Intel Corporation.
Oct  5 02:38:31 dilfridge kernel: [    2.108622] igb 0000:01:00.0: can't ch=
ange power state from D3cold to D0 (config space inaccessible)
Oct  5 02:38:31 dilfridge kernel: [    2.108918] igb 0000:01:00.0 0000:01:0=
0.0 (uninitialized): PCIe link lost
Oct  5 02:38:31 dilfridge kernel: [    2.418724] igb 0000:01:00.0: PHY rese=
t is blocked due to SOL/IDER session.
Oct  5 02:38:31 dilfridge kernel: [    4.148163] igb 0000:01:00.0: The NVM =
Checksum Is Not Valid
Oct  5 02:38:31 dilfridge kernel: [    4.154891] igb: probe of 0000:01:00.0=
 failed with error -5
Oct  5 02:38:31 dilfridge kernel: [    4.154904] igb 0000:01:00.1: can't ch=
ange power state from D3cold to D0 (config space inaccessible)
Oct  5 02:38:31 dilfridge kernel: [    4.155146] igb 0000:01:00.1 0000:01:0=
0.1 (uninitialized): PCIe link lost
Oct  5 02:38:31 dilfridge kernel: [    4.466904] igb 0000:01:00.1: PHY rese=
t is blocked due to SOL/IDER session.
Oct  5 02:38:31 dilfridge kernel: [    6.195528] igb 0000:01:00.1: The NVM =
Checksum Is Not Valid
Oct  5 02:38:31 dilfridge kernel: [    6.200863] igb: probe of 0000:01:00.1=
 failed with error -5


> >> Any advice on how to proceed? Willing to test patches and provide addi=
tional debug info.
>=20
> Without any ideas about the issue, please bisect the issue to find the=20
> commit introducing the regression, so it can be reverted/fixed to not=20
> violate Linux=E2=80=99 no-regression policy.

I'll start going through kernel versions (and later revisions) end of the w=
eek.

Thanks a lot,
Andreas


=2D-=20
PD Dr. Andreas K. Huettel
Institute for Experimental and Applied Physics
University of Regensburg
93040 Regensburg
Germany

--nextPart2159422.HovnAMPojK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQKTBAABCgB9FiEE6W4INB9YeKX6Qpi1TEn3nlTQogYFAmFcVmxfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldEU5
NkUwODM0MUY1ODc4QTVGQTQyOThCNTRDNDlGNzlFNTREMEEyMDYACgkQTEn3nlTQ
ogZcGQ//f8ADOoIyR+L7jh8IOJTOp1WgNbRzwws+OFwC5bzVSV5EDIo6epbNpobs
+pDuiypqp4XjSbpR9QHULKEDxmRSMClF5FmtXtnV8iR+fRoQJYzYN7SxDD4aTE/D
QtsZZlEH2JyqvpZR+Zg+EeGFW8RzuOd6f9LRg7zM2d5mYn+qu2F5y8FemZm8maaV
ZHzMgtFMsCLsr8Yb1J0eNkvPBA6TpR7ehcf9LkZxnNV/OPt1F2VjKzjZqyjHZYC+
Z2sBOkV6GbGciLwcFPrF/eEcQfhcAiXn+b+sKmSZws/YdALdat5gYB5ingJpl00U
fHCD70+v/jPyZb5thDFRDcMJFUxhycGiWrP53gsVpRKaU6KF2mREU8Q8LGabMcUu
uifrDmdXc/Daply5YNr1TTJ1HwU3L8n8A6WMlICEStXu4OH/Y6Q9fkcHBi8xEdNI
gS2/b3RLF8MFj/oqi5hMdDyIRTmixzBKiJMdqWPtvwmm6L74RLkXeSjHP0svVQTL
oACTlBJwMpmfj9mUAlDo0oV8yy+9+MjdzKiMuDdsyFQXkwPXzLK5zPNF063HLdrd
KrdmHEkCsUuni5lKEpJ4P0MLAASLsl7mOUsaBPipzXcoQxQA9mjU1sG16htWw/Wg
4L49s5gPBRoDOGwV83PifUClyRb5eiljm2898dFPXaFNaN66o+c=
=7fcw
-----END PGP SIGNATURE-----

--nextPart2159422.HovnAMPojK--



