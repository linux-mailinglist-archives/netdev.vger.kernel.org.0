Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 175545A7D9
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 02:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfF2AUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 20:20:33 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34134 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfF2AUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 20:20:33 -0400
Received: by mail-io1-f66.google.com with SMTP id k8so16229774iot.1;
        Fri, 28 Jun 2019 17:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=/0//fGmg2HXfSsXBwvjygypdcI0rQRYHZkZyWH13JfU=;
        b=PYjHIzBeOK+PO7t6a/g7JYO7Cdpo8aCDdp6d8L5daFo1w266l0vwzSqEop0QyCTwHa
         m2cHF+aWiEsHhREgGqtrkiOVelLnohiVZhpPP+2RW3p9Ho+yBKFMGVehq0rXKIUAJCjs
         lDVsxr7Nd29hq2W8KFivyG90rJg0SzD7x3zV1RAM5WTmP8+rPRFkuB8x2ErWjYCT6k7g
         EUUJfw2Jgl0xB9YkeKhCMR2joG8WGRw6zHs/JTPtJG3tkDTJIBgG1lzgNmR2IRXiCskK
         0WPnMb9MUlMbYxHz3ddnWZMqzh2uBGREGApCjw5w2HKQIVf/fwNZp1YErf0JCJESuGdo
         wFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=/0//fGmg2HXfSsXBwvjygypdcI0rQRYHZkZyWH13JfU=;
        b=aKlo0cPk0pwjJANDZL7+myk+U6LGWKBBsh0+aZftkNF8LtnJmhJgG/HKCZmdPR0imC
         VuWcxMQKoT44HNqRpx1/RcqOWJfXeeWN6l1TmuQeBK+gme/w0WIKM+6ZM/4FVMoi6JHq
         pQ5sXWNVT+JOlcwKt9VYOgpJLGr3BSR3ETdu0RMZqFFpm2U4dkDRtQA4s2h1vVce3UqT
         7jg5lTPcpMdsZC9rn0nYN6tSEH6e3KIiNR0BR7TUQe7KmKtvnf/Y7jpJc5o3KUOn8KaC
         Lyy+gWCd50nWesX0SKZiY7HcytUZdj+H5jHNntWKPo9YVgW1erq3gHX2HOw6FZiZdfr8
         TTSg==
X-Gm-Message-State: APjAAAVBWvrqWJWPw+z+8Qh6sO+MzLSkLLCTTYTjqPn6QVa+nqrnkTQX
        +LlxnYER191/Yj0WcWfVzKg=
X-Google-Smtp-Source: APXvYqwbhLPZQVoBwJXebJdQ1PlSXBwiZWepTaOP033peY+sg0NaNVIGy9Q2bbF8s0YuyYqSNbQpmg==
X-Received: by 2002:a6b:2bcd:: with SMTP id r196mr14219650ior.73.1561767632036;
        Fri, 28 Jun 2019 17:20:32 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f17sm3409479ioc.2.2019.06.28.17.20.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 17:20:31 -0700 (PDT)
Date:   Fri, 28 Jun 2019 17:20:23 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Message-ID: <5d16aec74b6cd_35a32adaec47c5c457@john-XPS-13-9370.notmuch>
In-Reply-To: <20190628154841.32b96fb1@cakuba.netronome.com>
References: <156165697019.32598.7171757081688035707.stgit@john-XPS-13-9370>
 <156165700197.32598.17496423044615153967.stgit@john-XPS-13-9370>
 <20190627164402.31cbd466@cakuba.netronome.com>
 <5d1620374694e_26962b1f6a4fa5c4f2@john-XPS-13-9370.notmuch>
 <20190628113100.597bfbe6@cakuba.netronome.com>
 <5d166d2deacfe_10452ad82c16e5c0a5@john-XPS-13-9370.notmuch>
 <20190628154841.32b96fb1@cakuba.netronome.com>
