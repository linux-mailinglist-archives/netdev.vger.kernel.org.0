Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3232046D9
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 03:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730738AbgFWBrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 21:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731434AbgFWBrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 21:47:42 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E739C061573;
        Mon, 22 Jun 2020 18:47:42 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id q22so6273926pgk.2;
        Mon, 22 Jun 2020 18:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r8vKZWM7pkSC5dnGJuCLDlbQLTE5rqdxtAgj9W0sk5M=;
        b=OS3fRFYFxlYOVyRNo69lxzyXm8lLC4THdKonNwXjNg7l7VMDGFU8IELDlSJ19iIXtd
         143jV9vgQMv6UUUwVq09piexrMPS+USw91k/XBrUIyYaGydkJMNaas7BjBgQJpbgU/Kb
         ORTIZWXRtEXR11b0UO7dhREgCgciy9qHzo0m2eQAjWIOu7B3iMS4oavyPIgeQ1FmcAt5
         E3nuvwRGkSNSTzh8Y1QRr0r6xl1ULXz+LXjhP7tE8mQywRBGIWGVW3va1lMVAFWBftAv
         MGFIeOX6kbB1MhCiTpk0uJeyMfSP2ihv+q5C5Tsd9JOIAssRJvuOfZH7hjkIyz/BLmHg
         vytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r8vKZWM7pkSC5dnGJuCLDlbQLTE5rqdxtAgj9W0sk5M=;
        b=MuDFxZ5YMOMhj4Nkc8plSUEt1DcRd2bDvbSE2ctHdpXmB4/x8yFgIsdXGnj3RA+XX6
         Tf/1/RpS5VPTzFS2PUOy/dM82HyTs6B2s0FaQKyEq2YWjJqjk4Ro275JTqnom1Jj8S+i
         AqFDzMtk1VbB7z+0D639dq1tCYp52WDJmPNNoIvxsRCMlhCCiRLcu3wBKDunHvnWnxLV
         +Sx29CqN6pctWcEwyky9jxkRYDwUe+P3wEjNp7Fqqr8AdIgn+3hzJFweYhk+QbLgmz0/
         DAekaf8O7GhQyvwp0IYANhcOKDaIHbuTUNB2dGwefWoENgkNT/2cQ0foNsZu5p/aTAiu
         cNKA==
X-Gm-Message-State: AOAM532WweupVTflrGzDjRCiCE5wiekCnTmSna10/RYFCnjzU7xSeYVM
        CWAuyUoOGR2Az7MBPduGpVP9a5yC
X-Google-Smtp-Source: ABdhPJyf8CjyCVTYVJKRbt5aVgBntqpT80ZgQ8ApCaedg3u3fxMAtc1mhMI5CfRjR8MrlNkcZBkk3w==
X-Received: by 2002:a63:205d:: with SMTP id r29mr15425860pgm.367.1592876861524;
        Mon, 22 Jun 2020 18:47:41 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id a7sm692871pjd.2.2020.06.22.18.47.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 18:47:40 -0700 (PDT)
Subject: Re: [PATCH bpf-next v3 09/15] bpf: add bpf_skc_to_udp6_sock() helper
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Martin KaFai Lau <kafai@fb.com>
References: <20200623003626.3072825-1-yhs@fb.com>
 <20200623003636.3074473-1-yhs@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d0a594f6-bd83-bb48-01ce-bb960fdf8eb3@gmail.com>
