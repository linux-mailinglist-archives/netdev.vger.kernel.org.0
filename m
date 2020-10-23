Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849262976D6
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 20:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754617AbgJWSWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 14:22:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37260 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754606AbgJWSWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 14:22:05 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201023182147euoutp016c6be17a9c294223d32c3b489b261f6d~Ash2Hu-Yf1136811368euoutp01F;
        Fri, 23 Oct 2020 18:21:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201023182147euoutp016c6be17a9c294223d32c3b489b261f6d~Ash2Hu-Yf1136811368euoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603477307;
        bh=oMLuD5Wlc163X55ToCaD9F6Rp3haPPYODKde631RbUI=;
        h=From:To:Cc:Subject:In-Reply-To:Date:References:From;
        b=bjbw8tCFLdVKpMayoigm7twPIpeW5fYTSD4DQkQgLhu0iyvbxjBWWXItkSrsOGzha
         EfaXJPvC/U0EQxVZEN5EetGp9g8Q6sx1qBYOA8WfJCMtzMpn75/OaEoDwe3n3l3TjD
         XZ4LHsGOVJObovuObBW8gpjKP9oUdiPgEQ7XemfM=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201023182138eucas1p2547f9bb105780c316eff28635ce69a31~AshthqH502955929559eucas1p25;
        Fri, 23 Oct 2020 18:21:38 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 46.44.06318.13F139F5; Fri, 23
        Oct 2020 19:21:37 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201023182136eucas1p28518b30e23ae4204840c3d5526bd3400~Ashsh8Fq72954729547eucas1p2r;
        Fri, 23 Oct 2020 18:21:36 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201023182136eusmtrp1957cbd06d4b18261c94cfea214e22975~AshshN-b71506915069eusmtrp1q;
        Fri, 23 Oct 2020 18:21:36 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-29-5f931f31f0f9
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 4B.2D.06314.03F139F5; Fri, 23
        Oct 2020 19:21:36 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201023182136eusmtip1e9e6409348152c60d21f3b329a094456~AshsXFfXY0446104461eusmtip1j;
        Fri, 23 Oct 2020 18:21:36 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewic?= =?utf-8?Q?z?= 
        <b.zolnierkie@samsung.com>,
        "linux-samsung-soc\@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, jim.cromie@gmail.com,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v3 2/5] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
