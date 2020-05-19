Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748561D8F3C
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 07:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgESFe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 01:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgESFe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 01:34:26 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D35C061A0C;
        Mon, 18 May 2020 22:34:26 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id h10so13200540iob.10;
        Mon, 18 May 2020 22:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=wBcDVMZukCDL4+iEWMTyjbWBL4KWHtoaMWzzzfyYCyA=;
        b=kSTp0LgSVZiTAzN1+vYglNiWK3XL39vrnS1DPhDwJrM3723mdQrBJ1wQIimcg65E/7
         RiY5v3u3Eu4SE6uvitveCHZHrpysZuBrUgh9S6c66F+G9NmX8vwMiIWn18rYHxpZUDgc
         wayRi/+a/qBPxcDa107Ar6KG18NOVAUJ5A3cJNnwzqOgwwvMrM4JwEFwM6MJrc6wWSTv
         iPk5sK9tzY446S+/yQiaaUpTD3xcr8EY3cwuYahkRVjvscrRnJl+O+JdS+CL4ijlxXiq
         18LIxP5Oyb3hgF+oFCa12vfms4wDjATGC8hJT9Jdj4ar9lQmtno/uEqNR9Au1Or8gCUx
         DWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=wBcDVMZukCDL4+iEWMTyjbWBL4KWHtoaMWzzzfyYCyA=;
        b=XRvblgYkPjsO7/ccHmDpg6T0wHrZTzXPQSmG3ETHkBPlcNf/zaB8THd/lEC+3WiQx6
         yEjTZoaLQF0iDNoNOJybwtuXudJtp9xbbocGzzsoe2gfFBUyHvxIhCNrGTExw4PiJk4m
         y20bnoj5GZAMMydfr3SqiOAXNMANAxd6vB8pB7PRkEhqyZrhodPBCWgnbL8nBzNybdvJ
         E03b9ge5nSeC1b77SeZ3MWwensPnhHKZh1SeT49FVF7NIzvP6xj1j6BVd1p/OqavcnOf
         VLvCdWkNY00KLnvSHwCF5X4lQzUHn8Eqyy3e/M4fL4SqQQl8qh7IhPc9EHyGhWx3Oeva
         /sLw==
X-Gm-Message-State: AOAM533LuzTI/sOo+5FiTldXa+QFd10DKHRCecOF2AGChqsoglLR+PDy
        JWQnptzcn2zUHnnJXXvf1DU=
X-Google-Smtp-Source: ABdhPJyP2/VRJXTa4o36FAJZEGIB8EBtFPjdO94zSapp+hmsYNro6cJUw9dzQcdBUMO0FGywBRzdJw==
X-Received: by 2002:a6b:bf83:: with SMTP id p125mr17695821iof.118.1589866465577;
        Mon, 18 May 2020 22:34:25 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q13sm4689621ion.36.2020.05.18.22.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 22:34:24 -0700 (PDT)
Date:   Mon, 18 May 2020 22:34:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-ID: <5ec36fd86bfbd_2e852b10123785b467@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzbjEXRy-VJqGodKB9Co7X8zGXSVFXqmZYK_PrCza6UOBA@mail.gmail.com>
References: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
 <158983215367.6512.2773569595786906135.stgit@john-Precision-5820-Tower>
 <CAEf4BzbjEXRy-VJqGodKB9Co7X8zGXSVFXqmZYK_PrCza6UOBA@mail.gmail.com>
Subject: Re: [bpf-next PATCH 1/4] bpf: verifier track null pointer
 branch_taken with JNE and JEQ
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Mon, May 18, 2020 at 1:05 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Current verifier when considering which branch may be taken on a
> > conditional test with pointer returns -1 meaning either branch may
> > be taken. But, we track if pointers can be NULL by using dedicated
> > types for valid pointers (pointers that can not be NULL). For example,
> > we have PTR_TO_SOCK and PTR_TO_SOCK_OR_NULL to indicate a pointer
> > that is valid or not, PTR_TO_SOCK being the validated pointer type.
> >
> > We can then use this extra information when we encounter null tests
> > against pointers. Consider,
> >
> >   if (sk_ptr == NULL) ... else ...
> >
> > if the sk_ptr has type PTR_TO_SOCK we know the null check will fail
> > and the null branch can not be taken.
> >
> > In this patch we extend is_branch_taken to consider this extra
> > information and to return only the branch that will be taken. This
> > resolves a verifier issue reported with this C code,
> >
> >  sk = bpf_sk_lookup_tcp(skb, tuple, tuple_len, BPF_F_CURRENT_NETNS, 0);
> >  bpf_printk("sk=%d\n", sk ? 1 : 0);
> >  if (sk)
> >    bpf_sk_release(sk);
> >  return sk ? TC_ACT_OK : TC_ACT_UNSPEC;
> >
> > The generated asm then looks like this,
> >
> >  43: (85) call bpf_sk_lookup_tcp#84
> >  44: (bf) r6 = r0                    <- do the lookup and put result in r6
> >  ...                                 <- do some more work
> >  51: (55) if r6 != 0x0 goto pc+1     <- test sk ptr for printk use
> >  ...
> >  56: (85) call bpf_trace_printk#6
> >  ...
> >  61: (15) if r6 == 0x0 goto pc+1     <- do the if (sk) test from C code
> >  62: (b7) r0 = 0                     <- skip release because both branches
> >                                         are taken in verifier
> >  63: (95) exit
> >  Unreleased reference id=3 alloc_insn=43
> >
> 
> bpf_sk_release call in above assembler would be really nice for
> completeness. As written, this code never calls and never will call
> bpf_sk_release().
> 
> > In the verifier path the flow is,
> >
> >  51 -> 53 ... 61 -> 62
> >
> > Because at 51->53 jmp verifier promoted reg6 from type PTR_TO_SOCK_OR_NULL
> > to PTR_TO_SOCK but then at 62 we still test both paths ignoring that we
> 
> Seems like your description got a bit out of sync with the code above.
> There is no line 53, check is actually on line 61, not 62, etc. Can
> you please update it in your v2 as well?

