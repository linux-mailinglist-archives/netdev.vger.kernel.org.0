Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F0280799
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 20:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbfHCSB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 14:01:26 -0400
Received: from smtprelay0253.hostedemail.com ([216.40.44.253]:53387 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728366AbfHCSB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 14:01:26 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id A495B182CED2A;
        Sat,  3 Aug 2019 18:01:24 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:7576:9036:10004:10400:10848:10967:11232:11658:11914:12297:12740:12760:12895:13069:13161:13229:13311:13357:13439:14096:14097:14181:14659:14721:21080:21611:21627:30054:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: place79_293e01dd82855
X-Filterd-Recvd-Size: 2126
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Sat,  3 Aug 2019 18:01:23 +0000 (UTC)
Message-ID: <8ea7002f65305ed82d2f09ea18cb237ee7e3a7a4.camel@perches.com>
Subject: Re: [PATCH] net: sctp: Rename fallthrough label to unhandled
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>
Cc:     nhorman@tuxdriver.com, vyasevich@gmail.com,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 03 Aug 2019 11:01:22 -0700
In-Reply-To: <20190802.161932.1776993765494484851.davem@davemloft.net>
References: <eac3fe457d553a2b366e1c1898d47ae8c048087c.camel@perches.com>
         <20190731121646.GD9823@hmswarspite.think-freely.org>
         <a03a23728d3b468942a20b55f70babceaec587ee.camel@perches.com>
         <20190802.161932.1776993765494484851.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-08-02 at 16:19 -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Fri, 02 Aug 2019 10:47:34 -0700
> 
> > On Wed, 2019-07-31 at 08:16 -0400, Neil Horman wrote:
> >> On Wed, Jul 31, 2019 at 04:32:43AM -0700, Joe Perches wrote:
> >> > On Wed, 2019-07-31 at 07:19 -0400, Neil Horman wrote:
> >> > > On Tue, Jul 30, 2019 at 10:04:37PM -0700, Joe Perches wrote:
> >> > > > fallthrough may become a pseudo reserved keyword so this only use of
> >> > > > fallthrough is better renamed to allow it.
> > 
> > Can you or any other maintainer apply this patch
> > or ack it so David Miller can apply it?
> 
> I, like others, don't like the lack of __ in the keyword.  It's kind of
> rediculous the problems it creates to pollute the global namespace like
> that and yes also inconsistent with other shorthands for builtins.

Rejected?

I think that's inappropriate.

As coded, it's nothing like a fallthrough and
the rename to unhandled is more descriptive.


