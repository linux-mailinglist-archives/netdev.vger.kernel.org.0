Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978DD366140
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbhDTU61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:58:27 -0400
Received: from gateway20.websitewelcome.com ([192.185.65.13]:19994 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233769AbhDTU60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:58:26 -0400
X-Greylist: delayed 1502 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2021 16:58:26 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 9641F4015719B
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 14:58:41 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id YwgolGkXLL7DmYwgolOrAf; Tue, 20 Apr 2021 15:09:42 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FOc5A4lcXPEdY8uIQjSXbHpXv3h/lmU0WMIPnLjkAII=; b=vNgPStY7WOM98xcPJLfhjNJOcE
        QW3QQurawm/IeOr/MpuguWyjJutaCyD9msz/oJqJ7rgdNdvknFanl0Ldeee8Jz1oKPA8t/Jou0EWp
        xa1WbDZ4ZFqy/4h128JfXrEVqlCg5MPKxqyTVdEPw437oGQUBkma4jglGqvXzFkvTBRyMTmzWwPrE
        MkgqoPvXac72NVZ/zCzuO8jEVIa/qWoxLLXUzG1a5Q8fcevbtxiZftEKsMLbFJ79VIeyE7CbcrYjo
        XZuJjsQ6gEMkmAEdCyLtg+aFW8xbUG89MRC8r8EP+PhGIN5mXFwIIk38s7I5kU1YIYAMF0SZfPhQt
        aALtI6nQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:48940 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lYwgk-002eN4-PR; Tue, 20 Apr 2021 15:09:38 -0500
Subject: Re: [PATCH RESEND][next] rxrpc: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210305091900.GA139713@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <7137db63-20ea-29b2-7b8e-e2edd0c42bdd@embeddedor.com>
Date:   Tue, 20 Apr 2021 15:09:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305091900.GA139713@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lYwgk-002eN4-PR
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:48940
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 43
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Friendly ping: who can take this, please?

Thanks
--
Gustavo

On 3/5/21 03:19, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of letting the code fall
> through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  net/rxrpc/af_rxrpc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
> index 41671af6b33f..2b5f89713e36 100644
> --- a/net/rxrpc/af_rxrpc.c
> +++ b/net/rxrpc/af_rxrpc.c
> @@ -471,6 +471,7 @@ static int rxrpc_connect(struct socket *sock, struct sockaddr *addr,
>  	switch (rx->sk.sk_state) {
>  	case RXRPC_UNBOUND:
>  		rx->sk.sk_state = RXRPC_CLIENT_UNBOUND;
> +		break;
>  	case RXRPC_CLIENT_UNBOUND:
>  	case RXRPC_CLIENT_BOUND:
>  		break;
> 
