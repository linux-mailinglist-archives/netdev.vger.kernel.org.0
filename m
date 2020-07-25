Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E6F22D903
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 19:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgGYRll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 13:41:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55374 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726904AbgGYRll (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 13:41:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jzOAs-006pfz-Kt; Sat, 25 Jul 2020 19:41:30 +0200
Date:   Sat, 25 Jul 2020 19:41:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] net: dsa: microchip: delete dead code
Message-ID: <20200725174130.GL1472201@lunn.ch>
References: <20200721083300.GA12970@laureti-dev>
 <20200722143953.GA1339445@lunn.ch>
 <20200723042431.GA14746@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723042431.GA14746@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 06:24:31AM +0200, Helmut Grohne wrote:
> Hi Andrew,
> 
> On Wed, Jul 22, 2020 at 04:39:53PM +0200, Andrew Lunn wrote:
> > This patch probably is correct. But it is not obviously correct,
> > because there are so many changes at once. Please could you break it
> > up.
> 
> >From my pov, it is less a question of whether it is correct, but whether
> it goes into the desired direction. There are a few comments in the
> driver that point to pending work. It might as well be that I'm removing
> the infrastructure that other patches are meant to build upon.

Hi Helmut

There was a small burst of patches from Microchip in this month. But
apart from that, you need to go a long way back.

I say clean it up now. The code is in the git history, so it is easy
to get back if needed.

   Andrew
