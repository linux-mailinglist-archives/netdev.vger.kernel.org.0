Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B66E2D8571
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 10:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437016AbgLLJz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 04:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390939AbgLLJzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 04:55:14 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EF5C0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 01:54:34 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1ko1Nk-0002qQ-VT; Sat, 12 Dec 2020 10:40:05 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1ko1Lz-003pcb-Oi; Sat, 12 Dec 2020 10:38:15 +0100
Date:   Sat, 12 Dec 2020 10:38:15 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next v2 01/12] gtp: set initial MTU
Message-ID: <X9SPh3YUauvPD0ey@nataraja>
References: <20201211122612.869225-1-jonas@norrbonn.se>
 <20201211122612.869225-2-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211122612.869225-2-jonas@norrbonn.se>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 01:26:01PM +0100, Jonas Bonn wrote:
> The GTP link is brought up with a default MTU of zero.  This can lead to
> some rather unexpected behaviour for users who are more accustomed to
> interfaces coming online with reasonable defaults.
> 
> This patch sets an initial MTU for the GTP link of 1500 less worst-case
> tunnel overhead.

Thanks, LGTM.  I would probably have gone to a #define or a 'const' variable,
but I guess compilers should be smart enough to figure out that this is
static at compile time even the way you wrote it.

Acked-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
