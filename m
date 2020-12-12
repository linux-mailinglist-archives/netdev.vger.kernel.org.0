Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AED2D84DD
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 06:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438326AbgLLF0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 00:26:07 -0500
Received: from smtprelay0029.hostedemail.com ([216.40.44.29]:35790 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2437153AbgLLFZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 00:25:54 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 641EF1803A836;
        Sat, 12 Dec 2020 05:25:03 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3866:3867:3871:4321:5007:7875:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12297:12740:12895:13069:13311:13357:13439:13894:14659:14721:21080:21451:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: linen76_000822627407
X-Filterd-Recvd-Size: 1608
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Sat, 12 Dec 2020 05:25:02 +0000 (UTC)
Message-ID: <a81975ecafefb7aebd087a97780424d5bb9ba280.camel@perches.com>
Subject: Re: [PATCH] net/mlx4: Use true,false for bool variable
From:   Joe Perches <joe@perches.com>
To:     Vasyl Gomonovych <gomonovych@gmail.com>, tariqt@nvidia.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 11 Dec 2020 21:25:01 -0800
In-Reply-To: <20201211100518.29804-1-gomonovych@gmail.com>
References: <20201211100518.29804-1-gomonovych@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-12-11 at 11:05 +0100, Vasyl Gomonovych wrote:
> Fix en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
> Fix main.c:4465:5-13: WARNING: Comparison of 0/1 to bool variable
[]
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
[]
> @@ -4462,7 +4462,7 @@ static int __init mlx4_verify_params(void)
>  		pr_warn("mlx4_core: log_num_vlan - obsolete module param, using %d\n",
>  			MLX4_LOG_NUM_VLANS);
>  
> 
> -	if (use_prio != 0)
> +	if (use_prio != false)
>  		pr_warn("mlx4_core: use_prio - obsolete module param, ignored\n");

Generally, assuming use_prio is bool, this would be written

	if (use_prio)
		pr_warn("etc...")


