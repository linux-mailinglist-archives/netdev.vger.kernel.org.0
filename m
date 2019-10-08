Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 347A6CF9A9
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730710AbfJHMVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:21:36 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35298 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730316AbfJHMVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 08:21:36 -0400
Received: by mail-qt1-f193.google.com with SMTP id m15so24956759qtq.2;
        Tue, 08 Oct 2019 05:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fo9jaBQ7TxPfuSklVvOpFJysct6r8/4i1fi8AxuAvGk=;
        b=U44GSjVzfrgL4olKGCzZKY0vEvBN6C0Z8pcKpUPzYpDvvQfk2miuYUpRB8/13tgL2a
         XPIIDRbfIsltPIkQDpgL5XVPJgu78hM6E9SqQMZkTCvfdn9xfSXPbP2YWLLRlcYrVNZ0
         UsbgmNtDT2ltEonTiveS9ZVkPM29LR6Oe8lNcL65oTFIr0nzeIyJCF8JqyWhuX+/ZB0a
         MtdnfWyC7QEl+O5Ykxt4/20tRcimntpz4jiGQ7YtLV6QTCvKe0+3CN07GCXMvCkBBLvM
         6VLBsy/Oh7c5aKwEvijW09IqRnKh6wmR2kYu1S94hLmb1lVL1E3cqCyrEQpMSL1GmNid
         kCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fo9jaBQ7TxPfuSklVvOpFJysct6r8/4i1fi8AxuAvGk=;
        b=sQ4LT4eORbNeXUgPHks/tjd173t4LuPitVcCrxSwoP7Oi/vyi1cmewPSspGlHbcNaX
         InQjqxxIUTOrFDdaLpt+10rDt94NyrOxSnSdp/20SqZltck9Brso3153ZaF8cG18toiV
         +M7H3vjg27H9OZlMdTTY748WyX6X/dj7a8cscdYjuTKsJ5LSIx6s10ZYeL/ifZ+rWXbQ
         2a1s2o9CJ/f+/lDsYxi+pissfWa3CD4tgEULAagz8kPxGTal5rSuApW7vSW7JRGphvjJ
         JrWKWTv7PtgZH76nYRkzB+VMCh4i/bP8cns6csOW6Hy9NiSRj0SfsJQBcGjHus54lbOW
         0PbQ==
X-Gm-Message-State: APjAAAXFAk85H6lF7+VaBgDC2jm32uaRlF1AIrlwxh9nrjOWcnZOHLZX
        ROjDJHaDPL/DE8CAEpaV3JjVPyJUsIs=
X-Google-Smtp-Source: APXvYqz8/fcjbqVMyYaFPWjRR3oBEa7jwZ2UjSIpxIw3xzGEtAxWD6GDVP8x8rDxBU7OdMIPqo2asQ==
X-Received: by 2002:ac8:2eaa:: with SMTP id h39mr35541315qta.389.1570537293544;
        Tue, 08 Oct 2019 05:21:33 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f028:9747:1eea:8fc6:8bb2:db7c])
        by smtp.gmail.com with ESMTPSA id u123sm8812399qkh.120.2019.10.08.05.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 05:21:32 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 71C5DC07B5; Tue,  8 Oct 2019 09:21:30 -0300 (-03)
Date:   Tue, 8 Oct 2019 09:21:30 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>,
        omosnace@redhat.com
Subject: Re: [PATCH net] sctp: add chunks to sk_backlog when the newsk
 sk_socket is not set
