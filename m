Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25653497C7
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhCYRVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhCYRVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 13:21:03 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4CDC06174A;
        Thu, 25 Mar 2021 10:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=hPUcNfmFYXF+F9jzXnSZaB8Uasyr3U6TOgw5rvhcYrY=; b=Pju/W9tTFQ8NqKnBc9hn5aiZf7
        5MZdWFrRCsSJeG3WwZKteFexx8AGhGs4v7gUv7LPSO6KXE5rTBOWY4VCYnyfvdl+i68DpHbmFVVNW
        4sqbp1+2uQXcSeRp4qqFx+zdEx1AcG6LiG1laL7bmSjpmQHBFHK5apmvAchS55xwRqdVeRXYTh2LZ
        Lqr/4n132NWt4qd+JhVgW2F8+HaRDwM9mkNUHghhnaH4ARrybguOkg2ynm3g2YewZnALnBGem24Ne
        D4T4Ts/us/WD9vLPbLqnI6UK4GIu0Qe72p1s1w79kFgdSq1sNT5jJXcZJ6twV+CRSaF4/UP0q8/bb
        zYaL1EAA==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lPTfH-001tq9-7b; Thu, 25 Mar 2021 17:20:59 +0000
Subject: Re: [PATCH] Bluetooth: L2CAP: Rudimentary typo fixes
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210325043544.29248-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2c93a1a3-2717-29ef-4fc1-b41c61e02780@infradead.org>
Date:   Thu, 25 Mar 2021 10:20:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210325043544.29248-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/21 9:35 PM, Bhaskar Chowdhury wrote:
> 
> s/minium/minimum/
> s/procdure/procedure/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  net/bluetooth/l2cap_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 72c2f5226d67..b38e80a0e819 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -1690,7 +1690,7 @@ static void l2cap_le_conn_ready(struct l2cap_conn *conn)
>  		smp_conn_security(hcon, hcon->pending_sec_level);
> 
>  	/* For LE slave connections, make sure the connection interval
> -	 * is in the range of the minium and maximum interval that has
> +	 * is in the range of the minimum and maximum interval that has
>  	 * been configured for this connection. If not, then trigger
>  	 * the connection update procedure.
>  	 */
> @@ -7542,7 +7542,7 @@ static void l2cap_data_channel(struct l2cap_conn *conn, u16 cid,
>  	BT_DBG("chan %p, len %d", chan, skb->len);
> 
>  	/* If we receive data on a fixed channel before the info req/rsp
> -	 * procdure is done simply assume that the channel is supported
> +	 * procedure is done simply assume that the channel is supported
>  	 * and mark it as ready.
>  	 */
>  	if (chan->chan_type == L2CAP_CHAN_FIXED)
> --


-- 
~Randy

