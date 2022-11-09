Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4606226C4
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 10:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiKIJW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 04:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiKIJWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 04:22:25 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4BC1839D
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 01:22:23 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221109092222epoutp01905cb6765f1ed5b86011f1dda6cb74ff~l4DHs6C5E2244622446epoutp014
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 09:22:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221109092222epoutp01905cb6765f1ed5b86011f1dda6cb74ff~l4DHs6C5E2244622446epoutp014
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667985742;
        bh=0Fp8gjhjNu8/y7GV683SkiOwYjglOgKKa34wixxzrp4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=tmTqsJ63mb5mNRjq11zCjWVcvBYQkF/G7/9YhvvBuaiNhiMATlPMirqV11LdNNRgQ
         /jtYOhHa+wcGeuO7uLjEUa+KoP5FyzgIBRHkWsaGpvmGDlTIGP+PJEp/Hxzy1pQXGq
         tCrsOCraIcLpMJ8nTLxDPXOclGavTiG9W48zSOrU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221109092220epcas5p1dfab955ed2cc60897f646c98fe8ae8ee~l4DGqwDaB2787227872epcas5p19;
        Wed,  9 Nov 2022 09:22:20 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4N6fcp31qlz4x9Q3; Wed,  9 Nov
        2022 09:22:18 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B5.0C.01710.8417B636; Wed,  9 Nov 2022 18:22:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221109091623epcas5p1023143581849a8799650b86f40e65787~l395gfqF00292802928epcas5p1s;
        Wed,  9 Nov 2022 09:16:23 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221109091623epsmtrp1c8e3337edbf2c8a713017eab6ac631a3~l395fMr7S1307013070epsmtrp1H;
        Wed,  9 Nov 2022 09:16:23 +0000 (GMT)
