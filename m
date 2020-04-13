Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59B41A69AC
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 18:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731425AbgDMQRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 12:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731412AbgDMQRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 12:17:34 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E963C0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 09:17:33 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id p10so10712319wrt.6
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 09:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZMes6k5E63hf5JYKPSPIdshRuUcP8NRkdIwvL/Dg1D0=;
        b=WskZ03qlo+Zuh5Jcj+i1YeMa0OM5N7SlmTMz+BwuArzjw6gfhWBFaRjgGnaucAVc0r
         qRqku9+RJ+8gaOgMsVnLwGYNtLhTZBC0GpHXuObeOP64ZDttD+RspI023lFvRRbmsF5Q
         TzhFFfF/TocpdMmCq95HqN+9nMjj4bMESKoeksDpfFeE5nk0YohclDFiJ/HALfvh9mGE
         jWxBOz0vNq9v4aoy8hKfwMxBmWmZdvJsp7toV3IMiS7b+9/kZWEfFHeuRXMJ3DGNKv5C
         mhnzJCNfc8I4m74J77THqdkJLhqUvsGyPYKZdWnH3xRWeATwTSYA/d5QUsvfANI5XY6h
         Zxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZMes6k5E63hf5JYKPSPIdshRuUcP8NRkdIwvL/Dg1D0=;
        b=s6unmb8+idbr1v+FePgDl0nbs8+EtoQ+chN+nJONiBYDs/L4boj5Kwuo2A/tSgErSH
         mHTJibFJnsE36tqrcQIU1ZGaCZUr16sXhxbLW76zFeAWfwZxKycwfIcbHY2c5Y8fMGcO
         NNNobKRftXCV2eZorYb2AQfK11yAbpmhfpKteeCmtbnnyf7KTGOaaYbvFAmpd/WpgP9H
         5W8WH89vCkcV/8rfRMJBJg3OkIUUnbDU5x/uzGb5FU4jD5IU+gFPQTUOnEet3fbqSDzO
         TGsSqdK4AzediNkDi0/WXgUxF7iZhaHyXIGz2i0cZBPeWNeu0DxZaukzp35p2SH82Rkz
         gQCw==
X-Gm-Message-State: AGi0PuZ0CBMvfBoqxQLqXiw7GnWKBqC0+5mnTHO7+E9hkBldjHVRKfjI
        EWbOw1EkaHo2sP5RWd9HrCw=
X-Google-Smtp-Source: APiQypIl/GMYQQJTXnb4IRlE3H7pJqJ7IU2Bxxt4aJqmvqseON0OA5QD6gXeAOBF2SdCbUOMOYCR6g==
X-Received: by 2002:adf:f508:: with SMTP id q8mr3948931wro.117.1586794652210;
        Mon, 13 Apr 2020 09:17:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:ecd0:ef61:dfee:4535? (p200300EA8F296000ECD0EF61DFEE4535.dip0.t-ipconnect.de. [2003:ea:8f29:6000:ecd0:ef61:dfee:4535])
        by smtp.googlemail.com with ESMTPSA id w83sm15530962wmb.37.2020.04.13.09.17.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 09:17:31 -0700 (PDT)
Subject: Re: NET: r8168/r8169 identifying fix
To:     Lauri Jakku <lauri.jakku@pp.inet.fi>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <20200413105838.GK334007@unreal>
 <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
 <20200413113430.GM334007@unreal>
 <06489204-2bec-fe64-4dbd-7abe4c585c23@pp.inet.fi>
 <20200413121858.GN334007@unreal>
 <bcf7817f-43b0-ec45-fbfa-b3459dc67859@pp.inet.fi>
 <e17747d2-d623-e565-3e90-eb671e61a2dd@gmail.com>
 <37d9b586-71e4-4cb2-412e-f37caefcc3f4@pp.inet.fi>
 <ac71fa0a-d460-ac23-e787-2c304e5cc3bf@gmail.com>
 <a5f15ebb-10fc-4bb6-79a0-8352e036d88f@pp.inet.fi>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <6e965a73-a119-7af2-a0e4-0775602276fe@gmail.com>
