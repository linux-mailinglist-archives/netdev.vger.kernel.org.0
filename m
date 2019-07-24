Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A227312F
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 16:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387426AbfGXOJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 10:09:44 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44338 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbfGXOJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 10:09:43 -0400
Received: by mail-qk1-f194.google.com with SMTP id d79so33788164qke.11;
        Wed, 24 Jul 2019 07:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mymZsatmiZj2HO1rrAnVH77ZT9rCEUe6Woe+bb611d8=;
        b=LG/wguG5BSWNMDO4csWKUQ+zclt6MI1ZVC2PMK48Q01fpCUhxnLzF+SB4Zr8uCCDKw
         itoH7kHCcaFYsFnQJdy0gMhH3NVuk8cStO7HnA4PRVWHi5PuHBSbGi+vJsyD39UWf3zO
         KOgG5f/dv6wQBhFai8FMKTDrxubgWNtmUxWp3AA8dAeijmMafCMWvopXiN1sQ9VSQ64E
         U5gROYczSh5jHdGKhYkm9m0Ex2osA/i1EI+nUMk5XsG+jpVBGfUwUhm742G/y5NOwYTu
         HPEZPurKxyjxbWJXIBAOM39hx2Qh4wRxUzLUR5SXl6YCMy+2R9DTIHPXv9fQuT3pAkKh
         jJ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mymZsatmiZj2HO1rrAnVH77ZT9rCEUe6Woe+bb611d8=;
        b=rREnfVfG9/RzlRFEUHvBcYkgj6MXHjXA/uDvo2V2BCczRL/vzqCvLGOh2NrsyCkiVn
         ZinE8fG4JhwYs27JsQO+CF/DfBx8pMgISP9/LAYti2Y+0A41b7s30DB5OEaHf8rbwPzX
         5amCCOKPeMFspOI/HbLuT+i6+eUwsCLCBVvMCdaDbEjppZ/owwcJJ54aiBpwroV1eUUd
         HYiEn+tka/KOCilCjPaIKsAU7cpyYr4Cv6HPfB6hfKtInP+vl2kIvfN0MLyu8iXg+6X7
         LQckjvVxJ6ka9fk5ouv2sB0C0+b4DhyHOk8EgvcmYJgu69YjKJegVwUgDm2JE1mvUaGZ
         vQCw==
X-Gm-Message-State: APjAAAWp8nPpBneFjHeDQTbQI1TDJBwdNhybDYkj/+Fr9whTaqDFifg+
        F9tqkTtxylgujIpz5lo4wSc=
X-Google-Smtp-Source: APXvYqx3nGgL15xJdBo3POltz3ca97eG5mgkZEjoFEZmzdFuKkW481p8s/PAH2XonPU2iwwdktKT+w==
X-Received: by 2002:a37:9a4a:: with SMTP id c71mr21830405qke.258.1563977382336;
        Wed, 24 Jul 2019 07:09:42 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.45])
        by smtp.gmail.com with ESMTPSA id c20sm14679798qkk.69.2019.07.24.07.09.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 07:09:41 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id E8D27C0AAD; Wed, 24 Jul 2019 11:09:38 -0300 (-03)
Date:   Wed, 24 Jul 2019 11:09:38 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: Re: [PATCH net-next 2/4] sctp: clean up __sctp_connect
Message-ID: <20190724140938.GF6204@localhost.localdomain>
References: <cover.1563817029.git.lucien.xin@gmail.com>
 <0a87c3c2c48b10a930205d413a160854032eaa4a.1563817029.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a87c3c2c48b10a930205d413a160854032eaa4a.1563817029.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 01:37:58AM +0800, Xin Long wrote:
