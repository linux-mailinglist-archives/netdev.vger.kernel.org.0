Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75D6C11EF06
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfLNAKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:10:33 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42493 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfLNAKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 19:10:33 -0500
Received: by mail-lj1-f196.google.com with SMTP id e28so521319ljo.9
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=qO581ryzWnuopWnNAxCBPoLTDTR3yaDY2w2kCADf9gA=;
        b=zSn5mb2MWn63z6z8bq2BS8z/ogCUFtsL3llUxEt+W7Qg5xE7sHoUwyLQHj2FfeL8b3
         Rsi1vf7010CokMVLe+1aGxEXSQFjGEQaAn4vc7IFK4gBZsHy1tZiddJ3wpaYqr5piZGk
         6b6aDrlcmugwoybTmcIgUoqlKgkMXwfdPxV5EvOAERUgPvNeLLhV8dM6Wt25nP91t8qh
         Gk0ejpDJapEzi59Vu8nl19N/CRzWkTp4FXuhtdgIYfJx5QTsL8AbzeiKV4aXm+oOQuGg
         DGAR2OdwKyg6RTNkpNjJ23FXZg5SDT4vcl7bCjbzWmP6qWD9n8XwlXrdGn2VBUWe1+Gi
         ZY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qO581ryzWnuopWnNAxCBPoLTDTR3yaDY2w2kCADf9gA=;
        b=lM0VaS86ZhDn9kOPdZAE7/n/RzbZgTswEOcvfyb7Vb+gnBSz+IledwpjyjY5VlAwzS
         R2h4BjAy/SP4SQvWnc270S9LzSYa+fWNZYjEXpjXxcAbmzGKVFxasCZphEZaC38pShDC
         At+IcEa4dhbHvAv6Opf7jXqRJwkJDod4dHGLh5M/+aEuCj8D7SzzkKp+g7MkWwORH/9j
         fS+Zn/RpErzad2K0q5H5AVigenb2AjGmCiPQgVrpN7+SCit4SLBvKzUU5SVajRjOur5T
         yLiZe1bL6/xap3M4YkHDjAmN301RqViDhz/8j9XKgc75rGv9N/RVNtkVFB52w0dMGb14
         RjQw==
X-Gm-Message-State: APjAAAVB1jF7ak7QmL7Wv0nZS3r510EKoRlr6goU2TBbO5XWAO5eqbP2
        reqrlHFp+1Bb7L6DS3qEJejCMw==
X-Google-Smtp-Source: APXvYqxeMiRIGGqi8jPl8Q7ci5BVZuWPhWojKwf9HWqMMC0Z+PoBMtIUt2Nnvmp0sBaZuyTChesDbg==
X-Received: by 2002:a2e:9741:: with SMTP id f1mr10967109ljj.123.1576282230442;
        Fri, 13 Dec 2019 16:10:30 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w19sm5106135lfl.55.2019.12.13.16.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 16:10:30 -0800 (PST)
Date:   Fri, 13 Dec 2019 16:10:21 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, arnd@arndb.de, maowenan@huawei.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH] net: mscc: ocelot: hide MSCC_OCELOT_SWITCH and move
 outside NET_VENDOR_MICROSEMI
Message-ID: <20191213161021.6c96d8fe@cakuba.netronome.com>
In-Reply-To: <20191212171125.9933-1-olteanv@gmail.com>
References: <20191212171125.9933-1-olteanv@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 19:11:25 +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> NET_DSA_MSCC_FELIX and MSCC_OCELOT_SWITCH_OCELOT are 2 different drivers
> that use the same core operations, compiled under MSCC_OCELOT_SWITCH.
> 
> The DSA driver depends on HAVE_NET_DSA, and the switchdev driver depends
> on NET_VENDOR_MICROSEMI. This dependency is purely cosmetic (to hide
> options per driver class, or per networking vendor) from menuconfig
> choices.
> 
> However, there is an issue with the fact that the common core depends on
> NET_VENDOR_MICROSEMI, as can be seen below, when building the DSA
> driver:
> 
> WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
> Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] &&
> NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
> Selected by [y]:
> NET_DSA_MSCC_FELIX [=y] && NETDEVICES [=y] && HAVE_NET_DSA [=y]
> && NET_DSA [=y] && PCI [=y]
> 
> We don't want to make NET_DSA_MSCC_FELIX hidden under
> NET_VENDOR_MICROSEMI, since it is physically located under
> drivers/net/dsa and already findable in the configurator through DSA.
> 
> So we move the common Ocelot core outside the NET_VENDOR_MICROSEMI
> selector, and we make the switchdev and DSA drivers select it by
> default. In that process, we hide it from menuconfig, since the user
> shouldn't need to know anything about it, and we change it from tristate
> to bool, since it doesn't make a lot of sense to have it as yet another
> loadable kernel module.

