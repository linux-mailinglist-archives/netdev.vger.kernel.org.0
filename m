Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5E46772B
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 02:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbfGMAOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 20:14:09 -0400
Received: from smtprelay0104.hostedemail.com ([216.40.44.104]:48302 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727118AbfGMAOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 20:14:09 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 26E19100E86C6;
        Sat, 13 Jul 2019 00:14:08 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3868:4321:5007:7576:10004:10400:10848:10967:11026:11232:11658:11914:12114:12297:12438:12740:12760:12895:13069:13255:13311:13357:13439:14181:14659:21080:21627:30054:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: step13_7b009126cd010
X-Filterd-Recvd-Size: 1404
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Sat, 13 Jul 2019 00:14:05 +0000 (UTC)
Message-ID: <82ccdd83d2a18912bb8cf75585e751c0bd39a215.camel@perches.com>
Subject: Re: [PATCH] [net-next] cxgb4: reduce kernel stack usage in
 cudbg_collect_mem_region()
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>, arnd@arndb.de
Cc:     vishal@chelsio.com, rahul.lakkireddy@chelsio.com,
        ganeshgr@chelsio.com, alexios.zavras@intel.com, arjun@chelsio.com,
        surendra@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Date:   Fri, 12 Jul 2019 17:14:03 -0700
In-Reply-To: <20190712.153632.1007215196498198399.davem@davemloft.net>
References: <20190712090700.317887-1-arnd@arndb.de>
         <20190712.153632.1007215196498198399.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-07-12 at 15:36 -0700, David Miller wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Fri, 12 Jul 2019 11:06:33 +0200
> 
> > The cudbg_collect_mem_region() and cudbg_read_fw_mem() both use several
> > hundred kilobytes of kernel stack space.

Several hundred 'kilo' bytes?
I hope not.

