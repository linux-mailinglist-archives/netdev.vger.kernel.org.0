Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D0E144421
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 19:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgAUSPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 13:15:53 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:38584 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAUSPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 13:15:53 -0500
Received: by mail-il1-f195.google.com with SMTP id f5so3101901ilq.5;
        Tue, 21 Jan 2020 10:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=HhzQ2HEbpoArdE+H7PJkpGcXDRKyyTvQZZodOusLYx8=;
        b=Q/+m+BE8R22RkoM4DDnEb6oQHvI/ApuzNQfJz5t9b316OqXlDZ2A/9c0eyZnK7YG0u
         LX6cnN/4/87qUl/aAF7rPt/QR4B3aR3GF3jTB5Ema4fCaGoxJagUjXOUAPCLXK1tRqdb
         dZ5o4WSSbewhY5S1NxTV9ylLy2lKBxgsdG0GHVbG1a7LM0LC9OnnOKyg7aip2j5Ycopb
         zVoqIys+g/DohMmUE+XvjcXAaTPM+jgm//R5fw9nUF/Eu/V8p9CB2HWOESZcYfMFNr/5
         TI3AQpyY0eG/A0/rrF14RRc8ce7krpGC+WOeLpupXscArkRsNkHSKKQApBxKsyZltCyb
         NTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=HhzQ2HEbpoArdE+H7PJkpGcXDRKyyTvQZZodOusLYx8=;
        b=Ow+k8Bm+MwXTZ5SUlQxiGBSKta5qWZ6iQ0ys/3TP1PpPToIMFrBVLmfEt/FZ3vRn5U
         w7H0//dtjy7XYaK+RFglqt5/ApOjAO4z2XDWXPBCw+pHYHnz60IYVE1PwGTpSzDkJDuU
         XBH4kO6M54N1uY2bTYH6ZuLfDgAvLU8lG92T2OL8vBJ3RKIZ2PP9/AtvRiLoewE+6Nhr
         ua+IgJQ/dFvXEZML4aAmYPLx7irZe3HBJDVq4xF5yyu5zZuxA8D0MACcDqDHVZ6cyHjS
         N6C50JxLLKH45Y+2bmHMyNmjgkDGPQtCx+kRxHQThIKU0lg0fDjJhbxOVrZL7gKChEza
         oJjg==
X-Gm-Message-State: APjAAAWpAAI0xhUyBlJYpWKEJ9hfneDxKU0ZfnNy+XgWEIZLrpGNa4Vz
        5vyOT6WFYxGsf76DZeUwU6g=
X-Google-Smtp-Source: APXvYqw8fvyS4ku0EjJI9dpR/Nraz+WPzgMOUe6x6NWDMDxApIZEVqtlRHsN/G8v/FLaAIpbuEtC6A==
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr4385735ilq.215.1579630552421;
        Tue, 21 Jan 2020 10:15:52 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h4sm9931869ioq.40.2020.01.21.10.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 10:15:51 -0800 (PST)
Date:   Tue, 21 Jan 2020 10:15:42 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <5e273fce74a7f_20522ac6ec2c45c457@john-XPS-13-9370.notmuch>
In-Reply-To: <20200121160018.2w4o6o5nnhbdqicn@ast-mbp.dhcp.thefacebook.com>
References: <20200121005348.2769920-1-ast@kernel.org>
 <20200121005348.2769920-2-ast@kernel.org>
 <5e26aa0bc382b_32772acafb17c5b410@john-XPS-13-9370.notmuch>
 <20200121160018.2w4o6o5nnhbdqicn@ast-mbp.dhcp.thefacebook.com>
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
> On Mon, Jan 20, 2020 at 11:36:43PM -0800, John Fastabend wrote:
> > 
> > > +
> > > +	t1 = btf_type_skip_modifiers(btf1, t1->type, NULL);
> > > +	t2 = btf_type_skip_modifiers(btf2, t2->type, NULL);
> > 
> > Is it really best to skip modifiers? I would expect that if the
> > signature is different including modifiers then we should just reject it.
> > OTOH its not really C code here either so modifiers may not have the same
> > meaning. With just integers and struct it may be ok but if we add pointers
> > to ints then what would we expect from a const int*?
> > 
> > So whats the reasoning for skipping modifiers? Is it purely an argument
> > that its not required for safety so solve it elsewhere? In that case then
> > checking names of functions is also equally not required.
> 
> Function names are not checked by the kernel. It's purely libbpf and bpf_prog.c
> convention. The kernel operates on prog_fd+btf_id only. The names of function
> arguments are not compared either.

Sorry mistyped names of struct is what I meant, but that is probably nice to
have per comment.

> 
> The code has to skip modifiers. Otherwise the type comparison algorithm will be
> quite complex, since typedef is such modifier. Like 'u32' in original program
> and 'u32' in extension program would have to be recursively checked.
> 
> Another reason to skip modifiers is 'volatile' modifier. I suspect we would
> have to use it from time to time in original placeholder functions. Yet new
> replacement function will be written without volatile. The placeholder may need
> volatile to make sure compiler doesn't optimize things away. I found cases
> where 'noinline' in placeholder was not enough. clang would still inline the
> body of the function and remove call instruction. So far I've been using
> volatile as a workaround. May be we will introduce new function attribute to
> clang.

Yes, we have various similar issue and have in the past used volatile to work
around them but volatile's inside loops tends to break loop optimizations and
cause clang warnings/errors. Another common one is verifier failing to track
when scalars move around in registers. As an example the following is valid
C for a bounded additon to array pointer but not tractable for the verifier
at the moment. (made example at some point I'll dig up a collection of
real-world examples)

    r1 = *(u64 *)(r10 - 8)
    r6 = r1
    if r6 < %[const] goto %l[err]
    r3 += r1
    r2 = %[copy_size]
    r1 = r7
    call 4

compiler barriers help but not always and also breaks loop optimization
passes. But, thats a different discussion I only mention it because
either verifier has to track above logic better or new attributes in clang
could be used for these things. But the new attributes don't usually work
well when mixed with optimization passes that we would actually like to
keep.

> 
> Having said that I share your concern regarding skipping 'const'. For 'const
> int arg' it's totally ok to skip it, since it's meaningless from safety pov,
> but for 'const int *arg' and 'const struct foo *arg' I'm planning to preserve
> it. It will be preserved at the verifier bpf_reg_state level though. Just
> checking that 'const' is present in extension prog's BTF doesn't help safety.
> I'm planing to make the verifier enforce that bpf prog cannot write into
> argument which type is pointer to const struct. That part is still wip. It will
> be implemented for global functions first and then for extension programs.
> Currently the verifier rejects any pointer to struct (other than context), so
> no backward compatibility issues.

Ah ok this will be great. In that case const will be more general then
merely functions and should be applicable generally at least as an end
goal IMO. There will be a slight annoyance where old extensions may not
run on new kernels though. I will argue such extensions are broken though.

For this patch then,

Acked-by: John Fastabend <john.fastabend@gmail.com>