Subject: Re: [PATCH 1/2] tls: remove close callback sock unlock/lock and
 flush_sync
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Fri, 28 Jun 2019 12:40:29 -0700, John Fastabend wrote:
> > The lock() is already held when entering unhash() side so need to
> > handle this case as well,
> > 
> > CPU 0 (free)          CPU 1 (wq)
> > 
> > lock(sk)              ctx = tls_get_ctx(sk) <- need to be check null ptr
> > sk_prot->unhash()
> >   set_bit()
> >   cancel_work()
> >   ...
> >   kfree(ctx)
> > unlock(sk)
> > 
> > but using cancel and doing an unlikely(!ctx) check should be
> > sufficient to handle wq. 
> 
> I'm not sure we can kfree ctx, the work struct itself is in it, no?

should be OK as long as we have no outstanding work. So cancel_work()
needs to be cancel_work_sync() but we can't do this in unhash so
see below...

> 
> > What I'm not sure how to solve now is
> > in patch 2 of this series unhash is still calling strp_done
> > with the sock lock. Maybe we need to do a deferred release
> > like sockmap side?
> 
> Right, we can't do anything that sleeps in unhash, since we're holding
> the spinlock there, not the "owner" lock.

yep.

> 
> > Trying to drop the lock and then grabbing it again doesn't
> > seem right to me seems based on comment in tcp_abort we
> > could potentially "race with userspace socket closes such
> > as tcp_close". iirc I think one of the tls splats from syzbot
> > looked something like this may have happened.
> > 
> > For now I'm considering adding a strp_cancel() op. Seeing
> > we are closing() the socket and tearkng down we can probably
> > be OK with throwing out strp results.
> 
> But don't we have to flush the work queues before we free ctx?  We'd
> need to alloc a workqueue and schedule a work to flush the other works
> and then free?

Agree, just wrote this code now and testing it. So new flow is,

 lock(sk)
 sk_prot->unhash()
   set_bit(CLOSING)
   ...
   tls_ctx_wq_free(ctx) <- sets up a work queue to do the *sync and kfree
 unlock(sk)

FWIW sockmap has a similar problem on unhash() where it needs to
wait a RCU grace period and then do *sync operations on workqueues.
So it also schedules work to do the cleanup outside unhash() with
additional complication of waiting rcu grace period before scheduling.

The new patches are not too ugly IMO it only impacts this one
unhash() case.

> 
> Why can't tls sockets exist outside of established state?  If shutdown
> doesn't call close, perhaps we can add a shutdown callback?  It doesn't
> seem to be called from BH?
>

Because the ulp would be shared in this case,

	/* The TLS ulp is currently supported only for TCP sockets
	 * in ESTABLISHED state.
	 * Supporting sockets in LISTEN state will require us
	 * to modify the accept implementation to clone rather then
	 * share the ulp context.
	 */
	if (sk->sk_state != TCP_ESTABLISHED)
		return -ENOTSUPP;

In general I was trying to avoid modifying core TCP layer to fix
this corner case in tls.
 
> Sorry for all the questions, I'm not really able to fully wrap my head
> around this. I also feel like I'm missing the sockmap piece that may
> be why you prefer unhash over disconnect.

Yep, if we try to support listening sockets we need a some more
core infrastructure to push around ulp and user_data portions of
sockets. Its not going to be nice for stable. Also at least in TLS
and sockmap case its not really needed for any use case I know
of.

> 
> FWIW Davide's ULP diag support patches will require us to most likely
> free ctx with kfree_rcu(). diag only has a ref on struct sock, so if 
> we want to access ctx we need RCU or to lock every socket. It's a
> little bit of an abuse of RCU, because the data under our feet may
> actually change, but the fields we dump will only get inited once
> after ulp is installed.

Ah great. I'll push a v2 this afternoon so we get syzbot running
its reproducers over it and maybe it will fit into Davide's work
as well.
