Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6241410C8C
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 19:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhISRJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 13:09:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48590 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229809AbhISRJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 13:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OB7JhoOZgaqROs2GvbWn1w077HmRIDNkUuO9hQyMtps=; b=PB4dF6TOzRbkHJvOQbp0NgI6uL
        XF2bURhubyZUyGlX/v8SKWyorphajZhi0+/Omy/0R0cL6CROJQUzMDGZrIP4DWha4s8hVeMK7Qx+4
        df4CO77H1GMcOMtrq78yhWcMvoWy6tuxzXXeSDUTpIoPDPSc9HbMxhwVbyLr2W7PbLaQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mS0Ik-007Mi6-EA; Sun, 19 Sep 2021 19:08:26 +0200
Date:   Sun, 19 Sep 2021 19:08:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 2/3] net: phy: at803x: add resume/suspend
 function to qca83xx phy
Message-ID: <YUduiurvo7Zc7SR8@lunn.ch>
References: <20210919162817.26924-1-ansuelsmth@gmail.com>
 <20210919162817.26924-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919162817.26924-3-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 19, 2021 at 06:28:16PM +0200, Ansuel Smith wrote:
> Add resume/suspend function to qca83xx internal phy.
> We can't use the at803x generic function as the documentation lacks of
> any support for WoL regs.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
