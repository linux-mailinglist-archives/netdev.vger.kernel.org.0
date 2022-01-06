Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBD64861EC
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbiAFJOL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Jan 2022 04:14:11 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37289 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237223AbiAFJOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 04:14:06 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 08820E0016;
        Thu,  6 Jan 2022 09:14:02 +0000 (UTC)
Date:   Thu, 6 Jan 2022 10:14:01 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
Message-ID: <20220106101401.4ada5b80@xps13>
In-Reply-To: <57f0e761-db5a-86f6-ab27-c0943d3e7805@datenfreihafen.org>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
        <20211222155743.256280-13-miquel.raynal@bootlin.com>
        <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
        <Ycx0mwQcFsmVqWVH@ni.fr.eu.org>
        <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
        <CAB_54W6gHE1S9Q+-SVbrnAWPxBxnvf54XVTCmddtj8g-bZzMRA@mail.gmail.com>
        <20220104191802.2323e44a@xps13>
        <CAB_54W5quZz8rVrbdx+cotTRZZpJ4ouRDZkxeW6S1L775Si=cw@mail.gmail.com>
        <20220105215551.1693eba4@xps13>
        <CAB_54W7zDXfybMZZo8QPwRCxX8-BbkQdznwEkLEWeW+E3k2dNg@mail.gmail.com>
        <57f0e761-db5a-86f6-ab27-c0943d3e7805@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Thu, 6 Jan 2022 09:44:50 +0100:

> Hello.
> 
> On 06.01.22 01:38, Alexander Aring wrote:
> > Hi,
> > 
> > 
> > On Wed, 5 Jan 2022 at 15:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > ...  
> 
> >> Also, just for the record,
> >> - should I keep copying the netdev list for v2?  
> > 
> > yes, why not.  
> 
> >> - should I monitor if net-next is open before sending or do you have
> >>    your own set of rules?
> >>  
> > 
> > I need to admit, Stefan is the "Thanks, applied." hero here and he
> > should answer this question.  
> 
> No need to monitor if net-next is open for these patches (just don't add a net-next patch subject prefix as this would confuse Jakub and Dave. wpan-next would be more appropriate).

Sure! It might be worth updating [1] to tell people about this prefix?
(only the userspace tools prefix is mentioned).

[1] https://linux-wpan.org/contributing.html 

> I am following this patchset and the review from Alex. I have not done a full in depth review myself yet, its on my list.

Yeah sure, no problem.

> Basically keep working with Alex and use the wpan-next prefix and I will pick up the patches to my wpan-next tree and sent a pull to net-next when we are happy with it. Does that sound good to you?

Yes of course, that's ideal.

Thanks,
Miquèl