Message-ID: <20191008122130.GS3431@localhost.localdomain>
References: <d8dd0065232e5c3629bf55e54e3a998110ec1aef.1570532963.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8dd0065232e5c3629bf55e54e3a998110ec1aef.1570532963.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 07:09:23PM +0800, Xin Long wrote:
> This patch is to fix a NULL-ptr deref in selinux_socket_connect_helper:
> 
>   [...] kasan: GPF could be caused by NULL-ptr deref or user memory access
>   [...] RIP: 0010:selinux_socket_connect_helper+0x94/0x460
>   [...] Call Trace:
>   [...]  selinux_sctp_bind_connect+0x16a/0x1d0
>   [...]  security_sctp_bind_connect+0x58/0x90
>   [...]  sctp_process_asconf+0xa52/0xfd0 [sctp]
>   [...]  sctp_sf_do_asconf+0x785/0x980 [sctp]
>   [...]  sctp_do_sm+0x175/0x5a0 [sctp]
>   [...]  sctp_assoc_bh_rcv+0x285/0x5b0 [sctp]
>   [...]  sctp_backlog_rcv+0x482/0x910 [sctp]
>   [...]  __release_sock+0x11e/0x310
>   [...]  release_sock+0x4f/0x180
>   [...]  sctp_accept+0x3f9/0x5a0 [sctp]
>   [...]  inet_accept+0xe7/0x720
> 
> It was caused by that the 'newsk' sk_socket was not set before going to
> security sctp hook when processing asconf chunk with SCTP_PARAM_ADD_IP
> or SCTP_PARAM_SET_PRIMARY:
> 
>   inet_accept()->
>     sctp_accept():
>       lock_sock():
>           lock listening 'sk'
>                                           do_softirq():
>                                             sctp_rcv():  <-- [1]
>                                                 asconf chunk arrives and
>                                                 enqueued in 'sk' backlog
>       sctp_sock_migrate():
>           set asoc's sk to 'newsk'
>       release_sock():
>           sctp_backlog_rcv():
>             lock 'newsk'
>             sctp_process_asconf()  <-- [2]
>             unlock 'newsk'
>     sock_graft():
>         set sk_socket  <-- [3]
> 
> As it shows, at [1] the asconf chunk would be put into the listening 'sk'
> backlog, as accept() was holding its sock lock. Then at [2] asconf would
> get processed with 'newsk' as asoc's sk had been set to 'newsk'. However,
> 'newsk' sk_socket is not set until [3], while selinux_sctp_bind_connect()
> would deref it, then kernel crashed.
> 
> Here to fix it by adding the chunk to sk_backlog until newsk sk_socket is
> set when .accept() is done.
> 
> Note that sk->sk_socket can be NULL when the sock is closed, so SOCK_DEAD
> flag is also needed to check in sctp_newsk_ready().
> 
> Thanks to Ondrej for reviewing the code.
> 
> Fixes: d452930fd3b9 ("selinux: Add SCTP support")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks Xin.

> ---
>  include/net/sctp/sctp.h |  5 +++++
>  net/sctp/input.c        | 12 +++++++++---
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> index 5d60f13..3ab5c6b 100644
> --- a/include/net/sctp/sctp.h
> +++ b/include/net/sctp/sctp.h
> @@ -610,4 +610,9 @@ static inline __u32 sctp_min_frag_point(struct sctp_sock *sp, __u16 datasize)
>  	return sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT, datasize);
>  }
>  
> +static inline bool sctp_newsk_ready(const struct sock *sk)
> +{
> +	return sock_flag(sk, SOCK_DEAD) || sk->sk_socket;
> +}
> +
>  #endif /* __net_sctp_h__ */
> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 5a070fb..f277137 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -243,7 +243,7 @@ int sctp_rcv(struct sk_buff *skb)
>  		bh_lock_sock(sk);
>  	}
>  
> -	if (sock_owned_by_user(sk)) {
> +	if (sock_owned_by_user(sk) || !sctp_newsk_ready(sk)) {
>  		if (sctp_add_backlog(sk, skb)) {
>  			bh_unlock_sock(sk);
>  			sctp_chunk_free(chunk);
> @@ -321,7 +321,7 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb)
>  		local_bh_disable();
>  		bh_lock_sock(sk);
>  
> -		if (sock_owned_by_user(sk)) {
> +		if (sock_owned_by_user(sk) || !sctp_newsk_ready(sk)) {
>  			if (sk_add_backlog(sk, skb, sk->sk_rcvbuf))
>  				sctp_chunk_free(chunk);
>  			else
> @@ -336,7 +336,13 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb)
>  		if (backloged)
>  			return 0;
>  	} else {
> -		sctp_inq_push(inqueue, chunk);
> +		if (!sctp_newsk_ready(sk)) {
> +			if (!sk_add_backlog(sk, skb, sk->sk_rcvbuf))
> +				return 0;
> +			sctp_chunk_free(chunk);
> +		} else {
> +			sctp_inq_push(inqueue, chunk);
> +		}
>  	}
>  
>  done:
> -- 
> 2.1.0
> 
