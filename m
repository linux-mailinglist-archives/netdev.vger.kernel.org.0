Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8867546A5CD
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348602AbhLFTmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346738AbhLFTmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:42:39 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4908C061746;
        Mon,  6 Dec 2021 11:39:10 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id 15so11396505ilq.2;
        Mon, 06 Dec 2021 11:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=7MNTPaPMAIedAFVlet93iaHAUg9zOwM18moopl7g9lc=;
        b=nYSPhhiPqu87OH4ju8JFgjZqWw8aeeGoO/7Fd8uMBxWyDyCu5UDbAF/WXAFAOP84ts
         hqr01P/cLnktZDpdIyxc2m9YnD8uTPwHy/4B1OZFqsKE8PZTeCP6Xke9V4kMHk4EKRrb
         PzfQnXAH1sdxUkuhp832s8B3iNi4nrGtYLmgSoD9clrjIAw3fODUKg9J+ph97kylCEeZ
         ySkUeXk83jfZ+dVqV9Ryh3UDnk5rcBWW4Uats+RHapQeNHtO00oa6f9DEVfmByrImIrU
         GpH5cdPRsrirOAd/3pohp6zAQs/dFQCWQylZWQUSQLhY+9Hqq12Yzv3h0dvllKbW1cnF
         AFLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=7MNTPaPMAIedAFVlet93iaHAUg9zOwM18moopl7g9lc=;
        b=4wZG7yyTOLajfNNV+MBhccIGxuefvNQAQ61jtYbfTKWJYMJhC2maRXslJeqpm4PCxC
         Tgbe0NE9X7c12cjlX71HTqhumPVS212rp/j3Mtw2eNThIVqN+VMR/K13Y8ggLzseQCL8
         ubdcMQD2vRaNjMoL6+jOipimDduNgWAx/ln/lv35kmJHoF5LZCFDIcv/lw3D3f1uk4fr
         tHGLan3gNEdcV0j6EFrpwcaaOXM8CxCe0PCSBCmHgmB6xUlsbXhlMN2MBXHrmLCHoFt3
         xsxHquS63AJdNfq3BGOmnfbIGGsec5NTDu+/uBcAjuhqJARygxndkspMt8V6CVJbKz1S
         Y17w==
X-Gm-Message-State: AOAM530CLw/dL0sPvmPywKhZGM1pPyegn9fGpOjzbG4h3DfObp0dDh2f
        WjKT6tb6D8jDi/bM8m5zE+o=
X-Google-Smtp-Source: ABdhPJyRVJb3T7/GILgACoemPGx7tzN28cpjZuZ283HVngRGTjQRmxPE8AUYjRhe8LT1DQVv5NMl8A==
X-Received: by 2002:a92:b112:: with SMTP id t18mr32550371ilh.301.1638819550000;
        Mon, 06 Dec 2021 11:39:10 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id s21sm7045509ioj.11.2021.12.06.11.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 11:39:09 -0800 (PST)
Date:   Mon, 06 Dec 2021 11:39:00 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Message-ID: <61ae66d49f24f_c5bd208bf@john.notmuch>
In-Reply-To: <20211204140700.396138-3-jolsa@kernel.org>
References: <20211204140700.396138-1-jolsa@kernel.org>
 <20211204140700.396138-3-jolsa@kernel.org>
Subject: RE: [PATCH bpf-next 2/3] bpf: Add get_func_[arg|ret|arg_cnt] helpers
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa wrote:
> Adding following helpers for tracing programs:
> 
> Get n-th argument of the traced function:
>   long bpf_get_func_arg(void *ctx, u32 n, u64 *value)
> 
> Get return value of the traced function:
>   long bpf_get_func_ret(void *ctx, u64 *value)
> 
> Get arguments count of the traced funtion:
>   long bpf_get_func_arg_cnt(void *ctx)
> 
> The trampoline now stores number of arguments on ctx-8
> address, so it's easy to verify argument index and find
> return value argument's position.
> 
> Moving function ip address on the trampoline stack behind
> the number of functions arguments, so it's now stored on
> ctx-16 address if it's needed.
> 
> All helpers above are inlined by verifier.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index c26871263f1f..d5a3791071d6 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4983,6 +4983,31 @@ union bpf_attr {
>   *	Return
>   *		The number of loops performed, **-EINVAL** for invalid **flags**,
>   *		**-E2BIG** if **nr_loops** exceeds the maximum number of loops.
> + *
> + * long bpf_get_func_arg(void *ctx, u32 n, u64 *value)
> + *	Description
> + *		Get **n**-th argument (zero based) of the traced function (for tracing programs)
> + *		returned in **value**.
> + *
> + *	Return
> + *		0 on success.
> + *		**-EINVAL** if n >= arguments count of traced function.
> + *
> + * long bpf_get_func_ret(void *ctx, u64 *value)
> + *	Description
> + *		Get return value of the traced function (for tracing programs)
> + *		in **value**.
> + *
> + *	Return
> + *		0 on success.
> + *		**-EINVAL** for tracing programs other than BPF_TRACE_FEXIT or BPF_MODIFY_RETURN.


Can we just throw a verifier error if the program type doesn't support
this? Then weget a void and ther is no error case.

> + *
> + * long bpf_get_func_arg_cnt(void *ctx)
> + *	Description
> + *		Get number of arguments of the traced function (for tracing programs).
> + *
> + *	Return
> + *		The number of arguments of the traced function.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -5167,6 +5192,9 @@ union bpf_attr {
>  	FN(kallsyms_lookup_name),	\
>  	FN(find_vma),			\
>  	FN(loop),			\
> +	FN(get_func_arg),		\
> +	FN(get_func_ret),		\
> +	FN(get_func_arg_cnt),		\
>  	/* */
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 6522ffdea487..cf6853d3a8e9 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -12974,6 +12974,7 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
>  static int do_misc_fixups(struct bpf_verifier_env *env)
>  {
>  	struct bpf_prog *prog = env->prog;
> +	enum bpf_attach_type eatype = prog->expected_attach_type;
>  	bool expect_blinding = bpf_jit_blinding_enabled(prog);
>  	enum bpf_prog_type prog_type = resolve_prog_type(prog);
>  	struct bpf_insn *insn = prog->insnsi;
> @@ -13344,11 +13345,79 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
>  			continue;
>  		}
>  

[...]

> +		/* Implement get_func_arg_cnt inline. */
> +		if (prog_type == BPF_PROG_TYPE_TRACING &&
> +		    insn->imm == BPF_FUNC_get_func_arg_cnt) {
> +			/* Load nr_args from ctx - 8 */
> +			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> +
> +			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
> +			if (!new_prog)
> +				return -ENOMEM;

How does this handle the !x86 case? The code above only touches the x86
jit? Perhaps its obvious with some code digging, but its not to me from
the patch description and code here.

> +
> +			env->prog = prog = new_prog;
> +			insn      = new_prog->insnsi + i + delta;
> +			continue;
> +		}
> +
