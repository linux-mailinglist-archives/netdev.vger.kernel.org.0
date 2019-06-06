Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF2723741B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 14:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbfFFM2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 08:28:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32832 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbfFFM2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 08:28:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6YZ1MeiYHjFJerny/uXVRiChqyXVuu8b4YDLfGqoIns=; b=elV5S4NZyMCanfhYWfco1bi3Zm
        TfjJP0rlqePX5Ydo3Ihc/u8S+ntELmmB5nVi0q88+t5rTBIjPMIacPAvx2Aw307GbiPdacVjSCv5f
        +kxrWCPf1VRuHvdOMsXqu/DDfczdncEuzBTdA7Yz53aYzz9bobGasJGoIwjnYLx5ROiE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYrUs-0005YO-IY; Thu, 06 Jun 2019 14:27:58 +0200
Date:   Thu, 6 Jun 2019 14:27:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>, hancock@sedsystems.ca,
        netdev@vger.kernel.org, f.fainelli@gmail.com
Subject: Re: [PATCH net-next] net: phy: Add detection of 1000BaseX link mode
 support
Message-ID: <20190606122758.GB20899@lunn.ch>
References: <1559686501-25739-1-git-send-email-hancock@sedsystems.ca>
 <20190605.184254.1047432851767426057.davem@davemloft.net>
 <20b0f19b-131d-2db0-dfa6-dac7e5b8d422@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20b0f19b-131d-2db0-dfa6-dac7e5b8d422@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 08:05:31AM +0200, Heiner Kallweit wrote:
> On 06.06.2019 03:42, David Miller wrote:
> > From: Robert Hancock <hancock@sedsystems.ca>
> > Date: Tue,  4 Jun 2019 16:15:01 -0600
> > 
> >> Add 1000BaseX to the link modes which are detected based on the
> >> MII_ESTATUS register as per 802.3 Clause 22. This allows PHYs which
> >> support 1000BaseX to work properly with drivers using phylink.
> >>
> >> Previously 1000BaseX support was not detected, and if that was the only
> >> mode the PHY indicated support for, phylink would refuse to attach it
> >> due to the list of supported modes being empty.
> >>
> >> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> > 
> > Andrew/Florian/Heiner, is there a reason we left out the handling of these
> > ESTATUS bits?
> > 
> > 
> I can only guess here:
> In the beginning phylib took care of BaseT modes only. Once drivers for
> BaseX modes were added the authors dealt with it in the drivers directly
> instead of extending the core.

That seems like a reasonable guess. Also, SFPs are also reasonably new
in this field, so using a PHY as a media converter like this was not
needed before.

       Andrew
