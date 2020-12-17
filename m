Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785B32DD9B2
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 21:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgLQUMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 15:12:20 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55639 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728208AbgLQUMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 15:12:19 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201217201127euoutp0275dbebf5288d7b555edea522d427699d~RmgTFSw9Y0255602556euoutp025;
        Thu, 17 Dec 2020 20:11:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201217201127euoutp0275dbebf5288d7b555edea522d427699d~RmgTFSw9Y0255602556euoutp025
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608235887;
        bh=oLVaYH5sGYHTpc7LtynFuW/NM4L7YplTU1DshzGd7+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4e/1cdMXTM19oPuRsdlocelz9nipoSI42VcA4uPhAOX22ZzV5pk4+e9cVStGCj8F
         g8/coWm43I1ve2/kg/qcB4roRSAAyLDsJp05dLqE2CbyrwjT0pVj+rCehDiO0hLX8c
         6gxfhhQuRDJVZkF7TL+ice2vjPFMBADMy9x7SrbY=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201217201121eucas1p239445214fde7606fe72772cfa8e1736b~RmgOMC1w82757427574eucas1p2M;
        Thu, 17 Dec 2020 20:11:21 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 27.11.27958.96BBBDF5; Thu, 17
        Dec 2020 20:11:21 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201217201121eucas1p1147efa18e8ae36db188cae200bc21e4d~RmgNVKap53222332223eucas1p1x;
        Thu, 17 Dec 2020 20:11:21 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201217201121eusmtrp19a048490110a66b3cdbf80fb8a5bf0de~RmgNUX7ww1667416674eusmtrp1d;
        Thu, 17 Dec 2020 20:11:21 +0000 (GMT)
X-AuditID: cbfec7f2-efdff70000006d36-81-5fdbbb693de2
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 1D.2B.16282.86BBBDF5; Thu, 17
        Dec 2020 20:11:20 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201217201120eusmtip28c607a2c357b105d9e281aa2962dfe45~RmgNHEn3j2581525815eusmtip2N;
        Thu, 17 Dec 2020 20:11:20 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolni?= =?utf-8?Q?erkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v9 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Thu, 17 Dec 2020 21:11:10 +0100
In-Reply-To: <20201217110851.4a059426@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Thu, 17 Dec 2020 11:08:51 -0800")
Message-ID: <dleftjk0tg6vmp.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsWy7djPc7qZu2/HGyx+aGBx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2qx6fE1VovLu+awWcw4v4/J
        4tDUvYwWa4/cZbc4tkDMonXvEXYHAY/L1y4ye2xZeZPJY+esu+wem1Z1snlsXlLvsXPHZyaP
        vi2rGD0+b5IL4IjisklJzcksSy3St0vgynj85QpTwSmBitW951gaGKfydTFyckgImEi07/zE
        BGILCaxglDh+PqmLkQvI/sIo8XjuB2YI5zOjxPrZLWwwHc+b2tkgEssZJTafmAxV9ZxRYtWX
        J4xdjBwcbAJ6EmvXRoA0iAioSLRsnskCUsMscJFFYn33ZxaQhLBAmMThRU/AbBYBVYk9R+ax
        ghRxCkxjlLi1+S5YglfAXOLfqp1gtqiApcSWF/fZIeKCEidnQjQzC+RKzDz/hhGkWULgHKfE
        /8cP2CFudZF4eXAZlC0s8er4FihbRuL05B4WkEslBOolJk8yg+jtYZTYNucHC0SNtcSdc7+g
        fnaUaD/9lxGink/ixltBiL18EpO2TWeGCPNKdLQJQVSrSKzr3wM1RUqi99UKRgjbQ+JQ1y1E
        yK3umMk0gVFhFpJ3ZiF5ZxbQWGYBTYn1u/QhwtoSyxa+ZoawbSXWrXvPsoCRdRWjeGppcW56
        arFhXmq5XnFibnFpXrpecn7uJkZgSjz97/inHYxzX33UO8TIxMF4iFEFqPnRhtUXGKVY8vLz
        UpVEeOPib8cL8aYkVlalFuXHF5XmpBYfYpTmYFES5101e028kEB6YklqdmpqQWoRTJaJg1Oq
        gcmty2oCi/+ZAwkvZq55xOzPevXkwbyTLXwnWl5JX405ZD7H4V7YvR63c9z7n+n3pao7y/nM
        2avxRUCc+wfv/KNvs4JW/Thm+a00/jX7An3LrRFTI6VEjPSnrq4IP3ZeqezCth3G93jt9Xlv
        LO2SbdywK2OpY82Kd98KWB0eat25ldNs/FGoQL23wzhAV8Y91tAl0DGJI763NcF7wuNleUv7
        X1x4lWi6V2HvCa35h6wq2oQ2SH113jNp9XUhr39/bmb3lc7KmSLycers86Ir/C7wc0j//O5f
        Y3VEoHwNN2+u7eJJO9dO12T+4XyG0bxwJ/+Wa1sNc/x2m90KDHSOKrlwUcJoXcTNEJepVku+
        WiuxFGckGmoxFxUnAgAsPDKTBAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t/xe7oZu2/HG3yZbGVx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2qx6fE1VovLu+awWcw4v4/J
        4tDUvYwWa4/cZbc4tkDMonXvEXYHAY/L1y4ye2xZeZPJY+esu+wem1Z1snlsXlLvsXPHZyaP
        vi2rGD0+b5IL4IjSsynKLy1JVcjILy6xVYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcks
        Sy3St0vQy3j85QpTwSmBitW951gaGKfydTFyckgImEg8b2pnA7GFBJYySuy5q9TFyAEUl5JY
        OTcdokRY4s+1LqASLqCSp4wSj1efYgOpYRPQk1i7NgKkRkRARaJl80wWkBpmgSssEqs+trCC
        JIQFQiTeL53HCDE/WKJx7SGwOIuAqsSeI/NYQRo4BaYxStzafJcFJMErYC7xb9VOMFtUwFJi
        y4v77BBxQYmTM5+AxZkFsiW+rn7OPIFRYBaS1CwkqVlA9zELaEqs36UPEdaWWLbwNTOEbSux
        bt17lgWMrKsYRVJLi3PTc4uN9IoTc4tL89L1kvNzNzECo3nbsZ9bdjCufPVR7xAjEwfjIUYV
        oM5HG1ZfYJRiycvPS1US4Y2Lvx0vxJuSWFmVWpQfX1Sak1p8iNEU6LeJzFKiyfnANJNXEm9o
        ZmBqaGJmaWBqaWasJM5rcmRNvJBAemJJanZqakFqEUwfEwenVANT6zKm5IDNXkd3M3EHTlLd
        b7zHI3KF9rX9HNs3u2cVOc86pFT/yvvqpb8CqgyV6829xPIl7IpV+gKu8t4QvM969/76P3ev
        C22/dXLP2/jQiutnHbVW5vpx/rdfe/3a8z0ekkzXq5Oitz0Ns3mftOCc9rtgyehlj66LcLj/
        FdrkxMntc3Rr5k8TuY1cP0v/6q3w3tLmkC924d3zOU7Hrqdv3OZ9TH92/Ve+g6emx/q+5fY+
        /Sf6N8sL5k/p8mk21hbKBibTeedlSoocOPtZvOnY64kmm99cYS99xVvlW3Tv8EVP/xMN6cE3
        cxYZXH77YOYcvaqsXSvmnys3ecTj2DnZ4+QScecpqxQuCUyuZo2IVmIpzkg01GIuKk4EAHta
        tGF7AwAA
