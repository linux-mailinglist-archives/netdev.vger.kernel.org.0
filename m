Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800A43660F6
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhDTUeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:34:12 -0400
Received: from gateway34.websitewelcome.com ([192.185.148.142]:43695 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234003AbhDTUeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:34:06 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 1B4A040C91
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 15:08:37 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Ywfllde4J1cHeYwflllS3s; Tue, 20 Apr 2021 15:08:37 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=V90Tj6Wd5nMF3N/WKL/1v+/wiuT404oIfpEQA/lhaYA=; b=QiEM0THmYnxbYX0Ca1F1Sb+5ML
        riyRBu3ggxV9vVFecNrkKj1eaSOl11gwr2DzwwoJDVKUpfX7OK1drBc5dPQSRHyfFbwJgRRVmB2Fj
        5z0eBF0+BpR2Euwszowsq2cxttKpQM/69kJi8qoBK6F9aI6o3NNEYb+XftGKK6lk//UlrBjl0QuUK
        GmCY7RCwmyAaA1Sat7fULdGZYZJbLcrwnEDG70RGjW9wzgoq/BPrOFI/abvAxAYNbJlVaiMx6Wzyr
        eyUF5ebqbkjcb774UEIH/ZpLulIhxwOVU0tNJBUYTg7lEJiULQXjkXd8y9RmBTb9y1KGX8oQBsfQ3
        +NY0FfLw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:48932 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lYwfh-002bTT-JJ; Tue, 20 Apr 2021 15:08:33 -0500
Subject: Re: [PATCH RESEND][next] tipc: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210305092504.GA140204@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <4739167e-676b-998c-4565-8aa32a66706f@embeddedor.com>
Date:   Tue, 20 Apr 2021 15:08:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305092504.GA140204@embeddedor>
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
X-Exim-ID: 1lYwfh-002bTT-JJ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:48932
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 24
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

On 3/5/21 03:25, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of letting the code fall
> through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  net/tipc/link.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/tipc/link.c b/net/tipc/link.c
> index 115109259430..bcc426e16725 100644
> --- a/net/tipc/link.c
> +++ b/net/tipc/link.c
> @@ -649,6 +649,7 @@ int tipc_link_fsm_evt(struct tipc_link *l, int evt)
>  			break;
>  		case LINK_FAILOVER_BEGIN_EVT:
>  			l->state = LINK_FAILINGOVER;
> +			break;
>  		case LINK_FAILURE_EVT:
>  		case LINK_RESET_EVT:
>  		case LINK_ESTABLISH_EVT:
> 
