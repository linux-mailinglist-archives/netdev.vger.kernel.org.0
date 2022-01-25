Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D6449B441
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 13:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455410AbiAYMqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 07:46:05 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39544 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453272AbiAYMnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 07:43:47 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220125124341euoutp021dab8921ae42562bb9cbc2102fb13847~NhArgqoAL0065500655euoutp02g;
        Tue, 25 Jan 2022 12:43:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220125124341euoutp021dab8921ae42562bb9cbc2102fb13847~NhArgqoAL0065500655euoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1643114621;
        bh=W1VJKej5tvxUTH001aI8Z1FA4oOGwRlch3xBtFp8eGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TP4MnGRLtGbBLT7gxojViSrwH5Zj0lD7S383bKJtGpbE78MELVjhdNWrhRwEQPv07
         l1djISyIpjXWsd4okvaxBNW84AdnYEQnWA90bpG8UnJ46tdN1n1C+f1apd8G79PRvR
         tGqO141mW0kCcGe3Mmc5e5sfNq30EIu53nJkIvB4=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220125124341eucas1p2739e597c949b0ec2fb4f48e2eafbf821~NhArXjzAG2646926469eucas1p2a;
        Tue, 25 Jan 2022 12:43:41 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id C0.36.10009.D70FFE16; Tue, 25
        Jan 2022 12:43:41 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220125124340eucas1p2504c36206c5c17f63663a814fc8f7feb~NhAq-AvkH2646426464eucas1p26;
        Tue, 25 Jan 2022 12:43:40 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220125124340eusmtrp231d4a83b4646831988952eca3561df89~NhAq_AalO1895218952eusmtrp2e;
        Tue, 25 Jan 2022 12:43:40 +0000 (GMT)
X-AuditID: cbfec7f2-e95ff70000002719-42-61eff07d5a41
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 7A.0E.09522.C70FFE16; Tue, 25
        Jan 2022 12:43:40 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220125124340eusmtip2e8675654e52a53b73a55f6f608394cc0~NhAqyR9Vk2435324353eusmtip2A;
        Tue, 25 Jan 2022 12:43:40 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] spi: make remove callback a void function
