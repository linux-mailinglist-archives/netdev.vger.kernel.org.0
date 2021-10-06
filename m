Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C2A424902
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 23:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhJFViE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 17:38:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52958 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbhJFViC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 17:38:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zHpbsjc3qKt9LogaeKeHB5njaBmULVU/acnxbVKrwRQ=; b=0qfrzn0bkrFkSFvPNuD8AE9cvl
        PgfXbR8fbI0/IOz78MVLiTCjCrfDxgbdEqqxp6GqiM3KNzs3ALy0Abwbwh5rw2EYcYpcL1VXJXaVv
        rnbsznsSTzMPsWWckChQIX3xEUNZRDCdniu0WMa6EHH/gZxK6iblb0HwO6aj5lGjmrpA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYEa1-009sY3-Ro; Wed, 06 Oct 2021 23:36:01 +0200
Date:   Wed, 6 Oct 2021 23:36:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcel Ziswiler <marcel@ziswiler.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Frank Rowand <frowand.list@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Olof Johansson <olof@lixom.net>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        soc@kernel.org
Subject: Re: [PATCH v2 3/3] ARM: dts: mvebu: add device tree for netgear
 gs110emx switch
Message-ID: <YV4WweG1ukE9HfJr@lunn.ch>
References: <20211006063321.351882-1-marcel@ziswiler.com>
 <20211006063321.351882-4-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006063321.351882-4-marcel@ziswiler.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	reg_3p3v: regulator-3p3v {
> +		compatible = "regulator-fixed";
> +		regulator-always-on;
> +		regulator-max-microvolt = <3300000>;
> +		regulator-min-microvolt = <3300000>;
> +		regulator-name = "3P3V";
> +	};

Sorry, i missed this the first time. This regulator does not appear to
be used. Other armada boards us it in the sdhci controller, but it
does not look like this board uses that. So i think you can remove
this.

	Andrew
