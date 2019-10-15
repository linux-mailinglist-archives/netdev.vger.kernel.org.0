Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2055DD7768
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 15:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731907AbfJON0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 09:26:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45922 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727745AbfJON0x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 09:26:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JNYMJH0unbZWxrOPpSR7QnBJyoBenqoIe9WKdFH+qGM=; b=4DLHhWlFFkr5SrHTa/OGKHlRKP
        Bgw7wbwUCymt1tSOIFmhAYXsWhJi6LwOyXtWBfkJsuF9XBjeXbDpcen6lP95ypfF5CRGefOfOf1MY
        KoBwopSMKWilxipfUJ9OcXD06CkBVhZnt3b40tACb4ivR37/8Ur0xEZfvppW9DtsnXCc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKMqd-0001b9-0U; Tue, 15 Oct 2019 15:26:47 +0200
Date:   Tue, 15 Oct 2019 15:26:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylink: use more linkmode_*
Message-ID: <20191015132647.GA4780@lunn.ch>
References: <E1iKK4M-0000bC-AE@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iKK4M-0000bC-AE@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 11:28:46AM +0100, Russell King wrote:
> Use more linkmode_* helpers rather than open-coding the bitmap
> operations.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
