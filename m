Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A834F9F2F0
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 21:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbfH0TIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 15:08:00 -0400
Received: from smtprelay0152.hostedemail.com ([216.40.44.152]:36939 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730379AbfH0TIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 15:08:00 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 06D84440B;
        Tue, 27 Aug 2019 19:07:59 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3870:3871:3872:3873:3874:4250:4321:5007:7514:7903:10004:10400:10450:10455:10848:11232:11658:11914:12043:12295:12297:12555:12740:12760:12895:13069:13141:13230:13311:13357:13439:14181:14659:14721:14819:19904:19999:21080:21451:21611:21627:30054:30055:30056:30070:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:27,LUA_SUMMARY:none
X-HE-Tag: knot38_7fb82438d284f
X-Filterd-Recvd-Size: 2809
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Tue, 27 Aug 2019 19:07:57 +0000 (UTC)
Message-ID: <b1ea77866e8736fa691cf4658a87ca2c1bf642d6.camel@perches.com>
Subject: Re: [PATCH] net: intel: Cleanup e1000 - add space between }}
From:   Joe Perches <joe@perches.com>
To:     jeffrey.t.kirsher@intel.com, Forrest Fleming <ffleming@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 27 Aug 2019 12:07:56 -0700
In-Reply-To: <c40b4043424055fc4dae97771bb46c8ab15c6230.camel@intel.com>
References: <20190823191421.3318-1-ffleming@gmail.com>
         <c2279a78904b581924894b712403299903eacbfc.camel@intel.com>
         <877726fc009ee5ffde50e589d332db90c9695f06.camel@perches.com>
         <c40b4043424055fc4dae97771bb46c8ab15c6230.camel@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-08-27 at 12:02 -0700, Jeff Kirsher wrote:
> On Mon, 2019-08-26 at 20:41 -0700, Joe Perches wrote:
> > On Mon, 2019-08-26 at 01:03 -0700, Jeff Kirsher wrote:
> > > On Fri, 2019-08-23 at 19:14 +0000, Forrest Fleming wrote:
> > > > suggested by checkpatch
> > > > 
> > > > Signed-off-by: Forrest Fleming <ffleming@gmail.com>
> > > > ---
> > > >  .../net/ethernet/intel/e1000/e1000_param.c    | 28 +++++++++--
> > > > --------
> > > >  1 file changed, 14 insertions(+), 14 deletions(-)
> > > 
> > > While I do not see an issue with this change, I wonder how
> > > important it is
> > > to make such a change.  Especially since most of the hardware
> > > supported by
> > > this driver is not available for testing.  In addition, this is one
> > > suggested change by checkpatch.pl that I personally do not agree
> > > with.
> > 
> > I think checkpatch should allow consecutive }}.
> 
> Agreed, have you already submitted a formal patch Joe with the
> suggested change below?

No.

>   If so, I will ACK it.

Of course you can add an Acked-by:

> > Maybe:
> > ---
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index 287fe73688f0..ac5e0f06e1af 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -4687,7 +4687,7 @@ sub process {
> >  
> >  # closing brace should have a space following it when it has
> > anything
> >  # on the line
> > -		if ($line =~ /}(?!(?:,|;|\)))\S/) {
> > +		if ($line =~ /}(?!(?:,|;|\)|\}))\S/) {
> >  			if (ERROR("SPACING",
> >  				  "space required after that close
> > brace '}'\n" . $herecurr) &&
> >  			    $fix) {
> > 
> > 

