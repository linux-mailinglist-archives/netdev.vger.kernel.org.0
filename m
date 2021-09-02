Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C80B3FF1E1
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 18:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346470AbhIBQ4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 12:56:52 -0400
Received: from smtp6.emailarray.com ([65.39.216.46]:38203 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbhIBQ4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 12:56:51 -0400
Received: (qmail 50556 invoked by uid 89); 2 Sep 2021 16:55:51 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 2 Sep 2021 16:55:51 -0000
Date:   Thu, 2 Sep 2021 09:55:50 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: Re: [PATCH net-next 06/11] ptp: ocp: Add SMA selector and controls
Message-ID: <20210902165550.eplp6wkdcio5pocg@bsd-mbp.dhcp.thefacebook.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
 <20210830235236.309993-7-jonathan.lemon@gmail.com>
 <20210901165612.77cac1b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901165612.77cac1b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 04:56:12PM -0700, Jakub Kicinski wrote:
> On Mon, 30 Aug 2021 16:52:31 -0700 Jonathan Lemon wrote:
> >  static int
> > -ptp_ocp_clock_val_from_name(const char *name)
> > +select_val_from_name(struct ocp_selector *tbl, const char *name)
> 
> Why not prefix the helpers with ptp_ocp_ ? Makes code easier to follow
> IMHO.

Will fix.  Was adding these for use by the DEVICE_ATTR functions, and
those don't have prefixes, so I neglected to namespace them.
-- 
Jonathan
