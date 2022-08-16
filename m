Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AD1595A84
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbiHPLqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbiHPLpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:45:32 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10BC8304E
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 04:18:31 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220816111826euoutp01b5acf580fa7a5857ba88f716a93a4a84~LzzMg4jsU3122731227euoutp01z
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:18:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220816111826euoutp01b5acf580fa7a5857ba88f716a93a4a84~LzzMg4jsU3122731227euoutp01z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660648706;
        bh=8qlHYZTa8T/zZ1lSh3y/2QHWKCL3iVeytbgEsAxm80c=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=NzjwDYdCS61rm0et6eIl4S0Ge4NnTaFevA5OXs8RgOVGdSEbhhwf9jboW49TlfETK
         xUWn4hnBzzkZj68st5be07M/ocFzftUEhiZ1U7a7/HNum/NPCSjVNamek5PeAFlDdn
         DmVlgZ/2dW7mGUo/e9syB7y8M1ipv0zbqMkFU0qw=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220816111825eucas1p207711b7d7ce51d639fa19a9cb7500db4~LzzL7Xnpj0314503145eucas1p2v;
        Tue, 16 Aug 2022 11:18:25 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id D7.BD.09580.10D7BF26; Tue, 16
        Aug 2022 12:18:25 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220816111824eucas1p2719a48c792ba5676c89378c9090a83c7~LzzLbd6pD2207622076eucas1p2d;
        Tue, 16 Aug 2022 11:18:24 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220816111824eusmtrp250f9304febf1c81cb400fb113efff106~LzzLaryhw0129801298eusmtrp2Q;
        Tue, 16 Aug 2022 11:18:24 +0000 (GMT)
X-AuditID: cbfec7f5-9c3ff7000000256c-3f-62fb7d01ee96
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 87.AE.09038.00D7BF26; Tue, 16
        Aug 2022 12:18:24 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220816111824eusmtip225842e3588a76ab3b35386956cd4ab63~LzzKvWeKR1128611286eusmtip2C;
        Tue, 16 Aug 2022 11:18:24 +0000 (GMT)
