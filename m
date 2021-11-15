Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F936451983
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 00:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346544AbhKOXWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 18:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346478AbhKOXUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 18:20:31 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9AFC048C81
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:21:31 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id o29so15256355wms.2
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=RIi+kt91mWkYQZHWyGOB62ZXgdwC285xIb9CIAVDT0s=;
        b=dsOUy910coSQT7+dngH/BK434KljpnHAzXy5Z4W6BtuSCA+u0FVMTizORwkPYvwG9x
         auvZjIv9ECigc+XRSkxbiH+hXJ2b91ZtHeVwoTDgPMipJk1gsOON3P5fmCwiMmPPQ6Uz
         b0Sz5X3XSvPLB2RKn0gaQANdcGRvM0KVnbO6eoGsYpxaH7viNllD2cDyqvKNPeC/EAcO
         ciuCkr0HdzJ1cDG9CVSJTTnFaZA4mUMnwiPz5L2Le/GNd9eQtcbSjfGv+15kAyhAB6SS
         RU8rm2pVDwiAoUtCa7Q2wLA3psaBG7w3A296NRRsD6IdK0o7TzEyImcMVUGvxUMqe37u
         d85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=RIi+kt91mWkYQZHWyGOB62ZXgdwC285xIb9CIAVDT0s=;
        b=XOn21anaPH0yZFDGfSA/ALsD2mX3KgMl0t9Orl0cKUft3gEzQ3pqaUF3JoEeACiHCs
         BsLg0FC2Lpkph7lAhzOOySMmt6pfYvL8PD+TVal2WBJdajvCRDe28gPkuB4kJfEAFl/l
         vLLPn+WfnrtSsDczauugmpWCOFFOWx48E2SUtzmjbJRk9v75QwLbCDgq9+9EmidTZIYr
         BwY6zk01F5WScYFB9c1qxIJ6hHPSQAhTdCiTz6JT/XigP0PG7iAcdWbE0h1vHQVuwdEE
         bPr5mv05zNzMW6HAuVKM1drE0lL2F8y7y8G2zz/ciH1ML/GOCoC3ELNn3NWgdOBf8z0s
         KmPA==
X-Gm-Message-State: AOAM533viJyhedZg+3KGZEl4GjAmpDWnMbSEuTMh58qN36FD8vRPfjKH
        URzAF39ixh6E3t0IvInGpvg=
X-Google-Smtp-Source: ABdhPJy04ioFrUwCV1ZOnWVaCxEMuPCO1WwYSww0Z3nMQN4D1BAdSyDFampwKKsXVEmC5Keo9cxHxw==
X-Received: by 2002:a05:600c:1f13:: with SMTP id bd19mr47506820wmb.9.1637014889516;
        Mon, 15 Nov 2021 14:21:29 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:a554:6e71:73b4:f32d? (p200300ea8f1a0f00a5546e7173b4f32d.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:a554:6e71:73b4:f32d])
        by smtp.googlemail.com with ESMTPSA id m21sm15727188wrb.2.2021.11.15.14.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 14:21:28 -0800 (PST)
Message-ID: <577ffb42-d74e-9da7-d921-b7f62c26b596@gmail.com>
Date:   Mon, 15 Nov 2021 23:21:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org
References: <20211115205005.6132-1-gerhard@engleder-embedded.com>
 <20211115205005.6132-4-gerhard@engleder-embedded.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v5 3/3] tsnep: Add TSN endpoint Ethernet MAC
 driver
