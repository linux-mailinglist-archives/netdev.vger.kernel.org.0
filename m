Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99866C210A
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCTTPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjCTTOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:14:47 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBE743470;
        Mon, 20 Mar 2023 12:06:50 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id r16so14406359qtx.9;
        Mon, 20 Mar 2023 12:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679339200;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8rA4K62vUtfLOsNz63o59Uk51gIjIGDhfOV9BqrV4Bg=;
        b=FDW2ZiGuwmiOMk4l7k0YK5xZ2eaAf1TT4GP8CE1uinDsZ61BBdovBVpj6ag9R+l8Xf
         GRuuFzFy1a8kT4rkSByme/HemQoVjZEGUMTeOpFCQzkfujK86+SrLMwhEaz4VY5GAc9T
         NZQkt0AYHSG2qMALCCeGV0GlMOohC3bYH7KJFoZGmIwgaJTZU5FWndiU8IyeggHgvR5Y
         YbMdMGl+PrTUoAaK8cIC0/YJbyy9UXn79qd4eaF0ha3L19pcM7ER5HTV+iUmZPqAz82c
         BpLmRX/mXF7d4ZCAJq6AQNfWjONQ4rcY38pWE9yG+QmcNIpsrbcRBjeH4OcMR9npv4IX
         Yf+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679339200;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8rA4K62vUtfLOsNz63o59Uk51gIjIGDhfOV9BqrV4Bg=;
        b=pDeZ0ng9UOgif5ucMcNgKWv26CFun0rjt73YnymGdca3YUoTdhannT1DtHmasYmPr7
         iJTMulnt/d220KO27Vfk/M4djyW9QgvL6BnPjAZtq2mqNalF9wKQ3pwQ3aVx3iTNKj+7
         R+jZ+Yo8TkSxxBJGv84vrlUUT0QG1hc80B8uw+FDSqq42cMOXZVqfc55N8cBkKdm7niP
         B7aGHMypmjauLfR9sf4PErLVJu5socSd75piv4MM9Xj7Egx+sMy+xEW9J3mLTDN8svor
         uRjfJZwSeuj7vQ0KwiTeH2vTykjv/smNbY0GUq9p+hUS5PxE/HNyWEqFla+eiamCSJd4
         sPmA==
X-Gm-Message-State: AO0yUKWpCifi/ecgvtTrWorih4vjRQLCmmgw7TXwTbtmkAKDsgiizCzx
        GS3A2/t0TspLlGTWVvE3pV0=
X-Google-Smtp-Source: AK7set+bTnMHCeMn5JO2toWQ4ji2Mngz9l/qr/TnKi5TufFGnDIUSH+2sJQ3zlNNbo42eGgUOivP2w==
X-Received: by 2002:a05:622a:1108:b0:3bf:bdb8:c64a with SMTP id e8-20020a05622a110800b003bfbdb8c64amr344144qty.49.1679339199747;
        Mon, 20 Mar 2023 12:06:39 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s20-20020a374514000000b00742bc037f29sm7808825qka.120.2023.03.20.12.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 12:06:39 -0700 (PDT)
Message-ID: <95e106fd-d1ce-b9d4-a4f7-03fb69bd4aaa@gmail.com>
Date:   Mon, 20 Mar 2023 12:06:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH] drivers: net: dsa: b53: mmap: add phy ops
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230320182813.963508-1-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320182813.963508-1-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/23 11:28, Álvaro Fernández Rojas wrote:
> Currently, B53 MMAP BCM63xx devices with an external switch hang when
> performing PHY read and write operations due to invalid registers access.
> This adds support for PHY ops by using the internal bus from mdio-mux-bcm6368
> when probed by device tree and also falls back to direct MDIO registers if not.
> 
> This is an alternative to:
> - https://patchwork.kernel.org/project/netdevbpf/cover/20230317113427.302162-1-noltari@gmail.com/
> - https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.302162-2-noltari@gmail.com/
> - https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.302162-3-noltari@gmail.com/
> - https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.302162-4-noltari@gmail.com/
> As discussed, it was an ABI break and not the correct way of fixing the issue.

