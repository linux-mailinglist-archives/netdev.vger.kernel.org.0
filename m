Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09BE3ECD7D
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 06:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhHPEL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 00:11:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51276 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229550AbhHPEL0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 00:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lnFC0mcTrtftt9YUv/VHE4sLvFQC1IIrfw3meEGyAAU=; b=zQ2NTxhnkMfWvqO3fSzkZiT/hY
        DGU+uN71Xlqihw5v+XJ3VS7F9Uk+btqKVn1Q6WDYl1x1AjxalZ5+orSd6i0RuesLU7p3/NN49rjGp
        9aSyPa3dPS+WRa5/yLuWt8GZvqf7aNHX55deRj4Q182+g+ZxIND+tuRbI8bqI4hMgbC0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mFTxP-000KlX-Qm; Mon, 16 Aug 2021 06:10:39 +0200
Date:   Mon, 16 Aug 2021 06:10:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Song, Yoong Siang" <yoong.siang.song@intel.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Message-ID: <YRnlP/9oimKRbn0q@lunn.ch>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
 <20210814172656.GA22278@shell.armlinux.org.uk>
 <YRgFxzIB3v8wS4tF@lunn.ch>
 <PH0PR11MB4950EAF1FC749EAAE3FDFCB7D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB4950EAF1FC749EAAE3FDFCB7D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 03:19:34AM +0000, Song, Yoong Siang wrote:
> > > How does this work if the driver has no interrupt support? What is the
> > > hardware setup this has been tested with?
> > 
> > Hi Russell
> > 
> > We already know from previous patches that the Intel hardware is broken,
> > and does not actually deliver the interrupt which caused the wake up. So i
> > assume this just continues on with the same broken hardware, but they have
> > a different PHY connected.
> 
> Hi Russell & Andrew,
> 
> This is tested on Intel Elkhart Lake (EHL) board. We are using polling mode.
> Both WoL interrupt and link change interrupt are the same pin which is
> routed to PMC. PMC will wake up the system when there is WoL event.

Is the PMC also an interrupt controller?

   Andrew
