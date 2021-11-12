Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC29344EC40
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 18:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbhKLRzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 12:55:20 -0500
Received: from smtprelay0125.hostedemail.com ([216.40.44.125]:32784 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235347AbhKLRzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 12:55:19 -0500
Received: from omf15.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id F2134181AC9CC;
        Fri, 12 Nov 2021 17:52:24 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf15.hostedemail.com (Postfix) with ESMTPA id 1BF63200026E;
        Fri, 12 Nov 2021 17:52:23 +0000 (UTC)
Message-ID: <61c7ecf2ba3db984fbbced5b6e34b2de71c63e8d.camel@perches.com>
Subject: Re: [PATCH v3 3/3] MAINTAINERS: Mark VMware mailing list entries as
 email aliases
From:   Joe Perches <joe@perches.com>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date:   Fri, 12 Nov 2021 09:52:23 -0800
In-Reply-To: <20211112174458.GB11364@csail.mit.edu>
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
         <163657493334.84207.11063282485812745766.stgit@srivatsa-dev>
         <20211110173935.45a9f495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <d7f3fec79287a149d6edc828583a771c84646b42.camel@perches.com>
         <20211111055554.4f257fd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20211112174458.GB11364@csail.mit.edu>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1BF63200026E
X-Spam-Status: No, score=-4.89
X-Stat-Signature: wboa1t8w68sc39be84n6n9azc1k9cb7u
X-Rspamd-Server: rspamout05
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19yNH6uWKgJVIoR2k3jeozYNIUPs0DZ52M=
X-HE-Tag: 1636739543-245155
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-11-12 at 09:44 -0800, Srivatsa S. Bhat wrote:
> On Thu, Nov 11, 2021 at 05:55:54AM -0800, Jakub Kicinski wrote:
> > On Wed, 10 Nov 2021 21:19:53 -0800 Joe Perches wrote:
> > > On Wed, 2021-11-10 at 17:39 -0800, Jakub Kicinski wrote:
> > > > On Wed, 10 Nov 2021 12:09:06 -0800 Srivatsa S. Bhat wrote:  
> > > > >  DRM DRIVER FOR VMWARE VIRTUAL GPU
> > > > > -M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
> > > > >  M:	Zack Rusin <zackr@vmware.com>
> > > > > +R:	VMware Graphics Reviewers <linux-graphics-maintainer@vmware.com>
> > > > >  L:	dri-devel@lists.freedesktop.org
> > > > >  S:	Supported
> > > > >  T:	git git://anongit.freedesktop.org/drm/drm-misc  
> > > > 
> > > > It'd be preferable for these corporate entries to be marked or
> > > > otherwise distinguishable so that we can ignore them when we try 
> > > > to purge MAINTAINERS from developers who stopped participating.
> > > > 
> > > > These addresses will never show up in a commit tag which is normally
> > > > sign of inactivity.  
> > > 
> > > Funny.
> > > 
> > > The link below is from over 5 years ago.
> > > 
> > > https://lore.kernel.org/lkml/1472081625.3746.217.camel@perches.com/
> > > 
> > > Almost all of those entries are still in MAINTAINERS.
> > > 
> > > I think the concept of purging is a non-issue.
> > 
> > I cleaned networking in January and intend to do it again in 2 months.
> > See:
[]
> > 8b0f64b113d6 MAINTAINERS: remove names from mailing list maintainers

I think the last removal of descriptive naming from exploder style
reviewers or mailing lists is misguided/not good.

I suggest this change be reverted.

> I'm assuming the purging is not totally automated, is it? As long as
> the entries are informative to a human reader, it should be possible
> to skip the relevant ones when purging inactive entries.

true

> I believe this patch makes the situation better than it is currently
> (at least for the human reader), by marking lists without public
> read-access in a format that is more appropriate. In the future, we
> could perhaps improve on it to ease automation too, but for now I
> think it is worthwhile to merge this change (unless there are strong
> objections or better alternatives that everyone agrees on).

I think this VMware suggested patch to MAINTAINERS is good and
improves readers ability to know how any suggested patch is going
to be reviewed by a company..


