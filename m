Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A942D5296F8
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiEQByc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 21:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbiEQByb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:54:31 -0400
Received: from smtp2.emailarray.com (smtp.emailarray.com [69.28.212.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2AA3E5D5
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 18:54:30 -0700 (PDT)
Received: (qmail 57403 invoked by uid 89); 17 May 2022 01:54:29 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 17 May 2022 01:54:29 -0000
Date:   Mon, 16 May 2022 18:54:28 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        kernel-team@fb.com
Subject: Re: [PATCH net-next v3 08/10] ptp: ocp: fix PPS source selector
 reporting
Message-ID: <20220517015428.l6ttuht3ufrl2deb@bsd-mbp.dhcp.thefacebook.com>
References: <20220513225924.1655-1-jonathan.lemon@gmail.com>
 <20220513225924.1655-9-jonathan.lemon@gmail.com>
 <20220516174317.457ec2d1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516174317.457ec2d1@kernel.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 05:43:17PM -0700, Jakub Kicinski wrote:
> On Fri, 13 May 2022 15:59:22 -0700 Jonathan Lemon wrote:
> > The NTL timecard design has a PPS1 selector which selects the
> > the PPS source automatically, according to Section 1.9 of the
> > documentation.
> > 
> >   If there is a SMA PPS input detected:
> >      - send signal to MAC and PPS slave selector.
> > 
> >   If there is a MAC PPS input detected:
> >      - send GNSS1 to the MAC
> >      - send MAC to the PPS slave
> > 
> >   If there is a GNSS1 input detected:
> >      - send GNSS1 to the MAC
> >      - send GNSS1 to the PPS slave.MAC
> > 
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 
> This one and patch 10 need Fixes tags

This is for a debugfs entry.  I disagree that a Fixes: tag
is needed here.

I'll do it for patch 10 if you insist, but this only happens
if ptp_clock_register() fails, which not normally seen.
-- 
Jonathan
