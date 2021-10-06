Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871DD4248A7
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 23:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239643AbhJFVQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 17:16:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52928 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239591AbhJFVQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 17:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lUg5dpLOUlv/OvKUAwhlirfWiCVHrd4Gl9U9MrqYD28=; b=5dlI2rvMEKqp24ABqkDyZo0uLl
        w5u5YtmkKrFlzwWX/YSaZy6GMidt0MaMDcuzAn0l5x+WyB0KaV0iZLAbN9naJKyq0XqmUVUCRkI6s
        GeAOxjobnCjWARhO5ofRea/PHg7OkCXiZ3wZ8SmzXl5EbfjIIJEqfVIKym/fS0dLWvE8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYEFL-009sS3-Me; Wed, 06 Oct 2021 23:14:39 +0200
Date:   Wed, 6 Oct 2021 23:14:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/2] net: phylink: use
 mdiobus_modify_changed() helper
Message-ID: <YV4RvzF+aJwzxFGK@lunn.ch>
References: <YV2UIa2eU+UjmWaE@shell.armlinux.org.uk>
 <E1mY5tN-001SlT-DB@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mY5tN-001SlT-DB@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 01:19:25PM +0100, Russell King (Oracle) wrote:
> Use the mdiobus_modify_changed() helper in the C22 PCS advertisement
> helper.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
