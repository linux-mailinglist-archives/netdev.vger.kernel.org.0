Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52601378E7
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 23:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgAJWEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 17:04:47 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:54726 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbgAJWEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 17:04:46 -0500
Received: by mail-pj1-f68.google.com with SMTP id kx11so1505274pjb.4;
        Fri, 10 Jan 2020 14:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eb9Zu4ng3OFqsu040N9uJfSobuP+HTIZaWYh+4c4MGU=;
        b=Jw7ulMnHhi1YOBpqwEdBLml7YAwubcJCZcoToV/R0C8wYwVEcWMyuZ4bjkjUf8+ZfH
         VO5KMRPDx9PvPvp6ZuJRARBI5veWbkLa4lbAX/HWM3fEGHBD5FWPPkm0IxFqM1K4mjU5
         Jj7ZeyE726wmedlcfCkur+OTHpk/D1e+T1FJr0X4PZFSdiPY0Pu5b/0GwScM6QK65jnk
         +taKEZwtxcDeOMcsdImrRlziMp/OFCvqyZ0qqT7ScjyQavM3LIjwF7OT7mZ8UpyRzeNK
         XOpNzJEp1TAhHIcp6JrdPB9HHQfel/gKuVnYnsrzkqtEBhQNiG8268N9m0P5D+gEpf6Q
         SECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eb9Zu4ng3OFqsu040N9uJfSobuP+HTIZaWYh+4c4MGU=;
        b=K6RQqfG5B4Q+aEwb+14OVEh3pchkAwws6TqW7WNwEnsAIyK4U2qIMU+JK3yCQzv8Us
         /IDejAuqToH+Zl2V7H4CAu3S7aJ6JWeagnXIYygoDAIa6i+l4xhKnO2qDPTqd097DzDU
         XpmH57x8Ol+3E20y1Ny+U3ik2wqpSLIVSOjK9JPlQuGUdsM6mXblbWFIzd+CLpsDRuFL
         G4Q+VOiiWxSmAIsMj4bKU0kuAya6pWSykIsLAjOOcXytubYq3KbS1sPs6yE399iQmCch
         Cx7ITAzLFH0Fyg3NB3pqByku0FZWMknA837Sc7Z8hPU79dujfQTE0JdBQp9fQu8CMJhd
         s4uA==
X-Gm-Message-State: APjAAAWbUc0E31M2u15B/yVW7WkMg119SAViWIFPsMKPndYXFNdJUINU
        /hxBEedNm684KN3eZzuqRJk=
X-Google-Smtp-Source: APXvYqwzcNzzjZTeNYqD22n3zkIm0G4tZqFkBwHfbfRvfsFZUW+TC3MUL8MNnVHfRP2HISTMBmDh9A==
X-Received: by 2002:a17:90a:8584:: with SMTP id m4mr7552496pjn.123.1578693885765;
        Fri, 10 Jan 2020 14:04:45 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:ba5e])
        by smtp.gmail.com with ESMTPSA id k1sm3941926pgk.90.2020.01.10.14.04.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Jan 2020 14:04:44 -0800 (PST)
Date:   Fri, 10 Jan 2020 14:04:43 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kafai@fb.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH v5 bpf-next] selftests/bpf: add BPF_PROG, BPF_KPROBE, and
 BPF_KRETPROBE macros
Message-ID: <20200110220441.rwbxg4c452eupvjt@ast-mbp.dhcp.thefacebook.com>
References: <20200110211634.1614739-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110211634.1614739-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 01:16:34PM -0800, Andrii Nakryiko wrote:
> Streamline BPF_TRACE_x macro by moving out return type and section attribute
> definition out of macro itself. That makes those function look in source code
> similar to other BPF programs. Additionally, simplify its usage by determining
> number of arguments automatically (so just single BPF_TRACE vs a family of
> BPF_TRACE_1, BPF_TRACE_2, etc). Also, allow more natural function argument
> syntax without commas inbetween argument type and name.
> 
> Given this helper is useful not only for tracing tp_btf/fenty/fexit programs,
> but could be used for LSM programs and others following the same pattern,
> rename BPF_TRACE macro into more generic BPF_PROG. Existing BPF_TRACE_x
> usages in selftests are converted to new BPF_PROG macro.
> 
> Following the same pattern, define BPF_KPROBE and BPF_KRETPROBE macros for
> nicer usage of kprobe/kretprobe arguments, respectively. BPF_KRETPROBE, adopts
> same convention used by fexit programs, that last defined argument is probed
> function's return result.
...
>  SEC("kretprobe/__set_task_comm")
> -int prog2(struct pt_regs *ctx)
> +int BPF_KRETPROBE(prog2,
> +		  struct task_struct *tsk, const char *buf, bool exec,
> +		  int ret)
>  {
> -	return 0;
> +	return PT_REGS_PARM1(ctx) == 0 && ret != 0;
>  }
>  
>  SEC("raw_tp/task_rename")
>  int prog3(struct bpf_raw_tracepoint_args *ctx)
>  {
> -	return 0;
> +	return ctx->args[0] == 0;;

I've corrected this typo
and converted != 0 and == 0 to more traditional checks for null.
And applied.