Date:   Mon, 13 Apr 2020 18:17:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a5f15ebb-10fc-4bb6-79a0-8352e036d88f@pp.inet.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.04.2020 18:10, Lauri Jakku wrote:
> 
> 
> On 13.4.2020 18.54, Heiner Kallweit wrote:
>> On 13.04.2020 17:50, Lauri Jakku wrote:
>>> Hi,
>>>
>>> On 13.4.2020 18.33, Heiner Kallweit wrote:
>>>> On 13.04.2020 16:44, Lauri Jakku wrote:
>>>>> Hi,
>>>>>
>>>>> On 13.4.2020 15.18, Leon Romanovsky wrote:
>>>>>> On Mon, Apr 13, 2020 at 03:01:23PM +0300, Lauri Jakku wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I've tought that the debug's are worth to save behind an definition/commented out, so they can be enabled if needed.
>>>>>>>
>>>>>>
>>>>>> Please stop to do top-posting.
>>>>>
>>>>>  I did not realise, sorry. Trying to do better.
>>>>>
>>>>>>
>>>>>>>
>>>>>>> Latest version:
>>>>>>>
>>>>>>> From 1a75f6f9065a58180de1fa3c48fd80418af6c347 Mon Sep 17 00:00:00 2001
>>>>>>> From: Lauri Jakku <lja@iki.fi>
>>>>>>> Date: Mon, 13 Apr 2020 13:18:35 +0300
>>>>>>> Subject: [PATCH] NET: r8168/r8169 identifying fix
>>>>>>>
>>>>>>> The driver installation determination made properly by
>>>>>>> checking PHY vs DRIVER id's.
>>>>>>> ---
>>>>>>>  drivers/net/ethernet/realtek/r8169_main.c | 114 ++++++++++++++++++++--
>>>>>>>  drivers/net/phy/mdio_bus.c                |  15 ++-
>>>>>>>  2 files changed, 119 insertions(+), 10 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>> index bf5bf05970a2..5e992f285527 100644
>>>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>> @@ -61,6 +61,11 @@
>>>>>>>  #define R8169_MSG_DEFAULT \
>>>>>>>  	(NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | NETIF_MSG_IFDOWN)
>>>>>>>
>>>>>>> +
>>>>>>> +/*
>>>>>>> +#define R8169_PROBE_DEBUG
>>>>>>> +*/
>>>>>>
>>>>>> Of course not, it is even worse than before.
>>>>>> If user recompiles module, he will add prints.
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>
>>>>> New patch at the end and in attachments.
>>>>>
>>>> Please do as suggested and read through the kernel developer beginners
>>>> guides first. The patch itself, and sending patches as attachments
>>>> is not acceptable.
>>>>
>>>> Please provide the requested logs and information first so that we can
>>>> understand your issue.
>>>>
>>>
>>> I'm compiling newest patch + 5.6.2-2 and I'll then provide logs from 
>>> 5.3, 5.4 and 5.6 (without and with the patch).
>>>
>>> steps i take:
>>> 1. power off computer properly
>>> 2. take output of dmesg 
>>> 3. take output of ip link
>>>
>>> Initramfs does have libphy, realtek and r8169 modules added.
>>>
>> Typically you need the network driver in initramfs only when
>> loading rootfs from network, e.g. via NFS.
>> How is it if you remove r8169 from initramfs?
>>
> 
> Hmm, I'm using Manjaro's stock packages for kernels. I removed
> modules from mkinitcpio.conf and reinstall the kernel packages
> now. i check do they have them installed. 
> 
> One thing that I've noticed is that when doing reboot, the NIC
> does not work ok after bootup. When proper power cycle is done
> the NIC works ok, so something in settings etc. does not reset.
> 
> I check if adding reset to driver's probe helps, i make diffrent
> patch for that.
> 
No need for such a patch, probe is resetting the chip already.
Best provide a dmesg log of such a reboot.
The issue can also be caused by a BIOS bug, as I don't see
this behavior on my systems.

