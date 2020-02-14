Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D11615F7BF
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbgBNUdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:33:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47170 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730005AbgBNUdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 15:33:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vlat72TK2KwmfqvC4gryMeGdbsVvpdlox6r1LgVzu5I=; b=tzyCMYkbpEpnzfYM/OsJauRje3
        VJhyF5y+5PNkNlrc7UdwojZna3Crbh/EVjts2QTYBD+e+tAcJ7jR+PC4CcB4g3zn3vqr9jOD/EYQD
        VjfSSEwpFeVol5+zTH3uPW8QcqWrZF+r9whQAp7bX0tPpid0JHeTuHjxnQMcpRCrHWhQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j2heA-0001vc-Bq; Fri, 14 Feb 2020 21:33:10 +0100
Date:   Fri, 14 Feb 2020 21:33:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Scott Branden <scott.branden@broadcom.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: phy: restore mdio regs in the iproc mdio driver
Message-ID: <20200214203310.GQ31084@lunn.ch>
References: <20200214194858.8528-1-scott.branden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214194858.8528-1-scott.branden@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 11:48:58AM -0800, Scott Branden wrote:
> From: Arun Parameswaran <arun.parameswaran@broadcom.com>
> 
> The mii management register in iproc mdio block
> does not have a reention register so it is lost on suspend.

reention?

	Andrew
