Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6C5151583
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 06:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgBDFgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 00:36:17 -0500
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:54753 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbgBDFgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 00:36:17 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 71695182CED34;
        Tue,  4 Feb 2020 05:36:16 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2560:2563:2682:2685:2692:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:6691:7903:9010:9025:10004:10400:11232:11658:11914:12043:12297:12555:12663:12740:12760:12895:13017:13018:13019:13069:13311:13357:13439:14096:14097:14181:14659:14721:21080:21324:21451:21611:21627:30041:30045:30054:30060:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:3,LUA_SUMMARY:none
X-HE-Tag: smash54_53b153a945116
X-Filterd-Recvd-Size: 2936
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Tue,  4 Feb 2020 05:36:15 +0000 (UTC)
Message-ID: <7040e0501f1a04cf09195bdccfcfb05df25962ec.camel@perches.com>
Subject: Re: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
From:   Joe Perches <joe@perches.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Arnd Bergmann <arnd@arndb.de>,
        isdn4linux@listserv.isdn4linux.de, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Mon, 03 Feb 2020 21:35:04 -0800
In-Reply-To: <alpine.DEB.2.21.2002040550540.3062@felia>
References: <20200201124301.21148-1-lukas.bulwahn@gmail.com>
         <20200202124306.54bcabea@cakuba.hsd1.ca.comcast.net>
         <CAHp75VdVXqz7fab4MKH2jZozx4NGGkQnJyTWHDKCdgSwD2AtpA@mail.gmail.com>
         <ce81e9b1ac6ede9f7a16823175192ef69613ec07.camel@perches.com>
         <CAHp75VdaaOW0ktt4eo4NsLFu2QT1K1mHK8DZeycOPhbvcMq4wQ@mail.gmail.com>
         <alpine.DEB.2.21.2002040550540.3062@felia>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-02-04 at 06:08 +0100, Lukas Bulwahn wrote:
> 
> On Mon, 3 Feb 2020, Andy Shevchenko wrote:
> 
> > On Mon, Feb 3, 2020 at 1:08 PM Joe Perches <joe@perches.com> wrote:
> > > On Mon, 2020-02-03 at 12:13 +0200, Andy Shevchenko wrote:
> > > > On Sun, Feb 2, 2020 at 10:45 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > 
> > ...
> > 
> > > > I'm not sure it's ready. I think parse-maintainers.pl will change few
> > > > lines here.
> > > 
> > > parse-maintainers would change a _lot_ of the MAINTAINERS file
> > > by reordering section letters.
> > 
> > I think it's quite easy to find out if it had changed the record in question.
> > 
> I checked it and it does change a bit. My patch adds to a list of file 
> entries sorted by "relevance" (not alphabetically) two further minor (by 
> relevance) entries, i.e., Kconfig and Makefile, to the end of that list.
> 
> The other reorderings would have already applied to the original state; 
> rather than trying to "fix" this locally for this one patch here, I would 
> prefer to understand why the discussion on splitting the MAINTAINERS file,
> summarized at https://lwn.net/Articles/730509/, got stuck and how I can 
> contribute to that. If that bigger change would happen, we could 
> automatically clean up all the entries when the things are splitted, 
> rather than sending reordering patches to the maintainers that then spend 
> time on trying to merge that all back together.

Realistically, ISDN is all but dead.

Perhaps it'd be better to change the entries here to:

F:	drivers/isdn/
X:	drivers/isdn/capi/





