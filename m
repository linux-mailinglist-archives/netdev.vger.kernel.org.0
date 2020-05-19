Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3806A1D95DB
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 14:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgESMGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 08:06:38 -0400
Received: from smtprelay0059.hostedemail.com ([216.40.44.59]:58298 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726949AbgESMGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 08:06:37 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 596C118223C6E;
        Tue, 19 May 2020 12:06:35 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2551:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3871:3872:3874:4321:4605:5007:6119:7576:7903:7904:9545:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12050:12296:12297:12663:12740:12760:12895:13095:13436:13439:13846:14093:14097:14181:14659:14721:21080:21433:21451:21627:21990:30054:30055:30056:30063:30064:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: meal12_2301a9026d0c
X-Filterd-Recvd-Size: 3695
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Tue, 19 May 2020 12:06:33 +0000 (UTC)
Message-ID: <eed06e1b6a2ee736dd9d520962aacb31bce88c18.camel@perches.com>
Subject: Re: [net-next v5 4/9] igc: Use netdev log helpers in igc_ethtool.c
From:   Joe Perches <joe@perches.com>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "Guedes, Andre" <andre.guedes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>
Date:   Tue, 19 May 2020 05:06:32 -0700
In-Reply-To: <61CC2BC414934749BD9F5BF3D5D94044986A0C1E@ORSMSX112.amr.corp.intel.com>
References: <20200519010343.2386401-1-jeffrey.t.kirsher@intel.com>
         <20200519010343.2386401-5-jeffrey.t.kirsher@intel.com>
         <697e1cc89bec1cbe18d6e1c155a5ca1c9ac05e4a.camel@perches.com>
         <61CC2BC414934749BD9F5BF3D5D94044986A0C1E@ORSMSX112.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-05-19 at 01:35 +0000, Kirsher, Jeffrey T wrote:
> > -----Original Message-----
> > From: Joe Perches <joe@perches.com>
> > Sent: Monday, May 18, 2020 18:22
> > To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> > Cc: Guedes, Andre <andre.guedes@intel.com>; netdev@vger.kernel.org;
> > nhorman@redhat.com; sassmann@redhat.com; Brown, Aaron F
> > <aaron.f.brown@intel.com>
> > Subject: Re: [net-next v5 4/9] igc: Use netdev log helpers in igc_ethtool.c
> > 
> > On Mon, 2020-05-18 at 18:03 -0700, Jeff Kirsher wrote:
> > > This patch converts all dev_* calls to netdev_*.
> > []
> > > diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c
> > > b/drivers/net/ethernet/intel/igc/igc_ethtool.c
> > []
> > > @@ -1904,7 +1905,7 @@ static void igc_diag_test(struct net_device
> > *netdev,
> > >  	bool if_running = netif_running(netdev);
> > > 
> > >  	if (eth_test->flags == ETH_TEST_FL_OFFLINE) {
> > > -		netdev_info(adapter->netdev, "offline testing starting");
> > > +		netdev_info(adapter->netdev, "Offline testing starting");
> > 
> > several missing '\n' format terminations
> [Kirsher, Jeffrey T] 
> 
> Your right, these never had them, which is why it was not caught.
> I am fine with adding the terminating \n, if that is what is requested.
> Andre was just trying to fix the message to properly capitalize the first letter of the message.

What's odd is no other intel driver uses the same logging
format even though many use the same message.

Likely there's little value in capitalization.

$ git grep -i -n "offline testing starting" drivers/net/ethernet/intel
drivers/net/ethernet/intel/e1000/e1000_ethtool.c:1524:          e_info(hw, "offline testing starting\n");
drivers/net/ethernet/intel/e1000e/ethtool.c:1818:               e_info("offline testing starting\n");
drivers/net/ethernet/intel/i40e/i40e_ethtool.c:2536:            netif_info(pf, drv, netdev, "offline testing starting\n");
drivers/net/ethernet/intel/ice/ice_ethtool.c:807:               netdev_info(netdev, "offline testing starting\n");
drivers/net/ethernet/intel/igb/igb_ethtool.c:2025:              dev_info(&adapter->pdev->dev, "offline testing starting\n");
drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c:2095:          e_info(hw, "offline testing starting\n");
drivers/net/ethernet/intel/ixgbevf/ethtool.c:744:               hw_dbg(&adapter->hw, "offline testing starting\n");