Message-ID: <291ed62e-7748-fffc-65c7-98f01e6abcf2@samsung.com>
Date:   Tue, 16 Aug 2022 13:18:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH net] net: phy: Warn about incorrect
 mdio_bus_phy_resume() state
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>
Cc:     opendmb@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <8c21e530-8e8f-ce2a-239e-9d3a354996cf@gmail.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsWy7djP87qMtb+TDHZ0SFmcv3uI2WLO+RYW
        i6fHHrFb/Hp3hN1i0fsZrBYXtvWxWlzeNYfN4tDUvYwWxxaIWXyeNIXR4tvpN4wWzZ9eMTnw
        eFy+dpHZY8vKm0weO2fdZfdYsKnUY9OqTjaPnTs+M3m833eVzeN/82UWj8+b5AI4o7hsUlJz
        MstSi/TtErgy+n+dYytYrV1xfOIm5gbGVypdjBwcEgImEs0rHboYuTiEBFYwSvR9msrexcgJ
        5HxhlPjW6gOR+MwosfdRJytIAqThx88HLBCJ5YwS5xa3M0E4Hxkl1p3pZAOp4hWwk5gw7REz
        iM0ioCrRsesKO0RcUOLkzCcsILaoQLLEs/+LweLCAqESJ6b1gm1gFhCXuPVkPhOILSJQIXHt
        6WF2kAXMAoeZJF7fmw5WxCZgKNH1tosN5AdOAVuJBb84IHrlJZq3zmYGqZcQmM8p8XXzPaiz
        XSSefHzDBmELS7w6voUdwpaR+L8TZBkoLPIl/s4whggD7X29hhnCtpa4c+4X2CpmAU2J9bv0
        IcKOEstaVkB18knceCsIcQGfxKRt05khwrwSHW1CENVqErOOr4PbefDCJeYJjEqzkMJkFpLf
        ZyH5ZRbC3gWMLKsYxVNLi3PTU4uN81LL9YoTc4tL89L1kvNzNzECU9rpf8e/7mBc8eqj3iFG
        Jg7GQ4wSHMxKIryCL34kCfGmJFZWpRblxxeV5qQWH2KU5mBREudNztyQKCSQnliSmp2aWpBa
        BJNl4uCUamBaUfBwjpX7TLn/m0J+JdUsWsRQnB6vaXjC8+R0RY/kO/ul+u+d4Vq2Y5ZR9rw3
        u2UCPpecv2z/JkpoXuCT4t+JG0NmPzms3+x5QPPGoZtttY9vzTzNOsnw1DkH+a9/7GLYX958
        9mQb59VEW1mJprzoTTUb5Ys4rh5LtZovJq08qSL1I4/n47MtAay3qjOUWl6aHl70fNGl0yLZ
        she+tXgGLtdlz8qYkmXTHLxbhKPdVtmke8rbv3u2fXi8YOK7CTO9j5W8nfDwUlt+8776VTp5
        exdsjPDVVAx5k+Cwzryeu/Vab6P4k/Xn365KXV2SkpL+aYoWm2hRlBbn2oNmvJYi69N+VXNG
        MTOFWC2X3hGpxFKckWioxVxUnAgAqZsuNNgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t/xe7oMtb+TDBrOGlmcv3uI2WLO+RYW
        i6fHHrFb/Hp3hN1i0fsZrBYXtvWxWlzeNYfN4tDUvYwWxxaIWXyeNIXR4tvpN4wWzZ9eMTnw
        eFy+dpHZY8vKm0weO2fdZfdYsKnUY9OqTjaPnTs+M3m833eVzeN/82UWj8+b5AI4o/RsivJL
        S1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQy+n+dYytYrV1x
        fOIm5gbGVypdjJwcEgImEj9+PmDpYuTiEBJYyihx8dhLNoiEjMTJaQ2sELawxJ9rXWwQRe8Z
        JW6ffcUOkuAVsJOYMO0RM4jNIqAq0bHrClRcUOLkzCcsILaoQLLEgkNLwWxhgVCJu+dPgNUw
        C4hL3HoynwnEFhGokLi58wITyAJmgcNMEqeeTWKF2PaNUeLR/ndgJ7EJGEp0vQU5g4ODU8BW
        YsEvDohBZhJdW7sYIWx5ieats5knMArNQnLHLCT7ZiFpmYWkZQEjyypGkdTS4tz03GIjveLE
        3OLSvHS95PzcTYzAaN527OeWHYwrX33UO8TIxMF4iFGCg1lJhFfwxY8kId6UxMqq1KL8+KLS
        nNTiQ4ymwMCYyCwlmpwPTCd5JfGGZgamhiZmlgamlmbGSuK8ngUdiUIC6YklqdmpqQWpRTB9
        TBycUg1Ms09Ghb9xuHzO4nlJg/HB9DXxR44xuL9p+TXnwcOqPO69/at/mU7b8Tzyyon56c9Z
        BXrO7L0hNL86SrEuxFScm7ujPjQraH/gqes79jdz77X4PMHT6PJzfoa67RwzXyt+jb4vGj39
        k/TFmBQusfMCHGJ7n747Fn5qzysGpusfV1rZTK1Y3VS4pt5T64Tj7XzLp+FRondLJQ49N/us
        +DrLM/i1slVFvWIAx1Kv2OW1fF3sPS7ZivFH2YzmX1uvXL1gxpvXB1dfcilNuLZDYMvE5TL3
        rxhrpZ1f0S3mLMLGzflJJ+jdy4Xipc+mznj0f92hzvnHXW7Jz3iau+q4AYPj+pzb6t72vLrW
        vFHJi1N2KrEUZyQaajEXFScCAKFVjIhvAwAA
X-CMS-MailID: 20220816111824eucas1p2719a48c792ba5676c89378c9090a83c7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220812111948eucas1p2bf97e7f4558eb024f419346367a87b45
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220812111948eucas1p2bf97e7f4558eb024f419346367a87b45
References: <20220801233403.258871-1-f.fainelli@gmail.com>
        <CGME20220812111948eucas1p2bf97e7f4558eb024f419346367a87b45@eucas1p2.samsung.com>
        <27016cc0-f228-748b-ea03-800dda4e5f0c@samsung.com>
        <8c21e530-8e8f-ce2a-239e-9d3a354996cf@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12.08.2022 18:32, Florian Fainelli wrote:
