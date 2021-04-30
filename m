Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B9E370336
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 23:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhD3VuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 17:50:01 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56210 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229915AbhD3Vt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 17:49:59 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 13ULmu1e024684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Apr 2021 17:48:56 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id E6B1F15C39C4; Fri, 30 Apr 2021 17:48:55 -0400 (EDT)
Date:   Fri, 30 Apr 2021 17:48:55 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
Message-ID: <YIx7R6tmcRRCl/az@mit.edu>
References: <YH2hs6EsPTpDAqXc@mit.edu>
 <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 12:29:52PM +0200, Jiri Kosina wrote:
> On Mon, 19 Apr 2021, Theodore Ts'o wrote:
> 
> > This year, the Maintainers and Kernel Summit is currently planned to
> > be held in Dublin, Ireland, September 27 -- 29th.  
> 
> Given the fact that OSS is being relocated from Dublin to Washington [1], 
> is Kernel Summit following that direction?
> 
> [1] https://www.linuxfoundation.org/en/press-release/the-linux-foundation-announces-open-source-summit-embedded-linux-conference-2021-will-move-from-dublin-ireland-to-seattle-washington/

Apologies for the delay in responding; I wasiting for the LPC to post
its announcement that the LPC will be going 100% virtual:

   https://www.linuxplumbersconf.org/blog/2021/index.php/2021/04/30/linux-plumbers-goes-fully-virtual/

As the LPC planning committee stated,

   "Unfortunately, the safety protocols imposed by event venues in the
   US require masks and social distancing which make it impossible to
   hold the interactive part of Plumbers (the Microconferences)."

The Maintainer's Summit is even more interactive and discussion
focused than most of the Microconferences.  In addition, for the last
few years, the Kernel Summit is run as a track at the LPC.  As a
result, both the Maintainer's and Kernel Summit will be held virtually
this year, using the LPC infrastructure, and will not be colocated
with OSS to Seattle.  We'll make sure the dates (plus some buffer for
travel) won't overlap to avoid creating conflicts for those who are
planning to attend OSS in Seattle.

I know we're all really hungry for some in-person meetups and
discussions, but at least for LPC, Kernel Summit, and Maintainer's
Summit, we're going to have to wait for another year,

Cheers,

					- Ted