> __sctp_connect is doing quit similar things as sctp_sendmsg_new_asoc.
> To factor out common functions, this patch is to clean up their code
> to make them look more similar:
> 
>   1. create the asoc and add a peer with the 1st addr.
>   2. add peers with the other addrs into this asoc one by one.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/socket.c | 211 +++++++++++++++++++-----------------------------------
>  1 file changed, 75 insertions(+), 136 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 5f92e4a..49837e9 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1049,154 +1049,108 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>   * Common routine for handling connect() and sctp_connectx().
>   * Connect will come in with just a single address.
>   */
> -static int __sctp_connect(struct sock *sk,
> -			  struct sockaddr *kaddrs,
> -			  int addrs_size, int flags,
> -			  sctp_assoc_t *assoc_id)
> +static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
> +			  int addrs_size, int flags, sctp_assoc_t *assoc_id)
>  {
> -	struct net *net = sock_net(sk);
> -	struct sctp_sock *sp;
> -	struct sctp_endpoint *ep;
> -	struct sctp_association *asoc = NULL;
> -	struct sctp_association *asoc2;
> +	struct sctp_association *old, *asoc;
> +	struct sctp_sock *sp = sctp_sk(sk);
> +	struct sctp_endpoint *ep = sp->ep;
>  	struct sctp_transport *transport;
> -	union sctp_addr to;
> +	struct net *net = sock_net(sk);
> +	int addrcnt, walk_size, err;
> +	void *addr_buf = kaddrs;
> +	union sctp_addr *daddr;
>  	enum sctp_scope scope;
> +	struct sctp_af *af;
>  	long timeo;
> -	int err = 0;
> -	int addrcnt = 0;
> -	int walk_size = 0;
> -	union sctp_addr *sa_addr = NULL;
> -	void *addr_buf;
> -	unsigned short port;
>  
> -	sp = sctp_sk(sk);
> -	ep = sp->ep;
> -
> -	/* connect() cannot be done on a socket that is already in ESTABLISHED
> -	 * state - UDP-style peeled off socket or a TCP-style socket that
> -	 * is already connected.
> -	 * It cannot be done even on a TCP-style listening socket.
> -	 */
>  	if (sctp_sstate(sk, ESTABLISHED) || sctp_sstate(sk, CLOSING) ||
> -	    (sctp_style(sk, TCP) && sctp_sstate(sk, LISTENING))) {
> -		err = -EISCONN;
> -		goto out_free;
> +	    (sctp_style(sk, TCP) && sctp_sstate(sk, LISTENING)))
> +		return -EISCONN;
> +
> +	daddr = addr_buf;
> +	af = sctp_get_af_specific(daddr->sa.sa_family);
> +	if (!af || af->sockaddr_len > addrs_size)
> +		return -EINVAL;
> +
> +	err = sctp_verify_addr(sk, daddr, af->sockaddr_len);
> +	if (err)
> +		return err;
> +
> +	asoc = sctp_endpoint_lookup_assoc(ep, daddr, &transport);
> +	if (asoc)
> +		return asoc->state >= SCTP_STATE_ESTABLISHED ? -EISCONN
> +							     : -EALREADY;
> +
> +	if (sctp_endpoint_is_peeled_off(ep, daddr))
> +		return -EADDRNOTAVAIL;
> +
> +	if (!ep->base.bind_addr.port) {
> +		if (sctp_autobind(sk))
> +			return -EAGAIN;
> +	} else {
> +		if (ep->base.bind_addr.port < inet_prot_sock(net) &&
> +		    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
> +			return -EACCES;
>  	}
>  
> -	/* Walk through the addrs buffer and count the number of addresses. */
> -	addr_buf = kaddrs;
> -	while (walk_size < addrs_size) {
> -		struct sctp_af *af;
> +	scope = sctp_scope(daddr);
> +	asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
> +	if (!asoc)
> +		return -ENOMEM;
>  
> -		if (walk_size + sizeof(sa_family_t) > addrs_size) {
> -			err = -EINVAL;
> -			goto out_free;
> -		}
> +	err = sctp_assoc_set_bind_addr_from_ep(asoc, scope, GFP_KERNEL);
> +	if (err < 0)
> +		goto out_free;
>  
> -		sa_addr = addr_buf;
> -		af = sctp_get_af_specific(sa_addr->sa.sa_family);
> +	transport = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL, SCTP_UNKNOWN);
> +	if (!transport) {
> +		err = -ENOMEM;
> +		goto out_free;
> +	}
>  
> -		/* If the address family is not supported or if this address
> -		 * causes the address buffer to overflow return EINVAL.
> -		 */
> -		if (!af || (walk_size + af->sockaddr_len) > addrs_size) {
> -			err = -EINVAL;
> +	addr_buf += af->sockaddr_len;
> +	walk_size = af->sockaddr_len;
> +	addrcnt = 1;

This variable can be removed (in a follow-up patch). It's only
incremented and never used other than that.

> +	while (walk_size < addrs_size) {
> +		err = -EINVAL;
> +		if (walk_size + sizeof(sa_family_t) > addrs_size)
>  			goto out_free;
> -		}
> -
> -		port = ntohs(sa_addr->v4.sin_port);
>  
> -		/* Save current address so we can work with it */
> -		memcpy(&to, sa_addr, af->sockaddr_len);
> +		daddr = addr_buf;
> +		af = sctp_get_af_specific(daddr->sa.sa_family);
> +		if (!af || af->sockaddr_len + walk_size > addrs_size)
> +			goto out_free;
>  
> -		err = sctp_verify_addr(sk, &to, af->sockaddr_len);
> -		if (err)
> +		if (asoc->peer.port != ntohs(daddr->v4.sin_port))
>  			goto out_free;
>  
> -		/* Make sure the destination port is correctly set
> -		 * in all addresses.
> -		 */
> -		if (asoc && asoc->peer.port && asoc->peer.port != port) {
> -			err = -EINVAL;
> +		err = sctp_verify_addr(sk, daddr, af->sockaddr_len);
> +		if (err)
>  			goto out_free;
> -		}
>  
> -		/* Check if there already is a matching association on the
> -		 * endpoint (other than the one created here).
> -		 */
> -		asoc2 = sctp_endpoint_lookup_assoc(ep, &to, &transport);
> -		if (asoc2 && asoc2 != asoc) {
> -			if (asoc2->state >= SCTP_STATE_ESTABLISHED)
> -				err = -EISCONN;
> -			else
> -				err = -EALREADY;
> +		old = sctp_endpoint_lookup_assoc(ep, daddr, &transport);
> +		if (old && old != asoc) {
> +			err = old->state >= SCTP_STATE_ESTABLISHED ? -EISCONN
> +								   : -EALREADY;
>  			goto out_free;
>  		}
>  
> -		/* If we could not find a matching association on the endpoint,
> -		 * make sure that there is no peeled-off association matching
> -		 * the peer address even on another socket.
> -		 */
> -		if (sctp_endpoint_is_peeled_off(ep, &to)) {
> +		if (sctp_endpoint_is_peeled_off(ep, daddr)) {
>  			err = -EADDRNOTAVAIL;
>  			goto out_free;
>  		}
>  
> -		if (!asoc) {
> -			/* If a bind() or sctp_bindx() is not called prior to
> -			 * an sctp_connectx() call, the system picks an
> -			 * ephemeral port and will choose an address set
> -			 * equivalent to binding with a wildcard address.
> -			 */
> -			if (!ep->base.bind_addr.port) {
> -				if (sctp_autobind(sk)) {
> -					err = -EAGAIN;
> -					goto out_free;
> -				}
> -			} else {
> -				/*
> -				 * If an unprivileged user inherits a 1-many
> -				 * style socket with open associations on a
> -				 * privileged port, it MAY be permitted to
> -				 * accept new associations, but it SHOULD NOT
> -				 * be permitted to open new associations.
> -				 */
> -				if (ep->base.bind_addr.port <
> -				    inet_prot_sock(net) &&
> -				    !ns_capable(net->user_ns,
> -				    CAP_NET_BIND_SERVICE)) {
> -					err = -EACCES;
> -					goto out_free;
> -				}
> -			}
> -
> -			scope = sctp_scope(&to);
> -			asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
> -			if (!asoc) {
> -				err = -ENOMEM;
> -				goto out_free;
> -			}
> -
> -			err = sctp_assoc_set_bind_addr_from_ep(asoc, scope,
> -							      GFP_KERNEL);
> -			if (err < 0) {
> -				goto out_free;
> -			}
> -
> -		}
> -
> -		/* Prime the peer's transport structures.  */
> -		transport = sctp_assoc_add_peer(asoc, &to, GFP_KERNEL,
> +		transport = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL,
>  						SCTP_UNKNOWN);
>  		if (!transport) {
>  			err = -ENOMEM;
>  			goto out_free;
>  		}
>  
> -		addrcnt++;
> -		addr_buf += af->sockaddr_len;
> +		addr_buf  += af->sockaddr_len;
>  		walk_size += af->sockaddr_len;
> +		addrcnt++;
>  	}
>  
>  	/* In case the user of sctp_connectx() wants an association
> @@ -1209,39 +1163,24 @@ static int __sctp_connect(struct sock *sk,
>  	}
>  
>  	err = sctp_primitive_ASSOCIATE(net, asoc, NULL);
> -	if (err < 0) {
> +	if (err < 0)
>  		goto out_free;
> -	}
>  
>  	/* Initialize sk's dport and daddr for getpeername() */
>  	inet_sk(sk)->inet_dport = htons(asoc->peer.port);
> -	sp->pf->to_sk_daddr(sa_addr, sk);
> +	sp->pf->to_sk_daddr(daddr, sk);
>  	sk->sk_err = 0;
>  
> -	timeo = sock_sndtimeo(sk, flags & O_NONBLOCK);
> -
>  	if (assoc_id)
>  		*assoc_id = asoc->assoc_id;
>  
> -	err = sctp_wait_for_connect(asoc, &timeo);
> -	/* Note: the asoc may be freed after the return of
> -	 * sctp_wait_for_connect.
> -	 */
> -
> -	/* Don't free association on exit. */
> -	asoc = NULL;
> +	timeo = sock_sndtimeo(sk, flags & O_NONBLOCK);
> +	return sctp_wait_for_connect(asoc, &timeo);
>  
>  out_free:
>  	pr_debug("%s: took out_free path with asoc:%p kaddrs:%p err:%d\n",
>  		 __func__, asoc, kaddrs, err);
> -
> -	if (asoc) {
> -		/* sctp_primitive_ASSOCIATE may have added this association
> -		 * To the hash table, try to unhash it, just in case, its a noop
> -		 * if it wasn't hashed so we're safe
> -		 */
> -		sctp_association_free(asoc);
> -	}
> +	sctp_association_free(asoc);
>  	return err;
>  }
>  
> -- 
> 2.1.0
> 
