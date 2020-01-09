Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730D0136263
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 22:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgAIVW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 16:22:59 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:46247 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgAIVW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 16:22:58 -0500
Received: by mail-il1-f194.google.com with SMTP id t17so38899ilm.13;
        Thu, 09 Jan 2020 13:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=WraloYdZdtwOOBnxS9mfcGbFdjEwYDgsrd/DfdbfkyU=;
        b=ouzldhhTo+VzZh84orsDT+6EKe8vJ8V5wn+iJl6jfbeZMcz7bMuvEqtiz/cKsuQtM6
         NeLjdlKsGhhfnQkwF4duEhm8FvFcxvSammZbUNz1BKvDYYDXVmUvMp5spJmTGFD5Xkh+
         +KoN148i9ekHT6U7iNJt9XjUTWTMeATQWZBPnAjIfRBMlFgjw5veKgMyptkXq6i1G6oK
         hVYK5DUEBFuAh2QyNvt8qh3pPxawhqipPHLTt9OIbRvTHqPW+Eszsp85Kch1GjPuWVCs
         D1a/OuUzBq0X7Nx9ZLxhjaOZB5G6RJeF/tRXR16yT7AvWhBwKzqTQ1OXD9lqh0v/AXGP
         B6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=WraloYdZdtwOOBnxS9mfcGbFdjEwYDgsrd/DfdbfkyU=;
        b=HbWpwsoTZVzDIpxOfR7OK6sBKW59RTeLVAR6oiAtXBurjVaHozYa2wOSE0vLryIME+
         crzDmUyAsss8dELgnd7tL98xxmTC0CPV0tZFSRxuuMy4XJN3e1m/04sNANHAfJ0mPsWD
         dq4w3Ue1oVJbnorH9xreAbSAcxLqqov2Dr6fCK0tRvOi9S4EOwMXHs4be0OW4clWaM8s
         AqGCncFHBOAC0gh5M9rWd3PTL5CZR7sJ2D9gcydFJTjKsz+LwZXIuB8lsNdMfTwn8GhJ
         pPX4vrpyfN0YcZQOIsmmRm2J87dLdKRt+OtT+OEoN64eY/8oPcj2K900gzjdvsjNNHOZ
         pvyw==
X-Gm-Message-State: APjAAAXqCWDsU4sEVQC3Jqwa+liZ74Gda9+/6cufa/NmVKApuxiquwuW
        D4jsCjPmA8i79QPM4dM/nadCaFNJ
X-Google-Smtp-Source: APXvYqw47TA2cvVV8aJb4Fr9g2EPKZPjT6APv7mCmh/xR3oxsmevx+sk2sLKqvHhu4yMaxz7npwjSQ==
X-Received: by 2002:a92:914a:: with SMTP id t71mr10960389ild.293.1578604977822;
        Thu, 09 Jan 2020 13:22:57 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n22sm2519iog.14.2020.01.09.13.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 13:22:57 -0800 (PST)
Date:   Thu, 09 Jan 2020 13:22:49 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Message-ID: <5e1799a913185_35982ae92e9d45bcc9@john-XPS-13-9370.notmuch>
In-Reply-To: <87tv54syv8.fsf@cloudflare.com>
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
 <157851808101.1732.11616068811837364406.stgit@ubuntu3-kvm2>
 <87tv54syv8.fsf@cloudflare.com>
