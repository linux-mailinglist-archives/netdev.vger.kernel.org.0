Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FAFCBEF6
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389843AbfJDPTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389643AbfJDPTn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 11:19:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEF5B222C2;
        Fri,  4 Oct 2019 15:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570202382;
        bh=Pq6hbDsQZxwre7MzFt398+CEXy84MFC3LjumafQCV4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gCYK3lgUboe3FuKPEs2rc8lxU0t0/iNDy4oVyz2VV094/Q1KyzMTC1aKQReJ3rB8m
         ipkK78pody2hXsi8W0iGDS8g6l/kRI1MFJHYsNnOEoBvPs+vb+cvTa8PhDQFRfK/jC
         Dm5oZ7phqNtUUhFHwPust2e877Z581WnBLC3lb9c=
Date:   Fri, 4 Oct 2019 17:19:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        GR-Linux-NIC-Dev@marvell.com, linux-kernel@vger.kernel.org,
        Manish Chopra <manishc@marvell.com>
Subject: Re: [PATCH v2 0/17] staging: qlge: Fix rx stall in case of
 allocation failures
Message-ID: <20191004151916.GA776553@kroah.com>
References: <20190927101210.23856-1-bpoirier@suse.com>
 <20191004081931.GA67764@kroah.com>
 <20191004091545.GA29467@f1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004091545.GA29467@f1>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 06:15:45PM +0900, Benjamin Poirier wrote:
> On 2019/10/04 10:19, Greg Kroah-Hartman wrote:
> > On Fri, Sep 27, 2019 at 07:11:54PM +0900, Benjamin Poirier wrote:
> [...]
> > 
> > As this code got moved to staging with the goal to drop it from the
> > tree, why are you working on fixing it up?  Do you want it moved back
> > out of staging into the "real" part of the tree, or are you just fixing
> > things that you find in order to make it cleaner before we delete it?
> > 
> > confused,
> > 
> 
> I expected one of two possible outcomes after moving the qlge driver to
> staging:
> 1) it gets the attention of people looking for something to work on and
> the driver is improved and submitted for normal inclusion in the future
> 2) it doesn't get enough attention and the driver is removed
> 
> I don't plan to do further work on it and I'm admittedly not holding my
> breath for others to rush in but I already had those patches; it wasn't
> a big effort to submit them as a first step towards outcome #1.
> 
> If #2 is a foregone conclusion, then there's little point in applying
> the patches. The only benefit I can think of that if the complete
> removal is reverted in the future, this specific problem will at least
> be fixed.

That makes more sense, I'll go queue these up now, as I don't want to
waste the work you did on this.

thanks,

greg k-h
