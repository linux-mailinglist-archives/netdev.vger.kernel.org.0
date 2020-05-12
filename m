Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1801B1CECBD
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 08:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgELGAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 02:00:14 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52681 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgELGAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 02:00:13 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200512060012euoutp01984e4cd447fe8f1cedfaed6bc13b7217~OMnijAIDf2928629286euoutp01b
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 06:00:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200512060012euoutp01984e4cd447fe8f1cedfaed6bc13b7217~OMnijAIDf2928629286euoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589263212;
        bh=qBQCgSV1H4lTopc6ziFSzLrDrLyvon3nMDzQhcOB1zo=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=PhjodGlCR1+kpWm+ivklqTp2ehTVO3ShhTH8tkshACTvWJE/cXK7x54LRvS7H7a4F
         nMcvC4tef1TMpMhREqcKFBdWdi5cTdeS1p9mXl1RzQMC9OvFVfFpH/535/JlAF8PP7
         1Mufoo1CgpEnqCU+1VySa/BO2KvENIpY46YGP1xU=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200512060011eucas1p201e643e3f309a756e1167438d6f61038~OMniQnoZm1159611596eucas1p2t;
        Tue, 12 May 2020 06:00:11 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 04.6D.60698.B6B3ABE5; Tue, 12
        May 2020 07:00:11 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200512060011eucas1p14bdaf602bb62b3eb5344db379a2d04bb~OMnh46-lw1582015820eucas1p1o;
        Tue, 12 May 2020 06:00:11 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200512060011eusmtrp1c8b01594ef47ac652fbf3019326febe6~OMnh4OPaN0862708627eusmtrp1d;
        Tue, 12 May 2020 06:00:11 +0000 (GMT)
X-AuditID: cbfec7f5-a0fff7000001ed1a-60-5eba3b6ba14f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 50.C8.08375.B6B3ABE5; Tue, 12
        May 2020 07:00:11 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200512060010eusmtip19e27b1a0d995374720085eacdd1ccc13~OMnhQ1fKw1427614276eusmtip1k;
        Tue, 12 May 2020 06:00:10 +0000 (GMT)
Subject: Re: [PATCH net] net: broadcom: Imply BROADCOM_PHY for BCMGENET
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     nsaenzjulienne@suse.de, wahrenst@gmx.net,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tal Gilboa <talgi@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andy Gospodarek <gospo@broadcom.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        open list <linux-kernel@vger.kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <d4ddf75c-3355-daee-b1d1-8db02675507a@samsung.com>
Date:   Tue, 12 May 2020 08:00:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <51710a87-5a99-35ee-5bea-92a5801cec09@gmail.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTcRjlt3u997rauFsPPzQyFr20NNPqoiVZVhf8J4KgIquVF5W2KZuW
        JYUvxMeINGp603wUbAm9Zs0UNFzhMmlaqyzzUSRWrik1pbKHbbtY/ne+853DOd+PH4XJ+/wC
        qVRNBqfVKFUKQoxbOn50rzkW03Jw7bW6CKaquwBnpsYekkz1pXLEmG7V+zGOliqCKWu4TjAd
        tQsZC28kGFe/AWcuVreSTKP5AsbYHhVjW+ay/NATgr1z7bWILXuyhm3mB0j2ivk+wTaaQtgx
        u51kRwwPRGxjVzbrNi/eJd4v3pTEqVKPc9rw2MPiFMenD1h6vTyr/XYnkYOc0hLkTwEdBW/G
        zxIlSEzJaROCuiEDLgwTCJpGbxJelZx2I+hvDZ1x5DrvkoLIiGDksQEThnEEpoGfmFc1j94J
        g81GPy+eT28DQ2+Dz4HREyJwWwp9C4KOgBJXiS9CQseCPe+yz4zTy2CqVI978QI6EbquNCJB
        I4POymEf709vBt7+wYcxOhiaXFWYgAOgb7hG5A0DepKEyVw9JvSOh9EbX3EBz4NR2x1SwIug
        67weFwz5CN7Zr5PCoEfgyKtAgioG+u1TnqqUJ2IV3GwJF+g4sL7/KPLSQEvhlUsmlJBCucX7
        LF5aAkWFckG9HHjbjX+x7T3PsHNIwc86jZ91Dj/rHP5/bi3CG1AAl6lTJ3O6SA13IkynVOsy
        NclhR9PUZuT5cV1/bJP3UNuvI1ZEU0gxV1K0rvmg3E95XHdSbUVAYYr5koJUDyVJUp48xWnT
        DmkzVZzOioIoXBEgiaz/lCink5UZ3DGOS+e0M1sR5R+Ygx6cysbHbMPRzm9am2L6y8afQXFR
        g073RK80Ybc6f86LPG1noLyCJ3KCjDu2rn26d5pyLCmqZC9Jy2X7sjqbz7wNy8j+TP6W1ZDb
        o0ZHTodaA9uozITvpuDnKrRyf2lIoSw9XnZAn78i2XI1pvTt0j3xL3tcq3OmNqyPLL4bbSlX
        4LoUZUQIptUp/wKGcda/bQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t/xu7rZ1rviDI7tkLWYc76FxeLXuyPs
        FnNnT2K0WLFhEavF5V1z2CwmrlrLZnFsgZjFtlnL2Sze3pnOYjFt7l52i82bpjJbHD/RyezA
        4zHr/lk2jy0rbzJ5TDyr67Fz1l12j8Wb9rN5bF6h5fHu3Dl2j2fTDzN5bD5d7fF5k1wAV5Se
        TVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZapG+XYJexuWXz5kL
        FglVHNx4kq2B8TVfFyMnh4SAiUTj663sILaQwFJGiZcXPSDiMhInpzWwQtjCEn+udbF1MXIB
        1bxllDj5uQcsISzgLnFv53IwW0TAWWL69VXsIEXMAt+YJE7M7mOG6PjCKPH3/S0WkCo2AUOJ
        rrcgozg5eAXsJM41zWMGsVkEVCV+dfeA1YgKxEqsvtbKCFEjKHFy5hOwOKeArcSsc8/BbGYB
        M4l5mx8yQ9jyEtvfzoGyxSVuPZnPNIFRaBaS9llIWmYhaZmFpGUBI8sqRpHU0uLc9NxiQ73i
        xNzi0rx0veT83E2MwJjeduzn5h2MlzYGH2IU4GBU4uHtMNoZJ8SaWFZcmXuIUYKDWUmEtyUT
        KMSbklhZlVqUH19UmpNafIjRFOi5icxSosn5wHSTVxJvaGpobmFpaG5sbmxmoSTO2yFwMEZI
        ID2xJDU7NbUgtQimj4mDU6qBsUXLM3vd7ClPBMS8th41+FwRULHla+ldxwcnjv+pWOL1meHW
        1QVHvB992hxw79NfDf/Ls7QWPdZvfvhnI+/je9I5vI8nKjvuurpUjPl9024e94y/DIaZcmra
        ExP/3UpI1/Df58Vxv08jg0/rlc8pm+xQdtOZfIbu68OUcj6JC099azdVfqmeqhJLcUaioRZz
        UXEiAH+5i7T/AgAA
