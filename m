Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2459C2D85B6
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 11:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407169AbgLLJyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 04:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407165AbgLLJyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 04:54:01 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7E7C0619DC
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 01:50:07 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1ko1XQ-0003Ht-Qj; Sat, 12 Dec 2020 10:50:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1ko1Oo-003ph5-04; Sat, 12 Dec 2020 10:41:10 +0100
Date:   Sat, 12 Dec 2020 10:41:09 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next v2 03/12] gtp: really check namespaces before
 xmit
Message-ID: <X9SQNRNxcUT1Q8ib@nataraja>
References: <20201211122612.869225-1-jonas@norrbonn.se>
 <20201211122612.869225-4-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211122612.869225-4-jonas@norrbonn.se>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 01:26:03PM +0100, Jonas Bonn wrote:
> Blindly assuming that packet transmission crosses namespaces results in
> skb marks being lost in the single namespace case.
> 
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>

Acked-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
