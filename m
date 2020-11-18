Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1052B784F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgKRITF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:19:05 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34122 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgKRITF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 03:19:05 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201118081853euoutp02399fbe9d89bc8e081c2c2c9bbbd8847d~IjE3rFsgC0679306793euoutp02N
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:18:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201118081853euoutp02399fbe9d89bc8e081c2c2c9bbbd8847d~IjE3rFsgC0679306793euoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605687533;
        bh=3AVGejOWI+zfnZDxmo65S7C/BS7eNSduGs7tvM+vBQM=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=AswUwIlFtluyPpe328WhTmE9xu+W0zV0sQBDqUkcQXWMeMEBzocNfJ3HzX+B4YZ8z
         EZm0xq4x3tJkaCaSsKY8HEYvHJRI8rvY/NIE2pxSQhCl0W81nSTmL3hGF0ZRHbBFGT
         sIlwc0W5vJdO7gqduZsjHcSgZq5Kf5WnAyll24kU=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201118081848eucas1p190f13d67d8792baf8dcc71ee86879fb4~IjEy2Dazn0353103531eucas1p10;
        Wed, 18 Nov 2020 08:18:48 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 59.C6.44805.8E8D4BF5; Wed, 18
        Nov 2020 08:18:48 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201118081847eucas1p1cd6b364d763afa452b93e81899602153~IjEyVDAL33175531755eucas1p1w;
        Wed, 18 Nov 2020 08:18:47 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201118081847eusmtrp28b147f583bb586c8f3f3935cc0ae3993~IjEyUc8kZ3115231152eusmtrp20;
        Wed, 18 Nov 2020 08:18:47 +0000 (GMT)
X-AuditID: cbfec7f4-b4fff7000000af05-f2-5fb4d8e814b8
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 43.F2.21957.7E8D4BF5; Wed, 18
        Nov 2020 08:18:47 +0000 (GMT)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201118081847eusmtip16ba6845d94231838352a8bf48b3a6e83~IjEx5XQom2356323563eusmtip1l;
        Wed, 18 Nov 2020 08:18:47 +0000 (GMT)
Subject: Re: [PATCH net-next v2] r8153_ecm: avoid to be prior to r8152
 driver
To:     Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org
Cc:     nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <4261c50d-4bf0-e861-dc1a-1332165db0ef@samsung.com>
Date:   Wed, 18 Nov 2020 09:18:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <1394712342-15778-394-Taiwan-albertk@realtek.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42LZduznOd0XN7bEG2y7w2Ex7WAPo8XlXXPY
        LBYta2W2OLZAzOJL7yxWB1aPx283s3t83iQXwBTFZZOSmpNZllqkb5fAlfFi1hqWgr9CFYuX
        72NrYLzB38XIySEhYCJxd1EnexcjF4eQwApGiQUXfzNBOF8YJe6efcQG4XxmlLhyaRdQGQdY
        y+etehDx5YwSG2b9YAIZJSTwnlFiSY8JiC0s4C8x9dNPdhBbRMBOYvrLC4wgNrNAsMTUps8s
        IDabgKFE19suNhCbF6jm6Jp3YDUsAqoSa/dtB5spKpAksX3LdlaIGkGJkzOfgPVyAtXvXv+G
        BWKmvMT2t3OYIWxxiVtP5oN9ICGwg0Ni0aVPjBB/ukjMn/OVDcIWlnh1fAs7hC0j8X8nTEMz
        o8TDc2vZIZweRonLTTOguq0l7pz7xQbyPrOApsT6XfqQkHCUePU/DsLkk7jxVhDiBj6JSdum
        M0OEeSU62oQgZqhJzDq+Dm7rwQuXmCcwKs1C8tksJN/MQvLNLIS1CxhZVjGKp5YW56anFhvl
        pZbrFSfmFpfmpesl5+duYgQmk9P/jn/Zwbj81Ue9Q4xMHIyHGCU4mJVEeF1MNsYL8aYkVlal
        FuXHF5XmpBYfYpTmYFES503asiZeSCA9sSQ1OzW1ILUIJsvEwSnVwGR7zmaKxNNKp7Nsj4Ud
        F72aUbzLNsnGr8As/vufzZ4WMz8dyAvfK6qz23DCIqm+8mWblqyIcleeuC4kL/3VueZ/v/Sd
        /X08+yvDV+80OnE+y//H8fD+XfcvyL0qW/riblt4l3nhbkaNY4ckTuy4rpy7wq5+2qp3PZ1t
        bIoemW42DPpFhZ+DzZ0uzuCfo/VJe8mH/T/sX79MXRex3eXJ+rsnE3+npXLcZxM05OwWXuG6
        z2syo/98tYfKpYHP7vQ2ds79KLf6nKji7GVL72r261y4pbXvzc4XD3yPdr2MP3mwkn3CKtF7
        u4Rc4p7F+p60/tnyfr2M3l+2x1U7Z7TJRdgu7XvttqS/U9TUL+FNApMSS3FGoqEWc1FxIgA5
        HZwklQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t/xu7rPb2yJN7g8VcVi2sEeRovLu+aw
        WSxa1spscWyBmMWX3lmsDqwej99uZvf4vEkugClKz6Yov7QkVSEjv7jEVina0MJIz9DSQs/I
        xFLP0Ng81srIVEnfziYlNSezLLVI3y5BL+PFrDUsBX+FKhYv38fWwHiDv4uRg0NCwETi81a9
        LkYuDiGBpYwS+1b/YOpi5ASKy0icnNbACmELS/y51sUGUfSWUWLOpqeMIAlhAV+JtSt2s4PY
        IgJ2EtNfXmAEGcosECyx92UBRP1RRom2nyfAhrIJGEp0vQUZxMnBC1R/dM07sDksAqoSa/dt
        B6sRFUiSmHn8LDtEjaDEyZlPWEBsTqD63evfgNnMAmYS8zY/ZIaw5SW2v50DZYtL3Hoyn2kC
        o9AsJO2zkLTMQtIyC0nLAkaWVYwiqaXFuem5xYZ6xYm5xaV56XrJ+bmbGIHxs+3Yz807GOe9
        +qh3iJGJg/EQowQHs5IIr4vJxngh3pTEyqrUovz4otKc1OJDjKZA/0xklhJNzgdGcF5JvKGZ
        gamhiZmlgamlmbGSOO/WuWvihQTSE0tSs1NTC1KLYPqYODilGph8vY4ZPtp2I/yYx5vMkn/z
        /7XLil199Lls19sjVdMma05Jf23K9XOTUGOf8JcNGWevLDqc8qgn28+85Oq1HRuOx5pyTn24
        9phOW/O9j7P0D211PTlr5dyS808+vF9YqStf3h6xinHPFAdNffWQ8zFiL2euWL32pGVcwvI3
        x94YLj5tWqbutqnblWsWp3PLsuxb03Xa7Gd3rosXVg/udJv/07gn7JlYeeik/5rOM/asZWjs
        r+VelbKzbsHnTLuKw+a2Bubz1/AvjLGPj1nyef5Z6VoeVrNZHNpTly/YLrabe0IC61ux1DJn
        Pa9ghlkzaqR9w1WnP+z58fJ7vKy1QPqdZXflzveesXmrXucdfDhViaU4I9FQi7moOBEAqBCf
        aygDAAA=
