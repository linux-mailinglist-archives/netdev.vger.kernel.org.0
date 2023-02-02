Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947056889E5
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 23:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbjBBWgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 17:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbjBBWgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 17:36:48 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420766C127;
        Thu,  2 Feb 2023 14:36:39 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20230202223635euoutp028aa85a05136d84479868026cc689723e~AIt10sLuV3268532685euoutp02k;
        Thu,  2 Feb 2023 22:36:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20230202223635euoutp028aa85a05136d84479868026cc689723e~AIt10sLuV3268532685euoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1675377395;
        bh=gVVzobgWD0G710KRWrH/TSkLkwxMnOuivRvOp9v6yRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMSNvXT8Ab+F1nvnspXW57dvOd9mwSVHrFr8sT5NmeyH3GeipkcHKvyStl+j+QuHz
         B3Bc0IfhJ74vzK9laRhPNAhmhCoQUw+wHH8P+1CLqFCEjgBvwsgKVdnxLLMmajCJO0
         4UPuPMef0hjWI3Fv+O1x6YXcCLLfM+DymxDXB/GU=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20230202223635eucas1p109b71e662fe17b031b4418058286079b~AIt1VpyHE0574105741eucas1p1J;
        Thu,  2 Feb 2023 22:36:35 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 3D.C1.13597.3FA3CD36; Thu,  2
        Feb 2023 22:36:35 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20230202223633eucas1p2d9ec5e0fee227cb5a1bcb81c3c137859~AItz__UUS1056510565eucas1p2M;
        Thu,  2 Feb 2023 22:36:33 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230202223633eusmtrp1b5669b54abbfb025d772f3525741d56f~AItz_aQDl1505515055eusmtrp1f;
        Thu,  2 Feb 2023 22:36:33 +0000 (GMT)
X-AuditID: cbfec7f4-1f1ff7000000351d-35-63dc3af349dc
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 09.17.02722.1FA3CD36; Thu,  2
        Feb 2023 22:36:33 +0000 (GMT)
Received: from localhost (unknown [106.120.51.111]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230202223633eusmtip12c1b8a24bb4e64544e26c2a3b62aa921~AItzwQ-py1095610956eusmtip11;
        Thu,  2 Feb 2023 22:36:33 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/13] net: Replace all spi->chip_select and
 spi->cs_gpiod references with function call
