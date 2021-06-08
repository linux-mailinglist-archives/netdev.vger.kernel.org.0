Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B8539ED16
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhFHDc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:32:27 -0400
Received: from smtprelay0224.hostedemail.com ([216.40.44.224]:56874 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230266AbhFHDcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 23:32:25 -0400
Received: from omf18.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 0049E18029120;
        Tue,  8 Jun 2021 03:30:31 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf18.hostedemail.com (Postfix) with ESMTPA id CA9A62EBFA6;
        Tue,  8 Jun 2021 03:30:30 +0000 (UTC)
Message-ID: <d639dd7c7738a14b5e9e8877eefd20fda9c37279.camel@perches.com>
Subject: Re: [PATCH v2] net: appletalk: fix some mistakes in grammar
From:   Joe Perches <joe@perches.com>
To:     13145886936@163.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Date:   Mon, 07 Jun 2021 20:30:29 -0700
In-Reply-To: <20210608025602.8066-1-13145886936@163.com>
References: <20210608025602.8066-1-13145886936@163.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=4.10
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: CA9A62EBFA6
X-Stat-Signature: 71rzp6ddw7njafawupsfei1qxagoo54o
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18LMHArzN7sZYSwrZwEdu1UCtcPgJYpBgU=
X-HE-Tag: 1623123030-946920
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-06-07 at 19:56 -0700, 13145886936@163.com wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Fix some mistakes in grammar.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
> v2: This statement "Anyone wanting to add it goes ahead." 
> is changed to "Anyone wanting to add it, go ahead.".
>  net/appletalk/ddp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
> index bc76b2fa3dfb..8ade5a4ceaf5 100644
> --- a/net/appletalk/ddp.c
> +++ b/net/appletalk/ddp.c
> @@ -707,7 +707,7 @@ static int atif_ioctl(int cmd, void __user *arg)
>  
> 
>  		/*
>  		 * Phase 1 is fine on LocalTalk but we don't do
> -		 * EtherTalk phase 1. Anyone wanting to add it goes ahead.
> +		 * EtherTalk phase 1. Anyone wanting to add it, go ahead.
>  		 */
>  		if (dev->type == ARPHRD_ETHER && nr->nr_phase != 2)
>  			return -EPROTONOSUPPORT;
> @@ -828,7 +828,7 @@ static int atif_ioctl(int cmd, void __user *arg)
>  		nr = (struct atalk_netrange *)&(atif->nets);
>  		/*
>  		 * Phase 1 is fine on Localtalk but we don't do
> -		 * Ethertalk phase 1. Anyone wanting to add it goes ahead.
> +		 * Ethertalk phase 1. Anyone wanting to add it, go ahead.
>  		 */
>  		if (dev->type == ARPHRD_ETHER && nr->nr_phase != 2)
>  			return -EPROTONOSUPPORT;