Looks good for the most part, just a few questions below.

> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>   drivers/net/dsa/b53/b53_mmap.c    | 86 +++++++++++++++++++++++++++++++
>   include/linux/platform_data/b53.h |  1 +
>   2 files changed, 87 insertions(+)
> 
> diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
> index 706df04b6cee..7deca1c557c5 100644
> --- a/drivers/net/dsa/b53/b53_mmap.c
> +++ b/drivers/net/dsa/b53/b53_mmap.c
> @@ -19,14 +19,25 @@
>   #include <linux/bits.h>
>   #include <linux/kernel.h>
>   #include <linux/module.h>
> +#include <linux/of_mdio.h>
>   #include <linux/io.h>
>   #include <linux/platform_device.h>
>   #include <linux/platform_data/b53.h>
>   
>   #include "b53_priv.h"
>   
> +#define REG_MDIOC		0xb0
> +#define  REG_MDIOC_EXT_MASK	BIT(16)
> +#define  REG_MDIOC_REG_SHIFT	20
> +#define  REG_MDIOC_PHYID_SHIFT	25
> +#define  REG_MDIOC_RD_MASK	BIT(30)
> +#define  REG_MDIOC_WR_MASK	BIT(31)

For some reason, there was no bit introduced to tell us when a 
transaction has finished, so we have to poll after a certain delay has 
elapsed...

> +
> +#define REG_MDIOD		0xb4
> +
>   struct b53_mmap_priv {
>   	void __iomem *regs;
> +	struct mii_bus *bus;
>   };
>   
>   static int b53_mmap_read8(struct b53_device *dev, u8 page, u8 reg, u8 *val)
> @@ -216,6 +227,69 @@ static int b53_mmap_write64(struct b53_device *dev, u8 page, u8 reg,
>   	return 0;
>   }
>   
> +static inline void b53_mmap_mdio_read(struct b53_device *dev, int phy_id,
> +				      int loc, u16 *val)
> +{
> +	uint32_t reg;
> +
> +	b53_mmap_write32(dev, 0, REG_MDIOC, 0);
> +
> +	reg = REG_MDIOC_RD_MASK |
> +	      (phy_id << REG_MDIOC_PHYID_SHIFT) |
> +	      (loc << REG_MDIOC_REG_SHIFT);
> +
> +	b53_mmap_write32(dev, 0, REG_MDIOC, reg);
> +	udelay(50);
> +	b53_mmap_read16(dev, 0, REG_MDIOD, val);
> +}
> +
> +static inline int b53_mmap_mdio_write(struct b53_device *dev, int phy_id,
> +				      int loc, u16 val)
> +{
> +	uint32_t reg;
> +
> +	b53_mmap_write32(dev, 0, REG_MDIOC, 0);
> +
> +	reg = REG_MDIOC_WR_MASK |
> +	      (phy_id << REG_MDIOC_PHYID_SHIFT) |
> +	      (loc << REG_MDIOC_REG_SHIFT) |
> +	      val;
> +
> +	b53_mmap_write32(dev, 0, REG_MDIOC, reg);
> +	udelay(50);
> +
> +	return 0;
> +}
> +
> +static int b53_mmap_phy_read16(struct b53_device *dev, int addr, int reg,
> +			       u16 *value)
> +{
> +	struct b53_mmap_priv *priv = dev->priv;
> +	struct mii_bus *bus = priv->bus;
> +
> +	if (bus)
> +		*value = mdiobus_read_nested(bus, addr, reg);

Since you make the 'mii-bus' property and 'priv->bus' necessary 
prerequisites for the driver to finish probing successfully, when shall 
we not have valid priv->bus reference to work with? Do we end-up taking 
the other path at all?
-- 
Florian

