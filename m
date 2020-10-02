Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F80280C31
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 04:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387549AbgJBCAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 22:00:22 -0400
Received: from ozlabs.org ([203.11.71.1]:42449 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgJBCAV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 22:00:21 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C2Y9H3hQKz9sSG;
        Fri,  2 Oct 2020 12:00:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601604019;
        bh=JJU/m7iI6vnJda2OoX/uTcHMjyjyAn9guGzBAmlcufw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NtH+Bd/rBWVaYnlBxCTcKgk5XuLXXD79RNrTCknWBrHn2ajTPndPiaK1jmiAhwQTn
         sNh9Z7b+I7EhpjX8xAXcfmn/kRq9477rpWv7JCmjrlwdnHbHNPjmxEaLXH0Ecvg5r8
         DYHXvbMa3G4FddSoRcmr+sHQrSalNhDGAbfsqTFy6COchQHPrKztgBxvXtIR84wvf/
         GNAfrOKxjW+nm7NuWUUay6OeabrlGd2xVCF0hVWPascaChmmhmhm1PsMYRNUAmzUqY
         +51E+0Mf+xvpguywkCMDpJEAIXkK4j/HivYihIjK9z7gtG+SFLxWFRp0Ddp5E+BoVU
         Lad2T1E7AJo1w==
Date:   Fri, 2 Oct 2020 12:00:18 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, vadym.kochan@plvision.eu,
        ap420073@gmail.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20201002120018.1aa3c0f6@canb.auug.org.au>
In-Reply-To: <20201001.184013.1373555560291108341.davem@davemloft.net>
References: <20200929130446.0c2630d2@canb.auug.org.au>
        <20201001.184013.1373555560291108341.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mkjmDzZTlS+AR_CZfZ/1Dsf";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/mkjmDzZTlS+AR_CZfZ/1Dsf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, 01 Oct 2020 18:40:13 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 29 Sep 2020 13:04:46 +1000
>=20
> > Caused by commit
> >=20
> >   eff7423365a6 ("net: core: introduce struct netdev_nested_priv for nes=
ted interface infrastructure")
> >=20
> > interacting with commit
> >=20
> >   e1189d9a5fbe ("net: marvell: prestera: Add Switchdev driver implement=
ation")
> >=20
> > also in the net-next tree. =20
>=20
> I would argue against that "also" as the first commit is only in the
> 'net' tree right now. :-)

Sorry, my mistake.  I was wondering why your testing did not seem to be
affected.

> This is simply something I'll have to resolve the next time net is merged
> into net-next.

Absolutely, no problem.

--=20
Cheers,
Stephen Rothwell

--Sig_/mkjmDzZTlS+AR_CZfZ/1Dsf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl92ibIACgkQAVBC80lX
0GxGHQf/UpWz/P9C5wlbk0Qua0KmG9dmTNPHDQi/qZ6KVADYQYn53P5fVQo2CSSh
juKMQa3tJTYSn3euNOupLKILn98asxzQpkl3X1MX60n2yI4uysocZMAIw8DJ6bCF
uB305I5lpCBLvCbWbRmUduxZERf8pb9BTcaX0tiesZFTC59c3cj8OuUfXaH1T3j+
9oPL0qCYPpSJSM8iQqBEmI89oJgO4RFBU6Ieh98RVN111xEklGqhC8ngOhBdy7DK
5q6h30i+miHrsD2uOIz893MWT5kHmkgvrlZkiZKUzQCjMTDWwnhb5hm/deJQCLGK
kofqZ35EM9YuuLEa6iwxFthSJGQ64g==
=Jfgd
-----END PGP SIGNATURE-----

--Sig_/mkjmDzZTlS+AR_CZfZ/1Dsf--
