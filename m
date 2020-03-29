Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D660E196EA1
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 19:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgC2RTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 13:19:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37580 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbgC2RTn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 13:19:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9ZqkCBo5hn1RfCB3iihruPy2OqQzCB6GDT7OykXnpXw=; b=a+CLRd3TNY3gMJpRfOkUx4/lxZ
        vudCaJPavatkIsqg4B7q53A4cUM04qY/QC8OLIIrcy99dxo6+v9GetwunZgEKN1nsNqTeT6gPgT3Z
        /kKhsRNg5q0FcRM6moNrZ3q4SoZLhyFRd18cnXFnkoGHYv3haIlRbzv/LMieHnJzdspA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jIbaz-00057d-EK; Sun, 29 Mar 2020 19:19:37 +0200
Date:   Sun, 29 Mar 2020 19:19:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] net: phylink: change
 phylink_mii_c22_pcs_set_advertisement() prototype
Message-ID: <20200329171937.GC31812@lunn.ch>
References: <20200329160036.GB25745@shell.armlinux.org.uk>
 <E1jIaN1-0007la-Tf@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jIaN1-0007la-Tf@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 05:01:07PM +0100, Russell King wrote:
> Change phylink_mii_c22_pcs_set_advertisement() to take only the PHY
> interface and advertisement mask, rather than the full phylink state.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
