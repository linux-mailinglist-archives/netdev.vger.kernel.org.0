Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228D82B4043
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgKPJtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:49:32 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43141 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728480AbgKPJtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:49:31 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201116094919euoutp02f17816b2bddfca7692c33b58a2c29546~H9BQxMDWM3218632186euoutp021
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 09:49:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201116094919euoutp02f17816b2bddfca7692c33b58a2c29546~H9BQxMDWM3218632186euoutp021
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605520159;
        bh=UwB7hd06BgY+vzRM1GIKrF0SRX9dkSTSNo0qT/NjFac=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=OIyzl28V/ATOZh46GmXo0W+4xPgOGohLahQm14D532JT3BvZ0e+Fn3QUq7f4tLRaT
         76VyIEGyCX+WYnfFsNK49diyuwPkQwMxsY22pTNaPcMbEOeGUs2psATcPlccWmCxtG
         eEPh+DBI1corKHwMYBIDSEfBArMSXKEsR0iYJvBo=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201116094312eucas1p17172ee21930f918bbba8e136c4477062~H876otzxD2126921269eucas1p1o;
        Mon, 16 Nov 2020 09:43:12 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id AF.F1.27958.E7942BF5; Mon, 16
        Nov 2020 09:42:22 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201116091814eucas1p26556359eb8ecd5309657baf1d876888d~H8mIDeDxT1628416284eucas1p29;
        Mon, 16 Nov 2020 09:18:13 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201116091813eusmtrp1abe891aa09f56f1dd6f8581ca9bf18aa~H8mHHTeDy1967619676eusmtrp1G;
        Mon, 16 Nov 2020 09:18:13 +0000 (GMT)
X-AuditID: cbfec7f2-49bb5a8000006d36-a2-5fb2497ed355
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 99.CF.16282.5D342BF5; Mon, 16
        Nov 2020 09:18:13 +0000 (GMT)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201116091813eusmtip1bb50ddc74149e7a0b0ac3fef69280e84~H8mGvQcTV0475404754eusmtip1X;
        Mon, 16 Nov 2020 09:18:13 +0000 (GMT)
Subject: Re: [PATCH net-next] r8153_ecm: avoid to be prior to r8152 driver
To:     Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org
Cc:     nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <5f3db229-940c-c8ed-257b-0b4b3dd2afbb@samsung.com>
Date:   Mon, 16 Nov 2020 10:18:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <1394712342-15778-393-Taiwan-albertk@realtek.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42LZduzned0pnpviDdruGVtMO9jDaHF51xw2
        i0XLWpktji0Qs/jSO4vVgdXj8dvN7B6fN8kFMEVx2aSk5mSWpRbp2yVwZSzd/Iep4C5fxa3u
        zSwNjBt4uhg5OSQETCQuLnvI3MXIxSEksIJRYt6O50wgCSGBL4wS19bEQiQ+M0r8+veVGaaj
        qWkxG0RiOaPEqhmbmSCc94wSCyfeYwGpEhbwktj3dBNYh4iAncT0lxcYQWxmgWCJqU2fwWrY
        BAwlut52sYHYvEA1ZxZNYQexWQRUJdrOtLKC2KICSRLbt2xnhagRlDg58wlYLydQ/bLNe9kg
        ZspLbH87hxnCFpe49WQ+2EESAms5JC7/fMQIcbaLxINL89kgbGGJV8e3sEPYMhKnJ/ewQDQ0
        M0o8PLeWHcLpYZS43DQDqtta4s65X0DdHEArNCXW79KHCDtK7Dq/mxUkLCHAJ3HjrSDEEXwS
        k7ZNZ4YI80p0tAlBVKtJzDq+Dm7twQuXmCcwKs1C8tosJO/MQvLOLIS9CxhZVjGKp5YW56an
        FhvmpZbrFSfmFpfmpesl5+duYgQmlNP/jn/awTj31Ue9Q4xMHIyHGCU4mJVEeF1MNsYL8aYk
        VlalFuXHF5XmpBYfYpTmYFES5101e028kEB6YklqdmpqQWoRTJaJg1OqgSnF0P/uokX7T7Qx
        HBYOL1t8Z2Hq5M1xG+Slws/2JVxIEjrsGXqG0eTqkn63tCNXe+sZVx56sGPFzM23/VsU79zf
        miBYnbviqH5wqxYDf6HSq3NaPTL2RzN2nJPUf9J5NeBKzr6srjTHSQZPX1lcSLdWWztR5ESc
        39QTRpYHlSbF3pf8tS757crUrhtr5xR4/JJeYee8+OVbrwMO1THOjyc++m9yM86G/cDUQkO1
        xBunZPXz5hsoifxdt2PFlWd9pof3pt2QErP9wiw758/f1frf1+rd3X2o0Wrz2TbrkBtaLMfT
        Kh9Vc3C+2JJYNj+n/NXjnzaXPt/hDP/7oZH9J2P//Ud3739Ysm33ZdaipxsilViKMxINtZiL
        ihMB8/fWU5cDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t/xu7pXnTfFG3xfbmox7WAPo8XlXXPY
        LBYta2W2OLZAzOJL7yxWB1aPx283s3t83iQXwBSlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hpoWdk
        YqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl7F08x+mgrt8Fbe6N7M0MG7g6WLk5JAQMJFoalrM
        1sXIxSEksJRR4lLbdmaIhIzEyWkNrBC2sMSfa11QRW8ZJZZ/3QFWJCzgJbHv6SYwW0TATmL6
        ywuMXYwcHMwCwRJ7XxZA1B9jlJi3+RzYIDYBQ4mutyCDODl4gerPLJrCDmKzCKhKtJ1pBasR
        FUiSmHn8LDtEjaDEyZlPWEBsTqD6ZZv3gvUyC5gBzXzIDGHLS2x/OwfKFpe49WQ+0wRGoVlI
        2mchaZmFpGUWkpYFjCyrGEVSS4tz03OLjfSKE3OLS/PS9ZLzczcxAiNo27GfW3Ywrnz1Ue8Q
        IxMH4yFGCQ5mJRFeF5ON8UK8KYmVValF+fFFpTmpxYcYTYH+mcgsJZqcD4zhvJJ4QzMDU0MT
        M0sDU0szYyVxXpMja+KFBNITS1KzU1MLUotg+pg4OKUamCSNWad4RD5PXBObd1HtM8usLX27
        L9dc7N/v94l5T3rpxO03K/VlpP3iXz0+ZCZ20FlG2bOw1TVxftRy+4k1UwKKeR6Eai4tSbKK
        //vr16+nD45Gr33lka3sy/I83viDeojM8nl3GLSMO8q3s81NPeZlKHDTZltab2fcojlamVda
        GUzNtI/zCyUe2dwqu2HOga3xd0IE+387fzm7+NytUMPF4pb8z1J3non/eFCx3qJ9++HAzF1n
        rn5xFM/5wNFXojf7crvfmu59J7/Y92f52Xv0Te56dLvf43iORU/n89/t6WoT760/U/Nhu/La
        SVLCK9gbzk2cHrCwdQX/nKRA0YAJIfZ2WhEeeQyV669cUmIpzkg01GIuKk4EAAZ/iWYpAwAA
