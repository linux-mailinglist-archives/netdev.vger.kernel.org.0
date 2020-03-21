Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C36718DC7B
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 01:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgCUA3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 20:29:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48328 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgCUA3p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 20:29:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wDfaUYGhbXR1KHx0zwbGjc+oS5m+S8+yITLhZ8pQ/Tg=; b=WXIC97FkYdRaVEHQ0e2q5MyFsQ
        +AG3cUeWDgSpI+mTB2ZHaQeIHjtz0XTJn5GWdwGZ4+UCO+rd2ZuQ9nQuIkWCRsvQ+5ulpNdM7j8yL
        wAhEjfX0KPczTdSnNBYgNwcvF6HwvX5SRYgm+rCwu/KCTUOJRdhld0m874EueQoJkYEY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jFS1H-0000pX-J9; Sat, 21 Mar 2020 01:29:43 +0100
Date:   Sat, 21 Mar 2020 01:29:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: phy: marvell smi2usb mdio controller
Message-ID: <20200321002943.GC2702@lunn.ch>
References: <20200319230002.GO27807@lunn.ch>
 <C1FQR2V46F7K.1KBCJSQ8V4V2B@wkz-x280>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C1FQR2V46F7K.1KBCJSQ8V4V2B@wkz-x280>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 03:44:34PM +0100, Tobias Waldekranz wrote:
> Hi Andrew,
> 
> > > How about just mdio-mvusb?
> >
> > 
> > Yes, i like that.
> 
> ACK.
> 
> > > On the 88E6390X-DB, I know that there is a chip by the USB port that
> > > is probably either an MCU or a small FPGA. I can have a closer look at
> > > it when I'm at the office tomorrow if you'd like. I also remember
> > > seeing some docs from Marvell which seemed to indicate that they have
> > > a standalone product providing only the USB-to-MDIO functionality.
> >
> > 
> > I would be interested in knowing more.
> 
> It seems like they are using the Cypress FX2 controller
> (CY7C68013). I've used it before on USB device projects. If I remember
> correctly it has an 8052 core, a USB2 controller and some low-speed
> I/O blocks. Couldn't locate the slide deck about a standalone device
> unfortunately.
> 
> > I would fixup the naming and repost. You can put whatever comments you
> > want under the --- marker. So say this driver should be merged via
> > netdev, but you would appreciate reviews of the USB parts from USB
> > maintainers. linux-usb@vger.kernel.org would be the correct list to
> > add.
> 
> Great. Just to make sure I've understood: I'll send v3 with _both_
> netdev and linux-usb in "To:"?

Hi Tobias

I normally use To: for the maintainer i expect to merge the patch,
i.e. DaveM, and Cc: for lists and other maintainers who should review
it.

	Andrew
