Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7017F45E7C0
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 07:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344020AbhKZGRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 01:17:09 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28817 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhKZGPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 01:15:08 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211126061154epoutp04894fdf571fccae1237e2a01caafedfed~7A9fO0LJ30856808568epoutp04a
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 06:11:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211126061154epoutp04894fdf571fccae1237e2a01caafedfed~7A9fO0LJ30856808568epoutp04a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1637907114;
        bh=bexQxcXmimFYvXFLHmG7q6SN3eyBbfy/oH937spvRxc=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=EEz50I8ofcLnYgSCf9WFUq2c2r3Hncx0GIDy8j4RSOBdVgp9CeA0zgPlyPBxXhKgH
         tdfG9gG0mL7YOozQL5WnWF5We98q/tzt6arRRuKZxi80JnR6011rdx2DQ/Iub+kL59
         n2eioAGU77VdckNzRRCfGzUKbe4QtBL8e/z/8kt0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20211126061154epcas2p4848b450e9c78226c0785da02d0965d48~7A9e52op71244612446epcas2p4F;
        Fri, 26 Nov 2021 06:11:54 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.100]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4J0ksf6hhvz4x9QK; Fri, 26 Nov
        2021 06:11:50 +0000 (GMT)
X-AuditID: b6c32a46-a0fff70000002722-bb-61a07aa6a0bf
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E4.7B.10018.6AA70A16; Fri, 26 Nov 2021 15:11:50 +0900 (KST)
Mime-Version: 1.0
Subject: Re: [PATCH] nfc: virtual_ncidev: change default device permissions
Reply-To: bongsu.jeon@samsung.com
Sender: =?UTF-8?B?7KCE67SJ7IiY?= <bongsu.jeon@samsung.com>
From:   =?UTF-8?B?7KCE67SJ7IiY?= <bongsu.jeon@samsung.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "krzysztof.kozlowski@canonical.com" 
        <krzysztof.kozlowski@canonical.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20211125141457.716921-1-cascardo@canonical.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20211126061150epcms2p2e7c41a092ce1c6162e9ca0e1cabb69bd@epcms2p2>
Date:   Fri, 26 Nov 2021 15:11:50 +0900
X-CMS-MailID: 20211126061150epcms2p2e7c41a092ce1c6162e9ca0e1cabb69bd
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGKsWRmVeSWpSXmKPExsWy7bCmue6yqgWJBv826Fq8n9zObLHx7Q8m
        i8u75rBZHFsg5sDiMauhl83j8ya5AKaobJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11D
        SwtzJYW8xNxUWyUXnwBdt8wcoD1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnALz
        Ar3ixNzi0rx0vbzUEitDAwMjU6DChOyMJc2RBT84Kh43XGFrYOxg72Lk5JAQMJG48Os0kM3F
        ISSwg1Fi2+6ZLF2MHBy8AoISf3cIg9QIC3hLPD7byghiCwkoSvzvOMcGUiIsYCUx5xUzSJhN
        wELibeMqsJEiAvkS0w4uYwEZySzQwyhxa91hNohdvBIz2p+yQNjSEtuXbwWbySlgK3GyZTZU
        jYbEj2W9zBC2qMTN1W/ZYez3x+YzQtgiEq33zkLVCEo8+LkbKi4l8eBeN1S8XuL05sdgR0iA
        HLH4y3moBfoSU1rmsILYvAK+Er+3bgJrYBFQlXjwcT/UIBeJ3asegh3KLCAvsf3tHGaQh5kF
        NCXW79IHMSUElCWO3IKq4JPoOPyXHebFHfOeMEHYqhK9zV+YYN6dPLsFarqHxJE1D9knMCrO
        QgT0LCS7ZiHsWsDIvIpRLLWgODc9tdiowAgetcn5uZsYwQlOy20H45S3H/QOMTJxMB5ilOBg
        VhLhdQ6cnyjEm5JYWZValB9fVJqTWnyI0RToy4nMUqLJ+cAUm1cSb2hiaWBiZmZobmRqYK4k
        zvvBf3qikEB6YklqdmpqQWoRTB8TB6dUA5PM2YMyVnOzVk1S1wl9V9jUkPLpzospDKothqlM
        75dW+oR/VXMoY7pV9GPaDmHxuJfN8btUPG6xu9vc3MO/UDfKiWNx9A/2lpcmClnyk6Y9Wzg9
        7MNi3buPlx48PHmH9Z+SvRt6GM9nH8ha1GrspGW4sZjh56KIg3brn2m9/d+2qsmt2CLtQ9Dl
        LemTFre8mNMZel54rl3noUrNG1ttWs1FGlvX7nm4Qrj2bsLKFQq3H804qXTu7u2bptwXb1pO
        t11S+tIwetvmhNfzz05jFi9zm87TmPuN1c5QO6PPbv6RwwJFh/8an6mLikh6+jwtT0Fe7tyf
        a9zBRw9XJ3VFbRdxnhLI+rNjzpN+433PywWUWIozEg21mIuKEwGKtDK3+QMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211125141522epcas2p21d45e3406fe76bdb17048553f8681af9
References: <20211125141457.716921-1-cascardo@canonical.com>
        <CGME20211125141522epcas2p21d45e3406fe76bdb17048553f8681af9@epcms2p2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 On 25/11/2021 15:14, Thadeu Lima de Souza Cascardo wrote:
> Device permissions is S_IALLUGO, with many unnecessary bits. Remove them
> and also remove read and write permissions from group and others.
> 
> Before the change:
> crwsrwsrwt    1 0        0          10, 125 Nov 25 13:59 /dev/virtual_nci
> 
> After the change:
> crw-------    1 0        0          10, 125 Nov 25 14:05 /dev/virtual_nci
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> ---
>  drivers/nfc/virtual_ncidev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
> index 221fa3bb8705..f577449e4935 100644
--- a/drivers/nfc/virtual_ncidev.c
> +++ b/drivers/nfc/virtual_ncidev.c
> @@ -202,7 +202,7 @@ static int __init virtual_ncidev_init(void)
> 	 miscdev.minor = MISC_DYNAMIC_MINOR;
> 	 miscdev.name = "virtual_nci";
> 	 miscdev.fops = &virtual_ncidev_fops;
> -	 miscdev.mode = S_IALLUGO;
> +	 miscdev.mode = 0600;
> 
> 	 return misc_register(&miscdev);
> }
> -- 

Reviewed-by: Bongsu Jeon <bongsu.jeon@samsung.com>


Thanks.
