Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60776389BB
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 14:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbfFGMFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 08:05:33 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60763 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbfFGMFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 08:05:32 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190607120531euoutp01a10c0cecb49de73c3cac0f069c96781d~l6RcQtRkQ1975319753euoutp01-
        for <netdev@vger.kernel.org>; Fri,  7 Jun 2019 12:05:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190607120531euoutp01a10c0cecb49de73c3cac0f069c96781d~l6RcQtRkQ1975319753euoutp01-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559909131;
        bh=COHVb0UeeGmSgkAXwTwyqkaza60Y5M9a3mjtKEoAQBs=;
        h=Subject:To:From:Cc:Date:In-Reply-To:References:From;
        b=NHSK5GZuBqssg0L8cRZDRo3h+TWLUv/+H2t9HEmFCXI8/D2lV4uXUXKLGzayHJ/Dq
         c/FsKsN7rlu2pAMJ3z233w/ubv1qrLFu4J+cleFw+gMByJJgvIewOP4OV0jCFcwbvS
         afVwvERuwarYacS8vgzOOxp9dn5DryTrc/t5z8Zs=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190607120529eucas1p18edacacf6f19b60087a2f81430102464~l6RbAkG0l1333013330eucas1p1D;
        Fri,  7 Jun 2019 12:05:29 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 1C.3F.04325.9035AFC5; Fri,  7
        Jun 2019 13:05:29 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190607120528eucas1p182869712159a1c29305842fa596c5712~l6RaI-h5M1333013330eucas1p1C;
        Fri,  7 Jun 2019 12:05:28 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190607120528eusmtrp148aefe48cfbb0f4362fc9c7897a5f755~l6RZ5HnQ22024420244eusmtrp1g;
        Fri,  7 Jun 2019 12:05:28 +0000 (GMT)
X-AuditID: cbfec7f5-b75ff700000010e5-3c-5cfa53090139
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id AA.95.04146.8035AFC5; Fri,  7
        Jun 2019 13:05:28 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190607120527eusmtip2eee646333b640feea00b97666f02f5a6~l6RY5VO9u0977709777eusmtip2G;
        Fri,  7 Jun 2019 12:05:27 +0000 (GMT)
Subject: Re: [PATCH 3/8] drivers: (video|gpu): fix warning same module names
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Anders Roxell <anders.roxell@linaro.org>
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     marex@denx.de, stefan@agner.ch, airlied@linux.ie,
        shawnguo@kernel.org, s.hauer@pengutronix.de, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        a.hajda@samsung.com, mchehab@kernel.org, p.zabel@pengutronix.de,
        hkallweit1@gmail.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-media@vger.kernel.org
