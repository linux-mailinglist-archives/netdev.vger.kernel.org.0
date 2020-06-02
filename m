Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD881EB711
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 10:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgFBIIc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Jun 2020 04:08:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:60930 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgFBIIa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 04:08:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 30EA1AEEE;
        Tue,  2 Jun 2020 08:08:30 +0000 (UTC)
Date:   Tue, 2 Jun 2020 10:08:26 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-Id: <20200602100826.72465faaab5f013e08851dfe@suse.de>
In-Reply-To: <20200529163340.GI869823@lunn.ch>
References: <20200528130738.GT1551@shell.armlinux.org.uk>
        <20200528151733.f1bc2fcdcb312b19b2919be9@suse.de>
        <20200528135608.GU1551@shell.armlinux.org.uk>
        <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
        <20200528144805.GW1551@shell.armlinux.org.uk>
        <20200528204312.df9089425162a22e89669cf1@suse.de>
        <20200528220420.GY1551@shell.armlinux.org.uk>
        <20200529130539.3fe944fed7228e2b061a1e46@suse.de>
        <20200529145928.GF869823@lunn.ch>
        <20200529175225.a3be1b4faaa0408e165435ad@suse.de>
        <20200529163340.GI869823@lunn.ch>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 18:33:40 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > > By propagated, you mean if the external link is down, the link between
> > > the switch and node 1 will also be forced down, at the SERDES level?
> > 
> > yes
> > 
> > > And if external ports are down, the nodes cannot talk to each other?
> > 
> > correct
> > 
> > > External link down causes the whole in box network to fall apart? That
> > > seems a rather odd design.
> > 
> > as I'm not an expert in ceph, I can't judge. But I'll bring it up.
> 
> I guess for a single use appliance this is O.K. But it makes the
> hardware unusable as a general purpose server.
> 
> Is there a variant of the hardware to be used as a general purpose
> server, rather than as a Ceph appliance? If so, does it share the same
> DT files?

I don't know of any, but it would just need some way to change the switch
configuration. So it's independent from linux running on the nodes.

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 36809 (AG Nürnberg)
Geschäftsführer: Felix Imendörffer
