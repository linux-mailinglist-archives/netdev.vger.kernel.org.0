Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D77421597
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 19:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbhJDRyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 13:54:35 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:44208 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234063AbhJDRyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 13:54:35 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7F83D1C0B76; Mon,  4 Oct 2021 19:52:44 +0200 (CEST)
Date:   Mon, 4 Oct 2021 19:52:44 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 00/95] 4.19.209-rc1 review
Message-ID: <20211004175244.GA14089@duo.ucw.cz>
References: <20211004125033.572932188@linuxfoundation.org>
 <CA+G9fYtyzfpSnapCFEVgeWGD8ZwS2_Lv5KPwjX4hUwDAv52kFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <CA+G9fYtyzfpSnapCFEVgeWGD8ZwS2_Lv5KPwjX4hUwDAv52kFg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 4.19.209 release.
> > There are 95 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patc=
h-4.19.209-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>=20
> Regression found on arm, arm64, i386 and x86.
> following kernel crash reported on stable-rc linux-4.19.y.
>=20
> metadata:
>   git branch: linux-4.19.y
>   git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>   git commit: ee3e528d83e91547f386a30677ccb96c28e78218
>   git describe: v4.19.208-96-gee3e528d83e9
>   make_kernelversion: 4.19.209-rc1
>   kernel-config: https://builds.tuxbuild.com/1z2izwX1xMgF2OSYM5EN6ELHEij/=
config
>=20
>=20
> Kernel crash:
> --------------
> [   14.900875] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000000
> [   14.908699] PGD 0 P4D 0
> [   14.911230] Oops: 0002 [#1] SMP PTI
> [   14.914714] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.19.209-rc1 #1
> [   14.921147] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [   14.928531] RIP: 0010:__sk_destruct+0xb9/0x190
> [   14.932965] Code: 48 8b 47 08 48 8d 50 ff a8 01 48 0f 45 fa f0 ff
> 4f 34 0f 84 d9 00 00 00 48 c7 83 00 ff ff ff 00 00 00 00 48 8b bb 78
> ff ff ff <f0> ff 0f 0f 84 a0 00 00 00 48 8b bb 70 ff ff ff e8 32 41 6d
> ff f6

I believe we see the same failure in testing:

https://lava.ciplatform.org/scheduler/job/455022

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.19.209-rc1-gee3e528d83e9-dirty (root@runner-=
ryfx8chz-project-14394223-concurrent-0xchkx) () #1 SMP Mon Oct 4 17:14:39 U=
TC 2021
[    0.000000] CPU: ARMv7 Processor [413fc0f2] revision 2 (ARMv7), cr=3D10c=
5387d
[    0.000000] CPU: div instructions available: patching division code
=2E..
[    7.215118]      nameserver0=3D192.168.1.1
[    7.228063] Unable to handle kernel NULL pointer dereference at virtual =
address 00000000
[    7.236165] pgd =3D (ptrval)
[    7.238867] [00000000] *pgd=3D00000000
[    7.242442] Internal error: Oops: 5 [#1] SMP ARM
[    7.247055] Modules linked in:
[    7.250110] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.19.209-rc1-gee3e=
528d83e9-dirty #1
[    7.258286] Hardware name: Generic RZ/G1 (Flattened Device Tree)
[    7.264318] PC is at __sk_destruct+0xa8/0x11c
[    7.268690] LR is at __sk_destruct+0x4c/0x11c
[    7.273058] pc : [<c0ce244c>]    lr : [<c0ce23f0>]    psr: 60000113


Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYVs/bAAKCRAw5/Bqldv6
8o8oAKCif9tj6XAsxnQxqZl9z/OcfazZagCglQ9kz+NpHVNUxfCFRNRArbTPNwc=
=809t
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
