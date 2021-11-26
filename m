Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB3D45F07A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 16:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354188AbhKZPVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 10:21:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53618 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377808AbhKZPTH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 10:19:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pX3CHWxASRKir7D2xp6R/D78E0zl6LNBN3bJv8RgPu0=; b=eae/qNXBRa2EbyS+2qDymWAZGb
        dkc9lJdYSKumdJkxr7QecDQB8Yexi85B7bPHLjJr0+FLNrphme+m3lpDkBaBZQ7kJ3jOR6/O3vCXG
        DI2ZxJ+BSr8NfHsa/pTv3X/ZaBvVkLxo6kEuOeHSBVzQVgsP8BsEoa3SgJCYE/wqg+ck=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqcx0-00Ehjp-QP; Fri, 26 Nov 2021 16:15:46 +0100
Date:   Fri, 26 Nov 2021 16:15:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: micrel: Add config_init for LAN8814
Message-ID: <YaD6Iita1y6m1Zya@lunn.ch>
References: <20211126103833.3609945-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126103833.3609945-1-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - swap the MDI-X A,B transmit so that there will not be any link flip-flaps
>   when the PHY gets a link.

Isn't this a board issue, rather than generic? Or does the datasheet
have the pins labelled wrongly and all boards following the datasheet
are wrong?

	Andrew
