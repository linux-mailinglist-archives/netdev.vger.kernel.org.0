Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEFD590FF3
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 13:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbiHLLUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 07:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiHLLT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 07:19:58 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C051AA4D9
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 04:19:54 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220812111949euoutp02832541225f76ee173a85ea7bdbfa091a~KlPQshCn_1188311883euoutp021
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 11:19:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220812111949euoutp02832541225f76ee173a85ea7bdbfa091a~KlPQshCn_1188311883euoutp021
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660303189;
        bh=wO8hdbryY0sm32FNDU5Z3KbpOXWIqd/1YwOt9Mkpv7k=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=Ge+PPFXD6wGTS4Nc/m2JFdaWxPUzrwrGz+2ggxSTtU7QEGKB4z41xj2PAstJ0f049
         jpixEPKw5Sf4OlUY/HBxVW1kNflrwXdtrD+QiawxTpn2szqGyyavyb+uqtBTG+WUsV
         bkVuF3vnIMCygmd5bQ1stwFU18wzo7VFFqs/+8ZE=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220812111948eucas1p296e40a57115e095f353f54c8e78988e2~KlPQNgBKI0686106861eucas1p2M;
        Fri, 12 Aug 2022 11:19:48 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 41.D6.10067.45736F26; Fri, 12
        Aug 2022 12:19:48 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220812111948eucas1p2bf97e7f4558eb024f419346367a87b45~KlPPsbNQi2071120711eucas1p2L;
        Fri, 12 Aug 2022 11:19:48 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220812111947eusmtrp1db526300ab355bde6559b55e234726e0~KlPProDkn2568325683eusmtrp1X;
        Fri, 12 Aug 2022 11:19:47 +0000 (GMT)
X-AuditID: cbfec7f4-dd7ff70000002753-e5-62f63754612c
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id E4.93.09038.35736F26; Fri, 12
        Aug 2022 12:19:47 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220812111947eusmtip21a68c6fb8ed7a1f3757a752b83138358~KlPPBpTmS0418004180eusmtip2h;
        Fri, 12 Aug 2022 11:19:47 +0000 (GMT)
