Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F052F094C
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 20:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbhAJTJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 14:09:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60188 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbhAJTJH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 14:09:07 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyg4Z-00HMVM-Sw; Sun, 10 Jan 2021 20:08:19 +0100
Date:   Sun, 10 Jan 2021 20:08:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH RFC net-next  00/19] net: mvpp2: Add TX Flow
 Control support
Message-ID: <X/tQo0uNFY63ra5R@lunn.ch>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <20210110181727.GK1551@shell.armlinux.org.uk>
 <CO6PR18MB38737A567187B2BBAFACFF6AB0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB38737A567187B2BBAFACFF6AB0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 06:55:11PM +0000, Stefan Chulski wrote:
> > > not connected to the GOP flow control generation mechanism.
> > > To solve this issue Armada has firmware running on CM3 CPU dedectated
> > > for Flow Control support. Firmware monitors Packet Processor resources
> > > and asserts XON/XOFF by writing to Ports Control 0 Register.
> > 
> > What is the minimum firmware version that supports this?
> > 
> 
> Support were added to firmware about two years ago. 
> All releases from 18.09 should has it.

Can you query the firmware and ask its version? We should keep all
this code disabled if the firmware it too old.

     Andrew
