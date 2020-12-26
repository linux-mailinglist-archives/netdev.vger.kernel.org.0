Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DA72E2ECB
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 18:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgLZRsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 12:48:04 -0500
Received: from smtprelay0238.hostedemail.com ([216.40.44.238]:38366 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726240AbgLZRsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 12:48:03 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 6A6C018225DF9;
        Sat, 26 Dec 2020 17:47:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3622:3865:3868:4321:5007:6742:7652:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: bulb63_150dd3d27484
X-Filterd-Recvd-Size: 1466
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Sat, 26 Dec 2020 17:47:20 +0000 (UTC)
Message-ID: <0d06aad61cdb5be1d9c8c17bcf938d726d028e3f.camel@perches.com>
Subject: Re: [PATCH] ethernet: Remove invalid trailers after %pI4
From:   Joe Perches <joe@perches.com>
To:     netdev@vger.kernel.org
Cc:     Tom Rix <trix@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, linux-kernel@vger.kernel.org,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Date:   Sat, 26 Dec 2020 09:47:19 -0800
In-Reply-To: <d1ea50ed47e2e9ca65a67ffc2ca0eee08e662132.camel@perches.com>
References: <d1ea50ed47e2e9ca65a67ffc2ca0eee08e662132.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-12-26 at 09:10 -0800, Joe Perches wrote:
> Alphanumeric characters after vsprintf pointer extension %pI4 are
> not valid and are not emitted.
> 
> Remove the invalid characters from the %pI4 uses.

self-nak.  I believe I misunderstood the format specifier.


