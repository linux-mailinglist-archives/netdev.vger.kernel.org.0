Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8682589188
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 13:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfHKLdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 07:33:08 -0400
Received: from mout.gmx.net ([212.227.15.18]:53855 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfHKLdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 07:33:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1565523160;
        bh=5XNLSGLV/n8XATlDhvdkuJ0c9QjsZbpQ2b3uSxwJK6w=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=bYyr51s8eLybvh94uOtY1iy/RL+qrsRvhIqX/y4gU5zcOm4PQzksqf+zXKoslev7D
         NP2u7cSloBXdFHSIX9LUiA3dVht1iTP26Jl9Oz+nmPJLrGqz5FoJT34A0i9VyyLL0D
         oaUFb5e12LIj1zFqZYpF2oPRAO7y25HgbbTQcur0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([109.90.233.87]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MQ2Wx-1i0Kr52FzX-005KXD; Sun, 11
 Aug 2019 13:32:40 +0200
Date:   Sun, 11 Aug 2019 13:32:25 +0200
From:   Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        linux-doc@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/networking/af_xdp: Inhibit reference to
 struct socket
Message-ID: <20190811113225.GD1966@latitude>
References: <20190810121738.19587-1-j.neuschaefer@gmx.net>
 <20190810085821.11cee8b0@lwn.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3Pql8miugIZX0722"
Content-Disposition: inline
In-Reply-To: <20190810085821.11cee8b0@lwn.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:WSlMOTVkTIxgNdANUM34B9Gmw91nDYkQ4iCc+WK1bcjyk8C1UVC
 xd4RXLqrHapjXCexH+vQ3NdTtgk03TD0vuPZ+zgdyQKcB/OBs1TdT7T6e7GZs9RfH1BUjvU
 5eUraiD5cWDMFKmPen2rgxYhu409cLv5Vh/xJr3Nbhx36lwNMVCPzEGVKzIdS2mOH4PxxOH
 Gu1usr2e7Hg9gQhtvvCpA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:y64qkCK5mCY=:Ul8qM4rYjC/JIKtPh+C2QA
 O+NQ+dtV+T+uJHv+18CPWbiFdp5IvIJrqq6fEsC1/9rvOfRkPVTHlNy5+3hImBlfdj3tGASW8
 E9f8vcOr5XSqUf3uTwU993wHkK4hXX0yErTG18Yj3n1nc0h2vu6LBc6HGsDJm2YSl0XVm4sAs
 6022eCI1cgEW9RH0v8t8CJkezSvr3GV0EgRTflBEFIVVmz9q1Y2ljSVGSeSCREXHJvemB2L3j
 ReTM+XO0LLZlM9vMVscZ63Rt+1uZYDVMqDyLYN9AXRa7uE+QdHpYlFGIVNMCABXUpoBCWiD1X
 GlFyqAr/1yOyfgDz/zbjAi0Y4wGO+J35M+dlDxt6kIPCMS/f8LyXpnRqu4Z1eKzOn6zw1fB9O
 /Psvu4iRxvr+HQ2n5EPbIj+ktG+It6+9O8vzdzj9d27Jhysy9ot3SNbZta0NiGbjsEHOodVqX
 Bq1BwSnK2sTgMTCAt/y/MvY0nDSyMQ3dOUwEYEWJk7y5/aTqD4R75QOrLQS0e5qlJmnwoMwRj
 +XRSU4ox8FyZMcL1f/3D1BFYNXr0BvlTHQgAwyxTS8UOIxnXVwoNVpzPmJ2npZGgbvzyPLNXw
 OwgK/F/13q9H1YKBzLUyK/4EUBB1Wybb44Eig2bK1XrEjXLWhdlsCCUoFvJjKonC6wQwRLPwx
 y8hGLVxZo7Po/KmLfrxNsSkZplVMK/5JcFP2KmHpTZ3Kt+89ZuE9XVJz9Gchtyova5jYMcOgv
 haCI5Qlc1+sTkqG81+pRSVtEt+LAG7j7SibahVhB+65QPdlIK87drPSmLJP6OFt0vZdJLqxBx
 sA1ozCd/ZGyIGGqHbyr8DrnjYVto5IIvltYEc7qMWNq7PD0xJvb4Kakd4i6Wfjjb9TRtvm6eV
 M03K7GPVhbmJFKL/DCQBRwaa7GU8Yc7eWBjeHe4svs3uJuM83FjEt5m7fHQAzwe2DL3TJNPHn
 n2vmD9BQgK45Z+2xVAU0mqlUmOaMBnQptu8bolR3EoqhyirC2Uo6P3DN58Vsz94zUGZyFsASX
 Bd/pRcUuJ8aWBDk5lQAfr46cLuIHrhEZDeSH/NOFy1UbJ7wZYB/1mE5UkA/OeDGPOchJaqxhR
 bTnOf675spHdrb7v6xdI7a6hpcU4oQ0mwv9aynbWG54b6EJT02E7gkc4Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3Pql8miugIZX0722
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 10, 2019 at 08:58:21AM -0600, Jonathan Corbet wrote:
> On Sat, 10 Aug 2019 14:17:37 +0200
> Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net> wrote:
>=20
> > With the recent change to auto-detect function names, Sphinx parses
> > socket() as a reference to the in-kernel definition of socket. It then
> > decides that struct socket is a good match, which was obviously not
> > intended in this case, because the text speaks about the syscall with
> > the same name.
> >=20
> > Prevent socket() from being misinterpreted by wrapping it in ``inline
> > literal`` quotes.
> >=20
> > Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
>=20
> Thanks for looking at that.  The better fix, though, would be to add
> socket() to the Skipfuncs array in Documentation/sphinx/automarkup.py.
> Then it will do the right thing everywhere without the need to add markup
> to the RST files.

Alright, I'll do that for v2.


Thanks,
Jonathan Neusch=C3=A4fer

--3Pql8miugIZX0722
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEvHAHGBBjQPVy+qvDCDBEmo7zX9sFAl1P/IAACgkQCDBEmo7z
X9sBYw//WDx7jJODlKacEnlPkuHTxAkanqNDkGnT1Ghh6pIMjM4kqaZSusMiTy77
BCcw1O+iDfYLGZgBVuEeOZzaQtmKPGiaYvaOCGlEse5I/FR51qxXJmH6joU7ernN
SktIdNBlV7GnisrZHoXvxVeBmnCtLUDX0mIdqstioLlkGNnu1zEduNhM+p/KkBzj
iSxlNeQ/NEETCj2e4UHpLpYynix8j17T7X7uG/uO4b8gzoMBRe1bSOfKp45+AOoN
0LwjbcS3rnsFqaYiP/7dJ8LaQUYCSWfUd4+f7yKgrvzA2cH3ObjYbDd8XeKHRm/R
Gndzkxqm3SzxaUfAo8xYBqzD9tl/lfVVDYz0LUl1S+zMWAVK9v6rLXvdX7Ab7YRX
dY3gRKCPYvL0jzyrLFHOZTBIlHqSHV9X/kECgVCS2ahOMIDx3ll8scb/Pw2XkM06
bKQ/M/4SEaW4kxbhIj3H8y3lzngY46I5kFW/R64vhiH5KITQvqNd31V5ZUNzkdAT
2+pQP1tBasxhur956ITqgW74t3KhwnqSTv8c7VS+VtmJQrB2QvXzaWT9RrodcrTo
Tm5mWmfVBy8d0xfUu6RFNZN7SuQ2aUwb5WxDmzvNrB7FGD3vFpd42SJN2ub3qSDZ
OeHDnYBFmcvbsYAi7JUi+Wg7yZzZoCeKsbKdgQdyxQG2UHYFpyg=
=rjZu
-----END PGP SIGNATURE-----

--3Pql8miugIZX0722--
