Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4682D30FB
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 18:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbgLHR1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 12:27:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44792 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729086AbgLHR1M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 12:27:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kmgkq-00At0C-48; Tue, 08 Dec 2020 18:26:24 +0100
Date:   Tue, 8 Dec 2020 18:26:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201208172624.GC2475207@lunn.ch>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201208112350.kuvlaxqto37igczk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208112350.kuvlaxqto37igczk@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>     There are two points to be made:
>     - Recently we have seen people with non-DSA (pure switchdev) hardware
>       being compelled to write DSA drivers, because they noticed that a
>       large part of the middle layer had already been written, and it
>       presents an API with a lot of syntactic sugar. Maybe there is a
>       larger issue here in that the switchdev offloading APIs are fairly
>       bulky and repetitive, but that does not mean that we should be
>       encouraging the attitude "come to DSA, we have cookies".
>       https://lwn.net/ml/linux-kernel/20201125232459.378-1-lukma@denx.de/

We often see developers stumbling around in the dark, not knowing the
subsystems and how best to solve a problem. So i would not read too
much into that particular email discussion. It was just another
example of we the maintainers, trying to get an understanding of the
hardware and help point a developer in the right direction. We don't
consider DSA the solution for all switch problems.

We do however have a growing number of pure switchdev drivers now, so
it might be time to take a look and see what is common, and pull some
code out of the drivers and into a library. This is a common pattern
you see all over the kernel. One driver often leads the way with a new
subsystem, but it is not until you have a few different drivers using
the subsystem do you have a real feel for what is common and can be
pulled out of the drivers and into a framework.

       Andrew
