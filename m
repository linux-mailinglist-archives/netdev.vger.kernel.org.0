Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB4813606D
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 19:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732198AbgAISs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 13:48:26 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33830 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732160AbgAISsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 13:48:25 -0500
Received: by mail-pf1-f195.google.com with SMTP id i6so3787776pfc.1;
        Thu, 09 Jan 2020 10:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fI9WHgKaFp4DfI/TYFPMR/7QFlU9Q2XOkMBqxZUqqL0=;
        b=WrOcwzIrWyMIesK9AQZAtapOgrNXy2+3/atJAYnueTaed2FJP6NkQLweM+SCNVtpe3
         lnTjwzh4CwuNJyFWIdTEH9FuU195I0SjkuSIXeLqO6xi/LInch4brpI/wG01SN8cHA1R
         6yB/8aUQtxKske5MWCzbAHoL/M8Go9MB2aFjPJQW9a/4H80aMSJ+AWgqBesTsBQG3Ou/
         XsjDqszKO8drUvMSHXGSzPd+BxSdmjEddjyOIKkR5tVkCaLCEz3pliW2xjzOg5PvN2J+
         NjE1xRvgpudlkSFyms+XiKiSUy75uTwteOj/VikvF/j8wZf4BPsP8jVLHzEjA8nj27Cs
         qOzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fI9WHgKaFp4DfI/TYFPMR/7QFlU9Q2XOkMBqxZUqqL0=;
        b=InpI8lI5eW28J8icmHnxBZtcHQ+XJtGgFQr73lDKUNkRHt3h0dUEmn4l6NCTCVlZGN
         s/kICMxAMCw2TZrXyA1C0+5UsYnlsFnKV3LXwYhFqKt/mAeX6n4Myr4gk//2ufKK4STN
         VzQGPPbMihETMC1XO83RJXrfHel8TRMhv1dq/s/cXvSmyOAK/P3P+VadqhjVNavr7bdT
         7pd9lSN9P/fWEG8cfzHjcxeoYINapoqXOlRDeFVQYO6ep30HpTHIonuqSiBlRzsqBBI0
         XGkTQOEmteJN6cydfCos+nngiXxZSeMP9yBr0MXRMT7SeXNIilCP9JuZGeajxfAJS40d
         7+XQ==
X-Gm-Message-State: APjAAAVpsexLPp5I5sbX3JGptZlfo5C+u/yddpMYnamdib9Yyfsnl18Q
        sq1Uffy/9oQBNP8ZYF4/Fvc=
X-Google-Smtp-Source: APXvYqzD6PorXUKSy9cEuJdIbN1Rctlh83qXO8KyUBVbrVfEAS+q3ARGyT2uWi9i9VrHI3En/6wWFg==
X-Received: by 2002:a62:6d01:: with SMTP id i1mr12543714pfc.94.1578595704837;
        Thu, 09 Jan 2020 10:48:24 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::3:d3c9])
        by smtp.gmail.com with ESMTPSA id k44sm4125916pjb.20.2020.01.09.10.48.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jan 2020 10:48:24 -0800 (PST)
Date:   Thu, 9 Jan 2020 10:48:22 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, yhs@fb.com, kafai@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] selftests/bpf: add BPF_HANDLER, BPF_KPROBE, and
 BPF_KRETPROBE macros
Message-ID: <20200109184820.mvgtxql7435bhzx3@ast-mbp>
References: <20191226211855.3190765-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226211855.3190765-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 01:18:55PM -0800, Andrii Nakryiko wrote:
> Streamline BPF_TRACE_x macro by moving out return type and section attribute
> definition out of macro itself. That makes those function look in source code
> similar to other BPF programs. Additionally, simplify its usage by determining
> number of arguments automatically (so just single BPF_TRACE vs a family of
> BPF_TRACE_1, BPF_TRACE_2, etc). Also, allow more natural function argument
> syntax without commas inbetween argument type and name.
> 
> Given this helper is useful not only for tracing tp_btf/fenty/fexit programs,
> but could be used for LSM programs and others following the same pattern,
> rename BPF_TRACE macro into more generic BPF_HANDLER. Existing BPF_TRACE_x
> usages in selftests are converted to new BPF_HANDLER macro.
> 
> Following the same pattern, define BPF_KPROBE and BPF_KRETPROBE macros for
> nicer usage of kprobe/kretprobe arguments, respectively. BPF_KRETPROBE, adopts
> same convention used by fexit programs, that last defined argument is probed
> function's return result.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
...
> +
> +#define BPF_HANDLER(name, args...)					    \
> +name(unsigned long long *ctx);						    \
> +static __always_inline typeof(name(0)) ____##name(args);		    \
> +typeof(name(0)) name(unsigned long long *ctx)				    \
> +{									    \
> +	_Pragma("GCC diagnostic push")					    \
> +	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
> +	return ____##name(___bpf_ctx_cast(args));			    \
> +	_Pragma("GCC diagnostic pop")					    \

It says "GCC ..", but does it actually work with gcc?
If the answer is no, I think it's still ok, but would be good to document.

Other than the above BPF_HANDLER, BPF_KPROBE, BPF_KRETPROBE distinction make sense.
Please document it. It's not obvious when to use each one.

Also the intent is do let users do s/BPF_KRETPROBE/BPF_HANDLER/ conversion
when they transition from kretprobe to fexit without changing anything else
in the function body and function declaration? That's neat if that can work.
