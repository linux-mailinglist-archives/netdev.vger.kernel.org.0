Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A30EDB97E
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 00:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503735AbfJQWGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 18:06:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36617 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503724AbfJQWGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 18:06:16 -0400
Received: by mail-wm1-f66.google.com with SMTP id m18so4117098wmc.1;
        Thu, 17 Oct 2019 15:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2XTmUdi3RPUYI6rnc4hcEUxSQTSxBfl5ZdZ//kGEK50=;
        b=CTU7g7BAfv1iOfImSHdH5co8qO34xFcgE8NRavtmOOHjjJmkzrIMSg/4s/ZNqEPcct
         9jymu8xCwSMOZKXJAASygVDNtKJZi0fuphZi5dpFLCTe98yZbZ1dIc1wv3j1+DcJnDEn
         mT8HUkMsAFNJm0ivchQy+xQYHJPGizfhzMh5zeJCowH1GGQEKgos2UNkYfGpNB/x8qXC
         uDMbU84QsiWaM37pL5Cq6ipnfcx8r/xCAjnkTbJMp4Lpg/Riorrpgya4tbqF0CyFWmmi
         Cdb1GeUFtzQl7+51/YX9GFaZ8VvN+Slk+lRWI9S98ctcgMSlINQ0zc6I2MIZU9+ui3z3
         DS4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2XTmUdi3RPUYI6rnc4hcEUxSQTSxBfl5ZdZ//kGEK50=;
        b=a6a7SARYRMqJ2Vn6pcZ6l/gRXZei7K6kI5Wj7q3gc95JriVEZ1Gm7kNDTrEjVOVK/K
         BBSdENTTUD7irhxs3unsUE8Pi+CzCF4crl54nfSJPlIHfeaWlbKTwbIqEQrqE+OqisNg
         h5MeisIqZFHBilRr8BG8GCT+Mb5ADm7xuBPBR7cwG4xPJaB6HtA1oMx9L0wEl6zHc2lf
         Vue9pIFzekyi/RCDQbdB5pCb6qJifX1SCr6claSDfQIt8o7EE3FM30a3toJ5qyCwqKIj
         gNEEFWhPD/ppprPpZNQISrymDeaZl9AEuP1sm7qebc4wKzt6j1KR2YXZeDoUDxpmIwgm
         by4A==
X-Gm-Message-State: APjAAAWDLPvGg7roK63AdcXqXuJt1qnpl0IDXgMA/waAXjQgypSHZUjw
        NEc6Y4XwTp5CC4vZ5V6wzvg=
X-Google-Smtp-Source: APXvYqxek5lvdwA6bvVjCFG4FdT6vjuQfYoRe3slxmVEawqP5nuPJGSrhF9jV+2VqwgFbG/yn3d4tA==
X-Received: by 2002:a1c:4c08:: with SMTP id z8mr4741299wmf.38.1571349971943;
        Thu, 17 Oct 2019 15:06:11 -0700 (PDT)
Received: from [192.168.1.2] ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id i1sm4523692wmb.19.2019.10.17.15.06.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 15:06:11 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] net: phy: Add ability to debug RGMII
 connections
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>, hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, rmk+kernel@armlinux.org.uk,
        cphealy@gmail.com, Jose Abreu <joabreu@synopsys.com>
References: <20191015224953.24199-1-f.fainelli@gmail.com>
 <20191015224953.24199-3-f.fainelli@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Message-ID: <4feb3979-1d59-4ad3-b2f1-90d82cfbdf54@gmail.com>
Date:   Fri, 18 Oct 2019 01:06:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191015224953.24199-3-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

[sorry, I started writing this before you sent out a v2]

