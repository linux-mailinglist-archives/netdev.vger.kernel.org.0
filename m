Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B51538EB5
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 12:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbiEaKUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 06:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245684AbiEaKUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 06:20:14 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A168D6A8
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 03:20:11 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id t5so16872071edc.2
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 03:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fJ8xPOQaHnkv4TRDjJb3VLzxkUSIfbFoPbt4lZK3Zpo=;
        b=SXwNfEGZzOFCa8JLysYX2ijqY/f6+BYKVtYzmJxzuyOrl33yZVvNpHpFEppuBJsoo8
         oVSpdaugr55+DBZqeqEi4ZkzVNd5uAZEj48Nfjmk+KLVy+BYfVVzglfn+pgDTXeYlq6J
         HZ78oEDRBzDEA6x62kUS0tzMoVnlzNoSimLrFxtf+RFFAZa4AooFdAI7AOs8eRsF2DLR
         qtxD1ST573iB5gcDN/Q/GJH6coa0em8EitXGGyJ5FM8n2erQ834kYWasTRcVCPrbBkAE
         HKHXvuwMsFwRis4NRz7qtVOKQSyjG0PDpjKnAR88c08yiwbfRraA0Tlq83WQX1AAs0NQ
         k3xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fJ8xPOQaHnkv4TRDjJb3VLzxkUSIfbFoPbt4lZK3Zpo=;
        b=LbfdYNRlyKNvtdE/81yjh3USG4QpHF/gXsczwfKjlUfRANXm4pXDXeGnV6DUjTdN0A
         ysRSlsVMC4pvjZRiy91mWAJeNk+wiHgQbHcBrUsZTvRCEvkzUxnMK7nkWMaEoZL52bmj
         oQEJBftfhmGb2Rnq9xx98VxQfoyEJZGeJTHmP4vLflhE06fw5LmO+KzaPtn83B5MGfrM
         zlDDRlXCg7jv0rvIeMRi+fql6zZYV5GKmQwHEGJWzyFVhd4P3kRSB2NndXd1MXts4YBq
         Wo9Lj6ZpM/5BddekTBCzzdGd4beBYZfUMEoQjwaj3Vn4koXbRLSMGOb9Rur3lqaijxcB
         LF7A==
X-Gm-Message-State: AOAM532kFChRdvDvoJUGkvSKR7XUP7yd0QYFFjTsJ+fiA8rfJJG1aFSc
        BLEKIa2ZMHr4h3Y7Qh7hJQ0L2w==
X-Google-Smtp-Source: ABdhPJzt+cJnCOetPrRyfrDDgZyWqr3+beN2dCNHh3jtlzo+NdXZrnEPKKhSJjfU2APcbk5LO1kulQ==
X-Received: by 2002:a50:9b11:0:b0:42a:c1b2:b2ca with SMTP id o17-20020a509b11000000b0042ac1b2b2camr61739464edi.313.1653992409790;
        Tue, 31 May 2022 03:20:09 -0700 (PDT)
Received: from [192.168.0.179] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id k16-20020a1709063e1000b006f4c557b7d2sm4807570eji.203.2022.05.31.03.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 03:20:09 -0700 (PDT)
Message-ID: <b881efcd-3d8a-fffb-5330-b67317d25d2d@linaro.org>
Date:   Tue, 31 May 2022 12:20:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
Content-Language: en-US
To:     Puranjay Mohan <p-mohan@ti.com>, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, nm@ti.com, ssantosh@kernel.org,
        s-anna@ti.com, linux-arm-kernel@lists.infradead.org,
        rogerq@kernel.org, grygorii.strashko@ti.com, vigneshr@ti.com,
        kishon@ti.com, robh+dt@kernel.org, afd@ti.com, andrew@lunn.ch
References: <20220531095108.21757-1-p-mohan@ti.com>
 <20220531095108.21757-3-p-mohan@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220531095108.21757-3-p-mohan@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/05/2022 11:51, Puranjay Mohan wrote:
> From: Roger Quadros <rogerq@ti.com>
> 
> This is the Ethernet driver for TI AM654 Silicon rev. 2
> with the ICSSG PRU Sub-system running dual-EMAC firmware.
> 
> The Programmable Real-time Unit and Industrial Communication Subsystem
> Gigabit (PRU_ICSSG) is a low-latency microcontroller subsystem in the TI
> SoCs. This subsystem is provided for the use cases like implementation of
> custom peripheral interfaces, offloading of tasks from the other
> processor cores of the SoC, etc.
> 
> Every ICSSG core has two Programmable Real-Time Unit(PRUs),
> two auxiliary Real-Time Transfer Unit (RT_PRUs), and
> two Transmit Real-Time Transfer Units (TX_PRUs). Each one of these runs
> its own firmware. Every ICSSG core has two MII ports connect to these
> PRUs and also a MDIO port.
> 
> The cores can run different firmwares to support different protocols and
> features like switch-dev, timestamping, etc.
> 
> It uses System DMA to transfer and receive packets and
> shared memory register emulation between the firmware and
> driver for control and configuration.
> 
> This patch adds support for basic EMAC functionality with 1Gbps
> and 100Mbps link speed. 10M and half duplex mode are not supported
> currently as they require IEP, the support for which will be added later.
> Support for switch-dev, timestamp, etc. will be added later
> by subsequent patch series.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> [Vignesh Raghavendra: add 10M full duplex support]
> Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
> [Grygorii Strashko: add support for half duplex operation]
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> ---
> v1: https://lore.kernel.org/all/20220506052433.28087-3-p-mohan@ti.com/
> v1 -> v2:
> * Addressed Andrew's comments
> * Used iopoll in place of a loop
> * Moved phydev from private data to ndev
> * Used netdev_err() in place of pr_err()
> * Used phy_ethtool_set_link_ksettings() in 
>   place of phy_ethtool_ksettings_set() and similar
> * Added error checking to DT logic.
> ---
>  drivers/net/ethernet/ti/Kconfig            |   15 +
>  drivers/net/ethernet/ti/Makefile           |    3 +
>  drivers/net/ethernet/ti/icssg_classifier.c |  375 ++++
>  drivers/net/ethernet/ti/icssg_config.c     |  440 +++++
>  drivers/net/ethernet/ti/icssg_config.h     |  200 +++
>  drivers/net/ethernet/ti/icssg_ethtool.c    |  319 ++++
>  drivers/net/ethernet/ti/icssg_mii_cfg.c    |  104 ++
>  drivers/net/ethernet/ti/icssg_mii_rt.h     |  151 ++
>  drivers/net/ethernet/ti/icssg_prueth.c     | 1889 ++++++++++++++++++++
>  drivers/net/ethernet/ti/icssg_prueth.h     |  246 +++
>  drivers/net/ethernet/ti/icssg_switch_map.h |  183 ++
>  include/linux/pruss.h                      |    1 +
>  12 files changed, 3926 insertions(+)
>  create mode 100644 drivers/net/ethernet/ti/icssg_classifier.c
>  create mode 100644 drivers/net/ethernet/ti/icssg_config.c
>  create mode 100644 drivers/net/ethernet/ti/icssg_config.h
>  create mode 100644 drivers/net/ethernet/ti/icssg_ethtool.c
>  create mode 100644 drivers/net/ethernet/ti/icssg_mii_cfg.c
>  create mode 100644 drivers/net/ethernet/ti/icssg_mii_rt.h
>  create mode 100644 drivers/net/ethernet/ti/icssg_prueth.c
>  create mode 100644 drivers/net/ethernet/ti/icssg_prueth.h
>  create mode 100644 drivers/net/ethernet/ti/icssg_switch_map.h
> 
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index fb30bc5d56cb..500d0591ad2a 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -182,4 +182,19 @@ config CPMAC
>  	help
>  	  TI AR7 CPMAC Ethernet support
>  
> +config TI_ICSSG_PRUETH
> +	tristate "TI Gigabit PRU Ethernet driver"
> +	select PHYLIB
> +

