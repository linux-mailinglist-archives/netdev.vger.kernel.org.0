Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D6318ABF5
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 06:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgCSFAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 01:00:06 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35491 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgCSFAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 01:00:06 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48jZTZ1tJcz9sPR;
        Thu, 19 Mar 2020 16:00:02 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1584594003;
        bh=aTbHR7hHUN6fU6enhevF6rNEujrRIXd6MP2kaGHM6ps=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o0jRAuHPTG7y3TjFRIfqgvymrH9m/fme+Jp30Ajqu21qSWhQqDEUytv3LpXEOx6t/
         c7nLrs4jJfrqg2oxcWwTMMp9aHMhmXOkm6EPt3rWzMmilW2ny2+CBovAu95NNznj9A
         YFjcNlLCx6g4pwTUeSFPH7SMhq6c7uco0PeANTvRiP3bmtsSHJ3XeutqNSrBWeSUFo
         g/lC7kZe4rrF4j4icfWZScp8qw3qvPgc24inkaF+O2fS+4ptQvbYteVpgc68Y6ZIBQ
         GzzB7ZFWJYpoOvOefHRuliCiBYhXdKHpZ2yTrNWNe5tmTSWpB7UY4GEorz2Bn1MoeP
         DDj/kyIWvzpkw==
Date:   Thu, 19 Mar 2020 15:59:56 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200319155956.1e916454@canb.auug.org.au>
In-Reply-To: <CA+h21hq1pVEJCZHzM4mCPEWhOL-_ugJ5h=EA4g=Lv5sweXGnAA@mail.gmail.com>
References: <20200311123318.51eff802@canb.auug.org.au>
        <CA+h21hq1pVEJCZHzM4mCPEWhOL-_ugJ5h=EA4g=Lv5sweXGnAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aKmygoOAv6BkFT.MF31uU50";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/aKmygoOAv6BkFT.MF31uU50
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

[Sorry fr the slow response]

On Wed, 11 Mar 2020 11:50:17 +0200 Vladimir Oltean <olteanv@gmail.com> wrot=
e:
>
> What would be the takeaway here? I did bring the fact that it will
> conflict to David's attention here, not sure what else should have
> been done:
> https://www.spinics.net/lists/netdev/msg636207.html
> The conflict resolution looks fine btw, I've tested linux-next and it
> also works.

David has now merged the two trees and resolved this.  My notification
is just so that people are aware of conflicts in separate trees that
usually only come together in Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/aKmygoOAv6BkFT.MF31uU50
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5y/EwACgkQAVBC80lX
0Gwcnwf/Y/1g384Izgi4aLvLdFAw7MtRWrwTnTUWPbITPyFb3/N0Gqr+18wLDWsq
tN/m2dEWW5vxPhKt5f6GP99eZldcmJjxGCJwseix/LZNgtIbynZuf8Y2txNMaBoe
fKqgzlb28t8BfKdXvnvsY0EhUJMqyg8NMCyx1eK0BgfNlWdURf/qU+kRo87l4Ptg
soXxtL3ldR1pbu924PzCnCDpwyahDCPlEAoCHRsU5WVpaPepzyb2dAu4YBG1Y5AP
tWPrjAxirMfzJPWbv0ME7rsk8QT5knPnPc8K+gpuTeAJ6Vk3SjlSFyWz2sLyjLxf
ujzMaw75yyZbCnmSzrCVzTVnVL+DWw==
=nXma
-----END PGP SIGNATURE-----

--Sig_/aKmygoOAv6BkFT.MF31uU50--
