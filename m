Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96F72FA7B9
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407236AbhARRmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:42:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46382 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406948AbhARRlt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 12:41:49 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l1YWT-001Jap-KO; Mon, 18 Jan 2021 18:41:01 +0100
Date:   Mon, 18 Jan 2021 18:41:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Chris Healy <cphealy@gmail.com>, Marek Behun <marek.behun@nic.cz>,
        netdev <netdev@vger.kernel.org>
Subject: Re: bug: net: dsa: mv88e6xxx: serdes Unable to communicate on fiber
 with vf610-zii-dev-rev-c
Message-ID: <YAXILTCNepv8eZnj@lunn.ch>
References: <CAFXsbZodM0W87aH=qeZCRDSwyNOAXwF=aO8zf1UpkhwNkSAczA@mail.gmail.com>
 <20200718164239.40ded692@nic.cz>
 <CAFXsbZoMcOQTY8HE+E359jT6Vsod3LiovTODpjndHKzhTBZcTg@mail.gmail.com>
 <20200718150514.GC1375379@lunn.ch>
 <20200718172244.59576938@nic.cz>
 <CAFXsbZrHRexg5zAsR1cah4p8HAZVc3tjKdMGKWO6Ha4jXux3QA@mail.gmail.com>
 <8735yykv88.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735yykv88.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 06:31:19PM +0100, Tobias Waldekranz wrote:
> On Sun, Jul 19, 2020 at 14:43, Chris Healy <cphealy@gmail.com> wrote:
> > On Sat, Jul 18, 2020 at 8:22 AM Marek Behun <marek.behun@nic.cz> wrote:
> >>
> >> On Sat, 18 Jul 2020 17:05:14 +0200
> >> Andrew Lunn <andrew@lunn.ch> wrote:
> >>
> >> > > If the traces were broken between the fiber module and the SERDES, I
> >> > > should not see these counters incrementing.
> >> >
> >> > Plus it is reproducible on multiple boards, of different designs.
> >> >
> >> > This is somehow specific to the 6390X ports 9 and 10.
> >> >
> >> >      Andrew
> >>
> >> Hmm.
> >>
> >> What about the errata setup?
> >> It says:
> >> /* The 6390 copper ports have an errata which require poking magic
> >>  * values into undocumented hidden registers and then performing a
> >>  * software reset.
> >>  */
> >> But then the port_hidden_write function is called for every port in the
> >> function mv88e6390_setup_errata, not just for copper ports. Maybe Chris
> >> should try to not write this hidden register for SerDes ports.
> >
> > I just disabled the mv88e6390_setup_errata all together and this did
> > not result in any different behaviour on this broken fiber port.
> 
> Hi Chris,
> 
> Did you manage to track this down?
> 
> I am seeing the exact same issue. I have tried both a 1000base-x SFP and
> a copper 1000base-T and get the same result on both - transmit is fine
> but rx only works up to the SERDES, no rx MAC counters are moving.

Hi Tobias

We never tracked this down. I spent many hours bashing my head against
this. I could not bisect it, which did not help.

FYI: Chris has moved onto a new job, and is unlikely to be involved
with Marvell switches any more.

     Andrew
