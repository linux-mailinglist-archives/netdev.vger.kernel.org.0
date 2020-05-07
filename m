Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556F91C8658
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgEGKDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:03:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45825 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgEGKDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 06:03:50 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200507100348euoutp015427178cc35b5c5789baa81bc10fad2d~Mttz3KKnN1626116261euoutp01a
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 10:03:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200507100348euoutp015427178cc35b5c5789baa81bc10fad2d~Mttz3KKnN1626116261euoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1588845828;
        bh=n1hyo1ZZivHMwjURuyCwQt/gyOD2+hA6O4SxbPqP0Ps=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nL4O4Cj70JWGFZLxZdmIGRGJ/teTkq1VN/br6vwpa0k2yaNwU33m4HmSXvWGr/5a6
         uDNmv6VOc7I8jI7PDtVoBoCTsvLRUB1ZXB2bxopwgPC3pjp0fertbOJGmQeV5svxls
         b2pL/JS4cWMi6O5wROYVG3ppcZZipDcYfElNI+Qw=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200507100348eucas1p25e26193811e0d61a01e14aaaaaeffe18~MttzofAi12132621326eucas1p2N;
        Thu,  7 May 2020 10:03:48 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 9D.2E.61286.40DD3BE5; Thu,  7
        May 2020 11:03:48 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200507100347eucas1p2bad4d58e4eb23e8abd22b43f872fc865~MttzJ7BSN2137321373eucas1p2F;
        Thu,  7 May 2020 10:03:47 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200507100347eusmtrp2d7aae0ca429747cf812959bf1ae24c23~MttzJABXy0420904209eusmtrp2C;
        Thu,  7 May 2020 10:03:47 +0000 (GMT)
X-AuditID: cbfec7f2-f0bff7000001ef66-33-5eb3dd04bec0
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 60.26.08375.30DD3BE5; Thu,  7
        May 2020 11:03:47 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200507100347eusmtip278840cc17e60b3a216025b769e33a67b~MttyqfPQb0642406424eusmtip2d;
        Thu,  7 May 2020 10:03:47 +0000 (GMT)
Subject: Re: [PATCH net v2] net: bcmgenet: Clear ID_MODE_DIS in
 EXT_RGMII_OOB_CTRL when not needed
From:   Marek Szyprowski <m.szyprowski@samsung.com>
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Wahren <wahrenst@gmx.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <a3df217d-f35c-9d74-4069-d47dee89173e@samsung.com>
Date:   Thu, 7 May 2020 12:03:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cf07fae3-bd8f-a645-0007-a317832c51c1@samsung.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsWy7djPc7osdzfHGbT8FLVY23uUxWLO+RYW
        i1/vjrBbXN41h83i2AIxi22zlrNZfJ40hdHi+IlOZgcOj1n3z7J5bFl5k8lj56y77B6LN+1n
        89h8utrj8ya5ALYoLpuU1JzMstQifbsEroydl2azFqzir5i9voexgXELTxcjJ4eEgInEsT1v
        WLoYuTiEBFYwSly7sxPK+cIocXbJRGYI5zOjxNV9nUwwLW83XmCHSCxnlDj2dgmU855RYv7s
        zawgVcICKRIz+j8yg9hsAoYSXW+72ECKRATOMErcPfyQHSTBLJAo8X/1H7AGXgE7idtTIJpZ
        BFQkLp9fAWRzcIgKxEpMvxYCUSIocXLmExYQm1PAXuLTjj9MEGPkJZq3zmaGsMUlbj2ZzwSy
        S0JgF7tEz+1NUGe7SGw9NYUVwhaWeHV8CzuELSPxfydMQzOjxMNza9khnB5GictNMxghqqwl
        7pz7xQZyEbOApsT6XfoQYUeJ/kcr2UHCEgJ8EjfeCkIcwScxadt0Zogwr0RHmxBEtZrErOPr
        4NYevHCJeQKj0iwkr81C8s4sJO/MQti7gJFlFaN4amlxbnpqsWFearlecWJucWleul5yfu4m
        RmBaOv3v+KcdjF8vJR1iFOBgVOLhPbBsU5wQa2JZcWXuIUYJDmYlEV6eHxvjhHhTEiurUovy
        44tKc1KLDzFKc7AoifMaL3oZKySQnliSmp2aWpBaBJNl4uCUamA04dDbFNZeetf/vOEJye3L
        NY16GLy59tXY2FmZbJnI//64blTgXpuVdZxuJgYWXN8l8nUYcuZ6bbzb2FkYxjOf61quVGhT
        Y9PlimWzdzxb3BP5hDmo7UlD4+qdTTNOsNg5SAS9vvNP0Dk8etLeTvVrQV9Ptzt1fd2U1PPy
        W/lNPxfJe1KTFiixFGckGmoxFxUnAgBigBfgRwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t/xe7rMdzfHGfy/a2qxtvcoi8Wc8y0s
        Fr/eHWG3uLxrDpvFsQViFttmLWez+DxpCqPF8ROdzA4cHrPun2Xz2LLyJpPHzll32T0Wb9rP
        5rH5dLXH501yAWxRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZ
        ZalF+nYJehk7L81mLVjFXzF7fQ9jA+MWni5GTg4JAROJtxsvsHcxcnEICSxllFh2/BYrREJG
        4uS0BihbWOLPtS42iKK3jBK/554BSwgLpEjM6P/IDGKzCRhKdL2FKBIROMMo8fXjXCaQBLNA
        osSSfTvBbCGBAol/85eCNfMK2EncnrIZzGYRUJG4fH4FkM3BISoQK9FyUROiRFDi5MwnLCA2
        p4C9xKcdf6BGmknM2/yQGcKWl2jeOhvKFpe49WQ+0wRGoVlI2mchaZmFpGUWkpYFjCyrGEVS
        S4tz03OLDfWKE3OLS/PS9ZLzczcxAqNw27Gfm3cwXtoYfIhRgINRiYf3wLJNcUKsiWXFlbmH
        GCU4mJVEeHl+bIwT4k1JrKxKLcqPLyrNSS0+xGgK9NtEZinR5HxggsgriTc0NTS3sDQ0NzY3
        NrNQEuftEDgYIySQnliSmp2aWpBaBNPHxMEp1cDoY/9y8bLnfRzdCfckL+7x3m7JZP3t8Ofq
        LNVg89s9D1jXhXauF269tXez+c9XO1KeVXPuf2Kissih6XXWsZ/qmn/efXrOdv3OJ8Mdcn1n
        J0kF/Ko8d4PxhqKm08INJmdv8VXMbXixvnzas1lam3MnMSUpmMSFTCuYfvGt+PoHMY2+T/a/
        +798oRJLcUaioRZzUXEiAHf4TnzYAgAA
