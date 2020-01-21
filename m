Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A637F144573
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 20:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgAUTy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 14:54:26 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:34712 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgAUTyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 14:54:25 -0500
Received: by mail-il1-f195.google.com with SMTP id s15so3368594iln.1;
        Tue, 21 Jan 2020 11:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=k8bAcsCd/tZktRVdRFCYBEHh0jb8PJ4s9w2NXVYJ/qc=;
        b=sqpthOXJlRF4xa+oScZPERG6cZTI27lFCO9iNTfl9o6umbQIlin7JfoItoEhnosaxz
         EYjsrLUCRDRHMcr3iLC8AW26GqgJDrAcrgpOZzkDqqzk67MFlWiAyUpuduLTd3iUJ0o8
         ROCTA9i+36Z8V2YtP78y8SlAPtVLXoeAWcQA0wrevvT6Iqhr34UuiddwVg7GNBsVM6Ms
         F6hVec02GybPA6zCl4cDfIOpImweP5YzD82LO8EOleL6fWMtSFQEuoIx4usc8MKX2zcK
         9GXqcpEQ4IgrtjEUwYxDH+Ks7FgyrM3C6veCVSQCy2PDch9yd6M0gOlhzU+O96uWN2ez
         MGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=k8bAcsCd/tZktRVdRFCYBEHh0jb8PJ4s9w2NXVYJ/qc=;
        b=P/0H1TPO6Ngpk1tAGAQ7gmCNMtVDn4y8T/SwUkXTTvbL2hzpQtJHG64wnCZHezQS5d
         +UHvK++CfVxiaXgHvqujGrzk26cZGToTyZxggyT53eh4drnttFygnkebjM1q30k89vwD
         k6/rp+Ql4OpPoY6GdBKz2b740FexYYDPpwqa3msUG0A0W4xV/JXloRLmjWlSCESPk4O0
         BAHwN50ehy7A+F3t8tDCpfKyPN2XnQh45TL0LmkjpNSqs3vXBdgmv57qQAUB9RIRwVtV
         3H0k3rr/J+nBcJTA721Ma6ih1eFHqsh4qMcGsNUjtbRk1v4PR+SynFN54009t2e2LCIK
         zIWA==
X-Gm-Message-State: APjAAAV6HvlWVcyts6arJVP2bj3N+2rXtUL647ICRU6T/PKVa8vI3fiK
        D60kccHEKOE1ETouKzzO8PM=
X-Google-Smtp-Source: APXvYqw434hz+i85z4GEVU3QYpgqUxLduFmKlQVev22T8Q7vNK0SH+Kf3gbN4DtJYjKr46XwhVC3cQ==
X-Received: by 2002:a92:3a02:: with SMTP id h2mr5217258ila.236.1579636464472;
        Tue, 21 Jan 2020 11:54:24 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f12sm9798542iog.46.2020.01.21.11.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 11:54:24 -0800 (PST)
