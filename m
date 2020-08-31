Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6A8257A34
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 15:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgHaNQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 09:16:41 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58902 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbgHaNQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 09:16:33 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200831131628euoutp017a4cb0aa751f1965a66f612de4f8b206~wXLJfDDQa0455704557euoutp013
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 13:16:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200831131628euoutp017a4cb0aa751f1965a66f612de4f8b206~wXLJfDDQa0455704557euoutp013
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598879788;
        bh=5VQ0Ar29Dvuafq8sMDFtn4rGRbW1P19RvUszVW2Ec1A=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=dTwUQ/JkRXBxHOFulehLhcgMXUVy0RGP8+byRuH5t6A9wSUl8bRgO4R4i55EN2fb6
         KqsDn+qCaH7pEyEyojszZHXvCY0zZ7R6vOu5Ts+8wk+xMqvtjtnNUdHyzuU+Mcp+aW
         3b1pnxdbmIyobj6DEJE6KeiU+b9V9DcGLhp6Npyo=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200831131628eucas1p277df1c0fea3c0b4fdf6e106475f96a73~wXLJN9vsB0220302203eucas1p2B;
        Mon, 31 Aug 2020 13:16:28 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 11.EF.06318.C28FC4F5; Mon, 31
        Aug 2020 14:16:28 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200831131628eucas1p2dbece80673d9a44929084210e658cec8~wXLIuj0Yd0809408094eucas1p22;
        Mon, 31 Aug 2020 13:16:28 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200831131628eusmtrp2f70555b54e2d2b57096f50034829b142~wXLItwQz43092430924eusmtrp2M;
        Mon, 31 Aug 2020 13:16:28 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-3b-5f4cf82c7f32
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 5B.55.06314.B28FC4F5; Mon, 31
        Aug 2020 14:16:28 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200831131627eusmtip2e48c554bfffbc613fc4269af62a5878a~wXLH77e450534905349eusmtip2p;
        Mon, 31 Aug 2020 13:16:27 +0000 (GMT)
Subject: Re: [RFT 3/4] nfc: s3fwrn5: Remove wrong vendor prefix from GPIOs
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <b97ec4e0-fd78-d605-a22b-310426803429@samsung.com>
Date:   Mon, 31 Aug 2020 15:16:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200829142948.32365-3-krzk@kernel.org>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTYRzl27279261cd1Sf5QUjRKKmoUGN3pH0JQFEYUQpS29U8tZ7Kpl
        //Swh62XWZSulUsKH5CP65wPdKDIRprOXFia0UOXqY0KtYdpj3m1/O+c3/edc37n46MwRY94
        PpWUksoaU3TJKkKK250/2leu+K6NXeV6tpipyC0TM89HB8SMxX0WZ/Kb28VMzutsnHl5/RbB
        XOsbxhi3u5xkOuxXxQzf1yVmPHUWgrGUV5JMrtshYpzWIOZcQzPJXPAOYptpja24W6ThSy4S
        mkt3fuGaygcnNVdtJUgzwi/cSeyVro9nk5PSWWPYxgPSxJY8B3G0UX78Su1P8hT6MceEKAro
        CHiRpTAhKaWgixBcOe3DBTKKoJmvwQQygiC/q0tkQpIpRX2LhxAOChH8buhBAvmE4N4bm8jv
        q6SjgH8i8c/n0XcxsGXbMb8ao0sRZPLRfkzQq8HkMxF+LKM3Qof95VQCTi+FpzeGpnAgHQPO
        lne4cCcAHuf1T2EJvQZeVxWRguciqPZZpv2Doac/X+QPBnqShHoXTwprb4OBsVdIwEoYctmm
        5yHwu3ZGkIngbfsjUiCXEXjO5E4r1kFv+zjhr4bRy6CsLkx4vS1wv26BAOXwwhcg7CCHHPtt
        TBjLIOu8QvAIBbOr9F9qY0cnlo1U5lnNzLPamGe1Mf+PtSK8BAWzaZwhgeXCU9hjak5n4NJS
        EtRxRww8+vvjWn+5xmqQY+JgE6IppJorK/qqjVWIdelchqEJAYWp5sm2trXGKGTxuowTrPFI
        rDEtmeWa0AIKVwXLwgsG9yvoBF0qe5hlj7LGmVMRJZl/CkXqt5/uZsOViXtalOota5Vy146x
        xwMLy6yfhjM8edXuzPfRWl/O57UR3d3l/c47uzN6P1jA6vRE9AVG7oquqljSOuYZybp5sSrE
        q43iQ+MKAvVq776aL+dH9MWTiakhG9Q3Td64j/ri3tFCXjL+hXMEtT3clIAiD32f6JT3f1Ph
        XKJu9XLMyOn+AEssu9htAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t/xe7o6P3ziDR4+ZrTYOGM9q8X1L89Z
        Leacb2GxmH/kHKvFpPsTWCxuT5zGZtH/+DWzxfnzG9gtLmzrY7XY9Pgaq8XlXXPYLOZs2Mxu
        MeP8PiaLYwvELFr3HmG3aH/6ktlBwGPLyptMHptWdbJ5dM/+x+KxeUm9R9+WVYwenzfJBbBF
        6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GWcmrmP
        reAgX0Xvzt/sDYw/ubsYOTkkBEwk9py6zNbFyMUhJLCUUeLfkjlsEAkZiZPTGlghbGGJP9e6
        oIreMkocuHULyOHgEBbwkth0hhOkRkRgPrPEgcOKIDXMAusYJV5vbmKFaNjMKNG//CYzSBWb
        gKFE19susA28AnYSF7bdZgKxWQRUJS5OfgVmiwrESZzpeQFVIyhxcuYTFhCbU8BU4v7WFewg
        NrOAmcS8zQ+ZIWx5ie1v50DZ4hK3nsxnmsAoNAtJ+ywkLbOQtMxC0rKAkWUVo0hqaXFuem6x
        oV5xYm5xaV66XnJ+7iZGYFxvO/Zz8w7GSxuDDzEKcDAq8fAGfPGJF2JNLCuuzD3EKMHBrCTC
        63T2dJwQb0piZVVqUX58UWlOavEhRlOg5yYyS4km5wNTTl5JvKGpobmFpaG5sbmxmYWSOG+H
        wMEYIYH0xJLU7NTUgtQimD4mDk6pBsY46Vu3prk0Hylwe5RUuV/xj8oWt42TJ8SZ/J708nlf
        fGv3Yfnq87/8f9nvUPL+dC2PJT4tdD7nJNd7HoLHau8v0t3UXtqgZxSQqX++qn3pRS6bObkG
        RWu4GOZ9rjW6dfpvyWPnEtVwfmOn528DjsUlp61YHPlvv6lTjsaHhdpfORbO2WUSVa7EUpyR
        aKjFXFScCAARjbxVAQMAAA==