> On 8/12/22 04:19, Marek Szyprowski wrote:
>> Hi All,
>>
>> On 02.08.2022 01:34, Florian Fainelli wrote:
>>> Calling mdio_bus_phy_resume() with neither the PHY state machine set to
>>> PHY_HALTED nor phydev->mac_managed_pm set to true is a good indication
>>> that we can produce a race condition looking like this:
>>>
>>> CPU0                        CPU1
>>> bcmgenet_resume
>>>    -> phy_resume
>>>      -> phy_init_hw
>>>    -> phy_start
>>>      -> phy_resume
>>> phy_start_aneg()
>>> mdio_bus_phy_resume
>>>    -> phy_resume
>>>       -> phy_write(..., BMCR_RESET)
>>>        -> usleep()                                  -> phy_read()
>>>
>>> with the phy_resume() function triggering a PHY behavior that might 
>>> have
>>> to be worked around with (see bf8bfc4336f7 ("net: phy: broadcom: Fix
>>> brcm_fet_config_init()") for instance) that ultimately leads to an 
>>> error
>>> reading from the PHY.
>>>
>>> Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC 
>>> driver manages PHY PM")
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>
>> This patch, as probably intended, triggers a warning during system
>> suspend/resume cycle in the SMSC911x driver. I've observed it on ARM
>> Juno R1 board on the kernel compiled from next-202208010:
>>
>>    ------------[ cut here ]------------
>>    WARNING: CPU: 1 PID: 398 at drivers/net/phy/phy_device.c:323
>> mdio_bus_phy_resume+0x34/0xc8
>>    Modules linked in: smsc911x cpufreq_powersave cpufreq_conservative
>> crct10dif_ce ip_tables x_tables ipv6 [last unloaded: smsc911x]
>>    CPU: 1 PID: 398 Comm: rtcwake Not tainted 5.19.0+ #940
>>    Hardware name: ARM Juno development board (r1) (DT)
>>    pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>>    pc : mdio_bus_phy_resume+0x34/0xc8
>>    lr : dpm_run_callback+0x74/0x350
>>    ...
>>    Call trace:
>>     mdio_bus_phy_resume+0x34/0xc8
>>     dpm_run_callback+0x74/0x350
>>     device_resume+0xb8/0x258
>>     dpm_resume+0x120/0x4a8
>>     dpm_resume_end+0x14/0x28
>>     suspend_devices_and_enter+0x164/0xa60
>>     pm_suspend+0x25c/0x3a8
>>     state_store+0x84/0x108
>>     kobj_attr_store+0x14/0x28
>>     sysfs_kf_write+0x60/0x70
>>     kernfs_fop_write_iter+0x124/0x1a8
>>     new_sync_write+0xd0/0x190
>>     vfs_write+0x208/0x478
>>     ksys_write+0x64/0xf0
>>     __arm64_sys_write+0x14/0x20
>>     invoke_syscall+0x40/0xf8
>>     el0_svc_common.constprop.3+0x8c/0x120
>>     do_el0_svc+0x28/0xc8
>>     el0_svc+0x48/0xd0
>>     el0t_64_sync_handler+0x94/0xb8
>>     el0t_64_sync+0x15c/0x160
>>    irq event stamp: 24406
>>    hardirqs last  enabled at (24405): [<ffff8000090c4734>]
>> _raw_spin_unlock_irqrestore+0x8c/0x90
>>    hardirqs last disabled at (24406): [<ffff8000090b3164>] 
>> el1_dbg+0x24/0x88
>>    softirqs last  enabled at (24144): [<ffff800008010488>] 
>> _stext+0x488/0x5cc
>>    softirqs last disabled at (24139): [<ffff80000809bf98>]
>> irq_exit_rcu+0x168/0x1a8
>>    ---[ end trace 0000000000000000 ]---
>>
>> I hope the above information will help fixing the driver.
>
> Yes this is catching an actual issue in the driver in that the PHY 
> state machine is still running while the system is trying to suspend. 
> We could go about fixing it in a different number of ways, though I 
> believe this one is probably correct enough to work and fix the warning:

Right, this fixes the warning (after fixing the minor compile issue, see 
below).

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

>
> diff --git a/drivers/net/ethernet/smsc/smsc911x.c 
> b/drivers/net/ethernet/smsc/smsc911x.c
> index 3bf20211cceb..e9c0668a4dc0 100644
> --- a/drivers/net/ethernet/smsc/smsc911x.c
> +++ b/drivers/net/ethernet/smsc/smsc911x.c
> @@ -1037,6 +1037,8 @@ static int smsc911x_mii_probe(struct net_device 
> *dev)
>                 return ret;
>         }
>
> +       /* Indicate that the MAC is responsible for managing PHY PM */
> +       phydev->mac_managed_pm = true;
>         phy_attached_info(phydev);
>
>         phy_set_max_speed(phydev, SPEED_100);
> @@ -2587,6 +2589,8 @@ static int smsc911x_suspend(struct device *dev)
>         if (netif_running(ndev)) {
>                 netif_stop_queue(ndev);
>                 netif_device_detach(ndev);
> +               if (!device_may_wakeup(dev))
> +                       phy_suspend(dev->phydev);
                         phy_suspend(ndev->phydev);
> }
>
>         /* enable wake on LAN, energy detection and the external PME
> @@ -2628,6 +2632,8 @@ static int smsc911x_resume(struct device *dev)
>         if (netif_running(ndev)) {
>                 netif_device_attach(ndev);
>                 netif_start_queue(ndev);
> +               if (!device_may_wakeup(dev))
> +                       phy_resume(dev->phydev);
                         phy_resume(ndev->phydev);
> }
>
>         return 0;
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

