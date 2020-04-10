Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D79741A3EC6
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 05:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgDJDd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 23:33:58 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38966 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgDJDd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 23:33:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id g32so459578pgb.6;
        Thu, 09 Apr 2020 20:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iox6yPgn6Z5RJBlEGgWCN2rRqyoYcY80D5yr3p+YMXA=;
        b=blehUBNmyb4WRGIVdwTmQ8AKsilGAV+TjniVOWCm7aTAiPKa7U1P0Khrj/cnAQU/WL
         /TYrtMQzTlUd7IdxdCoLsnKk5ybHSQRcP73Z49AvT/urRTUJ7msbAOV0QCLpn9uSrbW9
         D7UjFkQciTqxMpQJUWIvGILYZ/rCoBJNdVuKL6F7rTitcWTo3tiDUnD5AHXkF6nXqcqr
         aNI96mNADhhd5B+XS0jVuAo4OKIIbHQrGAxbSiozSFLH5Wb4DafjY1eAWv3zBz93V9Cf
         2piQzX3w0mI/fpDiK6qJTmlhzgFElhS8n55UwF3RelJr1PpSCxETzbW3wm2bsx8wDgmN
         JuWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iox6yPgn6Z5RJBlEGgWCN2rRqyoYcY80D5yr3p+YMXA=;
        b=H6ElPtHI8/eKYaHBk8opgfQ36+cgALcdI1NO2BnjnlXxaN5OJlJidb2YT4foI7SS34
         LQOykS1s1Aczm1OvBlSfMd/t5dMEGmKTJqTIs7d+qm80gudnT9jTuj7IvaJzaXS1Iw5+
         HehT0/B6/JHoSz1xjbg81ZHSnZiVq9Sr4CHzeMP1T4dzodVDjeRQSw72GwUUJkyRkpBc
         1SNNmQ75mjG8kfspWcb7+NptM1XMRV9xK3Is+euKabKJvNlt+nXs7fRLSVIJaRGHjeZA
         9iySg9bdHBvsD7vjeK5RoJn015vuKvL5OhK7N7pV6QB6MrToaw/dDhbGlJvuXkP9qs/Q
         Ts8w==
X-Gm-Message-State: AGi0PubUZqwDP6IoEsVSqGGiiiBg0lOiTosPowyS08TnraAkPKLrvV5y
        climABOP8HXfryTKWBjrJ0jDPpMr
X-Google-Smtp-Source: APiQypKSa20L1yR1V2I5YH9pEWI95EwckwgN+RBn+WnqeGWKbvad5P1XgQb1F5PwZKUI+oD0B7H4Lw==
X-Received: by 2002:a05:6a00:5:: with SMTP id h5mr3010270pfk.57.1586489635297;
        Thu, 09 Apr 2020 20:33:55 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f219])
        by smtp.gmail.com with ESMTPSA id f9sm525371pjt.45.2020.04.09.20.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 20:33:54 -0700 (PDT)
Date:   Thu, 9 Apr 2020 20:33:51 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [RFC PATCH bpf-next 15/16] tools/bpf: selftests: add dumper
 progs for bpf_map/task/task_file
Message-ID: <20200410033351.kuzndr2oovjz5xln@ast-mbp.dhcp.thefacebook.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232538.2676626-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408232538.2676626-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 04:25:38PM -0700, Yonghong Song wrote:
> For task/file, the dumper prints out:
>   $ cat /sys/kernel/bpfdump/task/file/my1
>     tgid      gid       fd      file
>        1        1        0 ffffffff95c97600
>        1        1        1 ffffffff95c97600
>        1        1        2 ffffffff95c97600
>     ....
>     1895     1895      255 ffffffff95c8fe00
>     1932     1932        0 ffffffff95c8fe00
>     1932     1932        1 ffffffff95c8fe00
>     1932     1932        2 ffffffff95c8fe00
>     1932     1932        3 ffffffff95c185c0
...
> +SEC("dump//sys/kernel/bpfdump/task/file")
> +int BPF_PROG(dump_tasks, struct task_struct *task, __u32 fd, struct file *file,
> +	     struct seq_file *seq, u64 seq_num)
> +{
> +	static char const banner[] = "    tgid      gid       fd      file\n";
> +	static char const fmt1[] = "%8d %8d";
> +	static char const fmt2[] = " %8d %lx\n";
> +
> +	if (seq_num == 0)
> +		bpf_seq_printf(seq, banner, sizeof(banner));
> +
> +	bpf_seq_printf(seq, fmt1, sizeof(fmt1), task->tgid, task->pid);
> +	bpf_seq_printf(seq, fmt2, sizeof(fmt2), fd, (long)file->f_op);
> +	return 0;
> +}

I wonder what is the speed of walking all files in all tasks with an empty
program? If it's fast I can imagine a million use cases for such searching bpf
prog. Like finding which task owns particular socket. This could be a massive
feature.

With one redundant spin_lock removed it seems it will be one spin_lock per prog
invocation? May be eventually it can be amortized within seq_file iterating
logic. Would be really awesome if the cost is just refcnt ++/-- per call and
rcu_read_lock.
