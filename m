Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D221AF9A7
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 13:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgDSLmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 07:42:40 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43532 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgDSLmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 07:42:39 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200419114237euoutp029c3913252399ecb584222f2b78de8280~HNc89X3m73109531095euoutp02O
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 11:42:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200419114237euoutp029c3913252399ecb584222f2b78de8280~HNc89X3m73109531095euoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587296557;
        bh=AeTRUoP5V39CmSWykAJx1gTZc2CekR22fFKKiooFO+g=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=IH03Bg4Mgsp98nHLKfc76dpGIpzk4kRkeYYtydFyaqOYqVv3DSz2mdHTGqRSqvUxx
         h6sMPFG/uukNo/RXtSJoTNbSFjgfKJY3ByAuCoW6K4zLi1SVXyP+OwHheW5wfqsJWW
         ZqxrwFWm2XsSlsSR1gqEyx+XnIM0110rBr1JW6oM=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200419114237eucas1p29db691d91c8248572d40852ad3b7743e~HNc8dbWpT0646806468eucas1p2a;
        Sun, 19 Apr 2020 11:42:37 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id D9.26.61286.D293C9E5; Sun, 19
        Apr 2020 12:42:37 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200419114236eucas1p2f22fabf1382dc66f37e5ee2121ca5e69~HNc7qsku-0762307623eucas1p2F;
        Sun, 19 Apr 2020 11:42:36 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200419114236eusmtrp1616b7a71d57cf7ff1cde47c5144a3f64~HNc7pncTW0522005220eusmtrp1K;
        Sun, 19 Apr 2020 11:42:36 +0000 (GMT)
X-AuditID: cbfec7f2-ef1ff7000001ef66-76-5e9c392d611f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 49.74.08375.C293C9E5; Sun, 19
        Apr 2020 12:42:36 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200419114235eusmtip2836501a9d091fe7d1d7b3ed83e181389~HNc6dpjMf2488024880eusmtip25;
        Sun, 19 Apr 2020 11:42:35 +0000 (GMT)
