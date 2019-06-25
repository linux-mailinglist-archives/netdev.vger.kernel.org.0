Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C1154F09
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 14:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfFYMiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 08:38:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57622 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfFYMiH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 08:38:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pDMZZUAFrDEHV1Do3manOEoBSuloY+uQJvhtbRVK3ns=; b=HPXrVkIrqgdYZaeYeK9ztOG3nT
        lOysTfncJwq/2TAdCoDbMU2BPHC3CYIs2gEjO0mCJemy68YdKdEdXMRsoveMnpxF6DTAh/lLxXxY3
        xV9MA0UbdAgpzED8oXM5cVy+3rqW3eYrxyHXNRULd07QEsiPj/Ib7e9tjtdl0+nav9gQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfki3-0005kc-Ui; Tue, 25 Jun 2019 14:38:03 +0200
Date:   Tue, 25 Jun 2019 14:38:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: further documentation clarifications
Message-ID: <20190625123803.GF17872@lunn.ch>
References: <E1hfi09-0007Zs-Vb@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1hfi09-0007Zs-Vb@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 10:44:33AM +0100, Russell King wrote:
> Clarify the validate() behaviour in a few cases which weren't mentioned
> in the documentation, but which are necessary for users to get the
> correct behaviour.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