Message-ID: <27016cc0-f228-748b-ea03-800dda4e5f0c@samsung.com>
Date:   Fri, 12 Aug 2022 13:19:47 +0200
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
In-Reply-To: <20220801233403.258871-1-f.fainelli@gmail.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfUgTcRjud3fbbqvFObP9stJYaRppWZEXlX2QdEFBhBEYVqcebswvNqcm
        fay00qFSWrouQUltJmY1TFOyj61mNWmZaRmlohbmZmYrKSnN7frwv+d93+f5Pe/z8sNRiYXn
        jSsSUxhVIh0v44uwesuPZ0ERoWPRK4fzfUnbOxNKltiyMPK9pU9Ajn96KCAvj+h55PP6fB7Z
        3lTCJ00XmgFpKZtLOgvOA3LM6gBk5pchZPMsqr2zDaXqrnYhVCP7TkCVGTWUsTqHTzXediLU
        yN0OPjWZ2Y5RTqPPbmGkaEMsE69IZVQrwg6J5LZaC5JsXZie3/YW1YKPUh3AcUisgbYvkTog
        wiVEFYDt42cQrvgKoPnlfQFXOAH86RjEdEDoVvRmagE3MABY1dnD44rRKX1tId/FEhNh0FBQ
        KXBhjPCDWWw54Poe8MnFAfdLXkQM/DBZ7uZ4Envh46I8ngujhBS+GShFXHgOkQ4735vda6CE
        GYH27mI3iU+EQN2wzm0mJNbDilY7xol9YeatS6hLAIlSIWxi21Au6TZYYz3ARfCEQy11Ag4v
        gNbCXIyjJMFf+tVce8rXXoNyeD18+2yc76KgRCC83rSCa2+BV7KqEE45G74e9uAWmA0L6ov/
        eIph9mkJx/aHbEvtP88Hz1+gZ4GMnXYTdlp2dloU9r9vGcCqgZTRqBPiGPWqRCYtWE0nqDWJ
        ccExSQlGMPXVrBMtX28Dw9BosAkgODABiKOyOeLUy85oiTiWPpzBqJIOqjTxjNoE5uOYTCqO
        UdygJUQcncIoGSaZUf2dIrjQW4tsOrp/goi5t+rp8pXNS9MdR3J3mYMUgc0eLxbbe4BPctra
        RaQeOzbzW0CHP+3XMVY5IlnoxT7KsjtSsYb4W0rF2PET28GMkEk0LXBfdULlJ8x/IJa3pyt0
        0zkkSs7LTUL8/aINtmLlKYM8FO1rlJ/MmMuc+Igs6QI2z9bS0YkDZ8Lkg1GvloUXzZvIGSxX
        7oqi8qRFju87I5Ubxm37+oUlKXjeOnPOjuoZ2pq7EVt5DVtHLHfOfhd1Zt/pV2qzu1MX/BqY
        93DWTt86Db06/V5Af5dPWWvvWmP2xm36lMBrV70aMm72FlfMnFT1b/kRuYcJL4wIWOxdoQj6
        3H1BX+snw9RyOmQZqlLTvwGNzQbG2QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t/xe7rB5t+SDC5vMbU4f/cQs8Wc8y0s
        Fk+PPWK3+PXuCLvFovczWC0ubOtjtbi8aw6bxaGpexktji0Qs/g8aQqjxbfTbxgtmj+9YnLg
        8bh87SKzx5aVN5k8ds66y+6xYFOpx6ZVnWweO3d8ZvJ4v+8qm8f/5sssHp83yQVwRunZFOWX
        lqQqZOQXl9gqRRtaGOkZWlroGZlY6hkam8daGZkq6dvZpKTmZJalFunbJehlnF93jKngtGxF
        38U7zA2ML8W7GDk5JARMJB40NzB2MXJxCAksZZS4eL+BBSIhI3FyWgMrhC0s8edaFxtE0XtG
        iSnT/zGBJHgF7CSWT1rKDmKzCKhKtMxazAgRF5Q4OfMJ2CBRgWSJBYeWgtnCAqESd8+fAKtn
        FhCXuPVkPtgcEYEKiZs7LzCBLGAWOMwkcerZJLDNQgJWEhO2nAcbyiZgKNH1FuQKTg5OAWuJ
        JWdes0AMMpPo2trFCGHLSzRvnc08gVFoFpI7ZiHZNwtJyywkLQsYWVYxiqSWFuem5xYb6RUn
        5haX5qXrJefnbmIERvO2Yz+37GBc+eqj3iFGJg7GQ4wSHMxKIrxliz4nCfGmJFZWpRblxxeV
        5qQWH2I0BQbGRGYp0eR8YDrJK4k3NDMwNTQxszQwtTQzVhLn9SzoSBQSSE8sSc1OTS1ILYLp
        Y+LglGpgWsgqcrKr5FO7/tfFp5dzVVwt+bNw8qpX/5uZamsfdX05/CZXyzjEqTiR9+2xWzP9
        1jgaXbIRvLZAe7FfltVetYetl6qyWJVyHU8tN7+5x8y4rZJhmXAM4/ZI9soG+73LlVhq3Ks+
        WEbtS53Fqz7r6+faK2JPQjUDEjLsc9pvH6+4XMrj8WftuUpX36dH51fsV9ywZOnsnlLudyxZ
        Wu9DLh50t29bav2DQaz7SPP07TGhG1a92rhc5uBZu6+ZT6x7Mp4GNr8O6jhzL99JQsb3+qlN
        WzI3VC63cd4n9tFhtrSPIrea1NFn3ZfPHUvmfb15/oXJG+895zJk6jat9jtyhbfu6n2XI0Ll
        K3hTBIqklFiKMxINtZiLihMBDLIQ228DAAA=
X-CMS-MailID: 20220812111948eucas1p2bf97e7f4558eb024f419346367a87b45
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220812111948eucas1p2bf97e7f4558eb024f419346367a87b45
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220812111948eucas1p2bf97e7f4558eb024f419346367a87b45
References: <20220801233403.258871-1-f.fainelli@gmail.com>
        <CGME20220812111948eucas1p2bf97e7f4558eb024f419346367a87b45@eucas1p2.samsung.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

