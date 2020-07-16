Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B0E221AC1
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgGPDSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:18:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37980 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbgGPDSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 23:18:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jvuPy-005LMX-7J; Thu, 16 Jul 2020 05:18:42 +0200
Date:   Thu, 16 Jul 2020 05:18:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>
Subject: Re: [RFC] bonding driver terminology change proposal
Message-ID: <20200716031842.GI1211629@lunn.ch>
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
 <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz>
 <20200713154118.3a1edd66@hermes.lan>
 <20200714002609.GB1140268@lunn.ch>
 <CAKfmpSdD2bupC=N8LnK_Uq7wtv+Ms6=e1kk-veeD24EVkMH7wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfmpSdD2bupC=N8LnK_Uq7wtv+Ms6=e1kk-veeD24EVkMH7wA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 11:04:16PM -0400, Jarod Wilson wrote:
> On Mon, Jul 13, 2020 at 8:26 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > Hi Jarod
> >
> > Do you have this change scripted? Could you apply the script to v5.4
> > and then cherry-pick the 8 bonding fixes that exist in v5.4.51. How
> > many result in conflicts?
> >
> > Could you do the same with v4.19...v4.19.132, which has 20 fixes.
> >
> > This will give us an idea of the maintenance overhead such a change is
> > going to cause, and how good git is at figuring out this sort of
> > thing.
> 
> Okay, I have some fugly bash scripts that use sed to do the majority
> of the work here, save some manual bits done to add duplicate
> interfaces w/new names and some aliases, and everything is compiling
> and functions in a basic smoke test here.
> 
> Summary on the 5.4 git cherry-pick conflict resolution after applying
> changes: not that good. 7 of the 8 bonding fixes in the 5.4 stable
> branch required fixing when straight cherry-picking. Dumping the
> patches, running a sed script over them, and then git am'ing them
> works pretty well though.

Hi Jarad

That is what i was expecting.

I really think that before we consider changes like this, somebody
needs to work on git tooling, so that it knows when mass renames have
happened, and can do the same sort of renames when cherry-picking
across the flag day. Without that, people trying to maintain stable
kernels are going to be very unhappy.

	 Andrew
