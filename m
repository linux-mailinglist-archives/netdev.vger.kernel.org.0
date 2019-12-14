Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B7111F40A
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 21:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfLNUtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 15:49:01 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34165 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfLNUtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 15:49:01 -0500
Received: by mail-pg1-f195.google.com with SMTP id r11so1334222pgf.1
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 12:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2IdZ4ekCQ6PMgSqK8hctEqFSrGXA9RF+ZiyRs539CIs=;
        b=C4cMIcRKqgb7XDTzizag1jyyKpUw3a6kCSefQN1k3U/NmqeoarPF5j4D7HUwrOOt6M
         ymBSUbBrKUa0PPtbHUAAwXT6h0EfJOBiqAB+Ks9cUHAcqp+eDeLpyI4MRWkY9brrrhfJ
         OW7myxcF8q90/hrVqFYvw9z7uuupzeRDYdwguwq/zh4wSgOKk0/QFOVGQV0mwfBXQcJd
         DWGqtCx65IT9GNOhYnXEimmp6IPmfBDGuEBeSX5i8YDzRrkOXBdA7v38uV5qBb3sf2A9
         71bIEqL6cCG5uQRnv1cfDpCrB7sf7sD3GqVeO2Uxma2W87IPn5W7+op+ad67zTpzcetD
         dCXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2IdZ4ekCQ6PMgSqK8hctEqFSrGXA9RF+ZiyRs539CIs=;
        b=ui4EWe9iixMZzWFDDr1bb5P25UBedcVb2LzVLTd8Vl/a0Gk48Tmzm7mTuVYCs7hGJc
         ySg9ga/QBGsFwm5IQgIIHWXgDV3MB+frhyo821iKR8xppMWJXuyJf/ERQjnO8tQRISu5
         yJ4DMEkV0vvSpa1H+oC0pbdfrgcoEBnsm9q+kic+RjEwJ+B3eix/oukvh8nR4zMr552l
         SHUa9ijReaIlM7rZTmEfSTbvFclHo8PNw+IkjIg8h465bfW8oYt2l5WWtufYQ1Id75jg
         MJo53sjrgjfReN8f6+4Cu/0xIYXEfTjCWOO4xkM/x8p8Vt6u4bW1RrSQr+l6JIPYepCc
         1CNg==
X-Gm-Message-State: APjAAAX/h7WygTEgMaUmiu6AMumeCYsTe/1cmvyZede3Vgv49bYRANV6
        Hw9bH8BynaDna08/IQTXuLIWGQ==
X-Google-Smtp-Source: APXvYqyHqTzavs+mcqeibXkMmsY4yuF7m4xLpw0VZZNkHi6v4WW/MyDb4VDhmMyN58j9TheL8A9PUw==
X-Received: by 2002:a63:1666:: with SMTP id 38mr7844385pgw.325.1576356540294;
        Sat, 14 Dec 2019 12:49:00 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id p38sm13324756pjp.27.2019.12.14.12.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 12:49:00 -0800 (PST)
Date:   Sat, 14 Dec 2019 12:48:56 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ajay Gupta <ajaykuee@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, treding@nvidia.com,
        Ajay Gupta <ajayg@nvidia.com>
Subject: Re: [PATCH v2 2/2] net: stmmac: dwc-qos: avoid clk and reset for
 acpi device
Message-ID: <20191214124856.4a9e2449@cakuba.netronome.com>
In-Reply-To: <20191211071125.15610-3-ajayg@nvidia.com>
References: <20191211071125.15610-1-ajayg@nvidia.com>
        <20191211071125.15610-3-ajayg@nvidia.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 23:11:25 -0800, Ajay Gupta wrote:
> From: Ajay Gupta <ajayg@nvidia.com>
> 
> There are no clocks or resets referenced by Tegra ACPI device
> so don't access clocks or resets interface with ACPI device.
> 
> Clocks and resets for ACPI devices will be handled via ACPI
> interface.
> 
> Signed-off-by: Ajay Gupta <ajayg@nvidia.com>
> ---
> Change from v1->v2: Rebased.
> 
>  .../stmicro/stmmac/dwmac-dwc-qos-eth.c        | 122 ++++++++++--------
>  1 file changed, 67 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
> index f87306b3cdae..70e8c41f7761 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
> @@ -272,6 +272,7 @@ static void *tegra_eqos_probe(struct platform_device *pdev,
>  			      struct stmmac_resources *res)
>  {
>  	struct tegra_eqos *eqos;
> +	struct device *dev = &pdev->dev;
>  	int err;

Looks like this file uses reverse xmas tree variable ordering (longest
to shortest total line length), please comply and add the dev first.

>  	eqos = devm_kzalloc(&pdev->dev, sizeof(*eqos), GFP_KERNEL);
> @@ -283,77 +284,88 @@ static void *tegra_eqos_probe(struct platform_device *pdev,
>  	eqos->dev = &pdev->dev;
>  	eqos->regs = res->addr;
>  
> -	eqos->clk_master = devm_clk_get(&pdev->dev, "master_bus");
> -	if (IS_ERR(eqos->clk_master)) {
> -		err = PTR_ERR(eqos->clk_master);
> -		goto error;
> -	}
> +	if (is_of_node(dev->fwnode)) {
> +		eqos->clk_master = devm_clk_get(&pdev->dev, "master_bus");
> +		if (IS_ERR(eqos->clk_master)) {
> +			err = PTR_ERR(eqos->clk_master);
> +			goto error;
> +		}

You're indenting most of this function (~70 lines?) Would it be
possible to move this code out into a separate function?

[..]
> +	} else {
> +		/* set clk and reset handle to NULL for non DT device */
> +		eqos->clk_master = NULL;
> +		eqos->clk_slave = NULL;
> +		data->stmmac_clk = NULL;
> +		eqos->clk_rx = NULL;
> +		eqos->clk_tx = NULL;
> +		eqos->reset = NULL;

Not sure about data, but eqos is zalloced so there should be no need to
set the pointers to NULL.

> +	}
