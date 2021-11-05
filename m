Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7070D446406
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 14:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhKENWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 09:22:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38938 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbhKENWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 09:22:30 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20211105131932euoutp024daf04fcb9869d99edf2ca2707068794~0qP3edrHS1722817228euoutp02K;
        Fri,  5 Nov 2021 13:19:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20211105131932euoutp024daf04fcb9869d99edf2ca2707068794~0qP3edrHS1722817228euoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1636118373;
        bh=pvKkSQfQXZLXIfe/YwqvyKLq5nJqkg5+Jem5zmbw3xQ=;
        h=From:To:Cc:Subject:In-Reply-To:Date:References:From;
        b=OJ5H90gG5beJ7wEJJzor5+QKEXpmLb6eI765xhZ1MsXapdYJ1yv6OEKu2KblQAOFJ
         +PjAuHZt/Pvm+bZuMiRb/9OwFJp26sZaQVTa/V8psPKCwFmEu8GP+HP4tesXwsUl20
         GzwjZPoKptd06R9SOzf1AqRa2uDvbChJgtEfTLkA=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211105131932eucas1p2e1d19560ad2120566d08e244fffce93e~0qP3NIN5R0297602976eucas1p2z;
        Fri,  5 Nov 2021 13:19:32 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 19.01.56448.46F25816; Fri,  5
        Nov 2021 13:19:32 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20211105131932eucas1p284bdb650732ceff3c8326ed578f22b1a~0qP2zQyFJ0990009900eucas1p2h;
        Fri,  5 Nov 2021 13:19:32 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211105131932eusmtrp2b5b2f5fe71dcf26ac12ca5bee73f61e4~0qP2yBP9e2295322953eusmtrp25;
        Fri,  5 Nov 2021 13:19:32 +0000 (GMT)
X-AuditID: cbfec7f5-d53ff7000002dc80-04-61852f645828
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 9C.5D.20981.46F25816; Fri,  5
        Nov 2021 13:19:32 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20211105131932eusmtip2c859289fa71724ed9abf275bfff6bab1~0qP2m8k3R2117921179eusmtip2c;
        Fri,  5 Nov 2021 13:19:31 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 1/2] ax88796c: fix ioctl callback
