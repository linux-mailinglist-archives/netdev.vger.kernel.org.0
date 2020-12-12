Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE4B2D858C
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 11:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438538AbgLLKBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 05:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438524AbgLLKAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 05:00:46 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B40C0613D3
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 02:00:06 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1ko1h7-0003jW-0U; Sat, 12 Dec 2020 11:00:05 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1ko1XR-003q4J-4x; Sat, 12 Dec 2020 10:50:05 +0100
Date:   Sat, 12 Dec 2020 10:50:05 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next v2 04/12] gtp: drop unnecessary call to
 skb_dst_drop
Message-ID: <X9SSTS5cPaKXsv08@nataraja>
References: <20201211122612.869225-1-jonas@norrbonn.se>
 <20201211122612.869225-5-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211122612.869225-5-jonas@norrbonn.se>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 01:26:04PM +0100, Jonas Bonn wrote:
> The call to skb_dst_drop() is already done as part of udp_tunnel_xmit().

I must be blind, can you please point out where exactly this happens?

I don't see any skb_dst_drop in udp_tunnel_xmit_skb, and 
in iptunnel_xmit() there's only a skb_dst_set (which doesn't call skb_dst_drop internally)

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
