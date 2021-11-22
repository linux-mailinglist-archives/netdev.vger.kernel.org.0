Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18830458FC8
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 14:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbhKVNzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 08:55:48 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60313 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhKVNzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 08:55:47 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20211122135239euoutp011849d20d9a8dfdc9b2462c25ccd581d2~54qoHoq3L3005830058euoutp01g;
        Mon, 22 Nov 2021 13:52:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20211122135239euoutp011849d20d9a8dfdc9b2462c25ccd581d2~54qoHoq3L3005830058euoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1637589159;
        bh=5UPvjGb4q8O15eAxfvLNzLhdKg1UMmGL6QheNnLVuMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swr9CLFf530hVdopI0/vccgN08qh0/gpk1Y3LoYTB23e4yVgVT67GqLBHtr3z7FBv
         LCrNCXCflrTOenTSIKurtgEAPnsK/tFU1IwR9lTt8VR1wWMi5ibvAwD2gUysp3cVcK
         xATdJH9XYD8NJlltDj6FQwTcNjxtixZ7XAKbVzoQ=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211122135239eucas1p153183b212646a619fd65f799aa4c9668~54qn7sD3N1646016460eucas1p16;
        Mon, 22 Nov 2021 13:52:39 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 7C.3A.10260.6A0AB916; Mon, 22
        Nov 2021 13:52:39 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20211122135238eucas1p1e46674d13b4f6f504558f4102cfe3a85~54qnRdMfV0785307853eucas1p1o;
        Mon, 22 Nov 2021 13:52:38 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211122135238eusmtrp238e5b09563a94bd7418698862a2ad03e~54qnQx22y1415314153eusmtrp2Q;
        Mon, 22 Nov 2021 13:52:38 +0000 (GMT)
X-AuditID: cbfec7f5-bf3ff70000002814-31-619ba0a63763
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id AC.F6.09404.6A0AB916; Mon, 22
        Nov 2021 13:52:38 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20211122135238eusmtip28b300fcd29e37939b374ea1136c3d6e2~54qnE06z91468714687eusmtip2v;
        Mon, 22 Nov 2021 13:52:38 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: ax88796c: do not receive data in pointer
