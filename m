Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A5B39EC36
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 04:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhFHCiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 22:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhFHCiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 22:38:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA60C061574;
        Mon,  7 Jun 2021 19:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=YCz40GTQLvU2H6cUTWTueAet4oQOTC6hBNiQ/DdKO2w=; b=U2u7kkSBQ4K3iQohb91DtBBgIG
        OP5v4q/rHXGTouXwRucsYS9shtZDKzUSVEy5bHB3PeCE4mqFRHP8/22IaYDy7clxBezdZCdIMX3NJ
        kno+Q2+HKaVQ1yVXTv2Yqi/Io6OS5w/RjXQDnXoGIvyTTmT7sQVBQ8jRlTaClSYcnVRj/0in2Qc3W
        rWQ6c0OxHnIP26/5x5JtaZtRZY9fZCA1Vt9p6JmGI84jq+ISylED2aidxYq2QyaNA37sk3ubbMlTT
        j6qS4QJbjPTrNWv6SdH8DcHUy3OT6555xGa9rYY1n0si5pYgZUWV7UeQMCDpnJbl4PDyRmygs0Yyu
        wZ91dIrQ==;
Received: from [2601:1c0:6280:3f0::bd57]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lqRbM-0063t4-GF; Tue, 08 Jun 2021 02:36:24 +0000
Subject: Re: [PATCH] net: appletalk: fix some mistakes in grammar
To:     13145886936@163.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
References: <20210608022546.7587-1-13145886936@163.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c9b6ed9d-92c1-55da-fe1f-0af33305bb89@infradead.org>
Date:   Mon, 7 Jun 2021 19:36:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210608022546.7587-1-13145886936@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/21 7:25 PM, 13145886936@163.com wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Fix some mistakes in grammar.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/appletalk/ddp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
> index ebda397fa95a..bc76b2fa3dfb 100644
> --- a/net/appletalk/ddp.c
> +++ b/net/appletalk/ddp.c
> @@ -707,7 +707,7 @@ static int atif_ioctl(int cmd, void __user *arg)
>  
>  		/*
>  		 * Phase 1 is fine on LocalTalk but we don't do
> -		 * EtherTalk phase 1. Anyone wanting to add it go ahead.
> +		 * EtherTalk phase 1. Anyone wanting to add it goes ahead.
>  		 */
>  		if (dev->type == ARPHRD_ETHER && nr->nr_phase != 2)
>  			return -EPROTONOSUPPORT;
> @@ -828,7 +828,7 @@ static int atif_ioctl(int cmd, void __user *arg)
>  		nr = (struct atalk_netrange *)&(atif->nets);
>  		/*
>  		 * Phase 1 is fine on Localtalk but we don't do
> -		 * Ethertalk phase 1. Anyone wanting to add it go ahead.
> +		 * Ethertalk phase 1. Anyone wanting to add it goes ahead.

Nak on these 2 changes.
If anything, it could be something like:
		                      Anyone wanting to add it, go ahead.
or
		                      If anyone wants to add it, go ahead.


>  		 */
>  		if (dev->type == ARPHRD_ETHER && nr->nr_phase != 2)
>  			return -EPROTONOSUPPORT;
> @@ -2018,7 +2018,7 @@ module_init(atalk_init);
>   * by the network device layer.
>   *
>   * Ergo, before the AppleTalk module can be removed, all AppleTalk
> - * sockets be closed from user space.
> + * sockets should be closed from user space.

ok.

>   */
>  static void __exit atalk_exit(void)
>  {
> 


-- 
~Randy

