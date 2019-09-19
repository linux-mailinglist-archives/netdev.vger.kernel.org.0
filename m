Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D802BB7F3B
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 18:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404408AbfISQfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 12:35:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404404AbfISQe7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 12:34:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4188B218AF;
        Thu, 19 Sep 2019 16:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568910898;
        bh=hdieCwqtpGBeub+UETbr22sG52WgH80MHKyAiqvy6U0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wxeym8nU4VDC43DiPzkGlX/bi97VoQU0o0FF0f6SsffaRDfGvNOt7fR10Kq1vFEeA
         1raGc1t7o8AKh2AbyJ3saKjTCBh1rSP27FAvYDWpO7xp2vxCnQgB7282vm39yYlYkj
         t076+Ger+5VUTVNA6dGNLzdXRUgwG2DlAjspAuk0=
Date:   Thu, 19 Sep 2019 18:34:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthias May <matthias.may@neratec.com>
Cc:     Or Gerlitz <gerlitz.or@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: ELOed stable kernels
Message-ID: <20190919163456.GA4037101@kroah.com>
References: <CAJ3xEMhzGs=8Vuw6aT=wCnQ24Qif89CUDxvbM0jWCgKjNNdbpA@mail.gmail.com>
 <e8cf18ee-d238-8d6f-e25f-9f59b28569d2@neratec.com>
 <20190919144426.GA3998200@kroah.com>
 <5381116f-caae-531d-adf3-1c7e07118b69@neratec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5381116f-caae-531d-adf3-1c7e07118b69@neratec.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 05:00:09PM +0200, Matthias May wrote:
> On 19/09/2019 16:44, Greg Kroah-Hartman wrote:
> > On Thu, Sep 19, 2019 at 04:39:28PM +0200, Matthias May wrote:
> >> On 19/09/2019 16:05, Or Gerlitz wrote:
> >>> Hi Greg,
> >>>
> >>> If this is RTFM could you please point me to the Emm
> >>>
> >>> AFAIR if a stable kernel is not listed at kernel.org than it is EOL by now.
> >>>
> >>> Is this correct?
> >>>
> >>> thanks,
> >>>
> >>> Or.
> >>>
> >>
> >> You can also look at the wikipedia page at
> >> https://en.wikipedia.org/wiki/Linux_kernel#Maintenance_and_long-term_support
> >>
> >> I do the updates of the entries for each release once the release-announcement has been sent to the list.
> >> At least since I'm doing this (last ~5 years), the last release-announcement of a branch always contains a notice that
> >> this release is now EOL.
> >> I reference all these messages for each version.
> > 
> > Very nice, I never noticed that!
> > 
> > Also, you might want to use lore.kernel.org for the email archives,
> > don't know who runs those other sites you link to :)
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> In the past I used to link to https://lkml.org/ .
> However this archive is... unreliable.
> Often the messages would not show up for days, and there are some
> messages which are missing completely.
> 
> Currently I'm using lkml.iu.edu which is run by the Indiana
> University.
> 
> Thank you for pointing to lore.kernel.org Seems better to have a
> reference which is run by kernel.org itself.
> 
> Do you happen to know what the update interval of this archive is?  At
> lkml.iu.edu, when the new version is announced, it often takes quite
> some time until it shows up in the archive.

An email posted to the mailing list should show up in the public side of
lore.kernel.org in the archives within minutes.

Look at this thread as an example, you should see this message there
already :)

thanks,

greg k-h
