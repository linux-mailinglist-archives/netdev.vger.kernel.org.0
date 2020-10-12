Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431D128BBF9
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 17:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389992AbgJLPdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 11:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389340AbgJLPdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 11:33:32 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC44C0613D0;
        Mon, 12 Oct 2020 08:33:32 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q1so16327554ilt.6;
        Mon, 12 Oct 2020 08:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ZlRO7xNEESUMjPrXLb6TdeW98enr+YeJFlHmQjxVWCQ=;
        b=K5uyOf9giYqRBOnEi8dEq9THsCQyey3mUbcKPdVPNMQ6NaK2EKvLCvQGxmzhSXM7uk
         q/1ZXVg8VQcaJFGmII9jRdaUiYgay7YF3/cYuvvOsAF5Sr73MGH3MvwPth2W1bedBVyi
         OckgGumlQ4Yyrt4SR0XgBQMHbexB/YVyIndJZhwuDzw211IdwfA0eBtgr4iJytdCvQcL
         9es7skanXcyjaiJrPT2JC9yn+q87Kz2DuA+So7lZ1CjZ1snpcyibIbm95G1Be94SR/w9
         HLQtrjsdyiN2dXSUuTADPchuu8rzjWRiX3Vq5Z0oNkEtlNwDvoHBf6UP15CcL3GHTj7E
         G36Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ZlRO7xNEESUMjPrXLb6TdeW98enr+YeJFlHmQjxVWCQ=;
        b=hLVxBFAuTwYPU3F4PmW4ejBzYbuNePMxGto/Vfo9e/e5zVK+xc6P3dWuUsFLXuU14d
         IqMKUfn0UNACw6PFwRHFPIUZPPKY5yx+Q4INBiUc4KHtjXOHhDFR4qjW6WU8q6RLlmzs
         hTILxI0CF3NGsLNd6t2aMahMEY8VkG9SZ7SzQ1GKOEhuVp/dYKQw2cL2EreWiZgjkkWb
         AbBl5gOZvgQxvLdTseQBokp6Xk6vIW4y90rxKJ09K8QhQyXSJW+leG1t4mu5c3w6+cT3
         KLmhV5UtIbEowfocbKiXPx4uvvInrKcrrkCSTs/NdW7qo2m7ye82S00dlq0GBSpIVi1+
         8UvA==
X-Gm-Message-State: AOAM5339pScPoJGO0ckYdkp34T/+fIsVkh7NPI0+02Om9xUhdr6zV5ii
        et2eu831SAYEz9suqQzUe3k=
X-Google-Smtp-Source: ABdhPJwbO1Sh91Ysr4zTVF8qcd7df5H+6qmFHJIsYb93fgsi2KBM7m1Knt3b4A0vO6wppFiWo4C4YA==
X-Received: by 2002:a92:d4c8:: with SMTP id o8mr4334311ilm.56.1602516811453;
        Mon, 12 Oct 2020 08:33:31 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k7sm6898347iog.26.2020.10.12.08.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 08:33:30 -0700 (PDT)
Date:   Mon, 12 Oct 2020 08:33:24 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, lmb@cloudflare.com
Message-ID: <5f8477448f66e_370c208e4@john-XPS-13-9370.notmuch>
In-Reply-To: <87h7qzrf3c.fsf@cloudflare.com>
References: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
 <160226859704.5692.12929678876744977669.stgit@john-Precision-5820-Tower>
 <87h7qzrf3c.fsf@cloudflare.com>
Subject: Re: [bpf-next PATCH v3 2/6] bpf, sockmap: On receive programs try to
 fast track SK_PASS ingress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Hey John,
> 
> Exiting to see this work :-)
> 
> On Fri, Oct 09, 2020 at 08:36 PM CEST, John Fastabend wrote:
> > When we receive an skb and the ingress skb verdict program returns
> > SK_PASS we currently set the ingress flag and put it on the workqueue
> > so it can be turned into a sk_msg and put on the sk_msg ingress queue.
> > Then finally telling userspace with data_ready hook.
> >
> > Here we observe that if the workqueue is empty then we can try to
> > convert into a sk_msg type and call data_ready directly without
> > bouncing through a workqueue. Its a common pattern to have a recv
> > verdict program for visibility that always returns SK_PASS. In this
> > case unless there is an ENOMEM error or we overrun the socket we
> > can avoid the workqueue completely only using it when we fall back
> > to error cases caused by memory pressure.
> >
> > By doing this we eliminate another case where data may be dropped
> > if errors occur on memory limits in workqueue.
> >
> > Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  net/core/skmsg.c |   17 +++++++++++++++--
> >  1 file changed, 15 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index 040ae1d75b65..4b160d97b7f9 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -773,6 +773,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
> >  {
> >  	struct tcp_skb_cb *tcp;
> >  	struct sock *sk_other;
> > +	int err = -EIO;
> >
> >  	switch (verdict) {
> >  	case __SK_PASS:
> > @@ -784,8 +785,20 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
> >
> >  		tcp = TCP_SKB_CB(skb);
> >  		tcp->bpf.flags |= BPF_F_INGRESS;
> > -		skb_queue_tail(&psock->ingress_skb, skb);
> > -		schedule_work(&psock->work);
> > +
> > +		/* If the queue is empty then we can submit directly
> > +		 * into the msg queue. If its not empty we have to
> > +		 * queue work otherwise we may get OOO data. Otherwise,
> > +		 * if sk_psock_skb_ingress errors will be handled by
> > +		 * retrying later from workqueue.
> > +		 */
> > +		if (skb_queue_empty(&psock->ingress_skb)) {
> > +			err = sk_psock_skb_ingress(psock, skb);
> 
> When going through the workqueue (sk_psock_backlog), we will also check
> if socket didn't get detached from the process, that is if
> psock->sk->sk_socket != NULL, before queueing into msg queue.

The sk_socket check is only for the egress path,

  sk_psock_handle_skb -> skb_send_sock_locked -> kernel_sendmsg_locked

Then the do_tcp_sendpages() uses sk_socket and I don't see any checks for
sk_socket being set. Although I think its worth looking through to see
if the psock/sk state is always such that we have sk_socket there I
don't recall off-hand where that is null'd.

But, to answer your question this is ingress only and here we don't
use sk_socket for anything so I don't see any reason the check is
needed. All that is done here is converting to skmsg and posting
onto ingress queue.

> 
> Do we need a similar check here?
> 

Don't think so for above reason. Thanks for asking though and let me
know if you see something.

I think to make the workqueue path symmetric I'll move the check there
into the egress branch.

> > +		}
> > +		if (err < 0) {
> > +			skb_queue_tail(&psock->ingress_skb, skb);
> > +			schedule_work(&psock->work);
> > +		}
> >  		break;
> >  	case __SK_REDIRECT:
> >  		sk_psock_skb_redirect(skb);


