Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0A95F54FA
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 15:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiJENFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 09:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiJENFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 09:05:51 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E797821E2A
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 06:05:47 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20221005130543euoutp027f560538f505fdda25455b6afba42fb8~bLhJcCOy80615306153euoutp02u
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 13:05:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20221005130543euoutp027f560538f505fdda25455b6afba42fb8~bLhJcCOy80615306153euoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664975143;
        bh=cShw/3LGlylN+4jJotpQbuNoLk30Zznf4m8prglpDWE=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=S/UHF0e2phRkGiCF0XGwtynhMSI6OuPOWGnyUO31/4azPx9Fd/P482Gl+oVJELhmQ
         4jSqwCm04jceqZqXx7ZIDlc124H3kU9UGzGKbKQ0r9kZHRmSgCpFwDeWXGZJSZtX8T
         i62BfLpu0Uya4Uk6HTG2BvfShkSGvcgkGRaYS9oA=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221005130543eucas1p1aed6763fdecb50ca11125c7eec2cbbf0~bLhI6xuMy3238032380eucas1p14;
        Wed,  5 Oct 2022 13:05:43 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 1B.A2.29727.6218D336; Wed,  5
        Oct 2022 14:05:42 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20221005130542eucas1p1a50cb2c3ee56c7c6b3b78f9d4b191abf~bLhIInLdI3061230612eucas1p19;
        Wed,  5 Oct 2022 13:05:42 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221005130542eusmtrp2fa51b0c29199130127621c85d53fce3c~bLhIHmN630188401884eusmtrp2Y;
        Wed,  5 Oct 2022 13:05:42 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-4f-633d81261c13
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id BA.2D.10862.6218D336; Wed,  5
        Oct 2022 14:05:42 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221005130541eusmtip25243c5df6e3b8a7331bd5ea6df42850f~bLhHDpACD0498804988eusmtip2d;
        Wed,  5 Oct 2022 13:05:41 +0000 (GMT)
Message-ID: <207c1979-0da2-b05d-fead-6880ad956b90@samsung.com>
Date:   Wed, 5 Oct 2022 15:05:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v8 00/29] Rework the trip points creation
Content-Language: en-US
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        rui.zhang@intel.com,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org, rafael@kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <851008bf-145d-224c-87a8-cb6ec1e9addb@linaro.org>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZduznOV21Rttkg9/XrS3OPf7NYvFg3jY2
        i7W9R1ksvm+5zmQx77OsxaqpO1ks9r7eym6x6fE1VouJ+8+yW3T9WslscXnXHDaL2Uv6WSw+
        9x5htNj68h2TxcTbG9gtZpzfx2TR+WUWm8WxBWIWq/e8YLaY+2Uqs8WTh31sFntbLzI7iHnM
        un+WzWPFJ32PnbPusnss3vOSyWPTqk42jzvX9rB5bF5S77Hx3Q4mj/6/Bh59W1YxenzeJBfA
        HcVlk5Kak1mWWqRvl8CVsXLTSraCv/wVFze/YmpgbOPtYuTgkBAwkXg+T7SLkYtDSGAFo8Tz
        f59ZIZwvjBK7H75lh3A+M0rM2PSBsYuRE6zj4qNHLBCJ5YwSP859Z4ZwPjJKXF6yiR2kilfA
        TuLn2sdgNouAisSi582MEHFBiZMzn7CA2KICyRI/uw6wgdjCArYS7390gtUzC4hL3HoynwnE
        FhHQk2h838YEsoBZYAqbxOEVe1lBEmwChhJdb7vAmjmBlh3ZsAiqWV5i+9s5zBCnvuKUODHR
        FsJ2kZg/6S4ThC0s8er4FnYIW0bi/875YAskBNoZJRb8vg/lTGCUaHh+C+ppa4k7536xgYKM
        WUBTYv0ufUjoOUrc/+cPYfJJ3HgrCHECn8SkbdOZIcK8Eh1tQhAz1CRmHV8Ht/XghUvMExiV
        ZiGFyiwk389C8swshLULGFlWMYqnlhbnpqcWG+allusVJ+YWl+al6yXn525iBKbS0/+Of9rB
        OPfVR71DjEwcjIcYJTiYlUR4eU/aJAvxpiRWVqUW5ccXleakFh9ilOZgURLnZZuhlSwkkJ5Y
        kpqdmlqQWgSTZeLglGpgas1MywlXW6yRvWzhuUS/oxOTTppaP9/kmKzPFxEUopizT8O0wNm2
        aX9r6JKILwqnVqyUKhD7WbFlS/i74w+ubdT7fr/52CfZJ5mnd2wwYNVk7GH0/ZY3a8KfW3OU
        M9uvrT0nzXXI2Mjk7fxDiqLy5TGuC2JO9Zlf/nNecva3A2v9OZPmvLK5cHTdRvF93tXS4uEp
        fTmngzQ+p/AE6UysU/FdZVpdmm8xOyd1X36Pi8vDSUWR/gblZufs2EVN9Y93hU80fXYyKv+I
        YVPJ7v7+rcuTiqR2Lj+7Osbr7r6vaa0LS382yZ6Jeu6z5orKgje9XK95hftf1J0oVr5/5kWY
        NeuH+Km5FlqZKpWvjqxQYinOSDTUYi4qTgQA70iftBQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t/xe7pqjbbJBttb2SzOPf7NYvFg3jY2
        i7W9R1ksvm+5zmQx77OsxaqpO1ks9r7eym6x6fE1VouJ+8+yW3T9WslscXnXHDaL2Uv6WSw+
        9x5htNj68h2TxcTbG9gtZpzfx2TR+WUWm8WxBWIWq/e8YLaY+2Uqs8WTh31sFntbLzI7iHnM
        un+WzWPFJ32PnbPusnss3vOSyWPTqk42jzvX9rB5bF5S77Hx3Q4mj/6/Bh59W1YxenzeJBfA
        HaVnU5RfWpKqkJFfXGKrFG1oYaRnaGmhZ2RiqWdobB5rZWSqpG9nk5Kak1mWWqRvl6CXsXLT
        SraCv/wVFze/YmpgbOPtYuTkkBAwkbj46BFLFyMXh5DAUkaJlytb2CESMhInpzWwQtjCEn+u
        dbGB2EIC7xklZu8OA7F5Bewkfq59DFbPIqAiseh5MyNEXFDi5MwnLCC2qECyxMs/E8FqhAVs
        Jd7/6ASzmQXEJW49mc8EYosI6Ek0vm9jgohPY5P4/DkeYtdGJon3W+pBbDYBQ4mutxA3cALt
        PbJhEdQcM4murV2MELa8xPa3c5gnMArNQnLGLCTrZiFpmYWkZQEjyypGkdTS4tz03GIjveLE
        3OLSvHS95PzcTYzA1LHt2M8tOxhXvvqod4iRiYPxEKMEB7OSCC/vSZtkId6UxMqq1KL8+KLS
        nNTiQ4ymwLCYyCwlmpwPTF55JfGGZgamhiZmlgamlmbGSuK8ngUdiUIC6YklqdmpqQWpRTB9
        TBycUg1M1fHK5u17e/xmPNAx/RH0+cWjBb8WrNXuNq34YHCgtn/5TlP7D3sKTu25XGdRv+Bo
        oMPkE2zaJ5cdPzpr9inpX/6XOaK26YtPvS8ygaf5seqXe+0nVrnrNpe0+Z9e/SOpau82KdeZ
        J2Vkru5/EVpp7Cj1wkzmg0iIo6HeXPkwqU0PC9Iap8yJesKwfzqXW6GYzvcLrEL2N40WJrjP
        3szWtf2Uada+eyXyJi2z9Phn7N6RvLljdZqM9uFwg+K7eW41zayWv3UMdkV+n7np305rbdGb
        t7tCMuctC7JT2X7EV3mP2PRd+xP61F8/NJB9vf1I0+KwwILXh3j22pbOLnhya8YOsRa7yJzF
        cj45z6adV2Ipzkg01GIuKk4EAIdUMlKmAwAA
