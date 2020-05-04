Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3E91C4A93
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgEDXsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgEDXsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:48:31 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06C1C061A0E;
        Mon,  4 May 2020 16:48:31 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w3so55782plz.5;
        Mon, 04 May 2020 16:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cfGiwA9LJRPCF3MX+zGph8ephlPPnJi7faJRy6NmTEM=;
        b=Hq/36UR+001Cwdpa+mLC4Zh1Dcu1HO4VDCScIWOw8YBsam7r8K5FJE6vJ9SIQbW63u
         aZVS9VhnNj2uoCryrXVaqOT/FdQNN+lyHz3/l0DJCuAsnNHIwbmDwUw+U6SmwsZnWNx6
         ZESTIljqgaWBKyjgbYVs4Q7S4yyzcoCVOcbCeVdtVH8JbYn1ZwOJGF14QDPRHGjAPf/2
         b/PfjO40F+JR2HcxpZKjhuQ3x9bojDpkdIOs06HpzMlHhNdD2ZAomcxiP7QdR/UUAMBo
         abHjooMu6Xsxd82zotN0x0zki5QsSWlcIoO6C7PTq4vLwRvIvndkrVUCO74g2ZM3M/v3
         qx7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cfGiwA9LJRPCF3MX+zGph8ephlPPnJi7faJRy6NmTEM=;
        b=jrwU4HdkadwUW8Zma68ru6okUFdEzH8VCz9BEQeLK8kyfYEuAdkvyLjGRimEQE1OZG
         vETZVs7WF4tkIxHq68QBKq/6RWxXPM+76GwyMrnhV2Jk5U0GOVzufS10fI2OvZYAGyjV
         pnoDhNRZbWl+5pKbCY+Paj/+dB8+RlhTQdHTddgbXoHKHYPCfq4CUJW7SeilrtWqdMM9
         Cc1nZSp52UWXKtBXF3r1phu3DXXJoNFm1xnp4S8Z/4M/3xpVMbAx7pvrgNb2PV5RPwhb
         +aitMlOVgvsphvdM4FgkAFg+lf7FaYE4ghB4cRlJoRpANAtqmoQM3GMH92ZdW262AgNH
         U+cg==
X-Gm-Message-State: AGi0PuaPnZXCDFD4eYr+Qz0nIbBZftFBcWxFRq5JNk9ZnMs+sgRefZ66
        QAs1a+NE/4tlMSggVLM/QOg=
X-Google-Smtp-Source: APiQypJojuvPLz4twGJW8t6CwdqX8pTJnOfRf5lowAkSZK9DI6d6rObg5OP7V/JcqnXhLMsmIvR3kw==
X-Received: by 2002:a17:902:fe09:: with SMTP id g9mr416924plj.65.1588636111122;
        Mon, 04 May 2020 16:48:31 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1bad])
        by smtp.gmail.com with ESMTPSA id b140sm191542pfb.119.2020.05.04.16.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:48:30 -0700 (PDT)
Date:   Mon, 4 May 2020 16:48:27 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Theo Julienne <theojulienne@github.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH 1/1] selftests/bpf: add cls_redirect classifier
Message-ID: <20200504234827.6mrogryxk73jc6x2@ast-mbp.dhcp.thefacebook.com>
References: <20200424185556.7358-1-lmb@cloudflare.com>
 <20200424185556.7358-2-lmb@cloudflare.com>
 <20200426173324.5zg7isugereb5ert@ast-mbp.dhcp.thefacebook.com>
 <CACAyw98nK_Vkstp-vEqNwKXtoCRnTOPr7Eh+ziH56tJGbnPsig@mail.gmail.com>
 <185417b8-0d50-f8a3-7a09-949066579732@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <185417b8-0d50-f8a3-7a09-949066579732@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 02, 2020 at 01:48:51AM +0200, Daniel Borkmann wrote:
> On 4/27/20 11:45 AM, Lorenz Bauer wrote:
> > On Sun, 26 Apr 2020 at 18:33, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> [...]
> > > > +/* Linux packet pointers are either aligned to NET_IP_ALIGN (aka 2 bytes),
> > > > + * or not aligned if the arch supports efficient unaligned access.
> > > > + *
> > > > + * Since the verifier ensures that eBPF packet accesses follow these rules,
> > > > + * we can tell LLVM to emit code as if we always had a larger alignment.
> > > > + * It will yell at us if we end up on a platform where this is not valid.
> > > > + */
> > > > +typedef uint8_t *net_ptr __attribute__((align_value(8)));
> > > 
> > > Wow. I didn't know about this attribute.
> > > I wonder whether it can help Daniel's memcpy hack.
> > 
> > Yes, I think so.
> 
> Just for some more context [0]. I think the problem is a bit more complex in
> general. Generally, _any_ kind of pointer to some data (except for the stack)
> is currently treated as byte-by-byte copy from __builtin_memcpy() and other
> similarly available __builtin_*() helpers on BPF backend since the backend
> cannot make any assumptions about the data's alignment and whether unaligned
> access from the underlying arch is ok & efficient (the latter the verifier
> does judge for us however). So it's definitely not just limited to xdp->data.
> There is also the issue that while access to any non-stack data can be
> unaligned, access to the stack however cannot. I've discussed a while back
> with Yonghong about potential solutions. One would be to add a small patch
> to the BPF backend to enable __builtin_*() helpers to allow for unaligned
> access which could then be opt-ed in e.g. via -mattr from llc for the case
> when we know that the compiled program only runs on archs with efficient
> unaligned access anyway. However, this still potentially breaks with the BPF
> stack for the case when objects are, for example, larger than size 8 but with
> a natural alignment smaller than 8 where __builtin_memcpy() would then decide
> to emit dw-typed load/stores. But for these cases could then be annotated via
> __aligned(8) on stack. So this is basically what we do right now as a generic
> workaround in Cilium [0], meaning, our own memcpy/memset with optimal number
> of instructions and __aligned(8) where needed; most of the time this __aligned(8)
> is not needed, so it's really just a few places, and we also have a cocci
> scripts to catch these during development if needed. Anyway, real thing would
> be to allow the BPF stack for unaligned access as well and then BPF backend
> could nicely solve this in a native way w/o any workarounds, but that is tbd.
> 
> Thanks,
> Daniel
> 
>   [0] https://github.com/cilium/cilium/blob/master/bpf/include/bpf/builtins.h

Daniel,
do you mind adding such memcpy to libbpf ?
