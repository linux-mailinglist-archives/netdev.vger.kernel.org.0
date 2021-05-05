Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56453746DD
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbhEERcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:32:07 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:24810 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236872AbhEERMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 13:12:52 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210505171153euoutp027198c2ad968a784dd964aa3e3b012f2d~8OuMbln281421014210euoutp02i;
        Wed,  5 May 2021 17:11:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210505171153euoutp027198c2ad968a784dd964aa3e3b012f2d~8OuMbln281421014210euoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620234713;
        bh=klq6z8FxFFNEyQHOvBbgLuF+nyAGZ72irGowKwJSAr4=;
        h=From:To:Cc:Subject:In-Reply-To:Date:References:From;
        b=aqjRhEAOU04BboMQJTk8VfGcsvVUnGIx2bklwd6Zz8CyyKTSjLLlTdlsLy5wibqaI
         DBTK7vepsSR/J8PIHa8CBlzUm9KvTlXXMhM2Exjs3eX4hqTVlgiwmPoXlMfzxlpPDJ
         ckHkEbVQK9uetW9c7IZC7V3ZtHpiFViRhbExQ/Tw=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210505171151eucas1p2549276ce4e090792daf4d5ced69f5643~8OuLY6VKr3116731167eucas1p20;
        Wed,  5 May 2021 17:11:51 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 9E.7C.09444.7D1D2906; Wed,  5
        May 2021 18:11:51 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210505171151eucas1p15785129622c00205d1d071a2fcaa30e8~8OuK2igI21074810748eucas1p1u;
        Wed,  5 May 2021 17:11:51 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210505171151eusmtrp14f1c0ffaa579153b79f17464802f87c1~8OuK1tAkU3213132131eusmtrp19;
        Wed,  5 May 2021 17:11:51 +0000 (GMT)
X-AuditID: cbfec7f4-dbdff700000024e4-e3-6092d1d79d5e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id EB.C6.08705.7D1D2906; Wed,  5
        May 2021 18:11:51 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210505171151eusmtip269579e4b4fd1175417ac4ff8f29c3cf4~8OuKlqGyG1277112771eusmtip2e;
        Wed,  5 May 2021 17:11:51 +0000 (GMT)
