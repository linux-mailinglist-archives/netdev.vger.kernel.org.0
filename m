Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A32A23A712
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 14:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgHCM5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 08:57:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40168 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgHCM5r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 08:57:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k2a2A-0082eD-4S; Mon, 03 Aug 2020 14:57:42 +0200
Date:   Mon, 3 Aug 2020 14:57:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vikas Singh <vikas.singh@puresoftware.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        kuldip dwivedi <kuldip.dwivedi@puresoftware.com>,
        Vikas Singh <vikas.singh@nxp.com>
Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Message-ID: <20200803125742.GK1862409@lunn.ch>
References: <1595938400-13279-3-git-send-email-vikas.singh@puresoftware.com>
 <20200728130001.GB1712415@lunn.ch>
 <CADvVLtXVVfU3-U8DYPtDnvGoEK2TOXhpuE=1vz6nnXaFBA8pNA@mail.gmail.com>
 <20200731153119.GJ1712415@lunn.ch>
 <CADvVLtUrZDGqwEPO_ApCWK1dELkUEjrH47s1CbYEYOH9XgZMRg@mail.gmail.com>
 <20200801094132.GH1551@shell.armlinux.org.uk>
 <20200801151107.GK1712415@lunn.ch>
 <AM6PR04MB3976BB0CAB0B4270FF932F62EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200803090716.GL1551@shell.armlinux.org.uk>
 <AM6PR04MB3976284AEC94129D26300485EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR04MB3976284AEC94129D26300485EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I see you agree that there were and there will be many changes for a while,
> It's not a complaint, I know hot it works, it's just a decision based on
> required effort vs features offered vs user requirements. Lately it's been
> time consuming to try to fix things in this area.

So the conclusion to all this that you are unwilling to use the
correct API for this, which would be phylink, and the SFP code.  So:

NACK

	Andrew
