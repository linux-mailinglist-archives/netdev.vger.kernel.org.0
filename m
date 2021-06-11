Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307D03A4624
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhFKQIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:08:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59516 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhFKQIy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 12:08:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=s2Uq4qYKqBUUTqGpAhQDw+qwxWKgEYhRTty5V2rGFiQ=; b=KU1oqRPXe0zTQZEV/88rVSdwPk
        +FFpb/cG+P3P8Et5FNWxNUPFUyjZsvmtaY38xLBvi0AlIS/p0T2LzEzR8zpkvHuLTBzIbSq1cyT7R
        PRDfsCA09IAAI4vqBaU7+q/6nqEId9hyQGzT3x0pXq7YGVvVN/pX1/zV72VACDaaTJ+E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrjgK-008sQx-SX; Fri, 11 Jun 2021 18:06:52 +0200
Date:   Fri, 11 Jun 2021 18:06:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@huawei.com,
        Wenpeng Liang <liangwenpeng@huawei.com>
Subject: Re: [PATCH net-next 7/8] net: phy: remove unnecessary line
 continuation
Message-ID: <YMOKHC6LV1SvMupN@lunn.ch>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-8-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623393419-2521-8-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -			phy_write(phydev, ET1011C_CONFIG_REG, val\
> -					| ET1011C_GMII_INTERFACE\
> -					| ET1011C_SYS_CLK_EN\
> +			phy_write(phydev, ET1011C_CONFIG_REG, val
> +					| ET1011C_GMII_INTERFACE
> +					| ET1011C_SYS_CLK_EN
>  					| ET1011C_TX_FIFO_DEPTH_16);

Please put the | at the end of the line, not the beginning of the next
line.

Thanks
	Andrew