From:   =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RESEND PATCH v11 0/3] AX88796C SPI Ethernet Adapter
In-Reply-To: <20210302152250.27113-1-l.stelmach@samsung.com>
        (=?utf-8?Q?=22=C5=81ukasz?= Stelmach"'s message of "Tue, 2 Mar 2021 16:22:47
        +0100")
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Wed, 05 May 2021 19:11:39 +0200
Message-ID: <dleftjim3x2jhw.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTVxzHc+6jva0pHCvIWdnc0rGQbYjdwtwluGkTnDdLlmg2ljm2QQdX
        IKOF3FscI2GSOMcGzCLMiRVpgQWQR0HoOmHioyslILY6kG6zyBymIhSQh4uYqGu5NfG/z+/7
        +/5eJ4fC5YukgsrR6VlOp8lViqSEzbnq2uy5WpWustRupt0Tdpw+XdNJ0rXubwja5HCRdMNC
        DUmPz3lJ2jA1i9Nud5eYvmI7TNLdU+MkPdpXK6Jr3Ocw2n60H9Adjgkx7TRvpA/1O8Q7IDM6
        fhVnrKf+wphe44SY6W79XsT0/HyA6T2zjDGHra2AWe7etJv6WLotk83N2c9yW95Ol2afbDGJ
        813rCn/0jmMl4LGkDEgoBBOQ3VUqKgNSSg5bALozPB8KVgDyXzfjQZccLgNUakp6UuG8O48L
        pmaAHO2+UHAboEeNRiLoEsHtyOA4t8YRcA/qv1BDBE04/IlAjqU7IJjYANXI/M/A2jwJPArQ
        0kIrGUxEwkRknZ4UB5mAL6GTg+1rugy+icr9nhCvR0PHb61NwKEWHXf7gbCfS4JGmlmBk9Gp
        sWFC4A1oZtAqFvhZdKm6IqBTAT6Aqqu2BndAsAIgW+39kD8JeV0PRAKrUdvph6TgD0N/zq0X
        xoahKtsxXJBl6Ltv5YI7BlkMZ0NdFOiHmZbQZgw6NNpICI9lAOjGwCRWCV4wPnWN8alrjIG2
        OHwZdfZtEeRXUVP9LC7wW8hiWSDMgGwFUWwBr81i+dd17JfxvEbLF+iy4jPytN0g8BMvPRpc
        OQOaZxbj7QCjgB3EBIr/7Wq7AhSELk/HKiNk+R2GdLksU/NVEcvlpXEFuSxvB9EUoYySfW5t
        T5PDLI2e/YJl81nuSRajJIoSLDzXdXNKr1yp9ngX9xYNduh9mE61M6XpounFDyedCZ/+XVGo
        4Tumqa/VrHz2bFKWdbtpl9a393y984+0yx+1yBrUhudh4q/cia0eByEpKQ+Hvh76fsLSwwvc
        zuTC972PE99RZcT+VrGrc8+Ntn18Tn2KaGwgdfcOydgz8/8dadq/WnAzOc6nKzb5tY7Ig55P
        su0fvNevupsRG2fqSYbHuPbsdx+ErQ5/FhtzL6NclRSvMG+MLi5OpC7qFHkHI6NupUrnnsMq
        x8p+0V+3Dyv91G3bCSyl0jLSeKQuk+htvnYvji06r/49YqihqgtOTJcaRvre2Fa3qS48OnVo
        uUniVBJ8tua1V3CO1/wPblHV0wQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t/xe7rXL05KMFh4gsfi/N1DzBYbZ6xn
        tZhzvoXFYv6Rc6wWi97PYLW49vYOq0X/49fMFufPb2C3uLCtj9Vi0+NrrBaXd81hs5hxfh+T
        xaGpexkt1h65y25xbIGYReveI+wOAh6Xr11k9tiy8iaTx85Zd9k9Nq3qZPPYvKTeY+eOz0we
        fVtWMXp83iQXwBGlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZ
        llqkb5eglzF3xXz2gnPcFVPuXGNqYPzP2cXIySEhYCJx7MM7ZhBbSGApo8TBN6JdjBxAcSmJ
        lXPTIUqEJf5c62KDKHnKKHHhqwqIzSZgL9F/ZB8LiC0i4C9x78w79i5GLg5mgVksEreet4DN
        FBZwlFjw4ChYM6fAVEaJc5/cIQZZSyy6v5IdxBYVsJTY8uI+mM0ioCox9/gaVhCbV8BcovvN
        dShbUOLkzCdgy5gFsiW+rn7OPIFRYBaS1CwkqVlALzALaEqs36UPEdaWWLbwNTOEbSuxbt17
        lgWMrKsYRVJLi3PTc4sN9YoTc4tL89L1kvNzNzECY3nbsZ+bdzDOe/VR7xAjEwfjIUYVoM5H
        G1ZfYJRiycvPS1US4S1Y258gxJuSWFmVWpQfX1Sak1p8iNEU6IWJzFKiyfnAJJNXEm9oZmBq
        aGJmaWBqaWasJM67de6aeCGB9MSS1OzU1ILUIpg+Jg5OqQamPaVn33171Wbpw1d6/uC3mNc6
        vM4qygu6XQUvRftfPTf536tsoQN8fry/uVdMkkg+dN61u+rcncp3f7ynzrj0fgF7o/bNZLtV
        Z25+blJIqzZZtmFK7FbpD+by4edqNn4wL71zS8D724TZ001u7q81U044nxpevXbaCsln1yzf
        7/l9+M67nQfjqi7Or1N8sOzpzFl3ZFiuKV7xKenZ0rB2Sr4yi1zEvjvn0yI7zka9Pt569JDM
        pk0v3p7OMP7oPPXwwYhtPPb6VxauyLkhm+n7qFbjx+qXfzYLXz56rIndTTupv/KEo6STlQYH
        p3napLOyjS/Dli5eKpYYq1P7qiqS4fDJqWwffRcF7awRSpwQqq/EUpyRaKjFXFScCABo93+1
        egMAAA==
X-CMS-MailID: 20210505171151eucas1p15785129622c00205d1d071a2fcaa30e8
X-Msg-Generator: CA
X-RootMTR: 20210505171151eucas1p15785129622c00205d1d071a2fcaa30e8
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210505171151eucas1p15785129622c00205d1d071a2fcaa30e8
References: <20210302152250.27113-1-l.stelmach@samsung.com>
        <CGME20210505171151eucas1p15785129622c00205d1d071a2fcaa30e8@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2021-03-02 wto 16:22>, when =C5=81ukasz Stelmach wrote:
> This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
> found on ARTIK5 evaluation board. The driver has been ported from a
> v3.10.9 vendor kernel for ARTIK5 board.
>
> Changes in v11:
>   - changed stat counters to 64-bit
>   - replaced WARN_ON(!mutex_is_locked()) with lockdep_assert_held()
>   - replaced ax88796c_free_skb_queue() with __skb_queue_purge()
>   - added cancel_work_sync() for ax_work
>   - removed unused fields of struct skb_data
>   - replaced MAX() with max() from minmax.h
>   - rebased to net-next (resend)
[=E2=80=A6]

Hi,

What is current status? Should I rebase once more?

Kind regards,
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmCS0csACgkQsK4enJil
gBDqSgf8C1LVY0HAJO+k2Fa784Yd0+waxpQGXf14FoByZOdNzgzPwRy8C239sftI
n7eG3WMheuQ6SmA6AIUnLVWdctthDaOhOXlfjg88RbWbOvvX4v5EWjWw0rgrwQOc
5gAHXTCHoAVvqmlq55mLfXl5G0Lw8xPH48ry5ubwnIp0LHyDDcez8QkkLv00Ga/2
OsUVHuKoNQtHqyx6EuYUrOmOBLEjYMCSC/R+v+DLO35w5HChcIqJW9TOb27QPp3S
5xdoWvSeSojhD/3tP/XfhFYpqcBpJaqfZwUOZdgOnXK0Q1Rpiha8sBj45Czy5SI+
2yIUcadFpL7Sd4PasEWLCkWVPH5iqg==
=FXKg
-----END PGP SIGNATURE-----
--=-=-=--
