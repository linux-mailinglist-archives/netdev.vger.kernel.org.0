Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173842A6166
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 11:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgKDKVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 05:21:09 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41965 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgKDKVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 05:21:08 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201104102055euoutp017e70806b10090a4d1a9cf867bcfed04e~ERtat2ZFw2502425024euoutp01H;
        Wed,  4 Nov 2020 10:20:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201104102055euoutp017e70806b10090a4d1a9cf867bcfed04e~ERtat2ZFw2502425024euoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1604485255;
        bh=tAi+6eLpYGgM6NQaLyk8KzwgohfMuiPjvqb2EyAkySw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1x0Bm9JMM+KKFZ/TRKzy5Ix3sdDI4PU8lFlwT+vgop2IS8IIIEgEQeWRb7Vl6n30
         xRjQnFHzpv/tMd4GPMuViTdKa4yhgIpcQmhRdFIF3igZWMkko5ddkIb7d6lk60m5rA
         7DnJUFhON6EuNV2v5ZzpBIrrHhnCsHy8cpiHngzA=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201104102049eucas1p130cef7ee3b80fefcee8d058f60be375c~ERtVeyrC30494004940eucas1p1L;
        Wed,  4 Nov 2020 10:20:49 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 44.AC.06456.18082AF5; Wed,  4
        Nov 2020 10:20:49 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201104102048eucas1p1e3b29b66c497ee38656acf9ba5df10eb~ERtU-RHj80494004940eucas1p1K;
        Wed,  4 Nov 2020 10:20:48 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201104102048eusmtrp2666027ea81ad0a6d0f9e01605733bd66~ERtU_c0q22072420724eusmtrp2k;
        Wed,  4 Nov 2020 10:20:48 +0000 (GMT)
X-AuditID: cbfec7f2-809ff70000001938-02-5fa28081e643
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 04.71.06017.08082AF5; Wed,  4
        Nov 2020 10:20:48 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201104102048eusmtip18dc222cb21125f7540565cbaba6d8fc0~ERtUwY4XC2324823248eusmtip1j;
        Wed,  4 Nov 2020 10:20:48 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     jim.cromie@gmail.com, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewic?= =?utf-8?Q?z?= 
        <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v5 3/5] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Wed, 04 Nov 2020 11:20:37 +0100
In-Reply-To: <20201104024211.GS933237@lunn.ch> (Andrew Lunn's message of
        "Wed, 4 Nov 2020 03:42:11 +0100")
Message-ID: <dleftj361ps9sa.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRjm2zln57iafC7TN5OwaUEXTSvqi0oq+nF+RERBV8xWHpy5zdi0
        sj8paJTkJU3SYVliZhteG6tVRh1NM9GjWWaiFd3zgpGLNNJyngX9e973eZ73e96Xj6M0k0wQ
        l2BKFswmnUGrVNHO5gkpPD2tLDbSnTuPSAMiReqKahhSImXQpLSpgyFlo0UM6RnpZ0ju+yGK
        SFItSzqdOQypf9/DkO67JUpSJD1QELGwAZGqpgGWNF8NIJkNTewmzHf3dFG84+YrBe+yDrB8
        ve2ckr9Vfpp33RlT8DkOG+LH6hfs4ParNsQJhoTjgnlF9CGV/nlhIXvMFnBS+tDCpqEmTRby
        4QCvhsbLP1AWUnEaXIngaZaVlgs3gi+9Ewq5GEPwczyD/We5PZyhlIkbCD7dKvD6PyMYrXs5
        reI4JY6Aqqq9HoM/DoGLrb8Zj4bCL2h4ab/CeIg5eDc8sLmRB9N4EfSLt2ewDzbADVfljEaN
        10JFo13hwXPxOnB8ecPKfT9oLf5AezCFjVAsDc+EAHydA7F5QilH3QrZOe8YGc+BwRaHd4Vg
        +OMqVXiCAj4NBflrZO95BM6ScVrWrIf+jl/eOZsh/eZXr94Xekf85Hd9Id95iZLbajh7xnvT
        MKjOve+dEgTZg5VIlvDQ03VYPlU6AsfEc2UeCrH+t431v22s0xYKL4Gauyvk9jKouDZEyXgj
        VFeP0lcRY0OBQorFGC9YokzCiQiLzmhJMcVHHEky1qPpj9g21fL9Dvrx7LCIMIe0s9UPnddi
        NYzuuCXVKKKw6Unvau2dKIg2JZkErb96S3vbQY06Tpd6SjAnxZpTDIJFRPM5WhuoXlX2NUaD
        43XJQqIgHBPM/1gF5xOUhsp+ji6Ma49JDM+oude6Jl/vP6vOMLVYHD4lfdu58mNjaldML+/L
        Boe6a6vNvouCr0Tmldu/i4SntZejA3e7I5YnR0UGbBlxpdD73HtGGvYceXwhdNuBbFLZd+Zt
        Z17fvvEslXuy++jSo2Edqx+pnYlc9JO+/kx93lCBvXT76116LW3R66KWUmaL7i8SLyCYkAMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t/xu7oNDYviDb63GFucv3uI2WLjjPWs
        FnPOt7BYzD9yjtVi0fsZrBbX3t5hteh//JrZ4vz5DewWF7b1sVpsenyN1eLyrjlsFjPO72Oy
        ODR1L6PF2iN32S2OLRCzaN17hN1BwOPytYvMHltW3mTy2DnrLrvHplWdbB6bl9R77Nzxmcmj
        b8sqRo/Pm+QCOKL0bIryS0tSFTLyi0tslaINLYz0DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLL
        Uov07RL0Mq5MncpesEqs4vyT4+wNjEeEuhg5OSQETCS2v2lh62Lk4hASWMoosXnhXcYuRg6g
        hJTEyrnpEDXCEn+udUHVPGWUaJs7hxmkhk1AT2Lt2giQGhEBBYkpJ/+wgtQwC9xgkdjcfJkF
        JCEsECJxe/lvdhBbSEBXonn3fmYQm0VAVeLOoe1guzgFciRW/okDCfMKmEssO7yaCcQWFbCU
        2PLiPjtEXFDi5MwnYCOZBbIlvq5+zjyBUWAWktQsJKlZQFOZBTQl1u/ShwhrSyxb+JoZwraV
        WLfuPcsCRtZVjCKppcW56bnFRnrFibnFpXnpesn5uZsYgbG87djPLTsYu94FH2IU4GBU4uE9
        sG1hvBBrYllxZe4hRhWgMY82rL7AKMWSl5+XqiTC63T2dJwQb0piZVVqUX58UWlOavEhRlOg
        NycyS4km5wPTT15JvKGpobmFpaG5sbmxmYWSOG+HwMEYIYH0xJLU7NTUgtQimD4mDk6pBsbV
        QeHmRl5r3hTJaB3mYJdZuFa6fv77m1+KdO3n/fLw26qy/EXX45se+x5ZmX/yWjpd+66CWeXx
        AN+EM1PPOJVL9N5imJQ08ffP72uyeRduvKlvOHdxLt8kpkk5nVHb6+696To5w+HSZBPLeumN
        UhwHLDYfnKMw5/5OK+Y+/z27b/DpVSWfl7NWYinOSDTUYi4qTgQAA52AgQcDAAA=
