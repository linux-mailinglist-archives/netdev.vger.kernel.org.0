Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 394DE18D64D
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 18:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCTR4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 13:56:32 -0400
Received: from tuna.sandelman.ca ([209.87.249.19]:59091 "EHLO
        tuna.sandelman.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgCTR4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 13:56:32 -0400
Received: from sandelman.ca (obiwan.sandelman.ca [IPv6:2607:f0b0:f:2::247])
        by tuna.sandelman.ca (Postfix) with ESMTP id 554B33897A;
        Fri, 20 Mar 2020 13:55:11 -0400 (EDT)
Received: from localhost (localhost [IPv6:::1])
        by sandelman.ca (Postfix) with ESMTP id 8586CF19;
        Fri, 20 Mar 2020 13:56:31 -0400 (EDT)
From:   Michael Richardson <mcr@sandelman.ca>
To:     Alexander Aring <alex.aring@gmail.com>
cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, dav.lebrun@gmail.com, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org
Subject: Re: [PATCHv2 net-next 3/5] net: ipv6: add support for rpl sr exthdr
In-Reply-To: <20200320023901.31129-4-alex.aring@gmail.com>
References: <20200320023901.31129-1-alex.aring@gmail.com> <20200320023901.31129-4-alex.aring@gmail.com>
X-Mailer: MH-E 8.6; nmh 1.7+dev; GNU Emacs 25.1.1
X-Face: $\n1pF)h^`}$H>Hk{L"x@)JS7<%Az}5RyS@k9X%29-lHB$Ti.V>2bi.~ehC0;<'$9xN5Ub#
 z!G,p`nR&p7Fz@^UXIn156S8.~^@MJ*mMsD7=QFeq%AL4m<nPbLgmtKK-5dC@#:k
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Date:   Fri, 20 Mar 2020 13:56:31 -0400
Message-ID: <32639.1584726991@localhost>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain


My superficial read of the patch set is that it looks right.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEbsyLEzg/qUTA43uogItw+93Q3WUFAl51A88ACgkQgItw+93Q
3WUFxAf/b+sbc589eu84R1pHG5KB8f26k2sZkwvDmvul8/Qqok3xtSfDbfkkS4c/
DklUiNY3f6r15stwg+cVS5/Xa58rmn6wiT5/6y2JNddWl4RLfW/E4Re1s7+7tLtw
LePTFLH9RTUsPW+NRIX0MKXA7ci+U5bmSA4fe3dMB3zaeSgxJyPScsrBBJc1i87I
rrAAK9vZ54erxaZu/caGcdVeFNcgkxuavizJM9/KLTiNg/XpVohCmwJSuXhMlc6L
wAZblmklBPTjbS9ztYxOezOENHglHtKpAyrW021pt8bBtbHxj1+CxfNPxGAQ96aY
SrX5GaTID0L0IWZvcpcgs96W0QOWGg==
=f19v
-----END PGP SIGNATURE-----
--=-=-=--
