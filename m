Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C137301DC0
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 18:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbhAXRAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 12:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbhAXRAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 12:00:46 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BAEC061573
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 09:00:05 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1l3ik7-0003Bz-TL; Sun, 24 Jan 2021 18:00:03 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1l3iag-001Nnq-HE; Sun, 24 Jan 2021 17:50:18 +0100
Date:   Sun, 24 Jan 2021 17:50:18 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     netdev@vger.kernel.org, pbshelar@fb.com, kuba@kernel.org,
        pablo@netfilter.org
Subject: Re: [RFC PATCH 12/16] gtp: update rx_length_errors for abnormally
 short packets
Message-ID: <YA2lSlEk15/yDtkM@nataraja>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
 <20210123195916.2765481-13-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210123195916.2765481-13-jonas@norrbonn.se>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 08:59:12PM +0100, Jonas Bonn wrote:
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>

Acked-by: Harald Welte <laforge@gnumonks.org>
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