In-Reply-To: <20211105092954.1771974-1-arnd@kernel.org> (Arnd Bergmann's
        message of "Fri, 5 Nov 2021 10:29:39 +0100")
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
Date:   Fri, 05 Nov 2021 14:19:21 +0100
Message-ID: <dleftj5yt6loyu.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsWy7djP87op+q2JBpP3KliserydxeLvpGPs
        Ftu2bGK1mHO+hcVi5owTjBYXtvWxWlzeNYfNYu2Ru+wW7SufslkcWyDmwOXx+9ckRo8tK28y
        eWxa1cnmcXTPOTaPvi2rGD0+b5Lz2Pr5NksAexSXTUpqTmZZapG+XQJXxoqFt1kKpohVfF/1
        g62B8apQFyMnh4SAiUTr281MXYxcHEICKxgl3j5fDOV8YZTY8PYeM4TzmVFi6pTlbDAtn+de
        ZYRILGeUuH5zFQuE85xRYvPXT0AZDg42AT2JtWsjQBpEBJQlrn+bA9bALHCCSWLt769MIAlh
        AVOJqR/fg9mcAuUS6+cuZwWxRQUsJf48+8gOYrMIqEpMPdzNAmLzCphLNC1qYoOwBSVOznwC
        FmcWyJWYef4N2AIJgdmcEs8nnGcHOUJCwEVi9+VwiKuFJV4d38IOYctI/N85nwmipF5i8iQz
        iNYeRoltc36wQNRYS9w59wvqY0eJ5d9msULU80nceCsIsZZPYtK26cwQYV6JjjZokKpIrOvf
        AzVFSqL31QpGCNtD4tGX69Cg6mKUWLL5FcsERoVZSL6ZheSbWUBjmQU0Jdbv0ocIa0ssW/ia
        GcK2lVi37j3LAkbWVYziqaXFuempxcZ5qeV6xYm5xaV56XrJ+bmbGIHJ7PS/4193MK549VHv
        ECMTB+MhRhWg5kcbVl9glGLJy89LVRLhNb7YkijEm5JYWZValB9fVJqTWnyIUZqDRUmcV+RP
        Q6KQQHpiSWp2ampBahFMlomDU6qBycfQ7h3HwQWBnydN6Nm0xt5YfFVBt5jHi8fGHIn+yXNf
        XNkRfXvCpRV6j7dohOS/OH6mdf/nv7O/MoVPjKm1YZdPXNLA53zIKMHw3VrB22H+d/ZlZrxv
        P/f99646sb0X799s5OXd/WLLjCANl8hi6VdKtyI396z80fxyA0/x2Yt6k99E6GitYE19naqk
        b3XSoulsVtrdgN/POe5cXuOueP/TrT8KvlGFx5Ki7TmNIt/LfZFKOafycP2TB1sW6blF+Frr
        lket/7dsu6Di9XWGdS6X7+nyGTOuvXol1LKtoe9Rn3bvzD1mbyNk/6376qScIzt/R/eiM6ac
        f5c+Wal+pnO7+6XbQn+vCn9IVTdIqVNiKc5INNRiLipOBAB6V0fo4QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t/xe7op+q2JBm2v2C1WPd7OYvF30jF2
        i21bNrFazDnfwmIxc8YJRosL2/pYLS7vmsNmsfbIXXaL9pVP2SyOLRBz4PL4/WsSo8eWlTeZ
        PDat6mTzOLrnHJtH35ZVjB6fN8l5bP18myWAPUrPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jE
        Us/Q2DzWyshUSd/OJiU1J7MstUjfLkEvY8XC2ywFU8Qqvq/6wdbAeFWoi5GTQ0LAROLz3KuM
        XYxcHEICSxklZk85BORwACWkJFbOTYeoEZb4c62LDaLmKaPEyntvmUFq2AT0JNaujQCpERFQ
        lrj+bQ7YHGaBk0wSM+72MIEkhAVMJaZ+fA9mcwqUS6yfu5wVxBYSMJO427aZEcQWFbCU+PPs
        IzuIzSKgKjH1cDcLiM0rYC7RtKiJDcIWlDg58wlYnFkgW+Lr6ufMExgFZiFJzUKSmgV0HrOA
        psT6XfoQYW2JZQtfM0PYthLr1r1nWcDIuopRJLW0ODc9t9hIrzgxt7g0L10vOT93EyMwErcd
        +7llB+PKVx/1DjEycTAeYlQB6ny0YfUFRimWvPy8VCURXuOLLYlCvCmJlVWpRfnxRaU5qcWH
        GE2BXpjILCWanA9MEXkl8YZmBqaGJmaWBqaWZsZK4rwmR9bECwmkJ5akZqemFqQWwfQxcXBK
        NTBVlTPtOeuz7Hzc/9IPJ19r7lrw9ZFXy9cGhyutcwwSWCeVHTxxJFH14oQZy/c/D1b2DDpj
        X/zvzIELgWLfNz/4MT9tW7HUs+9GD5cvSRLZtHWl8YFfp7Zx2XXv+Ll6Q9vi+UHPXLdwzukw
        lOD2dlqfKrvEsy0kXKfkyOT1AVY6ahK9bO/9ulun8dtMNEvkX3hAJ3XljSxbNR07pdrP7mZ7
        53EdEmPdxPBvdtGm05sbrBUXxH7ZbpPpWb2u+oPmzhfqOVoRfgGCvcGST370zDt5oXTf9z8S
        lgk2hx82fLOKuXQp54pW2Ms5W3nlHmvrFc/OKORc5FqziLtmf7qe4cOM2hel3BPMDqx7/WaF
        1NnrSizFGYmGWsxFxYkAuzeToFkDAAA=
