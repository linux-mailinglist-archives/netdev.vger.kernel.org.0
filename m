Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C08229F639
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 21:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgJ2Ucm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 16:32:42 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37002 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgJ2Ucg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 16:32:36 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201029203149euoutp023a45d9d52efba1902e5cab24111c067d~CkLGnzXEI0777807778euoutp02Y;
        Thu, 29 Oct 2020 20:31:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201029203149euoutp023a45d9d52efba1902e5cab24111c067d~CkLGnzXEI0777807778euoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1604003510;
        bh=pb5peJL+Fq7yal7O9zQDYDUxf4O+0oVNlLooYDQ+TMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEARg5UfERI2QPeAcKkldQLE2PHB8aJgaLuBa9wcWoJuFBSi5ser9GCrpQQF1JjoC
         1WG+oPbYja7BRLGkAm7KbOX1OiU9V7TGxlufDG3N79rs7L7sjSA0eWFuLzLb6//Q5A
         SdAMJUgZAUkJC1XqejrkGfNlH9DrfzqNJaUjR1HM=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201029203143eucas1p221829b3d8e41cc5f4ca5ed90f02bced5~CkLA6ZICv2113321133eucas1p2y;
        Thu, 29 Oct 2020 20:31:43 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id BE.46.06318.FA62B9F5; Thu, 29
        Oct 2020 20:31:43 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201029203142eucas1p138b7a69cf72e5ad0b1ecd8134adcbccf~CkK-vc3Zb2259322593eucas1p1Q;
        Thu, 29 Oct 2020 20:31:42 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201029203142eusmtrp10756083d29a05e6509de9183e989a1af~CkK-utoo71337413374eusmtrp1C;
        Thu, 29 Oct 2020 20:31:42 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-de-5f9b26af0b21
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 13.06.06017.EA62B9F5; Thu, 29
        Oct 2020 20:31:42 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201029203142eusmtip271b2a01a361d0b4e994bc7af95f28b80~CkK-kdlzn2507625076eusmtip2T;
        Thu, 29 Oct 2020 20:31:42 +0000 (GMT)
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
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolni?= =?utf-8?Q?erkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v4 3/5] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Thu, 29 Oct 2020 21:31:32 +0100
In-Reply-To: <20201029003131.GF933237@lunn.ch> (Andrew Lunn's message of
        "Thu, 29 Oct 2020 01:31:31 +0100")
