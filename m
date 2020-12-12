Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F3A2D862A
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 12:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405665AbgLLLKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 06:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgLLLKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 06:10:45 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C9DC0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 03:10:05 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1ko2mp-0006xt-Uv; Sat, 12 Dec 2020 12:10:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1ko2iV-003rBG-OC; Sat, 12 Dec 2020 12:05:35 +0100
Date:   Sat, 12 Dec 2020 12:05:35 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Pravin Shelar <pravin.ovn@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next v2 10/12] gtp: add IPv6 support
Message-ID: <X9Sj/15ebQ9GrKoH@nataraja>
References: <20201211122612.869225-1-jonas@norrbonn.se>
 <20201211122612.869225-11-jonas@norrbonn.se>
 <CAOrHB_B3oDcQz97409ZG8zmu+yX4yTWdhHRN8g+Kp6GD+Ov4cg@mail.gmail.com>
 <a52c6960-cf72-9c7a-6c44-cf03711d65f6@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a52c6960-cf72-9c7a-6c44-cf03711d65f6@norrbonn.se>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonas,

On Sat, Dec 12, 2020 at 08:05:40AM +0100, Jonas Bonn wrote:
> Yes, you're probably right.  Given that IPv6 isn't really optional in
> contexts where this driver is relevant, [...]

I strongly contest this statement. GTP is used in a lot of legacy contexts
without any IPv6 requirements whatsoever.  _particularly_ so on the outer/
transport level, where even GSMA IR.34 in still states:

> The IPX Provider's and Service Provider's networks must support IPv4
> addressing and routing.  IPv6 addressing and routing is recommended.

So there is (still) no requirement for IPv6 on the transport level
between cellular operators.
 
The fact that this gtp module has existed until today with pure IPv4
support has something to say about that.

I'm of course all in support of finally getting IPv6 support merged (via
your patches!) - but I see absolutely no reason why a GTP kernel module
would have a mandatory dependency on IPv6.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
