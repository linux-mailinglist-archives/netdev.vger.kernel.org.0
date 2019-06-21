Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA654EDCA
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 19:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfFUR1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 13:27:46 -0400
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:50306 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726032AbfFUR1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 13:27:46 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 3F510100E806B;
        Fri, 21 Jun 2019 17:27:45 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1978:1981:2194:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4362:5007:7514:7809:7903:9010:10004:10400:10471:10848:11232:11657:11658:11914:12043:12048:12050:12296:12297:12663:12740:12760:12895:13161:13229:13255:13439:14096:14097:14181:14659:14721:21080:21451:21627:30030:30045:30054:30060:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.14.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: cream64_93b04b7d1048
X-Filterd-Recvd-Size: 3436
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Fri, 21 Jun 2019 17:27:43 +0000 (UTC)
Message-ID: <698d3e3614ae903ae9582547d64c6a9846629e57.camel@perches.com>
Subject: Re: [PATCH 0/3] net: ethernet: atheros: atlx: Use PCI generic
 definitions instead of private duplicates
From:   Joe Perches <joe@perches.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Puranjay Mohan <puranjay12@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Linux PCI <linux-pci@vger.kernel.org>
Date:   Fri, 21 Jun 2019 10:27:41 -0700
In-Reply-To: <CAErSpo5TMPokae7BMY8ZcOXtW=GeGsWXX_bqS8SrZnh0pEQYxw@mail.gmail.com>
References: <20190621163921.26188-1-puranjay12@gmail.com>
         <CAErSpo5TMPokae7BMY8ZcOXtW=GeGsWXX_bqS8SrZnh0pEQYxw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(adding the atlx maintainers to cc)

On Fri, 2019-06-21 at 12:11 -0500, Bjorn Helgaas wrote:
> On Fri, Jun 21, 2019 at 11:39 AM Puranjay Mohan <puranjay12@gmail.com> wrote:
> > This patch series removes the private duplicates of PCI definitions in
> > favour of generic definitions defined in pci_regs.h.
> > 
> > Puranjay Mohan (3):
> >   net: ethernet: atheros: atlx: Rename local PCI defines to generic
> >     names
> >   net: ethernet: atheros: atlx: Include generic PCI definitions
> >   net: ethernet: atheros: atlx: Remove unused and private PCI
> >     definitions
> > 
> >  drivers/net/ethernet/atheros/atlx/atl2.c | 5 +++--
> >  drivers/net/ethernet/atheros/atlx/atl2.h | 2 --
> >  drivers/net/ethernet/atheros/atlx/atlx.h | 1 -
> >  3 files changed, 3 insertions(+), 5 deletions(-)
> 
> Let's slow this down a little bit; I'm afraid we're going to overwhelm folks.

I generally disagree.

Consolidation of these sorts of changes are generally
better done treewide all at once, posted as a series to
a list and maintainers allowing time (weeks to months)
for the specific maintainers to accept them and then
whatever remainder exists reposted and possibly applied
by an overall maintainer (e.g.: Dave M)

> Before posting more to LKML/netdev, how about we first complete a
> sweep of all the drivers to see what we're getting into.  It could be
> that this will end up being more churn than it's worth.

Also doubtful.

Subsystem specific local PCI #defines without generic
naming is poor style and makes treewide grep and
refactoring much more difficult.

The atlx maintainers should definitely have been cc'd
on these patches.

Jay Cliburn <jcliburn@gmail.com> (maintainer:ATLX ETHERNET DRIVERS)
Chris Snook <chris.snook@gmail.com> (maintainer:ATLX ETHERNET DRIVERS)

Puranjay, can you please do a few things more here:

1: Make sure you use scripts/get_maintainer.pl to cc the
   appropriate people.

2: Show that you compiled the object files and verified
   where possible that there are no object file changes.

3: State that there are no object changes in the proposed
   commit log.

thanks.

