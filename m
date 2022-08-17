Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D87596D8D
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 13:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbiHQLcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 07:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbiHQLct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 07:32:49 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57306B8DB
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 04:32:40 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220817113235euoutp012291e9ba3db1f3f07ad7f7b18c3fa355~MHo2MWob73119231192euoutp01h
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 11:32:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220817113235euoutp012291e9ba3db1f3f07ad7f7b18c3fa355~MHo2MWob73119231192euoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660735955;
        bh=S3bzVlsCBjK72dYdHPRLrShfY7TzZgFl1ogmAT3SI24=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=HbK8GqoGH427LX3qm07kT8N1Mb+b9+RhJfBaHA+69mrnB+OI6HuZWbcAKsa5v1dY/
         1nwSTKp/LlZJKsMpJe3BqXxIcdTdj3ixh861ZukfQHk8guvvKlq94/Zeh2mgtYLYoR
         u0rEHiLdIjxjdMtFJ8dmDy1FQEsDxGOMYkEebjqw=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220817113235eucas1p1c4b4ec10d7246f24f52e22d72b60efde~MHo1zZUuM0205002050eucas1p1a;
        Wed, 17 Aug 2022 11:32:35 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 09.D8.09580.3D1DCF26; Wed, 17
        Aug 2022 12:32:35 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220817113234eucas1p1c936c1548099113f5eab529cf37c9c61~MHo1Twnx00207502075eucas1p1q;
        Wed, 17 Aug 2022 11:32:34 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220817113234eusmtrp29a82e04a30d8ee0a0c529ea333a2d636~MHo1S56PV1344513445eusmtrp2V;
        Wed, 17 Aug 2022 11:32:34 +0000 (GMT)
X-AuditID: cbfec7f5-9adff7000000256c-b0-62fcd1d391ed
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 8B.38.09095.2D1DCF26; Wed, 17
        Aug 2022 12:32:34 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220817113234eusmtip1a857f22b521212ae48991c0120b5fbf5~MHo0eOQlY0797307973eusmtip1M;
        Wed, 17 Aug 2022 11:32:33 +0000 (GMT)