X-AuditID: b6c32a49-c9ffa700000006ae-54-636b714802b1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        25.71.18644.7EF6B636; Wed,  9 Nov 2022 18:16:23 +0900 (KST)
Received: from FDSFTE314 (unknown [107.122.81.85]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20221109091620epsmtip236bd598509b7313213f3c437c7abb9cc~l392jyR2q2012520125epsmtip2A;
        Wed,  9 Nov 2022 09:16:19 +0000 (GMT)
From:   "Vivek Yadav" <vivek.2311@samsung.com>
To:     "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc:     <rcsekar@samsung.com>, <wg@grandegger.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pankaj.dubey@samsung.com>, <ravi.patel@samsung.com>,
        <alim.akhtar@samsung.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Sriranjani P'" <sriranjani.p@samsung.com>
In-Reply-To: <20221025074459.z7utljgnexqnohir@pengutronix.de>
Subject: RE: [PATCH 5/7] arm64: dts: fsd: Add MCAN device node
Date:   Wed, 9 Nov 2022 14:46:18 +0530
Message-ID: <006a01d8f41b$efae1fd0$cf0a5f70$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJD6JMFT7t8BSDsfE8Wj4Sh/mZZ1gIfGw/mAff9b8ECH8qDTK0ur0Lw
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmlq5HYXayweOdUhYP5m1js5hzvoXF
        4umxR+wWF7b1sVqs+j6V2eLyrjlsFusXTWGxOLZAzOLb6TeMFou2fmG3ePhhD7vFrAs7WC1u
        v1nHarH03k5WBz6PLStvMnks2FTq8fHSbUaPTas62Tz6/xp4vN93lc2jb8sqRo/Pm+QCOKKy
        bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOArlZSKEvM
        KQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGds
        3nOGrWACd8X3M03MDYzdnF2MnBwSAiYSVw/uYu5i5OIQEtjNKPFkyXtWCOcTo8Tb7Z0sEM5n
        RombL/+zwLTs3r+aDSKxi1Gib08vE4TznFFi+Y/XTCBVbAI6Es2T/zKC2CICehK/JywCK2IW
        eMwk0Xv1MBtIglPAVqL1XhNYg7CAncTNvsOsIDaLgIpEw/b/zCA2r4ClxJmT71ggbEGJkzOf
        gNnMAvIS29/OYYY4SUHi59NlrBDL3CTatu9ngqgRlzj6swfsOwmBOxwSC54+ZodocJG4vrAR
        6h9hiVfHt0DFpSRe9rdB2ckSO/51skLYGRILJu5hhLDtJQ5cmQPUywG0QFNi/S59iLCsxNRT
        66D28kn0/n7CBBHnldgxD8ZWkXjxeQIrSCvIqt5zwhMYlWYh+WwWks9mIflgFsKyBYwsqxgl
        UwuKc9NTi00LDPNSy+Exnpyfu4kRnKq1PHcw3n3wQe8QIxMH4yFGCQ5mJRFebo3sZCHelMTK
        qtSi/Pii0pzU4kOMpsDgnsgsJZqcD8wWeSXxhiaWBiZmZmYmlsZmhkrivItnaCULCaQnlqRm
        p6YWpBbB9DFxcEo1MAkHyz2338IpN7vwcqb8jYf/l8UfFfn33EqGIXYLz8nAKb0xfOapRnIh
        WpUzfZ4tuqH7zu3x0cUTC7jFu9kkBYOu7HWec6pvWbBrpUHH8oYry/wSVulOivjT6LuJ0XvR
        yt1Fv5LXnNvd4dgj0JElw3qceduqxtnFwlYnpWY4Hdlgl9t71tr9xlyBkK6WGdrPsgx2if8R
        O3Ci+sH9nZF33x69x+158uy7gmvsz4WTnxk+vdHDovx1ThT7hWCd3GY5vU4JjjWXawOanikL
        9Z2b7Ku7SMAkt53PzTZvR55HQNdrx+NBLxzkBBed7kxWdvkUv3yGSfojkaWqsowx7l6LFJkf
        Nf/bp/9l58ZAZg8zJZbijERDLeai4kQAuadMq14EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWy7bCSvO7z/OxkgzU32S0ezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFrc
        frOO1WLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERx
        2aSk5mSWpRbp2yVwZWzec4atYAJ3xfczTcwNjN2cXYycHBICJhK7969mA7GFBHYwShzsNISI
        S0lMOfOSBcIWllj57zl7FyMXUM1TRomX/74ygyTYBHQkmif/ZQSxRQT0JH5PWMQEUsQs8JFJ
        4s/nRqiOd4wS69bsABvFKWAr0XqviQnEFhawk7jZd5gVxGYRUJFo2P4fbCqvgKXEmZPvWCBs
        QYmTM5+A2cwC2hJPbz6FsuUltr+dwwxxnoLEz6fLWCGucJNo276fCaJGXOLozx7mCYzCs5CM
        moVk1Cwko2YhaVnAyLKKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4XrW0djDuWfVB
        7xAjEwfjIUYJDmYlEV5ujexkId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqem
        FqQWwWSZODilGpiU2Xe8fB6m6B1+L//hmTUtNxZFxDnlhU6o2mZs9UDuzfFjTz9ubXyul1if
        3n59vrH4+1NsKdcdnjtv1Tbd0znF3Cq3Vn35tGclbubKB3OsJadrM5t0dW85dMD6ptcHm1wV
        PcV/Ln16TY+OWcx6YnzmX8G02RGBvA1pU+/9aExvk0voUfoqmvJYd/2FHLm+inRBG36BX0kX
        e3iVH60tWTOz8fkevraXJbkLJ8Z+OrZVZ+nxlG/8hW0JzrxrZ6cYTNKZMaHwaOGChZ6lUXwX
        XOdvcT98+NW3wIm7Zs2S/2e9W+OwdnOOjprOw++JSyRMGCbff1HHFc40vfnuEb7MBmO2jPdP
        Mxfma+twSN1WWa3EUpyRaKjFXFScCABaV9DaRgMAAA==
X-CMS-MailID: 20221109091623epcas5p1023143581849a8799650b86f40e65787
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021102635epcas5p33623e6b6ed02d3fb663da9ec253585ad
References: <20221021095833.62406-1-vivek.2311@samsung.com>
        <CGME20221021102635epcas5p33623e6b6ed02d3fb663da9ec253585ad@epcas5p3.samsung.com>
        <20221021095833.62406-6-vivek.2311@samsung.com>
        <20221025074459.z7utljgnexqnohir@pengutronix.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Marc Kleine-Budde <mkl@pengutronix.de>
> Sent: 25 October 2022 13:15
> To: Vivek Yadav <vivek.2311@samsung.com>
> Cc: rcsekar@samsung.com; wg@grandegger.com; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> pankaj.dubey@samsung.com; ravi.patel@samsung.com;
> alim.akhtar@samsung.com; linux-can@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sriranjani P
> <sriranjani.p@samsung.com>
> Subject: Re: [PATCH 5/7] arm64: dts: fsd: Add MCAN device node
> 
> On 21.10.2022 15:28:31, Vivek Yadav wrote:
> > Add MCAN device node and enable the same for FSD platform.
> > This also adds the required pin configuration for the same.
> >
> > Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
> > Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
> 
> Please add the DT people on Cc.
Okay, I will add them in the next patch series.
> 
> Marc
> 
Thanks for the review.
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   |
> https://protect2.fireeye.com/v1/url?k=6c1d2429-0d96311f-6c1caf66-
> 000babff9b5d-435a1e79c4c5ee61&q=1&e=74fb5a49-eb28-4786-8c1d-
> 9aa91f25ec04&u=https%3A%2F%2Fwww.pengutronix.de%2F  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

