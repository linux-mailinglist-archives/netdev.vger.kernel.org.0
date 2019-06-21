Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF154EE42
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 19:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfFUR70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 13:59:26 -0400
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:39534 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725992AbfFUR7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 13:59:25 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 2CFC9837F24D;
        Fri, 21 Jun 2019 17:59:24 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:599:800:960:967:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1978:1981:2194:2199:2393:2525:2553:2559:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4384:5007:6117:6119:7514:9010:9025:10004:10400:10848:10967:11232:11658:11914:12043:12296:12297:12555:12740:12760:12895:13069:13255:13311:13357:13439:13845:14096:14097:14181:14659:14721:21080:21627:30009:30041:30054:30060:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: paint61_8c15a38e8ef39
X-Filterd-Recvd-Size: 2525
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Fri, 21 Jun 2019 17:59:22 +0000 (UTC)
Message-ID: <5025da034080c6653b23d7362e06cf211d2cec3c.camel@perches.com>
Subject: Re: [PATCH v3 0/3] net: fddi: skfp: Use PCI generic definitions
 instead of private duplicates
From:   Joe Perches <joe@perches.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Date:   Fri, 21 Jun 2019 10:59:21 -0700
In-Reply-To: <20190621164429.GA187016@google.com>
References: <20190621094607.15011-1-puranjay12@gmail.com>
         <20190621162024.53620dd9@alans-desktop>
         <20190621164429.GA187016@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-06-21 at 11:44 -0500, Bjorn Helgaas wrote:
> On Fri, Jun 21, 2019 at 04:20:24PM +0100, Alan Cox wrote:
> > On Fri, 21 Jun 2019 15:16:04 +0530
> > Puranjay Mohan <puranjay12@gmail.com> wrote:
> > 
> > > This patch series removes the private duplicates of PCI definitions in
> > > favour of generic definitions defined in pci_regs.h.
> > 
> > Why bother ? It's an ancient obsolete card ?
> 
> That's a fair question.
> 
> Is there anything that would indicate that "this file is obsolete and
> problems shouldn't be fixed"?  Nobody wants to waste time on things
> that don't need to be fixed, but I don't know how to tell if something
> is obsolete.
> 
> My naive assumption is that if something is in the tree, it's fair
> game for fixes and cleanups.

I'd prefer to move the old, crufty, obsolete and generally
unsupported drivers to new directory trees and possibly
symlink those drivers to their current locations.

I suggested on the kernel summit list:
https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2019-June/006482.html

---

Perhaps a mechanism to move these old, generally unsupported
by an actual maintainer, and rarely tested drivers out of the
mainline drivers directory into a separate obsolete directory
would help isolate the whitespace and trivial api changes.


