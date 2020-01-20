Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4BAE1433CB
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 23:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgATWQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 17:16:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47370 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgATWQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 17:16:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ebd5xcbG02GFcD3EWBAAN8eWKDv0WV9MKarUBbN0Vek=; b=0UCdt0gFcJQS2h+57aMTKq/kWN
        myEA8ILKPnJM1pocBePZgOlvljLUs3IwPxWleDEcxPDAfYqWbVpC9COe4Lue7r2ZLfblKTgnF9il7
        cFsSaIf6NZ3+R9mbeWsK3RiMMeyvrY2V6XafCJV6QZJrgXHW2n5LzQPbyGzCZ8ws9gRE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1itfLJ-0001cb-Ve; Mon, 20 Jan 2020 23:16:22 +0100
Date:   Mon, 20 Jan 2020 23:16:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mark Einon <mark.einon@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: rename phy_do_ioctl to
 phy_do_ioctl_running
Message-ID: <20200120221621.GD1466@lunn.ch>
References: <a7a6dc1f-b4d4-e36f-7408-31e4715d947f@gmail.com>
 <b2117c4e-c440-83da-7f73-0ddd3e6887fe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2117c4e-c440-83da-7f73-0ddd3e6887fe@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 10:16:07PM +0100, Heiner Kallweit wrote:
> We just added phy_do_ioctl, but it turned out that we need another
> version of this function that doesn't check whether net_device is
> running. So rename phy_do_ioctl to phy_do_ioctl_running.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
