Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A80F292925
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 16:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbgJSOTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 10:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbgJSOTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 10:19:44 -0400
Received: from smtp.gentoo.org (woodpecker.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8927DC0613CE;
        Mon, 19 Oct 2020 07:19:43 -0700 (PDT)
From:   "Thomas Deutschmann" <whissi@gentoo.org>
To:     "Mathy Vanhoef" <Mathy.Vanhoef@kuleuven.be>
Cc:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-wireless@vger.kernel.org>,
        "netdev" <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <denkenz@gmail.com>, "'Christian Hesse'" <list@eworm.de>
References: <4a7f92dc-13bb-697f-1730-ac288e74b730@gentoo.org>   <20201017230818.04896494@mathy-work.localhost> <20201019142550.5fe02d7d@leda>
In-Reply-To: <20201019142550.5fe02d7d@leda>
Subject: RE: [Regression 5.9][Bisected 1df2bdba528b] Wifi GTK rekeying fails: Sending of EAPol packages broken
Date:   Mon, 19 Oct 2020 16:19:36 +0200
MIME-Version: 1.0
Message-ID: <000001d6a622$e2d691a0$a883b4e0$@gentoo.org>
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHWopS/ehW+PgT+wUSNo3qWIdHUK6mcCw0AgAK0NwCAAD+M8A==
Content-Language: de
Content-Type: multipart/signed;
        protocol="application/pgp-signature";
        micalg=pgp-sha512;
        boundary="=-=JrFsF5PsuNu8wr=-="
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multipart message in MIME format.

--=-=JrFsF5PsuNu8wr=-=
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi Mathy,

I can also confirm that the patch works for me, thank you!


--=20
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5

--=-=JrFsF5PsuNu8wr=-=
Content-Type: application/pgp-signature;
	name="openpgp-digital-signature.asc"
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEExKRzo+LDXJgXHuURObr3Jv2BVkFAl+NoHJfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDEz
MTI5MUNFOEY4QjBENzI2MDVDN0I5NDQ0RTZFQkRDOUJGNjA1NTkACgkQRObr3Jv2
BVmT8Af/SY+jk3ZVHjoT7baXdpxiQbxQGsrv+fW62HXqoDV3tpFgwJvMPw2nTf1L
godZnBfHTYFCJ4Z29EMqlUqfUtMrT4vw91cWguhAc6AwlKKZjVqY0l9oNTCbsOo8
t4WJIIiXsP0ToGFt3cPV1Qvxl4cSPalTxGrorwZ3RFn1ewbWz/uA6siKU3y0vPm6
0VOTugFnuAj/wiYKcwcwe2Wg2tyYCH0WJLfGFfptNCuJsqfZJgNCD5FIcQtomdBI
1MehTb+Z6sK3LlU4gg3SQUixubuFIK3VJVkYKDlI2n8bFGW3tn+VgqXxucYulZa4
sMxO1znI+17PGXCaxMcmESsJnY5bNQ==
=BHIn
-----END PGP SIGNATURE-----


--=-=JrFsF5PsuNu8wr=-=--

