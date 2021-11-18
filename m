Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A66F45606B
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbhKRQa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:30:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40854 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233281AbhKRQa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 11:30:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=xtXMSWEpUbs9yiKVnomyvPIC2jWVFnNQu0gcB1e/U6Y=; b=uh
        TFD9PxYPpJkTXuqg4cVgp9KN6UewO4nXOk8Ebu//N01KTOCcnEx1RkYDg4JTCAO+Tq6Xf7uZxuOd5
        alqkvsJJo7Y8tX0OPoBe0m1MecxVOvybLaeSI+UNI9seEEqfrCf96rh4JvmGWTIe8sXFt5zhYWnff
        9F92oFl8HrvVN8g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mnkFx-00E084-7n; Thu, 18 Nov 2021 17:27:25 +0100
Date:   Thu, 18 Nov 2021 17:27:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 6/8] net: phy: marvell10g: Use generic macro for
 supported interfaces
Message-ID: <YZZ+7RG6PpD8O9Ch@lunn.ch>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-7-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211117225050.18395-7-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 11:50:48PM +0100, Marek Behún wrote:
> Now that phy.h defines macro DECLARE_PHY_INTERFACE_MASK(), use it
> instead of DECLARE_BITMAP().
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