> 
>>> This wille take some time, i try to provide the logs today.
>>>
>>> Do you like if they are provided in tar per configuration, or 
>>> how ?
>>>
>> The logs you can attach to the mail (name them properly).
>>
>>> I make the commit message have log of problem and log of solution
>>> case.
>>>
>>>
>>>>>
>>>>>>> +
>>>>>>>  /* Maximum number of multicast addresses to filter (vs. Rx-all-multicast).
>>>>>>>     The RTL chips use a 64 element hash table based on the Ethernet CRC. */
>>>>>>>  #define	MC_FILTER_LIMIT	32
>>>>>>> @@ -5149,6 +5154,9 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>>>>>>  {
>>>>>>>  	struct pci_dev *pdev = tp->pci_dev;
>>>>>>>  	struct mii_bus *new_bus;
>>>>>>> +	u32 phydev_id = 0;
>>>>>>> +	u32 phydrv_id = 0;
>>>>>>> +	u32 phydrv_id_mask = 0;
>>>>>>>  	int ret;
>>>>>>>
>>>>>>>  	new_bus = devm_mdiobus_alloc(&pdev->dev);
>>>>>>> @@ -5165,20 +5173,69 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>>>>>>  	new_bus->write = r8169_mdio_write_reg;
>>>>>>>
>>>>>>>  	ret = mdiobus_register(new_bus);
>>>>>>> +
>>>>>>> +#ifdef R8169_PROBE_DEBUG
>>>>>>> +	dev_info(&pdev->dev,
>>>>>>> +		 "mdiobus_register: %s, %d\n",
>>>>>>> +		 new_bus->id, ret);
>>>>>>> +#endif
>>>>>>>  	if (ret)
>>>>>>>  		return ret;
>>>>>>>
>>>>>>>  	tp->phydev = mdiobus_get_phy(new_bus, 0);
>>>>>>> +
>>>>>>>  	if (!tp->phydev) {
>>>>>>>  		mdiobus_unregister(new_bus);
>>>>>>>  		return -ENODEV;
>>>>>>> -	} else if (!tp->phydev->drv) {
>>>>>>> -		/* Most chip versions fail with the genphy driver.
>>>>>>> -		 * Therefore ensure that the dedicated PHY driver is loaded.
>>>>>>> -		 */
>>>>>>> -		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
>>>>>>> -		mdiobus_unregister(new_bus);
>>>>>>> -		return -EUNATCH;
>>>>>>> +	} else {
>>>>>>> +		/* tp -> phydev ok */
>>>>>>> +		int everything_OK = 0;
>>>>>>> +
>>>>>>> +		/* Check driver id versus phy */
>>>>>>> +
>>>>>>> +		if (tp->phydev->drv) {
>>>>>>> +			u32 phydev_masked = 0xBEEFDEAD;
>>>>>>> +			u32 drv_masked = ~0;
>>>>>>> +			u32 phydev_match = ~0;
>>>>>>> +			u32 drv_match = 0xDEADBEEF;
>>>>>>> +
>>>>>>> +			phydev_id = tp->phydev->phy_id;
>>>>>>> +			phydrv_id = tp->phydev->drv->phy_id;
>>>>>>> +			phydrv_id_mask = tp->phydev->drv->phy_id_mask;
>>>>>>> +
>>>>>>> +			drv_masked = phydrv_id & phydrv_id_mask;
>>>>>>> +			phydev_masked = phydev_id & phydrv_id_mask;
>>>>>>> +
>>>>>>> +#ifdef R8169_PROBE_DEBUG
>>>>>>> +			dev_debug(&pdev->dev,
>>>>>>> +				  "%s: ID Check: (%x -> %x), drv (%x -> %x)\n",
>>>>>>> +				new_bus->id, phydev_id, phydev_masked,
>>>>>>> +				phydrv_id, drv_masked);
>>>>>>> +#endif
>>>>>>> +
>>>>>>> +			phydev_match = phydev_masked & drv_masked;
>>>>>>> +			phydev_match = phydev_match == phydev_masked;
>>>>>>> +
>>>>>>> +			drv_match = phydev_masked & drv_masked;
>>>>>>> +			drv_match = drv_match == drv_masked;
>>>>>>> +
>>>>>>> +#ifdef R8169_PROBE_DEBUG
>>>>>>> +			dev_debug(&pdev->dev, "%s: ID Check: %x == %x\n",
>>>>>>> +				  new_bus->id, phydev_match, drv_match);
>>>>>>> +#endif
>>>>>>> +
>>>>>>> +			everything_OK = (phydev_match == drv_match);
>>>>>>> +		}
>>>>>>> +
>>>>>>> +		if (!everything_OK) {
>>>>>>> +			/* Most chip versions fail with the genphy driver.
>>>>>>> +			 * Therefore ensure that the dedicated PHY driver
>>>>>>> +			 * is loaded.
>>>>>>> +			 */
>>>>>>> +			dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
>>>>>>> +			mdiobus_unregister(new_bus);
>>>>>>> +			return -EUNATCH;
>>>>>>> +		}
>>>>>>>  	}
>>>>>>>
>>>>>>>  	/* PHY will be woken up in rtl_open() */
>>>>>>> @@ -5435,6 +5492,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>>>>>  	u64_stats_init(&tp->rx_stats.syncp);
>>>>>>>  	u64_stats_init(&tp->tx_stats.syncp);
>>>>>>>
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: MAC\n");
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	rtl_init_mac_address(tp);
>>>>>>>
>>>>>>>  	dev->ethtool_ops = &rtl8169_ethtool_ops;
>>>>>>> @@ -5483,29 +5544,64 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>>>>>  	dev->hw_features |= NETIF_F_RXFCS;
>>>>>>>
>>>>>>>  	jumbo_max = rtl_jumbo_max(tp);
>>>>>>> +
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: jumbo max: %d\n", jumbo_max);
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	if (jumbo_max)
>>>>>>>  		dev->max_mtu = jumbo_max;
>>>>>>>
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: irq mask\n");
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	rtl_set_irq_mask(tp);
>>>>>>>
>>>>>>>  	tp->fw_name = rtl_chip_infos[chipset].fw_name;
>>>>>>>
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: FW name: %s\n", tp->fw_name);
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	tp->counters = dmam_alloc_coherent (&pdev->dev, sizeof(*tp->counters),
>>>>>>>  					    &tp->counters_phys_addr,
>>>>>>>  					    GFP_KERNEL);
>>>>>>>  	if (!tp->counters)
>>>>>>>  		return -ENOMEM;
>>>>>>>
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: set driver data\n");
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	pci_set_drvdata(pdev, dev);
>>>>>>>
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: register mdio\n");
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	rc = r8169_mdio_register(tp);
>>>>>>> +
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: mdio register: %d\n", rc);
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	if (rc)
>>>>>>>  		return rc;
>>>>>>>
>>>>>>>  	/* chip gets powered up in rtl_open() */
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: pll pwr down\n");
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	rtl_pll_power_down(tp);
>>>>>>>
>>>>>>>  	rc = register_netdev(dev);
>>>>>>> +
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: netdev register: %d\n", rc);
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	if (rc)
>>>>>>>  		goto err_mdio_unregister;
>>>>>>>
>>>>>>> @@ -5525,6 +5621,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>>>>>  	if (pci_dev_run_wake(pdev))
>>>>>>>  		pm_runtime_put_sync(&pdev->dev);
>>>>>>>
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: ALL DONE!\n");
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	return 0;
>>>>>>>
>>>>>>>  err_mdio_unregister:
>>>>>>> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>>>>>>> index 522760c8bca6..41777f379a57 100644
>>>>>>> --- a/drivers/net/phy/mdio_bus.c
>>>>>>> +++ b/drivers/net/phy/mdio_bus.c
>>>>>>> @@ -112,14 +112,22 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
>>>>>>>  struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
>>>>>>>  {
>>>>>>>  	struct mdio_device *mdiodev = bus->mdio_map[addr];
>>>>>>> -
>>>>>>> +	struct phy_device *rv = NULL;
>>>>>>> +/*
>>>>>>> +	pr_debug("mii_bus %s addr %d, %p\n", bus->id, addr, mdiodev);
>>>>>>> +*/
>>>>>>>  	if (!mdiodev)
>>>>>>>  		return NULL;
>>>>>>>
>>>>>>>  	if (!(mdiodev->flags & MDIO_DEVICE_FLAG_PHY))
>>>>>>>  		return NULL;
>>>>>>>
>>>>>>> -	return container_of(mdiodev, struct phy_device, mdio);
>>>>>>> +	rv = container_of(mdiodev, struct phy_device, mdio);
>>>>>>> +/*
>>>>>>> + 	pr_debug("mii_bus OK? %s addr %d, %p -> %p\n",
>>>>>>> +		 bus->id, addr, mdiodev, rv);
>>>>>>> +*/
>>>>>>> +	return rv;
>>>>>>>  }
>>>>>>>  EXPORT_SYMBOL(mdiobus_get_phy);
>>>>>>>
>>>>>>> @@ -645,10 +653,11 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>>>>>>>  	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
>>>>>>>
>>>>>>>  	bus->state = MDIOBUS_REGISTERED;
>>>>>>> -	pr_info("%s: probed\n", bus->name);
>>>>>>> +	pr_info("%s: probed (mdiobus_register)\n", bus->name);
>>>>>>>  	return 0;
>>>>>>>
>>>>>>>  error:
>>>>>>> +	pr_err("%s: Error while in mdiobus_register: %d\n", bus->name, err);
>>>>>>>  	while (--i >= 0) {
>>>>>>>  		mdiodev = bus->mdio_map[i];
>>>>>>>  		if (!mdiodev)
>>>>>>> --
>>>>>>> 2.26.0
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On 2020-04-13 14:34, Leon Romanovsky wrote:
>>>>>>>> On Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote:
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> Comments inline.
>>>>>>>>>
>>>>>>>>> On 2020-04-13 13:58, Leon Romanovsky wrote:
>>>>>>>>>> On Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote:
>>>>>>>>>>> From 2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00 2001
>>>>>>>>>>> From: Lauri Jakku <lja@iki.fi>
>>>>>>>>>>> Date: Mon, 13 Apr 2020 13:18:35 +0300
>>>>>>>>>>> Subject: [PATCH] NET: r8168/r8169 identifying fix
>>>>>>>>>>>
>>>>>>>>>>> The driver installation determination made properly by
>>>>>>>>>>> checking PHY vs DRIVER id's.
>>>>>>>>>>> ---
>>>>>>>>>>>  drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++---
>>>>>>>>>>>  drivers/net/phy/mdio_bus.c                | 11 +++-
>>>>>>>>>>>  2 files changed, 72 insertions(+), 9 deletions(-)
>>>>>>>>>>
>>>>>>>>>> I would say that most of the code is debug prints.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> I tought that they are helpful to keep, they are using the debug calls, so
>>>>>>>>> they are not visible if user does not like those.
>>>>>>>>
>>>>>>>> You are missing the point of who are your users.
>>>>>>>>
>>>>>>>> Users want to have working device and the code. They don't need or like
>>>>>>>> to debug their kernel.
>>>>>>>>
>>>>>>>> Thanks
>>>>>>>>
>>>>>>>
>>>>>>> --
>>>>>>> Br,
>>>>>>> Lauri J.
>>>>>>
>>>>>>> From 1a75f6f9065a58180de1fa3c48fd80418af6c347 Mon Sep 17 00:00:00 2001
>>>>>>> From: Lauri Jakku <lja@iki.fi>
>>>>>>> Date: Mon, 13 Apr 2020 13:18:35 +0300
>>>>>>> Subject: [PATCH] NET: r8168/r8169 identifying fix
>>>>>>>
>>>>>>> The driver installation determination made properly by
>>>>>>> checking PHY vs DRIVER id's.
>>>>>>> ---
>>>>>>>  drivers/net/ethernet/realtek/r8169_main.c | 114 ++++++++++++++++++++--
>>>>>>>  drivers/net/phy/mdio_bus.c                |  15 ++-
>>>>>>>  2 files changed, 119 insertions(+), 10 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>> index bf5bf05970a2..5e992f285527 100644
>>>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>> @@ -61,6 +61,11 @@
>>>>>>>  #define R8169_MSG_DEFAULT \
>>>>>>>  	(NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | NETIF_MSG_IFDOWN)
>>>>>>>
>>>>>>> +
>>>>>>> +/*
>>>>>>> +#define R8169_PROBE_DEBUG
>>>>>>> +*/
>>>>>>> +
>>>>>>>  /* Maximum number of multicast addresses to filter (vs. Rx-all-multicast).
>>>>>>>     The RTL chips use a 64 element hash table based on the Ethernet CRC. */
>>>>>>>  #define	MC_FILTER_LIMIT	32
>>>>>>> @@ -5149,6 +5154,9 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>>>>>>  {
>>>>>>>  	struct pci_dev *pdev = tp->pci_dev;
>>>>>>>  	struct mii_bus *new_bus;
>>>>>>> +	u32 phydev_id = 0;
>>>>>>> +	u32 phydrv_id = 0;
>>>>>>> +	u32 phydrv_id_mask = 0;
>>>>>>>  	int ret;
>>>>>>>
>>>>>>>  	new_bus = devm_mdiobus_alloc(&pdev->dev);
>>>>>>> @@ -5165,20 +5173,69 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>>>>>>  	new_bus->write = r8169_mdio_write_reg;
>>>>>>>
>>>>>>>  	ret = mdiobus_register(new_bus);
>>>>>>> +
>>>>>>> +#ifdef R8169_PROBE_DEBUG
>>>>>>> +	dev_info(&pdev->dev,
>>>>>>> +		 "mdiobus_register: %s, %d\n",
>>>>>>> +		 new_bus->id, ret);
>>>>>>> +#endif
>>>>>>>  	if (ret)
>>>>>>>  		return ret;
>>>>>>>
>>>>>>>  	tp->phydev = mdiobus_get_phy(new_bus, 0);
>>>>>>> +
>>>>>>>  	if (!tp->phydev) {
>>>>>>>  		mdiobus_unregister(new_bus);
>>>>>>>  		return -ENODEV;
>>>>>>> -	} else if (!tp->phydev->drv) {
>>>>>>> -		/* Most chip versions fail with the genphy driver.
>>>>>>> -		 * Therefore ensure that the dedicated PHY driver is loaded.
>>>>>>> -		 */
>>>>>>> -		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
>>>>>>> -		mdiobus_unregister(new_bus);
>>>>>>> -		return -EUNATCH;
>>>>>>> +	} else {
>>>>>>> +		/* tp -> phydev ok */
>>>>>>> +		int everything_OK = 0;
>>>>>>> +
>>>>>>> +		/* Check driver id versus phy */
>>>>>>> +
>>>>>>> +		if (tp->phydev->drv) {
>>>>>>> +			u32 phydev_masked = 0xBEEFDEAD;
>>>>>>> +			u32 drv_masked = ~0;
>>>>>>> +			u32 phydev_match = ~0;
>>>>>>> +			u32 drv_match = 0xDEADBEEF;
>>>>>>> +
>>>>>>> +			phydev_id = tp->phydev->phy_id;
>>>>>>> +			phydrv_id = tp->phydev->drv->phy_id;
>>>>>>> +			phydrv_id_mask = tp->phydev->drv->phy_id_mask;
>>>>>>> +
>>>>>>> +			drv_masked = phydrv_id & phydrv_id_mask;
>>>>>>> +			phydev_masked = phydev_id & phydrv_id_mask;
>>>>>>> +
>>>>>>> +#ifdef R8169_PROBE_DEBUG
>>>>>>> +			dev_debug(&pdev->dev,
>>>>>>> +				  "%s: ID Check: (%x -> %x), drv (%x -> %x)\n",
>>>>>>> +				new_bus->id, phydev_id, phydev_masked,
>>>>>>> +				phydrv_id, drv_masked);
>>>>>>> +#endif
>>>>>>> +
>>>>>>> +			phydev_match = phydev_masked & drv_masked;
>>>>>>> +			phydev_match = phydev_match == phydev_masked;
>>>>>>> +
>>>>>>> +			drv_match = phydev_masked & drv_masked;
>>>>>>> +			drv_match = drv_match == drv_masked;
>>>>>>> +
>>>>>>> +#ifdef R8169_PROBE_DEBUG
>>>>>>> +			dev_debug(&pdev->dev, "%s: ID Check: %x == %x\n",
>>>>>>> +				  new_bus->id, phydev_match, drv_match);
>>>>>>> +#endif
>>>>>>> +
>>>>>>> +			everything_OK = (phydev_match == drv_match);
>>>>>>> +		}
>>>>>>> +
>>>>>>> +		if (!everything_OK) {
>>>>>>> +			/* Most chip versions fail with the genphy driver.
>>>>>>> +			 * Therefore ensure that the dedicated PHY driver
>>>>>>> +			 * is loaded.
>>>>>>> +			 */
>>>>>>> +			dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
>>>>>>> +			mdiobus_unregister(new_bus);
>>>>>>> +			return -EUNATCH;
>>>>>>> +		}
>>>>>>>  	}
>>>>>>>
>>>>>>>  	/* PHY will be woken up in rtl_open() */
>>>>>>> @@ -5435,6 +5492,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>>>>>  	u64_stats_init(&tp->rx_stats.syncp);
>>>>>>>  	u64_stats_init(&tp->tx_stats.syncp);
>>>>>>>
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: MAC\n");
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	rtl_init_mac_address(tp);
>>>>>>>
>>>>>>>  	dev->ethtool_ops = &rtl8169_ethtool_ops;
>>>>>>> @@ -5483,29 +5544,64 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>>>>>  	dev->hw_features |= NETIF_F_RXFCS;
>>>>>>>
>>>>>>>  	jumbo_max = rtl_jumbo_max(tp);
>>>>>>> +
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: jumbo max: %d\n", jumbo_max);
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	if (jumbo_max)
>>>>>>>  		dev->max_mtu = jumbo_max;
>>>>>>>
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: irq mask\n");
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	rtl_set_irq_mask(tp);
>>>>>>>
>>>>>>>  	tp->fw_name = rtl_chip_infos[chipset].fw_name;
>>>>>>>
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: FW name: %s\n", tp->fw_name);
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	tp->counters = dmam_alloc_coherent (&pdev->dev, sizeof(*tp->counters),
>>>>>>>  					    &tp->counters_phys_addr,
>>>>>>>  					    GFP_KERNEL);
>>>>>>>  	if (!tp->counters)
>>>>>>>  		return -ENOMEM;
>>>>>>>
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: set driver data\n");
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	pci_set_drvdata(pdev, dev);
>>>>>>>
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: register mdio\n");
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	rc = r8169_mdio_register(tp);
>>>>>>> +
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: mdio register: %d\n", rc);
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	if (rc)
>>>>>>>  		return rc;
>>>>>>>
>>>>>>>  	/* chip gets powered up in rtl_open() */
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: pll pwr down\n");
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	rtl_pll_power_down(tp);
>>>>>>>
>>>>>>>  	rc = register_netdev(dev);
>>>>>>> +
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: netdev register: %d\n", rc);
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	if (rc)
>>>>>>>  		goto err_mdio_unregister;
>>>>>>>
>>>>>>> @@ -5525,6 +5621,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>>>>>  	if (pci_dev_run_wake(pdev))
>>>>>>>  		pm_runtime_put_sync(&pdev->dev);
>>>>>>>
>>>>>>> +#ifdef R816X_PROBE_DEBUG
>>>>>>> +	dev_dbg(&pdev->dev, "init: ALL DONE!\n");
>>>>>>> +#endif
>>>>>>> +
>>>>>>>  	return 0;
>>>>>>>
>>>>>>>  err_mdio_unregister:
>>>>>>> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>>>>>>> index 522760c8bca6..41777f379a57 100644
>>>>>>> --- a/drivers/net/phy/mdio_bus.c
>>>>>>> +++ b/drivers/net/phy/mdio_bus.c
>>>>>>> @@ -112,14 +112,22 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
>>>>>>>  struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
>>>>>>>  {
>>>>>>>  	struct mdio_device *mdiodev = bus->mdio_map[addr];
>>>>>>> -
>>>>>>> +	struct phy_device *rv = NULL;
>>>>>>> +/*
>>>>>>> +	pr_debug("mii_bus %s addr %d, %p\n", bus->id, addr, mdiodev);
>>>>>>> +*/
>>>>>>>  	if (!mdiodev)
>>>>>>>  		return NULL;
>>>>>>>
>>>>>>>  	if (!(mdiodev->flags & MDIO_DEVICE_FLAG_PHY))
>>>>>>>  		return NULL;
>>>>>>>
>>>>>>> -	return container_of(mdiodev, struct phy_device, mdio);
>>>>>>> +	rv = container_of(mdiodev, struct phy_device, mdio);
>>>>>>> +/*
>>>>>>> + 	pr_debug("mii_bus OK? %s addr %d, %p -> %p\n",
>>>>>>> +		 bus->id, addr, mdiodev, rv);
>>>>>>> +*/
>>>>>>> +	return rv;
>>>>>>>  }
>>>>>>>  EXPORT_SYMBOL(mdiobus_get_phy);
>>>>>>>
>>>>>>> @@ -645,10 +653,11 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>>>>>>>  	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
>>>>>>>
>>>>>>>  	bus->state = MDIOBUS_REGISTERED;
>>>>>>> -	pr_info("%s: probed\n", bus->name);
>>>>>>> +	pr_info("%s: probed (mdiobus_register)\n", bus->name);
>>>>>>>  	return 0;
>>>>>>>
>>>>>>>  error:
>>>>>>> +	pr_err("%s: Error while in mdiobus_register: %d\n", bus->name, err);
>>>>>>>  	while (--i >= 0) {
>>>>>>>  		mdiodev = bus->mdio_map[i];
>>>>>>>  		if (!mdiodev)
>>>>>>> --
>>>>>>> 2.26.0
>>>>>>>
>>>>>>
>>>>>
>>>>> >From 85766c0ab77750faa4488ca7018784e3e8e9eba0 Mon Sep 17 00:00:00 2001
>>>>> From: Lauri Jakku <lja@iki.fi>
>>>>> Date: Mon, 13 Apr 2020 13:18:35 +0300
>>>>> Subject: [PATCH] NET: r8168/r8169 identifying fix
>>>>>
>>>>> The driver installation determination made properly by
>>>>> checking PHY vs DRIVER id's.
>>>>> ---
>>>>>  drivers/net/ethernet/realtek/r8169_main.c | 47 +++++++++++++++++++----
>>>>>  1 file changed, 40 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>>> index bf5bf05970a2..da08b1b1047c 100644
>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>>> @@ -5149,6 +5149,9 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>>>>  {
>>>>>  	struct pci_dev *pdev = tp->pci_dev;
>>>>>  	struct mii_bus *new_bus;
>>>>> +	u32 phydev_id = 0;
>>>>> +	u32 phydrv_id = 0;
>>>>> +	u32 phydrv_id_mask = 0;
>>>>>  	int ret;
>>>>>  
>>>>>  	new_bus = devm_mdiobus_alloc(&pdev->dev);
>>>>> @@ -5172,13 +5175,43 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>>>>  	if (!tp->phydev) {
>>>>>  		mdiobus_unregister(new_bus);
>>>>>  		return -ENODEV;
>>>>> -	} else if (!tp->phydev->drv) {
>>>>> -		/* Most chip versions fail with the genphy driver.
>>>>> -		 * Therefore ensure that the dedicated PHY driver is loaded.
>>>>> -		 */
>>>>> -		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
>>>>> -		mdiobus_unregister(new_bus);
>>>>> -		return -EUNATCH;
>>>>> +	} else {
>>>>> +		/* tp -> phydev ok */
>>>>> +		int everything_OK = 0;
>>>>> +
>>>>> +		/* Check driver id versus phy */
>>>>> +
>>>>> +		if (tp->phydev->drv) {
>>>>> +			u32 phydev_masked = 0xBEEFDEAD;
>>>>> +			u32 drv_masked = ~0;
>>>>> +			u32 phydev_match = ~0;
>>>>> +			u32 drv_match = 0xDEADBEEF;
>>>>> +
>>>>> +			phydev_id = tp->phydev->phy_id;
>>>>> +			phydrv_id = tp->phydev->drv->phy_id;
>>>>> +			phydrv_id_mask = tp->phydev->drv->phy_id_mask;
>>>>> +
>>>>> +			drv_masked = phydrv_id & phydrv_id_mask;
>>>>> +			phydev_masked = phydev_id & phydrv_id_mask;
>>>>> +
>>>>> +			phydev_match = phydev_masked & drv_masked;
>>>>> +			phydev_match = phydev_match == phydev_masked;
>>>>> +
>>>>> +			drv_match = phydev_masked & drv_masked;
>>>>> +			drv_match = drv_match == drv_masked;
>>>>> +
>>>>> +			everything_OK = (phydev_match == drv_match);
>>>>> +		}
>>>>> +
>>>>> +		if (!everything_OK) {
>>>>> +			/* Most chip versions fail with the genphy driver.
>>>>> +			 * Therefore ensure that the dedicated PHY driver
>>>>> +			 * is loaded.
>>>>> +			 */
>>>>> +			dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
>>>>> +			mdiobus_unregister(new_bus);
>>>>> +			return -EUNATCH;
>>>>> +		}
>>>>>  	}
>>>>>  
>>>>>  	/* PHY will be woken up in rtl_open() */
>>>>>
>>>>
>>>>
>>>
>>
> 

