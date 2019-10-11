Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E897D4666
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 19:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbfJKRPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 13:15:36 -0400
Received: from fieldses.org ([173.255.197.46]:59098 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbfJKRPg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 13:15:36 -0400
Received: by fieldses.org (Postfix, from userid 2815)
        id DF9B51C95; Fri, 11 Oct 2019 13:15:35 -0400 (EDT)
Date:   Fri, 11 Oct 2019 13:15:35 -0400
From:   "J . Bruce Fields" <bfields@fieldses.org>
To:     NeilBrown <neilb@suse.de>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Neil F Brown <nfbrown@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Vasiliy Averin <vvs@virtuozzo.com>
Subject: Re: [PATCH] sunrpc: fix crash when cache_head become valid before
 update
Message-ID: <20191011171535.GG19318@fieldses.org>
References: <20191001080359.6034-1-ptikhomirov@virtuozzo.com>
 <3e455bb4-2a03-551e-6efb-1d41b5258327@virtuozzo.com>
 <20191008202332.GB9151@fieldses.org>
 <87wodergus.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wodergus.fsf@notabene.neil.brown.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 09:51:23AM +1100, NeilBrown wrote:
> On Tue, Oct 08 2019,  J . Bruce Fields  wrote:
> 
> > On Tue, Oct 08, 2019 at 10:02:53AM +0000, Pavel Tikhomirov wrote:
> >> Add Neil to CC, sorry, had lost it somehow...
> >
> > Always happy when we can fix a bug by deleting code, and your
> > explanation makes sense to me, but I'll give Neil a chance to look it
> > over if he wants.
> 
> Yes, it makes sense to me.  But I'm not sure that is worth much.  The
> original fix got a Reviewed-by from me but was wrong.
>  Acked-by: NeilBrown <neilb@suse.de>
> 
> 'Acked' is weaker than 'reviewed' - isn't it? :-)

Hah--"Self-deprecatingly-reviewed-by:"?

Anyway, applied thanks.

--b.
