Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF2319E603
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 17:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgDDPIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 11:08:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48146 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgDDPIr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Apr 2020 11:08:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vp27F8VCbpDyMug+E/DkoFiqJ0iXvSFB3dG9NhdVtJ4=; b=c4fufxCNaxCfxlabO36Hw9VuYU
        Iy7BaNe3r6MvvPPy9rhjqGjZJpP9y0GM9FWH6DappHyVFuggm31hWHqH+YqpzuLjkqxjiY+lCXKRh
        qEj3F2/EgI8g3uP6a3Lm8t5Z4mb59eooVu3rTup4yLq4VA8REUq6oXm6aucvLfNwtXf8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jKkP4-000xRF-B9; Sat, 04 Apr 2020 17:08:10 +0200
Date:   Sat, 4 Apr 2020 17:08:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chuanhong Guo <gch981213@gmail.com>
Cc:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: mt7530: fix null pointer dereferencing in
 port5 setup
Message-ID: <20200404150810.GA161768@lunn.ch>
References: <20200403112830.505720-1-gch981213@gmail.com>
 <20200403180911.Horde.9xqnJvjcRDe-ttshlJbG6WE@www.vdorst.com>
 <CAJsYDVJj1JajVxeGifaOprXYstG-gC_OYwd5LrALUY_4BdtR3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJsYDVJj1JajVxeGifaOprXYstG-gC_OYwd5LrALUY_4BdtR3A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 04, 2020 at 11:19:10AM +0800, Chuanhong Guo wrote:
> Hi!
> 
> On Sat, Apr 4, 2020 at 2:09 AM René van Dorst <opensource@vdorst.com> wrote:
> >
> > Quoting Chuanhong Guo <gch981213@gmail.com>:
> >
> > Hi Chuanhong,
> >
> > > The 2nd gmac of mediatek soc ethernet may not be connected to a PHY
> > > and a phy-handle isn't always available.
> > > Unfortunately, mt7530 dsa driver assumes that the 2nd gmac is always
> > > connected to switch port 5 and setup mt7530 according to phy address
> > > of 2nd gmac node, causing null pointer dereferencing when phy-handle
> > > isn't defined in dts.
> >
> > MT7530 tries to detect if 2nd GMAC is using a phy with phy-address 0 or 4.
> 
> What if the 2nd GMAC connects to an external PHY on address 0 on a
> different mdio-bus?

In general, you using a phy-handle to cover such a situation. If there
is a phy-handle, just use it.

   Andrew