Message-ID: <4c9681c0-5ead-3e4c-584b-c4e98cd94480@samsung.com>
Date:   Fri, 7 Jun 2019 14:05:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190607075728.GE21222@phenom.ffwll.local>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SeUiTYRjv/a59Sluv6/DBImmVYofZQb1dUhT0RScEXUq18kPNKzZnF9SK
        qGmXZmUOyZXhRZhOcypZsUwNQcsiSlpzZGDZNFiaVsvcvkn+9+N3PL/ngYenlSVcEB+fnCpq
        ktWJKs6fqW4cap3vt+NXdITVFEw6ylpZcrn1BUU6rv+mSJvNSpMbji6O3HHYaJLXdo4hb/r7
        OPKrt0FG7vbdYom9/zkiA28MFDF/esuS5ivfWfK6Lo8jl8ofsuTb+TOIFJr/UKTRNIXYPjYz
        xG0xM6S7KpBUll2QkQJnDb0GhIKfH2mhquQ9Jdw2NjNC/YCJEWqNNplgLk3nhA9vH3GCZaCT
        FewXmyih8t5pobbGRQlX3RHClapSJLjM07cr9vqvihET49NEzYLIA/5xraaNR0oCjvW2VTN6
        ZFJkID8e8BIoGuxnM5A/r8TFCJ4MDyGPoMQ/EGTmz5YEFwK7o5gdTWRaHIwkFCGwVbb54k4E
        72qvMx7XRLwZGnr0lAdPwjuhuvKqdyyHV0DWhVLkCdA4i4G6LgvtEeQ4Eoxn7V7M4FngKnR7
        B03Gu8HeWM5KngB4kdvl5f0wgZ99PV4/jQOhoyufknAwWJx5tKcAcDcPH3odvr3Xw3BWDifh
        ifC1qUom4WnQkn2JkQJlCNyGbl/agqAo+68vsRKeNb0amcSPVITBg7oFEr0WCr47aQ8NWAHv
        nAHSEgq4Vp3jo+VgOK+U3CFQXljOjdZm1JbQmUhlHHOaccw5xjHnGP/3mhBTigJFnTYpVtQu
        ThaPhmvVSVpdcmz4oZQkMxp54Ja/Tf016PGfg1aEeaQaLxdkQ9FKVp2mPZ5kRcDTqknytJeD
        0Up5jPr4CVGTsl+jSxS1VjSVZ1SB8pPjOqOUOFadKiaI4hFRM6pSvF+QHm2qWJ2QcD93fqRL
        PvN38XD9Z5V+3Mujy/d9CV7PtJD2FKFuhrxzl6Lg8NKBvc9vdqhDsyMbp849eNu2LH966L4n
        ywbXLTz1MD4i6NuiPfE1Vl2fbv+anvT2dqwXuQ1PwwxbLlZETZiRWm+dmdugjHMbYMm1kHOn
        07cpovbMM59I2RqkYrRx6oVzaI1W/Q962XULvAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe89tZ9HquGa+SjeWZAgtj1P3GiZ9KU5QFHQh1LChp1k5Fzvb
        yL5kElqrvJBdHKtWlugKtWneMrSVty4aFqMsXZahYbbC0jKtNlfgtz/P//d74IGHxqV3yRB6
        f4aB12eo0+XUXOLx7/b+1fT2yaSIypow1FvRRaIzXZ0Y6i36haHuPieOzg0MUujqQB+OrN3H
        CfTiu4dCk58fitA1z0USub+3AjT+4gSGHO9dJOrI+0Ki541WCp2uukOiTznHACp1TGGozbYI
        9fV3EGi6zkGg4ZogVF2RK0Ilo/X4esiVTPTjXE35K4y7bOkguHvjNoJrsPSJOIf9JMW9cTVR
        XN34W5Jzn2rHuOrrR7mG+jGMy5+O4PJq7IAbcyzdNj9BEafXGQ388jSdYFgnT2RRpIKNRYrI
        qFgFq1TtWRsZLV8TH5fKp+838fo18XsVaV22TYfKAw5/7q4lsoBtvhmIachEwYK6AcIM5tJS
        5gaAltEKkRnQ3mIxbK80+ZmFcMplpvzMCIAu9wWRr1jIbIYPR7IwX5Yxu2BLoY30Q80AFnl8
        W8U0xayFhbl24CtwppCAY6UlM7aEiYeWbDfuywQT6p1PzwiBzG74xFNG+JkA2Fk8OJPFDIIT
        npEZHmfC4NTlnn85CPYOXsH8eRmsG7XiBUBqmaVbZimWWYpllmIDhB3IeKOg1WgFViGotYIx
        Q6NI0WkdwPs4tW0/q+tBz+3tTsDQQD5Psn7OzyQpqTYJmVongDQul0lMz34kSSWp6swjvF6X
        rDem84ITRHuPK8RDAlN03jfMMCSz0awKxbIqpUoZg+RBkhPM/SQpo1Eb+IM8f4jX//cwWhyS
        BTTfZItb7OPWd3EfNlxcpVFlL3m5szbm3aPpW1Xmpiji8MfzZa1VxVTwFLPt0XnJguzM3BXF
        By7FHOx1Goc6Kwu+NVo3PsC7ZFGBw2ef83k7kp1/tjS1D6FhZeJQcM5XQ9hqa4K1KBoFlrYe
        2LoyZV/4x6f5v17nN7tvfmHbTKGblXJCSFOz4bheUP8Fi3t/J04DAAA=
