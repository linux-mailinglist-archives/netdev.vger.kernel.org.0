Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CCB39A28A
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhFCNzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:55:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43224 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230264AbhFCNzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 09:55:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kKCVCF/9ivwpe/HxHirxpcba696NWI+Aj1jZPtsC+G8=; b=KcU5ynFdYIW5RmG1hYwCzILLge
        7OZgvWxlHnZRM5fTiARojm6yqbVZUDyIc/hXi1v7cMaDZ+iTf9xypI3d1yvf2Wwb2IIq8ZZnOiGXr
        97je/65z60bq4xBie97FRybrkknlkDzy4BLcgbK+1eggneAcl5/IwuseVTlhrp3CYD88=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lonn1-007d0h-QV; Thu, 03 Jun 2021 15:53:39 +0200
Date:   Thu, 3 Jun 2021 15:53:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: marvell: use phy_modify_changed() for
 marvell_set_polarity()
Message-ID: <YLje45N0OKASZ1q+@lunn.ch>
References: <E1lomyE-0003mc-RP@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1lomyE-0003mc-RP@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 02:01:10PM +0100, Russell King wrote:
> Rather than open-coding the phy_modify_changed() sequence, use this
> helper in marvell_set_polarity().
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
