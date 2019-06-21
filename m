Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A59994EECA
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 20:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfFUSdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 14:33:32 -0400
Received: from smtprelay0111.hostedemail.com ([216.40.44.111]:43146 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726032AbfFUSdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 14:33:32 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 3DF02837F24D;
        Fri, 21 Jun 2019 18:33:30 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1978:1981:2194:2199:2393:2553:2559:2562:2736:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6119:7903:9010:9108:10004:10400:10471:10848:11232:11658:11914:12050:12257:12297:12663:12740:12760:12895:13069:13071:13255:13311:13357:13439:14096:14097:14180:14181:14659:14721:21060:21080:21451:21627:30054:30060:30070:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:30,LUA_SUMMARY:none
X-HE-Tag: value78_13e1d23df325
X-Filterd-Recvd-Size: 3044
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Fri, 21 Jun 2019 18:33:28 +0000 (UTC)
Message-ID: <838b8e84523151418ab8cda4abdbb114ce24a497.camel@perches.com>
Subject: Re: [PATCH 0/3] net: ethernet: atheros: atlx: Use PCI generic
 definitions instead of private duplicates
From:   Joe Perches <joe@perches.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Linux PCI <linux-pci@vger.kernel.org>
Date:   Fri, 21 Jun 2019 11:33:27 -0700
In-Reply-To: <CAErSpo6iRVWU-yL5CRF_GEY7CWg5iV=Jw0BrdNV4h3Jvh5AuAw@mail.gmail.com>
References: <20190621163921.26188-1-puranjay12@gmail.com>
         <CAErSpo5TMPokae7BMY8ZcOXtW=GeGsWXX_bqS8SrZnh0pEQYxw@mail.gmail.com>
         <698d3e3614ae903ae9582547d64c6a9846629e57.camel@perches.com>
         <CAErSpo6iRVWU-yL5CRF_GEY7CWg5iV=Jw0BrdNV4h3Jvh5AuAw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-06-21 at 13:12 -0500, Bjorn Helgaas wrote:
> On Fri, Jun 21, 2019 at 12:27 PM Joe Perches <joe@perches.com> wrote:
[]
> > Subsystem specific local PCI #defines without generic
> > naming is poor style and makes treewide grep and
> > refactoring much more difficult.
> 
> Don't worry, we have the same objectives.  I totally agree that local
> #defines are a bad thing, which is why I proposed this project in the
> first place.

Hi again Bjorn.

I didn't know that was your idea.  Good idea.

> I'm just saying that this is a "first-patch" sort of learning project
> and I think it'll avoid some list spamming and discouragement if we
> can figure out the scope and shake out some of the teething problems
> ahead of time.  I don't want to end up with multiple versions of
> dozens of little 2-3 patch series posted every week or two.

Great, that's sensible.

> I'd rather be able to deal with a whole block of them at one time.

Also very sensible.

> > 2: Show that you compiled the object files and verified
> >    where possible that there are no object file changes.
> 
> Do you have any pointers for the best way to do this?  Is it as simple
> as comparing output of "objdump -d"?

Generically, yes.

I have a little script that does the equivalent of:

<git reset>
make <foo.o>
mv <foo.o> <foo.o>.old
patch -P1 < <foo_patch>
make <foo.o>
mv <foo.o> <foo.o>.new
diff -urN <(objdump -d <foo.o>.old) <(objdump -d <foo.o>.new)

But it's not foolproof as gcc does not guarantee
compilation repeatability.

And some subsystems Makefiles do not allow per-file
compilation.