Mmm. Is that really the only choice? Wouldn't it be better to do
something like:

diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index 13fa11c30f68..991db8b94a9c 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -10,7 +10,8 @@ config NET_VENDOR_MICROSEMI
          the questions about Microsemi devices.
 
 config MSCC_OCELOT_SWITCH
-       bool
+       tristate
+       default (MSCC_OCELOT_SWITCH_OCELOT || NET_DSA_MSCC_FELIX)
        depends on NET_SWITCHDEV
        depends on HAS_IOMEM
        select REGMAP_MMIO

Presumably if user wants the end driver to be loadable module the
library should default to a module?

> With this, the DSA driver also needs to explicitly depend on ETHERNET,
> to avoid an unmet dependency situation caused by selecting
> MSCC_OCELOT_SWITCH when ETHERNET is disabled.
> 
> A few more dependencies were shuffled around. HAS_IOMEM is now "depends"
> to avoid a circular dependency:
> 
> symbol HAS_IOMEM is selected by MSCC_OCELOT_SWITCH
> symbol MSCC_OCELOT_SWITCH depends on NETDEVICES
> symbol NETDEVICES is selected by SCSI_CXGB3_ISCSI
> symbol SCSI_CXGB3_ISCSI depends on SCSI_LOWLEVEL
> symbol SCSI_LOWLEVEL depends on SCSI
> symbol SCSI is selected by ATA
> symbol ATA depends on HAS_IOMEM
> 
> Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Mao Wenan <maowenan@huawei.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/ocelot/Kconfig    |  2 +-
>  drivers/net/ethernet/mscc/Kconfig | 27 ++++++++++++++++-----------
>  2 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
> index 0031ca814346..c41d50ca98b7 100644
> --- a/drivers/net/dsa/ocelot/Kconfig
> +++ b/drivers/net/dsa/ocelot/Kconfig
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config NET_DSA_MSCC_FELIX
>  	tristate "Ocelot / Felix Ethernet switch support"
> -	depends on NET_DSA && PCI
> +	depends on NET_DSA && PCI && ETHERNET
>  	select MSCC_OCELOT_SWITCH
>  	select NET_DSA_TAG_OCELOT
>  	help
> diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
> index bcec0587cf61..13fa11c30f68 100644
> --- a/drivers/net/ethernet/mscc/Kconfig
> +++ b/drivers/net/ethernet/mscc/Kconfig
> @@ -9,24 +9,29 @@ config NET_VENDOR_MICROSEMI
>  	  kernel: saying N will just cause the configurator to skip all
>  	  the questions about Microsemi devices.
>  
> -if NET_VENDOR_MICROSEMI
> -
>  config MSCC_OCELOT_SWITCH
> -	tristate "Ocelot switch driver"
> +	bool
>  	depends on NET_SWITCHDEV
>  	depends on HAS_IOMEM
> -	select PHYLIB
>  	select REGMAP_MMIO
> +	select PHYLIB

The move of select PHYLIB seems unnecessary, is there a reason?
Otherwise since this is net material perhaps better to refrain from it.

>  	help
> -	  This driver supports the Ocelot network switch device.
> +	  This is the core library for the Vitesse / Microsemi / Microchip
> +	  Ocelot network switch family. It offers a set of DSA-compatible
> +	  switchdev operations for managing switches of this class, like:
> +	  - VSC7514
> +	  - VSC9959
> 
> +if NET_VENDOR_MICROSEMI
>  
>  config MSCC_OCELOT_SWITCH_OCELOT
> -	tristate "Ocelot switch driver on Ocelot"
> -	depends on MSCC_OCELOT_SWITCH
> -	depends on GENERIC_PHY
> -	depends on OF_NET
> +	tristate "Ocelot switch driver for local management CPUs"
> +	select MSCC_OCELOT_SWITCH
> +	select GENERIC_PHY
> +	select OF_NET
>  	help
> -	  This driver supports the Ocelot network switch device as present on
> -	  the Ocelot SoCs.
> +	  This supports the network switch present on the Ocelot SoCs
> +	  (VSC7514). The driver is intended for use on the local MIPS
> +	  management CPU. Frame transfer is through polled I/O or DMA.
>  
>  endif # NET_VENDOR_MICROSEMI