No need for blank line.

> +	depends on PRU_REMOTEPROC
> +	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
> +	help
> +	  Support dual Gigabit Ethernet ports over the ICSSG PRU Subsystem
> +	  This subsystem is available starting with the AM65 platform.
> +
> +	  This driver requires firmware binaries which will run on the PRUs
> +	  to support the ethernet operation. Currently, it supports Ethernet
> +	  with 1G and 100M link speed.
> +
> +

Only one blank line.

>  endif # NET_VENDOR_TI
> diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Makefile
> index 75f761efbea7..963691511357 100644
> --- a/drivers/net/ethernet/ti/Makefile
> +++ b/drivers/net/ethernet/ti/Makefile
> @@ -28,3 +28,6 @@ obj-$(CONFIG_TI_K3_AM65_CPSW_NUSS) += ti-am65-cpsw-nuss.o
>  ti-am65-cpsw-nuss-y := am65-cpsw-nuss.o cpsw_sl.o am65-cpsw-ethtool.o cpsw_ale.o k3-cppi-desc-pool.o am65-cpsw-qos.o
>  ti-am65-cpsw-nuss-$(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV) += am65-cpsw-switchdev.o
>  obj-$(CONFIG_TI_K3_AM65_CPTS) += am65-cpts.o
> +

No need for blank line.

