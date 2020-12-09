Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A08D2D4431
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732738AbgLIOY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:24:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46474 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732623AbgLIOY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 09:24:27 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kn0NY-00B429-PK; Wed, 09 Dec 2020 15:23:40 +0100
Date:   Wed, 9 Dec 2020 15:23:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201209142340.GE2611606@lunn.ch>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201208112350.kuvlaxqto37igczk@skbuf>
 <87mtyo5n40.fsf@waldekranz.com>
 <20201208163751.4c73gkdmy4byv3rp@skbuf>
 <87k0tr5q98.fsf@waldekranz.com>
 <20201209105326.boulnhj5hoaooppz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209105326.boulnhj5hoaooppz@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 12:53:26PM +0200, Vladimir Oltean wrote:
> On Wed, Dec 09, 2020 at 09:37:39AM +0100, Tobias Waldekranz wrote:
> > I will remove `struct dsa_lag` in v4.
> 
> Ok, thanks.
> It would be nice if you could also make .port_lag_leave return an int code.

I've not looked at the code, but how can it fail, other than something
probably fatal with communication with the hardware. And what should
the rest of the stack do? Recreate what is just destroyed? And does
that really work?

     Andrew
