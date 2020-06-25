Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB36F20A34E
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 18:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391001AbgFYQrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 12:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390952AbgFYQrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 12:47:05 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D128C08C5C1;
        Thu, 25 Jun 2020 09:47:05 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id f23so6800309iof.6;
        Thu, 25 Jun 2020 09:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=4guapXVx48kUC/LvtMX6uMczAsJmUT2cwWBwWn8bi/c=;
        b=JzNuLVFgeFpHlOegYcUBbjvZYCwX2eNLUDXjqZziBXaxpbn1YXDVPyy2iCCsVUHpaR
         yns94qY+Dja9IE3sh87Ba70uk3Qw+aEw3DNndFIcOduBGUb76LAJb4v7+gJLdxZHNlSk
         f9zVNPjX9Pwa9n7Q2w8o8XYMKFDgr2luf67c13gGhg4r6JFL5uAtv8cOp4zZb3YhxSPe
         E+GWKktN4NYRn5GmGTIUEgPKEzPfH6kJNxY7BM9FxyHtlLkWdOF4h7kOa8grZdPBUUjJ
         7aZBHvPY4a8JtPJT0QBEnjKskbQ6WJROz9SLjaoG9jrylgS0K2imZRFs9s5S6AdwePBA
         FEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=4guapXVx48kUC/LvtMX6uMczAsJmUT2cwWBwWn8bi/c=;
        b=UytsJmEC5HN5LckOhfJOovTWb/EtRlSIw6gJYBGOtrbR5YWvDazrLxEbPlpQ/RZ4ww
         Iv9Ziw930okpdFrvCbG3NJaWJldUcp5ENSbweLSUF9m2Xig5yPSyu1BMgqIA9Kgrhw8V
         9jKpVYZO0H146wagNyuG2WlYbtG09rGSJ5jh91PjBHmczv5Kdz2/4r2QlSbRNH9YM3mx
         Xa1P55sU7HTbO/S+1dfANXF2js9DjIgIGzDk8y7WFlhkKNCY8Da0WzCzUmuGoBQwgq5k
         gqnw/fTkIA6Zfa35oxsnF6Vgw5KljJH3tfd1NzjUvv9y4H90sJmVBEQjt7rTVVBPhofI
         h7Pg==
X-Gm-Message-State: AOAM5307uw9a/GcUVk6RbV2E17+C86DutIxYY92l8MJeHSVh/w2eRHCe
        znmCZrhxFVOHsf9ymfMGIkI=
X-Google-Smtp-Source: ABdhPJzYWsXSU0Ububc95B2hSm1o0I+lzKESn0HmCj7sCrunFKp9XSCYFvl4+LwJ10Du28S4n1qfFw==
X-Received: by 2002:a6b:8f04:: with SMTP id r4mr37768697iod.160.1593103624457;
        Thu, 25 Jun 2020 09:47:04 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y20sm3895829ioc.30.2020.06.25.09.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 09:47:03 -0700 (PDT)
Date:   Thu, 25 Jun 2020 09:46:55 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     jakub@cloudflare.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5ef4d4ffa74d3_12d32af9eaf485bc9e@john-XPS-13-9370.notmuch>
In-Reply-To: <20200625062202.jyt5dzcdbanwkah2@kafai-mbp.dhcp.thefacebook.com>
References: <159303296342.360.5487181450879978407.stgit@john-XPS-13-9370>
 <20200625062202.jyt5dzcdbanwkah2@kafai-mbp.dhcp.thefacebook.com>
Subject: Re: [bpf PATCH] bpf, sockmap: RCU splat with TLS redirect and
 strparser
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau wrote:
> On Wed, Jun 24, 2020 at 02:09:23PM -0700, John Fastabend wrote:
> > Redirect on non-TLS sockmap side has RCU lock held from sockmap code
> > path but when called from TLS this is no longer true. The RCU section
> > is needed because we use rcu dereference to fetch the psock of the
> > socket we are redirecting to.
> sk_psock_verdict_apply() is also called by sk_psock_strp_read() after
> rcu_read_unlock().  This issue should not be limited to tls?

The base case is covered because the non-TLS case is wrapped in
rcu_read_lock/unlock here,

 static void sk_psock_strp_data_ready(struct sock *sk)
 {
	struct sk_psock *psock;

	rcu_read_lock();
	psock = sk_psock(sk);
	if (likely(psock)) {
		if (tls_sw_has_ctx_rx(sk)) {
			psock->parser.saved_data_ready(sk);
		} else {
			write_lock_bh(&sk->sk_callback_lock);
			strp_data_ready(&psock->parser.strp);
			write_unlock_bh(&sk->sk_callback_lock);
		}
	}
	rcu_read_unlock();
 }

There is a case that has existed for awhile where if a skb_clone()
fails or alloc_skb_for_msg() fails when building a merged skb. We
could call back into sk_psock_strp_read() from a workqueue in
strparser that would not be covered by above sk_psock_strp_data_ready().
This would hit the sk_psock_verdict_apply() you caught above.

We don't actually see this from selftests because in selftests we
always return skb->len indicating a msg is a single skb. In our
use cases this is all we've ever used to date so we've not actually
hit the case you call out. Another case that might hit this, based
on code review, is some of the zero copy TX cases.

To fix the above case I think its best to submit another patch
because the Fixes tag will be different. Sound OK? I could push
them as a two patch series if that is easier to understand.

Also I should have a patch shortly to allow users to skip setting
up a parse_msg hook for the strparser. This helps because the
vast majority of use cases I've seen just use skb->len as the
message deliminator. It also bypasses above concern.

Thanks,
John
