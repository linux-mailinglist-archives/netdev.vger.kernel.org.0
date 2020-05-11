Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75231CDD50
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 16:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbgEKOdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 10:33:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53732 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728683AbgEKOdq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 10:33:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Mwae2KvTbiEeDM+Ihkjwa5GcbZ/X5g2Mvj9LCuhgqwI=; b=E8s9KGLEyptNB/d8E5IWsylI7y
        PANj3gT/wxQj90IqmEmto+J2PAHmgVWdSU96Ejm6mfPoj2T1bTLYysFRJ/6JGWmWWkxzgMyd5ss9Y
        qi+CD92i3+DxWyAvR4bxcwQ28ylkMTFYWK6JbWQShVKTHCaeZ89ZlvXztsdIPwTNzA0Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jY9Uv-001raJ-MF; Mon, 11 May 2020 16:33:37 +0200
Date:   Mon, 11 May 2020 16:33:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: signal quality and cable diagnostic
Message-ID: <20200511143337.GC413878@lunn.ch>
References: <20200511141310.GA2543@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511141310.GA2543@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 04:13:10PM +0200, Oleksij Rempel wrote:
> Hi Andrew,
> 
> First of all, great work! As your cable diagnostic patches are in
> net-next now and can be used as base for the follow-up discussion.
> 
> Do you already have ethtool patches somewhere? :=) Can you please give a
> link for testing?

Hi Oleksij

It was mentioned in the cover note

https://github.com/lunn/ethtool/tree/feature/cable-test-v4

> 
> I continue to work on TJA11xx PHY and need to export some additional
> cable diagnostic/link stability information: Signal Quality Index (SQI).

Is this something you want to continually make available, or just as
part of cable diagnostics. Additional nested attributes can be added
to the cable test results structure, and the user space code just
dumps whatever it finds. So it should be easy to have something like:

Pair A: OK
Pair A: Signal Quality Index class D

Are the classes part of the Open Alliance specification? Ideally we
want to report something standardized, not something proprietary to
NXP.

	Andrew
