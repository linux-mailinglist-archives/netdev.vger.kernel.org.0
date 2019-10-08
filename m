Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC49D0395
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 00:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfJHWvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 18:51:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:58532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbfJHWvh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 18:51:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 58E5AAE8B;
        Tue,  8 Oct 2019 22:51:35 +0000 (UTC)
From:   NeilBrown <neilb@suse.de>
To:     "J . Bruce Fields" <bfields@fieldses.org>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Date:   Wed, 09 Oct 2019 09:51:23 +1100
Cc:     "David S . Miller" <davem@davemloft.net>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Neil F Brown <nfbrown@suse.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfs\@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Vasiliy Averin <vvs@virtuozzo.com>
Subject: Re: [PATCH] sunrpc: fix crash when cache_head become valid before update
In-Reply-To: <20191008202332.GB9151@fieldses.org>
References: <20191001080359.6034-1-ptikhomirov@virtuozzo.com> <3e455bb4-2a03-551e-6efb-1d41b5258327@virtuozzo.com> <20191008202332.GB9151@fieldses.org>
Message-ID: <87wodergus.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue, Oct 08 2019,  J . Bruce Fields  wrote:

> On Tue, Oct 08, 2019 at 10:02:53AM +0000, Pavel Tikhomirov wrote:
>> Add Neil to CC, sorry, had lost it somehow...
>
> Always happy when we can fix a bug by deleting code, and your
> explanation makes sense to me, but I'll give Neil a chance to look it
> over if he wants.

Yes, it makes sense to me.  But I'm not sure that is worth much.  The
original fix got a Reviewed-by from me but was wrong.
 Acked-by: NeilBrown <neilb@suse.de>

'Acked' is weaker than 'reviewed' - isn't it? :-)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl2dEusACgkQOeye3VZi
gbnopA//SlaMhjk5SD0KTN4tOa1phmLsB+AQGBNeBjJ7F7JVNoqphvHbWqdp8uYG
Uy1NulqZGk2MKQ7vDdUDR82S5Y8y5s3bf9UJnpfLYdSEg21m2qTqDFYlt1ldvKsE
mO0tL9Dz/tAMu+a4OUyEGL7j/3c6/R/U1PFFzNXJKKzlKdfZaWV979BKMoEq+pep
c9Qiibl6GBIGzbfUZ/mZy77qM5Lrw/mj56P9amfiSL2DdCY4vukray/KTvE4Vbfq
4WcZ9AgFRayGa7EHlcVObz6Ut3ab46IR+uPG7Sl5VdNaDQRzSmES1cOGl5pK8K4J
YHdAucVq877MG+/PEzVVhLx5OO3TqV5I+rpuKYiwUD963erdmMa3MAlZJftURubA
nCIle/g3ngLQnnuu4Ui+kOqJDcABdniuyegSl0fDD2e1Vh+Aj0CXovtu3u/ORsm+
klK4ndDG2G0ORTuDKrFlqaIVJQ0NrtGkokNWHY3/CPPfguFewId23KwuXfrd4GLm
fdcCPAvufoGosLA9K1bF+hzBKGhAIwVg1KDmFN4rM1pNF3GfAUg+gWWqQlF7aPy3
egPYUmrts3RzmuDTinLZ0eEfwNGq4k1B7iJj+1L4ejuZ9XtF7l0wWmCBaWmsoWA7
1MvBIKLWjBswO64nsIFzz5nBuJkMezQ4n1VjBs4DVJJILTdlryI=
=5YfV
-----END PGP SIGNATURE-----
--=-=-=--
