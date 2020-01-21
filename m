Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F292143D94
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 14:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgAUNC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 08:02:27 -0500
Received: from smtprelay0179.hostedemail.com ([216.40.44.179]:34261 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726920AbgAUNC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 08:02:27 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 6FA62838434A;
        Tue, 21 Jan 2020 13:02:25 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3872:4321:4605:5007:7576:10004:10400:10848:10967:11026:11232:11658:11914:12043:12296:12297:12438:12740:12760:12895:13069:13255:13311:13357:13439:14181:14659:14721:21080:21627:21740:21990:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: time50_6c45a5c0ebf2e
X-Filterd-Recvd-Size: 1817
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Tue, 21 Jan 2020 13:02:23 +0000 (UTC)
Message-ID: <aba420a3be9272236795dbc14380991bbf72c657.camel@perches.com>
Subject: Re: [PATCH net 2/9] r8152: reset flow control patch when linking on
 for RTL8153B
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>, hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        pmalani@chromium.org, grundler@chromium.org
Date:   Tue, 21 Jan 2020 05:01:23 -0800
In-Reply-To: <20200121.135439.1619270282552230019.davem@davemloft.net>
References: <1394712342-15778-338-Taiwan-albertk@realtek.com>
         <1394712342-15778-340-Taiwan-albertk@realtek.com>
         <20200121.135439.1619270282552230019.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-01-21 at 13:54 +0100, David Miller wrote:
> From: Hayes Wang <hayeswang@realtek.com>
> Date: Tue, 21 Jan 2020 20:40:28 +0800
> 
> > When linking ON, the patch of flow control has to be reset. This
> > makes sure the patch works normally.
[]
> > diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
[]
> > @@ -2857,6 +2857,7 @@ static void r8153_set_rx_early_size(struct r8152 *tp)
> >  
> >  static int rtl8153_enable(struct r8152 *tp)
> >  {
> > +     u32 ocp_data;
> >       if (test_bit(RTL8152_UNPLUG, &tp->flags))
> >               return -ENODEV;
> >  
> 
> Please put an empty line after the local variable declarations.

Local scoping is generally better.

Perhaps declare ocp_data inside the if branch
where it's used.  