On 10/16/19 1:49 AM, Florian Fainelli wrote:
> RGMII connections are always troublesome because of the need to add
> delays between the RX or TX clocks and data lines. This can lead to a
> fair amount of breakage that upsets users.
> 
> Introduce a new sysfs write only attribute which can be set to 1 to
> instruct the PHY library to attempt to probe what the correct RGMII
> phy_interface_t value should be. When such debugging is requested, the
> PHY library will do a number of checks whether this debugging is even
> necessary (RGMII used, Gigabit, not a Generic PHY driver etc.) and if
> successfull will proceed with:
> 
> - putting the PHY in loopback mode
> - register a packet handler with an unused Ethernet type value in the
>    kernel (ETH_P_EDSA is a well known unused value)
> - re-configure the PHY and MAC with the phy_interface_t value to be
>    tried, which is one of the 4 possible interfaces, starting with the
>    currently defined one
> - craft a MTU sized packet with the Ethernet interface's MAC SA and DA
>    set to itself and send that in a process context
> - wait for that packet to be received through the registered packet_type
>    handler
> 
> If the packet is not received, we have a problem with the RGMII
> interface, if we do receive something, we check the FCS we calculated on
> transmit matches the FCS of the packet received, if we have a mismatch
> it most likely will not.
> 
> If all is well, we stop iterating over all possible RGMII combinations
> and offer the one that is deemed suitable which is what an user should
> be trying by configuring the platform appropriately.
> 
> This is not deemed to be 100% fool proof, but given how much support
> getting RGMII seems to involved, this seemed like a good tool to have
> users self-diagnose their connection issues.
> 
> Future improvements could be made in order to extrapolate from a
> specific frame patter the type of skewing between RXC/TXC that is going
> on so as to refine the search process, and even possibly suggest delays.
> 
> The function phy_rgmii_debug_probe() could also be used by an Ethernet
> controller during its selftests routines instead of open-coding that
> part.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>   .../ABI/testing/sysfs-class-net-phydev        |  11 +
>   drivers/net/phy/Kconfig                       |   9 +
>   drivers/net/phy/Makefile                      |   1 +
>   drivers/net/phy/phy-rgmii-debug.c             | 269 ++++++++++++++++++
>   drivers/net/phy/phy_device.c                  |  31 ++
>   include/linux/phy.h                           |   9 +
>   6 files changed, 330 insertions(+)
>   create mode 100644 drivers/net/phy/phy-rgmii-debug.c
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-net-phydev b/Documentation/ABI/testing/sysfs-class-net-phydev
> index 206cbf538b59..989fc128ec94 100644
> --- a/Documentation/ABI/testing/sysfs-class-net-phydev
> +++ b/Documentation/ABI/testing/sysfs-class-net-phydev
> @@ -49,3 +49,14 @@ Description:
>   		Boolean value indicating whether the PHY device is used in
>   		standalone mode, without a net_device associated, by PHYLINK.
>   		Attribute created only when this is the case.
> +
> +What:		/sys/class/mdio_bus/<bus>/<device>/phy_rgmii_debug
> +Date:		October 2019
> +KernelVersion:	5.5
> +Contact:	netdev@vger.kernel.org
> +Description:
> +		Write only attribute used to trigger the debugging of RGMII
> +		connections. Upon writing, this will either return success
> +		and print to kernel console the correct phy_interface value
> +		or an error will be returned. See CONFIG_PHY_RGMII_DEBUG for
> +		details.
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index fe602648b99f..e5b54627d426 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -248,6 +248,15 @@ config LED_TRIGGER_PHY
>   		<Speed in megabits>Mbps OR <Speed in gigabits>Gbps OR link
>   		for any speed known to the PHY.
>   
> +config PHY_RGMII_DEBUG
> +	bool "Support debugging of RGMII connections"
> +	---help---
> +	   This enables support for troubleshooting RGMII connections by
> +	   making use of the PHY devices standard loopback feature in order to
> +	   probe the correct RGMII connection.
> +
> +	   If unsure, say N here.
> +
>   
>   comment "MII PHY device drivers"
>   
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index a03437e091f3..1d9fddf83f6c 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -18,6 +18,7 @@ obj-$(CONFIG_MDIO_DEVICE)	+= mdio-bus.o
>   endif
>   libphy-$(CONFIG_SWPHY)		+= swphy.o
>   libphy-$(CONFIG_LED_TRIGGER_PHY)	+= phy_led_triggers.o
> +libphy-$(CONFIG_PHY_RGMII_DEBUG)	+= phy-rgmii-debug.o
>   
>   obj-$(CONFIG_PHYLINK)		+= phylink.o
>   obj-$(CONFIG_PHYLIB)		+= libphy.o
> diff --git a/drivers/net/phy/phy-rgmii-debug.c b/drivers/net/phy/phy-rgmii-debug.c
> new file mode 100644
> index 000000000000..f66ce8bc942c
> --- /dev/null
> +++ b/drivers/net/phy/phy-rgmii-debug.c
> @@ -0,0 +1,269 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * PHY library RGMII debugging tool.
> + *
> + * Author: Florian Fainelli <f.fainelli@gmail.com>
> + */
> +#include <linux/completion.h>
> +#include <linux/export.h>
> +#include <linux/kernel.h>
> +#include <linux/phy.h>
> +#include <linux/workqueue.h>
> +#include <linux/etherdevice.h>
> +#include <linux/crc32.h>
> +
> +#include <uapi/linux/if_ether.h>
> +
> +struct phy_rgmii_debug_priv {
> +	struct work_struct work;
> +	struct phy_device *phydev;
> +	struct completion compl;
> +	struct sk_buff *skb;
> +	u32 fcs;
> +	unsigned int rcv_ok;
> +};
> +
> +static u32 phy_rgmii_probe_skb_fcs(struct sk_buff *skb)
> +{
> +	u32 fcs;
> +
> +	fcs = crc32_le(~0, skb->data, skb->len);
> +	fcs = ~fcs;
> +
> +	return fcs;
> +}
> +
> +static int phy_rgmii_debug_rcv(struct sk_buff *skb, struct net_device *dev,
> +			       struct packet_type *pt, struct net_device *unused)
> +{
> +	struct phy_rgmii_debug_priv *priv = pt->af_packet_priv;
> +	u32 fcs;
> +
> +	/* If we receive something, the Ethernet header was valid and so was
> +	 * the Ethernet type, so to re-calculate the FCS we need to undo what
> +	 * eth_type_trans() just did.
> +	 */
> +	if (!__skb_push(skb, ETH_HLEN))
> +		return 0;

Why would this return NULL?

> +
> +	fcs = phy_rgmii_probe_skb_fcs(skb);
> +	if (skb->len != priv->skb->len || fcs != priv->fcs) {

I feel like this logic is broken. How do you know that this skb is that 
skb? Everybody else can still enqueue to the netdev, right?

Actually if I'm right about the FCS errors resulting in drops below, 
then any news here is good news, no need to even compare the FCS of two 
frames which you don't know whether they're in fact one and the same.

> +		print_hex_dump(KERN_INFO, "RX probe skb: ",
> +			       DUMP_PREFIX_OFFSET, 16, 1, skb->data, 32,
> +			       false);
> +		netdev_warn(dev, "Calculated FCS: 0x%08x expected: 0x%08x\n",
> +			    fcs, priv->fcs);
> +	} else {
> +		priv->rcv_ok = 1;
> +	}
> +
> +	complete(&priv->compl);
> +
> +	return 0;
> +}
> +
> +static int phy_rgmii_trigger_config(struct phy_device *phydev,
> +				    phy_interface_t interface)
> +{
> +	int ret = 0;
> +
> +	/* Configure the interface mode to be tested */
> +	phydev->interface = interface;
> +
> +	/* Forcibly run the fixups and config_init() */
> +	ret = phy_init_hw(phydev);
> +	if (ret) {
> +		phydev_err(phydev, "phy_init_hw failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* Some PHY drivers configure RGMII delays in their config_aneg()
> +	 * callback, so make sure we run through those as well.
> +	 */
> +	ret = phy_start_aneg(phydev);
> +	if (ret) {
> +		phydev_err(phydev, "phy_start_aneg failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* Put back in loopback mode since phy_init_hw() may have issued
> +	 * a software reset.
> +	 */
> +	ret = phy_loopback(phydev, true);
> +	if (ret)
> +		phydev_err(phydev, "phy_loopback failed: %d\n", ret);
> +
> +	return ret;
> +}
> +
> +static void phy_rgmii_probe_xmit_work(struct work_struct *work)
> +{
> +	struct phy_rgmii_debug_priv *priv;
> +
> +	priv = container_of(work, struct phy_rgmii_debug_priv, work);
> +
> +	dev_queue_xmit(priv->skb);

Oops, you just lost ownership of priv->skb here. Anything happening 
further is in a race with the netdev driver. You need to hold a 
reference to it with skb_get().

> +}
> +
> +static int phy_rgmii_prepare_probe(struct phy_rgmii_debug_priv *priv)
> +{
> +	struct phy_device *phydev = priv->phydev;
> +	struct net_device *ndev = phydev->attached_dev;
> +	struct sk_buff *skb;
> +	int ret;
> +
> +	skb = netdev_alloc_skb(ndev, ndev->mtu);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	priv->skb = skb;

Could you assign priv->skb at the end, not here? This way you won't risk 
leaking a freed pointer into priv->skb if eth_header below fails.

> +	skb->dev = ndev;
> +	skb_put(skb, ndev->mtu);
> +	memset(skb->data, 0xaa, skb->len);
> +

I think you need to do something like this before skb_put:

+       skb->protocol = htons(ETH_P_EDSA);
+       skb_reset_network_header(skb);
+       skb_reset_transport_header(skb);

Otherwise I get a lot of these errors on a bridged net device:

[  142.919783] protocol 0000 is buggy, dev swp2
[  142.924436] protocol 0000 is buggy, dev eth2

> +	/* Build the header */
> +	ret = eth_header(skb, ndev, ETH_P_EDSA, ndev->dev_addr,
> +			 NULL, ndev->mtu);

A switch net device will complain about having SMAC == DMAC and drop the 
frame. Don't you want to send broadcast frames here?

> +	if (ret != ETH_HLEN) {
> +		kfree_skb(skb);
> +		return -EINVAL;
> +	}
> +
> +	priv->fcs = phy_rgmii_probe_skb_fcs(skb);
> +

I'm far from a checksumming expert, but if the FCS was invalid, wouldn't 
the RX MAC just drop the frame?

> +	return 0;
> +}
> +
> +static int phy_rgmii_probe_interface(struct phy_rgmii_debug_priv *priv,
> +				     phy_interface_t iface)
> +{
> +	struct phy_device *phydev = priv->phydev;
> +	struct net_device *ndev = phydev->attached_dev;
> +	unsigned long timeout;
> +	int ret;
> +
> +	ret = phy_rgmii_trigger_config(phydev, iface);
> +	if (ret) {
> +		netdev_err(ndev, "%s rejected by driver(s)\n",
> +			   phy_modes(iface));
> +		return ret;
> +	}
> +
> +	netdev_info(ndev, "Trying \"%s\" PHY interface\n", phy_modes(iface));
> +
> +	/* Prepare probe frames now */
> +	ret = phy_rgmii_prepare_probe(priv);
> +	if (ret)
> +		return ret;
> +
> +	priv->rcv_ok = 0;
> +	reinit_completion(&priv->compl);
> +
> +	cancel_work_sync(&priv->work);
> +	schedule_work(&priv->work);
> +
> +	timeout = wait_for_completion_timeout(&priv->compl,
> +					      msecs_to_jiffies(3000));
> +	if (!timeout) {
> +		netdev_err(ndev, "transmit timeout!\n");
> +		ret = -ETIMEDOUT;
> +		goto out;
> +	}
> +
> +	ret = priv->rcv_ok == 1 ? 0 : -EINVAL;
> +out:
> +	phy_loopback(phydev, false);
> +	dev_consume_skb_any(priv->skb);

Don't consume the skb if the xmit has timed out. The driver will have 
already freed it in that case, leading to:

[  145.994328] sja1105 spi0.1 swp2: transmit timeout!
[  145.999259] ------------[ cut here ]------------
[  146.003901] WARNING: CPU: 0 PID: 163 at lib/refcount.c:190 
refcount_sub_and_test_checked+0xb8/0xc0
[  146.013029] refcount_t: underflow; use-after-free.

That means, in practice, moving the kfree_skb call to phy_rgmii_debug_rcv.

> +	return ret;
> +}
> +
> +static struct packet_type phy_rgmii_probes_type __read_mostly = {
> +	.type	= cpu_to_be16(ETH_P_EDSA),
> +	.func	= phy_rgmii_debug_rcv,
> +};
> +
> +static int phy_rgmii_can_debug(struct phy_device *phydev)
> +{
> +	struct net_device *ndev = phydev->attached_dev;
> +
> +	if (!ndev) {
> +		netdev_err(ndev, "No network device attached\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (!phy_interface_is_rgmii(phydev)) {
> +		netdev_info(ndev, "Not RGMII configured, nothing to do\n");
> +		return 0;
> +	}
> +
> +	if (!phydev->is_gigabit_capable) {
> +		netdev_err(ndev, "not relevant in non-Gigabit mode\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (phy_driver_is_genphy(phydev) || phy_driver_is_genphy_10g(phydev)) {
> +		netdev_err(ndev, "only relevant with non-generic drivers\n");
> +		return -EOPNOTSUPP;
> +	}
> +	return 1;
> +}
> +
> +int phy_rgmii_debug_probe(struct phy_device *phydev)
> +{
> +	struct net_device *ndev = phydev->attached_dev;
> +	unsigned char operstate = ndev->operstate;
> +	phy_interface_t rgmii_modes[4] = {
> +		PHY_INTERFACE_MODE_RGMII,
> +		PHY_INTERFACE_MODE_RGMII_ID,
> +		PHY_INTERFACE_MODE_RGMII_RXID,
> +		PHY_INTERFACE_MODE_RGMII_TXID
> +	};
> +	struct phy_rgmii_debug_priv *priv;
> +	unsigned int i, count;
> +	int ret;
> +
> +	ret = phy_rgmii_can_debug(phydev);
> +	if (ret <= 0)
> +		return ret;
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	if (phy_rgmii_probes_type.af_packet_priv)
> +		return -EBUSY;
> +
> +	phy_rgmii_probes_type.af_packet_priv = priv;
> +	priv->phydev = phydev;
> +	INIT_WORK(&priv->work, phy_rgmii_probe_xmit_work);
> +	init_completion(&priv->compl);
> +
> +	/* We are now testing this network device */
> +	ndev->operstate = IF_OPER_TESTING;
> +

Shouldn't you put the netdev in promisc mode somewhere?

> +	dev_add_pack(&phy_rgmii_probes_type);
> +
> +	/* Determine where to start */
> +	for (i = 0; i < ARRAY_SIZE(rgmii_modes); i++) {
> +		if (phydev->interface == rgmii_modes[i])
> +			break;
> +	}
> +
> +	/* Now probe all modes */
> +	for (count = 0; count < ARRAY_SIZE(rgmii_modes); count++) {
> +		ret = phy_rgmii_probe_interface(priv, rgmii_modes[i]);
> +		if (ret == 0) {
> +			netdev_info(ndev, "Determined \"%s\" to be correct\n",
> +				    phy_modes(rgmii_modes[i]));
> +			break;
> +		}
> +		i = (i + 1) % ARRAY_SIZE(rgmii_modes);
> +	}
> +
> +	dev_remove_pack(&phy_rgmii_probes_type);
> +	kfree(priv);
> +	phy_rgmii_probes_type.af_packet_priv = NULL;
> +	ndev->operstate = operstate;
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(phy_rgmii_debug_probe);
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index c2e66b9ec161..29b20befc371 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -537,10 +537,41 @@ phy_has_fixups_show(struct device *dev, struct device_attribute *attr,
>   }
>   static DEVICE_ATTR_RO(phy_has_fixups);
>   
> +static ssize_t
> +phy_rgmii_debug_enable_store(struct device *dev, struct device_attribute *attr,
> +			     const char *buf, size_t count)
> +{
> +	struct phy_device *phydev = to_phy_device(dev);
> +	unsigned int val;
> +	int ret = -EPERM;
> +
> +	if (!capable(CAP_NET_ADMIN))
> +		goto out;
> +
> +	ret = kstrtoint(buf, 0, &val);
> +	if (ret)
> +		goto out;
> +
> +	if (val != 1) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ret = phy_rgmii_debug_probe(phydev);
> +	if (ret)
> +		return ret;
> +
> +	ret = count;
> +out:
> +	return ret;
> +}
> +static DEVICE_ATTR_WO(phy_rgmii_debug_enable);
> +
>   static struct attribute *phy_dev_attrs[] = {
>   	&dev_attr_phy_id.attr,
>   	&dev_attr_phy_interface.attr,
>   	&dev_attr_phy_has_fixups.attr,
> +	&dev_attr_phy_rgmii_debug_enable.attr,
>   	NULL,
>   };
>   ATTRIBUTE_GROUPS(phy_dev);
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 9a0e981df502..83a25430596e 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -1287,4 +1287,13 @@ module_exit(phy_module_exit)
>   bool phy_driver_is_genphy(struct phy_device *phydev);
>   bool phy_driver_is_genphy_10g(struct phy_device *phydev);
>   
> +#ifdef CONFIG_PHY_RGMII_DEBUG
> +int phy_rgmii_debug_probe(struct phy_device *phydev);
> +#else
> +static inline int phy_rgmii_debug_probe(struct phy_device *phydev)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
> +
>   #endif /* __PHY_H */
> 

Despite the above, I couldn't actually get this running successfully. At 
the end of the test I always get "-bash: echo: write error: Connection 
timed out".
It's a fun toy, but I don't really think it's very useful in catching 
any bug.
It's basically a glorified ping test, and brainless ping tests are 
precisely the reason why people get this wrong most of the time. You 
can't have a generic software tool identify for you a configuration 
problem that depends entirely upon a private hardware implementation of 
a specification that is vague.

I mean in theory, the arithmetic is simple enough for a MAC-to-PHY 
connection. These 2 equalities always need to hold true:

MAC TX delay + PCB TX delay + PHY TX delay == 1
MAC RX delay + PCB RX delay + PHY RX delay == 1

meaning that delays in each direction need to be applied at most once.

For a PHY-to-MAC connection, there is this unwritten Linux rule that the 
PHY should apply the requested delays in both directions. This already 
contradicts common sense, as it is not uncommon, from a hardware point 
of view, for each device to add the delays in its own TX direction (so 
the MAC would add the TX delays and the PHY would add the RX delays). 
That is not possible to specify with Linux. But let's go with the flow. 
So the PHY adds all specified delays, and one can assume that the 
unspecified delays up to rgmii-id were added by the PCB. This small 
kernel thread would basically probe for PCB delays, in this case, 
assuming that the MAC driver and the PHY driver are both compliant.

Let's say there is more than one phy-mode that works. Andrew said to 
raise a red flag in that case, because the PHY driver is surely not 
doing the right thing with the delays. But:
- Maybe it is, but the equalities above aren't completely set in stone. 
Maybe the inserted propagation delays aren't high enough that two of 
them would break the link again.
- Which of the multiple phy-mode configurations that work is the right 
one? A tool that can't tell me that is pointless, IMO. My PHY works due 
to pin strapping, but the driver is buggy. Do I care? No, as long as it 
works, and as long as it will continue to work after somebody fixes the 
driver. How do I know what delay mode is right? Well, of course, if it 
works with the configuration out of pin strapping, then obviously I 
should put the pin strapping settings in the DT. End of story. Can this 
kernel thread tell me that? No....

And then, there's the RGMII fixed-link. The rules are cloudy for that 
one, because now there's potentially 2 phy-modes that operate on the 
same link. To complicate matters even further, your patch does not 
consider the fixed-link (no PHY) case, and there is no generic interface 
to even add selftests for that in the future. You would need to unbind 
the MAC driver, mangle the DT bindings, then bind it back again...

I guess I'm just concerned about the chaos that a tool returning false 
positives would create for people who don't really follow what's going 
on ("look, but the tool said this!").

Thanks,
-Vladimir
