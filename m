Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2971A60BB
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 23:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgDLVhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 17:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727363AbgDLVhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 17:37:37 -0400
Received: from smtprelay.hostedemail.com (smtprelay0097.hostedemail.com [216.40.44.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D539AC0A3BF5;
        Sun, 12 Apr 2020 14:37:37 -0700 (PDT)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id B25F9182CED34;
        Sun, 12 Apr 2020 21:37:36 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1561:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2741:2828:3138:3139:3140:3141:3142:3622:3873:3876:4250:4321:5007:10004:10400:10848:11026:11473:11657:11658:11914:12043:12297:12438:12740:12760:12895:13069:13311:13357:13439:14659:21080:21324:21451:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: cough09_424d60e13000d
X-Filterd-Recvd-Size: 1324
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Sun, 12 Apr 2020 21:37:35 +0000 (UTC)
Message-ID: <6ecfa6cb686af1452101c0b727c9eb34d5582610.camel@perches.com>
Subject: Re: [PATCH] net: mvneta: Fix a typo
From:   Joe Perches <joe@perches.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        thomas.petazzoni@bootlin.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date:   Sun, 12 Apr 2020 14:35:29 -0700
In-Reply-To: <20200412212034.4532-1-christophe.jaillet@wanadoo.fr>
References: <20200412212034.4532-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-04-12 at 23:20 +0200, Christophe JAILLET wrote:
> s/mvmeta/mvneta/

nice. how did you find this?

> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
[]
> @@ -5383,7 +5383,7 @@ static int __init mvneta_driver_init(void)
>  {
>  	int ret;
>  
> -	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "net/mvmeta:online",
> +	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "net/mvneta:online",


