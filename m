Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B341828FE
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387928AbgCLG2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:28:44 -0400
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:45052 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387831AbgCLG2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:28:44 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id B623C182CED34;
        Thu, 12 Mar 2020 06:28:43 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:3874:4321:5007:7522:10004:10400:11232:11658:11914:12297:12663:12740:12760:12895:13069:13161:13229:13311:13357:13439:14659:14721:21080:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: force01_4c0870e44a755
X-Filterd-Recvd-Size: 1322
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Thu, 12 Mar 2020 06:28:42 +0000 (UTC)
Message-ID: <cf74e8fdd3ee99aec86cec4abfdb1ce84b7fd90a.camel@perches.com>
Subject: Re: [PATCH -next 001/491] MELLANOX ETHERNET INNOVA DRIVERS: Use
 fallthrough;
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>
Cc:     borisp@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 11 Mar 2020 23:26:59 -0700
In-Reply-To: <20200311.232302.1442236068172575398.davem@davemloft.net>
References: <cover.1583896344.git.joe@perches.com>
         <605f5d4954fcb254fe6fc5c22dc707f29b3b7405.1583896347.git.joe@perches.com>
         <20200311.232302.1442236068172575398.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-03-11 at 23:23 -0700, David Miller wrote:
> Joe, please use Subject line subsystem prefixes consistent with what would
> be used for other changes to these drivers.

Not easy to do for scripted patches.
There's no mechanism that scriptable.

I'm not going to hand-edit 500 patches.


