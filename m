Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D073E2DC01B
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 13:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgLPMXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 07:23:14 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51659 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgLPMXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 07:23:14 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201216122221euoutp018ace46c38e797aea72fbc4927da28d9e~RMdcSY7YZ1459614596euoutp01P;
        Wed, 16 Dec 2020 12:22:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201216122221euoutp018ace46c38e797aea72fbc4927da28d9e~RMdcSY7YZ1459614596euoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608121341;
        bh=WDSWLJ1KthHaw+6Hxt7PHDOfO0uSu8pCSX9ZcwXXIwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2ZOnjQ87tlogPrCZIlhYzVGN2CBsh+UxNodQSeWfL7Vb3Cp2aM5UAog3uu7ydALd
         hKJph+ZKzeTnITgQGhWigRAxHul3UUWWfRa8+ZTx8VYex0/ZRgzLHPJlHHA+ZZv/1W
         Gb7qfrevM296rR0dFw81rYvLdO3/v5beoJroTMt0=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201216122213eucas1p2716c5596cae0ce235e86cdf04ff5510e~RMdUR9vF40639406394eucas1p2s;
        Wed, 16 Dec 2020 12:22:13 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 01.2D.44805.4FBF9DF5; Wed, 16
        Dec 2020 12:22:12 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201216122211eucas1p22314f0e8a28774545d168290ed57b355~RMdTLjpoi0210502105eucas1p2C;
        Wed, 16 Dec 2020 12:22:11 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201216122211eusmtrp1d9d1dc5683298d438e2e255d939c94a7~RMdTKuqPk0897108971eusmtrp1Z;
        Wed, 16 Dec 2020 12:22:11 +0000 (GMT)
