Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6BC260439
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 20:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731457AbgIGSHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 14:07:32 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58764 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728421AbgIGSHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 14:07:18 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200907180716euoutp0174eb10b253a3c460e8311e64a5fd3f9e~ykqC6nTPG1643416434euoutp01a;
        Mon,  7 Sep 2020 18:07:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200907180716euoutp0174eb10b253a3c460e8311e64a5fd3f9e~ykqC6nTPG1643416434euoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599502036;
        bh=9Ov1IwgdblahQ1lnpPYahXN/H6AgUfE+QnPNwnweqZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWpGnNXeM2sOwVjlU76n6o/dgwIKCvpzpTDZzn9kS0XdHu1VEKG4N5ZrYY8cZwPMP
         hxZI+GMAOldQSVf0b3zCpVcsb8Bx5LlZborBUGJ2mGK1XJJxKNyxFRfbAlD61R9I/c
         0mhVsltxLLM0etSEUYJNrUuHsGkSomgJ8q5iO+OY=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200907180716eucas1p20a614580eaa2b31e3d99363c794e84d6~ykqCfIW8o3155731557eucas1p2P;
        Mon,  7 Sep 2020 18:07:16 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 5C.27.06456.4D6765F5; Mon,  7
        Sep 2020 19:07:16 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200907180715eucas1p1c1e41bb1ddb5a401a4d9c8cb6117e1f6~ykqB3Wzxx0579005790eucas1p18;
        Mon,  7 Sep 2020 18:07:15 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200907180715eusmtrp28dad76c94961905038faa5884ba07596~ykqB2izpA0235102351eusmtrp2T;
        Mon,  7 Sep 2020 18:07:15 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-10-5f5676d4e5df
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id E6.D4.06017.3D6765F5; Mon,  7
        Sep 2020 19:07:15 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200907180715eusmtip2eb502591ea7603adc67594d5c9abe1ea~ykqBthZor0136101361eusmtip2m;
        Mon,  7 Sep 2020 18:07:15 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc\@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        "m.szyprowski\@samsung.com" <m.szyprowski@samsung.com>,
        "b.zolnierkie\@samsung.com" <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Date:   Mon, 07 Sep 2020 20:06:56 +0200
