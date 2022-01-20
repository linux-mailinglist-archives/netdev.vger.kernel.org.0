Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D473494478
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345304AbiATAZE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Jan 2022 19:25:04 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:46737 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345289AbiATAZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:25:03 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3DAB620003;
        Thu, 20 Jan 2022 00:25:00 +0000 (UTC)
Date:   Thu, 20 Jan 2022 01:24:59 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v3 00/41] IEEE 802.15.4 scan support
Message-ID: <20220120012459.1e3ca85e@xps13>
In-Reply-To: <CAB_54W4jAZqSJ-7VuT0uOukHEnxAYpaGqZ6S6n9tYst26F+VWQ@mail.gmail.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
        <CAB_54W4q9a1MRdfK6yJHMRt+Zfapn0ggie9RbbUYi4=Biefz_A@mail.gmail.com>
        <20220118114023.2d2c0207@xps13>
        <CAB_54W4jAZqSJ-7VuT0uOukHEnxAYpaGqZ6S6n9tYst26F+VWQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Tue, 18 Jan 2022 18:12:49 -0500:

> Hi,
> 
> On Tue, 18 Jan 2022 at 05:40, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >  
> > > > So far the only technical point that is missing in this series is the
> > > > possibility to grab a reference over the module driving the net device
> > > > in order to prevent module unloading during a scan or when the beacons
> > > > work is ongoing.  
> >
> > Do you have any advises regarding this issue? That is the only
> > technical point that is left unaddressed IMHO.
> >  
> 
> module_get()/module_put() or I don't see where the problem here is.
> You can avoid module unloading with it. Which module is the problem
> here?

I'll give it another try, maybe when I first tried that I was missing a
few mental peaces and did not understood the puzzle correctly.

> > > > Finally, this series is a deep reshuffle of David Girault's original
> > > > work, hence the fact that he is almost systematically credited, either
> > > > by being the only author when I created the patches based on his changes
> > > > with almost no modification, or with a Co-developped-by tag whenever the
> > > > final code base is significantly different than his first proposal while
> > > > still being greatly inspired from it.
> > > >  
> > >
> > > can you please split this patch series, what I see is now:
> > >
> > > 1. cleanup patches
> > > 2. sync tx handling for mlme commands
> > > 3. scan support  
> >
> > Works for me. I just wanted to give the big picture but I'll split the
> > series.
> >  
> 
> maybe also put some "symbol duration" series into it if it's getting
> too large? It is difficult to review 40 patches... in one step.

Yep, I truly understand (and now 50+).

> 
> > Also sorry for forgetting the 'wpan-next' subject prefix.
> >  
> 
> no problem.
> 
> I really appreciate your work and your willingness to work on all
> outstanding issues. I am really happy to see something that we can use
> for mlme-commands and to separate it from the hotpath transmission...
> It is good to see architecture for that which I think goes in the
> right direction.

That is very stirring to read :)

Thanks,
Miquèl
