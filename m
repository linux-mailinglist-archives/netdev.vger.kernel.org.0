Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E761C12B5
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 15:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgEANQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 09:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728586AbgEANQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 09:16:25 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B18C061A0C;
        Fri,  1 May 2020 06:16:25 -0700 (PDT)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1jUVWc-0006qD-Ve; Fri, 01 May 2020 15:16:19 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.93)
        (envelope-from <laforge@gnumonks.org>)
        id 1jUVWR-005pUN-AV; Fri, 01 May 2020 15:16:07 +0200
Date:   Fri, 1 May 2020 15:16:07 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Subject: Re: ABI breakage in sctp_event_subscribe (was [PATCH net-next 0/4]
 sctp: add some missing events from rfc5061)
Message-ID: <20200501131607.GU1294372@nataraja>
References: <cover.1570534014.git.lucien.xin@gmail.com>
 <20200419102536.GA4127396@nataraja>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419102536.GA4127396@nataraja>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux SCTP developers,

On Sun, Apr 19, 2020 at 12:25:36PM +0200, Harald Welte wrote:
> this patchset (merged back in Q4/2019) has broken ABI compatibility, more
> or less exactly as it was discussed/predicted in Message-Id
> <20190206201430.18830-1-julien@arista.com>
> "[PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length"
> on this very list in February 2019.

does the lack of any follow-up so far seems to indicate nobody considers
this a problem?  Even without any feedback from the Linux kernel
developers, I would be curious to hear What do other SCTP users say.

So far I have a somewhat difficult time understanding that I would be
the only one worried about ABI breakage?  If that's the case, I guess
it would be best to get the word out that people using Linux SCTP should
better make sure to not use binary packages but always build on the
system they run it on, to ensure kernel headers are identical.

I don't mean this in any cynical way.  The point is either the ABI is
stable and people can move binaries between different OS/kernel
versions, or they cannot.  So far the general assumption on Linux is you
can, but with SCTP you can not, so this needs to be clarified.

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
