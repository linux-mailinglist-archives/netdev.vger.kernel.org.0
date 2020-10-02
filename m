Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07AF5280E2E
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 09:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgJBHjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 03:39:54 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55493 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgJBHjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 03:39:53 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201002073951euoutp02a8fc2deac63e61d17b3cd7e4c9388be1~6HOX3m1aI2916729167euoutp02G;
        Fri,  2 Oct 2020 07:39:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201002073951euoutp02a8fc2deac63e61d17b3cd7e4c9388be1~6HOX3m1aI2916729167euoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1601624391;
        bh=D5aWub2riZnqTo8DXxDOKktt9rTQ7gb8ODG+JeKAJtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wt0UR4TJsYXztCDB0J/G59ZNtNKg8K5Tw2DQhJs6WlwhnoBTe5KYXlXwLQRGo141N
         ypm/ssHV4B4/icCR2pH894nAAPrVz1QQ5aR9c2qF8j5nSHC0DPxd9x4PBCUUit/lrJ
         Fe0gUySEc9JrhKNrJqXkMu27px1AQfG7+743xdeU=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201002073951eucas1p1bc659ba0e39770ed0f90ebf9cc0107cc~6HOXd_LQ62480224802eucas1p1l;
        Fri,  2 Oct 2020 07:39:51 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id B6.44.06456.649D67F5; Fri,  2
        Oct 2020 08:39:51 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201002073950eucas1p24615a7f620afa1c1f9c0fc2e47daaef0~6HOXDkF3M2440424404eucas1p2w;
        Fri,  2 Oct 2020 07:39:50 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201002073950eusmtrp1c72bcc925cac99c7dca0939971a4b114~6HOXC3j6r1059210592eusmtrp1R;
        Fri,  2 Oct 2020 07:39:50 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-02-5f76d946beb3
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id A7.83.06314.649D67F5; Fri,  2
        Oct 2020 08:39:50 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201002073950eusmtip24f32a97766d1828355927804046b7573~6HOW2bPFB1575915759eusmtip2h;
        Fri,  2 Oct 2020 07:39:50 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>, steve.glendinning@shawell.net,
        UNGLinuxDriver@microchip.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        b.zolnierkie@samsung.com, m.szyprowski@samsung.com
Subject: Re: [PATCH] net/smscx5xx: change to of_get_mac_address()
 eth_platform_get_mac_address()
