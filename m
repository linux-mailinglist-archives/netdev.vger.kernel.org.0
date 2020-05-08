Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6D41CA424
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 08:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgEHGih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 02:38:37 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57004 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgEHGih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 02:38:37 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200508063835euoutp01a1519931748f32073d5ce4f821c11da9~M_j6r1eZR2859928599euoutp01x
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 06:38:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200508063835euoutp01a1519931748f32073d5ce4f821c11da9~M_j6r1eZR2859928599euoutp01x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1588919915;
        bh=n6h/PRBXetIl0W7Qpfk7CQDTFFnfUja/KhnLbfFnF2s=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=qcOAR3c8ao7bEqCS2FI1eMo7E9PQdSQX+Z8h8lGzUbtH+XzN5BBtnCP+yQ2Lnj2WP
         HohzBwuKotyMxfaoAcbtYx+euMd21xhukTnkcwLfDTO5aEt6DqqQjPoy+5FJBGitKc
         Lhd6NhF+joPtewIpaFQ/3ssxrgFIu/s7BNlGw6XE=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200508063835eucas1p1db8218f33b12e03796d6952d05b7dc36~M_j6Tqm8Q1585315853eucas1p1v;
        Fri,  8 May 2020 06:38:35 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id A4.95.61286.B6EF4BE5; Fri,  8
        May 2020 07:38:35 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200508063834eucas1p28a0442b9e5433ecdc5c56cbd19dd313c~M_j6Cqkew2820928209eucas1p2L;
        Fri,  8 May 2020 06:38:34 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200508063834eusmtrp2885b36ff6c06ef71e7637b52daa3a74f~M_j6CAr6P1393113931eusmtrp2A;
        Fri,  8 May 2020 06:38:34 +0000 (GMT)
X-AuditID: cbfec7f2-f0bff7000001ef66-71-5eb4fe6b8ece
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id EB.F9.08375.A6EF4BE5; Fri,  8
        May 2020 07:38:34 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200508063834eusmtip1d337920e3cee288cc2d1720184039d23~M_j5k8aNp1444914449eusmtip1e;
        Fri,  8 May 2020 06:38:34 +0000 (GMT)
Subject: Re: [PATCH net v2] net: bcmgenet: Clear ID_MODE_DIS in
 EXT_RGMII_OOB_CTRL when not needed
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Wahren <wahrenst@gmx.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <bff2b7b6-22c8-7624-d31b-5b2a9425b11c@samsung.com>
Date:   Fri, 8 May 2020 08:38:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <09f9fdff-867f-687f-e5af-a4f82a75e105@gmail.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsWy7djP87rZ/7bEGaxcymOxtvcoi8Wc8y0s
        Fr/eHWG3uLxrDpvFsQViFttmLWez+DxpCqPF8ROdzA4cHrPun2Xz2LLyJpPHzll32T0Wb9rP
        5rH5dLXH501yAWxRXDYpqTmZZalF+nYJXBlTtvIUbBOtuHBqCWsD417BLkZODgkBE4k9C7rY
        uxi5OIQEVjBK9E7fA+V8YZQ4OukbI4TzmVFi461D7DAtN29uhEosZ5S4de0MVMt7RomlX84z
        g1QJC6RIzOj/yAySEBE4wygx4/ItsHZmgUSJ/6v/sILYbAKGEl1vu9hAbF4BO4nDW84zgdgs
        AioSFy4tAGrm4BAViJWYfi0EokRQ4uTMJywgYU4BW4mmDmeIifIS29/OYYawxSVuPZnPBLJW
        QmAfu8Tcl7dYIK52kZjyajoThC0s8er4FqhvZCT+74RpaGaUeHhuLTuE08MocblpBiNElbXE
        nXO/2EA2MwtoSqzfpQ8RdpTof7SSHSQsIcAnceOtIMQRfBKTtk1nhgjzSnS0CUFUq0nMOr4O
        bu3BC5eYJzAqzULy2Swk78xC8s4shL0LGFlWMYqnlhbnpqcWG+allusVJ+YWl+al6yXn525i
        BKak0/+Of9rB+PVS0iFGAQ5GJR5ei4+b44RYE8uKK3MPMUpwMCuJ8E6s2BInxJuSWFmVWpQf
        X1Sak1p8iFGag0VJnNd40ctYIYH0xJLU7NTUgtQimCwTB6dUA6OCct3SB4rNB/Yt+ZAdttqw
        5PNMzX2uNy3jvVb9m9XubLvm2bK4nrqFvh7FU/Z8FZ8lqrFxaWlnid2X5zmqcxumZsjfuqxS
        oBrekX3Bcqllv0Jp2v7qPLUCrvKOLeldbCXtS5/crPXe+N7yRGuo0nzL28qOEkq3stQeO9gZ
        bgp43RT5/NT8W0osxRmJhlrMRcWJAMsxfCdFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t/xu7pZ/7bEGcyYY26xtvcoi8Wc8y0s
        Fr/eHWG3uLxrDpvFsQViFttmLWez+DxpCqPF8ROdzA4cHrPun2Xz2LLyJpPHzll32T0Wb9rP
        5rH5dLXH501yAWxRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZ
        ZalF+nYJehlTtvIUbBOtuHBqCWsD417BLkZODgkBE4mbNzcydjFycQgJLGWU2PO6gw0iISNx
        cloDK4QtLPHnWhcbRNFbRonGHx/BEsICKRIz+j8ygyREBM4xSsw9t50FJMEskCixZN9OJoiO
        NUwSZ2Y3MIMk2AQMJbredoGt4BWwkzi85TwTiM0ioCJx4dICoBoODlGBWImWi5oQJYISJ2c+
        YQEJcwrYSjR1OEOMN5OYt/khM4QtL7H97RwoW1zi1pP5TBMYhWYh6Z6FpGUWkpZZSFoWMLKs
        YhRJLS3OTc8tNtQrTswtLs1L10vOz93ECIzBbcd+bt7BeGlj8CFGAQ5GJR5ei4+b44RYE8uK
        K3MPMUpwMCuJ8E6s2BInxJuSWFmVWpQfX1Sak1p8iNEU6LWJzFKiyfnA9JBXEm9oamhuYWlo
        bmxubGahJM7bIXAwRkggPbEkNTs1tSC1CKaPiYNTqoFxXnm4ylOWoDU54jI7ju1+NmvRxI0/
        X+eccpug9mzX5N16noVxnk+t1vhPSP69Q6RkUqB1y3qXM30ne+MZV70IT8k6denLgxmaq2rW
        /putpbT/0KGvrIKPbt56PMfhreeUV83Ghitm6FREfDt665pvXx7jBtHw7IvHjF31i3I+vtRc
        zDnn8DT3HiWW4oxEQy3mouJEAJvHOMHXAgAA