On 02.08.2022 01:34, Florian Fainelli wrote:
> Calling mdio_bus_phy_resume() with neither the PHY state machine set to
> PHY_HALTED nor phydev->mac_managed_pm set to true is a good indication
> that we can produce a race condition looking like this:
>
> CPU0						CPU1
> bcmgenet_resume
>   -> phy_resume
>     -> phy_init_hw
>   -> phy_start
>     -> phy_resume
>                                                  phy_start_aneg()
> mdio_bus_phy_resume
>   -> phy_resume
>      -> phy_write(..., BMCR_RESET)
>       -> usleep()                                  -> phy_read()
>
> with the phy_resume() function triggering a PHY behavior that might have
> to be worked around with (see bf8bfc4336f7 ("net: phy: broadcom: Fix
> brcm_fet_config_init()") for instance) that ultimately leads to an error
> reading from the PHY.
>
> Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

This patch, as probably intended, triggers a warning during system 
suspend/resume cycle in the SMSC911x driver. I've observed it on ARM 
Juno R1 board on the kernel compiled from next-202208010:

  ------------[ cut here ]------------
  WARNING: CPU: 1 PID: 398 at drivers/net/phy/phy_device.c:323 
mdio_bus_phy_resume+0x34/0xc8
  Modules linked in: smsc911x cpufreq_powersave cpufreq_conservative 
crct10dif_ce ip_tables x_tables ipv6 [last unloaded: smsc911x]
  CPU: 1 PID: 398 Comm: rtcwake Not tainted 5.19.0+ #940
  Hardware name: ARM Juno development board (r1) (DT)
  pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : mdio_bus_phy_resume+0x34/0xc8
  lr : dpm_run_callback+0x74/0x350
  ...
  Call trace:
   mdio_bus_phy_resume+0x34/0xc8
   dpm_run_callback+0x74/0x350
   device_resume+0xb8/0x258
   dpm_resume+0x120/0x4a8
   dpm_resume_end+0x14/0x28
   suspend_devices_and_enter+0x164/0xa60
   pm_suspend+0x25c/0x3a8
   state_store+0x84/0x108
   kobj_attr_store+0x14/0x28
   sysfs_kf_write+0x60/0x70
   kernfs_fop_write_iter+0x124/0x1a8
   new_sync_write+0xd0/0x190
   vfs_write+0x208/0x478
   ksys_write+0x64/0xf0
   __arm64_sys_write+0x14/0x20
   invoke_syscall+0x40/0xf8
   el0_svc_common.constprop.3+0x8c/0x120
   do_el0_svc+0x28/0xc8
   el0_svc+0x48/0xd0
   el0t_64_sync_handler+0x94/0xb8
   el0t_64_sync+0x15c/0x160
  irq event stamp: 24406
  hardirqs last  enabled at (24405): [<ffff8000090c4734>] 
_raw_spin_unlock_irqrestore+0x8c/0x90
  hardirqs last disabled at (24406): [<ffff8000090b3164>] el1_dbg+0x24/0x88
  softirqs last  enabled at (24144): [<ffff800008010488>] _stext+0x488/0x5cc
  softirqs last disabled at (24139): [<ffff80000809bf98>] 
irq_exit_rcu+0x168/0x1a8
  ---[ end trace 0000000000000000 ]---

I hope the above information will help fixing the driver.

> ---
>   drivers/net/phy/phy_device.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 46acddd865a7..608de5a94165 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -316,6 +316,12 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
>   
>   	phydev->suspended_by_mdio_bus = 0;
>   
> +	/* If we managed to get here with the PHY state machine in a state other
> +	 * than PHY_HALTED this is an indication that something went wrong and
> +	 * we should most likely be using MAC managed PM and we are not.
> +	 */
> +	WARN_ON(phydev->state != PHY_HALTED && !phydev->mac_managed_pm);
> +
>   	ret = phy_init_hw(phydev);
>   	if (ret < 0)
>   		return ret;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