Date:   Fri, 02 Oct 2020 09:39:40 +0200
In-Reply-To: <6fad98ac-ff25-2954-8d62-85c39c16383c@gmail.com> (Florian
        Fainelli's message of "Thu, 1 Oct 2020 19:45:35 -0700")
Message-ID: <dleftj362xf54z.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0iTYRTu3fftWluvS/NkYTKMKGkmSn1RSoXUV3/qT5Bi6dQvldyUrZkV
        pWFFM7Wy60xtLbw0ndZcQ60MhpphaWZ2U8vutdJoXTCji9tr4L/nPOc5zznPyyui5H38AFGa
        Zgen1ajSFQIJ7Wj/2bVo7ZOs+MUP/iDmytl6PlPafYBmxkZahcw9RxGfMVcepBhr66CQaTfN
        ZPLcLh7z63iPYKWYtV96wmObSgaFrM1iELADoxWILbJbEPs3r5dmv9oCNwpjJSuSufS0LE4b
        GpUgSS373kdlNuLs0eKXVC6qkuUjkQhwBBwpZPORRCTH1Qje2N5SpPiG4JqhgU+KrwgsXbV0
        PhJ7J8wPTwpIowrB/qJHAk9Djt8h6B2L9NgKsBKs1s0e2heHgLvHxPPoKY+k5tlxr9EMnAiv
        2p5RHj2N54HlUaRHI8a5CMrqOryeUrwUHlaWe7EfXgb298+FhPeB28bXXh8Kq8HY/Ql5hgEP
        C6Hx7TAil0ZDwfM7FMEzwHXLLiR4DnSeKKBJ/hw4UbyEzBYgcJSOTqRcDgNdYwKCV0HTgRdC
        opfB42EfslcGxY4zFKGlcPiQnKiDoe7o9QmXACh0VU9cw8LRjtM0ebdjCG5eraKOoaCSSXFK
        JsUpGbel8AKobw4ldAhUXvhIERwJdXWfaRPiW5A/p9epUzhdmIbbqdSp1Dq9JkWZlKG2ofEP
        1vnnlrsRfb+f6ERYhBTTpKlOfbycr8rS7VI7UfC408vLNfdQAK3J0HAKX+nqu51b5dJk1a7d
        nDYjXqtP53RONFtEK/yl4eYPW+Q4RbWD285xmZz2f5cnEgfkonBexUjq5+LfT/0q5jd031jn
        aI5Yr2xvG7IFTflUDhejgvoNbbjFGLX3l+F87Ya5gXvyJFxMxn3xyrjZBvm5pA5r9JpZkbwf
        7sQv02vP5LTkxqQZ7T1xqo45ekWozOYb4qM3F27b884UFrtvbGjqkLKytRCfmtufHe3a1HIw
        wdqnoHWpqrCFlFan+gcLAegEaAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/xe7puN8viDb78V7DYOGM9q8Wc8y0s
        Fr/eHWG3uLCtj9Vi0bJWZou1R+6yWxxbIGbR/OkVk8XviRfZHDg9tqy8yeSxc9Zddo9NqzrZ
        PO78WMro0bdlFaPH/+bLLB6fN8kFsEfp2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvH
        WhmZKunb2aSk5mSWpRbp2yXoZcz9epW5YIdAxY9Jj5gbGJfzdTFyckgImEgsujaFrYuRi0NI
        YCmjxIpXX1m7GDmAElISK+emQ9QIS/y51gVV85RR4svNc+wgNWwCehJr10aA1IgIaEt8uriA
        CaSGWeARo0T/q6tMIAlhgQSJiYt/sYDYQgI2Ejf7VrGB9LIIqEqsum4LUs8p0MAoMXfdCTaQ
        Gl4Bc4lry+aB2aIClhJbXtxnh4gLSpyc+QRsDrNAtsTX1c+ZJzAKzEKSmoUkNQtoBbOApsT6
        XfoQYW2JZQtfM0PYthLr1r1nWcDIuopRJLW0ODc9t9hQrzgxt7g0L10vOT93EyMw/rYd+7l5
        B+OljcGHGAU4GJV4eAUOlMYLsSaWFVfmHmJUAflyw+oLjFIsefl5qUoivE5nT8cJ8aYkVlal
        FuXHF5XmpBYfYjQF+nMis5Rocj4wZeSVxBuaGppbWBqaG5sbm1koifN2CByMERJITyxJzU5N
        LUgtgulj4uCUamBk3dC0K0WQ89Kia11G8/7vTZ4R8W/t7gvB2+YdmB8exLknufXCxwV14h+5
        n95QbH+VKpLMI3nS6juzJa/c4uBjJ7LPOZzNuWaxRJFRuXahtc/l17/nsCV1iBfLLxEKDrGa
        e1dmzbbcD5/cpeaf2DpdRjYiku/zspeq/d2Nhiab69cei9VK6pRSYinOSDTUYi4qTgQAb/WR
        2OECAAA=
X-CMS-MailID: 20201002073950eucas1p24615a7f620afa1c1f9c0fc2e47daaef0
X-Msg-Generator: CA
X-RootMTR: 20201002073950eucas1p24615a7f620afa1c1f9c0fc2e47daaef0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201002073950eucas1p24615a7f620afa1c1f9c0fc2e47daaef0
References: <6fad98ac-ff25-2954-8d62-85c39c16383c@gmail.com>
        <CGME20201002073950eucas1p24615a7f620afa1c1f9c0fc2e47daaef0@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-01 czw 19:45>, when Florian Fainelli wrote:
> On 10/1/2020 7:05 PM, David Miller wrote:
>> From: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> Date: Wed, 30 Sep 2020 16:25:25 +0200
>>
>>> Use more generic eth_platform_get_mac_address() which can get a MAC
>>> address from other than DT platform specific sources too. Check if the
>>> obtained address is valid.
>>>
>>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>>
>> Failure to probe a MAC address should result in the selection of a
>> random one.  This way, the interface still comes up and is usable
>> even when the MAC address fails to be probed.
>
> True, however this behavior is not changed after this patch is
> applied, I would argue that this should be a separate patch.

In both drivers the second to last line of the *_init_mac_address()[1][2]
functions is

    eth_hw_addr_random(dev->net);

and I haven't changed that. My patches enable getting a MAC address via
arch/platform specific function[3] arch_get_platform_mac_address() if
of_get_mac_address() fails.

[1] https://elixir.bootlin.com/linux/v5.8/source/drivers/net/usb/smsc75xx.c=
#L758
[2] https://elixir.bootlin.com/linux/v5.8/source/drivers/net/usb/smsc95xx.c=
#L902
[3] https://elixir.bootlin.com/linux/v5.8/source/net/ethernet/eth.c#L502
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl922TwACgkQsK4enJil
gBCEKAf/TX86ykn+SzGrLYzd3w63xgsPezT+G2UL3wYBuHWgSMFd8yXtRepEg3As
GW4TeLITEahwOdZ3KxEQ6IHyPq06jggy/+gki8Gt5//PNatRySgF9njfHRx7YQOx
GA9yqa41US1Z7ZZHAY2C+Eypnsdp06f8eclX59Fc1Od2oxlsVwCA1G/uQieqoIoT
xd9sY975ekwLQpFcqD698XMbZZ4QN353HsJVDxjTySwHPhFrEHZYlIPnZNMq0Mp3
S7+do05lRBdVO8ZCwOYSgi1BSVeAzYYorDoOkgSnT5/27T7oGqqsLUoyEvxq9ykM
1hLZ33XnFn3Rv64FFRYkUi2SD1YjHw==
=Yb9X
-----END PGP SIGNATURE-----
--=-=-=--
