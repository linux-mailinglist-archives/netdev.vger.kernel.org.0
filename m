Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9FA257A3B
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 15:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgHaNRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 09:17:21 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56754 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgHaNQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 09:16:53 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200831131651euoutp025bcd3cb2e6350c974c29a2803874e4f0~wXLec7LKY2169921699euoutp02T
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 13:16:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200831131651euoutp025bcd3cb2e6350c974c29a2803874e4f0~wXLec7LKY2169921699euoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598879811;
        bh=5nP5KvDT5qN8c57PFcGNX+7gNR6f6VMKSvBr/mSxdxE=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=BWvvFDdiM05PYjWtryepUCs1Mgw1S15LA3h5ikuWP1x1C1rBnU6BBBDA20qlqyVSz
         kxNkx4imUduYdH4USGSeA43nFzCtxNYGzal3MSirAjO9YuBhnQiSfBpl5BKd0et9Ex
         j2qO7LEXgqAH5o5w1jmPOrZ3ZRmhCJ+lnacEIC3A=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200831131650eucas1p134722c283ee08857a38d94c048827828~wXLd7YaIe1484214842eucas1p1v;
        Mon, 31 Aug 2020 13:16:50 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id BA.F8.06456.248FC4F5; Mon, 31
        Aug 2020 14:16:50 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200831131650eucas1p296e31e2ea42c8075f3defc2d449e17b3~wXLdmR5kP1084710847eucas1p27;
        Mon, 31 Aug 2020 13:16:50 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200831131650eusmtrp22d7506be16746006b14780816d7c5e28~wXLdlbQe63092430924eusmtrp2C;
        Mon, 31 Aug 2020 13:16:50 +0000 (GMT)
X-AuditID: cbfec7f2-809ff70000001938-21-5f4cf842b039
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 4B.65.06314.248FC4F5; Mon, 31
        Aug 2020 14:16:50 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200831131649eusmtip15b068521d7ab06a291b62c4f0d4c4872~wXLcxQKlC2717527175eusmtip1V;
        Mon, 31 Aug 2020 13:16:49 +0000 (GMT)
