Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E43B1504EA
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 12:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgBCLIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 06:08:14 -0500
Received: from smtprelay0053.hostedemail.com ([216.40.44.53]:53054 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727509AbgBCLIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 06:08:14 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id BD3E72816;
        Mon,  3 Feb 2020 11:08:12 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:69:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3872:3874:4321:5007:6691:7514:9040:10004:10400:10848:10967:11232:11658:11914:12043:12291:12297:12555:12663:12683:12740:12760:12895:12986:13069:13311:13357:13439:14093:14095:14096:14181:14659:14721:21080:21324:21451:21611:21627:30054:30060:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: cause64_d4df4aac5c17
X-Filterd-Recvd-Size: 2662
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Mon,  3 Feb 2020 11:08:11 +0000 (UTC)
Message-ID: <ce81e9b1ac6ede9f7a16823175192ef69613ec07.camel@perches.com>
Subject: Re: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
From:   Joe Perches <joe@perches.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Arnd Bergmann <arnd@arndb.de>,
        isdn4linux@listserv.isdn4linux.de, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Mon, 03 Feb 2020 03:07:01 -0800
In-Reply-To: <CAHp75VdVXqz7fab4MKH2jZozx4NGGkQnJyTWHDKCdgSwD2AtpA@mail.gmail.com>
References: <20200201124301.21148-1-lukas.bulwahn@gmail.com>
         <20200202124306.54bcabea@cakuba.hsd1.ca.comcast.net>
         <CAHp75VdVXqz7fab4MKH2jZozx4NGGkQnJyTWHDKCdgSwD2AtpA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-02-03 at 12:13 +0200, Andy Shevchenko wrote:
> On Sun, Feb 2, 2020 at 10:45 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Sat,  1 Feb 2020 13:43:01 +0100, Lukas Bulwahn wrote:
> > > Commit 6d97985072dc ("isdn: move capi drivers to staging") cleaned up the
> > > isdn drivers and split the MAINTAINERS section for ISDN, but missed to add
> > > the terminal slash for the two directories mISDN and hardware. Hence, all
> > > files in those directories were not part of the new ISDN/mISDN SUBSYSTEM,
> > > but were considered to be part of "THE REST".
> > > 
> > > Rectify the situation, and while at it, also complete the section with two
> > > further build files that belong to that subsystem.
> > > 
> > > This was identified with a small script that finds all files belonging to
> > > "THE REST" according to the current MAINTAINERS file, and I investigated
> > > upon its output.
> > > 
> > > Fixes: 6d97985072dc ("isdn: move capi drivers to staging")
> > > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > 
> > Applied to net, thanks!
> 
> I'm not sure it's ready. I think parse-maintainers.pl will change few
> lines here.

parse-maintainers would change a _lot_ of the MAINTAINERS file
by reordering section letters.

$ perl ./scripts/parse-maintainers.pl --output=MAINTAINERS
$ git diff --stat MAINTAINERS
 MAINTAINERS | 5572 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 2786 insertions(+), 2786 deletions(-)


