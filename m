Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D303C36A2
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 21:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhGJT4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 15:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhGJT4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 15:56:07 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C14C0613DD;
        Sat, 10 Jul 2021 12:53:21 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id hr1so23783795ejc.1;
        Sat, 10 Jul 2021 12:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=032AH9X+L0SuQKma6ZBqCnEC1Y08NFvFQspfXbtZTrc=;
        b=jh5bhyxLCS4uOzUIY20zOCIxJJklCVTWvEWhZwWiPQ+f5LVhXA8lhQClEEc9DQAJlt
         yrm0doHHvBI2SFTHDqx6ZPs1gG79QA74j3LDahmAGNJ0Kzmd698BmwJj2tCope4nfEeU
         rf7xciiUcw8eStna4DSRzpYLavT/Lo6tAvSbaqISsQQAjbVWPbmH2bp1pGOvgJs5iSql
         VhybcXLJ6fNJx2IQ1Lhqi84ouuP3JNca9wijPvlp/xqhTbSL2i5tIS2mo++jr1sTxESc
         B8V4kgCjiVmvNcAgtqX+Z/zke+L+mnrFSp5KEnfFGpFZeZ0R3k6d49+tRCZQfYSJ8xV1
         srVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=032AH9X+L0SuQKma6ZBqCnEC1Y08NFvFQspfXbtZTrc=;
        b=JDaRK61VmKN/DpxKXjr9pRkjLMEnWXszAqBuTObg1BRju0picNxKUaG9YxF3j2YtI1
         IlT19dbIRM4mxEEnAAAuYe3Cr/8y8MKLEhfS2nsO2kXokCVBGLJIuTI5oBjClxRssRCu
         tij3kiv1Kt39q+NfNOaGij+TktS0+JYnJLDSva7WJDNLk+WaI7CrsEjNKUAPlRHs8mcB
         EUnyYbkXNlBeOVTDu4thbUahOyMbme91NrBDHeCo4YwFDerU57MqzY0iGkU1+Nkz/l8e
         wDGnneKyGf6dqHkE/whPdMrjJbV+FiZQ6b95n/JV+g0rIZT5q5G9uyZ85isq8Kq/3Prx
         Bp9Q==
X-Gm-Message-State: AOAM5339vgKcNqPNAdRCwhDORgzZx3h3YCgZY3a8pqT9Uvaj18cN+kUe
        sicVsj4MJwX6YLBzW11MTQ4=
X-Google-Smtp-Source: ABdhPJxDraNcIVKa7Oo2S0jMzogiysep7Y4HEWBTzG6XeyF/zkHKihsLoyyIrxrrcuQ8If9zuGK8pA==
X-Received: by 2002:a17:906:51d4:: with SMTP id v20mr24768450ejk.107.1625946799826;
        Sat, 10 Jul 2021 12:53:19 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id hg23sm2020432ejc.106.2021.07.10.12.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 12:53:19 -0700 (PDT)
Date:   Sat, 10 Jul 2021 22:53:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 1/8] net: dsa: ocelot: remove unnecessary
 pci_bar variables
Message-ID: <20210710195318.jq3xu2gkbttmcsfy@skbuf>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
 <20210710192602.2186370-2-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710192602.2186370-2-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 12:25:55PM -0700, Colin Foster wrote:
> The pci_bar variables for the switch and imdio don't make sense for the
> generic felix driver. Moving them to felix_vsc9959 to limit scope and
> simplify the felix_info struct.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Just one comment below.

>  drivers/net/dsa/ocelot/felix.h         |  2 --
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 11 +++++------
>  2 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
> index 4d96cad815d5..47769dd386db 100644
> --- a/drivers/net/dsa/ocelot/felix.h
> +++ b/drivers/net/dsa/ocelot/felix.h
> @@ -20,8 +20,6 @@ struct felix_info {
>  	int				num_ports;
>  	int				num_tx_queues;
>  	struct vcap_props		*vcap;
> -	int				switch_pci_bar;
> -	int				imdio_pci_bar;
>  	const struct ptp_clock_info	*ptp_caps;
>  
>  	/* Some Ocelot switches are integrated into the SoC without the
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index f966a253d1c7..182ca749c8e2 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -1359,8 +1359,6 @@ static const struct felix_info felix_info_vsc9959 = {
>  	.num_mact_rows		= 2048,
>  	.num_ports		= 6,
>  	.num_tx_queues		= OCELOT_NUM_TC,
> -	.switch_pci_bar		= 4,
> -	.imdio_pci_bar		= 0,
>  	.quirk_no_xtr_irq	= true,
>  	.ptp_caps		= &vsc9959_ptp_caps,
>  	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
> @@ -1388,6 +1386,9 @@ static irqreturn_t felix_irq_handler(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> +#define VSC9959_SWITCH_PCI_BAR 4
> +#define VSC9959_IMDIO_PCI_BAR 0
> +

I would prefer these to be declared right below

#define VSC9959_TAS_GCL_ENTRY_MAX	63

and aligned with it
