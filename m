Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF4525267A
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 07:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgHZFLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 01:11:40 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47509 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgHZFLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 01:11:38 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200826051135euoutp02e5d551df7b2b5d99978f8dd4ab4f2aac~uuVXLc0l72850028500euoutp02L;
        Wed, 26 Aug 2020 05:11:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200826051135euoutp02e5d551df7b2b5d99978f8dd4ab4f2aac~uuVXLc0l72850028500euoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598418695;
        bh=UoWZxsq2ehgW6OJCcDlHRW36cf3DBAGPj6G6QPuhOk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQj7nEji6ZHBRvG8OclXTVyjMFZD6W6NYuQ+HDNHW8GbULvR3lgq9bL46Hz6+9pdC
         rjiuAMKGgPvryc2dRdzCXSOcAaPwniLnH7ijo6P+OxB3rfyhntALLGj1ieadr7Fr53
         4UKfOJUur5HLD/zQJR8dqjn2qp0ke5Q6VakWpH8o=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200826051134eucas1p2e7e95ebb5be135386f7e12e5fd00a133~uuVWRFIe-0099700997eucas1p27;
        Wed, 26 Aug 2020 05:11:34 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 7E.36.05997.60FE54F5; Wed, 26
        Aug 2020 06:11:34 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200826051134eucas1p23a1c91b2179678eecc5dd5eeb2d0e4c9~uuVVoxr7O2361423614eucas1p2M;
        Wed, 26 Aug 2020 05:11:34 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200826051134eusmtrp16606dc6df146f0b38b332affe9d28037~uuVVoC1Bn2068720687eusmtrp1v;
        Wed, 26 Aug 2020 05:11:34 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-0d-5f45ef06ddf3
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 40.7A.06314.60FE54F5; Wed, 26
        Aug 2020 06:11:34 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200826051134eusmtip2c4cbe24fe8f6a11cc1119606acfc10e1~uuVVapPyv0656206562eusmtip2a;
        Wed, 26 Aug 2020 05:11:33 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH 3/3] ARM: defconfig: Enable ax88796c driver
Date:   Wed, 26 Aug 2020 07:11:18 +0200
In-Reply-To: <20200825185152.GC2693@kozik-lap> (Krzysztof Kozlowski's
        message of "Tue, 25 Aug 2020 20:51:52 +0200")
Message-ID: <dleftjk0xmuh3d.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsWy7djP87ps713jDZ68NLTYOGM9q8Wc8y0s
        FvOPnGO16H/8mtni/PkN7BYXtvWxWmx6fI3V4vKuOWwWM87vY7I4NHUvo8XaI3fZLY4tELNo
        3XuE3YHX4/K1i8weW1beZPLYtKqTzWPzknqPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyji4
        7TVbwQTxinUzepkaGJtEuhg5OSQETCT2Pmpi72Lk4hASWMEocWn5BUYI5wujxJ9pL9ggnM+M
        Eif/TWeDaZl84DITRGI5o8SH08ugnOeMEq/PHGXpYuTgYBPQk1i7NgKkQURAU+L63++sIDXM
        ArOYJS5u+c4CkhAWsJc4urqHEcRmEVCV+HPyFtgGToFSiXcntjKD2LwC5hLTnk1mArFFBSwl
        try4zw4RF5Q4OfMJ2BxmgVyJmeffgN0tIfCXXaLr7AlmiFNdJG6f3s8CYQtLvDq+hR3ClpE4
        PbkH7FAJgXqJyZPMIHp7GCW2zfkBVW8tcefcL6iXHSVaDq5nhqjnk7jxVhBiL5/EpG3TocK8
        Eh1tQhDVKhLr+vdATZGS6H21ghHC9pBY/BfCFhJoZJT49UZuAqPCLCTfzELyzSygqczAoFu/
        Sx8irC2xbOFrZgjbVmLduvcsCxhZVzGKp5YW56anFhvlpZbrFSfmFpfmpesl5+duYgSmt9P/
        jn/ZwbjrT9IhRgEORiUe3gVsrvFCrIllxZW5hxhVgCY92rD6AqMUS15+XqqSCK/T2dNxQrwp
        iZVVqUX58UWlOanFhxilOViUxHmNF72MFRJITyxJzU5NLUgtgskycXBKNTAuPyOzxdmK/3KA
        2yWVJY0atuWyUcknbZbtOyby807ky8+b7BsuMEvpZIcsK5xzabuS0LHQG8JypxjFH/DPN3YJ
        /fOxtULta69BdSv7rAU/L9jJPbQorv1TX99n4ub5nqFLMcr+V//DndPi5aM7vjUaP631rS95
        O5mpZvlmZQMD8zmGNY+DK5VYijMSDbWYi4oTAQTkyOB3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/xe7ps713jDbZc5bDYOGM9q8Wc8y0s
        FvOPnGO16H/8mtni/PkN7BYXtvWxWmx6fI3V4vKuOWwWM87vY7I4NHUvo8XaI3fZLY4tELNo
        3XuE3YHX4/K1i8weW1beZPLYtKqTzWPzknqPvi2rGD0+b5ILYIvSsynKLy1JVcjILy6xVYo2
        tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcksSy3St0vQyzi47TVbwQTxinUzepkaGJtEuhg5
        OSQETCQmH7jM1MXIxSEksJRR4uiOD0AOB1BCSmLl3HSIGmGJP9e62CBqnjJKPHreDVbDJqAn
        sXZtBEiNiICmxPW/31lBapgF+pgl7i78yQiSEBawlzi6ugfMFhLQlbi3eh8riM0ioCrx5+Qt
        NpA5nAKlEtO32oCEeQXMJaY9m8wEYosKWEpseXGfHSIuKHFy5hMWEJtZIFvi6+rnzBMYBWYh
        Sc1CkpoFNJUZ6KT1u/QhwtoSyxa+ZoawbSXWrXvPsoCRdRWjSGppcW56brGhXnFibnFpXrpe
        cn7uJkZgZG479nPzDsZLG4MPMQpwMCrx8C5gc40XYk0sK67MPcSoAjTm0YbVFxilWPLy81KV
        RHidzp6OE+JNSaysSi3Kjy8qzUktPsRoCvTmRGYp0eR8YDLJK4k3NDU0t7A0NDc2NzazUBLn
        7RA4GCMkkJ5YkpqdmlqQWgTTx8TBKdXAWHHFi2XGperEM8snrIh3qy/Wm2O0++S3BKvPU0oe
        i586cz9inlW/d3yz65XGjl/a7l8CL21gdgxOkNKy+Ln88N8j7H8kzLd/X3iPv2XfSrfvfscq
        Lnv47ePPnde10lKCq/TmoZ2hvOLaJ6vKol6u4Hmk/Xx7df6s6acad1f2p6R9eH5yxsxCLyWW
        4oxEQy3mouJEAP4Td0XuAgAA
