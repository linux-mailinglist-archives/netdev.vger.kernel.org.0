Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3634C422CB5
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbhJEPlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 11:41:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50240 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236188AbhJEPlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 11:41:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yq+9Vm6c17B0PRNNUkOtPc7VAtSE/B8wb+3JXYHf19M=; b=WxQ+evl5IQ4S+6FGlYKW4umUSk
        x6cUPgrUgZOo6+QuPdFqIKrHTQtSOIZhN+O0dKuKA132+vyqX6Gq62wec+QXC+t57ALNdWv/RpuFY
        1Lz1cKKKmTCNGSKb+TcYdEtb7b9DZB0CvklKRbHp342olo9Y+Sk0O0E11dWIfN2WV6Nw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXmXH-009iFq-R3; Tue, 05 Oct 2021 17:39:19 +0200
Date:   Tue, 5 Oct 2021 17:39:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: phylink: use mdiobus_modify_changed()
 helper
Message-ID: <YVxxp9h65QB36blZ@lunn.ch>
References: <YVxwKVZVbmC78fKK@shell.armlinux.org.uk>
 <E1mXmSA-0015rK-Pj@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mXmSA-0015rK-Pj@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 04:34:02PM +0100, Russell King (Oracle) wrote:
> Use the mdiobus_modify_changed() helper in the C22 PCS advertisement
> helper.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