X-CMS-MailID: 20200507100347eucas1p2bad4d58e4eb23e8abd22b43f872fc865
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200507100347eucas1p2bad4d58e4eb23e8abd22b43f872fc865
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200507100347eucas1p2bad4d58e4eb23e8abd22b43f872fc865
References: <20200225131159.26602-1-nsaenzjulienne@suse.de>
        <cf07fae3-bd8f-a645-0007-a317832c51c1@samsung.com>
        <CGME20200507100347eucas1p2bad4d58e4eb23e8abd22b43f872fc865@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 07.05.2020 11:46, Marek Szyprowski wrote:
> On 25.02.2020 14:11, Nicolas Saenz Julienne wrote:
>> Outdated Raspberry Pi 4 firmware might configure the external PHY as
>> rgmii although the kernel currently sets it as rgmii-rxid. This makes
>> connections unreliable as ID_MODE_DIS is left enabled. To avoid this,
>> explicitly clear that bit whenever we don't need it.
>>
>> Fixes: da38802211cc ("net: bcmgenet: Add RGMII_RXID support")
>> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
>
> I've finally bisected the network issue I have on my RPi4 used for 
> testing mainline builds. The bisect pointed to this patch. Once it got 
> applied in v5.7-rc1, the networking is broken on my RPi4 in ARM32bit 
> mode and kernel compiled from bcm2835_defconfig. I'm using u-boot to 
> tftp zImage/dtb/initrd there. After reverting this patch network is 
> working fine again. The strange thing is that networking works fine if 
> kernel is compiled from multi_v7_defconfig but I don't see any obvious 
> difference there.
>
> I'm not sure if u-boot is responsible for this break, but kernel 
> definitely should be able to properly reset the hardware to the valid 
> state.
>
> I can provide more information, just let me know what is needed. Here 
> is the log, I hope it helps:
>
> [   11.881784] bcmgenet fd580000.ethernet eth0: Link is Up - 
> 1Gbps/Full - flow control off
> [   11.889935] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>
> root@target:~# ping host
> PING host (192.168.100.1) 56(84) bytes of data.
> From 192.168.100.53 icmp_seq=1 Destination Host Unreachable
> ...

Okay, I've played a bit more with this and found that enabling 
CONFIG_BROADCOM_PHY fixes this network issue. I wonder if Genet driver 
should simply select CONFIG_BROADCOM_PHY the same way as it selects 
CONFIG_BCM7XXX_PHY.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