Subject: Re: [bpf PATCH 3/9] bpf: sockmap/tls, push write_space updates
 through ulp updates
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Wed, Jan 08, 2020 at 10:14 PM CET, John Fastabend wrote:
> > When sockmap sock with TLS enabled is removed we cleanup bpf/psock state
> > and call tcp_update_ulp() to push updates to TLS ULP on top. However, we
> > don't push the write_space callback up and instead simply overwrite the
> > op with the psock stored previous op. This may or may not be correct so
> > to ensure we don't overwrite the TLS write space hook pass this field to
> > the ULP and have it fixup the ctx.
> >
> > This completes a previous fix that pushed the ops through to the ULP
> > but at the time missed doing this for write_space, presumably because
> > write_space TLS hook was added around the same time.
> >
> > Fixes: 95fa145479fbc ("bpf: sockmap/tls, close can race with map free")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  include/linux/skmsg.h |   12 ++++++++----
> >  include/net/tcp.h     |    6 ++++--
> >  net/ipv4/tcp_ulp.c    |    6 ++++--
> >  net/tls/tls_main.c    |   10 +++++++---
> >  4 files changed, 23 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> > index b6afe01f8592..14d61bba0b79 100644
> > --- a/include/linux/skmsg.h
> > +++ b/include/linux/skmsg.h
> > @@ -359,17 +359,21 @@ static inline void sk_psock_restore_proto(struct sock *sk,
> >  					  struct sk_psock *psock)
> >  {
> >  	sk->sk_prot->unhash = psock->saved_unhash;
> > -	sk->sk_write_space = psock->saved_write_space;
> >
> >  	if (psock->sk_proto) {
> >  		struct inet_connection_sock *icsk = inet_csk(sk);
> >  		bool has_ulp = !!icsk->icsk_ulp_data;
> >
> > -		if (has_ulp)
> > -			tcp_update_ulp(sk, psock->sk_proto);
> > -		else
> > +		if (has_ulp) {
> > +			tcp_update_ulp(sk, psock->sk_proto,
> > +				       psock->saved_write_space);
> > +		} else {
> >  			sk->sk_prot = psock->sk_proto;
> > +			sk->sk_write_space = psock->saved_write_space;
> > +		}
> 
> I'm wondering if we need the above fallback branch for no-ULP case?
> tcp_update_ulp repeats the ULP check and has the same fallback. Perhaps
> it can be reduced to:
> 
> 	if (psock->sk_proto) {
> 		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
> 		psock->sk_proto = NULL;
> 	} else {
> 		sk->sk_write_space = psock->saved_write_space;
> 	}

Yeah that is a bit nicer. How about pushing it for bpf-next? I'm not
sure its needed for bpf and the patch I pushed is the minimal change
needed for the fix and pushes the saved_write_space around.

> 
> Then there's the question if it's okay to leave psock->sk_proto set and
> potentially restore it more than once? Reading tls_update, the only user
> ULP 'update' callback, it looks fine.
> 
> Can sk_psock_restore_proto be as simple as:
> 
> static inline void sk_psock_restore_proto(struct sock *sk,
> 					  struct sk_psock *psock)
> {
> 	tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
> }
> 
> ... or am I missing something?

I think that is good. bpf-next?

> 
> Asking becuase I have a patch [0] like this in the queue and haven't
> seen issues with it during testing.

+1 Want to push it after we sort out this series?

> 
> -jkbs
> 
> [0] https://github.com/jsitnicki/linux/commit/2d2152593c8e6c5f38548796501a81a6ba20b6dc
> 
> >  		psock->sk_proto = NULL;
> > +	} else {
> > +		sk->sk_write_space = psock->saved_write_space;
> >  	}
> >  }
> >
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index e460ea7f767b..e6f48384dc71 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -2147,7 +2147,8 @@ struct tcp_ulp_ops {
> >  	/* initialize ulp */
> >  	int (*init)(struct sock *sk);
> >  	/* update ulp */
> > -	void (*update)(struct sock *sk, struct proto *p);
> > +	void (*update)(struct sock *sk, struct proto *p,
> > +		       void (*write_space)(struct sock *sk));
> >  	/* cleanup ulp */
> >  	void (*release)(struct sock *sk);
> >  	/* diagnostic */
> > @@ -2162,7 +2163,8 @@ void tcp_unregister_ulp(struct tcp_ulp_ops *type);
> >  int tcp_set_ulp(struct sock *sk, const char *name);
> >  void tcp_get_available_ulp(char *buf, size_t len);
> >  void tcp_cleanup_ulp(struct sock *sk);
> > -void tcp_update_ulp(struct sock *sk, struct proto *p);
> > +void tcp_update_ulp(struct sock *sk, struct proto *p,
> > +		    void (*write_space)(struct sock *sk));
> >
> >  #define MODULE_ALIAS_TCP_ULP(name)				\
> >  	__MODULE_INFO(alias, alias_userspace, name);		\
> > diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
> > index 12ab5db2b71c..38d3ad141161 100644
> > --- a/net/ipv4/tcp_ulp.c
> > +++ b/net/ipv4/tcp_ulp.c
> > @@ -99,17 +99,19 @@ void tcp_get_available_ulp(char *buf, size_t maxlen)
> >  	rcu_read_unlock();
> >  }
> >
> > -void tcp_update_ulp(struct sock *sk, struct proto *proto)
> > +void tcp_update_ulp(struct sock *sk, struct proto *proto,
> > +		    void (*write_space)(struct sock *sk))
> >  {
> >  	struct inet_connection_sock *icsk = inet_csk(sk);
> >
> >  	if (!icsk->icsk_ulp_ops) {
> > +		sk->sk_write_space = write_space;
> >  		sk->sk_prot = proto;
> >  		return;
> >  	}
> >
> >  	if (icsk->icsk_ulp_ops->update)
> > -		icsk->icsk_ulp_ops->update(sk, proto);
> > +		icsk->icsk_ulp_ops->update(sk, proto, write_space);
> >  }
> >
> >  void tcp_cleanup_ulp(struct sock *sk)
> > diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> > index dac24c7aa7d4..94774c0e5ff3 100644
> > --- a/net/tls/tls_main.c
> > +++ b/net/tls/tls_main.c
> > @@ -732,15 +732,19 @@ static int tls_init(struct sock *sk)
> >  	return rc;
> >  }
> >
> > -static void tls_update(struct sock *sk, struct proto *p)
> > +static void tls_update(struct sock *sk, struct proto *p,
> > +		       void (*write_space)(struct sock *sk))
> >  {
> >  	struct tls_context *ctx;
> >
> >  	ctx = tls_get_ctx(sk);
> > -	if (likely(ctx))
> > +	if (likely(ctx)) {
> > +		ctx->sk_write_space = write_space;
> >  		ctx->sk_proto = p;
> > -	else
> > +	} else {
> >  		sk->sk_prot = p;
> > +		sk->sk_write_space = write_space;
> > +	}
> >  }
> >
> >  static int tls_get_info(const struct sock *sk, struct sk_buff *skb)


