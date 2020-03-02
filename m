Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD13176787
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 23:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgCBWhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 17:37:54 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34544 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgCBWhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 17:37:53 -0500
Received: by mail-pf1-f196.google.com with SMTP id y21so428761pfp.1;
        Mon, 02 Mar 2020 14:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=E4j2khFom9WbWJYI0JJ4Oj4FfVAH6TUg09opZHP3DUQ=;
        b=VK5km7mC2B7BPdDbwLDq1SFNyVpvEk28HXfPktKbKCcn5P71cZ8mg70Hy6BuTohZk2
         QZj5FtQJfYfUcCr70N++5IY8Eh/WJOSYja+1U2MH9qCQaBxrsFqdGGlG6UPAO+hQsEyb
         c2bhlTmhnHS8P8/SimbLzveMZuy/Xmoy+BIYfyljVv453rXrkIA18Ajmvfzjl2uUsw7x
         xXN4zJFSukJnFLjJsPeIdyUcdYyXcuVHMeRH6XmC96NTdwFlblPJLRJMmS/BqJWoLw6/
         2JZV3aCsabi/fNm1qV3tygTTG1qNpPFml3I88S9M3AfAdO5JqqjoGmZcY9C4AOV4vtEF
         ULyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=E4j2khFom9WbWJYI0JJ4Oj4FfVAH6TUg09opZHP3DUQ=;
        b=e/3jQw/Z/eK7ZdYJJ92c04if2SxfCntwLpNMeUT0p1WvWqSO5dZETEI5ZLP2HB1OXK
         xIjyoe4Z+GOJckby9Z9WvO6kxtUV3/QEQRXNgJzaBfzSFkDa8FkIz8IED5bo/OdsUr+o
         mQvvtJ7noQBuVYJ01811RdqROc7HSLDlRuaV+y4Tl9cdgEP6YR0LRnupDS3iUd/ck6pW
         tI9cYhBbGw5OPB2IIOCA+33XFHqCALWRYcYWvuciIRbvDKv0Io44ar8Xb/jTXZwOr+mK
         NNOyZF9NQ+nbTfG+zmkkKKsKbwLMPx3k7smYNiwhxhU/GBLbEht9VFoUIjue8Dmyf0j0
         gF6A==
X-Gm-Message-State: ANhLgQ04VRzXnuiqb/MfKRkBBrTGHiU8Q1BgYcQmUSpcJOxpaRSvnbPO
        9gjKBQMkV9YWusRWT5fbbnI=
X-Google-Smtp-Source: ADFU+vtJA4RWyPwKkN1uOqkCAK/JWk5Gv8JXlQ/+CxP6k9X9t73Ci1S1Yrh5UyzAX98tOkToeqKi+w==
X-Received: by 2002:a63:78c4:: with SMTP id t187mr1103798pgc.88.1583188672403;
        Mon, 02 Mar 2020 14:37:52 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::7:1db6])
        by smtp.gmail.com with ESMTPSA id h7sm23258300pfq.36.2020.03.02.14.37.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 14:37:51 -0800 (PST)
Date:   Mon, 2 Mar 2020 14:37:49 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: switch BPF UAPI #define constants
 to enums
Message-ID: <20200302223748.v4omummx43pejzfn@ast-mbp>
References: <20200301062405.2850114-1-andriin@fb.com>
 <20200301062405.2850114-2-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200301062405.2850114-2-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 29, 2020 at 10:24:03PM -0800, Andrii Nakryiko wrote:
> Switch BPF UAPI constants, previously defined as #define macro, to anonymous
> enum values. This preserves constants values and behavior in expressions, but
> has added advantaged of being captured as part of DWARF and, subsequently, BTF
> type info. Which, in turn, greatly improves usefulness of generated vmlinux.h
> for BPF applications, as it will not require BPF users to copy/paste various
> flags and constants, which are frequently used with BPF helpers.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  include/uapi/linux/bpf.h              | 272 +++++++++++++++----------
>  include/uapi/linux/bpf_common.h       |  86 ++++----
>  include/uapi/linux/btf.h              |  60 +++---
>  tools/include/uapi/linux/bpf.h        | 274 ++++++++++++++++----------
>  tools/include/uapi/linux/bpf_common.h |  86 ++++----
>  tools/include/uapi/linux/btf.h        |  60 +++---
>  6 files changed, 497 insertions(+), 341 deletions(-)

I see two reasons why converting #define to enum is useful:
1. bpf progs can use them from vmlinux.h as evident in patch 3.
2. "bpftool feature probe" can be replaced with
  bpftool btf dump file /sys/kernel/btf/vmlinux |grep BPF_CGROUP_SETSOCKOPT

The second use case is already possible, since bpf_prog_type,
bpf_attach_type, bpf_cmd, bpf_func_id are all enums.
So kernel is already self describing most bpf features.
Does kernel support bpf_probe_read_user() ? Answer is:
bpftool btf dump file /sys/kernel/btf/vmlinux | grep BPF_FUNC_probe_read_user

The only bit missing is supported kernel flags and instructions.

I think for now I would only convert flags that are going to be
used from bpf program and see whether 1st use case works well.
Later we can convert flags that are used out of user space too.

