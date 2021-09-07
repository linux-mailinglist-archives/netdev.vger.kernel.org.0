Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A98402A16
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 15:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344866AbhIGNsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 09:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbhIGNsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 09:48:02 -0400
X-Greylist: delayed 1008 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Sep 2021 06:46:56 PDT
Received: from ganesha.gnumonks.org (unknown [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02ACEC061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 06:46:55 -0700 (PDT)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1mNbAq-0006jq-2t; Tue, 07 Sep 2021 15:30:04 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1mNb1V-0051Mn-Cx; Tue, 07 Sep 2021 15:20:25 +0200
Date:   Tue, 7 Sep 2021 15:20:25 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     David Miller <davem@davemloft.net>
Cc:     osmith@sysmocom.de, netdev@vger.kernel.org
Subject: Re: Missing include include acpi.h causes build failures
Message-ID: <YTdnGfVFIjuHtiAm@nataraja>
References: <aa6271d7-7574-041d-ab35-ea98a8a6df79@sysmocom.de>
 <20210906.130817.2086973831700819915.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906.130817.2086973831700819915.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

thanks a lot for that, I can confirm the CI builds are executing again since
last night.

Regards,
	Harald

On Mon, Sep 06, 2021 at 01:08:17PM +0100, David Miller wrote:
> From: Oliver Smith <osmith@sysmocom.de>
> Date: Mon, 6 Sep 2021 11:04:40 +0200
> 
> > Hello linux-netdev ML,
> > 
> > can somebody please cherry pick the following patch from
> > torvalds/linux.git to net-next.git (or rebase on that patch? not sure
> > about the usual workflow for net-next):
> > 
> > 	ea7b4244 ("x86/setup: Explicitly include acpi.h")
> > 
> > Since the 1st of September, this missing include causes the Osmocom CI
> > job to fail, which runs osmo-ggsn against the GTP tunnel driver in
> > net-next.git (to catch regressions in both kernel and Osmocom code).
> 
> I ff'd net-next ad this should be fixed now.
> 

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
