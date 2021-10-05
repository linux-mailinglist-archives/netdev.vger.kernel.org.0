Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AAB422CAB
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbhJEPkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 11:40:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50224 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235942AbhJEPkA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 11:40:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JuQMYQO4+h/okVhCrhDurSZibfmWUuu8z1lxmxn7P8E=; b=It0/rIROM2WsarGWigIWbWVgLl
        bwEJDbKfugkj90XtWgZvgMo3llnshOacEKGU1a5vV9I2/i/wp9ijiocPq80CTPUy50EGJ3j/wAtNy
        kFKsAk71WT+rZ/DzrYqsy7IqGNStQiGog8evQp2dPyMrctc5Nj40/9lgSTZGxFGsZ530=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXmVw-009iE6-3z; Tue, 05 Oct 2021 17:37:56 +0200
Date:   Tue, 5 Oct 2021 17:37:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: mdio: add mdiobus_modify_changed()
Message-ID: <YVxxVFPWIqHsd7ps@lunn.ch>
References: <YVxwKVZVbmC78fKK@shell.armlinux.org.uk>
 <E1mXmS5-0015rD-Jd@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mXmS5-0015rD-Jd@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 04:33:57PM +0100, Russell King (Oracle) wrote:
> Add mdiobus_modify_changed() helper to reflect the phylib and similar
> equivalents. This will avoid this functionality being open-coded, as
> has already happened in phylink, and it looks like other users will be
> appearing soon.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
