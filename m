Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72F83EC9AD
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 16:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238544AbhHOOuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 10:50:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50668 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232179AbhHOOt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Aug 2021 10:49:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6PILfRjAPIVbz7yptfJPF9IyZ40Hyv3qB6aT3DV5dp0=; b=ut2RCLnu27XQkRGthBymynOQQZ
        Xd9ucWfi3PcTak22UjzYxGXAGt7U9J6iHthlTmr6SlbDZT39eIje4WbhY2ZEzJ6pkaJ2/pBNRKPK0
        ON+VrolZU6G55MJ3K7AKMEb7xLbgA6AQJkfAFWdUI16lItFHaOmMy3hgObykL0iOW5t8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mFHRt-000FOs-IJ; Sun, 15 Aug 2021 16:49:17 +0200
Date:   Sun, 15 Aug 2021 16:49:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robert.marko@sartura.hr,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
Subject: Re: [PATCH v3 1/3] net: mdio: Add the reset function for IPQ MDIO
 driver
Message-ID: <YRkpbb8e7EP1McjP@lunn.ch>
References: <20210812100642.1800-1-luoj@codeaurora.org>
 <20210812100642.1800-2-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812100642.1800-2-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 06:06:40PM +0800, Luo Jie wrote:
> 1. configure the MDIO clock source frequency.
> 2. the LDO resource is needed to configure the ethernet LDO available
> for CMN_PLL.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
