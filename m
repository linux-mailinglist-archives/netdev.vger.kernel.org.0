Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0DA149189
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 00:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbgAXXCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 18:02:17 -0500
Received: from smtprelay0064.hostedemail.com ([216.40.44.64]:59034 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729195AbgAXXCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 18:02:17 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 9D610180A68D8;
        Fri, 24 Jan 2020 23:02:16 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:599:968:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2110:2194:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3866:3868:3870:3871:3872:3873:4225:4321:5007:10004:10400:10848:11658:11914:12297:12740:12760:12895:13069:13161:13229:13311:13357:13439:14659:21080:21627:30045:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: chair33_8831116e1430d
X-Filterd-Recvd-Size: 1348
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Fri, 24 Jan 2020 23:02:15 +0000 (UTC)
Message-ID: <2603295b9f93bebda831079f10a8c6faf9b1c812.camel@perches.com>
Subject: Re: [net-next 06/14] mlx5: Use proper logging and tracing line
 terminations
From:   Joe Perches <joe@perches.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Fri, 24 Jan 2020 15:01:13 -0800
In-Reply-To: <83a85bb8d25d08cb897d4af54b7a71f285238520.camel@mellanox.com>
References: <20200124215431.47151-1-saeedm@mellanox.com>
         <20200124215431.47151-7-saeedm@mellanox.com>
         <6713b0b5394cfcc5b2b2c6c2f2fb48920a3f2efa.camel@perches.com>
         <83a85bb8d25d08cb897d4af54b7a71f285238520.camel@mellanox.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-01-24 at 22:42 +0000, Saeed Mahameed wrote:
> 2) keep it as is, and fix whatever you don't like about the current
> state of the patch. (remove the newline).. 

Just removing then newlines will be fine, thanks.

There were two unnecessary newlines in your posted patch,
one in rx, one in tx.

cheers, Joe