X-AuditID: cbfec7f4-b37ff7000000af05-7a-5fd9fbf40160
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id F0.E6.16282.3FBF9DF5; Wed, 16
        Dec 2020 12:22:11 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201216122211eusmtip1336c48f7bdb13e86949c10d28229cce2~RMdS46Rt32884228842eusmtip1V;
        Wed, 16 Dec 2020 12:22:11 +0000 (GMT)
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
Subject: Re: [PATCH v8 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Wed, 16 Dec 2020 13:21:52 +0100
In-Reply-To: <20201215174615.17c08e88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Tue, 15 Dec 2020 17:46:15 -0800")
Message-ID: <dleftjczza7xgf.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsWy7djPc7pfft+MN9hxVdPi/N1DzBYbZ6xn
        tZhzvoXFYv6Rc6wWi97PYLW49vYOq0X/49fMFufPb2C3uLCtj9Vi0+NrrBaXd81hs5hxfh+T
        xaGpexkt1h65y25xbIGYReveI+wOAh6Xr11k9tiy8iaTx85Zd9k9Nq3qZPPYvKTeY+eOz0we
        fVtWMXp83iQXwBHFZZOSmpNZllqkb5fAlbFz032mggcyFfNX/mdqYDwi3sXIySEhYCLR/W4N
        excjF4eQwApGidW/X7FCOF8YJV7umgjlfGaUuDT7DCtMy5tZ56FaljNKrFo2jQXCec4ocWX2
        U+YuRg4ONgE9ibVrI0AaRARUJFo2zwSrYRa4yCKxvvszC0hCWCBMYvLKTUwgNouAqsT5R2/A
        ijgFpjFKzD54FKyIV8BcYuHlp4wgtqiApcSWF/fZIeKCEidnPgGrYRbIlZh5/g0jxHmXOCVe
        bxaCsF0knjzrZYewhSVeHd8CZctInJ7cwwJyqIRAvcTkSWYgeyUEehglts35wQJRYy1x59wv
        NgjbUeLlss9MEPV8EjfeCkKs5ZOYtG06M0SYV6KjDWqrisS6/j1QU6Qkel+tgLrMQ2LPi11M
        8IBbe/c7ywRGhVlIvpmF5JtZQGOZBTQl1u/ShwhrSyxb+JoZwraVWLfuPcsCRtZVjOKppcW5
        6anFRnmp5XrFibnFpXnpesn5uZsYgSnx9L/jX3YwLn/1Ue8QIxMH4yFGFaDmRxtWX2CUYsnL
        z0tVEuFNOHAzXog3JbGyKrUoP76oNCe1+BCjNAeLkjhv0pY18UIC6YklqdmpqQWpRTBZJg5O
        qQYmQ3W7tHAxQ60nrWvrb1yfZXdUZUeOhbuPrH//mao3Trw3fvhffpJlanhloVqp8E/n78m7
        vS0W7jmvwF94OHM2z4mXlbqTKi1WfZM6btm/xugD5wYezrpPRVasfGnrPvyt2enzVrrv+fzN
        ay4GXDTpjGAqvOLr16q4lef25onpbQ3p/97kvVNdoWdRLlH56K1a8aEVUxbvSWA8vpurTqLk
        ueeRjzGZ2XfuTVCzFwi167c4rZYe3uYqc6/U795xabube1V8rFriSiLWmf84f/HpjcJvPNPf
        LTta+//ehwMs55u9FeK0PjRyOjMutVnRvr6p17rTwf551J3HpvvKU8IuR8x5+shedmbOlVMs
        724qsRRnJBpqMRcVJwIAJGH/UwQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t/xu7qff9+MN9i/1sDi/N1DzBYbZ6xn
        tZhzvoXFYv6Rc6wWi97PYLW49vYOq0X/49fMFufPb2C3uLCtj9Vi0+NrrBaXd81hs5hxfh+T
        xaGpexkt1h65y25xbIGYReveI+wOAh6Xr11k9tiy8iaTx85Zd9k9Nq3qZPPYvKTeY+eOz0we
        fVtWMXp83iQXwBGlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZ
        llqkb5egl7Fz032mggcyFfNX/mdqYDwi3sXIySEhYCLxZtZ59i5GLg4hgaWMEg/XH2brYuQA
        SkhJrJybDlEjLPHnWhcbRM1TRom/p9cxgtSwCehJrF0bAVIjIqAi0bJ5JgtIDbPAFRaJVR9b
        WEESwgIhEs2/PzCC2EICwRKbb70Fi7MIqEqcf/QGrIFTYBqjxOyDR1lAErwC5hILLz8FaxAV
        sJTY8uI+O0RcUOLkzCdgNcwC2RJfVz9nnsAoMAtJahaS1Cyg+5gFNCXW79KHCGtLLFv4mhnC
        tpVYt+49ywJG1lWMIqmlxbnpucVGesWJucWleel6yfm5mxiB8bzt2M8tOxhXvvqod4iRiYPx
        EKMKUOejDasvMEqx5OXnpSqJ8CYcuBkvxJuSWFmVWpQfX1Sak1p8iNEU6LeJzFKiyfnARJNX
        Em9oZmBqaGJmaWBqaWasJM5rcmRNvJBAemJJanZqakFqEUwfEwenVANT/POX7ozGywIzgyYs
        3ZkdMe3blL2Fdw4EfZtxjGfGwtXndy6XqCqyX6Z5dMXn/vD+d0fn3Vr6XPOhfJrEkVynnvII
        5Q9xl0+fintSaRn83W7xREOWsg8zW98YP/RfaTdvZ5Fi+WEptYJqsxPas48x3P9i58js8ORn
        8YpC68USS+SX/laxkS34X5laNDXCIvBW/dt/XDLxeX/t5eZvcmWwmF3H7ps4YbZxFEckT9Q1
        i2ecQiwBd1Nm31nrMafeJXbnTq5JK1kPHxIWmrXwUfhno6clH6Lvrtvj5nqe2+MNyzb+sw/e
        n94cLnL79toz11aG6Tasj7DZZZlm/4kjtKpoqwxn/Ew3njUrXzi8mBrRocRSnJFoqMVcVJwI
        AAZqXJF8AwAA
X-CMS-MailID: 20201216122211eucas1p22314f0e8a28774545d168290ed57b355
X-Msg-Generator: CA
X-RootMTR: 20201216122211eucas1p22314f0e8a28774545d168290ed57b355
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201216122211eucas1p22314f0e8a28774545d168290ed57b355
References: <20201215174615.17c08e88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CGME20201216122211eucas1p22314f0e8a28774545d168290ed57b355@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-12-15 wto 17:46>, when Jakub Kicinski wrote:
> On Wed, 16 Dec 2020 01:42:03 +0100 Lukasz Stelmach wrote:
>>>> +	ax_local->stats.rx_packets++;
>>>> +	ax_local->stats.rx_bytes +=3D skb->len;
>>>> +	skb->dev =3D ndev;
>>>> +
>>>> +	skb->truesize =3D skb->len + sizeof(struct sk_buff);=20=20
>>>
>>> Why do you modify truesize?
>>>=20=20
>>=20
>> I don't know. Although uncommon, this appears in a few usb drivers, so I
>> didn't think much about it when I ported this code.
>
> I'd guess they do aggregation. I wouldn't touch it in your driver.
>

Removed.

>>>> +	u8			plat_endian;
>>>> +		#define PLAT_LITTLE_ENDIAN	0
>>>> +		#define PLAT_BIG_ENDIAN		1=20=20
>>>
>>> Why do you store this little nugget of information?
>>>=20=20
>>=20
>> I don't know*. The hardware enables endianness detection by providing a
>> constant value (0x1234) in one of its registers. Unfortunately I don't
>> have a big-endian board with this chip to check if it is necessary to
>> alter AX_READ/AX_WRITE in any way.
>
> Yeah, may be hard to tell what magic the device is doing.
> I was mostly saying that you don't seem to use this information,
> so the member of the struct can be removed IIRC.
>

Removed.

>>> These all look like multiple of 2 bytes. Why do they need to be packed?
>>=20
>> These are structures sent to and returned from the hardware. They are
>> prepended and appended to the network packets. I think it is good to
>> keep them packed, so compilers won't try any tricks.
>
> Compilers can't play tricks on memory layout of structures, the
> standard is pretty strict about that. Otherwise ABIs would never work.
> We prefer not to unnecessarily pack structures in the neworking code,
> because it generates byte by byte loads on architectures which can't=20
> do unaligned accesses.

Indeed, a struct of three u16 is 6 bytes long. I was worried it may be
rounded up to 8. Removed.

>>> No need to return some specific pattern on failure? Like 0xffff?
>>=20
>> All registers are 16 bit wide. I am afraid it isn't safe to assume that
>> there is a 16 bit value we could use. Chances that SPI goes south are
>> pretty slim. And if it does, there isn't much more than reporting an
>> error we can do about it anyway.
>>=20
>> One thing I can think of is to change axspi_* to (s32), return -1,
>> somehow (how?) shutdown the device in AX_*.
>
> I'm mostly concerned about potentially random data left over in the
> buffer. Seems like it could lead to hard to repro bugs. Hence the
> suggestion to return a constant of your choosing on error, doesn't
> really matter what as long as it's a known constant.

I see, that makes sense, indeed.

So, the only thing that's left is pskb_expand_head(). I need to wrap my
head around it. Can you tell me how a cloned skb is different and why
there may be separate branch for it?

Thank you.
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl/Z++AACgkQsK4enJil
gBBrswf/Skl+I72kUNXDOB/DpNJfKY9pT6T8nWWsQNYiuCiZ1B42FvLjC4pBywIl
H2X31qdEoFL+9g1YcF6q603r8+6rqoRW2FaGAnL/j0EUB6PzeGXw83ZH8stVIsrc
pwAnCkUeP3oEdJpDMPnQ6zqzHpw8P4p/hu4NfeU/tNDI4OoUuCQlPhGKENacw/dB
y+MyiK1KS04Hln4To//GMYnP5PSwId8s80N10AHgxKCSGtOyjhjHw+pfGbedm1JD
hUwU2P6zZg9i7U2bD89Yq791/sNH+dujj3rshmC7L8B/pgLBXDNU+BZlpNuQ5BoV
O00r+l2UdbBDgeHevY5H7GzvveZZTQ==
=FQIv
-----END PGP SIGNATURE-----
--=-=-=--