> +obj-$(CONFIG_TI_ICSSG_PRUETH) += icssg-prueth.o
> +icssg-prueth-y := icssg_prueth.o icssg_classifier.o icssg_ethtool.o icssg_config.o k3-cppi-desc-pool.o icssg_mii_cfg.o
> diff --git a/drivers/net/ethernet/ti/icssg_classifier.c b/drivers/net/ethernet/ti/icssg_classifier.c
> new file mode 100644
> index 000000000000..0d3325822ce2
> --- /dev/null
> +++ b/drivers/net/ethernet/ti/icssg_classifier.c
> @@ -0,0 +1,375 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Texas Instruments ICSSG Ethernet Driver
> + *
> + * Copyright (C) 2018-2022 Texas Instruments Incorporated - https://www.ti.com/
> + *
> + */
> +
> +#include <linux/etherdevice.h>
> +#include <linux/types.h>
> +#include <linux/regmap.h>
> +
> +#include "icssg_prueth.h"
> +
> +#define ICSSG_NUM_CLASSIFIERS	16
> +#define ICSSG_NUM_FT1_SLOTS	8
> +#define ICSSG_NUM_FT3_SLOTS	16
> +
> +#define ICSSG_NUM_CLASSIFIERS_IN_USE	5
> +
> +/* Filter 1 - FT1 */
> +#define FT1_NUM_SLOTS	8
> +#define FT1_SLOT_SIZE	0x10	/* bytes */
> +
> +/* offsets from FT1 slot base i.e. slot 1 start */
> +#define FT1_DA0		0x0
> +#define FT1_DA1		0x4
> +#define FT1_DA0_MASK	0x8
> +#define FT1_DA1_MASK	0xc
> +
> +#define FT1_N_REG(slize, n, reg)	(offs[slice].ft1_slot_base + FT1_SLOT_SIZE * (n) + (reg))
> +
> +#define FT1_LEN_MASK	GENMASK(19, 16)
> +#define FT1_LEN_SHIFT	16
> +#define FT1_LEN(len)	(((len) << FT1_LEN_SHIFT) & FT1_LEN_MASK)
> +
> +#define FT1_START_MASK	GENMASK(14, 0)
> +#define FT1_START(start)	((start) & FT1_START_MASK)
> +
> +#define FT1_MATCH_SLOT(n)	(GENMASK(23, 16) & (BIT(n) << 16))
> +
> +enum ft1_cfg_type {
> +	FT1_CFG_TYPE_DISABLED = 0,
> +	FT1_CFG_TYPE_EQ,
> +	FT1_CFG_TYPE_GT,
> +	FT1_CFG_TYPE_LT,
> +};
> +
> +#define FT1_CFG_SHIFT(n)	(2 * (n))
> +#define FT1_CFG_MASK(n)	(0x3 << FT1_CFG_SHIFT((n)))
> +
> +/* Filter 3 -  FT3 */
> +#define FT3_NUM_SLOTS	16
> +#define FT3_SLOT_SIZE	0x20	/* bytes */
> +
> +/* offsets from FT3 slot n's base */
> +#define FT3_START	0
> +#define FT3_START_AUTO	0x4
> +#define FT3_START_OFFSET	0x8
> +#define FT3_JUMP_OFFSET	0xc
> +#define FT3_LEN		0x10
> +#define FT3_CFG		0x14
> +#define FT3_T		0x18
> +#define FT3_T_MASK	0x1c
> +
> +#define FT3_N_REG(slize, n, reg)	(offs[slice].ft3_slot_base + FT3_SLOT_SIZE * (n) + (reg))
> +
> +/* offsets from rx_class n's base */
> +#define RX_CLASS_AND_EN	0
> +#define RX_CLASS_OR_EN	0x4
> +
> +#define RX_CLASS_NUM_SLOTS	16
> +#define RX_CLASS_EN_SIZE	0x8	/* bytes */
> +
> +#define RX_CLASS_N_REG(slice, n, reg)	(offs[slice].rx_class_base + RX_CLASS_EN_SIZE * (n) + (reg))
> +
> +/* RX Class Gates */
> +#define RX_CLASS_GATES_SIZE	0x4	/* bytes */
> +
> +#define RX_CLASS_GATES_N_REG(slice, n)	\
> +	(offs[slice].rx_class_gates_base + RX_CLASS_GATES_SIZE * (n))
> +
> +#define RX_CLASS_GATES_ALLOW_MASK	BIT(6)
> +#define RX_CLASS_GATES_RAW_MASK		BIT(5)
> +#define RX_CLASS_GATES_PHASE_MASK	BIT(4)
> +
> +/* RX Class traffic data matching bits */
> +#define RX_CLASS_FT_UC		BIT(31)
> +#define RX_CLASS_FT_MC		BIT(30)
> +#define RX_CLASS_FT_BC		BIT(29)
> +#define RX_CLASS_FT_FW		BIT(28)
> +#define RX_CLASS_FT_RCV		BIT(27)
> +#define RX_CLASS_FT_VLAN	BIT(26)
> +#define RX_CLASS_FT_DA_P	BIT(25)
> +#define RX_CLASS_FT_DA_I	BIT(24)
> +#define RX_CLASS_FT_FT1_MATCH_MASK	GENMASK(23, 16)
> +#define RX_CLASS_FT_FT1_MATCH_SHIFT	16
> +#define RX_CLASS_FT_FT3_MATCH_MASK	GENMASK(15, 0)
> +#define RX_CLASS_FT_FT3_MATCH_SHIFT	0
> +
> +#define RX_CLASS_FT_FT1_MATCH(slot)	\
> +	((BIT(slot) << RX_CLASS_FT_FT1_MATCH_SHIFT) & RX_CLASS_FT_FT1_MATCH_MASK)
> +
> +enum rx_class_sel_type {
> +	RX_CLASS_SEL_TYPE_OR = 0,
> +	RX_CLASS_SEL_TYPE_AND = 1,
> +	RX_CLASS_SEL_TYPE_OR_AND_AND = 2,
> +	RX_CLASS_SEL_TYPE_OR_OR_AND = 3,
> +};
> +
> +#define FT1_CFG_SHIFT(n)	(2 * (n))
> +#define FT1_CFG_MASK(n)		(0x3 << FT1_CFG_SHIFT((n)))
> +
> +#define RX_CLASS_SEL_SHIFT(n)	(2 * (n))
> +#define RX_CLASS_SEL_MASK(n)	(0x3 << RX_CLASS_SEL_SHIFT((n)))
> +
> +#define ICSSG_CFG_OFFSET	0
> +#define MAC_INTERFACE_0		0x18
> +#define MAC_INTERFACE_1		0x1c
> +
> +#define ICSSG_CFG_RX_L2_G_EN	BIT(2)
> +
> +/* these are register offsets per PRU */
> +struct miig_rt_offsets {
> +	u32 mac0;
> +	u32 mac1;
> +	u32 ft1_start_len;
> +	u32 ft1_cfg;
> +	u32 ft1_slot_base;
> +	u32 ft3_slot_base;
> +	u32 ft3_p_base;
> +	u32 ft_rx_ptr;
> +	u32 rx_class_base;
> +	u32 rx_class_cfg1;
> +	u32 rx_class_cfg2;
> +	u32 rx_class_gates_base;
> +	u32 rx_green;
> +	u32 rx_rate_cfg_base;
> +	u32 rx_rate_src_sel0;
> +	u32 rx_rate_src_sel1;
> +	u32 tx_rate_cfg_base;
> +	u32 stat_base;
> +	u32 tx_hsr_tag;
> +	u32 tx_hsr_seq;
> +	u32 tx_vlan_type;
> +	u32 tx_vlan_ins;
> +};
> +
> +static struct miig_rt_offsets offs[] = {

Isn't this const?

> +	/* PRU0 */
> +	{
> +		0x8,
> +		0xc,
> +		0x80,
> +		0x84,
> +		0x88,
> +		0x108,
> +		0x308,
> +		0x408,
> +		0x40c,
> +		0x48c,
> +		0x490,
> +		0x494,
> +		0x4d4,
> +		0x4e4,
> +		0x504,
> +		0x508,
> +		0x50c,
> +		0x54c,
> +		0x63c,
> +		0x640,
> +		0x644,
> +		0x648,
> +	},
> +	/* PRU1 */
> +	{
> +		0x10,
> +		0x14,
> +		0x64c,
> +		0x650,
> +		0x654,
> +		0x6d4,
> +		0x8d4,
> +		0x9d4,
> +		0x9d8,
> +		0xa58,
> +		0xa5c,
> +		0xa60,
> +		0xaa0,
> +		0xab0,
> +		0xad0,
> +		0xad4,
> +		0xad8,
> +		0xb18,
> +		0xc08,
> +		0xc0c,
> +		0xc10,
> +		0xc14,
> +	},
> +};
> +
> +static inline u32 addr_to_da0(const u8 *addr)
> +{
> +	return (u32)(addr[0] | addr[1] << 8 |
> +		addr[2] << 16 | addr[3] << 24);
> +};
> +
> +static inline u32 addr_to_da1(const u8 *addr)
> +{
> +	return (u32)(addr[4] | addr[5] << 8);
> +};
> +
> +static void rx_class_ft1_set_start_len(struct regmap *miig_rt, int slice,
> +				       u16 start, u8 len)
> +{
> +	u32 offset, val;
> +
> +	offset = offs[slice].ft1_start_len;
> +	val = FT1_LEN(len) | FT1_START(start);
> +	regmap_write(miig_rt, offset, val);
> +}
> +
> +static void rx_class_ft1_set_da(struct regmap *miig_rt, int slice,
> +				int n, const u8 *addr)
> +{
> +	u32 offset;
> +
> +	offset = FT1_N_REG(slice, n, FT1_DA0);
> +	regmap_write(miig_rt, offset, addr_to_da0(addr));
> +	offset = FT1_N_REG(slice, n, FT1_DA1);
> +	regmap_write(miig_rt, offset, addr_to_da1(addr));
> +}
> +
> +static void rx_class_ft1_set_da_mask(struct regmap *miig_rt, int slice,
> +				     int n, const u8 *addr)
> +{
> +	u32 offset;
> +
> +	offset = FT1_N_REG(slice, n, FT1_DA0_MASK);
> +	regmap_write(miig_rt, offset, addr_to_da0(addr));
> +	offset = FT1_N_REG(slice, n, FT1_DA1_MASK);
> +	regmap_write(miig_rt, offset, addr_to_da1(addr));
> +}
> +
> +static void rx_class_ft1_cfg_set_type(struct regmap *miig_rt, int slice, int n,
> +				      enum ft1_cfg_type type)
> +{
> +	u32 offset;
> +
> +	offset = offs[slice].ft1_cfg;
> +	regmap_update_bits(miig_rt, offset, FT1_CFG_MASK(n),
> +			   type << FT1_CFG_SHIFT(n));
> +}
> +
> +static void rx_class_sel_set_type(struct regmap *miig_rt, int slice, int n,
> +				  enum rx_class_sel_type type)
> +{
> +	u32 offset;
> +
> +	offset = offs[slice].rx_class_cfg1;
> +	regmap_update_bits(miig_rt, offset, RX_CLASS_SEL_MASK(n),
> +			   type << RX_CLASS_SEL_SHIFT(n));
> +}
> +
> +static void rx_class_set_and(struct regmap *miig_rt, int slice, int n,
> +			     u32 data)
> +{
> +	u32 offset;
> +
> +	offset = RX_CLASS_N_REG(slice, n, RX_CLASS_AND_EN);
> +	regmap_write(miig_rt, offset, data);
> +}
> +
> +static void rx_class_set_or(struct regmap *miig_rt, int slice, int n,
> +			    u32 data)
> +{
> +	u32 offset;
> +
> +	offset = RX_CLASS_N_REG(slice, n, RX_CLASS_OR_EN);
> +	regmap_write(miig_rt, offset, data);
> +}
> +
> +void icssg_class_set_host_mac_addr(struct regmap *miig_rt, const u8 *mac)
> +{
> +	regmap_write(miig_rt, MAC_INTERFACE_0, addr_to_da0(mac));
> +	regmap_write(miig_rt, MAC_INTERFACE_1, addr_to_da1(mac));
> +}
> +
> +void icssg_class_set_mac_addr(struct regmap *miig_rt, int slice, u8 *mac)
> +{
> +	regmap_write(miig_rt, offs[slice].mac0, addr_to_da0(mac));
> +	regmap_write(miig_rt, offs[slice].mac1, addr_to_da1(mac));
> +}
> +
> +/* disable all RX traffic */
> +void icssg_class_disable(struct regmap *miig_rt, int slice)
> +{
> +	u32 data, offset;
> +	int n;
> +
> +	/* Enable RX_L2_G */
> +	regmap_update_bits(miig_rt, ICSSG_CFG_OFFSET, ICSSG_CFG_RX_L2_G_EN,
> +			   ICSSG_CFG_RX_L2_G_EN);
> +
> +	for (n = 0; n < ICSSG_NUM_CLASSIFIERS; n++) {
> +		/* AND_EN = 0 */
> +		rx_class_set_and(miig_rt, slice, n, 0);
> +		/* OR_EN = 0 */
> +		rx_class_set_or(miig_rt, slice, n, 0);
> +
> +		/* set CFG1 to OR */
> +		rx_class_sel_set_type(miig_rt, slice, n, RX_CLASS_SEL_TYPE_OR);
> +
> +		/* configure gate */
> +		offset = RX_CLASS_GATES_N_REG(slice, n);
> +		regmap_read(miig_rt, offset, &data);
> +		/* clear class_raw so we go through filters */
> +		data &= ~RX_CLASS_GATES_RAW_MASK;
> +		/* set allow and phase mask */
> +		data |= RX_CLASS_GATES_ALLOW_MASK | RX_CLASS_GATES_PHASE_MASK;
> +		regmap_write(miig_rt, offset, data);
> +	}
> +
> +	/* FT1 Disabled */
> +	for (n = 0; n < ICSSG_NUM_FT1_SLOTS; n++) {
> +		u8 addr[] = { 0, 0, 0, 0, 0, 0, };

const

> +
> +		rx_class_ft1_cfg_set_type(miig_rt, slice, n,
> +					  FT1_CFG_TYPE_DISABLED);
> +		rx_class_ft1_set_da(miig_rt, slice, n, addr);
> +		rx_class_ft1_set_da_mask(miig_rt, slice, n, addr);
> +	}
> +
> +	/* clear CFG2 */
> +	regmap_write(miig_rt, offs[slice].rx_class_cfg2, 0);
> +}
> +
> +void icssg_class_default(struct regmap *miig_rt, int slice, bool allmulti)
> +{
> +	int classifiers_in_use = 1;
> +	u32 data;
> +	int n;
> +
> +	/* defaults */
> +	icssg_class_disable(miig_rt, slice);
> +
> +	/* Setup Classifier */
> +	for (n = 0; n < classifiers_in_use; n++) {
> +		/* match on Broadcast or MAC_PRU address */
> +		data = RX_CLASS_FT_BC | RX_CLASS_FT_DA_P;
> +
> +		/* multicast? */
> +		if (allmulti)
> +			data |= RX_CLASS_FT_MC;
> +
> +		rx_class_set_or(miig_rt, slice, n, data);
> +
> +		/* set CFG1 for OR_OR_AND for classifier */
> +		rx_class_sel_set_type(miig_rt, slice, n,
> +				      RX_CLASS_SEL_TYPE_OR_OR_AND);
> +	}
> +
> +	/* clear CFG2 */
> +	regmap_write(miig_rt, offs[slice].rx_class_cfg2, 0);
> +}
> +
> +/* required for SAV check */
> +void icssg_ft1_set_mac_addr(struct regmap *miig_rt, int slice, u8 *mac_addr)
> +{
> +	u8 mask_addr[] = { 0, 0, 0, 0, 0, 0, };

const

> +
> +	rx_class_ft1_set_start_len(miig_rt, slice, 0, 6);
> +	rx_class_ft1_set_da(miig_rt, slice, 0, mac_addr);
> +	rx_class_ft1_set_da_mask(miig_rt, slice, 0, mask_addr);
> +	rx_class_ft1_cfg_set_type(miig_rt, slice, 0, FT1_CFG_TYPE_EQ);
> +}
> diff --git a/drivers/net/ethernet/ti/icssg_config.c b/drivers/net/ethernet/ti/icssg_config.c
> new file mode 100644
> index 000000000000..a88ea4933802
> --- /dev/null
> +++ b/drivers/net/ethernet/ti/icssg_config.c
> @@ -0,0 +1,440 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* ICSSG Ethernet driver
> + *
> + * Copyright (C) 2022 Texas Instruments Incorporated - https://www.ti.com
> + */
> +
> +#include <linux/iopoll.h>
> +#include <linux/regmap.h>
> +#include <uapi/linux/if_ether.h>
> +#include "icssg_config.h"
> +#include "icssg_prueth.h"
> +#include "icssg_switch_map.h"
> +#include "icssg_mii_rt.h"
> +
> +/* TX IPG Values to be set for 100M link speed. These values are
> + * in ocp_clk cycles. So need change if ocp_clk is changed for a specific
> + * h/w design.
> + */
> +
> +/* IPG is in core_clk cycles */
> +#define MII_RT_TX_IPG_100M	0x17
> +#define MII_RT_TX_IPG_1G	0xb
> +
> +#define	ICSSG_QUEUES_MAX		64

