Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FB5301D89
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 17:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbhAXQku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 11:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbhAXQkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 11:40:49 -0500
Received: from ganesha.gnumonks.org (unknown [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93E1C061573
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 08:40:08 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1l3iQm-0002H1-5I; Sun, 24 Jan 2021 17:40:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1l3iL3-001NWN-7T; Sun, 24 Jan 2021 17:34:09 +0100
Date:   Sun, 24 Jan 2021 17:34:09 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     netdev@vger.kernel.org, pbshelar@fb.com, kuba@kernel.org,
        pablo@netfilter.org
Subject: Re: [RFC PATCH 01/16] Revert "GTP: add support for flow based
 tunneling API"
Message-ID: <YA2hgTtU3O8Elj0U@nataraja>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
 <20210123195916.2765481-2-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210123195916.2765481-2-jonas@norrbonn.se>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jonas,

thanks for your effort in breaking this down into more digestible chunks
for further review.

> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>

Acked-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
