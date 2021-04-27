Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6E936C13E
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 10:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbhD0IzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 04:55:07 -0400
Received: from mail.katalix.com ([3.9.82.81]:54412 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhD0IzG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 04:55:06 -0400
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 04D377DC8A;
        Tue, 27 Apr 2021 09:54:22 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1619513663; bh=BkOtjIgkefCri+COLZ6fE+Zf2Wn6Kwpj2GIydOH0QXY=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Tue,=2027=20Apr=202021=2009:54:22=20+0100|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20"Gong,=20Sishuai"=20<sishuai@p
         urdue.edu>|Cc:=20Cong=20Wang=20<xiyou.wangcong@gmail.com>,=0D=0A=0
         9David=20Miller=20<davem@davemloft.net>,=0D=0A=09Jakub=20Kicinski=
         20<kuba@kernel.org>,=0D=0A=09Matthias=20Schiffer=20<mschiffer@univ
         erse-factory.net>,=0D=0A=09Linux=20Kernel=20Network=20Developers=2
         0<netdev@vger.kernel.org>|Subject:=20Re:=20[PATCH=20v3]=20net:=20f
         ix=20a=20concurrency=20bug=20in=20l2tp_tunnel_register()|Message-I
         D:=20<20210427085422.GA4585@katalix.com>|References:=20<2021042119
         2430.3036-1-sishuai@purdue.edu>=0D=0A=20<CAM_iQpUV-rmGdn1g7jn=3D=3
         D53wLQ0MvM_bx4cJBo4AEDVZXPehRQ@mail.gmail.com>=0D=0A=20<2021042608
         5913.GA4750@katalix.com>=0D=0A=20<E30A6022-C479-4F67-B945-BFF0472C
         E320@purdue.edu>|MIME-Version:=201.0|Content-Disposition:=20inline
         |In-Reply-To:=20<E30A6022-C479-4F67-B945-BFF0472CE320@purdue.edu>;
        b=J5wF56isthrtQcsP423j3QZQ5nBpa6vG2Dsm2kYOcsrbQ0iKXj3fs+uEb9g/CmKba
         jhn5IXcU/KLuCNmYwDnk9SiSy6qIGAS9qPOxkQHHw56tzZCvQnoVtq+zPHvqy4OxhA
         2TPWDAkQC/zrl+t93HLDHJxIOp5GP8hqx5DEq7PEU3A5AKT5gb/2yQM6sk0sal6WMr
         NgpijOwcr8tiqQIxw/W2QsKauVpkY/Y2tT648+kKUYkWV5moZ7M0DeUZg7SFJZc9Hz
         ghPO/8WK2xTrNIzwKHHxaqdt0TG3CMWthccdZT571uk72LG1xjmsUn8+9exRzqybmA
         xN4/D4lKc9G9Q==
Date:   Tue, 27 Apr 2021 09:54:22 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     "Gong, Sishuai" <sishuai@purdue.edu>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH v3] net: fix a concurrency bug in l2tp_tunnel_register()
Message-ID: <20210427085422.GA4585@katalix.com>
References: <20210421192430.3036-1-sishuai@purdue.edu>
 <CAM_iQpUV-rmGdn1g7jn==53wLQ0MvM_bx4cJBo4AEDVZXPehRQ@mail.gmail.com>
 <20210426085913.GA4750@katalix.com>
 <E30A6022-C479-4F67-B945-BFF0472CE320@purdue.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <E30A6022-C479-4F67-B945-BFF0472CE320@purdue.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Mon, Apr 26, 2021 at 13:04:44 +0000, Gong, Sishuai wrote:
>    On Apr 26, 2021, at 4:59 AM, Tom Parkin <tparkin@katalix.com> wrote:
>      For some reason I've not been seeing these patches, just the replies.
>      I can't see it on lore.kernel.org either, unless I'm missing somethi=
ng
>      obvious.
>=20
>      Have the original mails cc'd netdev?
>=20
>    I also noticed this problem. I CCed netdev@vger.kernel.org but=20
>    this message didn=E2=80=99t show up in the maillist. Actually, I also
>    CCed you in the original email but it looks like only Cong Wang
>    could see it.
>    Should I re-send this email?
>    Thanks.

If you CC'd me in the first place and I didn't see it that's strange.
I got your initial "bug report" mail :-|

=46rom the perspective of submitting the patch, I have no problem with
it being applied on the strength of Cong Wang's review.

Thanks for working on this.

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmCH0TsACgkQlIwGZQq6
i9DTnggAu9jxr2TeWljvsF+rAtynFJVDqrXDBntJUd+lWpHvQY+KrUfLG4xmm+Id
ctLURLVS/5mmkcXDlrvS+Oo6jYIqOPYtQ58JtsdGtGYia/iB7hHRiHBxaUUf7kdL
yuI79FuuXZd5uMTne2A+Q4NYX6WHQ+QY0JNMcUWnLpuEwmb31I1p+lM7e4ynWimi
cjwNdAm9k5owtDnUATxTTStYr0DDZSnSPJb/uSZEMx09N8XLMWnhLWZ8IGjQg4IZ
Sn9Mzn/jbqiEitUYKIDWPBLNMfQyl+5yZW7a0KJwxlICc1kw8NZXnWk/0w27HN9a
phHU2+c9Jf0l56zf6oxKHxxq7Pt2aQ==
=AVj+
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
