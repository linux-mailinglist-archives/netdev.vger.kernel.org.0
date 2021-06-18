Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526523AC989
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 13:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhFRLNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 07:13:55 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57534 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhFRLNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 07:13:53 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210618111143euoutp01b3d96f3d08bd2f7653de780ee7117304~JqMTG3QI90785607856euoutp01H
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:11:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210618111143euoutp01b3d96f3d08bd2f7653de780ee7117304~JqMTG3QI90785607856euoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624014703;
        bh=pSwTUIAscPXtxhGZvWDPHbRmG482WFPNouiWzt7I0SE=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=YMRRq6FxTEbk8fF3Pc9uTtKRk86BOQWgp9IOoie408mhIIWpmaAa3kOGrsHg+Kp92
         AYloMHjqv3l6LWtEo1A/lF4eLPt5m5StcYjfYwOlpAcwsbOAcxGjYshheqO5ZzQbMu
         OftaZvG7GetSnKqPG+Mi14lWr1eEHkX7jsChOFtw=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210618111143eucas1p2f79c88182260ceca9f9807febe735bf6~JqMSrMQMW2165021650eucas1p2R;
        Fri, 18 Jun 2021 11:11:43 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 92.59.42068.F6F7CC06; Fri, 18
        Jun 2021 12:11:43 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210618111142eucas1p139b70c7c15fe20f4e9684a746f5a2cf0~JqMSMhkM31450214502eucas1p1e;
        Fri, 18 Jun 2021 11:11:42 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210618111142eusmtrp28a2c6a1a82f8df4e9ba0344663bbefcd~JqMSLyZvG1786717867eusmtrp2P;
        Fri, 18 Jun 2021 11:11:42 +0000 (GMT)
X-AuditID: cbfec7f4-c89ff7000002a454-73-60cc7f6f0c30
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 00.B2.31287.E6F7CC06; Fri, 18
        Jun 2021 12:11:42 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210618111142eusmtip14b2a773c3ad6f565421b489ddd0c6a9c~JqMRnmtR71686516865eusmtip16;
        Fri, 18 Jun 2021 11:11:42 +0000 (GMT)
Subject: Re: [PATCH net-next v2 4/8] net: usb: asix: ax88772: add phylib
 support
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <e868450d-c623-bea9-6325-aca4e8367ad5@samsung.com>
Date:   Fri, 18 Jun 2021 13:11:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <b1c48fa1-d406-766e-f8d7-54f76d3acb7c@gmail.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsWy7djPc7r59WcSDFYcZLc4f/cQs8Wc8y0s
        Fovez2C1WDV1J4vFhW19rBaXd81hs1i0rJXZ4tDUvYwWxxaIWTy5x+jA5XH52kVmjy0rbzJ5
        7Jx1l91j06pONo+dOz4zefT/NfD4vEkugD2KyyYlNSezLLVI3y6BK+PQg0mMBbc0K+bdd21g
        nKfUxcjBISFgIjHpaXEXIxeHkMAKRomvnetZIZwvjBJnFuxhhnA+M0o0PLrA0sXICdZxa2Mj
        VNVyRomnS2awQTgfGSXu/v3ECjJXWCBIYvnBIJAGEYEwiSm/u1lAapgFGpkkjr9rYANJsAkY
        SnS97QKzeQXsJL7vOssIYrMIqErMX/2dHcQWFUiWeD9vBitEjaDEyZlPwK7gFLCV2Hu8Daye
        WUBeonnrbGYIW1zi1pP5TCDLJAT+c0is/PWOFeJsF4nXTevZIWxhiVfHt0DZMhL/d8I0NDNK
        PDy3lh3C6WGUuNw0gxGiylrizrlfbCCvMQtoSqzfpQ8RdpSYsaKFBRKSfBI33gpCHMEnMWnb
        dGaIMK9ER5sQRLWaxKzj6+DWHrxwiXkCo9IsJK/NQvLOLCTvzELYu4CRZRWjeGppcW56arFR
        Xmq5XnFibnFpXrpecn7uJkZgujr97/iXHYzLX33UO8TIxMF4iFGCg1lJhJcz80yCEG9KYmVV
        alF+fFFpTmrxIUZpDhYlcd6kLWvihQTSE0tSs1NTC1KLYLJMHJxSDUwbJkUWWkq9f6ToUvJi
        u9p1se2/PHJ09305mvDHYdnmvmv/wxQ0+2IVky2aNkpG8665vfHwET6O401iiV69ig89ZifW
        yN4K3BnD9fBfRkD4whWWB1fwFOk9m7p3Ym2bbuFPt6Lq1ZGrTutvr2VqLmS92Kju/jrwx9/n
        81tE16jV993ZqTv3XuyLbXMC98871v2owfBK5pxuwejseTWmEudzRFW4OrzetavF/pg4S3Cl
        NPO3KfOZZdRcWIs8pO7MOiZ65Nk8rnCd9MCshu9/3D/Mti0QtNOJjr3558Y8+/Xuhgbnjvzj
        PBcZsCajcl5LUfQm1YBn9xu09917ukmXT46xpkjZVaprz9Fv+3orm5VYijMSDbWYi4oTAbrd
        cJrGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t/xu7p59WcSDKb81bA4f/cQs8Wc8y0s
        Fovez2C1WDV1J4vFhW19rBaXd81hs1i0rJXZ4tDUvYwWxxaIWTy5x+jA5XH52kVmjy0rbzJ5
        7Jx1l91j06pONo+dOz4zefT/NfD4vEkugD1Kz6Yov7QkVSEjv7jEVina0MJIz9DSQs/IxFLP
        0Ng81srIVEnfziYlNSezLLVI3y5BL+PQg0mMBbc0K+bdd21gnKfUxcjJISFgInFrYyNrFyMX
        h5DAUkaJ/ze3sEIkZCROTmuAsoUl/lzrYoMoes8ocen4VJYuRg4OYYEgieUHg0BqRATCJDbM
        vwZWwyzQyCSx6nMH1NR7TBI3/vxhAqliEzCU6HoLMomTg1fATuL7rrOMIDaLgKrE/NXf2UFs
        UYFkiZ/r26FqBCVOznzCAmJzCthK7D3eBlbPLGAmMW/zQ2YIW16ieetsKFtc4taT+UwTGIVm
        IWmfhaRlFpKWWUhaFjCyrGIUSS0tzk3PLTbUK07MLS7NS9dLzs/dxAiM0G3Hfm7ewTjv1Ue9
        Q4xMHIyHGCU4mJVEeDkzzyQI8aYkVlalFuXHF5XmpBYfYjQF+mcis5Rocj4wReSVxBuaGZga
        mphZGphamhkrifNunbsmXkggPbEkNTs1tSC1CKaPiYNTqoEprr+gqHcV5z7lnvs/TCXCpaO0
        vJNXJa5zqOTlvXfz9X5x+z23uVe3+XfyL247c/LGnjW6j3v6F8zdJen7YvUlle0pbPW2a64U
        XlmQETvz5syL2Tm9xYEiZc4hPf/vKKkGRp6ulTo40eTqLCXFy8/nzvrJEXRfl/OYfuj9Wbn1
        lw9yFk3fI5YjHSQ6XaxsvVn6/jrhnTMZFxYpvpHoy96x6HHafIfjFVcsq7fPN6rual/a++RT
        jvxq87MvXlv9PhjCc5lvlsf1WUUtRxbpu2zdGe1UH7rqpdjhvPm2QcY6Co77c3eeydj8f8ns
        y6lZp4rFX+zyWfZ/fd3PQPNtZ6PvBM3aL1gqXeN4JdPXJ+WMEktxRqKhFnNRcSIAoUnHEFkD
        AAA=
