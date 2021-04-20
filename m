Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC365366143
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhDTU63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:58:29 -0400
Received: from gateway20.websitewelcome.com ([192.185.65.13]:29334 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233964AbhDTU61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:58:27 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id A12CF40169F66
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 14:59:07 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id YwhElPdijmJLsYwhElmiMa; Tue, 20 Apr 2021 15:10:08 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=T17AR9OHg8qWguPD0J0elr1lqd2smiUTolFswCJAyeE=; b=jQv1GMuu077q+yr2ApeKRPnqFG
        tsMh+lvGaFmsQ34LLZzAiiaMs2XD7/RCguH8/bk/WIU0MMLRvQ9XXv7NaP1sxKaT+aHOkFZWVQ9Ks
        af6TwikMt8WF9nYbVo1NtLINT9o0LuB5RTjOvxDRUCEKa6xDGnHE4hUMbhs45ghfWNrBlaYqbnYAh
        es0Fz7K1Zu3HkQhpoc7ziffEQG1jzNPjbh7jeCROfAKO3ZeKb69sYyAYl+dqEPq7Flaofqnwe+L/o
        qPCCQPMg/4ondAJGMWVr9XoGJ2Q3Dt2gDQfr5PmSQFYKdDObeidc3bGZ16ovUn0ZWqqvra5fzrvYH
        sXxbcrcA==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:48946 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lYwhA-002fLy-Gv; Tue, 20 Apr 2021 15:10:04 -0500
Subject: Re: [PATCH RESEND][next] rds: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210305090612.GA139288@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <cd935ba5-a072-5b5a-d455-e06ef87a3a34@embeddedor.com>
Date:   Tue, 20 Apr 2021 15:10:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305090612.GA139288@embeddedor>
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
X-Exim-ID: 1lYwhA-002fLy-Gv
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:48946
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 50
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

On 3/5/21 03:06, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
> warnings by explicitly adding multiple break statements instead of
> letting the code fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  net/rds/tcp_connect.c | 1 +
>  net/rds/threads.c     | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/net/rds/tcp_connect.c b/net/rds/tcp_connect.c
> index 4e64598176b0..5461d77fff4f 100644
> --- a/net/rds/tcp_connect.c
> +++ b/net/rds/tcp_connect.c
> @@ -78,6 +78,7 @@ void rds_tcp_state_change(struct sock *sk)
>  	case TCP_CLOSE_WAIT:
>  	case TCP_CLOSE:
>  		rds_conn_path_drop(cp, false);
> +		break;
>  	default:
>  		break;
>  	}
> diff --git a/net/rds/threads.c b/net/rds/threads.c
> index 32dc50f0a303..1f424cbfcbb4 100644
> --- a/net/rds/threads.c
> +++ b/net/rds/threads.c
> @@ -208,6 +208,7 @@ void rds_send_worker(struct work_struct *work)
>  		case -ENOMEM:
>  			rds_stats_inc(s_send_delayed_retry);
>  			queue_delayed_work(rds_wq, &cp->cp_send_w, 2);
> +			break;
>  		default:
>  			break;
>  		}
> @@ -232,6 +233,7 @@ void rds_recv_worker(struct work_struct *work)
>  		case -ENOMEM:
>  			rds_stats_inc(s_recv_delayed_retry);
>  			queue_delayed_work(rds_wq, &cp->cp_recv_w, 2);
> +			break;
>  		default:
>  			break;
>  		}
> 