X-CMS-MailID: 20221005130542eucas1p1a50cb2c3ee56c7c6b3b78f9d4b191abf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20221003092704eucas1p2875c1f996dfd60a58f06cf986e02e8eb
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221003092704eucas1p2875c1f996dfd60a58f06cf986e02e8eb
References: <CGME20221003092704eucas1p2875c1f996dfd60a58f06cf986e02e8eb@eucas1p2.samsung.com>
        <20221003092602.1323944-1-daniel.lezcano@linaro.org>
        <8cdd1927-da38-c23e-fa75-384694724b1c@samsung.com>
        <c3258cb2-9a56-d048-5738-1132331a157d@linaro.org>
        <851008bf-145d-224c-87a8-cb6ec1e9addb@linaro.org>
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05.10.2022 14:37, Daniel Lezcano wrote:
>
> Hi Marek,
>
> On 03/10/2022 23:18, Daniel Lezcano wrote:
>
> [ ... ]
>
>>> I've tested this v8 patchset after fixing the issue with Exynos TMU 
>>> with
>>> https://lore.kernel.org/all/20221003132943.1383065-1-daniel.lezcano@linaro.org/ 
>>>
>>> patch and I got the following lockdep warning on all Exynos-based 
>>> boards:
>>>
>>>
>>> ======================================================
>>> WARNING: possible circular locking dependency detected
>>> 6.0.0-rc1-00083-ge5c9d117223e #12945 Not tainted
>>> ------------------------------------------------------
>>> swapper/0/1 is trying to acquire lock:
>>> c1ce66b0 (&data->lock#2){+.+.}-{3:3}, at: exynos_get_temp+0x3c/0xc8
>>>
>>> but task is already holding lock:
>>> c2979b94 (&tz->lock){+.+.}-{3:3}, at:
>>> thermal_zone_device_update.part.0+0x3c/0x528
>>>
>>> which lock already depends on the new lock.
>>
>> I'm wondering if the problem is not already there and related to 
>> data->lock ...
>>
>> Doesn't the thermal zone lock already prevent racy access to the data 
>> structure?
>>
>> Another question: if the sensor clock is disabled after reading it, 
>> how does the hardware update the temperature and detect the programed 
>> threshold is crossed?
>
> just a gentle ping, as the fix will depend on your answer ;)
>
Sorry, I've been busy with other stuff. I thought I will fix this once I 
find a bit of spare time.

IMHO the clock management is a bit over-engineered, as there is little 
(if any) benefit from such fine grade clock management. That clock is 
needed only for the AHB related part of the TMU (reading/writing the 
registers). The IRQ generation and temperature measurement is clocked 
from so called 'sclk' (special clock).

I also briefly looked at the code and the internal lock doesn't look to 
be really necessary assuming that the thermal core already serializes 
all the calls.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

