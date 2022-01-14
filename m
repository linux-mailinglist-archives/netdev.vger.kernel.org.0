Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6A748E83D
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 11:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240400AbiANKTO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Jan 2022 05:19:14 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:34899 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237487AbiANKTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 05:19:13 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 7B53B20000A;
        Fri, 14 Jan 2022 10:18:59 +0000 (UTC)
Date:   Fri, 14 Jan 2022 11:18:58 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Subject: Re: [wpan-next v2 06/27] net: mac802154: Set the symbol duration
 automatically
Message-ID: <20220114111858.117b3c9a@xps13>
In-Reply-To: <CAB_54W79S1gtNJtq+wzCig82KqauMXXOtdZ1VaNH97xXQEmUCQ@mail.gmail.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
        <20220112173312.764660-7-miquel.raynal@bootlin.com>
        <CAB_54W79S1gtNJtq+wzCig82KqauMXXOtdZ1VaNH97xXQEmUCQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Thu, 13 Jan 2022 18:36:15 -0500:

> Hi,
> 
> On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> ...
> > +               case IEEE802154_4030KHZ_MEAN_PRF:
> > +                       duration = 3974;
> > +                       break;
> > +               case IEEE802154_62890KHZ_MEAN_PRF:
> > +                       duration = 1018;
> > +                       break;
> > +               default:
> > +                       break;
> > +               }
> > +               break;
> > +       default:
> > +               break;
> > +       }
> > +
> > +set_duration:
> > +       if (!duration)
> > +               pr_debug("Unknown PHY symbol duration, the driver should be fixed\n");  
> 
> Why should the driver be fixed? It's more this table which needs to be fixed?

Right.

> 
> > +       else
> > +               phy->symbol_duration = duration;  
> 
> Can you also set the lifs/sifs period after the duration is known?

Done.

Thanks,
Miquèl
