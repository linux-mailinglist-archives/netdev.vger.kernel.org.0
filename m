Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8718A785
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 21:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfHLTv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 15:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbfHLTv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 15:51:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CB2620673;
        Mon, 12 Aug 2019 19:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565639487;
        bh=QrahdIQc+I03Dw/5bxeCV1d8D09SHYkPogK1oMYQeDw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DmCiQ8yfl2GnnVCWs8ZhECsc3sGs73hBOC3ETT0YtzsE2ZPcnMa7mMmYMVtDwrkU6
         HrOm8llvbySV96/6Go73ypVcQBcCXY6T5PZBNaEj2xE7/bJtWSoh+z7se8BcqV7lBh
         xVFbb+WmNJ6hZaD2IPjd/KmQAm6hn6aUGoaBIHck=
Date:   Mon, 12 Aug 2019 21:51:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Nathan Huckleberry <nhuck@google.com>
Subject: Re: [PATCH v3 13/17] mvpp2: no need to check return value of
 debugfs_create functions
Message-ID: <20190812195125.GA22367@kroah.com>
References: <20190810101732.26612-1-gregkh@linuxfoundation.org>
 <20190810101732.26612-14-gregkh@linuxfoundation.org>
 <CAKwvOdnP4OU9g_ebjnT=r1WcGRvsFsgv3NbguhFKOtt8RWNHwA@mail.gmail.com>
 <20190812190128.GB14905@kroah.com>
 <CAKwvOdkWzr5fu3v0KR2XXj0dqCZki=JOoMft9SMjs+XmZ8HpUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkWzr5fu3v0KR2XXj0dqCZki=JOoMft9SMjs+XmZ8HpUg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 12:44:36PM -0700, Nick Desaulniers wrote:
> On Mon, Aug 12, 2019 at 12:01 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Aug 12, 2019 at 10:55:51AM -0700, Nick Desaulniers wrote:
> > > On Sat, Aug 10, 2019 at 3:17 AM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > When calling debugfs functions, there is no need to ever check the
> > > > return value.  The function can work or not, but the code logic should
> > > > never do something different based on this.
> > >
> > > Maybe adding this recommendation to the comment block above the
> > > definition of debugfs_create_dir() in fs/debugfs/inode.c would help
> > > prevent this issue in the future?  What failure means, and how to
> > > proceed can be tricky; more documentation can only help in this
> > > regard.
> >
> > If it was there, would you have read it?  :)
> 
> Absolutely; I went looking for it, which is why I haven't added my
> reviewed by tag, because it's not clear from the existing comment
> block how callers should handle the return value, particularly as you
> describe in this commit's commit message.

Ok, fair enough, I'll update the documentation soon, thanks.

greg k-h
