Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA00018D646
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 18:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgCTRxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 13:53:53 -0400
Received: from tuna.sandelman.ca ([209.87.249.19]:59072 "EHLO
        tuna.sandelman.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgCTRxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 13:53:52 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Mar 2020 13:53:52 EDT
Received: from sandelman.ca (obiwan.sandelman.ca [IPv6:2607:f0b0:f:2::247])
        by tuna.sandelman.ca (Postfix) with ESMTP id D0A6A3897A;
        Fri, 20 Mar 2020 13:45:26 -0400 (EDT)
Received: from localhost (localhost [IPv6:::1])
        by sandelman.ca (Postfix) with ESMTP id 0BD58F19;
        Fri, 20 Mar 2020 13:46:47 -0400 (EDT)
From:   Michael Richardson <mcr@sandelman.ca>
To:     Alexander Aring <alex.aring@gmail.com>
cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, dav.lebrun@gmail.com, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org
Subject: Re: [PATCHv2 net-next 0/5] net: ipv6: add rpl source routing
In-Reply-To: <20200320023901.31129-1-alex.aring@gmail.com>
References: <20200320023901.31129-1-alex.aring@gmail.com>
X-Mailer: MH-E 8.6; nmh 1.7+dev; GNU Emacs 25.1.1
X-Face: $\n1pF)h^`}$H>Hk{L"x@)JS7<%Az}5RyS@k9X%29-lHB$Ti.V>2bi.~ehC0;<'$9xN5Ub#
 z!G,p`nR&p7Fz@^UXIn156S8.~^@MJ*mMsD7=QFeq%AL4m<nPbLgmtKK-5dC@#:k
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Date:   Fri, 20 Mar 2020 13:46:47 -0400
Message-ID: <30175.1584726407@localhost>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain


Alexander Aring <alex.aring@gmail.com> wrote:
    > should happen. So far I understand there exists a draft yet which
    > describes the cases (inclusive a Hop-by-Hop option which we also not
    > support yet).

    > https://tools.ietf.org/html/draft-ietf-roll-useofrplinfo-35

The need for the hop-by-hop encapsulation is, I hope, now unnecessary.

draft-ietf-roll-unaware-leaves describes how very low duty cycle systems
(window-smash alerts, etc.) could participate in RPL without being routers.

--
]               Never tell me the odds!                 | ipv6 mesh networks [
]   Michael Richardson, Sandelman Software Works        |    IoT architect   [
]     mcr@sandelman.ca  http://www.sandelman.ca/        |   ruby on rails    [


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEbsyLEzg/qUTA43uogItw+93Q3WUFAl51AYYACgkQgItw+93Q
3WVDVQf+Np2holQmsZapYKS2bsYZRttp4hOYjrxNeSeybFTtdAYND5pTcB5N1Uss
6nSyzwWXqOlsFMSWJ+ojEmo4sirm6ZlOvB43Hck26cPNQYolaXhH492lZBLXms3H
T9gFHSh4JWu+oh2kzNkWCMlTLeQHQK33NcSpOwrn5LbRkq2DQ34Q88+ZcN8gSGnx
dZM9lZHIWrDo9GLzlwTlglXR8nV6LkmKWRWQf49a8xKyATXRiaw2ZwouuVCD2TcP
riQDpDoYueS9c4gFx4neCCpIQ47sBo/8HsS8CwAbdAkh1qwIaPZDZgTRSb5mGR5v
MfGp0aC/qNI3Xbya007/quYzQtXBQw==
=dMSt
-----END PGP SIGNATURE-----
--=-=-=--
