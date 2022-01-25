Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8B249BA70
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243215AbiAYReh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:34:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53670 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1588269AbiAYRcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 12:32:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/fp2RW+WTrkt/5EmkS1z/tRkquj7q2TTpRqNxuP+OlE=; b=xQI0orZn3j+CMFqNLJgjv8nyYF
        ta2VeW+qQIfNOxfAZr4avv/leRBZK+ZVYnRZg2BmLiMrnNp3uhZn3q2rs2hS7CkvzGyTPPwtMnYhZ
        XESZTDCv8WINrwYQ0YryYx3Fjnt0o2UPuJ4eVglgjyrXbDZs6xaRkhkVmyiXx2gMvbtQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nCPgQ-002gya-QV; Tue, 25 Jan 2022 18:32:42 +0100
Date:   Tue, 25 Jan 2022 18:32:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, marex@denx.de,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: dsa: microchip: Add property to
 disable reference clock
Message-ID: <YfA0Ov8Skh0e50uA@lunn.ch>
References: <20220125171140.258190-1-robert.hancock@calian.com>
 <20220125171140.258190-3-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125171140.258190-3-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
>  							 "microchip,synclko-125");
> +		dev->synclko_disable = of_property_read_bool(dev->dev->of_node,
> +							     "microchip,synclko-disable");

It seems like microchip,synclko-125 and microchip,synclko-disable are
mutually exclusive? Please add an -EINVAL if both a present.

This should also be mentioned in the binding document.

Thanks
	Andrew
