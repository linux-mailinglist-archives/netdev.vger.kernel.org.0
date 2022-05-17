Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F6852A711
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344110AbiEQPjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350303AbiEQPjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:39:47 -0400
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28448D5F
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 08:39:46 -0700 (PDT)
Received: (qmail 92337 invoked by uid 89); 17 May 2022 15:39:44 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 17 May 2022 15:39:44 -0000
Date:   Tue, 17 May 2022 08:39:42 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        kernel-team@fb.com
Subject: Re: [PATCH net-next v3 08/10] ptp: ocp: fix PPS source selector
 reporting
Message-ID: <20220517153942.6ze5kj7hoj7z4caq@bsd-mbp.dhcp.thefacebook.com>
References: <20220513225924.1655-1-jonathan.lemon@gmail.com>
 <20220513225924.1655-9-jonathan.lemon@gmail.com>
 <20220516174317.457ec2d1@kernel.org>
 <20220517015428.l6ttuht3ufrl2deb@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517015428.l6ttuht3ufrl2deb@bsd-mbp.dhcp.thefacebook.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 06:54:28PM -0700, Jonathan Lemon wrote:
> On Mon, May 16, 2022 at 05:43:17PM -0700, Jakub Kicinski wrote:
> > On Fri, 13 May 2022 15:59:22 -0700 Jonathan Lemon wrote:
> > > The NTL timecard design has a PPS1 selector which selects the
> > > the PPS source automatically, according to Section 1.9 of the
> > > documentation.
> > > 
> > >   If there is a SMA PPS input detected:
> > >      - send signal to MAC and PPS slave selector.
> > > 
> > >   If there is a MAC PPS input detected:
> > >      - send GNSS1 to the MAC
> > >      - send MAC to the PPS slave
> > > 
> > >   If there is a GNSS1 input detected:
> > >      - send GNSS1 to the MAC
> > >      - send GNSS1 to the PPS slave.MAC
> > > 
> > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > 
> > This one and patch 10 need Fixes tags
> 
> This is for a debugfs entry.  I disagree that a Fixes: tag
> is needed here.
> 
> I'll do it for patch 10 if you insist, but this only happens
> if ptp_clock_register() fails, which not normally seen.

Actually, patch 10 would be:

Fixes: c205d53c4923 ("ptp: ocp: Add firmware capability bits for feature gating")

Which is only in 5.18-rcX at this point.

Do we need a fixes tags for code which hasn't made it into a
full release release yet?
-- 
Jonathan