X-CMS-MailID: 20211105131932eucas1p284bdb650732ceff3c8326ed578f22b1a
X-Msg-Generator: CA
X-RootMTR: 20211105131932eucas1p284bdb650732ceff3c8326ed578f22b1a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20211105131932eucas1p284bdb650732ceff3c8326ed578f22b1a
References: <20211105092954.1771974-1-arnd@kernel.org>
        <CGME20211105131932eucas1p284bdb650732ceff3c8326ed578f22b1a@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2021-11-05 pi=C4=85 10:29>, when Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> The timestamp ioctls are now handled by the ndo_eth_ioctl() callback,

Actually neither the driver nor the chip support
timstamping. ax88796c_ioctl() simply wraps phy_mii_ioctl(). I believe
you swapped commit messages between this and the other patch in the
series.

> not the old ndo_do_ioctl(), but oax88796 introduced the
                                 ^^^=20
Typo here.=20

> function for the old way.

At first I though =E2=80=94 What did I mess up again? But then saw a7605370=
7dbf
is quite a new thing and ndo_do_ioctl() is still there, so my builds
didn't fail. Thanks, for the patch.

> Move it over to ndo_eth_ioctl() to actually allow calling it from
> user space.
>
> Fixes: a97c69ba4f30 ("net: ax88796c: ASIX AX88796C SPI Ethernet Adapter D=
river")
> Fixes: a76053707dbf ("dev_ioctl: split out ndo_eth_ioctl")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> It would be best to completely remove the .ndo_do_ioctl() callback
> to avoid this problem in the future, but I'm still unsure whether
> we want to just remove the ancient wireless and localtalk drivers
> instead of fixing them.
> ---
>  drivers/net/ethernet/asix/ax88796c_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Acked-by: Lukasz Stelmach <l.stelmach@samsung.com>

> diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethe=
rnet/asix/ax88796c_main.c
> index 4b0c5a09fd57..8994f2322268 100644
> --- a/drivers/net/ethernet/asix/ax88796c_main.c
> +++ b/drivers/net/ethernet/asix/ax88796c_main.c
> @@ -934,7 +934,7 @@ static const struct net_device_ops ax88796c_netdev_op=
s =3D {
>  	.ndo_stop		=3D ax88796c_close,
>  	.ndo_start_xmit		=3D ax88796c_start_xmit,
>  	.ndo_get_stats64	=3D ax88796c_get_stats64,
> -	.ndo_do_ioctl		=3D ax88796c_ioctl,
> +	.ndo_eth_ioctl		=3D ax88796c_ioctl,
>  	.ndo_set_mac_address	=3D eth_mac_addr,
>  	.ndo_set_features	=3D ax88796c_set_features,
>  };

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmGFL1kACgkQsK4enJil
gBBgawf/RllvbArEsDJkUKjH7yGlJ3Xg/bcC40kDl7k3/LBv43X1f45915LoyJr6
QN9rZFxJt7bLjb7gIFuoZr7YzrXL6G+zT6eIiSNj12bLmBIQO9Q56emT5cDtGap4
xSjVzQII7JG7Lp5jnjIOpZTWg9O48taICkDCUw838QXGoZZzFCJvtMBGQ97nx3FK
/abRaW/NM+IGsK9EbEpIFVLFlRUIotRSLaSgaB9HoT+Xm9aXBZanuaSSTLMiA4GO
TnSUR0c18bACN2l9mIuegXXVV8T2jDrolujgYlNeXKmKVVmtNH9nwfexcinG6WgA
yjKe4VajNq2+hl6o/kkchWlrgUoT9A==
=sDKN
-----END PGP SIGNATURE-----
--=-=-=--
