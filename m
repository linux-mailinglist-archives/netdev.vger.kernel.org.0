Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9832E3E93C8
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 16:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhHKOkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 10:40:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45200 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232468AbhHKOkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 10:40:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=H04mt228TLJQ4ASnmfrV9b3FewFE2jggDXP/9KA7mws=; b=1uGQs0cUovIQKREwKGfpuLaxcZ
        aw64nyjB5W/+PwFJp96X+mCJJC1otAg9qnAuh6ahcQdJivhtDF5uG5L4/YrqguoD2XUCBw6ydfaZk
        U+S0oYE+G3+Jd0+O9PAonTbleZDozuDQFVuCbnBjZ0onDIFxGe+vUC9cK3H9GVW1h6Hw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDpOT-00H8B3-W4; Wed, 11 Aug 2021 16:39:45 +0200
Date:   Wed, 11 Aug 2021 16:39:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Ivan T. Ivanov" <iivanov@suse.de>
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: leds: Trigger leds only if PHY speed is known
Message-ID: <YRPhMen7jZZFe7pc@lunn.ch>
References: <20210716141142.12710-1-iivanov@suse.de>
 <YPGjnvB92ajEBKGJ@lunn.ch>
 <162646032060.16633.4902744414139431224@localhost>
 <20210719152942.GQ22278@shell.armlinux.org.uk>
 <162737250593.8289.392757192031571742@localhost>
 <162806599009.5748.14837844278631256325@localhost>
 <20210809141633.GT22278@shell.armlinux.org.uk>
 <162867546407.30043.9226294532918992883@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162867546407.30043.9226294532918992883@localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think will be easier if we protect public phylib API internally with
> lock, otherwise it is easy to make mistakes, obviously. But still this
> will not protect users which directly dereference phy_device members.

Anybody directly dereference phy_device members, rather than going
through the API, is directly responsible for any breakage they
cause. This is not a supported use case.

       Andrew