X-CMS-MailID: 20200831131628eucas1p2dbece80673d9a44929084210e658cec8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200829143008eucas1p11c924e666bcd7561c787755ea0a0ccb0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200829143008eucas1p11c924e666bcd7561c787755ea0a0ccb0
References: <20200829142948.32365-1-krzk@kernel.org>
        <CGME20200829143008eucas1p11c924e666bcd7561c787755ea0a0ccb0@eucas1p1.samsung.com>
        <20200829142948.32365-3-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29.08.2020 16:29, Krzysztof Kozlowski wrote:
> The device tree property prefix describes the vendor, which in case of
> S3FWRN5 chip is Samsung.  Therefore the "s3fwrn5" prefix for "en-gpios"
> and "fw-gpios" is not correct and should be deprecated.  Introduce
> properly named properties for these GPIOs but still support deprecated
> ones.
>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>   drivers/nfc/s3fwrn5/i2c.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
> index b4eb926d220a..557279492503 100644
> --- a/drivers/nfc/s3fwrn5/i2c.c
> +++ b/drivers/nfc/s3fwrn5/i2c.c
> @@ -200,13 +200,21 @@ static int s3fwrn5_i2c_parse_dt(struct i2c_client *client)
>   	if (!np)
>   		return -ENODEV;
>   
> -	phy->gpio_en = of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);
> -	if (!gpio_is_valid(phy->gpio_en))
> -		return -ENODEV;
> +	phy->gpio_en = of_get_named_gpio(np, "en-gpios", 0);
> +	if (!gpio_is_valid(phy->gpio_en)) {
> +		/* Support also deprecated property */
> +		phy->gpio_en = of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);
> +		if (!gpio_is_valid(phy->gpio_en))
> +			return -ENODEV;
> +	}
>   
> -	phy->gpio_fw_wake = of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);
> -	if (!gpio_is_valid(phy->gpio_fw_wake))
> -		return -ENODEV;
> +	phy->gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
> +	if (!gpio_is_valid(phy->gpio_fw_wake)) {
> +		/* Support also deprecated property */
> +		phy->gpio_fw_wake = of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);
> +		if (!gpio_is_valid(phy->gpio_fw_wake))
> +			return -ENODEV;
> +	}
>   
>   	return 0;
>   }

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