X-CMS-MailID: 20200508063834eucas1p28a0442b9e5433ecdc5c56cbd19dd313c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200507100347eucas1p2bad4d58e4eb23e8abd22b43f872fc865
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200507100347eucas1p2bad4d58e4eb23e8abd22b43f872fc865
References: <20200225131159.26602-1-nsaenzjulienne@suse.de>
        <cf07fae3-bd8f-a645-0007-a317832c51c1@samsung.com>
        <CGME20200507100347eucas1p2bad4d58e4eb23e8abd22b43f872fc865@eucas1p2.samsung.com>
        <a3df217d-f35c-9d74-4069-d47dee89173e@samsung.com>
        <09f9fdff-867f-687f-e5af-a4f82a75e105@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On 07.05.2020 17:54, Florian Fainelli wrote:
> On 5/7/2020 3:03 AM, Marek Szyprowski wrote:
>> On 07.05.2020 11:46, Marek Szyprowski wrote:
>>> On 25.02.2020 14:11, Nicolas Saenz Julienne wrote:
>>>> Outdated Raspberry Pi 4 firmware might configure the external PHY as
>>>> rgmii although the kernel currently sets it as rgmii-rxid. This makes
>>>> connections unreliable as ID_MODE_DIS is left enabled. To avoid this,
>>>> explicitly clear that bit whenever we don't need it.
>>>>
>>>> Fixes: da38802211cc ("net: bcmgenet: Add RGMII_RXID support")
>>>> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
>>> I've finally bisected the network issue I have on my RPi4 used for
>>> testing mainline builds. The bisect pointed to this patch. Once it got
>>> applied in v5.7-rc1, the networking is broken on my RPi4 in ARM32bit
>>> mode and kernel compiled from bcm2835_defconfig. I'm using u-boot to
>>> tftp zImage/dtb/initrd there. After reverting this patch network is
>>> working fine again. The strange thing is that networking works fine if
>>> kernel is compiled from multi_v7_defconfig but I don't see any obvious
>>> difference there.
>>>
>>> I'm not sure if u-boot is responsible for this break, but kernel
>>> definitely should be able to properly reset the hardware to the valid
>>> state.
>>>
>>> ...
>> Okay, I've played a bit more with this and found that enabling
>> CONFIG_BROADCOM_PHY fixes this network issue. I wonder if Genet driver
>> should simply select CONFIG_BROADCOM_PHY the same way as it selects
>> CONFIG_BCM7XXX_PHY.
> Historically GENET has been deployed with an internal PHY and this is
> still 90% of the GENET users out there on classic Broadcom STB
> platforms, not counting the 2711. For external PHYs, there is a variety
> of options here, so selecting CONFIG_BROADCOM_PHY would be just one of
> the possibilities, I would rather fix this with the bcm2835_defconfig
> and multi_v7_defconfig update. Would that work for you?

Frankly I was surprised that the Genet driver successfully probed and 
registered eth0 even when no proper PHY driver was available in the 
system. It even reported the link status change, but then didn't 
transfer any packets. I expected at least a runtime check and error or 
warning if proper PHY is not available. If this is really not possible, 
I would still advise to select proper potential PHY drivers, so users 
won't be confused.

The Genet driver already selects CONFIG_BCM7XXX_PHY. How common is it? 
Would it really hurt do the same for CONFIG_BROADCOM_PHY? I expect that 
2711 will be quite popular SoC with it soon.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