Date:   Mon, 22 Jun 2020 18:47:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200623003636.3074473-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/20 5:36 PM, Yonghong Song wrote:
> The helper is used in tracing programs to cast a socket
> pointer to a udp6_sock pointer.
> The return value could be NULL if the casting is illegal.
> 
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       |  9 ++++++++-
>  kernel/trace/bpf_trace.c       |  2 ++
>  net/core/filter.c              | 22 ++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py     |  2 ++
>  tools/include/uapi/linux/bpf.h |  9 ++++++++-
>  6 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index cc3f89827b89..3f5c6bb5e3a7 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1649,6 +1649,7 @@ extern const struct bpf_func_proto bpf_skc_to_tcp6_sock_proto;
>  extern const struct bpf_func_proto bpf_skc_to_tcp_sock_proto;
>  extern const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto;
>  extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
> +extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
>  
>  const struct bpf_func_proto *bpf_tracing_func_proto(
>  	enum bpf_func_id func_id, const struct bpf_prog *prog);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index e256417d94c2..3f4b12c5c563 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3276,6 +3276,12 @@ union bpf_attr {
>   *		Dynamically cast a *sk* pointer to a *tcp_request_sock* pointer.
>   *	Return
>   *		*sk* if casting is valid, or NULL otherwise.
> + *
> + * struct udp6_sock *bpf_skc_to_udp6_sock(void *sk)
> + * 	Description
> + *		Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
> + *	Return
> + *		*sk* if casting is valid, or NULL otherwise.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3417,7 +3423,8 @@ union bpf_attr {
>  	FN(skc_to_tcp6_sock),		\
>  	FN(skc_to_tcp_sock),		\
>  	FN(skc_to_tcp_timewait_sock),	\
> -	FN(skc_to_tcp_request_sock),
> +	FN(skc_to_tcp_request_sock),	\
> +	FN(skc_to_udp6_sock),
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index de5fbe66e1ca..d10ab16c4a2f 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1523,6 +1523,8 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  		return &bpf_skc_to_tcp_timewait_sock_proto;
>  	case BPF_FUNC_skc_to_tcp_request_sock:
>  		return &bpf_skc_to_tcp_request_sock_proto;
> +	case BPF_FUNC_skc_to_udp6_sock:
> +		return &bpf_skc_to_udp6_sock_proto;
>  #endif
>  	case BPF_FUNC_seq_printf:
>  		return prog->expected_attach_type == BPF_TRACE_ITER ?
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 140fc0fdf3e1..9a98f3616273 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -9325,3 +9325,25 @@ const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto = {
>  	.check_btf_id		= check_arg_btf_id,
>  	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_TCP_REQ],
>  };
> +
> +BPF_CALL_1(bpf_skc_to_udp6_sock, struct sock *, sk)
> +{
> +	/* udp6_sock type is not generated in dwarf and hence btf,
> +	 * trigger an explicit type generation here.
> +	 */
> +	BTF_TYPE_EMIT(struct udp6_sock);
> +	if (sk_fullsock(sk) && sk->sk_protocol == IPPROTO_UDP &&

Why is the sk_fullsock(sk) needed ?

> +	    sk->sk_family == AF_INET6)
> +		return (unsigned long)sk;
> +
> +	return (unsigned long)NULL;
> +}
> +
> +const struct bpf_func_proto bpf_skc_to_udp6_sock_proto = {
> +	.func			= bpf_skc_to_udp6_sock,
> +	.gpl_only		= false,
> +	.ret_type		= RET_PTR_TO_BTF_ID_OR_NULL,
> +	.arg1_type		= ARG_PTR_TO_BTF_ID,
> +	.check_btf_id		= check_arg_btf_id,
> +	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_UDP6],
> +};
> diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
> index d886657c6aaa..6bab40ff442e 100755
> --- a/scripts/bpf_helpers_doc.py
> +++ b/scripts/bpf_helpers_doc.py
> @@ -425,6 +425,7 @@ class PrinterHelpers(Printer):
>              'struct tcp_sock',
>              'struct tcp_timewait_sock',
>              'struct tcp_request_sock',
> +            'struct udp6_sock',
>  
>              'struct __sk_buff',
>              'struct sk_msg_md',
> @@ -466,6 +467,7 @@ class PrinterHelpers(Printer):
>              'struct tcp_sock',
>              'struct tcp_timewait_sock',
>              'struct tcp_request_sock',
> +            'struct udp6_sock',
>      }
>      mapped_types = {
>              'u8': '__u8',
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index e256417d94c2..3f4b12c5c563 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3276,6 +3276,12 @@ union bpf_attr {
>   *		Dynamically cast a *sk* pointer to a *tcp_request_sock* pointer.
>   *	Return
>   *		*sk* if casting is valid, or NULL otherwise.
> + *
> + * struct udp6_sock *bpf_skc_to_udp6_sock(void *sk)
> + * 	Description
> + *		Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
> + *	Return
> + *		*sk* if casting is valid, or NULL otherwise.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3417,7 +3423,8 @@ union bpf_attr {
>  	FN(skc_to_tcp6_sock),		\
>  	FN(skc_to_tcp_sock),		\
>  	FN(skc_to_tcp_timewait_sock),	\
> -	FN(skc_to_tcp_request_sock),
> +	FN(skc_to_tcp_request_sock),	\
> +	FN(skc_to_udp6_sock),
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> 