Message-ID: <dleftjimasvknv.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWUwTURSGczsznaGx5lpcTqpRU5fEDTBu130jOvHJF5VoFItMAKWl6Qgq
        L0KiRrG2KqgIKLKoyG4tFVGwVAISIgVB3EATa6IsdUONiqLUi4lv33/Of7abKzCaAU4rxBj3
        SmajPlanVLHO+u+eOWXTM8NDDllCiKfLzZDr6WUcyfIcYkl2XTNHct+nc6TD18kRm7eXIR5P
        OU9anFaO2L0dHGmrylKSdE+NgrjPVCNSUtfFk/pLY8nh6jp+FRbbOloZ0XHtqUK8ldHFi/bC
        Y0rxRv5B8VZlv0K0OgqR2G+fuFHYqloWKcXGJEjm4BU7VdEDvkHOdFK1P/tIviIJdQspKEAA
        PB++9Vr4FKQSNLgAQVptz7D4PCTyahEV/QjKM72KfyWNlhsMTVxF0DfwUEHFGwQfXVe4FCQI
        ShwEJSVh/oLReDKkNf7k/MzgRyykOSP9HIg3Q93HCt7PLJ4Gt/PSlX4OwAZ42Vr5d5gaLwLX
        gI/x8xi8GBxvX/I0Pgoaz79maU8DnPf0IbrcZQFs+bsph8Lxx60s5UDoaXDwlCdAU6qF9a8J
        +CCknl7oXx+wBYEz69uwfyl0Nv9QUl4NmX3Vw/6R8MQ3io4dCaed5xgaVsPRIxrqngqltjvD
        XbRwoqcAUYsIDUUyfahkBPcKvcxJNDnjv2My/jsmY6iEwTOgrCqYhmfBlZxehvJyKC19z15C
        XCEaJ8XLhihJnmeU9gXJeoMcb4wK2hVnsKOhb9g02PClEtX8jHAjLCDdCPWqSZnhGk6fIB8w
        uNHUoU6vyotakJY1xhkl3Wj1mgdNOzTqSP2BRMkcF26Oj5VkNxovsLpx6nm53ds1OEq/V9oj
        SSbJ/C+rEAK0SWhD/KcFyOWwXTa9Nr0riChekPjsUY5rdnTRm6Q5zz8s+lIco29p1wWQ+zFw
        qu9iyJa2im2d2qIE+8q70ckXZp6yDeblPv898Wxq8QirKay9vZvn1viaf92P+LpuE7uWxV+t
        LivvrU3sztlS8eLXwn03A0OXPGxe0VM+VpX8NDRs/RQdK0fr585kzLL+Dwo5hvSOAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t/xe7rr1GbHG6ztVbY4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7XY9Pgaq8XlXXPYLGac38dk
        cWjqXkaLtUfuslscWyBm0br3CLuDgMflaxeZPbasvMnksXPWXXaPTas62Tw2L6n32LnjM5NH
        35ZVjB6fN8kFcETp2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSW
        pRbp2yXoZfx++4+1YAJXxfy2JUwNjC85uhg5OSQETCRO9mxm7mLk4hASWMoo8e3jPSCHAygh
        JbFybjpEjbDEn2tdbCC2kMBTRokdJ81BStgE9CTWro0ACYsIKEhMOfmHFWQMs8ANFolHkxYz
        gySEBUIkFh28wQhSLySgKzGp1QckzCKgKrF78QywkZwCuRLr3u9nBbF5BcwlDvx+C9YqKmAp
        seXFfXaIuKDEyZlPWEBsZoFsia+rnzNPYBSYhSQ1C0lqFtA2ZgFNifW79CHC2hLLFr5mhrBt
        Jdate8+ygJF1FaNIamlxbnpusZFecWJucWleul5yfu4mRmAkbzv2c8sOxq53wYcYBTgYlXh4
        HeRnxwuxJpYVV+YeYlQBGvNow+oLjFIsefl5qUoivE5nT8cJ8aYkVlalFuXHF5XmpBYfYjQF
        +nMis5Rocj4w+eSVxBuaGppbWBqaG5sbm1koifN2CByMERJITyxJzU5NLUgtgulj4uCUamCs
        1fUW511/058l9zi7w5WLzh/7fXRuJu0pMCk+FSAaYK5m7HPj1cm5P2/ulp1y03+CSY/+55I1
        a9zC3bmi7AsOsdpq3WjY92XTrTfrNQqaWBWu3NnAPCeXvWXhtNVzf0oe/tziKx2adOI2t8L5
        hZ/13y9fGjFfsEkjK/bBn7tL9q6fE8aZGf9ViaU4I9FQi7moOBEAN+hnowYDAAA=
X-CMS-MailID: 20201029203142eucas1p138b7a69cf72e5ad0b1ecd8134adcbccf
X-Msg-Generator: CA
X-RootMTR: 20201029203142eucas1p138b7a69cf72e5ad0b1ecd8134adcbccf
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201029203142eucas1p138b7a69cf72e5ad0b1ecd8134adcbccf
References: <20201029003131.GF933237@lunn.ch>
        <CGME20201029203142eucas1p138b7a69cf72e5ad0b1ecd8134adcbccf@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-29 czw 01:31>, when Andrew Lunn wrote:
>
> Reverse christmass tree
>
>> +
>> +static int ax88796c_process_isr(struct ax88796c_device *ax_local)
>> +{
>> +	u16 isr;
>> +	u8 done =3D 0;
>> +	struct net_device *ndev =3D ax_local->ndev;
>
> ...
>
>> +static irqreturn_t ax88796c_interrupt(int irq, void *dev_instance)
>> +{
>> +	struct net_device *ndev =3D dev_instance;
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>
> ...
>

Doesn't work here - dependency. What next?

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+bJqUACgkQsK4enJil
gBAKfwgArpf5SfpOHrSeEwOv/FF2RM+YNK94OQLgTnozkUVduKhji/wW4VabUXdR
44qDIB7qAclOhG3bZWhnkaARKko11JFLiTcd5/Mc3mQI78EwMYiiY/lzd6horFUl
0awdth20AS8MDTt4j//19pAh3vOCokxqjfk3rRMxcLifNClhGce4S3wyT0N+PuwA
iYi/phClga5nSPWILlFoebUWNuV9z319cqb9mOHvIsQdTaU5BI8ZHOprxthQmtWD
JJti+axUev29O/1oVnH3a43Aq143Hf6blQ+V02LZv5DFmn3DEam4Cemt539YT2qy
/Z3Xd2L8i4fPdLQDOnCzJJo3Nbp3xw==
=CIbI
-----END PGP SIGNATURE-----
--=-=-=--