Messed up space after #define

> +#define	ICSSG_QUEUE_OFFSET		0xd00
> +#define	ICSSG_QUEUE_PEEK_OFFSET		0xe00
> +#define	ICSSG_QUEUE_CNT_OFFSET		0xe40
> +#define	ICSSG_QUEUE_RESET_OFFSET	0xf40
> +
> +#define	ICSSG_NUM_TX_QUEUES	8
> +
> +#define	RECYCLE_Q_SLICE0	16
> +#define	RECYCLE_Q_SLICE1	17
> +
> +#define	ICSSG_NUM_OTHER_QUEUES	5	/* port, host and special queues */
> +
> +#define	PORT_HI_Q_SLICE0	32
> +#define	PORT_LO_Q_SLICE0	33
> +#define	HOST_HI_Q_SLICE0	34
> +#define	HOST_LO_Q_SLICE0	35
> +#define	HOST_SPL_Q_SLICE0	40	/* Special Queue */
> +
> +#define	PORT_HI_Q_SLICE1	36
> +#define	PORT_LO_Q_SLICE1	37
> +#define	HOST_HI_Q_SLICE1	38
> +#define	HOST_LO_Q_SLICE1	39
> +#define	HOST_SPL_Q_SLICE1	41	/* Special Queue */
> +
> +#define MII_RXCFG_DEFAULT	(PRUSS_MII_RT_RXCFG_RX_ENABLE | \
> +				 PRUSS_MII_RT_RXCFG_RX_DATA_RDY_MODE_DIS | \
> +				 PRUSS_MII_RT_RXCFG_RX_L2_EN | \
> +				 PRUSS_MII_RT_RXCFG_RX_L2_EOF_SCLR_DIS)
> +
> +#define MII_TXCFG_DEFAULT	(PRUSS_MII_RT_TXCFG_TX_ENABLE | \
> +				 PRUSS_MII_RT_TXCFG_TX_AUTO_PREAMBLE | \
> +				 PRUSS_MII_RT_TXCFG_TX_32_MODE_EN | \
> +				 PRUSS_MII_RT_TXCFG_TX_IPG_WIRE_CLK_EN)
> +
> +#define ICSSG_CFG_DEFAULT	(ICSSG_CFG_TX_L1_EN | \
> +				 ICSSG_CFG_TX_L2_EN | ICSSG_CFG_RX_L2_G_EN | \
> +				 ICSSG_CFG_TX_PRU_EN | \
> +				 ICSSG_CFG_SGMII_MODE)
> +
> +#define FDB_GEN_CFG1		0x60
> +#define SMEM_VLAN_OFFSET	8
> +#define SMEM_VLAN_OFFSET_MASK	GENMASK(25, 8)
> +
> +#define FDB_GEN_CFG2		0x64
> +#define FDB_VLAN_EN		BIT(6)
> +#define FDB_HOST_EN		BIT(2)
> +#define FDB_PRU1_EN		BIT(1)
> +#define FDB_PRU0_EN		BIT(0)
> +#define FDB_EN_ALL		(FDB_PRU0_EN | FDB_PRU1_EN | \
> +				 FDB_HOST_EN | FDB_VLAN_EN)
> +
> +struct map {
> +	int queue;
> +	u32 pd_addr_start;
> +	u32 flags;
> +	bool special;
> +};
> +
> +struct map hwq_map[2][ICSSG_NUM_OTHER_QUEUES] = {

Isn't this const?

> +	{
> +		{ PORT_HI_Q_SLICE0, PORT_DESC0_HI, 0x200000, 0 },
> +		{ PORT_LO_Q_SLICE0, PORT_DESC0_LO, 0, 0 },
> +		{ HOST_HI_Q_SLICE0, HOST_DESC0_HI, 0x200000, 0 },
> +		{ HOST_LO_Q_SLICE0, HOST_DESC0_LO, 0, 0 },
> +		{ HOST_SPL_Q_SLICE0, HOST_SPPD0, 0x400000, 1 },
> +	},
> +	{
> +		{ PORT_HI_Q_SLICE1, PORT_DESC1_HI, 0xa00000, 0 },
> +		{ PORT_LO_Q_SLICE1, PORT_DESC1_LO, 0x800000, 0 },
> +		{ HOST_HI_Q_SLICE1, HOST_DESC1_HI, 0xa00000, 0 },
> +		{ HOST_LO_Q_SLICE1, HOST_DESC1_LO, 0x800000, 0 },
> +		{ HOST_SPL_Q_SLICE1, HOST_SPPD1, 0xc00000, 1 },
> +	},
> +};
> +
> +static void icssg_config_mii_init(struct prueth_emac *emac)
> +{
> +	struct prueth *prueth = emac->prueth;
> +	struct regmap *mii_rt = prueth->mii_rt;
> +	int slice = prueth_emac_slice(emac);
> +	u32 rxcfg_reg, txcfg_reg, pcnt_reg;
> +	u32 rxcfg, txcfg;
> +
> +	rxcfg_reg = (slice == ICSS_MII0) ? PRUSS_MII_RT_RXCFG0 :
> +				       PRUSS_MII_RT_RXCFG1;
> +	txcfg_reg = (slice == ICSS_MII0) ? PRUSS_MII_RT_TXCFG0 :
> +				       PRUSS_MII_RT_TXCFG1;
> +	pcnt_reg = (slice == ICSS_MII0) ? PRUSS_MII_RT_RX_PCNT0 :
> +				       PRUSS_MII_RT_RX_PCNT1;
> +
> +	rxcfg = MII_RXCFG_DEFAULT;
> +	txcfg = MII_TXCFG_DEFAULT;
> +
> +	if (slice == ICSS_MII1)
> +		rxcfg |= PRUSS_MII_RT_RXCFG_RX_MUX_SEL;
> +
> +	/* In MII mode TX lines swapped inside ICSSG, so TX_MUX_SEL cfg need
> +	 * to be swapped also comparing to RGMII mode.
> +	 */
> +	if (emac->phy_if == PHY_INTERFACE_MODE_MII && slice == ICSS_MII0)
> +		txcfg |= PRUSS_MII_RT_TXCFG_TX_MUX_SEL;
> +	else if (emac->phy_if != PHY_INTERFACE_MODE_MII && slice == ICSS_MII1)
> +		txcfg |= PRUSS_MII_RT_TXCFG_TX_MUX_SEL;
> +
> +	regmap_write(mii_rt, rxcfg_reg, rxcfg);
> +	regmap_write(mii_rt, txcfg_reg, txcfg);
> +	regmap_write(mii_rt, pcnt_reg, 0x1);
> +}
> +
> +static void icssg_miig_queues_init(struct prueth *prueth, int slice)
> +{
> +	struct regmap *miig_rt = prueth->miig_rt;
> +	void __iomem *smem = prueth->shram.va;
> +	u8 pd[ICSSG_SPECIAL_PD_SIZE];
> +	int queue = 0, i, j;
> +	u32 *pdword;
> +
> +	/* reset hwqueues */
> +	if (slice)
> +		queue = ICSSG_NUM_TX_QUEUES;
> +
> +	for (i = 0; i < ICSSG_NUM_TX_QUEUES; i++) {
> +		regmap_write(miig_rt, ICSSG_QUEUE_RESET_OFFSET, queue);
> +		queue++;
> +	}
> +
> +	queue = slice ? RECYCLE_Q_SLICE1 : RECYCLE_Q_SLICE0;
> +	regmap_write(miig_rt, ICSSG_QUEUE_RESET_OFFSET, queue);
> +
> +	for (i = 0; i < ICSSG_NUM_OTHER_QUEUES; i++) {
> +		regmap_write(miig_rt, ICSSG_QUEUE_RESET_OFFSET,
> +			     hwq_map[slice][i].queue);
> +	}
> +
> +	/* initialize packet descriptors in SMEM */
> +	/* push pakcet descriptors to hwqueues */
> +
> +	pdword = (u32 *)pd;
> +	for (j = 0; j < ICSSG_NUM_OTHER_QUEUES; j++) {
> +		struct map *mp;
> +		int pd_size, num_pds;
> +		u32 pdaddr;
> +
> +		mp = &hwq_map[slice][j];
> +		if (mp->special) {
> +			pd_size = ICSSG_SPECIAL_PD_SIZE;
> +			num_pds = ICSSG_NUM_SPECIAL_PDS;
> +		} else	{
> +			pd_size = ICSSG_NORMAL_PD_SIZE;
> +			num_pds = ICSSG_NUM_NORMAL_PDS;
> +		}
> +
> +		for (i = 0; i < num_pds; i++) {
> +			memset(pd, 0, pd_size);
> +
> +			pdword[0] &= cpu_to_le32(ICSSG_FLAG_MASK);
> +			pdword[0] |= cpu_to_le32(mp->flags);
> +			pdaddr = mp->pd_addr_start + i * pd_size;
> +
> +			memcpy_toio(smem + pdaddr, pd, pd_size);
> +			queue = mp->queue;
> +			regmap_write(miig_rt, ICSSG_QUEUE_OFFSET + 4 * queue,
> +				     pdaddr);
> +		}
> +	}
> +}
> +
> +void icssg_config_ipg(struct prueth_emac *emac)
> +{
> +	struct prueth *prueth = emac->prueth;
> +	int slice = prueth_emac_slice(emac);
> +
> +	switch (emac->speed) {
> +	case SPEED_1000:
> +		icssg_mii_update_ipg(prueth->mii_rt, slice, MII_RT_TX_IPG_1G);
> +		break;
> +	case SPEED_100:
> +		icssg_mii_update_ipg(prueth->mii_rt, slice, MII_RT_TX_IPG_100M);
> +		break;
> +	default:
> +		/* Other links speeds not supported */
> +		netdev_err(emac->ndev, "Unsupported link speed\n");
> +		return;
> +	}
> +}
> +
> +static void emac_r30_cmd_init(struct prueth_emac *emac)
> +{
> +	int i;
> +	struct icssg_r30_cmd *p;
> +
> +	p = emac->dram.va + MGR_R30_CMD_OFFSET;
> +
> +	for (i = 0; i < 4; i++)
> +		writel(EMAC_NONE, &p->cmd[i]);
> +}
> +
> +static int emac_r30_is_done(struct prueth_emac *emac)
> +{
> +	const struct icssg_r30_cmd *p;
> +	int i;
> +	u32 cmd;
> +
> +	p = emac->dram.va + MGR_R30_CMD_OFFSET;
> +
> +	for (i = 0; i < 4; i++) {
> +		cmd = readl(&p->cmd[i]);
> +		if (cmd != EMAC_NONE)
> +			return 0;
> +	}
> +
> +	return 1;
> +}
> +
> +static int prueth_emac_buffer_setup(struct prueth_emac *emac)
> +{
> +	struct icssg_buffer_pool_cfg *bpool_cfg;
> +	struct prueth *prueth = emac->prueth;
> +	int slice = prueth_emac_slice(emac);
> +	struct icssg_rxq_ctx *rxq_ctx;
> +	u32 addr;
> +	int i;
> +
> +	/* Layout to have 64KB aligned buffer pool
> +	 * |BPOOL0|BPOOL1|RX_CTX0|RX_CTX1|
> +	 */
> +
> +	addr = lower_32_bits(prueth->msmcram.pa);
> +	if (slice)
> +		addr += PRUETH_NUM_BUF_POOLS * PRUETH_EMAC_BUF_POOL_SIZE;
> +
> +	if (addr % SZ_64K) {
> +		dev_warn(prueth->dev, "buffer pool needs to be 64KB aligned\n");
> +		return -EINVAL;
> +	}
> +
> +	bpool_cfg = emac->dram.va + BUFFER_POOL_0_ADDR_OFFSET;
> +	/* workaround for f/w bug. bpool 0 needs to be initilalized */
> +	bpool_cfg[0].addr = cpu_to_le32(addr);
> +	bpool_cfg[0].len = 0;
> +
> +	for (i = PRUETH_EMAC_BUF_POOL_START;
> +	     i < (PRUETH_EMAC_BUF_POOL_START + PRUETH_NUM_BUF_POOLS);
> +	     i++) {
> +		bpool_cfg[i].addr = cpu_to_le32(addr);
> +		bpool_cfg[i].len = cpu_to_le32(PRUETH_EMAC_BUF_POOL_SIZE);
> +		addr += PRUETH_EMAC_BUF_POOL_SIZE;
> +	}
> +
> +	if (!slice)
> +		addr += PRUETH_NUM_BUF_POOLS * PRUETH_EMAC_BUF_POOL_SIZE;
> +	else
> +		addr += PRUETH_EMAC_RX_CTX_BUF_SIZE * 2;
> +
> +	/* Pre-emptible RX buffer queue */
> +	rxq_ctx = emac->dram.va + HOST_RX_Q_PRE_CONTEXT_OFFSET;
> +	for (i = 0; i < 3; i++)
> +		rxq_ctx->start[i] = cpu_to_le32(addr);
> +
> +	addr += PRUETH_EMAC_RX_CTX_BUF_SIZE;
> +	rxq_ctx->end = cpu_to_le32(addr);
> +
> +	/* Express RX buffer queue */
> +	rxq_ctx = emac->dram.va + HOST_RX_Q_EXP_CONTEXT_OFFSET;
> +	for (i = 0; i < 3; i++)
> +		rxq_ctx->start[i] = cpu_to_le32(addr);
> +
> +	addr += PRUETH_EMAC_RX_CTX_BUF_SIZE;
> +	rxq_ctx->end = cpu_to_le32(addr);
> +
> +	return 0;
> +}
> +
> +static void icssg_init_emac_mode(struct prueth *prueth)
> +{
> +	/* When the device is configured as a bridge and it is being brought back
> +	 * to the emac mode, the host mac address has to be set as 0.
> +	 */
> +	u8 mac[ETH_ALEN] = { 0 };
> +
> +	if (prueth->emacs_initialized)
> +		return;
> +
> +	regmap_update_bits(prueth->miig_rt, FDB_GEN_CFG1, SMEM_VLAN_OFFSET_MASK, 0);
> +	regmap_write(prueth->miig_rt, FDB_GEN_CFG2, 0);
> +	/* Clear host MAC address */
> +	icssg_class_set_host_mac_addr(prueth->miig_rt, mac);
> +}
> +
> +int icssg_config(struct prueth *prueth, struct prueth_emac *emac, int slice)
> +{
> +	void *config = emac->dram.va + ICSSG_CONFIG_OFFSET;
> +	u8 *cfg_byte_ptr = config;
> +	struct icssg_flow_cfg *flow_cfg;
> +	u32 mask;
> +	int ret;
> +
> +	icssg_init_emac_mode(prueth);
> +
> +	memset_io(config, 0, TAS_GATE_MASK_LIST0);
> +	icssg_miig_queues_init(prueth, slice);
> +
> +	emac->speed = SPEED_1000;
> +	emac->duplex = DUPLEX_FULL;
> +	if (!phy_interface_mode_is_rgmii(emac->phy_if)) {
> +		emac->speed = SPEED_100;
> +		emac->duplex = DUPLEX_FULL;
> +	}
> +	regmap_update_bits(prueth->miig_rt, ICSSG_CFG_OFFSET, ICSSG_CFG_DEFAULT, ICSSG_CFG_DEFAULT);
> +	icssg_miig_set_interface_mode(prueth->miig_rt, slice, emac->phy_if);
> +	icssg_config_mii_init(emac);
> +	icssg_config_ipg(emac);
> +	icssg_update_rgmii_cfg(prueth->miig_rt, emac);
> +
> +	/* set GPI mode */
> +	pruss_cfg_gpimode(prueth->pruss, prueth->pru_id[slice],
> +			  PRUSS_GPI_MODE_MII);
> +
> +	/* enable XFR shift for PRU and RTU */
> +	mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN;
> +	pruss_cfg_update(prueth->pruss, PRUSS_CFG_SPP, mask, mask);
> +
> +	/* set C28 to 0x100 */
> +	pru_rproc_set_ctable(prueth->pru[slice], PRU_C28, 0x100 << 8);
> +	pru_rproc_set_ctable(prueth->rtu[slice], PRU_C28, 0x100 << 8);
> +	pru_rproc_set_ctable(prueth->txpru[slice], PRU_C28, 0x100 << 8);
> +
> +	flow_cfg = config + PSI_L_REGULAR_FLOW_ID_BASE_OFFSET;
> +	flow_cfg->rx_base_flow = cpu_to_le32(emac->rx_flow_id_base);
> +	flow_cfg->mgm_base_flow = 0;
> +	*(cfg_byte_ptr + SPL_PKT_DEFAULT_PRIORITY) = 0;
> +	*(cfg_byte_ptr + QUEUE_NUM_UNTAGGED) = 0x0;
> +
> +	ret = prueth_emac_buffer_setup(emac);
> +	if (ret)
> +		return ret;
> +
> +	emac_r30_cmd_init(emac);
> +
> +	return 0;
> +}
> +
> +static struct icssg_r30_cmd emac_r32_bitmask[] = {

Isn't this const?

> +	{{0xffff0004, 0xffff0100, 0xffff0100, EMAC_NONE}},	/* EMAC_PORT_DISABLE */
> +	{{0xfffb0040, 0xfeff0200, 0xfeff0200, EMAC_NONE}},	/* EMAC_PORT_BLOCK */
> +	{{0xffbb0000, 0xfcff0000, 0xdcff0000, EMAC_NONE}},	/* EMAC_PORT_FORWARD */
> +	{{0xffbb0000, 0xfcff0000, 0xfcff2000, EMAC_NONE}},	/* EMAC_PORT_FORWARD_WO_LEARNING */
> +	{{0xffff0001, EMAC_NONE,  EMAC_NONE, EMAC_NONE}},	/* ACCEPT ALL */
> +	{{0xfffe0002, EMAC_NONE,  EMAC_NONE, EMAC_NONE}},	/* ACCEPT TAGGED */
> +	{{0xfffc0000, EMAC_NONE,  EMAC_NONE, EMAC_NONE}},	/* ACCEPT UNTAGGED and PRIO */
> +	{{EMAC_NONE,  0xffff0020, EMAC_NONE, EMAC_NONE}},	/* TAS Trigger List change */
> +	{{EMAC_NONE,  0xdfff1000, EMAC_NONE, EMAC_NONE}},	/* TAS set state ENABLE*/
> +	{{EMAC_NONE,  0xefff2000, EMAC_NONE, EMAC_NONE}},	/* TAS set state RESET*/
> +	{{EMAC_NONE,  0xcfff0000, EMAC_NONE, EMAC_NONE}},	/* TAS set state DISABLE*/
> +	{{EMAC_NONE,  EMAC_NONE,  0xffff0400, EMAC_NONE}},	/* UC flooding ENABLE*/
> +	{{EMAC_NONE,  EMAC_NONE,  0xfbff0000, EMAC_NONE}},	/* UC flooding DISABLE*/
> +	{{EMAC_NONE,  EMAC_NONE,  0xffff0800, EMAC_NONE}},	/* MC flooding ENABLE*/
> +	{{EMAC_NONE,  EMAC_NONE,  0xf7ff0000, EMAC_NONE}},	/* MC flooding DISABLE*/
> +	{{EMAC_NONE,  0xffff4000, EMAC_NONE, EMAC_NONE}},	/* Preemption on Tx ENABLE*/
> +	{{EMAC_NONE,  0xbfff0000, EMAC_NONE, EMAC_NONE}},	/* Preemption on Tx DISABLE*/
> +	{{0xffff0010,  EMAC_NONE, 0xffff0010, EMAC_NONE}},	/* VLAN AWARE*/
> +	{{0xffef0000,  EMAC_NONE, 0xffef0000, EMAC_NONE}}	/* VLAN UNWARE*/
> +};
> +
> +int emac_set_port_state(struct prueth_emac *emac,
> +			enum icssg_port_state_cmd cmd)
> +{
> +	struct icssg_r30_cmd *p;
> +	int ret = -ETIMEDOUT;
> +	int done = 0;
> +	int i;
> +
> +	p = emac->dram.va + MGR_R30_CMD_OFFSET;
> +
> +	if (cmd >= ICSSG_EMAC_PORT_MAX_COMMANDS) {
> +		netdev_err(emac->ndev, "invalid port command\n");
> +		return -EINVAL;
> +	}
> +
> +	/* only one command at a time allowed to firmware */
> +	mutex_lock(&emac->cmd_lock);
> +
> +	for (i = 0; i < 4; i++)
> +		writel(emac_r32_bitmask[cmd].cmd[i], &p->cmd[i]);
> +
> +	/* wait for done */
> +	ret = read_poll_timeout(emac_r30_is_done, done, done == 1,
> +				1000, 10000, false, emac);
> +
> +	if (ret == -ETIMEDOUT)
> +		netdev_err(emac->ndev, "timeout waiting for command done\n");
> +
> +	mutex_unlock(&emac->cmd_lock);
> +
> +	return ret;
> +}
> +
> +void icssg_config_set_speed(struct prueth_emac *emac)
> +{
> +	u8 fw_speed;
> +
> +	switch (emac->speed) {
> +	case SPEED_1000:
> +		fw_speed = FW_LINK_SPEED_1G;
> +		break;
> +	case SPEED_100:
> +		fw_speed = FW_LINK_SPEED_100M;
> +		break;
> +	default:
> +		/* Other links speeds not supported */
> +		netdev_err(emac->ndev, "Unsupported link speed\n");
> +		return;
> +	}
> +
> +	writeb(fw_speed, emac->dram.va + PORT_LINK_SPEED_OFFSET);
> +}
> diff --git a/drivers/net/ethernet/ti/icssg_config.h b/drivers/net/ethernet/ti/icssg_config.h
> new file mode 100644
> index 000000000000..43eb0922172a
> --- /dev/null
> +++ b/drivers/net/ethernet/ti/icssg_config.h
> @@ -0,0 +1,200 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Texas Instruments ICSSG Ethernet driver
> + *
> + * Copyright (C) 2022 Texas Instruments Incorporated - https://www.ti.com/
> + *
> + */
> +
> +#ifndef __NET_TI_ICSSG_CONFIG_H
> +#define __NET_TI_ICSSG_CONFIG_H
> +
> +struct icssg_buffer_pool_cfg {
> +	__le32	addr;
> +	__le32	len;
> +} __packed;
> +
> +struct icssg_flow_cfg {
> +	__le16 rx_base_flow;
> +	__le16 mgm_base_flow;
> +} __packed;
> +
> +#define PRUETH_PKT_TYPE_CMD	0x10
> +#define PRUETH_NAV_PS_DATA_SIZE	16	/* Protocol specific data size */
> +#define PRUETH_NAV_SW_DATA_SIZE	16	/* SW related data size */
> +#define PRUETH_MAX_TX_DESC	512
> +#define PRUETH_MAX_RX_DESC	512
> +#define PRUETH_MAX_RX_FLOWS	1	/* excluding default flow */
> +#define PRUETH_RX_FLOW_DATA	0
> +
> +#define PRUETH_EMAC_BUF_POOL_SIZE	SZ_8K
> +#define PRUETH_EMAC_POOLS_PER_SLICE	24
> +#define PRUETH_EMAC_BUF_POOL_START	8
> +#define PRUETH_NUM_BUF_POOLS	8
> +#define PRUETH_EMAC_RX_CTX_BUF_SIZE	SZ_16K	/* per slice */
> +#define MSMC_RAM_SIZE	\
> +	(2 * (PRUETH_EMAC_BUF_POOL_SIZE * PRUETH_NUM_BUF_POOLS + \
> +	 PRUETH_EMAC_RX_CTX_BUF_SIZE * 2))
> +
> +struct icssg_rxq_ctx {
> +	__le32 start[3];
> +	__le32 end;
> +} __packed;
> +
> +/* Load time Fiwmware Configuration */
> +
> +#define ICSSG_FW_MGMT_CMD_HEADER	0x81
> +#define ICSSG_FW_MGMT_FDB_CMD_TYPE	0x03
> +#define ICSSG_FW_MGMT_CMD_TYPE		0x04
> +#define ICSSG_FW_MGMT_PKT		0x80000000
> +
> +struct icssg_r30_cmd {
> +	u32 cmd[4];
> +} __packed;
> +
> +enum icssg_port_state_cmd {
> +	ICSSG_EMAC_PORT_DISABLE = 0,
> +	ICSSG_EMAC_PORT_BLOCK,
> +	ICSSG_EMAC_PORT_FORWARD,
> +	ICSSG_EMAC_PORT_FORWARD_WO_LEARNING,
> +	ICSSG_EMAC_PORT_ACCEPT_ALL,
> +	ICSSG_EMAC_PORT_ACCEPT_TAGGED,
> +	ICSSG_EMAC_PORT_ACCEPT_UNTAGGED_N_PRIO,
> +	ICSSG_EMAC_PORT_TAS_TRIGGER,
> +	ICSSG_EMAC_PORT_TAS_ENABLE,
> +	ICSSG_EMAC_PORT_TAS_RESET,
> +	ICSSG_EMAC_PORT_TAS_DISABLE,
> +	ICSSG_EMAC_PORT_UC_FLOODING_ENABLE,
> +	ICSSG_EMAC_PORT_UC_FLOODING_DISABLE,
> +	ICSSG_EMAC_PORT_MC_FLOODING_ENABLE,
> +	ICSSG_EMAC_PORT_MC_FLOODING_DISABLE,
> +	ICSSG_EMAC_PORT_PREMPT_TX_ENABLE,
> +	ICSSG_EMAC_PORT_PREMPT_TX_DISABLE,
> +	ICSSG_EMAC_PORT_VLAN_AWARE_ENABLE,
> +	ICSSG_EMAC_PORT_VLAN_AWARE_DISABLE,
> +	ICSSG_EMAC_PORT_MAX_COMMANDS
> +};
> +
> +#define EMAC_NONE           0xffff0000
> +#define EMAC_PRU0_P_DI      0xffff0004
> +#define EMAC_PRU1_P_DI      0xffff0040
> +#define EMAC_TX_P_DI        0xffff0100
> +
> +#define EMAC_PRU0_P_EN      0xfffb0000
> +#define EMAC_PRU1_P_EN      0xffbf0000
> +#define EMAC_TX_P_EN        0xfeff0000
> +
> +#define EMAC_P_BLOCK        0xffff0040
> +#define EMAC_TX_P_BLOCK     0xffff0200
> +#define EMAC_P_UNBLOCK      0xffbf0000
> +#define EMAC_TX_P_UNBLOCK   0xfdff0000
> +#define EMAC_LEAN_EN        0xfff70000
> +#define EMAC_LEAN_DI        0xffff0008
> +
> +#define EMAC_ACCEPT_ALL     0xffff0001
> +#define EMAC_ACCEPT_TAG     0xfffe0002
> +#define EMAC_ACCEPT_PRIOR   0xfffc0000
> +
> +/* Config area lies in DRAM */
> +#define ICSSG_CONFIG_OFFSET	0x0
> +
> +/* Config area lies in shared RAM */
> +#define ICSSG_CONFIG_OFFSET_SLICE0   0
> +#define ICSSG_CONFIG_OFFSET_SLICE1   0x8000
> +
> +#define ICSSG_NUM_NORMAL_PDS	64
> +#define ICSSG_NUM_SPECIAL_PDS	16
> +
> +#define ICSSG_NORMAL_PD_SIZE	8
> +#define ICSSG_SPECIAL_PD_SIZE	20
> +
> +#define ICSSG_FLAG_MASK		0xff00ffff
> +
> +struct icssg_setclock_desc {
> +	u8 request;
> +	u8 restore;
> +	u8 acknowledgment;
> +	u8 cmp_status;
> +	u32 margin;
> +	u32 cyclecounter0_set;
> +	u32 cyclecounter1_set;
> +	u32 iepcount_set;
> +	u32 rsvd1;
> +	u32 rsvd2;
> +	u32 CMP0_current;
> +	u32 iepcount_current;
> +	u32 difference;
> +	u32 cyclecounter0_new;
> +	u32 cyclecounter1_new;
> +	u32 CMP0_new;
> +} __packed;
> +
> +#define ICSSG_CMD_POP_SLICE0	56
> +#define ICSSG_CMD_POP_SLICE1	60
> +
> +#define ICSSG_CMD_PUSH_SLICE0	57
> +#define ICSSG_CMD_PUSH_SLICE1	61
> +
> +#define ICSSG_RSP_POP_SLICE0	58
> +#define ICSSG_RSP_POP_SLICE1	62
> +
> +#define ICSSG_RSP_PUSH_SLICE0	56
> +#define ICSSG_RSP_PUSH_SLICE1	60
> +
> +#define ICSSG_TS_POP_SLICE0	59
> +#define ICSSG_TS_POP_SLICE1	63
> +
> +#define ICSSG_TS_PUSH_SLICE0	40
> +#define ICSSG_TS_PUSH_SLICE1	41
> +
> +/* FDB FID_C2 flag definitions */
> +/* Indicates host port membership.*/
> +#define ICSSG_FDB_ENTRY_P0_MEMBERSHIP         BIT(0)
> +/* Indicates that MAC ID is connected to physical port 1 */
> +#define ICSSG_FDB_ENTRY_P1_MEMBERSHIP         BIT(1)
> +/* Indicates that MAC ID is connected to physical port 2 */
> +#define ICSSG_FDB_ENTRY_P2_MEMBERSHIP         BIT(2)
> +/* Ageable bit is set for learned entries and cleared for static entries */
> +#define ICSSG_FDB_ENTRY_AGEABLE               BIT(3)
> +/* If set for DA then packet is determined to be a special packet */
> +#define ICSSG_FDB_ENTRY_BLOCK                 BIT(4)
> +/* If set for DA then the SA from the packet is not learned */
> +#define ICSSG_FDB_ENTRY_SECURE                BIT(5)
> +/* If set, it means packet has been seen recently with source address + FID
> + * matching MAC address/FID of entry
> + */
> +#define ICSSG_FDB_ENTRY_TOUCHED               BIT(6)
> +/* Set if entry is valid */
> +#define ICSSG_FDB_ENTRY_VALID                 BIT(7)
> +
> +/**
> + * struct prueth_vlan_tbl - VLAN table entries struct in ICSSG SMEM
> + * @fid_c1: membership and forwarding rules flag to this table. See
> + *          above to defines for bit definitions
> + * @fid: FDB index for this VID (there is 1-1 mapping b/w VID and FID)
> + */
> +struct prueth_vlan_tbl {
> +	u8 fid_c1;
> +	u8 fid;
> +} __packed;
> +
> +/**
> + * struct prueth_fdb_slot - Result of FDB slot lookup
> + * @mac: MAC address
> + * @fid: fid to be associated with MAC
> + * @fid_c2: FID_C2 entry for this MAC
> + */
> +struct prueth_fdb_slot {
> +	u8 mac[ETH_ALEN];
> +	u8 fid;
> +	u8 fid_c2;
> +} __packed;
> +
> +enum icssg_ietfpe_verify_states {
> +	ICSSG_IETFPE_STATE_UNKNOWN = 0,
> +	ICSSG_IETFPE_STATE_INITIAL,
> +	ICSSG_IETFPE_STATE_VERIFYING,
> +	ICSSG_IETFPE_STATE_SUCCEEDED,
> +	ICSSG_IETFPE_STATE_FAILED,
> +	ICSSG_IETFPE_STATE_DISABLED
> +};
> +#endif /* __NET_TI_ICSSG_CONFIG_H */
> diff --git a/drivers/net/ethernet/ti/icssg_ethtool.c b/drivers/net/ethernet/ti/icssg_ethtool.c
> new file mode 100644
> index 000000000000..fd09d223b0ae
> --- /dev/null
> +++ b/drivers/net/ethernet/ti/icssg_ethtool.c
> @@ -0,0 +1,319 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Texas Instruments ICSSG Ethernet driver
> + *
> + * Copyright (C) 2018-2022 Texas Instruments Incorporated - https://www.ti.com/
> + *
> + */
> +
> +#include "icssg_prueth.h"
> +#include <linux/regmap.h>
> +
> +static u32 stats_base[] = {	0x54c,	/* Slice 0 stats start */
> +				0xb18,	/* Slice 1 stats start */

This also looks const.
Definitions of variable should go after type declarations.

> +};
> +
> +struct miig_stats_regs {
> +	/* Rx */



Best regards,
Krzysztof
