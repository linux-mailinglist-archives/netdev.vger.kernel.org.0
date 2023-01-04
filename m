Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B59265E95A
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 11:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbjAEKxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 05:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbjAEKxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 05:53:32 -0500
X-Greylist: delayed 1396 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 Jan 2023 02:53:30 PST
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B384750051
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 02:53:30 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1pDNVh-00CMzf-RG; Thu, 05 Jan 2023 11:30:09 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.96)
        (envelope-from <laforge@gnumonks.org>)
        id 1pDBd2-00FDH1-35;
        Wed, 04 Jan 2023 22:48:56 +0100
Date:   Wed, 4 Jan 2023 22:48:56 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, khc@pm.waw.pl
Subject: Re: [PATCH] net: hdlc: Increase maximum HDLC MTU
Message-ID: <Y7X0SAF461yyFAgs@nataraja>
References: <20230104125724.3587015-1-laforge@osmocom.org>
 <Y7W84D+J4iNx30zx@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7W84D+J4iNx30zx@lunn.ch>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Andrew,

On Wed, Jan 04, 2023 at 06:52:32PM +0100, Andrew Lunn wrote:
 
> This change does appear to change dev->mtu, not just dev->max_mtu?
> So i'm not sure the commit message is correct?

Thanks for your feedback, which seems correct. 

We've been using this patch in production for more than a year, but our
use cases are all using larger MTU so this might have been unnoticed.

I'll investigate and likely we have to introduce a new HDLC_DEFAULT_MTU
of 1500 to achieve backwards compatibility.

-- 
- Harald Welte <laforge@gnumonks.org>          https://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
