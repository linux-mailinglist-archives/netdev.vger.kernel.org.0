Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8D2204951
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 07:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbgFWFvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 01:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728866AbgFWFvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 01:51:04 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568D8C061573;
        Mon, 22 Jun 2020 22:51:04 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id x62so11185380qtd.3;
        Mon, 22 Jun 2020 22:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W7H9rFr0HDbGGTki2DoZ9cdBNBATy4Q0Mwa9jAl6H4c=;
        b=fH+xm7FPIT3buuXkBUtE/0fpG8TC/aXZl9mwdDD+anFJMvm1OI3meZsQ0phxcz5N+8
         exmclaeunt4CRoRR580kqQIJtBSlrvEHVLZlG/CX/WmGZN5cLk/mBn/AtEcSdrQ9wjfP
         5UnX1I/Y3YwO+l2xZkFL3NEPusecS7kNi7HZlZ51sYPzEijpCGYYG13DKqRCl9KqyLV+
         y+HVTJEL/di3BRIxRw1T3OeGxoZHpVMu6gvZMY+Yy5ZEyDMd87oEf1vJYI2Dng9YQpZc
         tR7lLil3UV9hFzifyxFFgKxZdK0BEYzzPnBR7nWXFykOQkhKWafRxFiENdFu42adtyCR
         8LIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W7H9rFr0HDbGGTki2DoZ9cdBNBATy4Q0Mwa9jAl6H4c=;
        b=WNVyXd+tqEy3+7bfv33dh9u0o+JfDGTiaAjEClM8sF/o4jDG5z6iGYnjTD2CmnDoNS
         gFwiwrlfcjDgpqhM7439hw3PYqvmuQdB9lvT3M0Q9W81rfdazDvxaLb5idr4yHUdA3YS
         l4e00YrrWq1BVAw/kcftapyq/WAKLmbODf+cmPoUZmjbc22sC+WQavyWIliTAR/dpnf1
         B/3S/Ouxstka1NvRRWoEB0sJNM5ihPuoXRZS2nS1nc5EF1bD/dR8gpelFRPUuzXcgHLz
         r2Fuc4f4R9uNYtH1Xk/i3J/tlxK9BcFBWdQknLUvXFEodeDOpZxFsWL1WgHPakhvFeWC
         evng==
X-Gm-Message-State: AOAM53302Zuk8BhbEO1tyGSx3Y1ez5MbjtZxPkPeEA5Zk7JjM9Mn5lvc
        dLjNQhvpiENhDmQPFPIPh1aKDsKLljMwBAi7hng=
X-Google-Smtp-Source: ABdhPJz60Np4FlkYko6/J/n7fMDxCBUzWk0F+c9HsZ/+6u5PS4gcLAw4V+1TfM6C9xynnh/0EqGN7kfA+LwG59yCH+M=
X-Received: by 2002:ac8:42ce:: with SMTP id g14mr19962014qtm.117.1592891463454;
 Mon, 22 Jun 2020 22:51:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592606391.git.lorenzo@kernel.org> <02a278b08d7c33a8cf0faf2a16931cd11addbc47.1592606391.git.lorenzo@kernel.org>
In-Reply-To: <02a278b08d7c33a8cf0faf2a16931cd11addbc47.1592606391.git.lorenzo@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 22:50:52 -0700
Message-ID: <CAEf4BzYNMtR56RRWDZEMK-nZj3AWoQJm-8-SL+vfhRT1nZjJhA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 6/8] libbpf: add SEC name for xdp programs
 attached to CPUMAP
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        lorenzo.bianconi@redhat.com, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 9:55 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> As for DEVMAP, support SEC("xdp_cpumap*") as a short cut for loading
> the program with type BPF_PROG_TYPE_XDP and expected attach type
> BPF_XDP_CPUMAP.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 477c679ed945..0cd13cad8375 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6655,6 +6655,8 @@ static const struct bpf_sec_def section_defs[] = {
>                 .attach_fn = attach_iter),
>         BPF_EAPROG_SEC("xdp_devmap",            BPF_PROG_TYPE_XDP,
>                                                 BPF_XDP_DEVMAP),
> +       BPF_EAPROG_SEC("xdp_cpumap",            BPF_PROG_TYPE_XDP,
> +                                               BPF_XDP_CPUMAP),

I noticed that XDP and a bunch of other progs don't enforce "/" at the
end of the prog type prefix. Is there any reason for that? Tracing
prog types are pretty consistent about that (except for perf_event, I
think). I'd love it if we were trying to converge here. Do you mind
switching this to "xdp_cpumap/"? Would be nice to do the same for
xdp_devmap, if it's not too late yet.


>         BPF_PROG_SEC("xdp",                     BPF_PROG_TYPE_XDP),
>         BPF_PROG_SEC("perf_event",              BPF_PROG_TYPE_PERF_EVENT),
>         BPF_PROG_SEC("lwt_in",                  BPF_PROG_TYPE_LWT_IN),
> --
> 2.26.2
>
