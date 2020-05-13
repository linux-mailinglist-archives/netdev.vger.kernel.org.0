Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA441D21FA
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 00:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731391AbgEMWY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 18:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730064AbgEMWY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 18:24:28 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B576C061A0C;
        Wed, 13 May 2020 15:24:28 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b12so362790plz.13;
        Wed, 13 May 2020 15:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WmWq9Zm5dP2zr07YUFHQo3EIGqCObwYkKIKNX9xyQno=;
        b=R8gimsX5sAFpVrbMwhCK4ULV83UVFlrGqGgAKtACREqtiOocpWc0r77mWdvAXHL1bS
         H0y1f8Qb4ddpCeWFXanVDsMrxWQGRzskUTpcpFMY/aLkOj9toPRVAAxzbWOEkvPkkHF9
         nFZBEVMoz/Qj+vNmdwoDBlV9zB2zsMw6LelsblLOd4YfUum1JV+KEMMslkMkUmYzzdG1
         MW0uLfxdQgQeuRcKj89+sopE/crnsYzBAnFXS4AxVn6Ahm+MxDYKGg1Y7gNq679T7YZW
         8WLwnZED0TCRpB1uOi7WDvu9tMsLbZC+QrMF+plhKuDymAu474wKD9n5DTVI/dcC+OZO
         w0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WmWq9Zm5dP2zr07YUFHQo3EIGqCObwYkKIKNX9xyQno=;
        b=XvcV4OjlQ57UOrE7VcO0a6pV4tSFgRLMKpkalhcVmUmWTSQKzZgciUjEUgxBRgUxn2
         7dZRFi95bED1f7hT0uvrV18pqmDjWxJINki4fNieMQjJIlWzeU+0ZoO4lJ5qsijA/t2G
         ZFoNAQyIcXSupsrlbVWjfrfPKhfzLtavL7SikXBBdkn4wA1a1sAYrbxjP25pJl0X0cmr
         Un60c01W95C9jYQtnWMYOMNdj/FwF+sF9gdew4fOzVOTAIuwyzYWgmqW3e+J/xrbN7JW
         UzBIql+v2cXbHLi+y9T9OmECx3JLVswyapepRGBgpwQLf2VFLfi5cmiVgeyYqcTymdTh
         cF2A==
X-Gm-Message-State: AGi0PuaoUJHYUefq0IP2c47dE/r9nPLXRHZY2VjoIC7+4knif39N6U9h
        WCc5oQia416EM+PAkfPQgcg=
X-Google-Smtp-Source: APiQypKqQyj2n0uBCUIxBPmkRCCFp7Mr0Seb93LDTZZ8Q9qensXYZQgvOUQmqE2dEJw1jfVURFARmQ==
X-Received: by 2002:a17:90a:ce8f:: with SMTP id g15mr27859883pju.203.1589408667835;
        Wed, 13 May 2020 15:24:27 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:ba8f])
        by smtp.gmail.com with ESMTPSA id y2sm500580pfq.16.2020.05.13.15.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 15:24:27 -0700 (PDT)
Date:   Wed, 13 May 2020 15:24:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        joe@perches.com, linux@rasmusvillemoes.dk, arnaldo.melo@gmail.com,
        yhs@fb.com, kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 0/7] bpf, printk: add BTF-based type printing
Message-ID: <20200513222424.4nfxgkequhdzn3u3@ast-mbp.dhcp.thefacebook.com>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 06:56:38AM +0100, Alan Maguire wrote:
> The printk family of functions support printing specific pointer types
> using %p format specifiers (MAC addresses, IP addresses, etc).  For
> full details see Documentation/core-api/printk-formats.rst.
> 
> This patchset proposes introducing a "print typed pointer" format
> specifier "%pT"; the argument associated with the specifier is of
> form "struct btf_ptr *" which consists of a .ptr value and a .type
> value specifying a stringified type (e.g. "struct sk_buff") or
> an .id value specifying a BPF Type Format (BTF) id identifying
> the appropriate type it points to.
> 
> There is already support in kernel/bpf/btf.c for "show" functionality;
> the changes here generalize that support from seq-file specific
> verifier display to the more generic case and add another specific
> use case; snprintf()-style rendering of type information to a
> provided buffer.  This support is then used to support printk
> rendering of types, but the intent is to provide a function
> that might be useful in other in-kernel scenarios; for example:
> 
> - ftrace could possibly utilize the function to support typed
>   display of function arguments by cross-referencing BTF function
>   information to derive the types of arguments
> - oops/panic messaging could extend the information displayed to
>   dig into data structures associated with failing functions
> 
> The above potential use cases hint at a potential reply to
> a reasonable objection that such typed display should be
> solved by tracing programs, where the in kernel tracing records
> data and the userspace program prints it out.  While this
> is certainly the recommended approach for most cases, I
> believe having an in-kernel mechanism would be valuable
> also.
> 
> The function the printk() family of functions rely on
> could potentially be used directly for other use cases
> like ftrace where we might have the BTF ids of the
> pointers we wish to display; its signature is as follows:
> 
> int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
>                            char *buf, int len, u64 flags);
> 
> So if ftrace say had the BTF ids of the types of arguments,
> we see that the above would allow us to convert the
> pointer data into displayable form.
> 
> To give a flavour for what the printed-out data looks like,
> here we use pr_info() to display a struct sk_buff *.
> 
>   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
> 
>   pr_info("%pT", BTF_PTR_TYPE(skb, "struct sk_buff"));
> 
> ...gives us:
> 
> (struct sk_buff){
>  .transport_header = (__u16)65535,
>  .mac_header = (__u16)65535,
>  .end = (sk_buff_data_t)192,
>  .head = (unsigned char *)000000007524fd8b,
>  .data = (unsigned char *)000000007524fd8b,

could you add "0x" prefix here to make it even more C like
and unambiguous ?

>  .truesize = (unsigned int)768,
>  .users = (refcount_t){
>   .refs = (atomic_t){
>    .counter = (int)1,
>   },
>  },
> }
> 
> For bpf_trace_printk() a "struct __btf_ptr *" is used as
> argument; see tools/testing/selftests/bpf/progs/netif_receive_skb.c
> for example usage.
> 
> The hope is that this functionality will be useful for debugging,
> and possibly help facilitate the cases mentioned above in the future.
> 
> Changes since v1:
> 
> - changed format to be more drgn-like, rendering indented type info
>   along with type names by default (Alexei)
> - zeroed values are omitted (Arnaldo) by default unless the '0'
>   modifier is specified (Alexei)
> - added an option to print pointer values without obfuscation.
>   The reason to do this is the sysctls controlling pointer display
>   are likely to be irrelevant in many if not most tracing contexts.
>   Some questions on this in the outstanding questions section below...
> - reworked printk format specifer so that we no longer rely on format
>   %pT<type> but instead use a struct * which contains type information
>   (Rasmus). This simplifies the printk parsing, makes use more dynamic
>   and also allows specification by BTF id as well as name.
> - ensured that BTF-specific printk code is bracketed by
>   #if ENABLED(CONFIG_BTF_PRINTF)

