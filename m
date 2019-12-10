Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C17118E33
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 17:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbfLJQw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 11:52:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45170 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727659AbfLJQw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 11:52:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1VJvwcTdx6rbqnyTBIzR8sn+kNVvsWpBVdcEs1WGMtY=; b=FSv8NaiYEMIwplcbEbW5beaHkF
        Vit32YW+OKExPzUFMMy/KCjo46hKrgP6TemI/UGVtSk0f6NaFHe+v0gwDoWuezNyZprn0B4sC0FxG
        GcATgFlYIIZjiaiC87lno8aonTknq4hv0tEdq5epyAX3jf43G2rvIOB15rNCOqTbVodM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieikn-0005Sd-6r; Tue, 10 Dec 2019 17:52:53 +0100
Date:   Tue, 10 Dec 2019 17:52:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 01/14] net: sfp: remove incomplete 100BASE-FX
 and 100BASE-LX support
Message-ID: <20191210165253.GG27714@lunn.ch>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKnt-0004uY-4b@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieKnt-0004uY-4b@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 03:18:29PM +0000, Russell King wrote:
> The 100BASE-FX and 100BASE-LX support assumes a PHY is present; this
> is probably an incorrect assumption. In any case, sfp_parse_support()
> will fail such a module. Let's stop pretending we support these
> modules.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
