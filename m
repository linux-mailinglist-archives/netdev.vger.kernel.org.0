Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423CF2A14A2
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 10:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgJaJSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 05:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgJaJSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 05:18:30 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1BDC0613D5;
        Sat, 31 Oct 2020 02:18:28 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id s15so11833134ejf.8;
        Sat, 31 Oct 2020 02:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mxv6t1OOCkxikxnlS/acjLw3eXE0gHOO14C0raf/cWs=;
        b=mfDt5epUbAW5bpOoMW0zNUCqaOnNUEEIfmkVx6QyltkMNBInh9tsLV9RBS/L00jtGx
         x0v0nRZeMblVXh8xE23KvEtfdoVpujN0/ZaMNIJEdiNFzx9I9VclWPWxgzeXbdi7doZA
         OUiK3EOY+GZdXSwQXzKjL1lnvrrceEiwXlK8MRpCnNBK2DeynMjnl329kDY+++k3TgLb
         NstdwuyOvw6fhGfN5QAc1BxjFl7z1CvwZtZT/2I+PaNoZPtmKmy660pDAYNBWcIJXaE0
         dGUDskHCT9VPN5wt/ppjX/sJAyjx7OwhFzWUSH35qEf2n+z7vUnW1iRKUbLQxU5xNGb3
         n5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mxv6t1OOCkxikxnlS/acjLw3eXE0gHOO14C0raf/cWs=;
        b=QUY/pZp54n18G9HTj5ECO5eJ1tFCeYe/QqasbWY/Jy6wnPysJA4BQsLKEBR9gxYfqB
         JCJRdMYYBklVqPtxnjGwMKcVdrhcyxX/gz5OhFo4OvknE9E4HjmBpy8R7Xv14pPgJUHs
         0pQmg1FLGAXDccQzez+/26ovugcuB3Wcsf7/7P6PjspjWRvTgUXHovoMQQ2gJnjx1X+5
         kPZbhX0qNckWJdRgP52s7IMvWagCUjEY6oC9a0qOj6W3V+Ksn6VcPsxzrJ29lE7iDDjZ
         9oZHIqBdOSXpiseVFUffUNMXMadqBdkEbMLMMjfY0DGmIywYUbS9/WGwrgMDZqjzKbAB
         /OvA==
X-Gm-Message-State: AOAM531TFIUZfiWVYHyh2mdZ4c+LjUEqFffxwd4RC65jUFfnwqICbAH1
        /IstAyy7Od9UxV4SNpfqPuM=
X-Google-Smtp-Source: ABdhPJxK/stNwBOlUKRQTJKcTRHO40bN58D2RTa2BNd99y1Y3CC1ytha1e54e05zZHWnXuo6Wj9q/A==
X-Received: by 2002:a17:906:580e:: with SMTP id m14mr6186777ejq.237.1604135907524;
        Sat, 31 Oct 2020 02:18:27 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q22sm4364662ejm.13.2020.10.31.02.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 02:18:26 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Sat, 31 Oct 2020 11:18:25 +0200
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, robh@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/4] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
Message-ID: <20201031091825.uucn2ax2cjzzuy2e@skbuf>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-5-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030172950.12767-5-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 12:29:50PM -0500, Dan Murphy wrote:
> The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
> that supports 10M single pair cable.
> 
> The device supports both 2.4-V p2p and 1-V p2p output voltage as defined
> by IEEE 802.3cg 10Base-T1L specfications. These modes can be forced via
> the device tree or the device is defaulted to auto negotiation to
> determine the proper p2p voltage.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  drivers/net/phy/Kconfig     |   6 +
>  drivers/net/phy/Makefile    |   1 +
>  drivers/net/phy/dp83td510.c | 681 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 688 insertions(+)
>  create mode 100644 drivers/net/phy/dp83td510.c
>

(...)

> +static int dp83td510_ack_interrupt(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read(phydev, DP83TD510_INT_REG1);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = phy_read(phydev, DP83TD510_INT_REG2);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int dp83td510_config_intr(struct phy_device *phydev)
> +{
> +	int int_status;
> +	int gen_cfg_val;
> +	int ret;
> +
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
> +		int_status = phy_read(phydev, DP83TD510_INT_REG1);
> +		if (int_status < 0)
> +			return int_status;
> +
> +		int_status = (DP83TD510_INT1_ESD_EN | DP83TD510_INT1_LINK_EN |
> +			      DP83TD510_INT1_RHF_EN);
> +
> +		ret = phy_write(phydev, DP83TD510_INT_REG1, int_status);
> +		if (ret)
> +			return ret;
> +
> +		int_status = phy_read(phydev, DP83TD510_INT_REG2);
> +		if (int_status < 0)
> +			return int_status;
> +
> +		int_status = (DP83TD510_INT2_POR | DP83TD510_INT2_POL |
> +				DP83TD510_INT2_PAGE);
> +
> +		ret = phy_write(phydev, DP83TD510_INT_REG2, int_status);
> +		if (ret)
> +			return ret;
> +
> +		gen_cfg_val = phy_read(phydev, DP83TD510_GEN_CFG);
> +		if (gen_cfg_val < 0)
> +			return gen_cfg_val;
> +
> +		gen_cfg_val |= DP83TD510_INT_OE | DP83TD510_INT_EN;
> +
> +	} else {
> +		ret = phy_write(phydev, DP83TD510_INT_REG1, 0);
> +		if (ret)
> +			return ret;
> +
> +		ret = phy_write(phydev, DP83TD510_INT_REG2, 0);
> +		if (ret)
> +			return ret;
> +
> +		gen_cfg_val = phy_read(phydev, DP83TD510_GEN_CFG);
> +		if (gen_cfg_val < 0)
> +			return gen_cfg_val;
> +
> +		gen_cfg_val &= ~DP83TD510_INT_EN;
> +	}
> +
> +	return phy_write(phydev, DP83TD510_GEN_CFG, gen_cfg_val);
> +}
> +

I am not really sure if the shared-IRQ work in the below linked patch
set will go through, but I think it would be cleaner just to ack any
pending interrupts after you disable them.

https://lore.kernel.org/netdev/20201029100741.462818-1-ciorneiioana@gmail.com/

I see that you are reading the INT_REG1 and INT_REG2 registers
(basically servicing any pending interrupts) before enabling the IRQ.
The same reads should be done after the IRQ has been disabled.

> +static struct phy_driver dp83td510_driver[] = {
> +	{
> +		PHY_ID_MATCH_MODEL(DP83TD510E_PHY_ID),
> +		.name		= "TI DP83TD510E",
> +		.probe          = dp83td510_probe,
> +		.config_init	= dp83td510_config_init,
> +		.soft_reset	= dp83td510_phy_reset,
> +
> +		/* IRQ related */
> +		.ack_interrupt	= dp83td510_ack_interrupt,
> +		.config_intr	= dp83td510_config_intr,

I think the PHY maintainers could comment on this more, but maybe it
would help if the driver implements the .handle_interrupt() callback
just so that I wouldn't have to touch a driver that was just added to
rework it for the shared-IRQ transition.

Ioana