Will do a rewrite.

> 
> > already promoted the type. So we incorrectly conclude an unreleased
> > reference. To fix this we add logic in is_branch_taken to test the
> > OR_NULL portion of the type and if its not possible for a pointer to
> > be NULL we can prune the branch taken where 'r6 == 0x0'.
> >
> > After the above additional logic is added the C code above passes
> > as expected.
> >
> > This makes the assumption that all pointer types PTR_TO_* that can be null
> > have an equivalent type PTR_TO_*_OR_NULL logic.
> >
> > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > Reported-by: Andrey Ignatov <rdna@fb.com>
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  0 files changed
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 180933f..8f576e2 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -393,6 +393,14 @@ static bool type_is_sk_pointer(enum bpf_reg_type type)
> >                 type == PTR_TO_XDP_SOCK;
> >  }
> >
> > +static bool reg_type_not_null(enum bpf_reg_type type)
> > +{
> > +       return type == PTR_TO_SOCKET ||
> > +               type == PTR_TO_TCP_SOCK ||
> > +               type == PTR_TO_MAP_VALUE ||
> > +               type == PTR_TO_SOCK_COMMON;
> 
> PTR_TO_BTF_ID should probably be here as well (we do have
> PTR_TO_BTF_ID_OR_NULL now).

OK.

> 
> > +}
> > +
> >  static bool reg_type_may_be_null(enum bpf_reg_type type)
> >  {
> >         return type == PTR_TO_MAP_VALUE_OR_NULL ||
> > @@ -1970,8 +1978,9 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
> >         if (regno >= 0) {
> >                 reg = &func->regs[regno];
> >                 if (reg->type != SCALAR_VALUE) {
> > -                       WARN_ONCE(1, "backtracing misuse");
> > -                       return -EFAULT;
> > +                       if (unlikely(!reg_type_not_null(reg->type)))
> > +                               WARN_ONCE(1, "backtracing misuse");
> > +                       return 0;
> 
> I think it's safer to instead add check in check_cond_jmp_op, in case
> branch is known, to only mark precision if register is not a non-null
> pointer. __mark_chain_precision is used in many places, so it's better
> to guard against this particular situation and leave warning for
> general case, IMO.

Sure.

> 
> >                 }
> >                 if (!reg->precise)
> >                         new_marks = true;
> > @@ -6306,8 +6315,26 @@ static int is_branch64_taken(struct bpf_reg_state *reg, u64 val, u8 opcode)
> >  static int is_branch_taken(struct bpf_reg_state *reg, u64 val, u8 opcode,
> >                            bool is_jmp32)
> >  {
> > -       if (__is_pointer_value(false, reg))
> > -               return -1;
> > +       if (__is_pointer_value(false, reg)) {
> > +               if (!reg_type_not_null(reg->type))
> > +                       return -1;
> > +
> > +               /* If pointer is valid tests against zero will fail so we can
> > +                * use this to direct branch taken.
> > +                */
> > +               switch (opcode) {
> > +               case BPF_JEQ:
> > +                       if (val == 0)
> > +                               return 0;
> > +                       return 1;
> 
> if val != 0, then we can't really tell whether point is equal to our
> scalar or not, right? What if we leaked pointer into a global
> variable, now we are checking against that stored value? It can go
> both ways. So unless I'm missing something, it should be -1 here.

Correct it should be -1 thanks. Probably worth adding a test for this case
as well.

> 
> > +               case BPF_JNE:
> > +                       if (val == 0)
> > +                               return 1;
> > +                       return 0;
> 
> same here, unless value we compare against is zero, we can't really
> tell for sure, so -1?
> 

Correct thanks.

> 
> > +               default:
> > +                       return -1;
> > +               }
> > +       }
> >
> >         if (is_jmp32)
> >                 return is_branch32_taken(reg, val, opcode);
> >
