Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3B93D0FB2
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 15:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbhGUM7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 08:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238381AbhGUM7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 08:59:25 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E26C002B64;
        Wed, 21 Jul 2021 06:40:00 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d12so2208048wre.13;
        Wed, 21 Jul 2021 06:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2YZWGZN/barbCQ4PSNvEgZE4u5ohSafJjdAflTNqMgo=;
        b=DY6ZW5ektiXig4yptvS9aLBaijbyR5XPieFrWmitZje3FrzUAyXvmyB7XDFu5dbOFf
         ndRlZKbo6PUsSs2Bs7mvgMWw2jRhNerf6IL4FR8yUixvcb+QNQs0+DMYPrFCGohOLEb9
         HmD581Q2ZQn3OroMlsjTncDLnfKP2qU6lEk2R7a2SQxh7QqKInVyUzINM/zNoKvh4UWP
         P3mL3d+ogtY6yOuai8T9npV3cRk+IEKgGPalzsq6jbbjxPo8D2b1dWCQ3+Oka5S4mJhu
         zvOegmp8aEevP5/QEtCWoUHEqeSKnCGvFZ7NtsmcubOeIdh8xM59TDTGumsoft7kqShh
         1jkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2YZWGZN/barbCQ4PSNvEgZE4u5ohSafJjdAflTNqMgo=;
        b=YxGQJbGJmTgThSDTRSOyg8XUxiQhqaH0cP6OBtxPz/K9DhPYQXoPlpC8iRexepVsG6
         y3iCLW1DRLfB2IVZBTyK0B+ma7Dxl5K6fRiNsE/zQP+MR24bja6VpDYKtf3/DRY3aB44
         Rm7PEGiB3jOOFFbgftPeVqGbuMl4DkK2NKLPoXrwftXIRcq2f0Tig2RcJfYpzp7YaE08
         br7UjiyYXzGUCWeOGF9FGctJ0+M0LT/c+7w0QctoQ+L8u/XDFwyuUGFvnUN/GIhoo6Ko
         iIMwJIO2estRm/GoKBfkHQ2+Q1dTcskl8LeUr6lrOtEjfhkY9O0gJ9mhyUcqjODGDJif
         ytwQ==
X-Gm-Message-State: AOAM530rvD7zHLwvwrwz4BMg1YlZWPLJioJ1zBICa+8dQo/TVlmrzg4s
        WGAW/r/b/Vn/MS66BcMGzG1/lAiU8zS8ZSH/
X-Google-Smtp-Source: ABdhPJxUoK4ngIeYTYIeMp+nrdVW1rzVTvvMf1oFSztb8AbntNCukxzjtWSBNkREq7jtUpangYWSlQ==
X-Received: by 2002:a5d:410b:: with SMTP id l11mr42738870wrp.173.1626874799148;
        Wed, 21 Jul 2021 06:39:59 -0700 (PDT)
Received: from ?IPv6:2a02:810d:d40:2317:2ef0:5dff:fe0a:a2d5? ([2a02:810d:d40:2317:2ef0:5dff:fe0a:a2d5])
        by smtp.gmail.com with ESMTPSA id 129sm22792434wmz.26.2021.07.21.06.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 06:39:58 -0700 (PDT)
Subject: Re: [PATCH v2] Expose Peak USB device id in sysfs via phys_port_name.
To:     =?UTF-8?Q?St=c3=a9phane_Grosjean?= <s.grosjean@peak-system.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210721124048.590426-1-nautsch2@gmail.com>
 <20210721125926.593283-1-nautsch2@gmail.com>
 <PA4PR03MB67973D473C7CE600A6104EE8D6E39@PA4PR03MB6797.eurprd03.prod.outlook.com>
From:   Andre Naujoks <nautsch2@gmail.com>
Message-ID: <fe8998f2-7897-735c-926f-6b6b74018784@gmail.com>
Date:   Wed, 21 Jul 2021 15:39:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <PA4PR03MB67973D473C7CE600A6104EE8D6E39@PA4PR03MB6797.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 21.07.21 um 15:29 schrieb Stéphane Grosjean:
> Hi,
> 
> The display and the possibility to change this "device_number" is a current modification of the peak_usb driver. This modification will offer this possibility for all CAN - USB interfaces of PEAK-System.

