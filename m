Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F682B1178
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 16:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732812AbfILOvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 10:51:52 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39239 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732444AbfILOvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 10:51:52 -0400
Received: by mail-qk1-f195.google.com with SMTP id 4so24722387qki.6;
        Thu, 12 Sep 2019 07:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=flpHUM3jIkqI5icvoEOQORa60za63cCS1Ns8QwP4lnY=;
        b=ky9CpUPU47G6GUX0BIje7EzJ/ntOeM73UZXhIwpoeyGviRskd/VkQIsgCQdbWfYSHA
         wWE31DHF63FaXtmgpLeifzIb/9R+pAq0NQVsgZCwiJvhWAP6DKOJx/Qfyt8c18q86epS
         wX5ufGJ3GT+l0wZ4XhmRMiL98M4qiAkFvxPNrjNlO8hLvXg1TmzNyX/6Iui95Y85WF2s
         AxjOWrpVcXjOY8YUxQ5iJG1cLaqh1P18RoM9r8rtwOIBFG0cwSdeQX+i7Fa7CvXLZ9sw
         NDeYYTlS6R+cR/Uj2tw5U+D8DOnz1WiiwwGa+/2gnS4CnEjJb7ecnmBSIqq/but5Vyyh
         0yYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=flpHUM3jIkqI5icvoEOQORa60za63cCS1Ns8QwP4lnY=;
        b=ckNlRN3W6H5WWx+itME4H+XUtKQXk/YkL0ITnaxTguHbIh/hoUWnn19ueOXRVmGP54
         kO+Hn4dT7o0URks8XKmnNq2eZyYPjBYGxwVbIz3KYEu/BnzaxQP8OuTIBekyzgMLj05t
         raDtwlooohGW+cx+XED/Y/KegsO2INMhQrfFxbnVV0rEuwPLjUrfsUMumqFMbFhi/8ZR
         J+JKYnu5rPdpIC3/YBCGhcBez36eC6ckZMM6or4Fd2pbA0oTEiCylbRQ6snP0seJdNr0
         fNsBKRB/2uPohBwhppNrkwCuNXuAeX5nAZbh9jLxwG3flZQHQTdhvjXnTWsc5DoZakkP
         0Rcw==
X-Gm-Message-State: APjAAAUXIUm6SFfM4R4Fvix4dwCrRcZHNZd+PzzSTgDh2lFY/Gfa1xxA
        skg+lRvVWNYnVUeNkd/4e+Y=
X-Google-Smtp-Source: APXvYqwJjh6Ss0MSjgLzgAgt6qtY9jxy5QyWWaHHI+LEeuXS7W9KlLQgPjzbQnd6rbfA74odGYvx5Q==
X-Received: by 2002:a37:a586:: with SMTP id o128mr21410644qke.147.1568299910876;
        Thu, 12 Sep 2019 07:51:50 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.89])
        by smtp.gmail.com with ESMTPSA id o124sm11916258qke.66.2019.09.12.07.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 07:51:50 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 81A51C0DAD; Thu, 12 Sep 2019 11:51:47 -0300 (-03)
Date:   Thu, 12 Sep 2019 11:51:47 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net 1/3] sctp: change return type of
 sctp_get_port_local
Message-ID: <20190912145147.GR3431@localhost.localdomain>
References: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
 <20190912040219.67517-1-maowenan@huawei.com>
 <20190912040219.67517-2-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912040219.67517-2-maowenan@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 12, 2019 at 12:02:17PM +0800, Mao Wenan wrote:
> Currently sctp_get_port_local() returns a long
> which is either 0,1 or a pointer casted to long.
> It's neither of the callers use the return value since
> commit 62208f12451f ("net: sctp: simplify sctp_get_port").
> Now two callers are sctp_get_port and sctp_do_bind,
> they actually assumend a casted to an int was the same as
> a pointer casted to a long, and they don't save the return
> value just check whether it is zero or non-zero, so
> it would better change return type from long to int for
> sctp_get_port_local.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

This Fixes tag is not needed. It's just a cleanup.
Maybe Dave can remove it for us.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks.

> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  net/sctp/socket.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 9d1f83b10c0a..5e1934c48709 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -309,7 +309,7 @@ static int sctp_bind(struct sock *sk, struct sockaddr *addr, int addr_len)
>  	return retval;
>  }
>  
> -static long sctp_get_port_local(struct sock *, union sctp_addr *);
> +static int sctp_get_port_local(struct sock *, union sctp_addr *);
>  
>  /* Verify this is a valid sockaddr. */
>  static struct sctp_af *sctp_sockaddr_af(struct sctp_sock *opt,
> @@ -7998,7 +7998,7 @@ static void sctp_unhash(struct sock *sk)
>  static struct sctp_bind_bucket *sctp_bucket_create(
>  	struct sctp_bind_hashbucket *head, struct net *, unsigned short snum);
>  
> -static long sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
> +static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
>  {
>  	struct sctp_sock *sp = sctp_sk(sk);
>  	bool reuse = (sk->sk_reuse || sp->reuse);
> @@ -8108,7 +8108,7 @@ static long sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
>  
>  			if (sctp_bind_addr_conflict(&ep2->base.bind_addr,
>  						    addr, sp2, sp)) {
> -				ret = (long)sk2;
> +				ret = 1;
>  				goto fail_unlock;
>  			}
>  		}
> @@ -8180,7 +8180,7 @@ static int sctp_get_port(struct sock *sk, unsigned short snum)
>  	addr.v4.sin_port = htons(snum);
>  
>  	/* Note: sk->sk_num gets filled in if ephemeral port request. */
> -	return !!sctp_get_port_local(sk, &addr);
> +	return sctp_get_port_local(sk, &addr);
>  }
>  
>  /*
> -- 
> 2.20.1
> 
