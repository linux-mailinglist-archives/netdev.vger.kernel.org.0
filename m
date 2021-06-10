Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332503A2313
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 06:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhFJEIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 00:08:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55578 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhFJEIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 00:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KjuI8jCqUcyAfx/5RiZL0Drr0Q511dbsI0/UHVUJCP8=; b=rO4X1G0tCX5Sohmhmo7qnuwcHQ
        IQbYkL+40DJiuLX/GRDJgHGB48j2wcUgEdNXw/d/YSzTMVWHKJEn8F7VKZfBMZswvdUAhvvZU/Suj
        EsqUsc3DlYkO/NY03/M4krmZ5RK9hv0cskiEZU7pwSzFJpRpzVrjmztGVXwz03dgsvjI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrBx6-008bPL-He; Thu, 10 Jun 2021 06:05:56 +0200
Date:   Thu, 10 Jun 2021 06:05:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: phy: probe for C45 PHYs that return
 PHY ID of zero in C22 space
Message-ID: <YMGPpIH0OXNS9TuA@lunn.ch>
References: <20210607023645.2958840-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607023645.2958840-1-vee.khee.wong@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 10:36:45AM +0800, Wong Vee Khee wrote:
> PHY devices such as the Marvell Alaska 88E2110 does not return a valid
> PHY ID when probed using Clause-22. The current implementation treats
> PHY ID of zero as a non-error and valid PHY ID, and causing the PHY
> device failed to bind to the Marvell driver.
> 
> For such devices, we do an additional probe in the Clause-45 space,
> if a valid PHY ID is returned, we then proceed to attach the PHY
> device to the matching PHY ID driver.
> 
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
