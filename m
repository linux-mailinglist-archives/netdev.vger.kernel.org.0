Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CDE224C35
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 17:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgGRPFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 11:05:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42694 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgGRPFR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jul 2020 11:05:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jwoOo-005m4F-Gv; Sat, 18 Jul 2020 17:05:14 +0200
Date:   Sat, 18 Jul 2020 17:05:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Healy <cphealy@gmail.com>
Cc:     Marek Behun <marek.behun@nic.cz>, netdev <netdev@vger.kernel.org>
Subject: Re: bug: net: dsa: mv88e6xxx: serdes Unable to communicate on fiber
 with vf610-zii-dev-rev-c
Message-ID: <20200718150514.GC1375379@lunn.ch>
References: <CAFXsbZodM0W87aH=qeZCRDSwyNOAXwF=aO8zf1UpkhwNkSAczA@mail.gmail.com>
 <20200718164239.40ded692@nic.cz>
 <CAFXsbZoMcOQTY8HE+E359jT6Vsod3LiovTODpjndHKzhTBZcTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFXsbZoMcOQTY8HE+E359jT6Vsod3LiovTODpjndHKzhTBZcTg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 07:49:26AM -0700, Chris Healy wrote:
> On Sat, Jul 18, 2020 at 7:42 AM Marek Behun <marek.behun@nic.cz> wrote:
> >
> > Hmm, nothing sticks out in the register dump.
> >
> > I encountered a similar problem 2 years ago on Topaz SERDES port when
> > the cmode was set to 2500BASE-X but the speed register was set to speed
> > incompatible with 2500BASE-X (I don't remember what, though). This
> > issue was solved by a patch I sent to netdev.
> >
> > Are you sure that your board isn't broken? Maybe the SerDes traces on
> > RX path are damaged...
> 
> In my case, both the SERDES and the MAC are inside the switch so I
> don't think it's likely that the SERDES traces are broken in there.
> If you are referring to the traces between the SERDES and the fiber
> module, that doesn't feel likely either as the SERDES appears to be
> reporting successfully received frames:
> 
> >From "ethtool -S" after sending 6 packets to the unit:
> serdes_rx_pkts: 6
> serdes_rx_bytes: 384
> serdes_rx_pkts_error: 0
> 
> If the traces were broken between the fiber module and the SERDES, I
> should not see these counters incrementing.

Plus it is reproducible on multiple boards, of different designs.

This is somehow specific to the 6390X ports 9 and 10.

     Andrew