In other words:

> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 8e98ced0963b..03e08f256bd1 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -14,34 +14,36 @@
>  /* Extended instruction set based on top of classic BPF */
>  
>  /* instruction classes */
> -#define BPF_JMP32	0x06	/* jmp mode in word width */
> -#define BPF_ALU64	0x07	/* alu mode in double word width */
> +enum {
> +	BPF_JMP32	= 0x06,	/* jmp mode in word width */
> +	BPF_ALU64	= 0x07,	/* alu mode in double word width */

not those.

> -#define BPF_F_ALLOW_OVERRIDE	(1U << 0)
> -#define BPF_F_ALLOW_MULTI	(1U << 1)
> -#define BPF_F_REPLACE		(1U << 2)
> +enum {
> +	BPF_F_ALLOW_OVERRIDE	= (1U << 0),
> +	BPF_F_ALLOW_MULTI	= (1U << 1),
> +	BPF_F_REPLACE		= (1U << 2),
> +};

not those either. These are the flags for user space. Not for the prog.

>  /* flags for BPF_MAP_UPDATE_ELEM command */
> -#define BPF_ANY		0 /* create new element or update existing */
> -#define BPF_NOEXIST	1 /* create new element if it didn't exist */
> -#define BPF_EXIST	2 /* update existing element */
> -#define BPF_F_LOCK	4 /* spin_lock-ed map_lookup/map_update */
> +enum {
> +	BPF_ANY		= 0, /* create new element or update existing */
> +	BPF_NOEXIST	= 1, /* create new element if it didn't exist */
> +	BPF_EXIST	= 2, /* update existing element */
> +	BPF_F_LOCK	= 4, /* spin_lock-ed map_lookup/map_update */
> +};

yes to these.

>  /* BPF_FUNC_skb_store_bytes flags. */
> -#define BPF_F_RECOMPUTE_CSUM		(1ULL << 0)
> -#define BPF_F_INVALIDATE_HASH		(1ULL << 1)
> +enum {
> +	BPF_F_RECOMPUTE_CSUM		= (1ULL << 0),
> +	BPF_F_INVALIDATE_HASH		= (1ULL << 1),
> +};

yes.

>  /* BPF_FUNC_l3_csum_replace and BPF_FUNC_l4_csum_replace flags.
>   * First 4 bits are for passing the header field size.
>   */
> -#define BPF_F_HDR_FIELD_MASK		0xfULL
> +enum {
> +	BPF_F_HDR_FIELD_MASK		= 0xfULL,
> +};

yes.

>  /* flags for both BPF_FUNC_get_stackid and BPF_FUNC_get_stack. */
> -#define BPF_F_SKIP_FIELD_MASK		0xffULL
> -#define BPF_F_USER_STACK		(1ULL << 8)
> +enum {
> +	BPF_F_SKIP_FIELD_MASK		= 0xffULL,
> +	BPF_F_USER_STACK		= (1ULL << 8),
>  /* flags used by BPF_FUNC_get_stackid only. */
> -#define BPF_F_FAST_STACK_CMP		(1ULL << 9)
> -#define BPF_F_REUSE_STACKID		(1ULL << 10)
> +	BPF_F_FAST_STACK_CMP		= (1ULL << 9),
> +	BPF_F_REUSE_STACKID		= (1ULL << 10),
>  /* flags used by BPF_FUNC_get_stack only. */
> -#define BPF_F_USER_BUILD_ID		(1ULL << 11)
> +	BPF_F_USER_BUILD_ID		= (1ULL << 11),
> +};

yes.

>  /* BPF_FUNC_skb_set_tunnel_key flags. */
> -#define BPF_F_ZERO_CSUM_TX		(1ULL << 1)
> -#define BPF_F_DONT_FRAGMENT		(1ULL << 2)
> -#define BPF_F_SEQ_NUMBER		(1ULL << 3)
> +enum {
> +	BPF_F_ZERO_CSUM_TX		= (1ULL << 1),
> +	BPF_F_DONT_FRAGMENT		= (1ULL << 2),
> +	BPF_F_SEQ_NUMBER		= (1ULL << 3),
> +};
>  
>  /* BPF_FUNC_perf_event_output, BPF_FUNC_perf_event_read and
>   * BPF_FUNC_perf_event_read_value flags.
>   */
> -#define BPF_F_INDEX_MASK		0xffffffffULL
> -#define BPF_F_CURRENT_CPU		BPF_F_INDEX_MASK
> +enum {
> +	BPF_F_INDEX_MASK		= 0xffffffffULL,
> +	BPF_F_CURRENT_CPU		= BPF_F_INDEX_MASK,
>  /* BPF_FUNC_perf_event_output for sk_buff input context. */
> -#define BPF_F_CTXLEN_MASK		(0xfffffULL << 32)
> +	BPF_F_CTXLEN_MASK		= (0xfffffULL << 32),
> +};

yes.

In all such cases I don't think we need #define FOO FOO
trick. These are the flags used within bpf program.
I don't think any user is doing #ifdef logic there.
I cannot come up with a use case of anything useful this way.
