Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9332B33F7AF
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhCQR60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbhCQR6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 13:58:12 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053B7C06174A;
        Wed, 17 Mar 2021 10:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=z6A1ZJh8eazfi5O/RUdqqjH347bkBHlxjeYy1k26C4o=; b=o7xShSLk/0r+zh7bI1COwvIJBW
        Ku2uZCv8/LM/xqXTOhPOC8VDPoS/xewlJ5ENtZlQSwKWdf5CMJhidq5rCQK2hvkjJjJfA7UVy3TXN
        ry1uxl73ANV5aBdAujknMWFFPhulvZkFcI1jDj1GdSZsWxuUbRE+pS4DaKkw8qSeND0KgdrnIZZAw
        B/m96dVda8gfgUadV/Eif+KpThCsX5IRQcFp1Kv+Api18Y5t499TYx76kzhJlgP/0xegqoW105ra0
        oQfW2IO0l89pGw4IPkwnqBypcWrEt4n3QWgK69AGUa6FGFVSxeRhZElxs7AQXh7G34hFQZWBcbPIo
        GGE9fLrQ==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMaQr-001fhO-0d; Wed, 17 Mar 2021 17:58:09 +0000
Subject: Re: [PATCH] net: ppp: Mundane typo fixes in the file pppoe.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, mostrows@earthlink.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210317090059.4145144-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <0222b3fa-6f43-1d7c-5180-65489994f69b@infradead.org>
Date:   Wed, 17 Mar 2021 10:58:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210317090059.4145144-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/21 2:00 AM, Bhaskar Chowdhury wrote:
> 
> s/procesing/processing/
> s/comparations/comparisons/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/net/ppp/pppoe.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
> index d7f50b835050..9dc7f4b93d51 100644
> --- a/drivers/net/ppp/pppoe.c
> +++ b/drivers/net/ppp/pppoe.c
> @@ -25,7 +25,7 @@
>   *		in pppoe_release.
>   * 051000 :	Initialization cleanup.
>   * 111100 :	Fix recvmsg.
> - * 050101 :	Fix PADT procesing.
> + * 050101 :	Fix PADT processing.
>   * 140501 :	Use pppoe_rcv_core to handle all backlog. (Alexey)
>   * 170701 :	Do not lock_sock with rwlock held. (DaveM)
>   *		Ignore discovery frames if user has socket
> @@ -96,7 +96,7 @@ struct pppoe_net {
>  	 * we could use _single_ hash table for all
>  	 * nets by injecting net id into the hash but
>  	 * it would increase hash chains and add
> -	 * a few additional math comparations messy
> +	 * a few additional math comparisons messy
>  	 * as well, moreover in case of SMP less locking
>  	 * controversy here
>  	 */
> --


-- 
~Randy

