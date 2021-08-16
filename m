Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648D23EDF78
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbhHPVrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbhHPVrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 17:47:09 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA3BC061764;
        Mon, 16 Aug 2021 14:46:32 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GpSR836n5z9sSn;
        Tue, 17 Aug 2021 07:46:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629150389;
        bh=GxpXS88kee0Bjl7oexujGeBRvw49mQS6pJyQtpRKOWo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TEzlL37j7WtbICcA/OrDmrF4LrGuhnZMv8NZ8AP/SFR+P7HYbz2a60lLkZ01IAf/K
         +9CvnSmXmntupWN84yoCJ9iK/QK39WjdQoeCWZS6HL3/XkK++W0UMHpeB869c2vlcr
         EU/4FrwjRdJrcwNvu1lZgkTUgNFKVcFUXw6CMF/RocGyebUaVYyNjB6yezzMUq6tuN
         2d0XYDbGHBWTT5Ui+40WJNe+7Kca6CFQE64OdVbypGSBn+kj1uHuUNGC316b55+Zos
         GxpFtTpRlzfzCA6Pznaxs2Bt2rDKsyZ8M0SQwKtW4I/LFw4k9+gXGMUlL5fqScqtFc
         AVQfhDqx+ZgRA==
Date:   Tue, 17 Aug 2021 07:46:27 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Greg KH <greg@kroah.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20210817074627.2a1ef298@canb.auug.org.au>
In-Reply-To: <YRp/2kRzujLsV8sm@kroah.com>
References: <20210816135216.46e50364@canb.auug.org.au>
        <YRp/2kRzujLsV8sm@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/GfpmKEhu/CQD3=ZU=yqVb.P";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/GfpmKEhu/CQD3=ZU=yqVb.P
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 16 Aug 2021 17:10:18 +0200 Greg KH <greg@kroah.com> wrote:
>
> On Mon, Aug 16, 2021 at 01:52:16PM +1000, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > After merging the staging tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/staging/r8188eu/core/rtw_br_ext.c:8:10: fatal error: ../include=
/net/ipx.h: No such file or directory
> >     8 | #include "../include/net/ipx.h"
> >       |          ^~~~~~~~~~~~~~~~~~~~~~
> >=20
> > Caused by commit
> >=20
> >   6c9b40844751 ("net: Remove net/ipx.h and uapi/linux/ipx.h header file=
s")
> >=20
> > from the net-next tree.
> >=20
> > I have reverted that commit for today. =20
>=20
> Should now be fixed up in my tree so that you do not need to drop that
> networking patch anymore.

Excellent, thanks.

--=20
Cheers,
Stephen Rothwell

--Sig_/GfpmKEhu/CQD3=ZU=yqVb.P
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEa3LMACgkQAVBC80lX
0GyczAgAkbxGMmJu1J33dlvwwsKriGporDtMrdu2379pYDx0xy9xEpTTRQ9o/Xla
zXfC8zBn0BJ0pOEuZHKSlCDWYykEy86Lo8Wh1fkgsRN2zn5YnKhdstIKHF30gESO
FHIWlHy3HeiqMiiM5UIWujuWfG8AN4/YOmsQzCkJDWyiQE6Mos6r77FvAYc9l8/i
7NXwjFK5RxVB0Ebh4u2XWlpEl7qoETXXNpSYrIfZQRsY48sWLVNO/nV1BwNir7rL
AV3kqZJH+jOM0RS6dqxumudrLUHaeNy0OXOfMws/CZPSS+3ez8g/126pBMR3coyd
K/MhsSmeIXPpQ8+rj9xr2LnvvpPzVg==
=hAGH
-----END PGP SIGNATURE-----

--Sig_/GfpmKEhu/CQD3=ZU=yqVb.P--
