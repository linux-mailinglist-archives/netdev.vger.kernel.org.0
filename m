Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A468107CA4
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 04:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfKWDZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 22:25:25 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:44572 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfKWDZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 22:25:24 -0500
Received: by mail-il1-f195.google.com with SMTP id i6so9116274ilr.11
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 19:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=k3+1F/tuKOzcbJXp2UodRLgQG3EWQ01CO3tTYqU2jpo=;
        b=pMXBzDHxNbWk7ezNe4yoYIgzpIyG+FAmKMRk3fV3dAGsvn3bBs/7HUv0p5r5dCx239
         ByCoPGqY16jTiFYsp/eQAkXiX95z0EmWiqbgu06rHBALai7aOXuX8+E3LUn+PB3+IBLe
         HLFc5Pm1TiZBjiCRXEOiTZsDfZ8/gXDjAlTuKSyQN3WkXpKdsembOu1ZIJt7a3wtIbBB
         rCQ/WDvSdRD07QWMq4D44XidfljxwobuagJp8gHXLYkhb+HoxVWNqdEtVv0TbM19IEX7
         Q9TvdDC6ep+NZVcZau+bFBzva64SiRld0D2P1QabOMYvYgAk4xYoazShigN04Fmoqv5C
         HZmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=k3+1F/tuKOzcbJXp2UodRLgQG3EWQ01CO3tTYqU2jpo=;
        b=Np6qtNIzpIljYPCOCaQRwyzx5Uz3h3VNx9CYK/xsiiTnUPA+wYzmGxvaLWJi7VwiNd
         Jn/ObbN4anQMq7oxI1MP2vR19Wtg9xavGv0x4g/6zB0pxhNTTEw9U5wOK/tI/DdR5N39
         3ydXsV1yIj5YNx/8nRGbrlqOQYTgf26ESCOJvwPnJVtbk6HHmgUCLSXrXuNCEAnvisop
         5HPemi8t7VKfOt4EDYGPKiQeMbzM2OD88nZIDNnZL03U7LP9oJylNc9S0Dozq/gf51qI
         0yuxBQwh5We+5fEm7Gp7qHhl60EV48lYACk+W4J+V8pEzJR2iMLE614BFNbuFdYj5A+A
         VB/A==
X-Gm-Message-State: APjAAAVf2OfOByFR4IVNLcaNwT3cMEbw7MEQKyn6jfnySpzERFWU5wrP
        eXqpvsXPB3akSd+KqbpBBsAGNtte
X-Google-Smtp-Source: APXvYqwLKeBSeA1k8MUtKUQECIgwQavNYRARAdWacerRa19DpBZfg1HulzzrvI4f6nJtMAdY4Hf3Bg==
X-Received: by 2002:a02:b614:: with SMTP id h20mr3079284jam.99.1574479521841;
        Fri, 22 Nov 2019 19:25:21 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h6sm3408468ilr.7.2019.11.22.19.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 19:25:21 -0800 (PST)
Date:   Fri, 22 Nov 2019 19:25:13 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
Message-ID: <5dd8a69936015_112a2b074679a5b83a@john-XPS-13-9370.notmuch>
In-Reply-To: <20191122214553.20982-1-jakub.kicinski@netronome.com>
References: <20191122214553.20982-1-jakub.kicinski@netronome.com>
Subject: RE: [RFC net] net/tls: clear SG markings on encryption error
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> When tls_do_encryption() fails the SG lists are left with the
> SG_END and SG_CHAIN marks in place. One could hope that once
> encryption fails we will never see the record again, but that
> is in fact not true. Commit d3b18ad31f93 ("tls: add bpf support
> to sk_msg handling") added special handling to ENOMEM and ENOSPC
> errors which mean we may see the same record re-submitted.
> 
> In all honesty I don't understand why we need the ENOMEM handling.
> Waiting for socket memory without setting SOCK_NOSPACE on any
> random memory allocation failure seems slightly ill advised.
> 
> Having said that, undoing the SG markings seems wise regardless.
> 
> Reported-by: syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
> Fixes: 130b392c6cd6 ("net: tls: Add tls 1.3 support")
> Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
> John, I'm sending this mostly to ask if we can safely remove
> the ENOMEM handling? :)
> 
What ENOMEM are you asking about here? The return code handling
from bpf_exec_tx_verdict?


	ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
				  record_type, &copied,
				  msg->msg_flags);
	if (ret) {
		if (ret == -EINPROGRESS)
			num_async++;
		else if (ret == -ENOMEM)
			goto wait_for_memory;
		else if (ret == -ENOSPC)
			goto rollback_iter;
		else if (ret != -EAGAIN)
			goto send_end;
	}

