Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7CAE3C2F
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437139AbfJXTla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:41:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46355 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfJXTla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 15:41:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id n15so16585099wrw.13;
        Thu, 24 Oct 2019 12:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fiq96nVjT7sQAwiXIWbAXKJXQQzKMaRKwEla4GjSbOo=;
        b=qTsLTm6MGk5ID/mmvIBrEdqlSQdIOywkczH9FHuYpKZNgrvrj7vRp8S/FBdUDWq+7S
         cVX4cN1uZXyhxWaqhexkroEkbX5tkcOt5I0sc8/fCX1HVzdKyeyeZUB62HOYF7bEgaRv
         Jt9+t576UfY48rbmwYwgIt8C90GyE8wYQBx8YIWJM0/B3MTFMhOSnN3yKgeDPSc0WIju
         TiiP78rn6gK6OLaf4+fp74oO27NOnSuaeyJ3+fDfSjR000hgiccNtIloUymSK85MRHZl
         saxF7dNSU+ljbG90g3Zw0dFtUph9lwsmSl18a9MvPw5ypTcLbOl+oeGCO/baSJ7FEL4u
         hm3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fiq96nVjT7sQAwiXIWbAXKJXQQzKMaRKwEla4GjSbOo=;
        b=if0q8C9H6d/o5f4RuAM/Zftx27AIYMHKFo6uGYdXWDoeLrqOJff43ZbVVo4iQmfQ91
         8BId7prCCLlTRsD0bjAmZtgE+y2enS4pbblo91wm641lkOjIoG3mxj4H0xPwKE6WeSje
         /8xCboMnXZX3pvcX/++45BgPT3JcbqRJ5bCTjZZPwN5qugdWA3lts75DvJJoS9+1Ejsf
         GcWYe2gpXXAnZ9+VMmy6f2fvH0bhf66pVtmj6bhMBm5ir5923lD+m+D+goC/p8M3wTBy
         fygC5fTdcpiLuS69QYw7jasZMOV6wqj5hNrHK7u8itkTU2FdW6SFFruh9WeqJ0AFHF+V
         FkXw==
X-Gm-Message-State: APjAAAW1aYmvUHaMjEeyv/jblXxEq8tCaBzRPMe2mUz1VqoBl58IA1NP
        j8vhhPJGsTR+DLvN4YJugboyC13H
X-Google-Smtp-Source: APXvYqz43ZaekBcWKuaU5TGXy/7Gp4rgz+nOb1cNpd6V25W8F55KqjLJmWggha2xwOLprbbJoqLPQA==
X-Received: by 2002:adf:e806:: with SMTP id o6mr4857048wrm.139.1571946086431;
        Thu, 24 Oct 2019 12:41:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:ac52:2d04:d8e7:8f98? (p200300EA8F266400AC522D04D8E78F98.dip0.t-ipconnect.de. [2003:ea:8f26:6400:ac52:2d04:d8e7:8f98])
        by smtp.googlemail.com with ESMTPSA id p12sm27729009wrm.62.2019.10.24.12.41.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 12:41:25 -0700 (PDT)
Subject: Re: [PATCH wireless-drivers 1/2] mt76: mt76x2e: disable pcie_aspm by
 default
To:     Lorenzo Bianconi <lorenzo@kernel.org>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, oleksandr@natalenko.name,
        netdev@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <cover.1571868221.git.lorenzo@kernel.org>
 <fec60f066bab1936d58b2e69bae3f20e645d1304.1571868221.git.lorenzo@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <5924c8eb-7269-b8ef-ad0e-957104645638@gmail.com>
