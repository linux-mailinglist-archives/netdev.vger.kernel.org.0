Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BE32D85BD
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 11:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438629AbgLLKKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 05:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgLLJyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 04:54:01 -0500
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 12 Dec 2020 01:50:07 PST
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AD2C0619DB
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 01:50:07 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1ko1XQ-0003Hw-VX; Sat, 12 Dec 2020 10:50:05 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1ko1Nw-003pgp-Td; Sat, 12 Dec 2020 10:40:16 +0100
Date:   Sat, 12 Dec 2020 10:40:16 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next v2 02/12] gtp: include role in link info
Message-ID: <X9SQAHRoFEH7erJx@nataraja>
References: <20201211122612.869225-1-jonas@norrbonn.se>
 <20201211122612.869225-3-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211122612.869225-3-jonas@norrbonn.se>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonas,

On Fri, Dec 11, 2020 at 01:26:02PM +0100, Jonas Bonn wrote:
> Querying link info for the GTP interface doesn't reveal in which "role" the
> device is set to operate.  Include this information in the info query
> result.
> 
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>

Acked-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