Date:   Tue, 21 Jan 2020 11:54:16 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <5e2756e81d8b2_74b42ad14ee465c08b@john-XPS-13-9370.notmuch>
In-Reply-To: <20200121190812.su5qrghfl7gefcqc@ast-mbp.dhcp.thefacebook.com>
References: <20200121005348.2769920-1-ast@kernel.org>
 <20200121005348.2769920-2-ast@kernel.org>
 <5e26aa0bc382b_32772acafb17c5b410@john-XPS-13-9370.notmuch>
 <20200121160018.2w4o6o5nnhbdqicn@ast-mbp.dhcp.thefacebook.com>
 <5e273fce74a7f_20522ac6ec2c45c457@john-XPS-13-9370.notmuch>
 <20200121190812.su5qrghfl7gefcqc@ast-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce dynamic program extensions
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Tue, Jan 21, 2020 at 10:15:42AM -0800, John Fastabend wrote:
> > Alexei Starovoitov wrote:
> > > On Mon, Jan 20, 2020 at 11:36:43PM -0800, John Fastabend wrote:
> > > > 
> > > > > +
> > > > > +	t1 = btf_type_skip_modifiers(btf1, t1->type, NULL);
> > > > > +	t2 = btf_type_skip_modifiers(btf2, t2->type, NULL);
> > > > 
> > > > Is it really best to skip modifiers? I would expect that if the
> > > > signature is different including modifiers then we should just reject it.
> > > > OTOH its not really C code here either so modifiers may not have the same
> > > > meaning. With just integers and struct it may be ok but if we add pointers
> > > > to ints then what would we expect from a const int*?
> > > > 
> > > > So whats the reasoning for skipping modifiers? Is it purely an argument
> > > > that its not required for safety so solve it elsewhere? In that case then
> > > > checking names of functions is also equally not required.
> > > 
> > > Function names are not checked by the kernel. It's purely libbpf and bpf_prog.c
> > > convention. The kernel operates on prog_fd+btf_id only. The names of function
> > > arguments are not compared either.
> > 
> > Sorry mistyped names of struct is what I meant, but that is probably nice to
> > have per comment.
> 
> I think comments in the kernel code won't be sufficient :) I'm planing to write
> a proper doc describing global functions and program extensions, since these
> concepts are coupled.
> 
> > > 
> > > The code has to skip modifiers. Otherwise the type comparison algorithm will be
> > > quite complex, since typedef is such modifier. Like 'u32' in original program
> > > and 'u32' in extension program would have to be recursively checked.
> > > 
> > > Another reason to skip modifiers is 'volatile' modifier. I suspect we would
> > > have to use it from time to time in original placeholder functions. Yet new
> > > replacement function will be written without volatile. The placeholder may need
> > > volatile to make sure compiler doesn't optimize things away. I found cases
> > > where 'noinline' in placeholder was not enough. clang would still inline the
> > > body of the function and remove call instruction. So far I've been using
> > > volatile as a workaround. May be we will introduce new function attribute to
> > > clang.
> > 
> > Yes, we have various similar issue and have in the past used volatile to work
> > around them but volatile's inside loops tends to break loop optimizations and
> > cause clang warnings/errors. Another common one is verifier failing to track
> > when scalars move around in registers. As an example the following is valid
> > C for a bounded additon to array pointer but not tractable for the verifier
> > at the moment. (made example at some point I'll dig up a collection of
> > real-world examples)
> > 
> >     r1 = *(u64 *)(r10 - 8)
> >     r6 = r1
> >     if r6 < %[const] goto %l[err]
> >     r3 += r1
> >     r2 = %[copy_size]
> >     r1 = r7
> >     call 4
> 
> Is it a sign compare in the above? The verifier currently struggles with sign
> compares. The issue you're describing could also be related to instruction
> combining optimization. Yonghong is working on undoing parts of instcombine here:
> https://reviews.llvm.org/D72787
> Dealing with 32-bit sign compares probably will be done as a verifier
> improvement. It's too hacky to do it in the llvm.

hmm I think it was an unsigned compare but I'll try to come up with some
simple examples of real code this week and post them. To illustrate some
of the verifier complaints we've been working around.

> 
> > compiler barriers help but not always and also breaks loop optimization
> > passes. But, thats a different discussion I only mention it because
> > either verifier has to track above logic better or new attributes in clang
> > could be used for these things. But the new attributes don't usually work
> > well when mixed with optimization passes that we would actually like to
> > keep.
> 
> yep. unfortunately llvm folks didn't like the idea of disabling individual
> optimization passes or parts of passes based on the backend flag. Hence BPF
> backend has to normalize IR before generating asm. Since all of the issues
> related to "llvm optimizing too much and verifier is too dumb" are related to
> missed tracking of registers, I'm thinking that we may try virtual register
> approach. Instead of doing register allocation and spill/fill in the llvm the
> backend may generate as many virtual registers as necessary and final BPF
> assembly will look like SSA except phisical registers will still be used to
> receive and pass arguments while all other math, branches will operate on
> virtual registers. Then the kernel will do register alloc after verification. I
> hope that should help the verifier get smarter at the expense of less efficient
> code and more spill/fill. But that is the last resort.

Interesting. Or maybe follow the parent chain and push information down the
chain when we see register moves and further bounds refining.

> 
> > > 
> > > Having said that I share your concern regarding skipping 'const'. For 'const
> > > int arg' it's totally ok to skip it, since it's meaningless from safety pov,
> > > but for 'const int *arg' and 'const struct foo *arg' I'm planning to preserve
> > > it. It will be preserved at the verifier bpf_reg_state level though. Just
> > > checking that 'const' is present in extension prog's BTF doesn't help safety.
> > > I'm planing to make the verifier enforce that bpf prog cannot write into
> > > argument which type is pointer to const struct. That part is still wip. It will
> > > be implemented for global functions first and then for extension programs.
> > > Currently the verifier rejects any pointer to struct (other than context), so
> > > no backward compatibility issues.
> > 
> > Ah ok this will be great. In that case const will be more general then
> > merely functions and should be applicable generally at least as an end
> > goal IMO. There will be a slight annoyance where old extensions may not
> > run on new kernels though. I will argue such extensions are broken though.
> 
> 'old extensions' won't run? I don't see it. Strict 'const' enforcement
> for pointers to struct won't break things. Currently pointers to struct
> are not supported. Only a pointer to one specific struct which is context.
> That's different. I don't think there will be any compatibility issues.

Right its not an issue.

> 
> > For this patch then,
> > 
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> 
> Thanks for the review!
