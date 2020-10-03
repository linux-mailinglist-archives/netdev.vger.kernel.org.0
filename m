Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78396282324
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgJCJc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725681AbgJCJc0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 05:32:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 688492067C;
        Sat,  3 Oct 2020 09:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601717544;
        bh=xU/4mSQjKnUMoLFgi6LJYOmtfQOkTKaMQDIAmid+Ko8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ItGdtEzDTFAaLFlAE3CdSqpEKn4R9J0w2TqimOhLyvNpxUOY5fSD2TNxWi37HOJvu
         lDkvKibokV1r0HHb4s+a/1U83R54zusIGzcngvN4pm7ak4qW2pJaMQr86DJoG99DvZ
         Bmf5c8btZw4500eq1ccFObN+x96PzQzOk2/pRfPc=
Date:   Sat, 3 Oct 2020 11:32:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Dave Ertman <david.m.ertman@intel.com>, linux-rdma@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/6] Ancillary bus implementation and SOF multi-client
 support
Message-ID: <20201003093220.GA127713@kroah.com>
References: <20201001050534.890666-1-david.m.ertman@intel.com>
 <20201003090452.GF3094@unreal>
 <20201003091036.GA118157@kroah.com>
 <20201003092407.GG3094@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003092407.GG3094@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 03, 2020 at 12:24:07PM +0300, Leon Romanovsky wrote:
> On Sat, Oct 03, 2020 at 11:10:36AM +0200, Greg KH wrote:
> > On Sat, Oct 03, 2020 at 12:04:52PM +0300, Leon Romanovsky wrote:
> > > Hi Dave,
> > >
> > > I don't know why did you send this series separately to every mailing
> > > list, but it is not correct thing to do.
> > >
> > > RDMA ML and discussion:
> > > https://lore.kernel.org/linux-rdma/20201001050534.890666-1-david.m.ertman@intel.com/T/#t
> > > Netdev ML (completely separated):
> > > https://lore.kernel.org/netdev/20201001050851.890722-1-david.m.ertman@intel.com/
> > > Alsa ML (separated too):
> > > https://lore.kernel.org/alsa-devel/20200930225051.889607-1-david.m.ertman@intel.com/
> >
> > Seems like the goal was to spread it around to different places so that
> > no one could strongly object or review it :(
> 
> It took me time to realize why I was alone expressing my thoughts :).
> 
> BTW, I'm looking on ALSA thread and happy to see that people didn't like
> "ancillary" name. It is far from intuitive name for any non-English speaker.

It's not intuitive for a native-english speaker either :)

greg k-h