Date:   Mon, 22 Nov 2021 14:52:27 +0100
In-Reply-To: <20211121200642.2083316-1-nicolas.iooss_linux@m4x.org> (Nicolas
        Iooss's message of "Sun, 21 Nov 2021 21:06:42 +0100")
Message-ID: <dleftjk0h0e1r8.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01SaUwTURDO227LUm2zLVXHesRUNB5YVDwKotGIWP9p/AEeCa6yqSi02IIg
        EiWxagVRaFUsYsRIANcUsSIBvNvIVaV4QBTxCGAVPJBLwQNl2Zr475uZ73gzeQRPWsiXEzHa
        BFqvpWIVAiFeXj3knleUf46an3cZU+W5jbiqsfwEX/W0Kk+gqs4fr7pntPBW8tVll19gajtz
        TKBu+naWr+6zT12PbxaGRtOxMXtpfeCKbcKd1vRKPL5JnvzTdZ6fhjrHpSOCAHIRvK6Ym458
        CSlZjKD6ti4dCUdwP4JCmxXnij4EFS2diGWxgoF8l4AbFCFoeziMccV7BJVPOwSsrYBUgs0W
        yQpkZCA4L7QglsMjTQjav3wQsAM/Mhzc/RYfFuPkDLhW4Bg18iWNCLr6WkZJInIpfHybg7F4
        HBkMvzw9PlxfAnXWDpzFPDIOrO5PowlAviWgoKpJwL01DBhXL85hP+iqKfPh8GT4U3kB4w5w
        ECzmJZz2OILyvEEvfxm0Nvzw+qyC8wNsMMsXw/PPEi5XDObyHB7XFoHpiJRj+0PJyVteFzlk
        dhV7L6eG0p4O77HOIPiUfYifhabl/rdO7n/r5I7Y8sjZcLUqkGvPhcKLH3kcXg4lJd14PuIz
        aAKdaIjT0IYgLZ2kNFBxhkStRrlDF2dHI9/HNVwzUIGKu3qUDoQRyIH8R8RtpVcakRzX6rS0
        QiYiSnMoqSia2pdC63VR+sRY2uBAkwhcMUEk+5VGSUkNlUDvpul4Wv9vihG+8jQsm/9mfJ2f
        85VHVvSY7u9d018TGF8Y3wy9wc0uz5fMr482re0b3O5J1p1urItwEsztVQ0MlnqibczdgA2H
        GdNRSbff0VdDTJi5LCJzi/Dg0MbsSHGtpHrrvpAPC8XrNoiPTIzcEbFm48tWm/2+9YrHBLsy
        9TNqmW+XJhkLpoPb34zt2mNONg42hAxVLTrFpDY/2Z9wun77saCATc69qboQRUbwoDilPcUZ
        Yw+a2Rua9ed3lObBQLTkeNaBSk/J2cWrNd2WKWNqv7dfdciUYzMarc0Pwg0/fTpbhzNsSUVh
        ex5GHboRveBNKFUfYrm+DF9NJ22dVV/zbnfoOdPNZ00BdxS4YSe1YA5Pb6D+AunTV5u5AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t/xe7rLFsxONFi0QcxizvkWFosL2/pY
        LS7vmsNmcWyBmMWBlsnMDqweW1beZPLYtKqTzePqtxmsHp83yQWwROnZFOWXlqQqZOQXl9gq
        RRtaGOkZWlroGZlY6hkam8daGZkq6dvZpKTmZJalFunbJehlzOzayVJwVari9+m5rA2ML0W7
        GDk5JARMJL4uOM3WxcjFISSwlFFi8rLVTF2MHEAJKYmVc9MhaoQl/lzrgqp5yihxaPkvRpAa
        NgE9ibVrI0BqRAT0JQ7Pv8UIUsMs0MEosXLpPRaQhLCAm8T5L5PZQWwhASeJm2++sIHYLAKq
        EhuXHGICaeAUaGGUePX5FliCV8Bc4vWD6UwgtqiApcSfZx/ZIeKCEidnPgEbyiyQLfF19XPm
        CYwCs5CkZiFJzQK6j1lAU2L9Ln2IsLbEsoWvmSFsW4l1696zLGBkXcUoklpanJueW2ykV5yY
        W1yal66XnJ+7iREYO9uO/dyyg3Hlq496hxiZOBgPMaoAdT7asPoCoxRLXn5eqpIIL8eG6YlC
        vCmJlVWpRfnxRaU5qcWHGE2BfpvILCWanA+M6rySeEMzA1NDEzNLA1NLM2MlcV7Pgo5EIYH0
        xJLU7NTUgtQimD4mDk6pBqaWe+xb/t3qfsRVe9KlaN4G4Q12scIlMixG4i/eWa9qFXt0/OuK
        Kbsa2p3/i1ayO9e0dEqKu0xzurArOFfdP41fukxEKXR1JJeC2MMDHEejox7PzRPxD1w/seTZ
        5aeKKyw1tRqFU1R/722z1Cy4XXPHKvFLwUqre3s9q7hcDfQTSueZv1vr6DzdSOHzIcm+hO4J
        Wa7fJTRdWZfIP9i+P2taxMxdP2KZZosavV9me8nio+j8tpViid9eM5+vlZ2YbiKaOOfDqucC
        L+RUnC991rfaXrola+OFhUJqF342ZHIGNh5s/HqR7WeV+Zensv9tWox31GqtXv3ksnhISarO
        oqJb0mGZj3LFVS41v7+7TYmlOCPRUIu5qDgRAK7oywcyAwAA
X-CMS-MailID: 20211122135238eucas1p1e46674d13b4f6f504558f4102cfe3a85
X-Msg-Generator: CA
X-RootMTR: 20211122135238eucas1p1e46674d13b4f6f504558f4102cfe3a85
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20211122135238eucas1p1e46674d13b4f6f504558f4102cfe3a85
References: <20211121200642.2083316-1-nicolas.iooss_linux@m4x.org>
        <CGME20211122135238eucas1p1e46674d13b4f6f504558f4102cfe3a85@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2021-11-21 nie 21:06>, when Nicolas Iooss wrote:
> Function axspi_read_status calls:
>
>     ret =3D spi_write_then_read(ax_spi->spi, ax_spi->cmd_buf, 1,
>                               (u8 *)&status, 3);
>
> status is a pointer to a struct spi_status, which is 3-byte wide:
>
>     struct spi_status {
>         u16 isr;
>         u8 status;
>     };
>
> But &status is the pointer to this pointer, and spi_write_then_read does
> not dereference this parameter:
>
>     int spi_write_then_read(struct spi_device *spi,
>                             const void *txbuf, unsigned n_tx,
>                             void *rxbuf, unsigned n_rx)
>
> Therefore axspi_read_status currently receive a SPI response in the
> pointer status, which overwrites 24 bits of the pointer.
>
> Thankfully, on Little-Endian systems, the pointer is only used in
>
>     le16_to_cpus(&status->isr);
>
> ... which is a no-operation. So there, the overwritten pointer is not
> dereferenced. Nevertheless on Big-Endian systems, this can lead to
> dereferencing pointers after their 24 most significant bits were
> overwritten. And in all systems this leads to possible use of
> uninitialized value in functions calling spi_write_then_read which
> expect status to be initialized when the function returns.
>
> Moreover function axspi_read_status (and macro AX_READ_STATUS) do not
> seem to be used anywhere. So currently this seems to be dead code. Fix
> the issue anyway so that future code works properly when using function
> axspi_read_status.
>

Thank you for spotting and fixing this one.

> Fixes: a97c69ba4f30 ("net: ax88796c: ASIX AX88796C SPI Ethernet Adapter D=
river")
>
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
> ---
>  drivers/net/ethernet/asix/ax88796c_spi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Acked-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>

> diff --git a/drivers/net/ethernet/asix/ax88796c_spi.c b/drivers/net/ether=
net/asix/ax88796c_spi.c
> index 94df4f96d2be..0710e716d682 100644
> --- a/drivers/net/ethernet/asix/ax88796c_spi.c
> +++ b/drivers/net/ethernet/asix/ax88796c_spi.c
> @@ -34,7 +34,7 @@ int axspi_read_status(struct axspi_data *ax_spi, struct=
 spi_status *status)
>=20=20
>  	/* OP */
>  	ax_spi->cmd_buf[0] =3D AX_SPICMD_READ_STATUS;
> -	ret =3D spi_write_then_read(ax_spi->spi, ax_spi->cmd_buf, 1, (u8 *)&sta=
tus, 3);
> +	ret =3D spi_write_then_read(ax_spi->spi, ax_spi->cmd_buf, 1, (u8 *)stat=
us, 3);
>  	if (ret)
>  		dev_err(&ax_spi->spi->dev, "%s() failed: ret =3D %d\n", __func__, ret);
>  	else

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmGboJsACgkQsK4enJil
gBBbAQf+LGRklhU4VJHDmVpF8P0R/Dqjs9+NNBmydtCQTkcJ6uuHwvE1igEJL/Ap
zQxWk143mdmbvhWThnVah83o0RH/0qArJ78iAFNyDikon+wtEqiiEWLuj/UBTplS
AwqvGYhSrkwrzErdMxSzH6M6cCUl9zUThlmExGwqUHGfsatecbo26uV2cBe9cPhs
5QoDNGjuhs2RTCOGpcYL9xL7xyqe6xh+AwAsUsGTPn+dnn13z95Ih+IxbrhYXrga
zYvjRPTmZZDKUDsQs6xdvHSw3Qgt0u8GoB7ZyDDGgBeh5zLy6zev5VPOyPp12kRE
xJjS1XqOPFZcPFJsSIHIkGx9X6BbOQ==
=u3wQ
-----END PGP SIGNATURE-----
--=-=-=--
