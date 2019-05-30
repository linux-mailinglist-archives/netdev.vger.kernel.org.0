Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1942FF58
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 17:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfE3PVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 11:21:36 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.20]:15228 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfE3PVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 11:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1559229693;
        s=strato-dkim-0002; d=romanh.de;
        h=Date:Message-ID:Subject:From:To:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=Kb0yMaXGTI8DdPJyfAcCLz2a/otuVCgc92rvJnIiwik=;
        b=b3GlCpuXNLRSsXOKeU+L7vWRjT8vYLRxEwr1JQwVHPo8lg7XKbgFK7klEP4lv92SQb
        RRc82HDDIh87VxWy+P7FuX/qfncNUCnOCdp5DbQuxj1ixqgbgPW+chzB6x+23IB9yn2j
        I5way+5OZvPkcC5wLLfp6dB5L18wafiVfupv/wqxAaiVgoJHkzE4XX3ANIDbBcSh+orl
        KsHUjlEl648vBqEnzDk1kNKQvFNwmKDWoduMQzxw3DGwkpEnzS/zRdfGItbjNbFSPLCz
        Ot898Ua6SKqW64THhaQ0hNX/Lv0fOoRNbeoa7m5qEAR9XCbhK9RybKK7LGVBUzYtFkAu
        LjhA==
X-RZG-AUTH: ":IW0NeWC6dPKGmaqnvJQvmGcPCmfSXfuocDNyu8aIRIC/sau4VPmRAYfaAZyQfAmjdTI="
X-RZG-CLASS-ID: mo00
Received: from [192.168.0.100]
        by smtp.strato.de (RZmta 44.21 SBL|AUTH)
        with ESMTPSA id J004c3v4UFLXxeb
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <netdev@vger.kernel.org>;
        Thu, 30 May 2019 17:21:33 +0200 (CEST)
To:     netdev@vger.kernel.org
From:   Roman Hergenreder <mail@romanh.de>
Subject: Gigabit ethernet r8168/r8169
Openpgp: preference=signencrypt
Autocrypt: addr=mail@romanh.de; keydata=
 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
Message-ID: <c63b1079-a5df-f3f3-da0c-c3ed08277a0c@romanh.de>
Date:   Thu, 30 May 2019 17:21:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QeA9YSTcspL5j2HK9JOeh0oTegCrXs954"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QeA9YSTcspL5j2HK9JOeh0oTegCrXs954
Content-Type: multipart/mixed; boundary="noe75xkyuPlH6LpyLHaP0RY6hV91tRtS9";
 protected-headers="v1"
From: Roman Hergenreder <mail@romanh.de>
To: netdev@vger.kernel.org
Message-ID: <c63b1079-a5df-f3f3-da0c-c3ed08277a0c@romanh.de>
Subject: Gigabit ethernet r8168/r8169

--noe75xkyuPlH6LpyLHaP0RY6hV91tRtS9
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

Dear Realtek crew,

i hope it is okay, that I contact you this way. If not, please tell me,
who is responsible for this kind of issues.

I am currently using Arch Linux (5.1.5-arch1-2-ARCH) on a Lenvo Flex
2-14
(https://www.lenovo.com/us/en/laptops/lenovo/flex-series/flex-2-14/) and
somehow it only operates at 100 mbps (100baseT/Full or 100baseT/Half). I
already tried various drivers e.g. r8168, r8168-dkms, r8169 (both
distribution packages and direct download from the realtek site). Also
different patch cables (cat 5e, cat6) and different communication
partners (gigabit router + switch) were tried.

I wonder if it's a driver/kernel problem or a hardware malfunction.

If you need any further information or command outputs (lspci, lshw,
dmesg, journal, ethtool), please contact me.

I am looking forward for your response if you have time to deal with
this problem.


Best Regards

Roman Hergenreder

P.S. Sorry for the last failed mail


--noe75xkyuPlH6LpyLHaP0RY6hV91tRtS9--

--QeA9YSTcspL5j2HK9JOeh0oTegCrXs954
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEy8QZ/4AT+soMsNM4WAqm71wEFYAFAlzv9P0ACgkQWAqm71wE
FYAchA/+K9IRdVtVtPmrOYWSO1BUFY8o24LB09EECdgA+eNKmU6YpE67vZC0ucQ6
Fe66DUxGlZdyaP3Irb4Rx7TDgHcEkNL0SFtMcM+I953GSYGDsbt4xHa005dX6HmE
pjJTjCVkYzYP4rhbkcVtkq1VrZVthOtPJerCnibFxG9WF5k5lkMwDjUpO1EURSch
Zp8BonpVC9mO3EBclq1oV99zSKxsxqKK037mjXjWdHSzhVntFMSyh2nvu6hrHw7P
BqV8JdGPjeGJHTpfWhJFJxoRkgx6Sj3gEsoGUi2Zx5ywq76RIOsEca5eh5YBTH2P
z/rkNqxZoY/HsKCKuOx+OqJdwGwPpXTk2GtcAmTBabMeEJjPzMjx3nyGEUS1xOIs
6PA5PSv6Sg23vYFd8IdrfvhQD9BTx8eBf3QaUJY5hMP9L138RgaGXYBwf0zTc26v
bqraIFyWbMmpc013jSrZLxQp4+X0vDSD9Gf40IeLt7GBKFzelko4vuGwhMJ2+iRO
Z773q5kca+D8StqpcdqiDfIe5fkQsLa+nEh+rE9eYut7J4/ntJHJ15MQkw3Jzx9c
129jk+X1gHm+Hxi2eDW+Ajij7k9aChF7/oZ4dcU64762c6nVZLnioXs9vqwB+AdI
aN/AMGr+lvFREBmXHKx660hR7eQ0Cf5v05Wto8+exGV7VTOd8F8=
=MvDn
-----END PGP SIGNATURE-----

--QeA9YSTcspL5j2HK9JOeh0oTegCrXs954--
