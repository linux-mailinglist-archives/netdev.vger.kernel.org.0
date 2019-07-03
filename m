Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE28A5ED3D
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfGCUKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:10:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52166 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbfGCUKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 16:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TPWVIErTayik2edSo/VKbrrdLvMsqce5uWXEpj/oAnw=; b=QjyXuNlTAI2gOt0dEDzQkINfW6
        BTzHSx8gAPdgxDnI1nGYQ9+TtvC7FP0VvT207N2qyEhVoZi91tCg5iRyKBiz8z1h14cTIW0MYlfng
        JxNSl3d9zfSbV5L3QMVe5U1xEDjbbTqDrLIhsRscWKO3DMnti5b0TmXUJ9B7GpEhmYr8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hilaK-0007Vg-4b; Wed, 03 Jul 2019 22:10:32 +0200
Date:   Wed, 3 Jul 2019 22:10:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 7/7] net: phy: realtek: configure RTL8211E LEDs
Message-ID: <20190703201032.GG18473@lunn.ch>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-7-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703193724.246854-7-mka@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	for (i = 0; i < count; i++) {
> +		u32 val;
> +
> +		of_property_read_u32_index(dev->of_node,
> +					   "realtek,led-modes", i, &val);

Please validate the value, 0 - 7.

       Andrew