Date:   Thu, 02 Feb 2023 23:36:33 +0100
In-Reply-To: <20230202152258.512973-3-amit.kumar-mahapatra@amd.com> (Amit
        Kumar Mahapatra's message of "Thu, 2 Feb 2023 20:52:47 +0530")
Message-ID: <dleftjedr7itji.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsWy7djPc7qfre4kG0ybKGDxZ7GqxZzzLSwW
        F7b1sVpc3jWHzeLYAjGLb6ffMDqwebRe+svmsWXlTSaPTas62Tze77vK5vF5k1wAaxSXTUpq
        TmZZapG+XQJXxrJt95kK9olVvD9xlaWB8ZNQFyMnh4SAicS1l0tZQWwhgRWMEss6I7oYuYDs
        L4wS9x98g0p8ZpSY8UwXpqG5q5MJIr6cUeL7Fk2IhheMEhu37Adq4OBgE9CTWLs2AqRGRMBc
        4uqS/2D1zALFEkt/dTKD2MIChRIrj0wGi7MIqEpcuncBLM4p0MUoMWFOOYjNC9T7b+49sBpR
        AUuJP88+skPEBSVOznzCAjEzV2Lm+TeMIDdICDzhkLj3+zwLxKEuEpe2HWKFsIUlXh3fwg5h
        y0icntzDAtHQzijRdGUhK4QzgVHic0cTE0SVtcSdc7/YIGxHiePXzzCCfCYhwCdx460gxGY+
        iUnbpjNDhHklOtqgIaoisa5/D9QNUhK9r1YwQtgeEmvf3WWEBNY0Rol5O6eyT2BUmIXkoVlI
        HpoFNJZZQFNi/S59iLC2xLKFr5khbFuJdevesyxgZF3FKJ5aWpybnlpslJdarlecmFtcmpeu
        l5yfu4kRmIxO/zv+ZQfj8lcf9Q4xMnEwHmJUAWp+tGH1BUYplrz8vFQlEd4r824nC/GmJFZW
        pRblxxeV5qQWH2KU5mBREufVtj2ZLCSQnliSmp2aWpBaBJNl4uCUamCaLVv+ttBc784JJUv/
        i53RlpHfqz1ENgeabW8ylhQQnHZa43H9QnPLz4s/7F7g13zzitSRB93si5ebysvzzNjX+NUp
        6dv2k1dr2WwmWSwKKouUOPJkv+du21eJh6vMju899HP1gyfLfshYNjnduMJUvnlb9Kn32zaY
        BE90fh7qcVWmvL9qobypWNjqA4kZ4R8/OQv+cBRTl7x2zSI0YI7FTNaAjulx4bE1SgF//FvE
        /K+90ffrLWad5n7pfq7SpjbFDVpmYhcn/dbcI7fByoHZSi0zuuyOYsSreqFXDgcqtc/dtFu/
        2zB2t4pxc/vNr/3xz/Zaxp5XniR7zsR42bEdbw448PYoiPKbLdli4arEUpyRaKjFXFScCAAF
        W89OwQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t/xu7ofre4kG8w5YmjxZ7GqxZzzLSwW
        F7b1sVpc3jWHzeLYAjGLb6ffMDqwebRe+svmsWXlTSaPTas62Tze77vK5vF5k1wAa5SeTVF+
        aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZapG+XYJexrJt95kK9olV
        vD9xlaWB8ZNQFyMnh4SAiURzVydTFyMXh5DAUkaJgyeOMXcxcgAlpCRWzk2HqBGW+HOtiw2i
        5hmjROvv34wgNWwCehJr10aA1IgImEtcXfKfCcRmFiiWeHDwE5gtLFAosfLIZDBbSMBJ4vTV
        WWA2i4CqxKV7F5hBbE6BLkaJCXPKQWxeoDn/5t4DqxEVsJT48+wjO0RcUOLkzCcsEPOzJb6u
        fs48gVFgFpLULCSpWUDXMQtoSqzfpQ8R1pZYtvA1M4RtK7Fu3XuWBYysqxhFUkuLc9Nziw31
        ihNzi0vz0vWS83M3MQIjaduxn5t3MM579VHvECMTB+MhRhWgzkcbVl9glGLJy89LVRLhvTLv
        drIQb0piZVVqUX58UWlOavEhRlOg1yYyS4km5wNjPK8k3tDMwNTQxMzSwNTSzFhJnNezoCNR
        SCA9sSQ1OzW1ILUIpo+Jg1OqgSnnZekLd1u20xtC805pJv9eIW9/sLria1Hv+yL1IxyBjQ7z
        KwI4ZTZfLD94L1iq/t+zTt/VzM+fdztsFc7vaGzbYCX78FBCxH1mrfqt2W/qOpb/qzTI0THJ
        cy2vKc/V1Hn4zchSdlr1t0z7Awa3ovuNr7KkLfkQlXH4SIeBRs4UNlmR1zc3GL3WON03S9mh
        dHOAif7a01IX9/HJRG5TFvszZ9/h9N64vS8D4q6oM759/+nEOqWdpv+0WHZl1u9Q083f9r/1
        56KgNx4X2Z9O1jBs2/nb++g875SL/8/63EpaZPxIX+H8GqOppp4fWtW6GZMK2DccUOyJ3n3R
        g/V0pM29fxPDF5w+YVIbuf9NjhJLcUaioRZzUXEiABqG4us5AwAA
X-CMS-MailID: 20230202223633eucas1p2d9ec5e0fee227cb5a1bcb81c3c137859
X-Msg-Generator: CA
X-RootMTR: 20230202223633eucas1p2d9ec5e0fee227cb5a1bcb81c3c137859
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230202223633eucas1p2d9ec5e0fee227cb5a1bcb81c3c137859
References: <20230202152258.512973-3-amit.kumar-mahapatra@amd.com>
        <CGME20230202223633eucas1p2d9ec5e0fee227cb5a1bcb81c3c137859@eucas1p2.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2023-02-02 czw 20:52>, when Amit Kumar Mahapatra wrote:
> Supporting multi-cs in spi drivers would require the chip_select & cs_gpi=
od
> members of struct spi_device to be an array. But changing the type of the=
se
> members to array would break the spi driver functionality. To make the
> transition smoother introduced four new APIs to get/set the
> spi->chip_select & spi->cs_gpiod and replaced all spi->chip_select and
> spi->cs_gpiod references with get or set API calls.
> While adding multi-cs support in further patches the chip_select & cs_gpi=
od
> members of the spi_device structure would be converted to arrays & the
> "idx" parameter of the APIs would be used as array index i.e.,
> spi->chip_select[idx] & spi->cs_gpiod[idx] respectively.
>
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
> Reviewed-by: Michal Simek <michal.simek@amd.com>
> ---
>  drivers/net/ethernet/adi/adin1110.c            | 2 +-
>  drivers/net/ethernet/asix/ax88796c_main.c      | 2 +-

For ax88796c
Acked-by: Lukasz Stelmach <l.stelmach@samsung.com>

Thanks.

>  drivers/net/ethernet/davicom/dm9051.c          | 2 +-
>  drivers/net/ethernet/qualcomm/qca_debug.c      | 2 +-
>  drivers/net/ieee802154/ca8210.c                | 2 +-
>  drivers/net/wan/slic_ds26522.c                 | 2 +-
>  drivers/net/wireless/marvell/libertas/if_spi.c | 2 +-
>  drivers/net/wireless/silabs/wfx/bus_spi.c      | 2 +-
>  drivers/net/wireless/st/cw1200/cw1200_spi.c    | 2 +-
>  9 files changed, 9 insertions(+), 9 deletions(-)
>

[...]

> --- a/drivers/net/ethernet/asix/ax88796c_main.c
> +++ b/drivers/net/ethernet/asix/ax88796c_main.c
> @@ -1006,7 +1006,7 @@ static int ax88796c_probe(struct spi_device *spi)
>  	ax_local->mdiobus->parent =3D &spi->dev;
>=20=20
>  	snprintf(ax_local->mdiobus->id, MII_BUS_ID_SIZE,
> -		 "ax88796c-%s.%u", dev_name(&spi->dev), spi->chip_select);
> +		 "ax88796c-%s.%u", dev_name(&spi->dev), spi_get_chipselect(spi, 0));
>=20=20
>  	ret =3D devm_mdiobus_register(&spi->dev, ax_local->mdiobus);
>  	if (ret < 0) {

[...]

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmPcOvEACgkQsK4enJil
gBBFfAf+LyND8/gjCylBNt7dTY3hKO00SkUXx6a05q1IlpefmnqZT0yft7oOQXwl
JP0KaUIeFwoByUpqpp9hzVpNcj+7qTPlpgIuI+t5fpUw2RTD6SZ2rsCiBKmtlN5/
bTORNHHcCTYTH94yWEm66ijd3mgbz9M8X3eWhxirDgsU6zCE0AtXPzDzkRLv5xbX
W4J+MK5Dsd8dvQ5uJ27LyJn0jF1jI6NQtxlno81DYxvhc/DnH7Nx/MFO5Jr2gAZm
zw+jorF8IW4XOHVexTQBWpBvyXzhn6GFlX6SzoRMYa48Gbw2fNeSxHEoaAnhOh4r
yezVLOhcR3ZGuPNzXSPXwnyNbwIpuA==
=Vt06
-----END PGP SIGNATURE-----
--=-=-=--
