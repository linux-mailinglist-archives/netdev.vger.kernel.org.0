Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63A923144A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgG1Uzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728625AbgG1Uzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:55:32 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C778C061794;
        Tue, 28 Jul 2020 13:55:32 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id c16so5651586ils.8;
        Tue, 28 Jul 2020 13:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=jjOCWK730xEo0Lq6i4P8RFjqFwjxAE+ePsbqdWti9Ks=;
        b=rUMJCC1xVFtIj5QgXgMbDXqwHsalfjvtkOknokbGBWLPCig/QyJy/gvYpvq4e0Mz89
         mi1keXq+Zv8vyWl4hLM5Vq3JRo05XaGZyKaHubHvLOiUUMx7oLSITNSNdtvdDvERVraS
         XyzHICndumqeeRQvVZVKnBGtSwxU42ruabIi5Tdjr3eQl0lbBIjCAGVwqk8v59uxw4Vy
         0e/ipEA3knX6MMtvk7jfYwRuGFCmvli9kIMqKUBxEWiRlVNTjtO88zuFYhb+La6yfAb1
         eAgYMLRYBjxUplTLnWZK5oqtks1py19qGrb3REqgz7uiEbzQYuKh4RVGB63ARiuQKlq8
         2XMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=jjOCWK730xEo0Lq6i4P8RFjqFwjxAE+ePsbqdWti9Ks=;
        b=ma94JC56BkaV7KY6cZZHKwUR74mxi4owlJgbFg26cXEFL+H8Htw12Zuivnvbp6wNzQ
         oV7cIexDzcvWR+ccjRB7hoTk5iNUnJDFhgkVYA78HuoRq4aFaVi0/kxHac8ivCqwAeAL
         yZ0aGqyYey8dj+nALccWxcJF2eWRdM/Xe3y6lTjoQAZ7TdqGWgfpIt/1dVqvMt1iSsL3
         6W4fJXYOCZNr2sBQurI35/b6+2iuVM4kct/RgQuxUjg/uhCECD3etawBY6ib2Da3FB8S
         WzNtZRGL+WX3c22uSUny8LQTnmxs+OzwA2o9YjOiI7dSiKQvI9vlX9r5xt+gfRQhKKcb
         0Iww==
X-Gm-Message-State: AOAM531F1YcA750rsGdaqj1QGj0agued9UgmqNO3zHyJVJz+c/Q83t7l
        Rs048w222SK/SYGchtySV03D8kHn
X-Google-Smtp-Source: ABdhPJxPXEVSYeQG7c2NHrXU/pIz5soI/eeWAvW5smBNtCW11QOPxePdB5kne/GTI0DpZI40xLXwaQ==
X-Received: by 2002:a92:db10:: with SMTP id b16mr21339520iln.288.1595969731173;
        Tue, 28 Jul 2020 13:55:31 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o64sm10824082ilb.12.2020.07.28.13.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 13:55:30 -0700 (PDT)
Date:   Tue, 28 Jul 2020 13:55:22 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5f2090bac65ef_2fe92b13c67445b47d@john-XPS-13-9370.notmuch>
In-Reply-To: <20200728172317.zdgkzfrones6pa54@kafai-mbp>
References: <159595098028.30613.5464662473747133856.stgit@john-Precision-5820-Tower>
 <159595102637.30613.6373296730696919300.stgit@john-Precision-5820-Tower>
 <20200728172317.zdgkzfrones6pa54@kafai-mbp>
Subject: Re: [bpf PATCH 1/3] bpf: sock_ops ctx access may stomp registers in
 corner case
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau wrote:
> On Tue, Jul 28, 2020 at 08:43:46AM -0700, John Fastabend wrote:
> > I had a sockmap program that after doing some refactoring started spewing
> > this splat at me:
> > 
> > [18610.807284] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
> > [...]
> > [18610.807359] Call Trace:
> > [18610.807370]  ? 0xffffffffc114d0d5
> > [18610.807382]  __cgroup_bpf_run_filter_sock_ops+0x7d/0xb0
> > [18610.807391]  tcp_connect+0x895/0xd50
> > [18610.807400]  tcp_v4_connect+0x465/0x4e0
> > [18610.807407]  __inet_stream_connect+0xd6/0x3a0
> > [18610.807412]  ? __inet_stream_connect+0x5/0x3a0
> > [18610.807417]  inet_stream_connect+0x3b/0x60
> > [18610.807425]  __sys_connect+0xed/0x120
> > 