In-Reply-To: <1efebb42c30a4c40bf91649d83d60e1c@AcuMS.aculab.com> (David
        Laight's message of "Wed, 26 Aug 2020 15:06:51 +0000")
Message-ID: <dleftjk0x5qx4v.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SeUhUURTGve+9efMcGruNWqcpRKaCFnJpsRtZaRg8/KOiRSIwG+tlojMT
        M2kb1LRig2muqQlNWWaGZjoOZmU1qJOYjtlCgmVkUW4VldlCi6+b0H/f/c7vu+ecyxVYzaBC
        KyQad0lmoz5Zx6s4Z/M3z9xHqTFxIR/yBHKt4KqCFHuOcqTuYg1Dzja2K0hm7wBLPJ4qJelw
        ZihIde8TBXlYX8yTAk8DQ1x5txCpaHymJM32ieTYrUZlhI+YeSaXFx8+ecCKjstdjFhdfoIX
        ay4cFDMc5Uj8VB2wRrlJFb5NSk5MlczBy7aodjS9mrzzht8e250hpRV1YxvyFgAvAHfVEGdD
        KkGDyxB8aT3M0sNnBH0jTl6mNPgTAkdL4Fgif8TGUf8SAs+7cBp4g6C/3z0aEAQeB0FFxUaZ
        8cOzIedzNyMzLK5VQHmLDckFX7wOSh7fZ2XN4RnwM/8OL0Pe2IqgtKnrb2c1XgTXSkoZWfvj
        xeB426Ok/gRoKXz1dwoWG6DQM4jkMOAsAX73tijpqFFQas9mqPaFfrfjnz8Vfl8/y8iTAj4I
        OdlhNJuOwFn8laPMEuhu/85THQk9zi885X3g6dAE2tcHsp2nWWqrIe24htLToTLz5r9btHCy
        vwxRRIRsm4m+VQ4C97NvzCkUWPTfNkX/bVM0GmHxLLhaH0ztOVB6boCleilUVr7n7EhRjiZJ
        KRZDgmQJNUq7gyx6gyXFmBC01WSoRqP/rvWX+2MdGu6MdyEsIN049YfomDiNQp9q2Wtwoemj
        N72sutKBtJzRZJR0fuoVba2bNept+r37JLMpzpySLFlcaIrA6Sap55/vi9XgBP0uKUmSdkrm
        sSojeGutyFA7MnMdMS3/8XRVc7wua3xkpf0ut6EtTSDdIcmqZbFF/kcONWDrgqT4qLqjphOr
        azoTp21VR/uHHQhcGR5hf/5CFxP8vmnNsGuKuNa+/VB6W4JVe4Oo7mX2VLxOK5lbHPs6ZsC3
        YFzQsFdVx6L2EK/bnQvjX+b2JPrNawjYv15zX8dZduhDZ7Nmi/4PjNCQA38DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t/xe7qXy8LiDeZPU7DYOGM9q8Wc8y0s
        FjuWbmaymH/kHKtF/+PXzBbnz29gt7iwrY/VYtPja6wWl3fNYbOYcX4fk8WhqXsZLdYeuctu
        cWyBmEXr3iPsDnwe/bOnsHlcvnaR2WPLyptMHptWdbJ5bF5S79G3ZRWjx+dNcgHsUXo2Rfml
        JakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWpRfp2CXoZR59IFuwWqeg6
        8Ja9gfGOQBcjJ4eEgInEtO9dLF2MXBxCAksZJY68O8TaxcgBlJCSWDk3HaJGWOLPtS42iJqn
        jBKPTm1lBKlhE9CTWLs2AqRGREBLYvKXO0wgNcwCC1klJu9/ygySEBYIlHgw7xQ7SL2QgL3E
        5/lKIGEWAVWJv9MOgM3kFGhglFh29CYbSIJXwFxi4+JlTCC2qIClxJYX99kh4oISJ2c+YQGx
        mQWyJb6ufs48gVFgFpLULCSpWUDrmAU0Jdbv0ocIa0ssW/iaGcK2lVi37j3LAkbWVYwiqaXF
        uem5xUZ6xYm5xaV56XrJ+bmbGIHRuu3Yzy07GLveBR9iFOBgVOLh/eAVFi/EmlhWXJl7iFEF
        aMyjDasvMEqx5OXnpSqJ8DqdPR0nxJuSWFmVWpQfX1Sak1p8iNEU6NGJzFKiyfnABJNXEm9o
        amhuYWlobmxubGahJM7bIXAwRkggPbEkNTs1tSC1CKaPiYNTqoHRqXH2Vu1s5qJZ9wINXTZs
        OrdVNkUzrrr7ZkfP7s5goQXnZWbn/jDj28BtJRLJeWaB/9zu2U5NihEKL64oh1bKb05Y6Z7s
        nVa6412tcMbz7HW6t3ZVJp3XEb4adv1oRHvyyU03FDdtPhvC6lgjEnTjT6Tf3JCmTL+nv0y5
        O04r1rE6+bd/lVdiKc5INNRiLipOBABgnstS+AIAAA==
X-CMS-MailID: 20200907180715eucas1p1c1e41bb1ddb5a401a4d9c8cb6117e1f6
X-Msg-Generator: CA
X-RootMTR: 20200907180715eucas1p1c1e41bb1ddb5a401a4d9c8cb6117e1f6
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200907180715eucas1p1c1e41bb1ddb5a401a4d9c8cb6117e1f6
References: <1efebb42c30a4c40bf91649d83d60e1c@AcuMS.aculab.com>
        <CGME20200907180715eucas1p1c1e41bb1ddb5a401a4d9c8cb6117e1f6@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-08-26 =C5=9Bro 15:06>, when David Laight wrote:
> From: Lukasz Stelmach
>> Sent: 26 August 2020 15:59
>>=20
>> It was <2020-08-25 wto 20:44>, when Krzysztof Kozlowski wrote:
>> > On Tue, Aug 25, 2020 at 07:03:09PM +0200, =C5=81ukasz Stelmach wrote:
>> >> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
>> >> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
>> >> supports SPI connection.
> ...
>> >> +++ b/drivers/net/ethernet/asix/Kconfig
>> >> @@ -0,0 +1,20 @@
>> >> +#
>> >> +# Asix network device configuration
>> >> +#
>> >> +
>> >> +config NET_VENDOR_ASIX
>> >> +	bool "Asix devices"
>> >> +	depends on SPI
>> >> +	help
>> >> +	  If you have a network (Ethernet) interface based on a chip from A=
SIX, say Y
>> >
>> > Looks like too long, did it pass checkpatch?
>>=20
>> Yes? Let me try again. Yes, this one passed, but I missed a few other
>> problems. Thank you.
>>=20
>> >> +
>> >> +if NET_VENDOR_ASIX
>> >> +
>> >> +config SPI_AX88796C
>> >> +	tristate "Asix AX88796C-SPI support"
>> >> +	depends on SPI
>> >> +	depends on GPIOLIB
>> >> +	help
>> >> +	  Say Y here if you intend to attach a Asix AX88796C as SPI mode
>> >> +
>> >> +endif # NET_VENDOR_ASIX
>
> There are plenty of other ethernet devices made by ASIX (eg USB ones)
> that have nothing at all to do with this driver.
> So those questions are too broad.
>
> The first one should probable be for ASIX SPI network devices.
>

On the other hand there is only one ASIX SPI network device and there
are four other Non-PCI AX88* chips (and that is all I know about them).

> (I can't imagine SPI being fast enough to be useful for ethernet...)

Not for a file server, sure. It handles clock up to 40MHz and it's meant
for systems that cannot handle more than a few MB/s anyway.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl9WdsEACgkQsK4enJil
gBCEDwf/ZAzzxZQsYFkciKV12hSut3cBhW9zfz+Zbxu1YFnFrPRfBmdwn7vmP8vb
uJTacwtFJ3OAJiWhQIt7r4tb/Uh1lK9S/kjVDABUtssuGj8YDgbBKUVdeA1ESPy9
u3wl2aId3k9NPp6sshwqb9Wmigqh6SjsA9hLvxQEBgfOrjvh95JA0TYqrmRijyn2
k1YitbAzKa5uIh1GziCGwehfvOxALSg09uCkA7mr/yRpjbmvrlitNlfQA+at0XWy
d+f0T474TbGCVDIxIV2f8+HFe3iOPeZJxFOkjiEi9PclaB/arQvbhT6IxJd3mIei
g/+F/BYB/aiBxxSLgg3Q3XL7YY6ecA==
=/xTC
-----END PGP SIGNATURE-----
--=-=-=--