Hi.

By "current modification" you mean something not yet public? Do you have 
a time frame for when you are planning to make it public? I'd really 
like to use this :-)

> 
> However, it is planned to create new R/W entries for this (under /sys/class/net/canX/...) as is already the case in other USB - CAN interface drivers.

I'd be fine with that. I just chose something, that was already 
available and looked as if it made the most sense without breaking anything.

Thanks for the reply!
   Andre

> 
> — Stéphane
> 
> 
> De : Andre Naujoks <nautsch2@gmail.com>
> Envoyé : mercredi 21 juillet 2021 14:59
> À : Wolfgang Grandegger <wg@grandegger.com>; Marc Kleine-Budde <mkl@pengutronix.de>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Stéphane Grosjean <s.grosjean@peak-system.com>; Vincent Mailhol <mailhol.vincent@wanadoo.fr>; Gustavo A. R. Silva <gustavoars@kernel.org>; Pavel Skripkin <paskripkin@gmail.com>; Colin Ian King <colin.king@canonical.com>; Andre Naujoks <nautsch2@gmail.com>; linux-can@vger.kernel.org <linux-can@vger.kernel.org>; netdev@vger.kernel.org <netdev@vger.kernel.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
> Objet : [PATCH v2] Expose Peak USB device id in sysfs via phys_port_name.
> 
> The Peak USB CAN adapters can be assigned a device id via the Peak
> provided tools (pcan-settings). This id can currently not be set by the
> upstream kernel drivers, but some devices expose this id already.
> 
> The id can be used for consistent naming of CAN interfaces regardless of
> order of attachment or recognition on the system. The classical CAN Peak
> USB adapters expose this id via bcdDevice (combined with another value)
> on USB-level in the sysfs tree and this value is then available in
> ID_REVISION from udev. This is not a feasible approach, when a single
> USB device offers more than one CAN-interface, like e.g. the PCAN-USB
> Pro FD devices.
> 
> This patch exposes those ids via the, up to now unused, netdevice sysfs
> attribute phys_port_name as a simple decimal ASCII representation of the
> id. phys_port_id was not used, since the default print functions from
> net/core/net-sysfs.c output a hex-encoded binary value, which is
> overkill for a one-byte device id, like this one.
> 
> Signed-off-by: Andre Naujoks <nautsch2@gmail.com>
> ---
>   drivers/net/can/usb/peak_usb/pcan_usb_core.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> index e8f43ed90b72..f6cbb01a58cc 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> @@ -408,6 +408,21 @@ static netdev_tx_t peak_usb_ndo_start_xmit(struct sk_buff *skb,
>           return NETDEV_TX_OK;
>   }
> 
> +static int peak_usb_ndo_get_phys_port_name(struct net_device *netdev,
> +                                          char *name, size_t len)
> +{
> +       const struct peak_usb_device *dev = netdev_priv(netdev);
> +       int err;
> +
> +       err = snprintf(name, len, "%u", dev->device_number);
> +
> +       if (err >= len || err <= 0) {
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
>   /*
>    * start the CAN interface.
>    * Rx and Tx urbs are allocated here. Rx urbs are submitted here.
> @@ -769,6 +784,7 @@ static const struct net_device_ops peak_usb_netdev_ops = {
>           .ndo_stop = peak_usb_ndo_stop,
>           .ndo_start_xmit = peak_usb_ndo_start_xmit,
>           .ndo_change_mtu = can_change_mtu,
> +       .ndo_get_phys_port_name = peak_usb_ndo_get_phys_port_name,
>   };
> 
>   /*
> --
> 2.32.0
> 
> --
> PEAK-System Technik GmbH
> Sitz der Gesellschaft Darmstadt - HRB 9183
> Geschaeftsfuehrung: Alexander Gach / Uwe Wilhelm
> Unsere Datenschutzerklaerung mit wichtigen Hinweisen
> zur Behandlung personenbezogener Daten finden Sie unter
> www.peak-system.com/Datenschutz.483.0.html
> 

