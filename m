Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51ED2D4E6D
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388134AbgLIXAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:00:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47388 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728357AbgLIXAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:00:35 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kn8R4-00B8DZ-7T; Wed, 09 Dec 2020 23:59:50 +0100
Date:   Wed, 9 Dec 2020 23:59:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201209225950.GC2649111@lunn.ch>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201208112350.kuvlaxqto37igczk@skbuf>
 <87mtyo5n40.fsf@waldekranz.com>
 <20201208163751.4c73gkdmy4byv3rp@skbuf>
 <87k0tr5q98.fsf@waldekranz.com>
 <20201209105326.boulnhj5hoaooppz@skbuf>
 <87eejz5asi.fsf@waldekranz.com>
 <20201209160440.evuv26c7cnkqdb22@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209160440.evuv26c7cnkqdb22@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> so basically my point was that I think you are adding a lot of infra
> in core DSA that only mv88e6xxx will use.

That is true already, since mv88e6xxx is currently the only driver
which supports D in DSA. And it has been Marvell devices which
initially inspired the DSA framework, and has pushed it forward. But I
someday expect another vendors switches will get added which also have
a D in DSA concept, and hopefully we can reuse the code. And is
Marvells implementation of LAGs truly unique? With only two drivers
with WIP code, it is too early to say that.

The important thing for me, is that we don't make the API for other
drivers more complex because if D in DSA, or the maybe odd way Marvell
implements LAGs.

One of the long learnt lessons in kernel development. Put complexity
in the core and make drivers simple. Because hopefully you have the
best developers working on the core and they can deal with the
complexity, and typically you have average developers working on
drivers, and they are sometimes stretched getting drivers correct.

Given your work on ocelot driver, does this core code make the ocelot
implementation more difficult? Or just the same?

       Andrew