I don't like this particular bit:
+config BTF_PRINTF
+       bool "print type information using BPF type format"
+       depends on DEBUG_INFO_BTF
+       default n

Looks like it's only purpose is to gate printk test.
In such case please convert it into hidden config that is
automatically selected when DEBUG_INFO_BTF is set.
Or just make printk tests to #if IS_ENABLED(DEBUG_INFO_BTF)

> - removed incorrect patch which tried to fix dereferencing of resolved
>   BTF info for vmlinux; instead we skip modifiers for the relevant
>   case (array element type/size determination) (Alexei).
> - fixed issues with negative snprintf format length (Rasmus)
> - added test cases for various data structure formats; base types,
>   typedefs, structs, etc.
> - tests now iterate through all typedef, enum, struct and unions
>   defined for vmlinux BTF and render a version of the target dummy
>   value which is either all zeros or all 0xff values; the idea is this
>   exercises the "skip if zero" and "print everything" cases.
> - added support in BPF for using the %pT format specifier in
>   bpf_trace_printk()
> - added BPF tests which ensure %pT format specifier use works (Alexei).
> 
> Outstanding issues
> 
> - currently %pT is not allowed in BPF programs when lockdown is active
>   prohibiting BPF_READ; is that sufficient?

yes. that's enough.

> - do we want to further restrict the non-obfuscated pointer format
>   specifier %pTx; for example blocking unprivileged BPF programs from
>   using it?

unpriv cannot use bpf_trace_printk() anyway. I'm not sure what is the concern.

> - likely still need a better answer for vmlinux BTF initialization
>   than the current approach taken; early boot initialization is one
>   way to go here.

btf_parse_vmlinux() can certainly be moved to late_initcall().

> - may be useful to have a "print integers as hex" format modifier (Joe)

I'd rather stick to the convention that the type drives the way the value is printed.
For example:
  u8 ch = 65;
  pr_info("%pT", BTF_PTR_TYPE(&ch, "char"));
  prints 'A'
while
  u8 ch = 65;
  pr_info("%pT", BTF_PTR_TYPE(&ch, "u8"));
  prints 65

> 
> Important note: if running test_printf.ko - the version in the bpf-next
> tree will induce a panic when running the fwnode_pointer() tests due
> to a kobject issue; applying the patch in
> 
> https://lkml.org/lkml/2020/4/17/389

Thanks for the headsup!

BTF_PTR_ID() is a great idea as well.
In the llvm 11 we will introduce __builtin__btf_type_id().
The bpf program will be able to say:
bpf_printk("%pT", BTF_PTR_ID(skb, __builtin_btf_type_id(skb, 1)));
That will help avoid run-time search through btf types by string name.
The compiler will supply btf_id at build time and libbpf will do
a relocation into vmlinux btf_id prior to loading.

Also I think there should be another flag BTF_SHOW_PROBE_DATA.
It should probe_kernel_read() all data instead of direct dereferences.
It could be implemented via single probe_kernel_read of the whole BTF data
structure before pringing the fields one by one. So it should be simple
addition to patch 2.
This flag should be default for printk() from bpf program,
since the verifier won't be checking that pointer passed into bpf_trace_printk
is of correct btf type and it's a real pointer.
Whether this flag should be default for normal printk() is arguable.
I would make it so. The performance cost of extra copy is small comparing
with no-crash guarantee it provides. I think it would be a good trade off.

In the future we can extend the verifier so that:
bpf_safe_printk("%pT", skb);
will be recognized that 'skb' is PTR_TO_BTF_ID and corresponding and correct
btf_id is passed into printk. Mistakes will be caught at program
verification time.