Subject: Re: [PATCH 4/4] arm64: dts: exynos: Use newer S3FWRN5 GPIO
 properties in Exynos5433 TM2
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
Message-ID: <8fe346a7-3c6c-f51d-f2a2-623931628a25@samsung.com>
Date:   Mon, 31 Aug 2020 15:16:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200829142948.32365-4-krzk@kernel.org>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsWy7djPc7pOP3ziDRZsMbTYOGM9q8X1L89Z
        Leacb2GxmH/kHKvFpPsTWCxuT5zGZtH/+DWzxfnzG9gtLmzrY7XY9Pgaq8XlXXPYLOZs2Mxu
        MeP8PiaLYwvELFr3HmG3aH/6ktlBwGPLyptMHptWdbJ5dM/+x+KxeUm9R9+WVYwenzfJBbBF
        cdmkpOZklqUW6dslcGXMXbSPueAWR8WqBd+ZGhjnsXcxcnJICJhIrG1pZQWxhQRWMEpsnaUD
        YX9hlNj+0KGLkQvI/gxkX33OCtPQP38nO0TRckaJb29SIIreM0p8bfrIDJIQFkiSaG78ygiS
        EBGYyyyxZcI2sASzwDpGieZN4SA2m4ChRNfbLjYQm1fATmL15i0sIDaLgKrEwQu9YNtEBeIk
        jp16xAJRIyhxcuYTMJtTwFSi891WJoiZ8hLb386Bmi8ucevJfCaQxRICX9kljl5tYIE420Vi
        1v05UC8IS7w6vgXqfxmJ/zthGpoZJR6eW8sO4fQwSlxumsEIUWUtcefcL6BTOYBWaEqs36UP
        EXaUOHLmMRNIWEKAT+LGW0GII/gkJm2bzgwR5pXoaBOCqFaTmHV8HdzagxcuMU9gVJqF5LVZ
        SN6ZheSdWQh7FzCyrGIUTy0tzk1PLTbMSy3XK07MLS7NS9dLzs/dxAhMcaf/Hf+0g/HrpaRD
        jAIcjEo8vAFffOKFWBPLiitzDzFKcDArifA6nT0dJ8SbklhZlVqUH19UmpNafIhRmoNFSZzX
        eNHLWCGB9MSS1OzU1ILUIpgsEwenVAOj7wSOp08PBzHtOCAUz/I4qUPwcuPuWUvVF1sefZQr
        36/iemXRC7HC9JJkhxd2GnXPJrf2iNTrXAwWjtJdnm7r4Hqr94Niif7n08tDvA6YfWgLfPRv
        0vKtb6c9VDsbO3OTiHL9w08fuDelHjzzZ3XnufypnpETHy+qO6ty7Wdv1qVwjwsnbxxtVGIp
        zkg01GIuKk4EAB5Guo1tAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t/xu7pOP3ziDRrWi1tsnLGe1eL6l+es
        FnPOt7BYzD9yjtVi0v0JLBa3J05js+h//JrZ4vz5DewWF7b1sVpsenyN1eLyrjlsFnM2bGa3
        mHF+H5PFsQViFq17j7BbtD99yewg4LFl5U0mj02rOtk8umf/Y/HYvKTeo2/LKkaPz5vkAtii
        9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DLmLtrH
        XHCLo2LVgu9MDYzz2LsYOTkkBEwk+ufvBLK5OIQEljJKTNlxACohI3FyWgMrhC0s8edaFxtE
        0VtGic6ZEAlhgSSJpS+uM4HYIgLzmSUOHFYEKWIWWMco8XpzEytEx2ZGibsXNoNVsQkYSnS9
        BRnFycErYCexevMWFhCbRUBV4uCFXrCpogJxEmd6XkDVCEqcnPkErIZTwFSi891WsDnMAmYS
        8zY/ZIaw5SW2v50DZYtL3Hoyn2kCo9AsJO2zkLTMQtIyC0nLAkaWVYwiqaXFuem5xYZ6xYm5
        xaV56XrJ+bmbGIGRve3Yz807GC9tDD7EKMDBqMTDG/DFJ16INbGsuDL3EKMEB7OSCK/T2dNx
        QrwpiZVVqUX58UWlOanFhxhNgZ6byCwlmpwPTDp5JfGGpobmFpaG5sbmxmYWSuK8HQIHY4QE
        0hNLUrNTUwtSi2D6mDg4pRoYXdU+6nkkhj9bcdirI1BA/YGP89Lw+XGWVxqSvpp2LA64k/Fi
        78EJMxkuJpQtncZ/2/TV7IRP6pYP/XJzz6bveJfxLCZBTtXVM6il2WqxUeWp+px7ds6uSYt/
        FXZ1svCf/O95Xfcc3xYZS2tNsz8xrCGJQQEfJh4sVIh76Fn5/vbZRS5VPvuVWIozEg21mIuK
        EwG42OC7AgMAAA==
X-CMS-MailID: 20200831131650eucas1p296e31e2ea42c8075f3defc2d449e17b3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200829143012eucas1p1b49614f85907091480a3b53ec70221b9
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200829143012eucas1p1b49614f85907091480a3b53ec70221b9
References: <20200829142948.32365-1-krzk@kernel.org>
        <CGME20200829143012eucas1p1b49614f85907091480a3b53ec70221b9@eucas1p1.samsung.com>
        <20200829142948.32365-4-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29.08.2020 16:29, Krzysztof Kozlowski wrote:
> Since "s3fwrn5" is not a valid vendor prefix, use new GPIO properties
> instead of the deprecated.
>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>   arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi b/arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi
> index 250fc01de78d..24aab3ea3f52 100644
> --- a/arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi
> +++ b/arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi
> @@ -795,8 +795,8 @@
>   		reg = <0x27>;
>   		interrupt-parent = <&gpa1>;
>   		interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;
> -		s3fwrn5,en-gpios = <&gpf1 4 GPIO_ACTIVE_HIGH>;
> -		s3fwrn5,fw-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
> +		en-gpios = <&gpf1 4 GPIO_ACTIVE_HIGH>;
> +		wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
>   	};
>   };
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

