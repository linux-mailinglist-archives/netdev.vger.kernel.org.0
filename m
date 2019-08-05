Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF3AF81EFF
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbfHEOZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:25:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34240 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728028AbfHEOZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 10:25:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pM17/mm7hk6l4gBw6yqpxD0ipo386Hkuzc90J1eBglE=; b=GcTf+FLjhwfrAUNoa6l/XXGacB
        kzklya1rmkLVLe/R5iYyoC3JilZyu6VOOTxRFULB93Vlr4x6dzso5Chtc9hCO4k7ngeQqdSuB568t
        p+xID9+UbrphMcQC4gZ6MEhB/8dyUEEunc16p5H0oAa9J/ZnU+LUf0vqCAWT1JVKvlTc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hudvF-0007St-54; Mon, 05 Aug 2019 16:25:13 +0200
Date:   Mon, 5 Aug 2019 16:25:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 04/16] net: phy: adin: add {write,read}_mmd hooks
Message-ID: <20190805142513.GK24275@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-5-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-5-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
> index b75c723bda79..3dd9fe50f4c8 100644
> --- a/drivers/net/phy/adin.c
> +++ b/drivers/net/phy/adin.c
> @@ -14,6 +14,9 @@
>  #define PHY_ID_ADIN1200				0x0283bc20
>  #define PHY_ID_ADIN1300				0x0283bc30
>  
> +#define ADIN1300_MII_EXT_REG_PTR		0x10
> +#define ADIN1300_MII_EXT_REG_DATA		0x11
> +
>  #define ADIN1300_INT_MASK_REG			0x0018

Please be consistent with registers. Either use 4 digits, or 2 digits.

       Andrew
