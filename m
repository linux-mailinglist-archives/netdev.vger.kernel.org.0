Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E473C7566
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhGMRBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 13:01:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52960 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhGMRBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 13:01:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0IDA8J9WhEK+nNvEP+NO8puCGNWVIwMG+Tjaae6uzh8=; b=4FLZzGs5ybXb+3F4kMsaXItVJs
        HeKhsgaqrUPaKe/T8UL/7E9zgYKcYpWN+DuCnIJ+YfSov2j603ggzp8cO4XN07boL7TRJ1V60Ki0U
        LZXCtXbcb7z/aEP9OyMSeaTJ89lCsrTTnAAZQIyegOw8/5Z2A1W4a/1exS26AXn1x3S4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m3Ljq-00DEW3-JZ; Tue, 13 Jul 2021 18:58:30 +0200
Date:   Tue, 13 Jul 2021 18:58:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: Re: [PATCH v2 3/7] net: phy: adin1100: Add initial support for
 ADIN1100 industrial PHY
Message-ID: <YO3GNqqUbyxId+Mn@lunn.ch>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
 <20210712130631.38153-4-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712130631.38153-4-alexandru.tachici@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static const int phy_10_features_array[] = {
> +	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,

Does you device implement ETHTOOL_LINK_MODE_10baseT1L_Half_BIT? I'm
assuming half duplex is part of the standard?

	 Andrew
