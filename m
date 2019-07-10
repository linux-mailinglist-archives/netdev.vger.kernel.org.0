Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08AF263FAB
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 05:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfGJDjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 23:39:35 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45697 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfGJDje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 23:39:34 -0400
Received: by mail-io1-f67.google.com with SMTP id g20so1571905ioc.12;
        Tue, 09 Jul 2019 20:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=vkNxhhQqx2DW45+FHUIITX7YT1t53rI6RXHcYiqJqUY=;
        b=Gai7FgBXUObMFo5yxa6ei+wlGGkCup2IlAsRVx2gdETCfRDXr0APA+24yIuewcqbop
         bTr1mMCVSR85ixRdN8cw+z2BAsjFFyT0/b8kfxD83Klk0lClbPTmrT8cuYtUpqKQacxv
         XFvuR/m/9sTjiNA/sv8nOJ1CkKOfx4uVfcVmlKVB6aJ6zMxDcmgTYWqE5lrZ9f2D1N/s
         Tb55zA6rXZKzikPzq04I1YC+juPaq3tV25cHWIqYzQ7/ChHQ71C7q2KM94bMnmpYGJyh
         HadTVbRuqHkYmv+1aKIbgbX3jIFjYCMcE2sU9H17mGZ0oWLbhVKY+FK5iK6Iy0ajyobE
         gtTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=vkNxhhQqx2DW45+FHUIITX7YT1t53rI6RXHcYiqJqUY=;
        b=f2GWS/iBKejF5LON4pfe/dSKsQiGWkn0ebU3+rndkZSmWIJ3BWKRyZH06Zte1BJ41b
         7Iri6YkHM6Uaq+fSxiutFMQhFIEzIOycE4ByMGUySCVQDXgBYrpvsjhUcyyJGvq236YI
         8+U599wjsozPm0hd+eXlAFeF77poI1wVLyCd+zwqSoKLDiK1FZb9iUWtbPDOL7eel+J/
         7oTFD5homI40qd5i90vocODHgWjX+2SQVyCDYIbI098Z0XP0ttHfEFk+Welwgx+NKyh9
         waiwH7jr/F0DEUdO6cfap3jmY5RJcFgyS88/+yOz3XgTiamZzduXxaw+kl/T3Tfdlb5m
         Dzww==
X-Gm-Message-State: APjAAAUrBrIPq1+oumgNP3w8T2olPWJ8Sk+2MdSLLWVzBdzt9Gs1FR+J
        JIXV4PGthtnRG4nwU6DqfAM=
X-Google-Smtp-Source: APXvYqxKBBKdf5Rv/MFREUAYs4D56vMeUuLkn1LIREaOMxu0g3X3ef7J+Mulg9G7PYDlh7uZJs6lEA==
X-Received: by 2002:a5d:9d42:: with SMTP id k2mr10439691iok.45.1562729973786;
        Tue, 09 Jul 2019 20:39:33 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m10sm1286950ioj.75.2019.07.09.20.39.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 20:39:33 -0700 (PDT)
Date:   Tue, 09 Jul 2019 20:39:24 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Message-ID: <5d255dececd33_1b7a2aec940d65b45@john-XPS-13-9370.notmuch>
In-Reply-To: <20190709194525.0d4c15a6@cakuba.netronome.com>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
 <156261324561.31108.14410711674221391677.stgit@ubuntu3-kvm1>
 <20190709194525.0d4c15a6@cakuba.netronome.com>
Subject: Re: [bpf PATCH v2 2/6] bpf: tls fix transition through disconnect
 with close
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Mon, 08 Jul 2019 19:14:05 +0000, John Fastabend wrote:
> > @@ -287,6 +313,27 @@ static void tls_sk_proto_cleanup(struct sock *sk,
> >  #endif
> >  }
> >  
> > +static void tls_sk_proto_unhash(struct sock *sk)
> > +{
> > +	struct inet_connection_sock *icsk = inet_csk(sk);
> > +	long timeo = sock_sndtimeo(sk, 0);
> > +	struct tls_context *ctx;
> > +
> > +	if (unlikely(!icsk->icsk_ulp_data)) {
> 
> Is this for when sockmap is stacked on top of TLS and TLS got removed
> without letting sockmap know?

Right its a pattern I used on the sockmap side and put here. But
I dropped the patch to let sockmap stack on top of TLS because
it was more than a fix IMO. We could probably drop this check on
the other hand its harmless.
> 
> > +		if (sk->sk_prot->unhash)
> > +			sk->sk_prot->unhash(sk);
> > +	}
> > +
> > +	ctx = tls_get_ctx(sk);
> > +	if (ctx->tx_conf == TLS_SW || ctx->rx_conf == TLS_SW)
> > +		tls_sk_proto_cleanup(sk, ctx, timeo);
> > +	icsk->icsk_ulp_data = NULL;
> 
> I think close only starts checking if ctx is NULL in patch 6.
> Looks like some chunks of ctx checking/clearing got spread to
> patch 1 and some to patch 6.

Yeah, I thought the patches were easier to read this way but
maybe not. Could add something in the commit log.

> 
> > +	tls_ctx_free_wq(ctx);
> > +
> > +	if (ctx->unhash)
> > +		ctx->unhash(sk);
> > +}
> > +
> >  static void tls_sk_proto_close(struct sock *sk, long timeout)
> >  {
> >  	struct tls_context *ctx = tls_get_ctx(sk);
> 


