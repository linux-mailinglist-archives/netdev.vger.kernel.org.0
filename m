Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C6647BC41
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 09:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbhLUI5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 03:57:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34024 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235914AbhLUI5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 03:57:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B905B811F0;
        Tue, 21 Dec 2021 08:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E1AC36AE7;
        Tue, 21 Dec 2021 08:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640077032;
        bh=3bs1IZW8nA0iroD5e7XrA2+YPfmQbVPvT8XPNH+IrL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oTX0Tcbi86PWCOn9mxT6p+H4Yon/pvXWyy+8fDz7B4DOIyjpL7CPdhWh8OqPFn50u
         YGC/T6FXwLN3vzrmf5maxVOPxFXJ+8aS8LplmlGYZXSPsPxV3/4YePiNvGYq5kcckv
         TodDl1GZyWh2W9Of/Vl+S5jzj++9rnciWtqnjonM=
Date:   Tue, 21 Dec 2021 09:57:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Ximing Chen <mike.ximing.chen@intel.com>
Cc:     linux-kernel@vger.kernel.org, arnd@arndb.de,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Message-ID: <YcGW3lm4UBbDHURW@kroah.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-2-mike.ximing.chen@intel.com>
 <YcF+QIHKgNLJOxUh@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcF+QIHKgNLJOxUh@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 08:12:00AM +0100, Greg KH wrote:
> On Tue, Dec 21, 2021 at 12:50:31AM -0600, Mike Ximing Chen wrote:
> > +/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
> 
> So you did not touch this at all in 2021?  And it had a copyrightable
> changed added to it for every year, inclusive, from 2016-2020?
> 
> Please run this past your lawyers on how to do this properly.

Ah, this was a "throw it over the fence at the community to handle for
me before I go on vacation" type of posting, based on your autoresponse
email that happened when I sent this.

That too isn't the most kind thing, would you want to be the reviewer of
this if it were sent to you?  Please take some time and start doing
patch reviews for the char/misc drivers on the mailing list before
submitting any more new code.

Also, this patch series goes agains the internal rules that I know your
company has, why is that?  Those rules are there for a good reason, and
by ignoring them, it's going to make it much harder to get patches to be
reviewed.

best of luck!

greg k-h
