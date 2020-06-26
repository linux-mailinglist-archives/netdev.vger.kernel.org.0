Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A0A20AAC8
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 05:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgFZDhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 23:37:15 -0400
Received: from smtprelay0087.hostedemail.com ([216.40.44.87]:56866 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725830AbgFZDhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 23:37:13 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id C038C100E7B40;
        Fri, 26 Jun 2020 03:37:12 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3868:3870:3872:4321:5007:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13069:13255:13311:13357:13439:14659:21080:21212:21627:30012:30054:30055:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: gate52_50005be26e52
X-Filterd-Recvd-Size: 1285
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Fri, 26 Jun 2020 03:37:11 +0000 (UTC)
Message-ID: <8a6648981072dd69e1cdca3563d4b88d2b81ee93.camel@perches.com>
Subject: Re: [net-next v3 00/15][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-06-25
From:   Joe Perches <joe@perches.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Date:   Thu, 25 Jun 2020 20:37:10 -0700
In-Reply-To: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> This series introduces both the Intel Ethernet Common Module and the Intel
> Data Plane Function.  The patches also incorporate extended features and
> functionality added in the virtchnl.h file.

Overall, perhaps the code wraps rather a lot more
at 80 columns than necessary.

It might be better reading if some of the code used
longer lines where reasonable.


