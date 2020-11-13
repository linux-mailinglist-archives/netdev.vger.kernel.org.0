Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A1E2B1350
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgKMAf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgKMAf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 19:35:57 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0759C0613D1;
        Thu, 12 Nov 2020 16:35:57 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id m13so8554800oih.8;
        Thu, 12 Nov 2020 16:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=M09YuAwcxqngOc9N6q/ZmK7f0Y/KZ5s7+kpoHEp5wGI=;
        b=POY2Oddubg91zxNwhJpr4cXVjkTMdxnmF3ZPpnnAaazrTBInktkrzJo6E8rKuxTkob
         yzw1ww8Y6ZQIbIKZM9OJlEYN2adoOoeV7MRPRsaeERNPAnMFh1YTrS/2L5cIzfyj1doL
         Kr4mMvTCmNc061KZ6kjVPerf0CImGkqVXY7+bMyCjTtzAuryMxDRh+cUBKz8TfHEpNUc
         jrkBnkEzKauDrsRFKZu669TxXTY6pZcweSJTv7dKyCwXIaJnFnuq0y1ILA8EZ6Aj4rcF
         oWIV8iGNcMLgUTHRSOcJHFiLCVFFF1tRRSg0tyTCxuCpZz8SYkukf4zcizBVYkDTyOCb
         Jd/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=M09YuAwcxqngOc9N6q/ZmK7f0Y/KZ5s7+kpoHEp5wGI=;
        b=j56op1UcXRtmkJNGgLsURRjhYckU1hJ2acqPRYW9dWVMb8l71ZuAyvb0CRsw0i/CFM
         zBqOmWULa7j5GRaYpvkWq2JFa/xGQWvyB6Wa4YAHXCQeSyVDHhHjTSOjI/DlBd0F3anM
         chNh5V34UrVsEbzuz4Vuiz8ud4wJC4+aQ4i4Q5ZvEFNbB6xDWuJR1bbPz8LEeDzQePzr
         LB9bJhAnufj9SMlmZJTkmx4jO7Z0t1cuELFAxfbgupJ8mW5/8J8PM830aseUMnm3Iz3k
         FttS4nS2+0sZdzqv/0ohAp3O9epoiWN0IDdEjJqr5d+1eo1IYHxToVQP6rG5NPh5GdJv
         YZwg==
X-Gm-Message-State: AOAM532Pre+sSOFDSanC+nbaT/3tMXmyzrpmBMDBEkco6hLsOuheNjpl
        rLyDcuS0/t09CPIsotMdAvPOgVkZOr1qOw==
X-Google-Smtp-Source: ABdhPJzvW0T0oGjtL5L/s3CMxZMbZVCLJrJe5Jma4FioMUEpuWytfDKTOs2r3olO975j9h1cRtykRw==
X-Received: by 2002:aca:4a0d:: with SMTP id x13mr287131oia.155.1605227757080;
        Thu, 12 Nov 2020 16:35:57 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z10sm1688859otp.0.2020.11.12.16.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 16:35:56 -0800 (PST)
Date:   Thu, 12 Nov 2020 16:35:50 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Message-ID: <5fadd4e6281_2784420869@john-XPS-13-9370.notmuch>
In-Reply-To: <20201112235934.gkydiegea4nhin3x@ast-mbp>
References: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
 <20201111031213.25109-2-alexei.starovoitov@gmail.com>
 <5fad89fb649af_2a612088e@john-XPS-13-9370.notmuch>
 <20201112235934.gkydiegea4nhin3x@ast-mbp>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Support for pointers beyond pkt_end.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Thu, Nov 12, 2020 at 11:16:11AM -0800, John Fastabend wrote:
> > Alexei Starovoitov wrote:
> > > From: Alexei Starovoitov <ast@kernel.org>
> > > 
> > > This patch adds the verifier support to recognize inlined branch conditions.
> > > The LLVM knows that the branch evaluates to the same value, but the verifier
> > > couldn't track it. Hence causing valid programs to be rejected.
> > > The potential LLVM workaround: https://reviews.llvm.org/D87428
> > > can have undesired side effects, since LLVM doesn't know that
> > > skb->data/data_end are being compared. LLVM has to introduce extra boolean
> > > variable and use inline_asm trick to force easier for the verifier assembly.
> > > 
> > > Instead teach the verifier to recognize that
> > > r1 = skb->data;
> > > r1 += 10;
> > > r2 = skb->data_end;
> > > if (r1 > r2) {
> > >   here r1 points beyond packet_end and
> > >   subsequent
> > >   if (r1 > r2) // always evaluates to "true".
> > > }
> > > 
> > > Tested-by: Jiri Olsa <jolsa@redhat.com>
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> > >  include/linux/bpf_verifier.h |   2 +-
> > >  kernel/bpf/verifier.c        | 129 +++++++++++++++++++++++++++++------
> > >  2 files changed, 108 insertions(+), 23 deletions(-)
> > > 
> > 
> > Thanks, we can remove another set of inline asm logic.
> 
> Awesome! Please contribute your C examples to selftests when possible.

Sure will do, its just some mundane header parsing iirc.

> 
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> >  
> > >  	if (pred >= 0) {
> > > @@ -7517,7 +7601,8 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
> > >  		 */
> > >  		if (!__is_pointer_value(false, dst_reg))
> > >  			err = mark_chain_precision(env, insn->dst_reg);
> > > -		if (BPF_SRC(insn->code) == BPF_X && !err)
> > > +		if (BPF_SRC(insn->code) == BPF_X && !err &&
> > > +		    !__is_pointer_value(false, src_reg))
> > 
> > This could have been more specific with !type_is_pkt_pointer() correct? I
> > think its fine as is though.
> 
> I actually meant to use __is_pointer_value() here for two reasons:
> 1. to match dst_reg check just few lines above.

Agree.

> 2. mark_chain_precision() is for scalars only. If in the future
>   is_*_branch_taken() will support other kinds of pointers the more
>   precise !type_is_pkt_pointer() check would need to be modified.
>   That would be unnecessary code churn.

Agree.