X-CMS-MailID: 20200826051134eucas1p23a1c91b2179678eecc5dd5eeb2d0e4c9
X-Msg-Generator: CA
X-RootMTR: 20200826051134eucas1p23a1c91b2179678eecc5dd5eeb2d0e4c9
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200826051134eucas1p23a1c91b2179678eecc5dd5eeb2d0e4c9
References: <20200825185152.GC2693@kozik-lap>
        <CGME20200826051134eucas1p23a1c91b2179678eecc5dd5eeb2d0e4c9@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-08-25 wto 20:51>, when Krzysztof Kozlowski wrote:
> On Tue, Aug 25, 2020 at 07:03:11PM +0200, =C5=81ukasz Stelmach wrote:
>> Enable ax88796c driver for the ethernet chip on Exynos3250-based
>> ARTIK5 boards.
>>=20
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> ---
>>  arch/arm/configs/exynos_defconfig   | 2 ++
>>  arch/arm/configs/multi_v7_defconfig | 2 ++
>>  2 files changed, 4 insertions(+)
>>=20
>> Please DO NOT merge before these two
>
> Sure, it can wait but shouldn't actually DT wait? It's only defconfig so
> it does not change anything except automated systems booting these
> defconfigs... The boards might be broken by DT.

I was told, to ask for deferred merge of defconfig and it makes sense to
me. DT won't break anything if the driver isn't compiled. However, I can
see that you have a word you may decide about DT too. My point is to
wait until spi-s3c64xx patches are merged and not to break ARTIK5
boards.

>>=20
>>   https://lore.kernel.org/lkml/20200821161401.11307-2-l.stelmach@samsung=
.com/
>>   https://lore.kernel.org/lkml/20200821161401.11307-3-l.stelmach@samsung=
.com/
>>=20
>> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos=
_defconfig
>> index 6e8b5ff0859c..82480b2bf545 100644
>> --- a/arch/arm/configs/exynos_defconfig
>> +++ b/arch/arm/configs/exynos_defconfig
>> @@ -107,6 +107,8 @@ CONFIG_MD=3Dy
>>  CONFIG_BLK_DEV_DM=3Dy
>>  CONFIG_DM_CRYPT=3Dm
>>  CONFIG_NETDEVICES=3Dy
>> +CONFIG_NET_VENDOR_ASIX=3Dy
>> +CONFIG_SPI_AX88796C=3Dy
>>  CONFIG_SMSC911X=3Dy
>>  CONFIG_USB_RTL8150=3Dm
>>  CONFIG_USB_RTL8152=3Dy
>> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/mult=
i_v7_defconfig
>> index e9e76e32f10f..a8b4e95d4148 100644
>> --- a/arch/arm/configs/multi_v7_defconfig
>> +++ b/arch/arm/configs/multi_v7_defconfig
>> @@ -241,6 +241,8 @@ CONFIG_SATA_HIGHBANK=3Dy
>>  CONFIG_SATA_MV=3Dy
>>  CONFIG_SATA_RCAR=3Dy
>>  CONFIG_NETDEVICES=3Dy
>> +CONFIG_NET_VENDOR_ASIX=3Dy
>> +CONFIG_SPI_AX88796C=3Dm
>>  CONFIG_VIRTIO_NET=3Dy
>>  CONFIG_B53_SPI_DRIVER=3Dm
>>  CONFIG_B53_MDIO_DRIVER=3Dm
>> --=20
>> 2.26.2
>>=20
>
>

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl9F7vYACgkQsK4enJil
gBAFHQgAmtB7lnKmjz1HmpsDGOZW6GL7+dy6DzX/WdcZYKl/BqPGkdJdS3mmZ2vL
ReeRKBNGMi1tF5ke//+PK2ymKNUlM+oNogikadhqey9bPRNNehuAHT5A3iL+KulJ
ynt0tiCPR1+1Map3UNgiMzAhcLmLZnJ+CIDeTq8z+USD7noFT05O3G4rNGnh5wMc
iIyx3zVUCCVVoqEE1HlulzOgXc1p1E9ZnoH331iBVEr3aTUDoLvSoymMRx6eA2zA
ggmUcoaFC5qjBza+qipukpqir4OZ40lisI3pgD8YPtJlJkZz4B7JitjcIb5s/7hT
8h5mI4Wf/w2tA+GWcoYAnMfKZR+O2Q==
=cYnG
-----END PGP SIGNATURE-----
--=-=-=--
