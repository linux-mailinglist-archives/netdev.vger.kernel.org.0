Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C39127F82
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfLTPju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:39:50 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36174 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfLTPju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:39:50 -0500
Received: by mail-wr1-f65.google.com with SMTP id z3so9857818wru.3
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 07:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ur307i9csXSZNQJ6fqdieONj7j4D2bGiW4RbOHBSQxc=;
        b=fcC5EHvgXJ4Si5wRV+wdyDyiqb5SFs+K6YhxRP04hWnRPZK0liJuqT0aXCLs+5veZE
         Gy+gxbfNl3NgWmDzMOE/gXaFQZgHBEBNDAylowwsrGv1c8sKBniMwFqKv/3/PG5Su7Ln
         BiQ0Ivu5uUEJzruRWy7LpjirrjQVZoQYXy0gvfXuIzGMfPPetRvyuCXEmaXTqmNA7qKh
         59FLpFyIU/zO2wxSpcmlVMUemI6YfOKU93geNWMY9Eg1nBTxlG/00tN4n+lM1OLMTraL
         4bWKFcWmZyrpFbN/qiyJQTvI00+aUv+AGpv34ipcIf0gFY0YI3yMmP6GcO7OjWQKL+ln
         X3hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ur307i9csXSZNQJ6fqdieONj7j4D2bGiW4RbOHBSQxc=;
        b=PApZYXVeqJlO+GSwMdrB4IWDcZon14W2Irfoq59aaF1Hnoy75zGcIT8Zq5ERaKeGAS
         FMEGADDfz3V0Z/9ZqwrBUw8RetVMvCwBmcptrABHQNqCAkLSZa0lcogsp1QzNyfbGw6c
         5jn6DGSEnoi+y7mgBsyTDLVoEzrHIxgJuLxJZb1SzgKcOsapNcBedYgsVqZM688EqeFa
         OWXH1abhTQ74hPJi3y8nRrUfY877IVxsT3mTqKHWrm/CbnIsFbwx1mb0cV4V6WCBskJ6
         bn8mVuj5N3ukGsofHgDQ+U62f8pyv+tnwuToBPcRuntS9bsQuHTIjoxb6c4fyGj44zYf
         a0LQ==
X-Gm-Message-State: APjAAAXfhJaNEIB9hA8IVkZSWiUt1pt82pBJ9y3rwHMfmI5AsBN8IpSD
        JOSROsnyb2UD+XYveoUKEa+dyPit
X-Google-Smtp-Source: APXvYqz/k1u2PAR3yoSiLL9gDTfHSJsyhk8Ye3uREkUwN2qTzJzAcugIvO0sGJwhfBU+xxGgxfJjZg==
X-Received: by 2002:adf:f491:: with SMTP id l17mr15704174wro.149.1576856387845;
        Fri, 20 Dec 2019 07:39:47 -0800 (PST)
Received: from [192.168.8.147] (72.173.185.81.rev.sfr.net. [81.185.173.72])
        by smtp.gmail.com with ESMTPSA id v22sm9550527wml.11.2019.12.20.07.39.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 07:39:47 -0800 (PST)
Subject: Re: [PATCH net-next v5 04/11] tcp: Add MPTCP option number
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
 <20191219223434.19722-5-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ad4295db-e219-9cf9-055a-b2319c87681c@gmail.com>
Date:   Fri, 20 Dec 2019 07:39:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219223434.19722-5-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/19 2:34 PM, Mat Martineau wrote:
> TCP option 30 is allocated for MPTCP by the IANA.
> 
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  include/net/tcp.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 86b9a8766648..d4b6bf2c5d3c 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -182,6 +182,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
>  #define TCPOPT_SACK             5       /* SACK Block */
>  #define TCPOPT_TIMESTAMP	8	/* Better RTT estimations/PAWS */
>  #define TCPOPT_MD5SIG		19	/* MD5 Signature (RFC2385) */
> +#define TCPOPT_MPTCP		30	/* Multipath TCP (RFC6824) */
>  #define TCPOPT_FASTOPEN		34	/* Fast open (RFC7413) */
>  #define TCPOPT_EXP		254	/* Experimental */
>  /* Magic number to be after the option value for sharing TCP
> 

Reviewed-by: Eric Dumazet <edumazet@google.com>