X-CMS-MailID: 20201116091814eucas1p26556359eb8ecd5309657baf1d876888d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201116065317eucas1p2a2d141857bbdd6b4998dd11937d52f56
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201116065317eucas1p2a2d141857bbdd6b4998dd11937d52f56
References: <7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsung.com>
        <CGME20201116065317eucas1p2a2d141857bbdd6b4998dd11937d52f56@eucas1p2.samsung.com>
        <1394712342-15778-393-Taiwan-albertk@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 16.11.2020 07:52, Hayes Wang wrote:
> Avoid r8153_ecm is compiled as built-in, if r8152 driver is compiled
> as modules. Otherwise, the r8153_ecm would be used, even though the
> device is supported by r8152 driver.
>
> Fixes: c1aedf015ebd ("net/usb/r8153_ecm: support ECM mode for RTL8153")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Yes, this fixes this issue, although I would prefer a separate Kconfig 
entry for r8153_ecm with proper dependencies instead of this ifdefs in 
Makefile.

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/net/usb/Makefile | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/usb/Makefile b/drivers/net/usb/Makefile
> index 99381e6bea78..98f4c100955e 100644
> --- a/drivers/net/usb/Makefile
> +++ b/drivers/net/usb/Makefile
> @@ -13,7 +13,7 @@ obj-$(CONFIG_USB_LAN78XX)	+= lan78xx.o
>   obj-$(CONFIG_USB_NET_AX8817X)	+= asix.o
>   asix-y := asix_devices.o asix_common.o ax88172a.o
>   obj-$(CONFIG_USB_NET_AX88179_178A)      += ax88179_178a.o
> -obj-$(CONFIG_USB_NET_CDCETHER)	+= cdc_ether.o r8153_ecm.o
> +obj-$(CONFIG_USB_NET_CDCETHER)	+= cdc_ether.o
>   obj-$(CONFIG_USB_NET_CDC_EEM)	+= cdc_eem.o
>   obj-$(CONFIG_USB_NET_DM9601)	+= dm9601.o
>   obj-$(CONFIG_USB_NET_SR9700)	+= sr9700.o
> @@ -41,3 +41,11 @@ obj-$(CONFIG_USB_NET_QMI_WWAN)	+= qmi_wwan.o
>   obj-$(CONFIG_USB_NET_CDC_MBIM)	+= cdc_mbim.o
>   obj-$(CONFIG_USB_NET_CH9200)	+= ch9200.o
>   obj-$(CONFIG_USB_NET_AQC111)	+= aqc111.o
> +
> +ifdef CONFIG_USB_NET_CDCETHER
> +ifeq ($(CONFIG_USB_RTL8152), m)
> +obj-$(CONFIG_USB_RTL8152)	+= r8153_ecm.o
> +else
> +obj-$(CONFIG_USB_NET_CDCETHER)	+= r8153_ecm.o
> +endif
> +endif

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