In-Reply-To: <CAJKOXPeNhXrBa0ZK-k37uhs5izukrhHN-rkxgsjiQBHCMmZs7g@mail.gmail.com>
        (Krzysztof Kozlowski's message of "Fri, 23 Oct 2020 18:27:18 +0200")
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Fri, 23 Oct 2020 20:21:25 +0200
Message-ID: <dleftjwnzgyfa2.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWUxTQRSGM70r1erQop6AWxo1rixujFGJ28ONTz6YaDSCVW5woa32CirG
        gImgVqDKZimooLiAgdLaYDFiTEXQVKmKqYKiibghAho0LjEg14uJb9858/9n/jMZntIeYsP5
        7aY9osVkSNazarqu6WfLnJhJ+QnRWWWxJNDho4jL7mRIaeAwTc42tjDkXJ+dIcGeFwyxdXZT
        JBCo5cjDulyGuDuDDGm9XsoSe+CmivgKGxCpbuzgSFPZWJLZ0MiRwRteblmo0Bp8RAmeyjaV
        UO/o4AR31TFWuFqRLtR7+1VCrqcKCf3uiWv4DeoliWLy9lTREhW3Wb3te/AeteuWbl+BY18G
        6sVWFMIDng+Xmjs5K1LzWnwZwZliJ6MUXxGcrK9AStGPoKi1S/XP4uyzIpm1+BKCvMEwRfQe
        wfny55QV8TyLI6G6er2sCcMC3C9ro2QNhYsYsL0rUckaHY4H/9OVcj8E2xFkt1tZ2TAGLwLP
        h1eczDSeOsQ5f1mDY6HH2jXMoXCv+A0tM4WNUBz49Dcp4As82I6cRkrSVeDxBodT6+Bjs4dT
        eDz487NpOQTgdMjPW6h4sxHUlf6gFc1ieNHyi1V4OfgLvnCKfhQ86wlV7h0FeXWnKKWtgaNZ
        WkU9BWpsN4anhEPOx8vDaQQYeOJnlbeqQOCydVAn0GTHf+s4/lvHMTSWwjPAeT1Kac+Ci+Xd
        lMJLoaamjy5DTBUaJ6ZIxiRRmmcS90ZKBqOUYkqK3Go2utHQZ/QPNH/zopu/t/gQ5pF+pCbj
        WV6CljGkSvuNPjRlaNLr2isPUThtMptEfZhmxQN/vFaTaNifJlrMCZaUZFHyoQie1o/TzDvX
        tUmLkwx7xJ2iuEu0/DtV8SHhGYibfrzXuLYTLWjSXTS70Oj4Qlfl27jbntg3pyOf3LUEdxRc
        /exKLWyP5mYnR1Wpc67ZX5dMWxcqbXDuLH/nXs2OOBYzd+D34UmJI/iIruiaTG/mgqgE5uXB
        C0fNG72lEw60rrnTMLtSeFrbJsbo2lNn7i4u0n/rH3lnVlvaY2jKOqGnpW2GmJmURTL8ARBq
        cw6UAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t/xu7oG8pPjDa4cM7M4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7XY9Pgaq8XlXXPYLGac38dk
        cWjqXkaLtUfuslscWyBm0br3CLvF/z072B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/O
        JiU1J7MstUjfLkEv4/u1k8wFB4QrpsyqaGB8J9DFyMkhIWAisf59F2MXIxeHkMBSRok1L78y
        dTFyACWkJFbOTYeoEZb4c62LDcQWEnjKKNG0rAakhE1AT2Lt2giQsIiAh8SZBTeZQcYwC8xi
        lbgz7QM7SEJYIEbi/b6nYPM5BWYwSvTcghkUIDH3yCFmEFtUwFJiy4v7YA0sAqpAdi+YzStg
        LvG26yWULShxcuYTFhCbWSBb4uvq58wTGAVmIUnNQpKaBXQfs4CmxPpd+hBhbYllC18zQ9i2
        EuvWvWdZwMi6ilEktbQ4Nz232FCvODG3uDQvXS85P3cTIzCqtx37uXkH46WNwYcYBTgYlXh4
        da5NihdiTSwrrsw9xKgCNObRhtUXGKVY8vLzUpVEeJ3Ono4T4k1JrKxKLcqPLyrNSS0+xGgK
        9M9EZinR5HxgIsoriTc0NTS3sDQ0NzY3NrNQEuftEDgYIySQnliSmp2aWpBaBNPHxMEp1cBY
        sGsr28/pT/mbWC7UPj/8iddt842/dbduNtddKpZlnqPZG9JYGdAaZPBpwekfT0J5CxssGeWl
        DX49ZuTm9lpmsPpDinhh3BFmlowmj9nbGH8vfSNeYyvYdXxjo3zjSu09TTNd7gid0GFndclV
        OHOWvfv8q2W2Fk+f/k8W2n1a5/CkCR90M+SVWIozEg21mIuKEwE6zHgqDAMAAA==
X-CMS-MailID: 20201023182136eucas1p28518b30e23ae4204840c3d5526bd3400
X-Msg-Generator: CA
X-RootMTR: 20201023182136eucas1p28518b30e23ae4204840c3d5526bd3400
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201023182136eucas1p28518b30e23ae4204840c3d5526bd3400
References: <CAJKOXPeNhXrBa0ZK-k37uhs5izukrhHN-rkxgsjiQBHCMmZs7g@mail.gmail.com>
        <CGME20201023182136eucas1p28518b30e23ae4204840c3d5526bd3400@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-23 pi=C4=85 18:27>, when Krzysztof Kozlowski wrote:
> On Fri, 23 Oct 2020 at 18:05, Rob Herring <robh@kernel.org> wrote:
>>
>> On Wed, 21 Oct 2020 23:49:07 +0200, =C5=81ukasz Stelmach wrote:
>> > Add bindings for AX88796C SPI Ethernet Adapter.
>> >
>> > Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> > ---
>> >  .../bindings/net/asix,ax88796c.yaml           | 69 +++++++++++++++++++
>> >  1 file changed, 69 insertions(+)
>> >  create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796=
c.yaml
>> >
>>
>>
>> My bot found errors running 'make dt_binding_check' on your patch:
>>
>> yamllint warnings/errors:
>>
>> dtschema/dtc warnings/errors:
>> ./Documentation/devicetree/bindings/net/asix,ax88796c.yaml: $id:
>> relative path/filename doesn't match actual path or filename
>>         expected:
>> https://protect2.fireeye.com/v1/url?k=3Db676d09f-eb1194b9-b6775bd0-0cc47=
a31384a-e1cc7da4db18c501&q=3D1&e=3Dea7ae062-8c39-4ee3-82fa-37d28062f086&u=
=3Dhttp%3A%2F%2Fdevicetree.org%2Fschemas%2Fnet%2Fasix%2Cax88796c.yaml%23
>> Documentation/devicetree/bindings/net/asix,ax88796c.example.dts:20:18:
>> fatal error: dt-bindings/interrupt-controller/gpio.h: No such file
>> or directory

Fixed.

> =C5=81ukasz,
>
> So you really did not compile/test these patches... It's the second
> build failure in the patchset. All sent patches should at least be
> compiled on the latest kernel, if you cannot test them. However this
> patchset should be testable - Artik5 should boot on mainline kernel

Yes, I messed up a bit. I made moved some code around without changing
it just before sending and I didn't run dt_binding_check. My fault, I am
sorry.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+THyUACgkQsK4enJil
gBDA3AgAgLMuK0JPBXpBA5PWakifRLC3bGtiJbKxSRzfNrHcVL0xFTwB5A0rs1Dl
b61fHAO945x8XDB7j1Gp0Z2GycAuZVL0fuE63ia4H8gPBqwpEGIQ/1k1ZiDRVLTc
5cGyy9zYazeJkX1+wNZAgnqZ9FgXxrn2vhgF6WzYwiUPnRILxbca82Tidezc88V0
x64WkKpSwFXr4jE2g+aKpDhfI9UZjJ2sB6lzF1rlhg/ZcOg4Iq5WHj6IXIdJVrv2
5NbmVY6JgQgHwCsVxanCWquhbi/DRLZnLuh+oD+VHFntVGKUwe2iYX5/rt8zbGBi
yil22ZMJWOUfvOW/K+uBS7GDgIp+qg==
=xBy1
-----END PGP SIGNATURE-----
--=-=-=--