Date:   Thu, 24 Oct 2019 21:41:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <fec60f066bab1936d58b2e69bae3f20e645d1304.1571868221.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.10.2019 00:23, Lorenzo Bianconi wrote:
> On same device (e.g. U7612E-H1) PCIE_ASPM causes continuous mcu hangs and
> instability and so let's disable PCIE_ASPM by default. This patch has
> been successfully tested on U7612E-H1 mini-pice card
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/wireless/mediatek/mt76/mmio.c     | 47 +++++++++++++++++++
>  drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
>  .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  2 +
>  3 files changed, 50 insertions(+)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
> index 1c974df1fe25..f991a8f1c42a 100644
> --- a/drivers/net/wireless/mediatek/mt76/mmio.c
> +++ b/drivers/net/wireless/mediatek/mt76/mmio.c
> @@ -3,6 +3,8 @@
>   * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
>   */
>  
> +#include <linux/pci.h>
> +
>  #include "mt76.h"
>  #include "trace.h"
>  
> @@ -78,6 +80,51 @@ void mt76_set_irq_mask(struct mt76_dev *dev, u32 addr,
>  }
>  EXPORT_SYMBOL_GPL(mt76_set_irq_mask);
>  
> +void mt76_mmio_disable_aspm(struct pci_dev *pdev)
> +{
> +	struct pci_dev *parent = pdev->bus->self;
> +	u16 aspm_conf, parent_aspm_conf = 0;
> +
> +	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &aspm_conf);
> +	aspm_conf &= PCI_EXP_LNKCTL_ASPMC;
> +	if (parent) {
> +		pcie_capability_read_word(parent, PCI_EXP_LNKCTL,
> +					  &parent_aspm_conf);
> +		parent_aspm_conf &= PCI_EXP_LNKCTL_ASPMC;
> +	}
> +
> +	if (!aspm_conf && (!parent || !parent_aspm_conf)) {
> +		/* aspm already disabled */
> +		return;
> +	}
> +
> +	dev_info(&pdev->dev, "disabling ASPM %s %s\n",
> +		 (aspm_conf & PCI_EXP_LNKCTL_ASPM_L0S) ? "L0s" : "",
> +		 (aspm_conf & PCI_EXP_LNKCTL_ASPM_L1) ? "L1" : "");
> +
> +#ifdef CONFIG_PCIEASPM
> +	pci_disable_link_state(pdev, aspm_conf);
> +
> +	/* Double-check ASPM control.  If not disabled by the above, the
> +	 * BIOS is preventing that from happening (or CONFIG_PCIEASPM is
> +	 * not enabled); override by writing PCI config space directly.
> +	 */
> +	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &aspm_conf);
> +	if (!(aspm_conf & PCI_EXP_LNKCTL_ASPMC))
> +		return;
> +#endif /* CONFIG_PCIEASPM */
> +
> +	/* Both device and parent should have the same ASPM setting.
> +	 * Disable ASPM in downstream component first and then upstream.
> +	 */
> +	pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL, aspm_conf);
> +
> +	if (parent)
> +		pcie_capability_clear_word(parent, PCI_EXP_LNKCTL,
> +					   aspm_conf);

+ linux-pci mailing list

All this seems to be legacy code copied from e1000e.
Fiddling with the low-level PCI(e) registers should be left to the
PCI core. It shouldn't be needed here, a simple call to
pci_disable_link_state() should be sufficient. Note that this function
has a return value meanwhile that you can check instead of reading
back low-level registers.
If BIOS forbids that OS changes ASPM settings, then this should be
respected (like PCI core does). Instead the network chip may provide
the option to configure whether it activates certain ASPM (sub-)states
or not. We went through a similar exercise with the r8169 driver,
you can check how it's done there.

> +}
> +EXPORT_SYMBOL_GPL(mt76_mmio_disable_aspm);
> +
>  void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
>  {
>  	static const struct mt76_bus_ops mt76_mmio_ops = {
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
> index 570c159515a0..962812b6247d 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> @@ -578,6 +578,7 @@ bool __mt76_poll_msec(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
>  #define mt76_poll_msec(dev, ...) __mt76_poll_msec(&((dev)->mt76), __VA_ARGS__)
>  
>  void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs);
> +void mt76_mmio_disable_aspm(struct pci_dev *pdev);
>  
>  static inline u16 mt76_chip(struct mt76_dev *dev)
>  {
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
> index 73c3104f8858..264bef87e5c7 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
> @@ -81,6 +81,8 @@ mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	/* RG_SSUSB_CDR_BR_PE1D = 0x3 */
>  	mt76_rmw_field(dev, 0x15c58, 0x3 << 6, 0x3);
>  
> +	mt76_mmio_disable_aspm(pdev);
> +
>  	return 0;
>  
>  error:
> 

