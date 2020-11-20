Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F8D2BA2D0
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 08:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgKTHGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 02:06:19 -0500
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:39920 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725785AbgKTHGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 02:06:19 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 44A8D182CED5B;
        Fri, 20 Nov 2020 07:06:18 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:8985:9025:10004:10400:10848:11232:11658:11914:12043:12297:12740:12760:12895:13069:13311:13357:13439:14181:14659:14721:21080:21212:21627:21660:21740:21788:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: run85_1100a7127349
X-Filterd-Recvd-Size: 1649
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Fri, 20 Nov 2020 07:06:16 +0000 (UTC)
Message-ID: <f722b8c425fb78f2434b4e66bbe4fbd69165903e.camel@perches.com>
Subject: Re: [PATCH v2] mdio_bus: suppress err message for reset gpio
 EPROBE_DEFER
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 19 Nov 2020 23:06:15 -0800
In-Reply-To: <20201119212122.665d5396@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201119203446.20857-1-grygorii.strashko@ti.com>
         <1a59fbe1-6a5d-81a3-4a86-fa3b5dbfdf8e@gmail.com>
         <cabad89e-23cc-18b3-8306-e5ef1ee4bfa6@ti.com>
         <44a3c8c0-9dbd-4059-bde8-98486dde269f@gmail.com>
         <20201119214139.GL1853236@lunn.ch>
         <221941d6-2bb1-9be8-7031-08071a509542@gmail.com>
         <20201119212122.665d5396@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-19 at 21:21 -0800, Jakub Kicinski wrote:
> We do have our own comment style rule in networking since the beginning
> of time, and reverse xmas tree, so it's not completely crazy.

reverse xmas tree is completely crazy.

But I posted a patch to checkpatch to suggest it for net/
and drivers/net/ once

https://lkml.org/lkml/2016/11/4/54


