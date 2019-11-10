Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905DDF6B1E
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 20:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfKJThZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 14:37:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59376 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbfKJThZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 14:37:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RbxbIHKh/rlx5pRlsJFzxvWRaQQulZQM9sGgTuN+1AA=; b=UQeAmUvdFTRzU8GQSi4Q4xGUWu
        DAXIiU11Rmsws+zyKQLKENahXkUnK49aehKB8qZqCs7yDdVqLrrk3JvCCzAwgXib+VSaGcTXKToxC
        +HijEbVBd1UUBZpj6g/ExI4/0hO6EChiNa9kuExWZAZNujQLQUHaY9LU8sYka16xjCTg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTt1T-0007TP-Py; Sun, 10 Nov 2019 20:37:19 +0100
Date:   Sun, 10 Nov 2019 20:37:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 10/17] net: sfp: eliminate mdelay() from PHY
 probe
Message-ID: <20191110193719.GW25889@lunn.ch>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
 <E1iTnrn-0005B1-HR@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iTnrn-0005B1-HR@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 02:06:59PM +0000, Russell King wrote:
> Rather than using mdelay() to wait before probing the PHY (which holds
> several locks, including the rtnl lock), add an extra wait state to
> the state machine to introduce the 50ms delay without holding any
> locks.

Hi Russell

Is this 50ms part of the standard? Or did you find that empirically?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