X-CMS-MailID: 20201104102048eucas1p1e3b29b66c497ee38656acf9ba5df10eb
X-Msg-Generator: CA
X-RootMTR: 20201104102048eucas1p1e3b29b66c497ee38656acf9ba5df10eb
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201104102048eucas1p1e3b29b66c497ee38656acf9ba5df10eb
References: <20201104024211.GS933237@lunn.ch>
        <CGME20201104102048eucas1p1e3b29b66c497ee38656acf9ba5df10eb@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-11-04 =C5=9Bro 03:42>, when Andrew Lunn wrote:
>> +config SPI_AX88796C_COMPRESSION
>> +	bool "SPI transfer compression"
>> +	default n
>> +	depends on SPI_AX88796C
>> +	help
>> +	  Say Y here to enable SPI transfer compression. It saves up
>> +	  to 24 dummy cycles during each transfer which may noticably
>> +	  speed up short transfers. This sets the default value that is
>> +	  inherited by network interfecase during probe. It can be
>
> interface
>

Done.

>> +	  changed in run time via spi-compression ethtool tunable.
>
> changed _at_ run time...
>

Done.

>> +static int
>> +ax88796c_set_tunable(struct net_device *ndev, const struct ethtool_tuna=
ble *tuna,
>> +		     const void *data)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	switch (tuna->id) {
>> +	case ETHTOOL_SPI_COMPRESSION:
>> +		if (netif_running(ndev))
>> +			return -EBUSY;
>> +		ax_local->capabilities &=3D ~AX_CAP_COMP;
>> +		ax_local->capabilities |=3D *(u32 *)data ? AX_CAP_COMP : 0;
>
> You should probably validate here that data is 0 or 1. That is what
> ax88796c_get_tunable() will return.
>
> It seems like this controls two hardware bits:
>
> SPICR_RCEN | SPICR_QCEN
>
> Maybe at some point it would make sense to allow these bits to be set
> individually? If you never validate the tunable, you cannot make use
> of other values to control the bits individually.

Good point. What is your recommendation for the userland facing
interface, so that future changes will be least disruptive?

ax_local->capabilities |=3D ((*(u32 *)data) & SPICR_RCEN) ? AX_CAP_COMP : 0;

or rather

ax_local->capabilities |=3D ((*(u32 *)data) & (SPICR_RCEN | SPICR_QCEN)) ? =
AX_CAP_COMP : 0;

and possibly in the future (or now) split it into=20

ax_local->capabilities |=3D ((*(u32 *)data) & SPICR_RCEN) ? AX_CAP_COMP_R :=
 0;
ax_local->capabilities |=3D ((*(u32 *)data) & SPICR_QCEN) ? AX_CAP_COMP_Q :=
 0;

(and appropriate masking abve and proper handling in
ax88796c_soft_reset()).

Kind regards
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+igHUACgkQsK4enJil
gBDpnQf/cbn9zvVOSpwY+Yl0IedAqG6YyKtEcI+wgKi8WGod8AlkCjEiaWFllLGw
pLRiQz56g3mF0yTitLwdY9mA6Q2joEFPaJguJeVI6GhV9W3uoeWXl68DT5OtiHvp
21BtS2RqBzGahVGMRwqt7jDMsLBV2PiqymA0UeFCspWHqjpqRw5s7vy5ySBS+qkp
23g8vTpxXhKjLdogK0S2bL8kZT3kcpdVSIw39LxuTHscA3jxuFDX1sVoYpn30nRM
9sNj5SQC6i0ja+Uoaeju4kLbeIU8IxrwfpiHKU8G7zZqmSb2F0RUIpRBNxJoK897
dlH3+R8pzTOpDSFM29eRFfVPDQIZog==
=2VnL
-----END PGP SIGNATURE-----
--=-=-=--