Message-ID: <af9f0842-5cdc-3ad3-fe97-193e6a96172c@samsung.com>
Date:   Wed, 17 Aug 2022 13:32:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH net] net: phy: Warn about incorrect
 mdio_bus_phy_resume() state
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <CAMuHMdXiawCULreUKZsBD0LNc3FTqMxpfM11N46OqppChT91Kw@mail.gmail.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsWy7djP87qXL/5JMvizU8Li/N1DzBZzzrew
        WDw99ojd4te7I+wWz27tZbJY9H4Gq8WFbX2sFpd3zWGz2PryHZPFoal7GS2OLRCz+DxpCqPF
        t9NvGC22tPxlsmj+9IrJgd/j8rWLzB5bVt5k8tg56y67x4JNpR6bVnWyeRw63MHosXPHZyaP
        HbdtPN7vu8rm8b/5MovH501yAdxRXDYpqTmZZalF+nYJXBlfHsxgKjikWLFz1VnmBsYGyS5G
        Tg4JAROJ41ufsnQxcnEICaxglFi65QcrhPOFUaLh1yRmCOczo8SXed9YYFp+3t8ElVjOKLHr
        4D2o/o+MEj+PrGcDqeIVsJP48fMtkM3BwSKgKrFthypEWFDi5MwnYINEBZIlnv1fzA5iCwuE
        SpyY1ssKYjMLiEvcejKfCaRVRCBCYuqqZJDxzAKNLBLTHtxmBKlhEzCU6HrbBbaKUyBQ4u60
        RcwQvfIS29/OYYY49DCnRFefJYTtIjH50j2oB4QlXh3fwg5hy0j83wmxS0IgX+LvDGOIcIXE
        tddroMZYS9w59wvsE2YBTYn1u/Qhwo4Sy1pWQHXySdx4KwhxAJ/EpG3TmSHCvBIdbUIQ1WoS
        s46vg9t58MIl5gmMSrOQgmQWktdnIXllFsLeBYwsqxjFU0uLc9NTi43zUsv1ihNzi0vz0vWS
        83M3MQJT4Ol/x7/uYFzx6qPeIUYmDsZDjBIczEoivIIvfiQJ8aYkVlalFuXHF5XmpBYfYpTm
        YFES503O3JAoJJCeWJKanZpakFoEk2Xi4JRqYJrNsd1yfzm/0JIbaZ7u0tlld5L82tXfRr68
        Z7IvxmK20qLz3Xb675vnH8vbqPmn9/q1mcun9Kk9K8otYShd/7p6dfHXsilfNqTW6m/Uesq5
        jytNuDOy92u/XWLoJwPFf1/vMJtILl1eEVSxKLpyYcn8FmXpvRssNgleuaTX8WTFBW63vpWl
        jG4//J5fNF8gIqw2aeXOtDnX+v0fv86/uWVR+WuDj698mgRT94ZbnL/YIXNAwdwi9Phq3WVi
        VpEL+lcmvf2p0nLS+C+zZDnjlYqZ8zbuvOTSIq1zgvFvV8msHZd0U29UMPH8je4X3yw255fj
        usaC7nty6p4JzLwvF6jfulYgv9P0Oddf5hfe85RYijMSDbWYi4oTAShYMhvwAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t/xu7qXLv5JMnh3Qd/i/N1DzBZzzrew
        WDw99ojd4te7I+wWz27tZbJY9H4Gq8WFbX2sFpd3zWGz2PryHZPFoal7GS2OLRCz+DxpCqPF
        t9NvGC22tPxlsmj+9IrJgd/j8rWLzB5bVt5k8tg56y67x4JNpR6bVnWyeRw63MHosXPHZyaP
        HbdtPN7vu8rm8b/5MovH501yAdxRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZG
        pkr6djYpqTmZZalF+nYJehlfHsxgKjikWLFz1VnmBsYGyS5GTg4JAROJn/c3MXcxcnEICSxl
        lNh29TobREJG4uS0BlYIW1jiz7UusLiQwHtGiceNkSA2r4CdxI+fb4HiHBwsAqoS23aoQoQF
        JU7OfMICYosKJEssOLQUzBYWCJW4e/4EO4jNLCAucevJfCYQW0QgQuJiyzsWkBuYBVpZJCat
        f8wIcdB2Zom+h1/BOtgEDCW63kIcwSkQKHF32iJmiElmEl1buxghbHmJ7W/nME9gFJqF5JBZ
        SBbOQtIyC0nLAkaWVYwiqaXFuem5xYZ6xYm5xaV56XrJ+bmbGIGxv+3Yz807GOe9+qh3iJGJ
        g/EQowQHs5IIr+CLH0lCvCmJlVWpRfnxRaU5qcWHGE2BgTGRWUo0OR+YfPJK4g3NDEwNTcws
        DUwtzYyVxHk9CzoShQTSE0tSs1NTC1KLYPqYODilGpg2rpuscU3kfmCpzCfeGfLnCvc3TjS7
        1rfom25+1Y4lpia3Jj/3fWQeKnzwVKBrQB6nw+cWUx/LnkOtH5M2blveEqjF1yejpbxdssBg
        js5tpvtVM+XWtS+ZtUQ6eZbJG47fJSe4mrWKpt2wmcPQXSMQvcAsfFVy3TrpR8+Mfwq4/Z0x
        S1jTSbJhhZhdxap1S2YUcfGwvZrcu7EptXHZvk9CjauyHVfU8q6Rnrd+QmWN4hbVxVu9BJ9M
        lo0vesPw7pl5Tbnkg+czHv5X9M29uTBd/efimNT/Pu+q8tJS9I/P2Drpf6fLwguv5xQ/5lTg
        3/VvUQ7Pl0//zU946ggum+8t9v7bVwtP2eL/jteTudmUWIozEg21mIuKEwEPJRYFhgMAAA==
X-CMS-MailID: 20220817113234eucas1p1c936c1548099113f5eab529cf37c9c61
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
        <CAMuHMdV8vsbFx+nikAwn1po1-PeZVhzotMaLLk+wXNquZceaRQ@mail.gmail.com>
        <c1301f39-9202-5eee-a0f6-9c0b66f2dccf@gmail.com>
        <CAMuHMdXiawCULreUKZsBD0LNc3FTqMxpfM11N46OqppChT91Kw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.08.2022 11:18, Geert Uytterhoeven wrote:
> On Wed, Aug 17, 2022 at 4:28 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>> On 8/16/2022 6:20 AM, Geert Uytterhoeven wrote:
>>> On Fri, Aug 12, 2022 at 6:39 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>>> On 8/12/22 04:19, Marek Szyprowski wrote:
>>>>> On 02.08.2022 01:34, Florian Fainelli wrote:
>>>>>> Calling mdio_bus_phy_resume() with neither the PHY state machine set to
>>>>>> PHY_HALTED nor phydev->mac_managed_pm set to true is a good indication
>>>>>> that we can produce a race condition looking like this:
>>>>>>
>>>>>> CPU0                                         CPU1
>>>>>> bcmgenet_resume
>>>>>>      -> phy_resume
>>>>>>        -> phy_init_hw
>>>>>>      -> phy_start
>>>>>>        -> phy_resume
>>>>>>                                                     phy_start_aneg()
>>>>>> mdio_bus_phy_resume
>>>>>>      -> phy_resume
>>>>>>         -> phy_write(..., BMCR_RESET)
>>>>>>          -> usleep()                                  -> phy_read()
>>>>>>
>>>>>> with the phy_resume() function triggering a PHY behavior that might have
>>>>>> to be worked around with (see bf8bfc4336f7 ("net: phy: broadcom: Fix
>>>>>> brcm_fet_config_init()") for instance) that ultimately leads to an error
>>>>>> reading from the PHY.
>>>>>>
>>>>>> Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
>>>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>>> This patch, as probably intended, triggers a warning during system
>>>>> suspend/resume cycle in the SMSC911x driver. I've observed it on ARM
>>>>> Juno R1 board on the kernel compiled from next-202208010:
>>>>>
>>>>>      ------------[ cut here ]------------
>>>>>      WARNING: CPU: 1 PID: 398 at drivers/net/phy/phy_device.c:323
>>>>> mdio_bus_phy_resume+0x34/0xc8
>>> I am seeing the same on the ape6evm and kzm9g development
>>> boards with smsc911x Ethernet, and on various boards with Renesas
>>> Ethernet (sh_eth or ravb) if Wake-on-LAN is disabled.
>>>
>>>> Yes this is catching an actual issue in the driver in that the PHY state
>>>> machine is still running while the system is trying to suspend. We could
>>>> go about fixing it in a different number of ways, though I believe this
>>>> one is probably correct enough to work and fix the warning:
>>>> --- a/drivers/net/ethernet/smsc/smsc911x.c
>>>> +++ b/drivers/net/ethernet/smsc/smsc911x.c
>>>> @@ -1037,6 +1037,8 @@ static int smsc911x_mii_probe(struct net_device *dev)
>>>>                    return ret;
>>>>            }
>>>>
>>>> +       /* Indicate that the MAC is responsible for managing PHY PM */
>>>> +       phydev->mac_managed_pm = true;
>>>>            phy_attached_info(phydev);
>>>>
>>>>            phy_set_max_speed(phydev, SPEED_100);
>>>> @@ -2587,6 +2589,8 @@ static int smsc911x_suspend(struct device *dev)
>>>>            if (netif_running(ndev)) {
>>>>                    netif_stop_queue(ndev);
>>>>                    netif_device_detach(ndev);
>>>> +               if (!device_may_wakeup(dev))
>>>> +                       phy_suspend(dev->phydev);
>>>>            }
>>>>
>>>>            /* enable wake on LAN, energy detection and the external PME
>>>> @@ -2628,6 +2632,8 @@ static int smsc911x_resume(struct device *dev)
>>>>            if (netif_running(ndev)) {
>>>>                    netif_device_attach(ndev);
>>>>                    netif_start_queue(ndev);
>>>> +               if (!device_may_wakeup(dev))
>>>> +                       phy_resume(dev->phydev);
>>>>            }
>>>>
>>>>            return 0;
>>> Thanks for your patch, but unfortunately this does not work on ape6evm
>>> and kzm9g, where the smsc911x device is connected to a power-managed
>>> bus.  It looks like the PHY registers are accessed while the device
>>> is already suspended, causing a crash during system suspend:
>> Does it work better if you replace phy_suspend() with phy_stop() and
>> phy_resume() with phy_start()?
> Thank you, much better!
> Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

It also works for me.

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

