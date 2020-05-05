Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2D61C5F1C
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbgEERna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730184AbgEERna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 13:43:30 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BD0C061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 10:43:30 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id d19so2558684qkj.21
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 10:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Slveylcay7wnEw1GTwIyCT2WGPuVc8v3TjGPcZ9/h84=;
        b=I8Y0Pknc6MHorBMuq7Hhd/8NnvzNRvpQbjyQr0rRKCfVPAFxCW37jBaxmsWzAHmvSH
         DDRN5rni3eOM0+04JtW+qvVzdRPGLAtnodLWnkuQQCFlWHXUYbOUzAdzcfY4oxyeP0y6
         XLZsv+qX5T1vgnR2v1g4v81VUcBzfjPBHtOllqw5dhczXOfZ6gsyfrw2e803XQ669KlR
         FiIxtezHnCAyBGFAQruGzptZlAhrMJAaxLJ3yvwsb+fwkVyMZQ6KTfadX+Ubgr5NguWf
         VxU/80b+ivz555ZdWMARtlUCVicyUwy6+iNuP8XIxyvrM2r0iNW+lMc16c8hB64Kn+Qr
         NuDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Slveylcay7wnEw1GTwIyCT2WGPuVc8v3TjGPcZ9/h84=;
        b=E471J30wpITKH7d1kvA+kNUv8w3zuoPsL7iNK/GNyxMARSbRmHQQmQ+zsM2oOHbPQi
         yTImXQ9UNMZKPdxGem3YX3/Zkmv+j1n+iM8jjxdRcp+8ZAo+PGUP8Of2j+aV4XHo9Xzy
         FNu8SJisZWfFRD5+1Iy4SYl96IqArfcE9J5u7vfrvZgcEeGJgME/jbFA7EEYOaKh6hFO
         I94UNNsT4BGKQzQk9n672v5Z+2QRtSi4EZf1sBrUPPCNjfpLwxnS6Bc2Sz16vSGxH3+h
         Me4yzE+G3Pmd9bIaG6ADC5SThGBKX1usfqQB1VOxkS0ZdthQBB7k9D3bAzMk/geamrUL
         nUew==
X-Gm-Message-State: AGi0PubPS3uTnfsv1g9mmSNXl6Afni+iUiNInE6OGpNGPPkB6I3bx+8H
        KvX83qHA/pKaAD6xHq7dfq7OF6M=
X-Google-Smtp-Source: APiQypJCQUhTguL5rRpkIG7z1+Fkf8loaQM8SxYfhC3+wfvFbFnxHgrv4u+OvV+o5OnRcimVbsiD9Kc=
X-Received: by 2002:a0c:da8c:: with SMTP id z12mr3941500qvj.143.1588700609123;
 Tue, 05 May 2020 10:43:29 -0700 (PDT)
Date:   Tue, 5 May 2020 10:43:27 -0700
In-Reply-To: <20200505173338.GA55644@rdna-mbp>
Message-Id: <20200505174327.GF241848@google.com>
Mime-Version: 1.0
References: <20200504173430.6629-1-sdf@google.com> <20200504173430.6629-5-sdf@google.com>
 <20200504232247.GA20087@rdna-mbp> <20200505160205.GC241848@google.com>
 <20200505170912.GE241848@google.com> <20200505173338.GA55644@rdna-mbp>
Subject: Re: [PATCH bpf-next 4/4] bpf: allow any port in bpf_bind helper
From:   sdf@google.com
To:     Andrey Ignatov <rdna@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/05, Andrey Ignatov wrote:
> sdf@google.com <sdf@google.com> [Tue, 2020-05-05 10:09 -0700]:
> > On 05/05, Stanislav Fomichev wrote:
> > > On 05/04, Andrey Ignatov wrote:
> > > > Stanislav Fomichev <sdf@google.com> [Mon, 2020-05-04 10:34 -0700]:
> > > > > [...]
> > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > index fa9ddab5dd1f..fc5161b9ff6a 100644
> > > > > --- a/net/core/filter.c
> > > > > +++ b/net/core/filter.c
> > > > > @@ -4527,29 +4527,24 @@ BPF_CALL_3(bpf_bind, struct
> > > bpf_sock_addr_kern *, ctx, struct sockaddr *, addr,
> > > > >  	struct sock *sk = ctx->sk;
> > > > >  	int err;
> > > > >
> > > > > -	/* Binding to port can be expensive so it's prohibited in the
> > > helper.
> > > > > -	 * Only binding to IP is supported.
> > > > > -	 */
> > > > >  	err = -EINVAL;
> > > > >  	if (addr_len < offsetofend(struct sockaddr, sa_family))
> > > > >  		return err;
> > > > >  	if (addr->sa_family == AF_INET) {
> > > > >  		if (addr_len < sizeof(struct sockaddr_in))
> > > > >  			return err;
> > > > > -		if (((struct sockaddr_in *)addr)->sin_port != htons(0))
> > > > > -			return err;
> > > > >  		return __inet_bind(sk, addr, addr_len,
> > > > > +				   BIND_FROM_BPF |
> > > > >  				   BIND_FORCE_ADDRESS_NO_PORT);
> > > >
> > > > Should BIND_FORCE_ADDRESS_NO_PORT be passed only if port is zero?
> > > > Passing non zero port and BIND_FORCE_ADDRESS_NO_PORT at the same  
> time
> > > > looks confusing (even though it works).
> > > Makes sense, will remove it here, thx.
> > Looking at it some more, I think we need to always have that
> > BIND_FORCE_ADDRESS_NO_PORT. Otherwise, it might regress your
> > usecase with zero port:
> >
> >   if (snum || !(inet->bind_address_no_port ||
> >                (flags & BIND_FORCE_ADDRESS_NO_PORT)))
> >
> > If snum == 0 we want to have either the flag on or
> > IP_BIND_ADDRESS_NO_PORT being set on the socket to prevent the port
> > allocation a bind time.

> Yes, if snum == 0 then flag is needed, that's why my previous comment
> has "only if port is zero" part.

> > If snum != 0, BIND_FORCE_ADDRESS_NO_PORT doesn't matter and the port
> > is passed as an argument. We don't need to search for a free one, just
> > to confirm it's not used.

> Yes, if snum != 0 then flag doesn't matter. So both cases are covered by
> your current code and that's what I meant by "(even though it works)".

> My point is in the "snum != 0" case it would look better not to pass the
> flag since:

> 1) as we see the flag doesn't matter on one hand;

> 2) but passing both port number and flag that says "bind only to address,
>     but not to port" can look confusing and raises a question "which
>     options wins? the one that sets the port or the one that asks to
>     ignore the port" and that question can be answered only by looking at
>     __inet_bind implementation.

> so basically what I mean is:

> 		flags = BIND_FROM_BPF;
> 		if (((struct sockaddr_in *)addr)->sin_port == htons(0))
> 			flags &= BIND_FORCE_ADDRESS_NO_PORT;

> That won't change anything for "snum == 0" case, but it would make the
> "snum != 0" case more readable IMO.

> Does it clarify?
Yes, it does, thanks! I somehow missed your 'only if port is zero' part.
