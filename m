Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10640109435
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 20:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfKYT2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 14:28:01 -0500
Received: from mx.mylinuxtime.de ([195.201.174.144]:55276 "EHLO
        mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKYT2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 14:28:00 -0500
Received: from leda (unknown [IPv6:2001:470:99c1:714:e078:5e8f:bc9c:af22])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.mylinuxtime.de (Postfix) with ESMTPSA id 30791AEEB2;
        Mon, 25 Nov 2019 20:21:17 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mx.mylinuxtime.de 30791AEEB2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=eworm.de; s=mail;
        t=1574709677; bh=lVLErUGFk9dzz9u0j/g686/stLu2yikC3nX7dRehwYY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=WIl/YizuaH3dyVQM0SQTqLtXFesAekuhqEGM1ZVn9oB6Lq79jKbD6hN83ORDJRRkb
         qjuhc0j+keFfWP3iu/GhYKdZjxCH98JGvvJAMhyiwwNhU0QIi76SU7qe5TjHvkRjln
         B6f6latpEXE6FbqECECJpz7NoPcHrHaZIBqglPFs=
Date:   Mon, 25 Nov 2019 20:21:11 +0100
From:   Christian Hesse <list@eworm.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] iproute2 5.4
Message-ID: <20191125202111.1bb32360@leda>
In-Reply-To: <20191125081737.2ff4a7ca@hermes.lan>
References: <20191125081737.2ff4a7ca@hermes.lan>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Face: %O:rCSk<c"<MpJ:yn<>HSKf7^4uF|FD$9$I0}g$nbnS1{DYPvs#:,~e`).mzj\$P9]V!WCveE/XdbL,L!{)6v%x4<jA|JaB-SKm74~Wa1m;|\QFlOg>\Bt!b#{;dS&h"7l=ow'^({02!2%XOugod|u*mYBVm-OS:VpZ"ZrRA4[Q&zye,^j;ftj!Hxx\1@;LM)Pz)|B%1#sfF;s;,N?*K*^)
Face:   iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAGFBMVEUZFRFENy6KVTKEd23CiGHeqofJvrX4+vdHgItOAAAACXBIWXMAAA3XAAAN1wFCKJt4AAACUklEQVQ4y2VUTZeqMAxNxXG2Io5uGd64L35unbF9ax0b3OLxgFs4PcLff0lBHeb1QIq5uelNCEJNq/TIFGyeC+iugH0WJr+B1MvzWASpuP4CYHOB0VfoDdddwA7OIFQIEHjXDiCtV5e9QX0WMu8AG0mB7g7WP4GqeqVdsi4vv/5kFBvaF/zD7zDquL4DxbrDGDyAsgNYOsJOYzth4Q9ZF6iLV+6TLAT1pi2kuvgAtZxSjoG8cL+8vIn251uoe1OOEWwbIPU04gHsmMsoxyyhYsD2FdIigF1yxaVbBuSOCAlCoX324I7wNMhrO1bhOLsRoA6DC6wQ5eQiSG5BiWQfM4gN+uItQTRDMaJUhVbGyKWCuaaUGSVFVKpl4PdoDn3yY8J+YxQxyhlHfoYOyPgyDcO+cSQK6Bvabjcy2nwRo3pxgA8jslnCuYw23ESOzHAPYwo4ITNQMaOO+RGPEGhSlPEZBh2jmBEjQ5cKbxmr0ruAe/WCriUxW76I8T3h7vqY5VR5wXLdERodg2rHEzdxxk5KpXTL4FwnarvndKM5/MWDY5CuBBdQ+3/0ivsUJHicuHd+Xh3jOdBL+FjSGq4SPCwco+orpWlERRTNo7BHCvbNXFVSIQMp+P5QsIL9upmr8kMTUOfxEHoanwzKRcNAe76WbjBwex/RkdHu48xT5YqP70DaMOhBcTHmAVDxLaBdle93oJy1QKFUh2GXT4am+YH/GGel1CeI98GdMXsytjCKIq/9cMrlgxFCROv+3/BU1fijNpcVD6DxE8VfLBaxUGr1D5usgDYdjwiPAAAAAElFTkSuQmCC
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Gt_qteWXsHThwO5rzNUlGk3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Authentication-Results: mx.mylinuxtime.de;
        auth=pass smtp.auth=mail@eworm.de smtp.mailfrom=list@eworm.de
X-Rspamd-Server: mx
X-Spam-Status: No, score=-4.68
X-Stat-Signature: dpsgjw3ameu7jykoyb58ur5dypo483sw
X-Rspamd-Queue-Id: 30791AEEB2
X-Spamd-Result: default: False [-4.68 / 15.00];
         TO_DN_SOME(0.00)[];
         SIGNED_PGP(-2.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+,1:+,2:~];
         ASN(0.00)[asn:6939, ipnet:2001:470::/32, country:US];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         RCPT_COUNT_THREE(0.00)[3];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.20)[multipart/signed,text/plain];
         NEURAL_HAM(-2.98)[-0.993,0];
         MID_RHS_NOT_FQDN(0.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Gt_qteWXsHThwO5rzNUlGk3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Stephen Hemminger <stephen@networkplumber.org> on Mon, 2019/11/25 08:17:
> The 5.4 kernel has been released, and the last patches have
> been applied to iproute2.
>=20
> Not a lot of changes in this release, most are related to fixing output
> formatting and documentation.
>=20
> Download:
>     https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.4.0.ta=
r.gz

The file is not (yet) available. Did you miss to push it to the servers?
--=20
main(a){char*c=3D/*    Schoene Gruesse                         */"B?IJj;MEH"
"CX:;",b;for(a/*    Best regards             my address:    */=3D0;b=3Dc[a+=
+];)
putchar(b-1/(/*    Chris            cc -ox -xc - && ./x    */b/42*2-3)*42);}

--Sig_/Gt_qteWXsHThwO5rzNUlGk3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXHmveYAHrRp+prOviUUh18yA9HYFAl3cKacACgkQiUUh18yA
9HYNKggAtF3eZeuvK+qmNMKjTzqSbj7nyAIu24a+vgGlAG9Gwb0CleINgbJLXTYP
2+xQDeBnO0m8oU20EWqt31cDCBzg81wQgWdRg1NHEGvl20yp3QoQlW8PvsM2Eu3f
1DMHnHBZigTwjLxcpDoqlV/fK39lZYhNfK2O0qnujaIEQBE8Gl7ifrJbXU2tLNX0
RkFHS+gn3JoCQub5BI2zJ+TKFs8//bzdFX63i4bhe/EkwoQFVyzGB0n2iLrb9pCm
DJdksB+rrY9xk+q0UIXBpU0EXnb+FrKj+x2z14vuhgSceXKF62TFfvUhPd/2KEaO
OCEPIv1Pxv0Exf8fl2eyqtGqH9z8wg==
=Spmo
-----END PGP SIGNATURE-----

--Sig_/Gt_qteWXsHThwO5rzNUlGk3--
