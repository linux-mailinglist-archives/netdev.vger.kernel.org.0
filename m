Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7A66517E
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 07:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbfGKFkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 01:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727898AbfGKFkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 01:40:08 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8093220838;
        Thu, 11 Jul 2019 05:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562823607;
        bh=zvuDGhOQ3cg7jcGK8yft/tWYQtU9QCFMuievf8sS0Lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tTgtdkClydOYcqmy3q/DgbDsZr7eimMgrWjMOm+CFxe7TnzsWd99fP1aPHuXMBqgs
         p8KGViDX4Ecr0jo1dNXOZupa4/Wsi8b0UbCW1zm60b+4ebLDSmW1tVha3oWMXn7v9t
         28Yuxykh+iK5jn36PX7XT19Eo5baZq/71UIYg9C4=
Date:   Thu, 11 Jul 2019 08:40:03 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Doug Ledford <dledford@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20190711054003.GA23598@mtr-leonro.mtl.com>
References: <20190709135636.4d36e19f@canb.auug.org.au>
 <20190709064346.GF7034@mtr-leonro.mtl.com>
 <20190710175212.GM2887@mellanox.com>
 <20190711115054.7d7f468c@canb.auug.org.au>
 <20190711015854.GC22409@mellanox.com>
 <20190711131344.452fc064@canb.auug.org.au>
 <20190711131603.6b11b831@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711131603.6b11b831@canb.auug.org.au>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 01:16:03PM +1000, Stephen Rothwell wrote:
> Hi all,
>
> On Thu, 11 Jul 2019 13:13:44 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Thu, 11 Jul 2019 02:26:27 +0000 Jason Gunthorpe <jgg@mellanox.com> wrote:
> > >
> > > On Thu, Jul 11, 2019 at 11:50:54AM +1000, Stephen Rothwell wrote:
> > >
> > > > So today this failed to build after I merged the rdma tree (previously
> > > > it didn;t until after the net-next tree was merged (I assume a
> > > > dependency changed).  It failed because in_dev_for_each_ifa_rcu (and
> > > > in_dev_for_each_ifa_rtnl) is only defined in a commit in the net-next
> > > > tree :-(
> > >
> > > ? I'm confused..
> > >
> > > rdma.git builds fine stand alone (I hope!)
> >
> > I have "Fixup to build SIW issue" from Leon (which switches to using
> > in_dev_for_each_ifa_rcu) included in the rmda tree merge commit because
> > without that the rdma tree would not build for me.  Are you saying that
> > I don't need that at all, now?
>
> Actually , I get it now, "Fixup to build SIW issue" is really just a
> fixup for the net-next and rdma trees merge ... OK, I will fix that up
> tomorrow.  Sorry for my confusion.

Yes, it was for build only.

>
> --
> Cheers,
> Stephen Rothwell