X-CMS-MailID: 20201118081847eucas1p1cd6b364d763afa452b93e81899602153
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201118064440eucas1p27610e4adabc4f77b985b6e8271a1dbc3
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201118064440eucas1p27610e4adabc4f77b985b6e8271a1dbc3
References: <1394712342-15778-393-Taiwan-albertk@realtek.com>
        <CGME20201118064440eucas1p27610e4adabc4f77b985b6e8271a1dbc3@eucas1p2.samsung.com>
        <1394712342-15778-394-Taiwan-albertk@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 18.11.2020 07:43, Hayes Wang wrote:
> Avoid r8153_ecm is compiled as built-in, if r8152 driver is compiled
> as modules. Otherwise, the r8153_ecm would be used, even though the
> device is supported by r8152 driver.
>
> Fixes: c1aedf015ebd ("net/usb/r8153_ecm: support ECM mode for RTL8153")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Yes, this looks like a proper fix.

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
> v2:
> Use a separate Kconfig entry for r8153_ecm with proper dependencies.
>
>   drivers/net/usb/Kconfig  | 9 +++++++++
>   drivers/net/usb/Makefile | 3 ++-
>   2 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
> index b46993d5f997..1e3719028780 100644
> --- a/drivers/net/usb/Kconfig
> +++ b/drivers/net/usb/Kconfig
> @@ -628,4 +628,13 @@ config USB_NET_AQC111
>   	  This driver should work with at least the following devices:
>   	  * Aquantia AQtion USB to 5GbE
>   
> +config USB_RTL8153_ECM
> +	tristate "RTL8153 ECM support"
> +	depends on USB_NET_CDCETHER && (USB_RTL8152 || USB_RTL8152=n)
> +	default y
> +	help
> +	  This option supports ECM mode for RTL8153 ethernet adapter, when
> +	  CONFIG_USB_RTL8152 is not set, or the RTL8153 device is not
> +	  supported by r8152 driver.
> +
>   endif # USB_NET_DRIVERS
> diff --git a/drivers/net/usb/Makefile b/drivers/net/usb/Makefile
> index 99381e6bea78..4964f7b326fb 100644
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
> @@ -41,3 +41,4 @@ obj-$(CONFIG_USB_NET_QMI_WWAN)	+= qmi_wwan.o
>   obj-$(CONFIG_USB_NET_CDC_MBIM)	+= cdc_mbim.o
>   obj-$(CONFIG_USB_NET_CH9200)	+= ch9200.o
>   obj-$(CONFIG_USB_NET_AQC111)	+= aqc111.o
> +obj-$(CONFIG_USB_RTL8153_ECM)	+= r8153_ecm.o

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