[...]

> > So three additional instructions if dst == src register, but I scanned
> > my current code base and did not see this pattern anywhere so should
> > not be a big deal. Further, it seems no one else has hit this or at
> > least reported it so it must a fairly rare pattern.
> > 
> > Fixes: 9b1f3d6e5af29 ("bpf: Refactor sock_ops_convert_ctx_access")
> I think this issue dated at least back from
> commit 34d367c59233 ("bpf: Make SOCK_OPS_GET_TCP struct independent")
> There are a few refactoring since then, so fixing in much older
> code may not worth it since it is rare?

OK I just did a quick git annotate and pulled out the last patch
there. I didn't go any farther back. The failure is rare and has
the nice property that it crashes hard always. For example I found
it by simply running some of our go tests after doing the refactor.
I guess if it was in some path that doesn't get tested like an
error case or something you might have an ugly surprise in production.
I can imagine a case where tracking this down might be difficult.

OTOH the backport wont be automatic past some of those reworks.

> 
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  net/core/filter.c |   26 ++++++++++++++++++++++++--
> >  1 file changed, 24 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 29e34551..c50cb80 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -8314,15 +8314,31 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
> >  /* Helper macro for adding read access to tcp_sock or sock fields. */
> >  #define SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ)			      \
> >  	do {								      \
> > +		int fullsock_reg = si->dst_reg, reg = BPF_REG_9, jmp = 2;     \
> >  		BUILD_BUG_ON(sizeof_field(OBJ, OBJ_FIELD) >		      \
> >  			     sizeof_field(struct bpf_sock_ops, BPF_FIELD));   \
> > +		if (si->dst_reg == reg || si->src_reg == reg)		      \
> > +			reg--;						      \
> > +		if (si->dst_reg == reg || si->src_reg == reg)		      \
> > +			reg--;						      \
> > +		if (si->dst_reg == si->src_reg) {			      \
> > +			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, reg,	      \
> > +					  offsetof(struct bpf_sock_ops_kern,  \
> > +				          temp));			      \
> Instead of sock_ops->temp, can BPF_REG_AX be used here as a temp?
> e.g. bpf_convert_shinfo_access() has already used it as a temp also.

Sure I will roll a v2 I agree that rax is a bit nicer. I guess for
bpf-next we can roll the load over to use rax as well? Once the
fix is in place I'll take a look it would be nice for consistency.

> 
> Also, it seems the "sk" access in sock_ops_convert_ctx_access() suffers
> a similar issue.

Good catch. I'll fix it up as well. Maybe with a second patch and test.
Patches might be a bit verbose but makes it easier to track the bugs
I think.

> 
> > +			fullsock_reg = reg;				      \
> > +			jmp+=2;						      \
> > +		}							      \
> >  		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(			      \
> >  						struct bpf_sock_ops_kern,     \
> >  						is_fullsock),		      \
> > -				      si->dst_reg, si->src_reg,		      \
> > +				      fullsock_reg, si->src_reg,	      \
> >  				      offsetof(struct bpf_sock_ops_kern,      \
> >  					       is_fullsock));		      \
> > -		*insn++ = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 2);	      \
> > +		*insn++ = BPF_JMP_IMM(BPF_JEQ, fullsock_reg, 0, jmp);	      \
> > +		if (si->dst_reg == si->src_reg)				      \
> > +			*insn++ = BPF_LDX_MEM(BPF_DW, reg, si->src_reg,	      \
> > +				      offsetof(struct bpf_sock_ops_kern,      \
> > +				      temp));				      \
> >  		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(			      \
> >  						struct bpf_sock_ops_kern, sk),\
> >  				      si->dst_reg, si->src_reg,		      \
> > @@ -8331,6 +8347,12 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
> >  						       OBJ_FIELD),	      \
> >  				      si->dst_reg, si->dst_reg,		      \
> >  				      offsetof(OBJ, OBJ_FIELD));	      \
> > +		if (si->dst_reg == si->src_reg)	{			      \
> > +			*insn++ = BPF_JMP_A(1);				      \
> > +			*insn++ = BPF_LDX_MEM(BPF_DW, reg, si->src_reg,	      \
> > +				      offsetof(struct bpf_sock_ops_kern,      \
> > +				      temp));				      \
> > +		}							      \
> >  	} while (0)
> >  
> >  #define SOCK_OPS_GET_TCP_SOCK_FIELD(FIELD) \
> > 