X-CMS-MailID: 20201217201121eucas1p1147efa18e8ae36db188cae200bc21e4d
X-Msg-Generator: CA
X-RootMTR: 20201217201121eucas1p1147efa18e8ae36db188cae200bc21e4d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201217201121eucas1p1147efa18e8ae36db188cae200bc21e4d
References: <20201217110851.4a059426@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CGME20201217201121eucas1p1147efa18e8ae36db188cae200bc21e4d@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-12-17 czw 11:08>, when Jakub Kicinski wrote:
> On Thu, 17 Dec 2020 12:53:30 +0100 =C5=81ukasz Stelmach wrote:
>> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
>> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
>> supports SPI connection.
>>=20
>> The driver has been ported from the vendor kernel for ARTIK5[2]
>> boards. Several changes were made to adapt it to the current kernel
>> which include:
>>=20
>> + updated DT configuration,
>> + clock configuration moved to DT,
>> + new timer, ethtool and gpio APIs,
>> + dev_* instead of pr_* and custom printk() wrappers,
>> + removed awkward vendor power managemtn.
>> + introduced ethtool tunable to control SPI compression
>>=20

[...]

>>=20
>> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
>> chips are not compatible. Hence, two separate drivers are required.
>>=20
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
> drivers/net/ethernet/asix/ax88796c_main.c: In function =E2=80=98ax88796c_=
tx_fixup=E2=80=99:
> drivers/net/ethernet/asix/ax88796c_main.c:248:6: warning: variable =E2=80=
=98tol_len=E2=80=99 set but not used [-Wunused-but-set-variable]
>   248 |  u16 tol_len, pkt_len;
>       |      ^~~~~~~

Done. Thanks.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl/bu14ACgkQsK4enJil
gBDPsQf8CSIAfSlfu6USnUeTjFPC7ww9FQ4bu869KBTSUDJHn4bzc+dJuyfb1yMq
34k2THjWDp8sWNDCoF4A0fWZbrBIwsg1vPFA+ave1KHxCe5mp1J4VzctqN1sIWmU
woW98UNIfgWdmS/Cb5TRh0In94a3yY/YypPICSPBbs6zuWIIrCHEJKUt1LEzgTx7
Q6nY0UeCs4Skpbaki/xDo3+uB6bXoRT/kQvnroy3DMCn8qBaX9N961BZUyzYYEg1
Upja6i+Md4k6UCCunktMtnlHfloXwO3TtVGpisq9eb0Ey/1+pJzD8wNKTOggLBsB
UhmtvRkvloftPEQSgBlGicJ4kNzBfg==
=Toi6
-----END PGP SIGNATURE-----
--=-=-=--