X-CMS-MailID: 20190607120528eucas1p182869712159a1c29305842fa596c5712
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190607075735epcas3p17dfbe45a2079b12f4e2268ee1b6086fe
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190607075735epcas3p17dfbe45a2079b12f4e2268ee1b6086fe
References: <20190606094712.23715-1-anders.roxell@linaro.org>
        <CGME20190607075735epcas3p17dfbe45a2079b12f4e2268ee1b6086fe@epcas3p1.samsung.com>
        <20190607075728.GE21222@phenom.ffwll.local>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/7/19 9:57 AM, Daniel Vetter wrote:
> On Thu, Jun 06, 2019 at 11:47:12AM +0200, Anders Roxell wrote:
>> When building with CONFIG_DRM_MXSFB and CONFIG_FB_MXS enabled as
>> loadable modules, we see the following warning:
>>
>> warning: same module names found:
>>   drivers/video/fbdev/mxsfb.ko
>>   drivers/gpu/drm/mxsfb/mxsfb.ko
>>
>> Rework so the names matches the config fragment.
>>
>> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> 
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> I'm assuming Bart will pick this one up for fbdev.

The DRM mxsfb has been a default for almost a year (since July
2018) and I've just applied "[PATCH] video: fbdev: mxsfb: Remove
driver" (https://marc.info/?l=dri-devel&m=155835758115686&w=2)
so it seems that this patch is not needed any longer (sorry!).

> -Daniel
> 
>> ---
>>  drivers/gpu/drm/mxsfb/Makefile | 4 ++--
>>  drivers/video/fbdev/Makefile   | 3 ++-
>>  2 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/mxsfb/Makefile b/drivers/gpu/drm/mxsfb/Makefile
>> index ff6e358088fa..5d49d7548e66 100644
>> --- a/drivers/gpu/drm/mxsfb/Makefile
>> +++ b/drivers/gpu/drm/mxsfb/Makefile
>> @@ -1,3 +1,3 @@
>>  # SPDX-License-Identifier: GPL-2.0-only
>> -mxsfb-y := mxsfb_drv.o mxsfb_crtc.o mxsfb_out.o
>> -obj-$(CONFIG_DRM_MXSFB)	+= mxsfb.o
>> +drm-mxsfb-y := mxsfb_drv.o mxsfb_crtc.o mxsfb_out.o
>> +obj-$(CONFIG_DRM_MXSFB)	+= drm-mxsfb.o
>> diff --git a/drivers/video/fbdev/Makefile b/drivers/video/fbdev/Makefile
>> index 655f2537cac1..7ee967525af2 100644
>> --- a/drivers/video/fbdev/Makefile
>> +++ b/drivers/video/fbdev/Makefile
>> @@ -131,7 +131,8 @@ obj-$(CONFIG_FB_VGA16)            += vga16fb.o
>>  obj-$(CONFIG_FB_OF)               += offb.o
>>  obj-$(CONFIG_FB_MX3)		  += mx3fb.o
>>  obj-$(CONFIG_FB_DA8XX)		  += da8xx-fb.o
>> -obj-$(CONFIG_FB_MXS)		  += mxsfb.o
>> +obj-$(CONFIG_FB_MXS)		  += fb-mxs.o
>> +fb-mxs-objs			  := mxsfb.o
>>  obj-$(CONFIG_FB_SSD1307)	  += ssd1307fb.o
>>  obj-$(CONFIG_FB_SIMPLE)           += simplefb.o
>>  
>> -- 
>> 2.20.1
Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
