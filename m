Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565F41F7F48
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 00:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgFLWxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 18:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgFLWxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 18:53:07 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15667C03E96F;
        Fri, 12 Jun 2020 15:53:07 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e18so4790411pgn.7;
        Fri, 12 Jun 2020 15:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=asGwvdUrTjw8DorufZbYD6ASVjYTNUZUj3WddLs7tLc=;
        b=NvMCchhChQweyJ/aUDC5d9dd8HfY71ySLHinqAoVnwRXavWngxHk5aGPik8xhVRy3t
         wzTsxAD/OJ2SOQvOaLg4Go7U7oWrYBSaHWCpy8qxQU1U/SrQApMSWBIMMWEiWBTC+kcs
         bQsnmyf9+sA/2KRmzOy9zuXwWbRWnJw6m5L2JoSbdblSHeKYYpgAgXErYaL0g8/B5Ehz
         KAGPQeOAmzs/Smr21NfODwEVZGjnuB0dCU2FH0pY/adp0BMB7buOeAEIKmAbTVx5LrXb
         DKff9HTjqRRZcmx1YIwjaOV9pFNgq2ohFREwL/fxMfyh9vRj81qm1sbjY0Oy2ZoP7kRG
         O9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=asGwvdUrTjw8DorufZbYD6ASVjYTNUZUj3WddLs7tLc=;
        b=auvoaRweom07VRHY2id9Dzz+vDQCLf8JNijVFcGnfZw8PW9iM52BLTsI0LCI5/Y8BT
         gZsID5Rqx2FDn7BpdfhENQ4Rl5z4gE+gRPmegntAtzqhsXuyv6f1tyj0P9vPhiqSRgRf
         TIoJxEY1H4QnlvvDZMdgVRXzW3EFcMK1FAECoVS1geSOJHNTKvVcztwdvTc+812q0jEZ
         kyA9DalBN7IIYBxNuNMVR+gUI6GR4zxX+KtqKwDukNTyu3+1hBHzZRCJUGTlDOxXB9Tv
         4IPLlTlcGxJ9RCOzlqwXkpIOXWN9lAPc63z+KwukGBuUeu24XRk3vlewCTtGU7cA6v35
         HlHg==
X-Gm-Message-State: AOAM533Izbrj+oLXPdjj2koCMBiyznlom2s6VMG28oD4Sq047YDU2k0a
        yqTBts9X/ipbRJBqXZlPv34=
X-Google-Smtp-Source: ABdhPJxJ7ubKRu/WrypYHAj4tnKQ75B3qrAd109dQzRW2f/ksASjEsw1ln6yDUTY0jPlWYKM1Dh/bA==
X-Received: by 2002:a65:4c8a:: with SMTP id m10mr12451873pgt.138.1592002386574;
        Fri, 12 Jun 2020 15:53:06 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id nl5sm6912704pjb.36.2020.06.12.15.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 15:53:05 -0700 (PDT)
Date:   Fri, 12 Jun 2020 15:52:55 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Network Development <netdev@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>
Message-ID: <5ee40747b71ee_489d2af902f845b45d@john-XPS-13-9370.notmuch>
In-Reply-To: <CAADnVQKYHg-ZmzEibZ7TtZdyfNK+r7FQfv_DuJK44LdRuATDGw@mail.gmail.com>
References: <26038a28c21fea5d04d4bd4744c5686d3f2e5504.1591784177.git.sd@queasysnail.net>
 <20200612121526.4810a073@toad>
 <CAADnVQKYHg-ZmzEibZ7TtZdyfNK+r7FQfv_DuJK44LdRuATDGw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: tcp: recv() should return 0 when the peer socket
 is closed
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Fri, Jun 12, 2020 at 3:18 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >
> > On Wed, 10 Jun 2020 12:19:43 +0200
> > Sabrina Dubroca <sd@queasysnail.net> wrote:
> >
> > > If the peer is closed, we will never get more data, so
> > > tcp_bpf_wait_data will get stuck forever. In case we passed
> > > MSG_DONTWAIT to recv(), we get EAGAIN but we should actually get
> > > 0.
> > >
> > > From man 2 recv:
> > >
> > >     RETURN VALUE
> > >
> > >     When a stream socket peer has performed an orderly shutdown, the
> > >     return value will be 0 (the traditional "end-of-file" return).
> > >
> > > This patch makes tcp_bpf_wait_data always return 1 when the peer
> > > socket has been shutdown. Either we have data available, and it would
> > > have returned 1 anyway, or there isn't, in which case we'll call
> > > tcp_recvmsg which does the right thing in this situation.
> > >
> > > Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> > > Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> > > ---
> > >  net/ipv4/tcp_bpf.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> > > index 2b915aafda42..7aa68f4aae6c 100644
> > > --- a/net/ipv4/tcp_bpf.c
> > > +++ b/net/ipv4/tcp_bpf.c
> > > @@ -245,6 +245,9 @@ static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
> > >       DEFINE_WAIT_FUNC(wait, woken_wake_function);
> > >       int ret = 0;
> > >
> > > +     if (sk->sk_shutdown & RCV_SHUTDOWN)
> > > +             return 1;
> > > +
> > >       if (!timeo)
> > >               return ret;
> > >
> >
> > Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
> 
> Applied. Thanks

Thanks for the patch. LGTM, I guess we should also break the
copy loop in __tcp_bpf_recvmsg if RCV_SHUTDOWN is set it
looks like TCP stack does. I'll send a follow up thanks!
