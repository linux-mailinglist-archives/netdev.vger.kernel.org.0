Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87E445DCB3
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348693AbhKYOw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:52:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52090 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349735AbhKYOun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 09:50:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2hMaCRMxVgM4TVI32WQvFsJU4187k7V84pmrkSmEJTI=; b=jY4QbYrhzSWswJ7lDvlmVBQyEA
        kiQcBkcxsGpQYTBdv6mnmgAKMT893mctRejpIWXGkZteoNoRbxuvWgVSSwZ1zcBiVhes+gPWiy1fW
        DPQkyZfEIsnyy2WaSxJuwiWxPTm6RRj5ZtQJ9HZQFgXyYAg03NXNNpt47SvNwR1kYrAQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqG1m-00EcKC-D0; Thu, 25 Nov 2021 15:47:10 +0100
Date:   Thu, 25 Nov 2021 15:47:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     linux-kernel@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        andrew@aj.id.au, joel@jms.id.au, kuba@kernel.org,
        davem@davemloft.net, linux@armlinux.org.uk, hkallweit1@gmail.com,
        BMC-SW@aspeedtech.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] mdio: aspeed: Fix "Link is Down" issue
Message-ID: <YZ+h7qXTLvRRXpj0@lunn.ch>
References: <20211125024432.15809-1-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125024432.15809-1-dylan_hung@aspeedtech.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 10:44:32AM +0800, Dylan Hung wrote:
> The issue happened randomly in runtime.  The message "Link is Down" is
> popped but soon it recovered to "Link is Up".
> 
> The "Link is Down" results from the incorrect read data for reading the
> PHY register via MDIO bus.  The correct sequence for reading the data
> shall be:
> 1. fire the command
> 2. wait for command done (this step was missing)
> 3. wait for data idle
> 4. read data from data register
> 
> Fixes: f160e99462c6 ("net: phy: Add mdio-aspeed")
> Cc: stable@vger.kernel.org
> Reviewed-by: Joel Stanley <joel@jms.id.au>
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
