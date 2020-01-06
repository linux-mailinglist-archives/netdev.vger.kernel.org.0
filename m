Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C703131C4E
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 00:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgAFX10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 18:27:26 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:53294 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgAFX1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 18:27:25 -0500
Received: by mail-pj1-f68.google.com with SMTP id n96so8173818pjc.3;
        Mon, 06 Jan 2020 15:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jPn73DMtcSflnfxRH7mWnc629ZU8jN1Lxj0uZf2hOW0=;
        b=gBvU4+agLc1idy19vdOvtBbeFKjO+2hSsumc0LK9UAWUbq7dkUSufpzJGJYVdzE1QQ
         OTnKOjHXusalohw0qFO92P5S6OULk50DMcNXoCGDgvT1a2kQRaiECkpLwmeitBLb+uP0
         vwoCduIf7uNHOfkwwgf84KNXXVAbDZbSMyBxf96sQC8fhadlY0eOvvmtgFtPuYo7qx+Q
         NWBbVXxkjuzAWdhuET7xeo3gt5dWs9DGx/dQEPtfqT+rQ7nckzwJ1ZusipvQNue4NC95
         CBZHJ13A0NRvSwNDBUTeO8/hqnqzGpCsSN4MjHvONx0j8wR/YwBbUAMlJkPMResUQp4p
         owTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jPn73DMtcSflnfxRH7mWnc629ZU8jN1Lxj0uZf2hOW0=;
        b=sViqPgia3Wynv1zAPyztjwHzykMCcszq2AhMsQHfS1pM/ONngi5+bmxozayz4Nnws1
         U/L3LYB7kK5vT9OHzNKdvKGqdBW4NLTU29bqpS0O1Cxe+ok5tYDQ6gCeaa4QFaN7H4r8
         ERfjsHD+WCj6xxIRKawH2Ku7NtogofD2fZQwSiy/a+XS1ugfZMtE1IyOHour3hNP6IaS
         xcixOcMtC428tBqxml4vZHHg7Cs56EySyUicTxDdz+JAxfUZpjyZ/rZZFqZSdA+QQzAz
         T+pHP92P7WRTG+wEMXywPjxg2R6+lryg2ALDdKKQIp9bTgMZmHmrseXQyAVilE6m4PCE
         6lOg==
X-Gm-Message-State: APjAAAU4Q3yApwiJPM4WVTvXZbEt08JsQr6HZ+VEZMHuklAlHuWfgfMk
        KPc0idFtn0H3iqAx6SGBvUo=
X-Google-Smtp-Source: APXvYqyNDfvHrzZmSH+QSReWHcBP97ZKs44mvqrr6GoukkUQJo/HkqO2I7JmQSw9nQPE/HunDnazsw==
X-Received: by 2002:a17:902:bf49:: with SMTP id u9mr54991136pls.199.1578353244147;
        Mon, 06 Jan 2020 15:27:24 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::1:2bf6])
        by smtp.gmail.com with ESMTPSA id o31sm74415725pgb.56.2020.01.06.15.27.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 15:27:23 -0800 (PST)
Date:   Mon, 6 Jan 2020 15:27:21 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
Subject: Re: [PATCH 2/5] bpf: Add bpf_perf_event_output_kfunc
Message-ID: <20200106232719.nk4k27ijm4uuwwo3@ast-mbp>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-3-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191229143740.29143-3-jolsa@kernel.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 29, 2019 at 03:37:37PM +0100, Jiri Olsa wrote:
> Adding support to use perf_event_output in
> BPF_TRACE_FENTRY/BPF_TRACE_FEXIT programs.
> 
> There are no pt_regs available in the trampoline,
> so getting one via bpf_kfunc_regs array.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/trace/bpf_trace.c | 67 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 67 insertions(+)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index e5ef4ae9edb5..1b270bbd9016 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1151,6 +1151,69 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  	}
>  }
>  
> +struct bpf_kfunc_regs {
> +	struct pt_regs regs[3];
> +};
> +
> +static DEFINE_PER_CPU(struct bpf_kfunc_regs, bpf_kfunc_regs);
> +static DEFINE_PER_CPU(int, bpf_kfunc_nest_level);

Thanks a bunch for working on it.

I don't understand why new regs array and nest level is needed.
Can raw_tp_prog_func_proto() be reused as-is?
Instead of patches 2,3,4 ?