I would want to run it through some of our tests but I don't think
there is anything specific about BPF that needs it to be handled.
I was just trying to handle the error case gracefully and
wait_for_memory seems like the right behavior to me. What is ill
advised here?

> I was going to try the sockmap tests myself, but looks like the current
> LLVM 10 build I get from their debs just segfaults when trying to build
> selftest :/
> 
> Also there's at least one more bug in this piece of code, TLS 1.3
> can't assume there's at least one free SG entry.

There should always be one free SG entry at the end of the ring
that is used for chaining.

From sk_msg_sg{}

	/* The extra element is used for chaining the front and sections when
	 * the list becomes partitioned (e.g. end < start). The crypto APIs
	 * require the chaining.
	 */
	struct scatterlist		data[MAX_MSG_FRAGS + 1];

Can we use that element in that case? Otherwise probably can
add an extra element there if needed, data[MAX_MSG_FRAGS + 2].

> 
>  net/tls/tls_sw.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 24161750a737..4a0ea87b20cf 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -737,6 +737,19 @@ static int tls_push_record(struct sock *sk, int flags,
>  	if (rc < 0) {
>  		if (rc != -EINPROGRESS) {
>  			tls_err_abort(sk, EBADMSG);
> +
> +			i = msg_pl->sg.end;
> +			if (prot->version == TLS_1_3_VERSION) {
> +				sg_mark_end(sk_msg_elem(msg_pl, i));
> +				sg_unmark_end(sk_msg_elem(msg_pl, i));
> +			}
> +			sk_msg_iter_var_prev(i);
> +			sg_unmark_end(sk_msg_elem(msg_pl, i));
> +
> +			i = msg_en->sg.end;
> +			sk_msg_iter_var_prev(i);
> +			sg_unmark_end(sk_msg_elem(msg_en, i));
> +
>  			if (split) {
>  				tls_ctx->pending_open_record_frags = true;
>  				tls_merge_open_record(sk, rec, tmp, orig_end);
> -- 
> 2.23.0
> 

Can you copy the tls_push_record() error handling from BPF side instead of
embedding more into tls_push_record itself?

	err = tls_push_record(sk, flags, record_type);
	if (err < 0) {
		*copied -= sk_msg_free(sk, msg);
		tls_free_open_rec(sk);
		goto out_err;
	}

If the BPF program is not installed I guess you can skip the copied part
because you wont have the 'more_data' case.

So something like (untested/compiled/etc)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 141da093ff04..0469eb73bc88 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -771,8 +771,14 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 
 	policy = !(flags & MSG_SENDPAGE_NOPOLICY);
 	psock = sk_psock_get(sk);
-	if (!psock || !policy)
-		return tls_push_record(sk, flags, record_type);
+	if (!psock || !policy) {
+		err = tls_push_record(sk, flags, record_type);
+		if (err) {
+			sk_msg_free(sk, msg);
+			tls_free_open_rec(sk); // might not be needed in noBPF
+		}
+		return err;
+	}
 more_data:
 	enospc = sk_msg_full(msg);
 	if (psock->eval == __SK_NONE) {
