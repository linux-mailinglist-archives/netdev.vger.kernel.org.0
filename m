Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A4D1D8D12
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 03:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgESBW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 21:22:26 -0400
Received: from smtprelay0242.hostedemail.com ([216.40.44.242]:35520 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726292AbgESBW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 21:22:26 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave07.hostedemail.com (Postfix) with ESMTP id D17C118353A61
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 01:22:25 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 211524820;
        Tue, 19 May 2020 01:22:25 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2902:3138:3139:3140:3141:3142:3352:3622:3867:4321:5007:6642:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12297:12740:12760:12895:13069:13311:13357:13439:13972:14659:14721:21080:21433:21627:21939:30045:30054:30055:30056:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: light63_320ceff63e15a
X-Filterd-Recvd-Size: 1999
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Tue, 19 May 2020 01:22:23 +0000 (UTC)
Message-ID: <697e1cc89bec1cbe18d6e1c155a5ca1c9ac05e4a.camel@perches.com>
Subject: Re: [net-next v5 4/9] igc: Use netdev log helpers in igc_ethtool.c
From:   Joe Perches <joe@perches.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
Date:   Mon, 18 May 2020 18:22:22 -0700
In-Reply-To: <20200519010343.2386401-5-jeffrey.t.kirsher@intel.com>
References: <20200519010343.2386401-1-jeffrey.t.kirsher@intel.com>
         <20200519010343.2386401-5-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-05-18 at 18:03 -0700, Jeff Kirsher wrote:
> This patch converts all dev_* calls to netdev_*.
[]
> diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
[]
> @@ -1904,7 +1905,7 @@ static void igc_diag_test(struct net_device *netdev,
>  	bool if_running = netif_running(netdev);
>  
>  	if (eth_test->flags == ETH_TEST_FL_OFFLINE) {
> -		netdev_info(adapter->netdev, "offline testing starting");
> +		netdev_info(adapter->netdev, "Offline testing starting");

several missing '\n' format terminations

		netdev_info(adapter->netdev, "Offline testing starting\n");

>  		set_bit(__IGC_TESTING, &adapter->state);
>  
>  		/* Link test performed before hardware reset so autoneg doesn't
> @@ -1918,13 +1919,13 @@ static void igc_diag_test(struct net_device *netdev,
>  		else
>  			igc_reset(adapter);
>  
> -		netdev_info(adapter->netdev, "register testing starting");
> +		netdev_info(adapter->netdev, "Register testing starting");

etc...