X-CMS-MailID: 20200512060011eucas1p14bdaf602bb62b3eb5344db379a2d04bb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200508223228eucas1p252dd643b4bedf08126cf6af4788f9b01
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200508223228eucas1p252dd643b4bedf08126cf6af4788f9b01
References: <CGME20200508223228eucas1p252dd643b4bedf08126cf6af4788f9b01@eucas1p2.samsung.com>
        <20200508223216.6611-1-f.fainelli@gmail.com>
        <350c88a9-eeaf-7859-d425-0ee4ca355ed3@samsung.com>
        <51710a87-5a99-35ee-5bea-92a5801cec09@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On 11.05.2020 20:19, Florian Fainelli wrote:
> On 5/11/2020 12:21 AM, Marek Szyprowski wrote:
>> On 09.05.2020 00:32, Florian Fainelli wrote:
>>> The GENET controller on the Raspberry Pi 4 (2711) is typically
>>> interfaced with an external Broadcom PHY via a RGMII electrical
>>> interface. To make sure that delays are properly configured at the PHY
>>> side, ensure that we get a chance to have the dedicated Broadcom PHY
>>> driver (CONFIG_BROADCOM_PHY) enabled for this to happen.
>>>
>>> Fixes: 402482a6a78e ("net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL when not needed")
>>> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>> ---
>>> David,
>>>
>>> I would like Marek to indicate whether he is okay or not with this
>>> change. Thanks!
>> It is better. It fixes the default values for ARM 32bit
>> bcm2835_defconfig and ARM 64bit defconfig, so you can add:
>>
>> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>
>> There is still an issue there. In case of ARM 64bit, when Genet driver
>> is configured as a module, BROADCOM_PHY is also set to module. When I
>> changed Genet to be built-in, BROADCOM_PHY stayed selected as module.
> OK.
>
>> This case doesn't work, as Genet driver is loaded much earlier than the
>> rootfs/initrd/etc is available, thus broadcom phy driver is not loaded
>> at all. It looks that some kind of deferred probe is missing there.
> In the absence of a specific PHY driver the Generic PHY driver gets used
> instead. This is a valid situation as I described in my other email
> because the boot loader/firmware could have left the PHY properly
> configured with the expected RGMII delays and configuration such that
> Linux does not need to be aware of anything. I suppose we could change
> the GENET driver when running on the 2711 platform to reject the PHY
> driver being "Generic PHY" on the premise that a specialized driver
> should be used instead, but that seems a bit too restrictive IMHO.
>
> Do you prefer a "select BROADCOM_PHY if ARCH_BCM2835" then?

Yes. It solves the issue after switching Genet to be built-in without 
the need to change the CONFIG_BROADCOM_PHY.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

