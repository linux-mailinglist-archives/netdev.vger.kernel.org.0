Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FBD19BDDF
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 10:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387758AbgDBIsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 04:48:12 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:39989 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgDBIsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 04:48:11 -0400
Received: from methusalix.internal.home.lespocky.de ([92.117.37.184]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1M1qfu-1jM8Ra0HRw-002CQL; Thu, 02 Apr 2020 10:48:06 +0200
Received: from falbala.internal.home.lespocky.de ([192.168.243.94])
        by methusalix.internal.home.lespocky.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92.3)
        (envelope-from <post@lespocky.de>)
        id 1jJvW7-0002JG-6M; Thu, 02 Apr 2020 10:48:04 +0200
Date:   Thu, 2 Apr 2020 10:48:02 +0200
From:   Alexander Dahl <post@lespocky.de>
To:     linux-doc@vger.kernel.org
Cc:     Florian Wolters <florian@florian-wolters.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>
Subject: doc: Leftovers from CAPI remove?
Message-ID: <20200402084801.soysci5abrazctog@falbala.internal.home.lespocky.de>
Mail-Followup-To: linux-doc@vger.kernel.org,
        Florian Wolters <florian@florian-wolters.de>,
        Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Karsten Keil <isdn@linux-pingi.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tvymzrgbesooq62h"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Scan-Signature: 2e89b8130284c79aa2484230574bb425
X-Spam-Score: -2.7 (--)
X-Provags-ID: V03:K1:WoG4PWMIhmmyPPgJD5uwY33yQ9PtnaOtaZPSlEfdVcmnpmqeluR
 PPGb9KGTHZfe0w0zIGMMRFNqe6NImR7eez2JoPhmPO55ZPinAGXqOkT2ZHrgn1aoKD4U4wl
 nvnTSeIrSUbjhFJ2UuGBccjwYbUPhikzs52b6+aNeGRkCifqyzRY+804Z2VfVqKiSUIpKeK
 6I2jiH/25i4yy2qSPOnjA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:V7YSUOLdg88=:cv5XUDbbL9T9LS2nNpo6b9
 4tXadBGkI96fYpa/E8KBVL6S2OuIEF9OG7TTZF5WUlaTznlOJsxOxxZJGSABzTS5alXq+LTdE
 Y5YeJnQhrJ8dXjrvk9FPrUsd/+c3bPxDDdv21ibbyELleqtPfKhfBzf2eoFfuAyIQBe+FQL0Q
 klxl1CY/49nYe4yrmjkG/FRkDrdQSWKMnevd1yh0jIW8tDj3pZPxOyMOL3XmYZzy44qc3lBZV
 RwDb8wEBuZt6/KHg3Gixbci0fNcMzGanl26YKd6QnEUJTwcpytqSwDJ8Mt9p6u7vLE4zhYXhz
 QlrrA2OEqLB1LVCVvhvZuZUUCnNftDsC9Yg//M6gchvFM7FEirAbrnyK1/WsanThvchm0Xztg
 i54+KiK0b7U4plIJj2NemEYx2XAPChAjhMIFEDcOWgLJStlF3xyltakcvzdhA/EKaWZF4N0Lx
 FTnphaorlRzpqbwd5UPxEXJuryWvNJU7chBMD1bSz9wGJGqpMy+Xx5WYNTCUff8swlqLJSOfX
 UHGSUGNMWtH1DvRCKebczkscOrk6HrpCSmK1t1Vtc87q6stBb7ALeOEF8/WDrTTddYLLZqdmQ
 UGWso3tmtwcTIPd/2y3caYbHAe872rkdt9gpK/cXvDykxT0yseiZbuDPadsq1Zv5jzkMzeENA
 DkJp7ZGt3yWufUqQWafVRQaq0QYtclqoBFaaxySTcC1gJN4L6quaN+c7ovrx9igJMXW2E74DU
 Zc50L2E3sqtwvGJ3qSYeKpj+3iND7ym3qM5W0ZuovDfvg16gKs9+nAVUfut7I5g7MEQpJCDwZ
 aKdmQkzP0RBwbaTO2h4Q1HgUtVTLdlMUD5i/Ooe5+FfxbOI0VRP12VZa18bXQ6kegLw3X4x
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tvymzrgbesooq62h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hei hei,

when accidentally building an old Fritz PCI driver=C2=B9 against v5.6.1 we
hit this build error (which this mail is not about):

/home/florian/.fbr/fbr-4.0-trunk-x86_64/buildroot/output/build/fcpci-2.6-43=
=2Ex86_64-5.6.1/fritz/src/main.c:371:3:
Fehler: Implizite Deklaration der Funktion =C2=BBregister_capi_driver=C2=AB=
; meinten Sie =C2=BBregister_chrdev=C2=AB?  [-Werror=3Dimplicit-function-de=
claration]

A quick grep in master revealed there are still hints to the function
'register_capi_driver()' in file Documentation/isdn/interface_capi.rst

I suppose after removing capi parts with f59aba2f7579 ("isdn: capi:
dead code removal") and merging with 7ba31c3f2f1e ("Merge tag
'staging-5.6-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging") these
are leftovers in the documentation, which should be removed, right?

Greets
Alex

=C2=B9we still have basic ISDN support in fli4l [1], although no one is
motivated to maintain it, there are still users, mainly with local
PBX installations =E2=80=A6

[1] http://www.fli4l.de/

--=20
/"\ ASCII RIBBON | =C2=BBWith the first link, the chain is forged. The first
\ / CAMPAIGN     | speech censured, the first thought forbidden, the
 X  AGAINST      | first freedom denied, chains us all irrevocably.=C2=AB
/ \ HTML MAIL    | (Jean-Luc Picard, quoting Judge Aaron Satie)

--tvymzrgbesooq62h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEwo7muQJjlc+Prwj6NK3NAHIhXMYFAl6Fpr0ACgkQNK3NAHIh
XMYTqw/7BhBxs9BmkUSB9GoV3D8XvYV4hqbHz5ntqTgPMJw7ZFoqbtygxpeWAMTJ
mxNUmHBtOCPOM/yF00zmueYunhuHLP/OCMol9KaLY+CK8AZtit102ja3kvjSVU2f
5DK1Lt8CR5VQIUp78+/FFIgK3DBLDOWhQHhNWTGcO+MDcqimMCfXdUMQwZmxKDIg
YUo3qaK19f5nnehOj5fNRnBWlYNTtnsw4lNytq5poRCYDXSojmT7bNbnETllHU4Q
/r58jjWPynRv6vZg36H6mnmLAC+er3Eo+FgqZnveu6QYitsUdvDCT5Q2ieXp1tJb
yCIQRRezDA3Uh/5HRghjwU/H/5zhX/28FQsmeF/lRd06L6o+eBhJps32vcXV9Oux
25SUMFI6RMD2AtWB1VnZqEgIqWIsepDFOlxtDVmLhusm00QSV96l1l9jtIH47t4d
fJ7hOVGVqJfYweYg2axz+r4/MHHgSvmymrDdCf4cQZTw4AsBPasE49mWfmLNPnpU
o7Ej5X8cyVoRrfjxgRFppAzK7n9ug7lLd3eAhJ4ziYKHZzG2EiK6nsebYUT+A5F5
RnueuvXVEAc16RKUts4yYM/7gMkpWchd0hGdG5pQ7S8++pgyaPJcqW0tXIXWvT5v
rdgBTSqIk+vw68LX1f2xG/KUXsCKi8urabu88lr/PyukNhbIucQ=
=hRnY
-----END PGP SIGNATURE-----

--tvymzrgbesooq62h--
