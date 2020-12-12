Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263182D8636
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 12:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437239AbgLLL0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 06:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403956AbgLLL0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 06:26:44 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4813CC0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 03:26:04 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1ko32I-0007pi-Sq; Sat, 12 Dec 2020 12:26:02 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1ko32A-003sWh-89; Sat, 12 Dec 2020 12:25:54 +0100
Date:   Sat, 12 Dec 2020 12:25:54 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next v2 11/12] gtp: netlink update for ipv6
Message-ID: <X9SowlkbZtXiaEVX@nataraja>
References: <20201211122612.869225-1-jonas@norrbonn.se>
 <20201211122612.869225-12-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211122612.869225-12-jonas@norrbonn.se>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 01:26:11PM +0100, Jonas Bonn wrote:
> This patch adds the netlink changes required to support IPv6.

See my related comment to the other IPv6 patch in this series.

It is not legal to assume that v4/v6 are an either-or decision,
but it can be either v4-only, v6-only or v4 and v6 in the same PDP context.

For the "peer" (outer) address, I think it is correct to assume only either v4 or v6.

But for the inner "ms" address, it is not.

Regards,
	Harald

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
