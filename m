Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8514D65081
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 05:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfGKDNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 23:13:50 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57123 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfGKDNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 23:13:49 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45kh3F3SsSz9sNF;
        Thu, 11 Jul 2019 13:13:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562814826;
        bh=PhG2hG4cwurJt26BRZUTaDAqGL6edeBLrcMEroPsEj0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SuTADComobW495yn0VS+70Awano2ExGgqtgVV+QRwhFeli/zdhgoqwIrbhBgrPn1x
         4skLMs9TYL/picxQWd1RBtOB0LxHHRHUYfMJHorysnA3jMGk8ILvjBrauq1KPJYZco
         r906QruX68qilfJIrw4VLnkLPi232pQysd6Q223G7NRGZDFF/Wg4ETXkqkfbzcCp58
         okM9iCm5cdnDg2Lx2up0BhHzb7mspbEB3whIj7l2FlYrPfXpC9aijxxuexB3zwwP1P
         pqtgOryYP2L4Cg/I4P+umsvAx942+39ZvTIqbod59+sp8+dHTTPld3NmnKTAwX6rKo
         km/sisSjD5EZA==
Date:   Thu, 11 Jul 2019 13:13:44 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Doug Ledford <dledford@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20190711131344.452fc064@canb.auug.org.au>
In-Reply-To: <20190711015854.GC22409@mellanox.com>
References: <20190709135636.4d36e19f@canb.auug.org.au>
        <20190709064346.GF7034@mtr-leonro.mtl.com>
        <20190710175212.GM2887@mellanox.com>
        <20190711115054.7d7f468c@canb.auug.org.au>
        <20190711015854.GC22409@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/6ThWdQ5XpS0.NYkNCCb3CV2"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/6ThWdQ5XpS0.NYkNCCb3CV2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Thu, 11 Jul 2019 02:26:27 +0000 Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> On Thu, Jul 11, 2019 at 11:50:54AM +1000, Stephen Rothwell wrote:
>=20
> > So today this failed to build after I merged the rdma tree (previously
> > it didn;t until after the net-next tree was merged (I assume a
> > dependency changed).  It failed because in_dev_for_each_ifa_rcu (and
> > in_dev_for_each_ifa_rtnl) is only defined in a commit in the net-next
> > tree :-( =20
>=20
> ? I'm confused..=20
>=20
> rdma.git builds fine stand alone (I hope!)

I have "Fixup to build SIW issue" from Leon (which switches to using
in_dev_for_each_ifa_rcu) included in the rmda tree merge commit because
without that the rdma tree would not build for me.  Are you saying that
I don't need that at all, now?

--=20
Cheers,
Stephen Rothwell

--Sig_/6ThWdQ5XpS0.NYkNCCb3CV2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0mqWgACgkQAVBC80lX
0GwurQgAgB9bMJLhS8GhhH0OUWvzmBFfu1x4BKqe6qXkABkKMZBip4oPpREIfhLP
DUayvBrwM+7oOKZ0BWe7tJMSjPj61XmQzHL7g9aHO9PvnDfHtsRkjshY3R16UWfJ
RfdWvByMRu+gxWbNxB+xFjVeE4le7mQbeP/Kwyu1WqG/HYIBFZMrFzAsmfgLhozB
1/h8/ir4oA591iwhksdIutmW3jUG0sc666gK5cvnyBmZKCAFpepzOcbI4pefV1+S
1Zw49JKsDi8ZD0Sh/SK7kxbcyQHsCC0YypycStBvMMEohdPxOktcxsgzxX1/Ptea
Xy4Cmv7CmXCG/n1wgfxwsMyTDRbYCA==
=YQjt
-----END PGP SIGNATURE-----

--Sig_/6ThWdQ5XpS0.NYkNCCb3CV2--