Subject: Re: [RFC 0/8] Stop monitoring disabled devices
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <4e77037a-6f19-b7a2-0090-9469f8297ee2@samsung.com>
Date:   Sun, 19 Apr 2020 13:42:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <fc166e0f-91ec-67d5-28b0-428f556643a4@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbUxTZxjNe+/tvRek5rWofVTmsmY6R4JAFH3d1Ay3LPef/jBTl4lWuEEy
        KKYVpsZEnN8NKoqIFERQArRbkJVC6QQUVHCWFEUxakDtqFqJFS1+FUbV2wsZ/85znnPe55zk
        5WlVKzuTT9NtFfU6bbqGDWca2gOumJglJUlxOcEIYr4WZMg7V4Ailf0PGHL81AealA59Rkq6
        9jLEWB5H3D0ryf6hUwxxX/qe3Nt9gSIl3mxS58pVEEuBgyEOt48lVS1HEbH231EQ47CZJkOH
        ryDSXjad3LjxC/mjyUuTTme3gnjcR1gyarcyxGtTk+Z9N2lSZy2gv4sSGvsqkGAz36OEan+s
        4DD1cUJddbRwrukZJVgth1ih904TK7xwuT7xFbuEV889nPCk8DIl5L30scJfLxop4ehonPD+
        1nPFqsifw5emiOlp2aI+dvnG8M191x+iLYXcttvV17kc9FphRGE84IXQ31JOG1E4r8LVCHoe
        VHHy8BrByMtBVh6GEFyx5jLjlleO/8ZUVQhOlt1UyIMPwWBDASepIvFiKO6qZCU8FS+AQIMv
        5KDxWw4eX3waeorF38CxAxZkRDyvxMvh30CMRDN4DvQ8dCAJT8Nrwf/ociisEk+Bf4o8IWsY
        ToQiXwstYRqr4b7nDCXjz2FPfXGoEOD8MOjd04bk2D9Ahe0QK+NIGOiwcTKOAme+VE0y1CAY
        Pegdc9sRVOUHxxzfQq9rmJWS0vhrOP93rEwnwtXOGk6iAU+Gu74pcojJcLyhkJZpJRzcr5LV
        c6G2spYdP2t0mOk8pDFNqGaaUMc0oY7p/7tliLEgtZhlyEgVDfE68bf5Bm2GIUuXOj85M8OK
        Pn1sZ7DD34jedG9qQ5hHmgglLClOUim02YbtGW0IeFozVdn6Y1GSSpmi3b5D1Gdu0Geli4Y2
        NItnNGrlgrPP1qtwqnar+KsobhH141uKD5uZg9aZjnk1V9MndaSoZ2jY2c2z45JOBob15Ypd
        1/yeYC47UDfyYeH5Oe/y7fERk9afmFu7bl+pSeesr81r1NkSmeafWHOE/Ut+0VeubofxdLLz
        99Y181JG0OGdXZ0b3M7ynFn+3C/+VC0bKF2WlbAmqsdPWRJqMhMu1tsrm1fkrU4Y1DCGzdr4
        aFpv0H4EVMO5X9QDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsVy+t/xe7o6lnPiDDZ1SlusPPGPxeL7uZ9M
        Fsse32OxmDTjP7PFvM+yFnPOt7BYdC00sHh41d+i7fMMFouHB5wtbjbuZrKY86LMYvO5HlaL
        VVN3sljsfPiWzWL5vn5Gi02Pr7FadP1ayWzxufcIo8WxBWIWFy7EWKze84LZ4szpS6wWTx72
        sVn83b6JxeLFFnGLva0XmS02b5rK7CDjsePuEkaPLStvMnms+KTvsXPWXXaPzSu0PBbvecnk
        sWlVJ5vHnWt72DzenTsHFF9S7/HxzRN2j2fTDzN5TPjwls1j47sdTB79fw08flx+wxogHKVn
        U5RfWpKqkJFfXGKrFG1oYaRnaGmhZ2RiqWdobB5rZWSqpG9nk5Kak1mWWqRvl6CXcffUfcaC
        6ewVV1acYm9g/MLaxcjJISFgIvFx5x92EFtIYCmjRM+5zC5GDqC4jMTx9WUQJcISf651sXUx
        cgGVvGaU2PnqMxtIQljAXGL2+WVgtoiAscTPbW/ZQYqYBX6wS/Q9/gLV8ZxJYvOmE2Db2ASs
        JCa2r2IE2cArYCfx6KcuSJhFQFXi6v2djCC2qECExOEds8BsXgFBiZMzn7CA2JwCjhIz3+5j
        BrGZBdQl/sy7BGWLS9x6Mp8JwpaXaN46m3kCo9AsJO2zkLTMQtIyC0nLAkaWVYwiqaXFuem5
        xYZ6xYm5xaV56XrJ+bmbGIHJaduxn5t3MF7aGHyIUYCDUYmHV8JydpwQa2JZcWXuIUYJDmYl
        Ed6DbjPjhHhTEiurUovy44tKc1KLDzGaAj03kVlKNDkfmDjzSuINTQ3NLSwNzY3Njc0slMR5
        OwQOxggJpCeWpGanphakFsH0MXFwSjUwZnEr9Jd2RB7/u1sqzHvb8eNPDnilz1md3LooJd5p
        1tb5kvyvDvHwr9JIZ9BgeyXXseS9t7pKW+OazmhOlsfdX52mfZcS6zi5tTtNzbO6f/Ln7rPR
        /853f7GeL1L6tll2V0fC/z08FyLXvjvWksvnN7N4XcCDhiT++oWvH1w8MynlRMT944WVSizF
        GYmGWsxFxYkA4j6U6GQDAAA=
X-CMS-MailID: 20200419114236eucas1p2f22fabf1382dc66f37e5ee2121ca5e69
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200415104010eucas1p101278e53e34a2e56dfc7c82b533a9122
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200415104010eucas1p101278e53e34a2e56dfc7c82b533a9122
References: <20200407174926.23971-1-andrzej.p@collabora.com>
        <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
        <aeec2ce8-8fb9-9353-f3dd-36a476ceeb3b@collabora.com>
        <CGME20200415104010eucas1p101278e53e34a2e56dfc7c82b533a9122@eucas1p1.samsung.com>
        <dc999149-d168-0b86-0559-7660e0fdec77@samsung.com>
        <fc166e0f-91ec-67d5-28b0-428f556643a4@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/17/20 6:23 PM, Andrzej Pietrasiewicz wrote:
> Hi Barlomiej,
> 
>>> Thanks for feedback.
>>>
>>> Anyone else?
>>
>> Yes. :)
>>
>> Please take a look at the following patchset (which I'm reviving currently):
>>
>>     https://protect2.fireeye.com/url?k=5d37badf-00a92135-5d363190-0cc47a6cba04-376ae45aa028b19a&q=1&u=https%3A%2F%2Flkml.org%2Flkml%2F2018%2F10%2F17%2F926
>>
>> It overlaps partially with your work so we need to coordinate our efforts.
>>
> 
> I've just sent a v3. After addressing your and Daniel's comments my series
> now looks pretty compact. Let's see if there's more feedback. Is your work on
> reviving the above mentioned 2018 series ready?

Not yet, also I think now that it will be the best if I rebase my changes on
top of your patchset (once it is ready/finished).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
