Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4F019E02C
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 23:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgDCVMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 17:12:03 -0400
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:43110 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728173AbgDCVMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 17:12:03 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id DBC401803F787;
        Fri,  3 Apr 2020 21:12:01 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3870:3871:3872:3873:3874:3876:4321:5007:10004:10400:10848:11026:11232:11658:11914:12296:12297:12438:12740:12760:12895:13069:13161:13229:13311:13357:13439:14659:14721:21080:21611:21627:30041:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: woman60_2ea71f4a1b319
X-Filterd-Recvd-Size: 1298
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Fri,  3 Apr 2020 21:12:00 +0000 (UTC)
Message-ID: <4e26a79ed71bd41b3bf2f65e48c4e4c41094fddc.camel@perches.com>
Subject: Re: question about drivers/net/dsa/sja1105/sja1105_main.c
From:   Joe Perches <joe@perches.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Julia Lawall <julia.lawall@inria.fr>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Fri, 03 Apr 2020 14:10:03 -0700
In-Reply-To: <7fc8f8d5-285a-9ec0-23c5-c867347c4feb@gmail.com>
References: <alpine.DEB.2.21.2004031542220.2694@hadrien>
         <CA+h21hrP-0Tdpqje-xbPHmh+v+zndsFyxaEfadMwdAHY+9QK+g@mail.gmail.com>
         <7fc8f8d5-285a-9ec0-23c5-c867347c4feb@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-04-03 at 23:02 +0200, Heiner Kallweit wrote:
> It's right that this is not correct. You can check genphy_read_status_fixed()
> for how it's done there.

There is no SPEED_UNKNOWN in that function.


