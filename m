Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F42DE2728
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 01:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392179AbfJWXqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 19:46:50 -0400
Received: from smtprelay0132.hostedemail.com ([216.40.44.132]:53368 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389801AbfJWXqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 19:46:49 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 8C573181D3417;
        Wed, 23 Oct 2019 23:46:48 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3866:3868:3870:4321:5007:6119:8603:10004:10400:11026:11232:11473:11658:11914:12297:12740:12760:12895:13069:13255:13311:13357:13439:14659:14721:21080:21433:21451:21627:30054:30070:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: plot32_3b2e9464b9b05
X-Filterd-Recvd-Size: 1614
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Wed, 23 Oct 2019 23:46:46 +0000 (UTC)
Message-ID: <dbecfcf9ed62c481bb040c619af3b1ee5a7de848.camel@perches.com>
Subject: Re: [PATCH v4] string-choice: add yesno(), onoff(),
 enableddisabled(), plural() helpers
From:   Joe Perches <joe@perches.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Jani Nikula <jani.nikula@intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date:   Wed, 23 Oct 2019 16:46:45 -0700
In-Reply-To: <20191023155619.43e0013f0c8c673a5c508c1e@linux-foundation.org>
References: <20191023131308.9420-1-jani.nikula@intel.com>
         <20191023155619.43e0013f0c8c673a5c508c1e@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-10-23 at 15:56 -0700, Andrew Morton wrote:
> And doing this will cause additional savings: calling a single-arg
> out-of-line function generates less .text than calling yesno().

I get no change in size at all with any of
	extern
	static __always_inline
with either of bool or int argument.

gcc 8.3, defconfig with CONFIG_CHELSIO_T4