In-Reply-To: <20211115205005.6132-4-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.11.2021 21:50, Gerhard Engleder wrote:
> The TSN endpoint Ethernet MAC is a FPGA based network device for
> real-time communication.
> 
> It is integrated as Ethernet controller with ethtool and PTP support.
> For real-time communcation TC_SETUP_QDISC_TAPRIO is supported.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/Kconfig                  |    1 +
>  drivers/net/ethernet/Makefile                 |    1 +
>  drivers/net/ethernet/engleder/Kconfig         |   29 +
>  drivers/net/ethernet/engleder/Makefile        |    9 +
>  drivers/net/ethernet/engleder/tsnep.h         |  171 +++
>  drivers/net/ethernet/engleder/tsnep_ethtool.c |  288 ++++
>  drivers/net/ethernet/engleder/tsnep_hw.h      |  230 +++
>  drivers/net/ethernet/engleder/tsnep_main.c    | 1255 +++++++++++++++++
>  drivers/net/ethernet/engleder/tsnep_ptp.c     |  221 +++
>  drivers/net/ethernet/engleder/tsnep_tc.c      |  443 ++++++
>  drivers/net/ethernet/engleder/tsnep_test.c    |  811 +++++++++++
>  11 files changed, 3459 insertions(+)
>  create mode 100644 drivers/net/ethernet/engleder/Kconfig
>  create mode 100644 drivers/net/ethernet/engleder/Makefile
>  create mode 100644 drivers/net/ethernet/engleder/tsnep.h
>  create mode 100644 drivers/net/ethernet/engleder/tsnep_ethtool.c
>  create mode 100644 drivers/net/ethernet/engleder/tsnep_hw.h
>  create mode 100644 drivers/net/ethernet/engleder/tsnep_main.c
>  create mode 100644 drivers/net/ethernet/engleder/tsnep_ptp.c
>  create mode 100644 drivers/net/ethernet/engleder/tsnep_tc.c
>  create mode 100644 drivers/net/ethernet/engleder/tsnep_test.c
> 
> diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
> index 4601b38f532a..027cbacca1c9 100644
> --- a/drivers/net/ethernet/Kconfig
> +++ b/drivers/net/ethernet/Kconfig
> @@ -73,6 +73,7 @@ config DNET
>  source "drivers/net/ethernet/dec/Kconfig"
>  source "drivers/net/ethernet/dlink/Kconfig"
>  source "drivers/net/ethernet/emulex/Kconfig"
> +source "drivers/net/ethernet/engleder/Kconfig"
>  source "drivers/net/ethernet/ezchip/Kconfig"
>  source "drivers/net/ethernet/faraday/Kconfig"
>  source "drivers/net/ethernet/freescale/Kconfig"
> diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
> index fdd8c6c17451..33d30b619e00 100644
> --- a/drivers/net/ethernet/Makefile
> +++ b/drivers/net/ethernet/Makefile
> @@ -36,6 +36,7 @@ obj-$(CONFIG_DNET) += dnet.o
>  obj-$(CONFIG_NET_VENDOR_DEC) += dec/
>  obj-$(CONFIG_NET_VENDOR_DLINK) += dlink/
>  obj-$(CONFIG_NET_VENDOR_EMULEX) += emulex/
> +obj-$(CONFIG_NET_VENDOR_ENGLEDER) += engleder/
>  obj-$(CONFIG_NET_VENDOR_EZCHIP) += ezchip/
>  obj-$(CONFIG_NET_VENDOR_FARADAY) += faraday/
>  obj-$(CONFIG_NET_VENDOR_FREESCALE) += freescale/
> diff --git a/drivers/net/ethernet/engleder/Kconfig b/drivers/net/ethernet/engleder/Kconfig
> new file mode 100644
> index 000000000000..26c2a8e0acc0
> --- /dev/null
> +++ b/drivers/net/ethernet/engleder/Kconfig
> @@ -0,0 +1,29 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Engleder network device configuration
> +#
> +
> +config NET_VENDOR_ENGLEDER
> +	bool "Engleder devices"
> +	default y
> +	help
> +	  If you have a network (Ethernet) card belonging to this class, say Y.
> +
> +	  Note that the answer to this question doesn't directly affect the
> +	  kernel: saying N will just cause the configurator to skip all
> +	  the questions about Engleder devices. If you say Y, you will be asked
> +	  for your specific card in the following questions.
> +
> +if NET_VENDOR_ENGLEDER
> +
> +config TSNEP
> +	tristate "TSN endpoint support"
> +	depends on PTP_1588_CLOCK_OPTIONAL
> +	select PHYLIB
> +	help
> +	  Support for the Engleder TSN endpoint Ethernet MAC IP Core.
> +
> +	  To compile this driver as a module, choose M here. The module will be
> +	  called tsnep.
> +
> +endif # NET_VENDOR_ENGLEDER
> diff --git a/drivers/net/ethernet/engleder/Makefile b/drivers/net/ethernet/engleder/Makefile
> new file mode 100644
> index 000000000000..fbaecbfb0944
> --- /dev/null
> +++ b/drivers/net/ethernet/engleder/Makefile
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for the Engleder Ethernet drivers
> +#
> +
> +obj-$(CONFIG_TSNEP) += tsnep.o
> +
> +tsnep-objs := tsnep_main.o tsnep_ethtool.o tsnep_ptp.o tsnep_tc.o \
> +	      tsnep_test.o
> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
> new file mode 100644
> index 000000000000..edd6fa7dafd7
> --- /dev/null
> +++ b/drivers/net/ethernet/engleder/tsnep.h
> @@ -0,0 +1,171 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2021 Gerhard Engleder <gerhard@engleder-embedded.com> */
> +
> +#ifndef _TSNEP_H
> +#define _TSNEP_H
> +
> +#include "tsnep_hw.h"
> +
> +#include <linux/platform_device.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/etherdevice.h>
> +#include <linux/phy.h>
> +#include <linux/ethtool.h>
> +#include <linux/net_tstamp.h>
> +#include <linux/ptp_clock_kernel.h>
> +#include <linux/miscdevice.h>
> +
> +#define TSNEP "tsnep"
> +
> +#define TSNEP_RING_SIZE 256
> +#define TSNEP_RING_ENTRIES_PER_PAGE (PAGE_SIZE / TSNEP_DESC_SIZE)
> +#define TSNEP_RING_PAGE_COUNT (TSNEP_RING_SIZE / TSNEP_RING_ENTRIES_PER_PAGE)
> +
> +#define TSNEP_QUEUES 1
> +
> +struct tsnep_gcl {
> +	void __iomem *addr;
> +
> +	u64 base_time;
> +	u64 cycle_time;
> +	u64 cycle_time_extension;
> +
> +	struct tsnep_gcl_operation operation[TSNEP_GCL_COUNT];
> +	int count;
> +
> +	u64 change_limit;
> +
> +	u64 start_time;
> +	bool change;
> +};
> +
> +struct tsnep_tx_entry {
> +	struct tsnep_tx_desc *desc;
> +	struct tsnep_tx_desc_wb *desc_wb;
> +	dma_addr_t desc_dma;
> +	bool owner_user_flag;
> +
> +	u32 properties;
> +
> +	struct sk_buff *skb;
> +	DEFINE_DMA_UNMAP_ADDR(dma);
> +	DEFINE_DMA_UNMAP_LEN(len);
> +};
> +
> +struct tsnep_tx {
> +	struct tsnep_adapter *adapter;
> +	void __iomem *addr;
> +
> +	void *page[TSNEP_RING_PAGE_COUNT];
> +	dma_addr_t page_dma[TSNEP_RING_PAGE_COUNT];
> +
> +	/* TX ring lock */
> +	spinlock_t lock;
> +	struct tsnep_tx_entry entry[TSNEP_RING_SIZE];
> +	int write;
> +	int read;
> +	u32 owner_counter;
> +	int increment_owner_counter;
> +
> +	u32 packets;
> +	u32 bytes;
> +	u32 dropped;
> +};
> +
> +struct tsnep_rx_entry {
> +	struct tsnep_rx_desc *desc;
> +	struct tsnep_rx_desc_wb *desc_wb;
> +	dma_addr_t desc_dma;
> +
> +	u32 properties;
> +
> +	struct sk_buff *skb;
> +	DEFINE_DMA_UNMAP_ADDR(dma);
> +	DEFINE_DMA_UNMAP_LEN(len);
> +};
> +
> +struct tsnep_rx {
> +	struct tsnep_adapter *adapter;
> +	void __iomem *addr;
> +
> +	void *page[TSNEP_RING_PAGE_COUNT];
> +	dma_addr_t page_dma[TSNEP_RING_PAGE_COUNT];
> +
> +	struct tsnep_rx_entry entry[TSNEP_RING_SIZE];
> +	int read;
> +	u32 owner_counter;
> +	int increment_owner_counter;
> +
> +	u32 packets;
> +	u32 bytes;
> +	u32 dropped;
> +	u32 multicast;
> +};
> +
> +struct tsnep_queue {
> +	struct tsnep_adapter *adapter;
> +
> +	struct tsnep_tx *tx;
> +	struct tsnep_rx *rx;
> +
> +	struct napi_struct napi;
> +
> +	u32 irq_mask;
> +};
> +
> +struct tsnep_adapter {
> +	struct net_device *netdev;
> +	u8 mac_address[ETH_ALEN];
> +	struct mii_bus *mdiobus;
> +	bool suppress_preamble;
> +	phy_interface_t phy_mode;
> +	struct phy_device *phydev;
> +	int msg_enable;
> +
> +	struct platform_device *pdev;
> +	struct device *dmadev;
> +	void __iomem *addr;
> +	unsigned long size;
> +	int irq;
> +
> +	bool gate_control;
> +	/* gate control lock */
> +	struct mutex gate_control_lock;
> +	bool gate_control_active;
> +	struct tsnep_gcl gcl[2];
> +	int next_gcl;
> +
> +	struct hwtstamp_config hwtstamp_config;
> +	struct ptp_clock *ptp_clock;
> +	struct ptp_clock_info ptp_clock_info;
> +	/* ptp clock lock */
> +	spinlock_t ptp_lock;
> +
> +	int num_tx_queues;
> +	struct tsnep_tx tx[TSNEP_MAX_QUEUES];
> +	int num_rx_queues;
> +	struct tsnep_rx rx[TSNEP_MAX_QUEUES];
> +
> +	int num_queues;
> +	struct tsnep_queue queue[TSNEP_MAX_QUEUES];
> +};
> +
> +extern const struct ethtool_ops tsnep_ethtool_ops;
> +
> +int tsnep_ptp_init(struct tsnep_adapter *adapter);
> +void tsnep_ptp_cleanup(struct tsnep_adapter *adapter);
> +int tsnep_ptp_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd);
> +
> +int tsnep_tc_init(struct tsnep_adapter *adapter);
> +void tsnep_tc_cleanup(struct tsnep_adapter *adapter);
> +int tsnep_tc_setup(struct net_device *netdev, enum tc_setup_type type,
> +		   void *type_data);
> +
> +int tsnep_ethtool_get_test_count(void);
> +void tsnep_ethtool_get_test_strings(u8 *data);
> +void tsnep_ethtool_self_test(struct net_device *netdev,
> +			     struct ethtool_test *eth_test, u64 *data);
> +
> +void tsnep_get_system_time(struct tsnep_adapter *adapter, u64 *time);
> +
> +#endif /* _TSNEP_H */
> diff --git a/drivers/net/ethernet/engleder/tsnep_ethtool.c b/drivers/net/ethernet/engleder/tsnep_ethtool.c
> new file mode 100644
> index 000000000000..f9abcaab1c7c
> --- /dev/null
> +++ b/drivers/net/ethernet/engleder/tsnep_ethtool.c
> @@ -0,0 +1,288 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2021 Gerhard Engleder <gerhard@engleder-embedded.com> */
> +
> +#include "tsnep.h"
> +
> +static const char tsnep_stats_strings[][ETH_GSTRING_LEN] = {
> +	"rx_packets",
> +	"rx_bytes",
> +	"rx_dropped",
> +	"rx_multicast",
> +	"rx_phy_errors",
> +	"rx_forwarded_phy_errors",
> +	"rx_invalid_frame_errors",
> +	"tx_packets",
> +	"tx_bytes",
> +	"tx_dropped",
> +};
> +
> +struct tsnep_stats {
> +	u64 rx_packets;
> +	u64 rx_bytes;
> +	u64 rx_dropped;
> +	u64 rx_multicast;
> +	u64 rx_phy_errors;
> +	u64 rx_forwarded_phy_errors;
> +	u64 rx_invalid_frame_errors;
> +	u64 tx_packets;
> +	u64 tx_bytes;
> +	u64 tx_dropped;
> +};
> +
> +#define TSNEP_STATS_COUNT (sizeof(struct tsnep_stats) / sizeof(u64))
> +
> +static const char tsnep_rx_queue_stats_strings[][ETH_GSTRING_LEN] = {
> +	"rx_%d_packets",
> +	"rx_%d_bytes",
> +	"rx_%d_dropped",
> +	"rx_%d_multicast",
> +	"rx_%d_no_descriptor_errors",
> +	"rx_%d_buffer_too_small_errors",
> +	"rx_%d_fifo_overflow_errors",
> +	"rx_%d_invalid_frame_errors",
> +};
> +
> +struct tsnep_rx_queue_stats {
> +	u64 rx_packets;
> +	u64 rx_bytes;
> +	u64 rx_dropped;
> +	u64 rx_multicast;
> +	u64 rx_no_descriptor_errors;
> +	u64 rx_buffer_too_small_errors;
> +	u64 rx_fifo_overflow_errors;
> +	u64 rx_invalid_frame_errors;
> +};
> +
> +#define TSNEP_RX_QUEUE_STATS_COUNT (sizeof(struct tsnep_rx_queue_stats) / \
> +				    sizeof(u64))
> +
> +static const char tsnep_tx_queue_stats_strings[][ETH_GSTRING_LEN] = {
> +	"tx_%d_packets",
> +	"tx_%d_bytes",
> +	"tx_%d_dropped",
> +};
> +
> +struct tsnep_tx_queue_stats {
> +	u64 tx_packets;
> +	u64 tx_bytes;
> +	u64 tx_dropped;
> +};
> +
> +#define TSNEP_TX_QUEUE_STATS_COUNT (sizeof(struct tsnep_tx_queue_stats) / \
> +				    sizeof(u64))
> +
> +static void tsnep_ethtool_get_drvinfo(struct net_device *netdev,
> +				      struct ethtool_drvinfo *drvinfo)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +
> +	strscpy(drvinfo->driver, TSNEP, sizeof(drvinfo->driver));
> +	strscpy(drvinfo->bus_info, dev_name(&adapter->pdev->dev),
> +		sizeof(drvinfo->bus_info));
> +}
> +
> +static int tsnep_ethtool_get_regs_len(struct net_device *netdev)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +	int len;
> +	int num_queues;
> +
> +	len = TSNEP_MAC_SIZE;
> +	num_queues = max(adapter->num_tx_queues, adapter->num_rx_queues);
> +	len += TSNEP_QUEUE_SIZE * (num_queues - 1);
> +
> +	return len;
> +}
> +
> +static void tsnep_ethtool_get_regs(struct net_device *netdev,
> +				   struct ethtool_regs *regs,
> +				   void *p)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +
> +	regs->version = 1;
> +
> +	memcpy_fromio(p, adapter->addr, regs->len);
> +}
> +
> +static u32 tsnep_ethtool_get_msglevel(struct net_device *netdev)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +
> +	return adapter->msg_enable;
> +}
> +
> +static void tsnep_ethtool_set_msglevel(struct net_device *netdev, u32 data)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +
> +	adapter->msg_enable = data;
> +}
> +
> +static void tsnep_ethtool_get_strings(struct net_device *netdev, u32 stringset,
> +				      u8 *data)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +	int rx_count = adapter->num_rx_queues;
> +	int tx_count = adapter->num_tx_queues;
> +	int i, j;
> +
> +	switch (stringset) {
> +	case ETH_SS_STATS:
> +		memcpy(data, tsnep_stats_strings, sizeof(tsnep_stats_strings));
> +		data += sizeof(tsnep_stats_strings);
> +
> +		for (i = 0; i < rx_count; i++) {
> +			for (j = 0; j < TSNEP_RX_QUEUE_STATS_COUNT; j++) {
> +				snprintf(data, ETH_GSTRING_LEN,
> +					 tsnep_rx_queue_stats_strings[j], i);
> +				data += ETH_GSTRING_LEN;
> +			}
> +		}
> +
> +		for (i = 0; i < tx_count; i++) {
> +			for (j = 0; j < TSNEP_TX_QUEUE_STATS_COUNT; j++) {
> +				snprintf(data, ETH_GSTRING_LEN,
> +					 tsnep_tx_queue_stats_strings[j], i);
> +				data += ETH_GSTRING_LEN;
> +			}
> +		}
> +		break;
> +	case ETH_SS_TEST:
> +		tsnep_ethtool_get_test_strings(data);
> +		break;
> +	}
> +}
> +
> +static void tsnep_ethtool_get_ethtool_stats(struct net_device *netdev,
> +					    struct ethtool_stats *stats,
> +					    u64 *data)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +	int rx_count = adapter->num_rx_queues;
> +	int tx_count = adapter->num_tx_queues;
> +	struct tsnep_stats tsnep_stats;
> +	struct tsnep_rx_queue_stats tsnep_rx_queue_stats;
> +	struct tsnep_tx_queue_stats tsnep_tx_queue_stats;
> +	u32 reg;
> +	int i;
> +
> +	memset(&tsnep_stats, 0, sizeof(tsnep_stats));
> +	for (i = 0; i < adapter->num_rx_queues; i++) {
> +		tsnep_stats.rx_packets += adapter->rx[i].packets;
> +		tsnep_stats.rx_bytes += adapter->rx[i].bytes;
> +		tsnep_stats.rx_dropped += adapter->rx[i].dropped;
> +		tsnep_stats.rx_multicast += adapter->rx[i].multicast;
> +	}
> +	reg = ioread32(adapter->addr + ECM_STAT);
> +	tsnep_stats.rx_phy_errors =
> +		(reg & ECM_STAT_RX_ERR_MASK) >> ECM_STAT_RX_ERR_SHIFT;
> +	tsnep_stats.rx_forwarded_phy_errors =
> +		(reg & ECM_STAT_FWD_RX_ERR_MASK) >> ECM_STAT_FWD_RX_ERR_SHIFT;
> +	tsnep_stats.rx_invalid_frame_errors =
> +		(reg & ECM_STAT_INV_FRM_MASK) >> ECM_STAT_INV_FRM_SHIFT;
> +	for (i = 0; i < adapter->num_tx_queues; i++) {
> +		tsnep_stats.tx_packets += adapter->tx[i].packets;
> +		tsnep_stats.tx_bytes += adapter->tx[i].bytes;
> +		tsnep_stats.tx_dropped += adapter->tx[i].dropped;
> +	}
> +	memcpy(data, &tsnep_stats, sizeof(tsnep_stats));
> +	data += TSNEP_STATS_COUNT;
> +
> +	for (i = 0; i < rx_count; i++) {
> +		memset(&tsnep_rx_queue_stats, 0, sizeof(tsnep_rx_queue_stats));
> +		tsnep_rx_queue_stats.rx_packets = adapter->rx[i].packets;
> +		tsnep_rx_queue_stats.rx_bytes = adapter->rx[i].bytes;
> +		tsnep_rx_queue_stats.rx_dropped = adapter->rx[i].dropped;
> +		tsnep_rx_queue_stats.rx_multicast = adapter->rx[i].multicast;
> +		reg = ioread32(adapter->addr + TSNEP_QUEUE(i) +
> +			       TSNEP_RX_STATISTIC);
> +		tsnep_rx_queue_stats.rx_no_descriptor_errors =
> +			(reg & TSNEP_RX_STATISTIC_NO_DESC_MASK) >>
> +			TSNEP_RX_STATISTIC_NO_DESC_SHIFT;
> +		tsnep_rx_queue_stats.rx_buffer_too_small_errors =
> +			(reg & TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL_MASK) >>
> +			TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL_SHIFT;
> +		tsnep_rx_queue_stats.rx_fifo_overflow_errors =
> +			(reg & TSNEP_RX_STATISTIC_FIFO_OVERFLOW_MASK) >>
> +			TSNEP_RX_STATISTIC_FIFO_OVERFLOW_SHIFT;
> +		tsnep_rx_queue_stats.rx_invalid_frame_errors =
> +			(reg & TSNEP_RX_STATISTIC_INVALID_FRAME_MASK) >>
> +			TSNEP_RX_STATISTIC_INVALID_FRAME_SHIFT;
> +		memcpy(data, &tsnep_rx_queue_stats,
> +		       sizeof(tsnep_rx_queue_stats));
> +		data += TSNEP_RX_QUEUE_STATS_COUNT;
> +	}
> +
> +	for (i = 0; i < tx_count; i++) {
> +		memset(&tsnep_tx_queue_stats, 0, sizeof(tsnep_tx_queue_stats));
> +		tsnep_tx_queue_stats.tx_packets += adapter->tx[i].packets;
> +		tsnep_tx_queue_stats.tx_bytes += adapter->tx[i].bytes;
> +		tsnep_tx_queue_stats.tx_dropped += adapter->tx[i].dropped;
> +		memcpy(data, &tsnep_tx_queue_stats,
> +		       sizeof(tsnep_tx_queue_stats));
> +		data += TSNEP_TX_QUEUE_STATS_COUNT;
> +	}
> +}
> +
> +static int tsnep_ethtool_get_sset_count(struct net_device *netdev, int sset)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +	int rx_count;
> +	int tx_count;
> +
> +	switch (sset) {
> +	case ETH_SS_STATS:
> +		rx_count = adapter->num_rx_queues;
> +		tx_count = adapter->num_tx_queues;
> +		return TSNEP_STATS_COUNT +
> +		       TSNEP_RX_QUEUE_STATS_COUNT * rx_count +
> +		       TSNEP_TX_QUEUE_STATS_COUNT * tx_count;
> +	case ETH_SS_TEST:
> +		return tsnep_ethtool_get_test_count();
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +static int tsnep_ethtool_get_ts_info(struct net_device *dev,
> +				     struct ethtool_ts_info *info)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(dev);
> +
> +	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
> +				SOF_TIMESTAMPING_RX_SOFTWARE |
> +				SOF_TIMESTAMPING_SOFTWARE |
> +				SOF_TIMESTAMPING_TX_HARDWARE |
> +				SOF_TIMESTAMPING_RX_HARDWARE |
> +				SOF_TIMESTAMPING_RAW_HARDWARE;
> +
> +	if (adapter->ptp_clock)
> +		info->phc_index = ptp_clock_index(adapter->ptp_clock);
> +	else
> +		info->phc_index = -1;
> +
> +	info->tx_types = BIT(HWTSTAMP_TX_OFF) |
> +			 BIT(HWTSTAMP_TX_ON);
> +	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
> +			   BIT(HWTSTAMP_FILTER_ALL);
> +
> +	return 0;
> +}
> +
> +const struct ethtool_ops tsnep_ethtool_ops = {
> +	.get_drvinfo = tsnep_ethtool_get_drvinfo,
> +	.get_regs_len = tsnep_ethtool_get_regs_len,
> +	.get_regs = tsnep_ethtool_get_regs,
> +	.get_msglevel = tsnep_ethtool_get_msglevel,
> +	.set_msglevel = tsnep_ethtool_set_msglevel,
> +	.nway_reset = phy_ethtool_nway_reset,
> +	.get_link = ethtool_op_get_link,
> +	.self_test = tsnep_ethtool_self_test,
> +	.get_strings = tsnep_ethtool_get_strings,
> +	.get_ethtool_stats = tsnep_ethtool_get_ethtool_stats,
> +	.get_sset_count = tsnep_ethtool_get_sset_count,
> +	.get_ts_info = tsnep_ethtool_get_ts_info,
> +	.get_link_ksettings = phy_ethtool_get_link_ksettings,
> +	.set_link_ksettings = phy_ethtool_set_link_ksettings,
> +};
> diff --git a/drivers/net/ethernet/engleder/tsnep_hw.h b/drivers/net/ethernet/engleder/tsnep_hw.h
> new file mode 100644
> index 000000000000..71cc8577d640
> --- /dev/null
> +++ b/drivers/net/ethernet/engleder/tsnep_hw.h
> @@ -0,0 +1,230 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2021 Gerhard Engleder <gerhard@engleder-embedded.com> */
> +
> +/* Hardware definition of TSNEP and EtherCAT MAC device */
> +
> +#ifndef _TSNEP_HW_H
> +#define _TSNEP_HW_H
> +
> +#include <linux/types.h>
> +
> +/* type */
> +#define ECM_TYPE 0x0000
> +#define ECM_REVISION_MASK 0x000000FF
> +#define ECM_REVISION_SHIFT 0
> +#define ECM_VERSION_MASK 0x0000FF00
> +#define ECM_VERSION_SHIFT 8
> +#define ECM_QUEUE_COUNT_MASK 0x00070000
> +#define ECM_QUEUE_COUNT_SHIFT 16
> +#define ECM_GATE_CONTROL 0x02000000
> +
> +/* system time */
> +#define ECM_SYSTEM_TIME_LOW 0x0008
> +#define ECM_SYSTEM_TIME_HIGH 0x000C
> +
> +/* clock */
> +#define ECM_CLOCK_RATE 0x0010
> +#define ECM_CLOCK_RATE_OFFSET_MASK 0x7FFFFFFF
> +#define ECM_CLOCK_RATE_OFFSET_SIGN 0x80000000
> +
> +/* interrupt */
> +#define ECM_INT_ENABLE 0x0018
> +#define ECM_INT_ACTIVE 0x001C
> +#define ECM_INT_ACKNOWLEDGE 0x001C
> +#define ECM_INT_LINK 0x00000020
> +#define ECM_INT_TX_0 0x00000100
> +#define ECM_INT_RX_0 0x00000200
> +#define ECM_INT_ALL 0x7FFFFFFF
> +#define ECM_INT_DISABLE 0x80000000
> +
> +/* reset */
> +#define ECM_RESET 0x0020
> +#define ECM_RESET_COMMON 0x00000001
> +#define ECM_RESET_CHANNEL 0x00000100
> +#define ECM_RESET_TXRX 0x00010000
> +
> +/* control and status */
> +#define ECM_STATUS 0x0080
> +#define ECM_LINK_MODE_OFF 0x01000000
> +#define ECM_LINK_MODE_100 0x02000000
> +#define ECM_LINK_MODE_1000 0x04000000
> +#define ECM_NO_LINK 0x01000000
> +#define ECM_LINK_MODE_MASK 0x06000000
> +
> +/* management data */
> +#define ECM_MD_CONTROL 0x0084
> +#define ECM_MD_STATUS 0x0084
> +#define ECM_MD_PREAMBLE 0x00000001
> +#define ECM_MD_READ 0x00000004
> +#define ECM_MD_WRITE 0x00000002
> +#define ECM_MD_ADDR_MASK 0x000000F8
> +#define ECM_MD_ADDR_SHIFT 3
> +#define ECM_MD_PHY_ADDR_MASK 0x00001F00
> +#define ECM_MD_PHY_ADDR_SHIFT 8
> +#define ECM_MD_BUSY 0x00000001
> +#define ECM_MD_DATA_MASK 0xFFFF0000
> +#define ECM_MD_DATA_SHIFT 16
> +
> +/* statistic */
> +#define ECM_STAT 0x00B0
> +#define ECM_STAT_RX_ERR_MASK 0x000000FF
> +#define ECM_STAT_RX_ERR_SHIFT 0
> +#define ECM_STAT_INV_FRM_MASK 0x0000FF00
> +#define ECM_STAT_INV_FRM_SHIFT 8
> +#define ECM_STAT_FWD_RX_ERR_MASK 0x00FF0000
> +#define ECM_STAT_FWD_RX_ERR_SHIFT 16
> +
> +/* tsnep */
> +#define TSNEP_MAC_SIZE 0x4000
> +#define TSNEP_QUEUE_SIZE 0x1000
> +#define TSNEP_QUEUE(n) ({ typeof(n) __n = (n); \
> +			  (__n) == 0 ? \
> +			  0 : \
> +			  TSNEP_MAC_SIZE + TSNEP_QUEUE_SIZE * ((__n) - 1); })
> +#define TSNEP_MAX_QUEUES 8
> +#define TSNEP_MAX_FRAME_SIZE (2 * 1024) /* hardware supports actually 16k */
> +#define TSNEP_DESC_SIZE 256
> +#define TSNEP_DESC_OFFSET 128
> +
> +/* tsnep register */
> +#define TSNEP_INFO 0x0100
> +#define TSNEP_INFO_RX_ASSIGN 0x00010000
> +#define TSNEP_INFO_TX_TIME 0x00020000
> +#define TSNEP_CONTROL 0x0108
> +#define TSNEP_CONTROL_TX_RESET 0x00000001
> +#define TSNEP_CONTROL_TX_ENABLE 0x00000002
> +#define TSNEP_CONTROL_TX_DMA_ERROR 0x00000010
> +#define TSNEP_CONTROL_TX_DESC_ERROR 0x00000020
> +#define TSNEP_CONTROL_RX_RESET 0x00000100
> +#define TSNEP_CONTROL_RX_ENABLE 0x00000200
> +#define TSNEP_CONTROL_RX_DISABLE 0x00000400
> +#define TSNEP_CONTROL_RX_DMA_ERROR 0x00001000
> +#define TSNEP_CONTROL_RX_DESC_ERROR 0x00002000
> +#define TSNEP_TX_DESC_ADDR_LOW 0x0140
> +#define TSNEP_TX_DESC_ADDR_HIGH 0x0144
> +#define TSNEP_RX_DESC_ADDR_LOW 0x0180
> +#define TSNEP_RX_DESC_ADDR_HIGH 0x0184
> +#define TSNEP_RESET_OWNER_COUNTER 0x01
> +#define TSNEP_RX_STATISTIC 0x0190
> +#define TSNEP_RX_STATISTIC_NO_DESC_MASK 0x000000FF
> +#define TSNEP_RX_STATISTIC_NO_DESC_SHIFT 0
> +#define TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL_MASK 0x0000FF00
> +#define TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL_SHIFT 8
> +#define TSNEP_RX_STATISTIC_FIFO_OVERFLOW_MASK 0x00FF0000
> +#define TSNEP_RX_STATISTIC_FIFO_OVERFLOW_SHIFT 16
> +#define TSNEP_RX_STATISTIC_INVALID_FRAME_MASK 0xFF000000
> +#define TSNEP_RX_STATISTIC_INVALID_FRAME_SHIFT 24
> +#define TSNEP_RX_STATISTIC_NO_DESC 0x0190
> +#define TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL 0x0191
> +#define TSNEP_RX_STATISTIC_FIFO_OVERFLOW 0x0192
> +#define TSNEP_RX_STATISTIC_INVALID_FRAME 0x0193
> +#define TSNEP_RX_ASSIGN 0x01A0
> +#define TSNEP_RX_ASSIGN_ETHER_TYPE_ACTIVE 0x00000001
> +#define TSNEP_RX_ASSIGN_ETHER_TYPE_MASK 0xFFFF0000
> +#define TSNEP_RX_ASSIGN_ETHER_TYPE_SHIFT 16
> +#define TSNEP_MAC_ADDRESS_LOW 0x0800
> +#define TSNEP_MAC_ADDRESS_HIGH 0x0804
> +#define TSNEP_RX_FILTER 0x0806
> +#define TSNEP_RX_FILTER_ACCEPT_ALL_MULTICASTS 0x0001
> +#define TSNEP_RX_FILTER_ACCEPT_ALL_UNICASTS 0x0002
> +#define TSNEP_GC 0x0808
> +#define TSNEP_GC_ENABLE_A 0x00000002
> +#define TSNEP_GC_ENABLE_B 0x00000004
> +#define TSNEP_GC_DISABLE 0x00000008
> +#define TSNEP_GC_ENABLE_TIMEOUT 0x00000010
> +#define TSNEP_GC_ACTIVE_A 0x00000002
> +#define TSNEP_GC_ACTIVE_B 0x00000004
> +#define TSNEP_GC_CHANGE_AB 0x00000008
> +#define TSNEP_GC_TIMEOUT_ACTIVE 0x00000010
> +#define TSNEP_GC_TIMEOUT_SIGNAL 0x00000020
> +#define TSNEP_GC_LIST_ERROR 0x00000080
> +#define TSNEP_GC_OPEN 0x00FF0000
> +#define TSNEP_GC_OPEN_SHIFT 16
> +#define TSNEP_GC_NEXT_OPEN 0xFF000000
> +#define TSNEP_GC_NEXT_OPEN_SHIFT 24
> +#define TSNEP_GC_TIMEOUT 131072
> +#define TSNEP_GC_TIME 0x080C
> +#define TSNEP_GC_CHANGE 0x0810
> +#define TSNEP_GCL_A 0x2000
> +#define TSNEP_GCL_B 0x2800
> +#define TSNEP_GCL_SIZE SZ_2K
> +
> +/* tsnep gate control list operation */
> +struct tsnep_gcl_operation {
> +	u32 properties;
> +	u32 interval;
> +};
> +
> +#define TSNEP_GCL_COUNT (TSNEP_GCL_SIZE / sizeof(struct tsnep_gcl_operation))
> +#define TSNEP_GCL_MASK 0x000000FF
> +#define TSNEP_GCL_INSERT 0x20000000
> +#define TSNEP_GCL_CHANGE 0x40000000
> +#define TSNEP_GCL_LAST 0x80000000
> +#define TSNEP_GCL_MIN_INTERVAL 32
> +
> +/* tsnep TX/RX descriptor */
> +#define TSNEP_DESC_SIZE 256
> +#define TSNEP_DESC_SIZE_DATA_AFTER 2048
> +#define TSNEP_DESC_OFFSET 128
> +#define TSNEP_DESC_OWNER_COUNTER_MASK 0xC0000000
> +#define TSNEP_DESC_OWNER_COUNTER_SHIFT 30
> +#define TSNEP_DESC_LENGTH_MASK 0x00003FFF
> +#define TSNEP_DESC_INTERRUPT_FLAG 0x00040000
> +#define TSNEP_DESC_EXTENDED_WRITEBACK_FLAG 0x00080000
> +#define TSNEP_DESC_NO_LINK_FLAG 0x01000000
> +
> +/* tsnep TX descriptor */
> +struct tsnep_tx_desc {
> +	__le32 properties;
> +	__le32 more_properties;
> +	__le32 reserved[2];
> +	__le64 next;
> +	__le64 tx;
> +};
> +
> +#define TSNEP_TX_DESC_OWNER_MASK 0xE0000000
> +#define TSNEP_TX_DESC_OWNER_USER_FLAG 0x20000000
> +#define TSNEP_TX_DESC_LAST_FRAGMENT_FLAG 0x00010000
> +#define TSNEP_TX_DESC_DATA_AFTER_DESC_FLAG 0x00020000
> +
> +/* tsnep TX descriptor writeback */
> +struct tsnep_tx_desc_wb {
> +	__le32 properties;
> +	__le32 reserved1[3];
> +	__le64 timestamp;
> +	__le32 dma_delay;
> +	__le32 reserved2;
> +};
> +
> +#define TSNEP_TX_DESC_UNDERRUN_ERROR_FLAG 0x00010000
> +#define TSNEP_TX_DESC_DMA_DELAY_FIRST_DATA_MASK 0x0000FFFC
> +#define TSNEP_TX_DESC_DMA_DELAY_FIRST_DATA_SHIFT 2
> +#define TSNEP_TX_DESC_DMA_DELAY_LAST_DATA_MASK 0xFFFC0000
> +#define TSNEP_TX_DESC_DMA_DELAY_LAST_DATA_SHIFT 18
> +#define TSNEP_TX_DESC_DMA_DELAY_NS 64
> +
> +/* tsnep RX descriptor */
> +struct tsnep_rx_desc {
> +	__le32 properties;
> +	__le32 reserved[3];
> +	__le64 next;
> +	__le64 rx;
> +};
> +
> +#define TSNEP_RX_DESC_BUFFER_SIZE_MASK 0x00003FFC
> +
> +/* tsnep RX descriptor writeback */
> +struct tsnep_rx_desc_wb {
> +	__le32 properties;
> +	__le32 reserved[7];
> +};
> +
> +/* tsnep RX inline meta */
> +struct tsnep_rx_inline {
> +	__le64 reserved;
> +	__le64 timestamp;
> +};
> +
> +#define TSNEP_RX_INLINE_METADATA_SIZE (sizeof(struct tsnep_rx_inline))
> +
> +#endif /* _TSNEP_HW_H */
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
> new file mode 100644
> index 000000000000..86d488821a65
> --- /dev/null
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -0,0 +1,1255 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2021 Gerhard Engleder <gerhard@engleder-embedded.com> */
> +
> +/* TSN endpoint Ethernet MAC driver
> + *
> + * The TSN endpoint Ethernet MAC is a FPGA based network device for real-time
> + * communication. It is designed for endpoints within TSN (Time Sensitive
> + * Networking) networks; e.g., for PLCs in the industrial automation case.
> + *
> + * It supports multiple TX/RX queue pairs. The first TX/RX queue pair is used
> + * by the driver.
> + *
> + * More information can be found here:
> + * - www.embedded-experts.at/tsn
> + * - www.engleder-embedded.com
> + */
> +
> +#include "tsnep.h"
> +#include "tsnep_hw.h"
> +
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_net.h>
> +#include <linux/of_mdio.h>
> +#include <linux/interrupt.h>
> +#include <linux/etherdevice.h>
> +#include <linux/phy.h>
> +#include <linux/iopoll.h>
> +
> +#define RX_SKB_LENGTH (round_up(TSNEP_RX_INLINE_METADATA_SIZE + ETH_HLEN + \
> +				TSNEP_MAX_FRAME_SIZE + ETH_FCS_LEN, 4))
> +#define RX_SKB_RESERVE ((16 - TSNEP_RX_INLINE_METADATA_SIZE) + NET_IP_ALIGN)
> +#define RX_SKB_ALLOC_LENGTH (RX_SKB_RESERVE + RX_SKB_LENGTH)
> +
> +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> +#define DMA_ADDR_HIGH(dma_addr) ((u32)(((dma_addr) >> 32) & 0xFFFFFFFF))
> +#else
> +#define DMA_ADDR_HIGH(dma_addr) ((u32)(0))
> +#endif
> +#define DMA_ADDR_LOW(dma_addr) ((u32)((dma_addr) & 0xFFFFFFFF))
> +
> +static void tsnep_enable_irq(struct tsnep_adapter *adapter, u32 mask)
> +{
> +	iowrite32(mask, adapter->addr + ECM_INT_ENABLE);
> +}
> +
> +static void tsnep_disable_irq(struct tsnep_adapter *adapter, u32 mask)
> +{
> +	mask |= ECM_INT_DISABLE;
> +	iowrite32(mask, adapter->addr + ECM_INT_ENABLE);
> +}
> +
> +static irqreturn_t tsnep_irq(int irq, void *arg)
> +{
> +	struct tsnep_adapter *adapter = arg;
> +	u32 active = ioread32(adapter->addr + ECM_INT_ACTIVE);
> +
> +	/* acknowledge interrupt */
> +	if (active != 0)
> +		iowrite32(active, adapter->addr + ECM_INT_ACKNOWLEDGE);
> +
> +	/* handle link interrupt */
> +	if ((active & ECM_INT_LINK) != 0) {
> +		if (adapter->netdev->phydev)
> +			phy_mac_interrupt(adapter->netdev->phydev);
> +	}
> +
> +	/* handle TX/RX queue 0 interrupt */
> +	if ((active & adapter->queue[0].irq_mask) != 0) {
> +		if (adapter->netdev) {
> +			tsnep_disable_irq(adapter, adapter->queue[0].irq_mask);
> +			napi_schedule(&adapter->queue[0].napi);
> +		}
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int tsnep_mdiobus_read(struct mii_bus *bus, int addr, int regnum)
> +{
> +	struct tsnep_adapter *adapter = bus->priv;
> +	u32 md;
> +	int retval;
> +
> +	if (regnum & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +
> +	md = ECM_MD_READ;
> +	if (!adapter->suppress_preamble)
> +		md |= ECM_MD_PREAMBLE;
> +	md |= (regnum << ECM_MD_ADDR_SHIFT) & ECM_MD_ADDR_MASK;
> +	md |= (addr << ECM_MD_PHY_ADDR_SHIFT) & ECM_MD_PHY_ADDR_MASK;
> +	iowrite32(md, adapter->addr + ECM_MD_CONTROL);
> +	retval = readl_poll_timeout_atomic(adapter->addr + ECM_MD_STATUS, md,
> +					   !(md & ECM_MD_BUSY), 16, 1000);
> +	if (retval != 0)
> +		return retval;
> +
> +	return (md & ECM_MD_DATA_MASK) >> ECM_MD_DATA_SHIFT;
> +}
> +
> +static int tsnep_mdiobus_write(struct mii_bus *bus, int addr, int regnum,
> +			       u16 val)
> +{
> +	struct tsnep_adapter *adapter = bus->priv;
> +	u32 md;
> +	int retval;
> +
> +	if (regnum & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +
> +	md = ECM_MD_WRITE;
> +	if (!adapter->suppress_preamble)
> +		md |= ECM_MD_PREAMBLE;
> +	md |= (regnum << ECM_MD_ADDR_SHIFT) & ECM_MD_ADDR_MASK;
> +	md |= (addr << ECM_MD_PHY_ADDR_SHIFT) & ECM_MD_PHY_ADDR_MASK;
> +	md |= ((u32)val << ECM_MD_DATA_SHIFT) & ECM_MD_DATA_MASK;
> +	iowrite32(md, adapter->addr + ECM_MD_CONTROL);
> +	retval = readl_poll_timeout_atomic(adapter->addr + ECM_MD_STATUS, md,
> +					   !(md & ECM_MD_BUSY), 16, 1000);
> +	if (retval != 0)
> +		return retval;
> +
> +	return 0;
> +}
> +
> +static void tsnep_phy_link_status_change(struct net_device *netdev)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +	struct phy_device *phydev = netdev->phydev;
> +	u32 mode;
> +
> +	if (phydev->link) {
> +		switch (phydev->speed) {
> +		case SPEED_100:
> +			mode = ECM_LINK_MODE_100;
> +			break;
> +		case SPEED_1000:
> +			mode = ECM_LINK_MODE_1000;
> +			break;
> +		default:
> +			mode = ECM_LINK_MODE_OFF;
> +			break;
> +		}
> +		iowrite32(mode, adapter->addr + ECM_STATUS);
> +	}
> +
> +	phy_print_status(netdev->phydev);
> +}
> +
> +static int tsnep_phy_open(struct tsnep_adapter *adapter)
> +{
> +	struct phy_device *phydev;
> +	struct ethtool_eee ethtool_eee;
> +	int retval;
> +
> +	retval = phy_connect_direct(adapter->netdev, adapter->phydev,
> +				    tsnep_phy_link_status_change,
> +				    adapter->phy_mode);
> +	if (retval)
> +		return retval;
> +	phydev = adapter->netdev->phydev;
> +
> +	/* MAC supports only 100Mbps|1000Mbps full duplex
> +	 * SPE (Single Pair Ethernet) is also an option but not implemented yet
> +	 */
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> +
> +	/* disable EEE autoneg, EEE not supported by TSNEP */
> +	memset(&ethtool_eee, 0, sizeof(ethtool_eee));
> +	phy_ethtool_set_eee(adapter->phydev, &ethtool_eee);
> +
> +	adapter->phydev->irq = PHY_MAC_INTERRUPT;
> +	phy_start(adapter->phydev);
> +
> +	return 0;
> +}
> +
> +static void tsnep_phy_close(struct tsnep_adapter *adapter)
> +{
> +	phy_stop(adapter->netdev->phydev);
> +	phy_disconnect(adapter->netdev->phydev);
> +	adapter->netdev->phydev = NULL;
> +}
> +
> +static void tsnep_tx_ring_cleanup(struct tsnep_tx *tx)
> +{
> +	struct device *dmadev = tx->adapter->dmadev;
> +	int i;
> +
> +	memset(tx->entry, 0, sizeof(tx->entry));
> +
> +	for (i = 0; i < TSNEP_RING_PAGE_COUNT; i++) {
> +		if (tx->page[i]) {
> +			dma_free_coherent(dmadev, PAGE_SIZE, tx->page[i],
> +					  tx->page_dma[i]);
> +			tx->page[i] = NULL;
> +			tx->page_dma[i] = 0;
> +		}
> +	}
> +}
> +
> +static int tsnep_tx_ring_init(struct tsnep_tx *tx)
> +{
> +	struct device *dmadev = tx->adapter->dmadev;
> +	struct tsnep_tx_entry *entry;
> +	struct tsnep_tx_entry *next_entry;
> +	int i, j;
> +	int retval;
> +
> +	for (i = 0; i < TSNEP_RING_PAGE_COUNT; i++) {
> +		tx->page[i] =
> +			dma_alloc_coherent(dmadev, PAGE_SIZE, &tx->page_dma[i],
> +					   GFP_KERNEL);
> +		if (!tx->page[i]) {
> +			retval = -ENOMEM;
> +			goto alloc_failed;
> +		}
> +		for (j = 0; j < TSNEP_RING_ENTRIES_PER_PAGE; j++) {
> +			entry = &tx->entry[TSNEP_RING_ENTRIES_PER_PAGE * i + j];
> +			entry->desc_wb = (struct tsnep_tx_desc_wb *)
> +				(((u8 *)tx->page[i]) + TSNEP_DESC_SIZE * j);
> +			entry->desc = (struct tsnep_tx_desc *)
> +				(((u8 *)entry->desc_wb) + TSNEP_DESC_OFFSET);
> +			entry->desc_dma = tx->page_dma[i] + TSNEP_DESC_SIZE * j;
> +		}
> +	}
> +	for (i = 0; i < TSNEP_RING_SIZE; i++) {
> +		entry = &tx->entry[i];
> +		next_entry = &tx->entry[(i + 1) % TSNEP_RING_SIZE];
> +		entry->desc->next = __cpu_to_le64(next_entry->desc_dma);
> +	}
> +
> +	return 0;
> +
> +alloc_failed:
> +	tsnep_tx_ring_cleanup(tx);
> +	return retval;
> +}
> +
> +static void tsnep_tx_activate(struct tsnep_tx *tx, int index, bool last)
> +{
> +	struct tsnep_tx_entry *entry = &tx->entry[index];
> +
> +	entry->properties = 0;
> +	if (entry->skb) {
> +		entry->properties =
> +			skb_pagelen(entry->skb) & TSNEP_DESC_LENGTH_MASK;
> +		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
> +		if (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
> +			entry->properties |= TSNEP_DESC_EXTENDED_WRITEBACK_FLAG;
> +
> +		/* toggle user flag to prevent false acknowledge
> +		 *
> +		 * Only the first fragment is acknowledged. For all other
> +		 * fragments no acknowledge is done and the last written owner
> +		 * counter stays in the writeback descriptor. Therefore, it is
> +		 * possible that the last written owner counter is identical to
> +		 * the new incremented owner counter and a false acknowledge is
> +		 * detected before the real acknowledge has been done by
> +		 * hardware.
> +		 *
> +		 * The user flag is used to prevent this situation. The user
> +		 * flag is copied to the writeback descriptor by the hardware
> +		 * and is used as additional acknowledge data. By toggeling the
> +		 * user flag only for the first fragment (which is
> +		 * acknowledged), it is guaranteed that the last acknowledge
> +		 * done for this descriptor has used a different user flag and
> +		 * cannot be detected as false acknowledge.
> +		 */
> +		entry->owner_user_flag = !entry->owner_user_flag;
> +	}
> +	if (last)
> +		entry->properties |= TSNEP_TX_DESC_LAST_FRAGMENT_FLAG;
> +	if (index == tx->increment_owner_counter) {
> +		tx->owner_counter++;
> +		if (tx->owner_counter == 4)
> +			tx->owner_counter = 1;
> +		tx->increment_owner_counter--;
> +		if (tx->increment_owner_counter < 0)
> +			tx->increment_owner_counter = TSNEP_RING_SIZE - 1;
> +	}
> +	entry->properties |=
> +		(tx->owner_counter << TSNEP_DESC_OWNER_COUNTER_SHIFT) &
> +		TSNEP_DESC_OWNER_COUNTER_MASK;
> +	if (entry->owner_user_flag)
> +		entry->properties |= TSNEP_TX_DESC_OWNER_USER_FLAG;
> +	entry->desc->more_properties =
> +		__cpu_to_le32(entry->len & TSNEP_DESC_LENGTH_MASK);
> +
> +	dma_wmb();
> +
> +	entry->desc->properties = __cpu_to_le32(entry->properties);
> +}
> +
> +static int tsnep_tx_desc_available(struct tsnep_tx *tx)
> +{
> +	if (tx->read <= tx->write)
> +		return TSNEP_RING_SIZE - tx->write + tx->read - 1;
> +	else
> +		return tx->read - tx->write - 1;
> +}
> +
> +static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
> +{
> +	struct device *dmadev = tx->adapter->dmadev;
> +	struct tsnep_tx_entry *entry;
> +	unsigned int len;
> +	dma_addr_t dma;
> +	int i;
> +
> +	for (i = 0; i < count; i++) {
> +		entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
> +
> +		if (i == 0) {
> +			len = skb_headlen(skb);
> +			dma = dma_map_single(dmadev, skb->data, len,
> +					     DMA_TO_DEVICE);
> +		} else {
> +			len = skb_frag_size(&skb_shinfo(skb)->frags[i - 1]);
> +			dma = skb_frag_dma_map(dmadev,
> +					       &skb_shinfo(skb)->frags[i - 1],
> +					       0, len, DMA_TO_DEVICE);
> +		}
> +		if (dma_mapping_error(dmadev, dma))
> +			return -ENOMEM;
> +
> +		dma_unmap_len_set(entry, len, len);
> +		dma_unmap_addr_set(entry, dma, dma);
> +
> +		entry->desc->tx = __cpu_to_le64(dma);
> +	}
> +
> +	return 0;
> +}
> +
> +static void tsnep_tx_unmap(struct tsnep_tx *tx, int count)
> +{
> +	struct device *dmadev = tx->adapter->dmadev;
> +	struct tsnep_tx_entry *entry;
> +	int i;
> +
> +	for (i = 0; i < count; i++) {
> +		entry = &tx->entry[(tx->read + i) % TSNEP_RING_SIZE];
> +
> +		if (dma_unmap_len(entry, len)) {
> +			if (i == 0)
> +				dma_unmap_single(dmadev,
> +						 dma_unmap_addr(entry, dma),
> +						 dma_unmap_len(entry, len),
> +						 DMA_TO_DEVICE);
> +			else
> +				dma_unmap_page(dmadev,
> +					       dma_unmap_addr(entry, dma),
> +					       dma_unmap_len(entry, len),
> +					       DMA_TO_DEVICE);
> +			dma_unmap_len_set(entry, len, 0);
> +		}
> +	}
> +}
> +
> +static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
> +					 struct tsnep_tx *tx)
> +{
> +	unsigned long flags;
> +	int count = 1;
> +	struct tsnep_tx_entry *entry;
> +	int i;
> +	int retval;
> +
> +	if (skb_shinfo(skb)->nr_frags > 0)
> +		count += skb_shinfo(skb)->nr_frags;
> +
> +	spin_lock_irqsave(&tx->lock, flags);
> +
> +	if (tsnep_tx_desc_available(tx) < count) {
> +		/* ring full, shall not happen because queue is stopped if full
> +		 * below
> +		 */
> +		netif_stop_queue(tx->adapter->netdev);
> +
> +		spin_unlock_irqrestore(&tx->lock, flags);
> +
> +		return NETDEV_TX_BUSY;
> +	}
> +
> +	entry = &tx->entry[tx->write];
> +	entry->skb = skb;
> +
> +	retval = tsnep_tx_map(skb, tx, count);
> +	if (retval != 0) {
> +		tsnep_tx_unmap(tx, count);
> +		dev_kfree_skb_any(entry->skb);
> +		entry->skb = NULL;
> +
> +		tx->dropped++;
> +
> +		spin_unlock_irqrestore(&tx->lock, flags);
> +
> +		netdev_err(tx->adapter->netdev, "TX DMA map failed\n");
> +
> +		return NETDEV_TX_OK;
> +	}
> +
> +	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
> +		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> +
> +	for (i = 0; i < count; i++)
> +		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE,
> +				  i == (count - 1));
> +	skb_tx_timestamp(skb);
> +
> +	/* entry->properties shall be valid before write pointer is
> +	 * incrememted
> +	 */
> +	wmb();

A lighter variant like smp_wmb() is not sufficient here?

> +	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
> +
> +	iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
> +
> +	if (tsnep_tx_desc_available(tx) < (MAX_SKB_FRAGS + 1)) {
> +		/* ring can get full with next frame */
> +		netif_stop_queue(tx->adapter->netdev);
> +	}
> +
> +	tx->packets++;
> +	tx->bytes += skb_pagelen(entry->skb) + ETH_FCS_LEN;
> +
> +	spin_unlock_irqrestore(&tx->lock, flags);
> +
> +	return NETDEV_TX_OK;
> +}
> +
> +static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
> +{
> +	unsigned long flags;
> +	int budget = 128;
> +	struct tsnep_tx_entry *entry;
> +	int count;
> +
> +	spin_lock_irqsave(&tx->lock, flags);
> +
> +	do {
> +		if (tx->read == tx->write)
> +			break;
> +
> +		entry = &tx->entry[tx->read];
> +		if ((__le32_to_cpu(entry->desc_wb->properties) &
> +		     TSNEP_TX_DESC_OWNER_MASK) !=
> +		    (entry->properties & TSNEP_TX_DESC_OWNER_MASK))
> +			break;
> +
> +		dma_rmb();
> +

Memory barriers should always have a comment explaining why
they are needed. I think checkpatch would complain here.
