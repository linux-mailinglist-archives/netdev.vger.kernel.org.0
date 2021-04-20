Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D32366142
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhDTU62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:58:28 -0400
Received: from gateway20.websitewelcome.com ([192.185.65.13]:31040 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233957AbhDTU61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:58:27 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id BE8564010C024
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 14:58:11 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id YwgJlGjt6L7DmYwgJlOqWd; Tue, 20 Apr 2021 15:09:11 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9B0yy04ZlX+XOpLtOLXLro5YGBYuU/g5MJ8vNg1SATk=; b=sfQrpe/V49WFyWapAHyeNonLEs
        IQtiGdBsz1nayl5zAaBmTFNH9Gsn20i3jJyKYrwQ7R5K5FsB7S+9U5P0ItXPx+pgMTZ+wpRHbJB+S
        eJSICvpeXrnpD9oLdaMBjpt/+pI0bb6unv+UTyQrDoEwC/odcuk69BelG3mARa17m0j9j3xiH0fsb
        c3F9CqEYSqbs96tI+zS0KjvdxYiFf2Re3bqAuAzSV2HqT6YpMXAGfWWJzBT2QWP5HY8/6c/GIxSbQ
        SQ3fdD0axH2ZkBkK7m7dq9E7KmpFY0LQf5k+IevIxvzEQwakrD29OWiIrNW5SPk8EtDyET9HByvSL
        BK04cAXg==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:48936 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lYwgG-002d36-BK; Tue, 20 Apr 2021 15:09:08 -0500
Subject: Re: [PATCH RESEND][next] sctp: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210305090717.GA139387@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <91fcca0d-c986-f88e-4a0d-4590de6a5985@embeddedor.com>
Date:   Tue, 20 Apr 2021 15:09:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305090717.GA139387@embeddedor>
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
X-Exim-ID: 1lYwgG-002d36-BK
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:48936
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 35
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

On 3/5/21 03:07, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a couple
> of warnings by explicitly adding a break statement and replacing a
> comment with a goto statement instead of letting the code fall through
> to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  net/sctp/input.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index d508f6f3dd08..5ceaf75105ba 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -633,7 +633,7 @@ int sctp_v4_err(struct sk_buff *skb, __u32 info)
>  		break;
>  	case ICMP_REDIRECT:
>  		sctp_icmp_redirect(sk, transport, skb);
> -		/* Fall through to out_unlock. */
> +		goto out_unlock;
>  	default:
>  		goto out_unlock;
>  	}
> @@ -1236,6 +1236,7 @@ static struct sctp_association *__sctp_rcv_walk_lookup(struct net *net,
>  						net, ch, laddr,
>  						sctp_hdr(skb)->source,
>  						transportp);
> +			break;
>  		default:
>  			break;
>  		}
> 
