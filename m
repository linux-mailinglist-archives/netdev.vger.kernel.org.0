Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D93A284854
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 10:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgJFIUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 04:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgJFIUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 04:20:14 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F7EC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 01:20:10 -0700 (PDT)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1kPiCa-0006hT-4j; Tue, 06 Oct 2020 10:20:04 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1kPiAa-001eMb-Cp; Tue, 06 Oct 2020 10:18:00 +0200
Date:   Tue, 6 Oct 2020 10:18:00 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     Fabian Frederick <fabf@skynet.be>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH 5/9 net-next] gtp: use dev_sw_netstats_rx_add()
Message-ID: <20201006081800.GV3994@nataraja>
References: <20201005203546.55332-1-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005203546.55332-1-fabf@skynet.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 10:35:46PM +0200, Fabian Frederick wrote:
> use new helper for netstats settings

Acked-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