X-CMS-MailID: 20210618111142eucas1p139b70c7c15fe20f4e9684a746f5a2cf0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210618083914eucas1p240f88e7064a7bf15b68370b7506d24a9
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210618083914eucas1p240f88e7064a7bf15b68370b7506d24a9
References: <20210607082727.26045-1-o.rempel@pengutronix.de>
        <20210607082727.26045-5-o.rempel@pengutronix.de>
        <CGME20210618083914eucas1p240f88e7064a7bf15b68370b7506d24a9@eucas1p2.samsung.com>
        <15e1bb24-7d67-9d45-54c1-c1c1a0fe444a@samsung.com>
        <20210618101317.55fr5vl5akmtgcf6@pengutronix.de>
        <b1c48fa1-d406-766e-f8d7-54f76d3acb7c@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

On 18.06.2021 13:04, Heiner Kallweit wrote:
> On 18.06.2021 12:13, Oleksij Rempel wrote:
>> thank you for your feedback.
>>
>> On Fri, Jun 18, 2021 at 10:39:12AM +0200, Marek Szyprowski wrote:
>>> On 07.06.2021 10:27, Oleksij Rempel wrote:
>>>> To be able to use ax88772 with external PHYs and use advantage of
>>>> existing PHY drivers, we need to port at least ax88772 part of asix
>>>> driver to the phylib framework.
>>>>
>>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>> I found one more issue with this patch. On one of my test boards
>>> (Samsung Exynos5250 SoC based Arndale) system fails to establish network
>>> connection just after starting the kernel when the driver is build-in.
>>>
> If you build in the MAC driver, do you also build in the PHY driver?
> If the PHY driver is still a module this could explain why genphy
> driver is used.
> And your dmesg filtering suppresses the phy_attached_info() output
> that would tell us the truth.

Here is a bit more complete log:

# dmesg | grep -i Asix
[    2.412966] usbcore: registered new interface driver asix
[    4.620094] usb 1-3.2.4: Manufacturer: ASIX Elec. Corp.
[    4.641797] asix 1-3.2.4:1.0 (unnamed net_device) (uninitialized): 
invalid hw address, using random
[    5.657009] libphy: Asix MDIO Bus: probed
[    5.750584] Asix Electronics AX88772A usb-001:004:10: attached PHY 
driver (mii_bus:phy_addr=usb-001:004:10, irq=POLL)
[    5.763908] asix 1-3.2.4:1.0 eth0: register 'asix' at 
usb-12110000.usb-3.2.4, ASIX AX88772 USB 2.0 Ethernet, fe:a5:29:e2:97:3e
[    9.090270] asix 1-3.2.4:1.0 eth0: Link is Up - 100Mbps/Full - flow 
control off

This seems to be something different than missing PHY driver.

>>> --->8---
>>> # dmesg | grep asix
>>> [    2.761928] usbcore: registered new interface driver asix
>>> [    5.003110] asix 1-3.2.4:1.0 (unnamed net_device) (uninitialized):
>>> invalid hw address, using random
>>> [    6.065400] asix 1-3.2.4:1.0 eth0: register 'asix' at
>>> usb-12110000.usb-3.2.4, ASIX AX88772 USB 2.0 Ethernet, 7a:9b:9a:f2:94:8e
>>> [   14.043868] asix 1-3.2.4:1.0 eth0: Link is Up - 100Mbps/Full - flow
>>> control off
>>> # ping -c2  host
>>> PING host (192.168.100.1) 56(84) bytes of data.
>>>   From 192.168.100.20 icmp_seq=1 Destination Host Unreachable
>>>   From 192.168.100.20 icmp_seq=2 Destination Host Unreachable
>>>
>>> --- host ping statistics ---
>>> 2 packets transmitted, 0 received, +2 errors, 100% packet loss, time 59ms
>>> --->8---
>> Hm... it looks like different chip variant. My is registered as
>> "ASIX AX88772B USB", yours is "ASIX AX88772 USB 2.0" - "B" is the
>> difference. Can you please tell me more about this adapter and if possible open
>> tell the real part name.
>>
>> I can imagine that this adapter may using generic PHY driver.
>> Can you please confirm it by dmesg | grep PHY?
>> In my case i'll get:
>> Asix Electronics AX88772C usb-001:003:10: attached PHY driver (mii_bus:phy_addr=usb-001:003:10, irq=POLL)
>>
>> If you have a different PHY, can you please send me the PHY id:
>> cat /sys/bus/mdio_bus/devices/usb-001\:003\:10/phy_id
>>
>> Your usb path will probably be different.
>>
>>> Calling ifup eth0 && ifdown eth0 fixes the network status:
>>>
>>> --->8---
>>> # ifdown eth0 && ifup eth0
>>> [   60.474929] asix 1-3.2.4:1.0 eth0: Link is Down
>>> [   60.623516] asix 1-3.2.4:1.0 eth0: Link is Down
>>> [   62.774304] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>>> [   62.786354] asix 1-3.2.4:1.0 eth0: Link is Up - 100Mbps/Full - flow
>>> control off
>>> # ping -c2 host
>>> PING host (192.168.100.1) 56(84) bytes of data.
>>> 64 bytes from host (192.168.100.1): icmp_seq=1 ttl=64 time=1.25 ms
>>> 64 bytes from host (192.168.100.1): icmp_seq=2 ttl=64 time=0.853 ms
>>>
>>> --- host ping statistics ---
>>> 2 packets transmitted, 2 received, 0% packet loss, time 3ms
>>> rtt min/avg/max/mdev = 0.853/1.053/1.254/0.203 ms
>>> --->8---
>>>
>>> When driver is loaded as a module (and without any other modules, so
>>> this is not a dependency issue), the connection is established properly
>>> just after the boot:
>>>
>>> --->8---
>>> # dmesg | grep asix
>>> [   13.633284] asix 1-3.2.4:1.0 (unnamed net_device) (uninitialized):
>>> invalid hw address, using random
>>> [   15.390350] asix 1-3.2.4:1.0 eth0: register 'asix' at
>>> usb-12110000.usb-3.2.4, ASIX AX88772 USB 2.0 Ethernet, 3a:51:11:08:aa:ea
>>> [   15.414052] usbcore: registered new interface driver asix
>>> [   15.832564] asix 1-3.2.4:1.0 eth0: Link is Down
>>> [   18.053747] asix 1-3.2.4:1.0 eth0: Link is Up - 100Mbps/Full - flow
>>> control off
>>> # ping -c2 host
>>> PING host (192.168.100.1) 56(84) bytes of data.
>>> 64 bytes from host (192.168.100.1): icmp_seq=1 ttl=64 time=0.545 ms
>>> 64 bytes from host (192.168.100.1): icmp_seq=2 ttl=64 time=0.742 ms
>>>
>>> --- host ping statistics ---
>>> 2 packets transmitted, 2 received, 0% packet loss, time 3ms
>>> rtt min/avg/max/mdev = 0.545/0.643/0.742/0.101 ms
>>>
>>> --->8---
>>>
>>> Let me know if I can make any other tests that would help fixing this issue.
>>> [...]

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