Date:   Tue, 25 Jan 2022 13:43:31 +0100
In-Reply-To: <20220123175201.34839-6-u.kleine-koenig@pengutronix.de> ("Uwe
 =?utf-8?Q?Kleine-K=C3=B6nig=22's?= message of "Sun, 23 Jan 2022 18:52:01
        +0100")
Message-ID: <dleftjtuds2dfw.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfUyMcRz3u+e55547rv1cL76dmN2KaF2FuvOSeW1hw2bMaHjkUdFdPOfk
        JW/zlkjcyXFpKcYN5WbtLiE6ZGEnsolueYlQkqPlZRWdH5v/Pt/v5+X7/f72YynFUbGSTdOv
        5wU9l65iZLSj5oc7cuvnDi663CHR1leeZLQ7vc8k2ppTQdrGI2Y0mU7M64lO/Hp56DzRYtnE
        lXx62gZeiJq0XJZ6tT14bZ3/xpKnuZIdqBbnICkLeCwc7HWIcpCMVWAbgubXHxApOhE0nW2g
        SPEVQbG1S/zP4rG9YAhxDsGF69/+qt4hyK8+RucglmWwGkpLF/lgAE6A3MKlPi+FF8ChF89p
        H/bHU2Gn/QDjwzQOg6qmPRJfjBQXIXDaCv6I5FgDBU4fIWUD8TjobvFKSH8g1J54Q5NQHZx4
        +PHP2oBvs1Da4hL7BgOeDiXuMLK0P7TeLZcQHAK/rhSJiGQ7mE1xxHoQgePkd5poJoDH/ZMh
        eAo4KmoZoveDhvaBZKwfmBwWirTlkL1XQdShUJZ37W+KEnJbbYjgRHC+PCAmL2VBUGe1SA6j
        Ydb/rrH+d421L5bCI+FSZRRpR8DZ4jaK4HgoK+ugTyHxeTSINxp0KbwhRs9nqg2czmDUp6iT
        M3SXUd9nud9790sFKmz1ql1IxCIXCu0zv7ZfqENKWp+h51UB8l+zOziFfCW3aTMvZCwTjOm8
        wYUGs7RqkDw5zc4pcAq3nl/D82t54R8rYqXKHaJloUnrCp/vqmI0+2LbVqDmvIRb2fHuPX5s
        v5rCkISGoPey9idsd2pgooI1RJ3GXtObGL09uMQ9t7GXml/2dlZTS9rIeRqNOP7ZFoqZcOmT
        MV8JsdFzRoRZp+2ac2bprCrXtiWHw4/f+bniuuTHvcxb0h5kUp1+5PAvsi/URmZfbEwIT4p3
        9VudH8jcrF/jnH++U9jt0sVVPwoNaPPsvq+r798ZnjU81l6/aF1QTUxyyDl3ruOaOW70PrdN
        vSpPsAWD2VLt7SrdntVf7TfUNDN1v0ZXVWweMn3GB0++58YI3P2ppyuiMSrL/Coz0lkx4HGz
        cPzBGOP4ji3JBfbNlmYVbUjlYkZRgoH7DQaQvc6nAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e/4Pd2aD+8TDZae1rC4vGsOm0Xjx5vs
        FscWiFncnjiZ0YHFo/+vgcfnTXIBTFF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYmlnqGxuax
        VkamSvp2NimpOZllqUX6dgl6GbvfShZcEK5YdL2XvYHxpEAXIyeHhICJxJ0V99m6GLk4hASW
        MkrMff6LqYuRAyghJbFybjpEjbDEn2tdUDVPGSXaNv1kA6lhE9CTWLs2AsQUEXCT6J0bB1LO
        LBAqMffjbxYQW1jASaJxQzcbiC0k4Czxp/0vK4jNIqAqse9eKzvISE6B+YwSq/unMIMkeAXM
        JWZvB0lwcogKWEr8efaRHSIuKHFy5hMWiAXZEl9XP2eewCgwC0lqFpLULKCTmAU0Jdbv0ocI
        a0ssW/iaGcK2lVi37j3LAkbWVYwiqaXFuem5xYZ6xYm5xaV56XrJ+bmbGIFRse3Yz807GOe9
        +qh3iJGJg/EQowpQ56MNqy8wSrHk5eelKonw/vd+nyjEm5JYWZValB9fVJqTWnyI0RTot4nM
        UqLJ+cB4zSuJNzQzMDU0MbM0MLU0M1YS5/Us6EgUEkhPLEnNTk0tSC2C6WPi4JRqYJqw+fLn
        18FXl1z6GqRxYvHkOP9tj5bqLcnPeqtu19/8J0J20x15jXuNi50LVi3WiFeVObbtjA6T6hJX
        ptD4jVcZd/lKddRpvcht+BdwTEToTv69i1U3vlV6HjftZJxZUs3NFBSm9ZnvkuQ1y68XnOPN
        /HJv/76+t1bT/uz07dnyGpvXscmtbZq/QCA8PSNidv7m//+F94isdj22Y0aYEvvSmLbisz7G
        G96tt119JHGu45HYklU98clBPqkWfsGe2U4K1ys+Fe5mOang1BuXkbn0cHl8VHCqpdb6qasT
        u8WZJNQ2piy2LtSzeL6aT7Nh7w031yW1fVUK86yO8i7K3OsWkbj3yxFlWwb5+/fFlViKMxIN
        tZiLihMBmc3x9h8DAAA=
X-CMS-MailID: 20220125124340eucas1p2504c36206c5c17f63663a814fc8f7feb
X-Msg-Generator: CA
X-RootMTR: 20220125124340eucas1p2504c36206c5c17f63663a814fc8f7feb
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220125124340eucas1p2504c36206c5c17f63663a814fc8f7feb
References: <20220123175201.34839-6-u.kleine-koenig@pengutronix.de>
        <CGME20220125124340eucas1p2504c36206c5c17f63663a814fc8f7feb@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2022-01-23 nie 18:52>, when Uwe Kleine-K=C3=B6nig wrote:
> The value returned by an spi driver's remove function is mostly ignored.
> (Only an error message is printed if the value is non-zero that the
> error is ignored.)
>
> So change the prototype of the remove function to return no value. This
> way driver authors are not tempted to assume that passing an error to
> the upper layer is a good idea. All drivers are adapted accordingly.
> There is no intended change of behaviour, all callbacks were prepared to
> return 0 before.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---

[...]


>  drivers/net/ethernet/asix/ax88796c_main.c             |  4 +---

[...]

>  191 files changed, 197 insertions(+), 545 deletions(-)
>

Acked-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>


[...]

> diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethe=
rnet/asix/ax88796c_main.c
> index e7a9f9863258..bf70481bb1ca 100644
> --- a/drivers/net/ethernet/asix/ax88796c_main.c
> +++ b/drivers/net/ethernet/asix/ax88796c_main.c
> @@ -1102,7 +1102,7 @@ static int ax88796c_probe(struct spi_device *spi)
>  	return ret;
>  }
>=20=20
> -static int ax88796c_remove(struct spi_device *spi)
> +static void ax88796c_remove(struct spi_device *spi)
>  {
>  	struct ax88796c_device *ax_local =3D dev_get_drvdata(&spi->dev);
>  	struct net_device *ndev =3D ax_local->ndev;
> @@ -1112,8 +1112,6 @@ static int ax88796c_remove(struct spi_device *spi)
>  	netif_info(ax_local, probe, ndev, "removing network device %s %s\n",
>  		   dev_driver_string(&spi->dev),
>  		   dev_name(&spi->dev));
> -
> -	return 0;
>  }
>=20=20
>  #ifdef CONFIG_OF

[...]


=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmHv8HMACgkQsK4enJil
gBDZLwgAiQJmNfQTvlC3zqDkdVoOLECSq3mkDbjbEVXF6lQqJgFV1Ttj18n0lPRf
iagQVxD3rOILZy3/bK4mDM175TaaWmFvwCKS5PVt/fB6oY85XBtl/SG/qsoNJe0U
9fs0KFPAfHj/uO1aA7pUUwJuaIvQrSyLGVtxJ0MPW3yT00EK7efTZH0jvBbg9RfO
zdubRqyhLIKOOeuhhcERk6/+cWLAex3tmudHqG3+n0MrmD6m5/Yt42JPo+TcAz80
6/63/ZJAE+DHQEvX5nog5flnTGN+17sLFk7kVXRyeYNubYBfPC2uGQ0gjY0gl3a2
bapr4wAW1WYQ/DQSX1isrfZVKDto6Q==
=qN9z
-----END PGP SIGNATURE-----
--=-=-=--
