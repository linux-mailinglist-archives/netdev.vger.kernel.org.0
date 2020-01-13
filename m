Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5BB9139ACB
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 21:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgAMUfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 15:35:34 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40797 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgAMUfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 15:35:34 -0500
Received: by mail-qt1-f196.google.com with SMTP id v25so10345849qto.7;
        Mon, 13 Jan 2020 12:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m8IBv0huJex4tUhutDtMNrqLZ1kmcqmp2Eo7K+Jkeck=;
        b=G6d+br+CvhS6gqnd6GWL53vkzQQJGgH3Oj8tT2CL4CU8W+L3q4yFlMgqDOuJ6C84Wy
         rEOlKggOQaW4C7xKG2Z3scWUFbw/eCPUJZLgPyS82FXzjAySp0I3tFVBdGHV7ittSIYK
         90jyFQCqff2+C2V9eR6/hw2qWhUqbTC8u6D0QnT6mI32ReG1XFeECZoM2brv+F7TcsnN
         MkDZqjM/z92FW8x9voXLQeG1rHcNP4bYyXDpTHNJ4qx9TWI0/oJVDngIgOQpIv95bsQd
         sNZb4Ozdt9cur+0hL3cxMXsFczo0Wfdc9PrN10Z7n0Hc6BoxidNTgU7k1v9ayzOIKAbe
         cb8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m8IBv0huJex4tUhutDtMNrqLZ1kmcqmp2Eo7K+Jkeck=;
        b=SKNQAW8kKi7PyXdA4v+wOfCcqrQXQAZAysXU7peJAm7ZKcqQ6dkvrpZcOhlXS3HkOb
         CWVuevwyzUI/qO7jqSQWW5j66QRxppTb5+pG7zzH9V2feQelsDsoJS16BWOlY2iv2lwc
         HKYGPG38Wu7zZGh1CydiZpD9T5TfBhjT6Hg4rro5k6+NPOJ1L+hXuFf1RfyrBF/NAWg9
         wyuYvw47MRJYTeOCTok52SlvuuWteIRejIeWJYtkAG1mG5eFh751hYYYYGeeyMbrUM8S
         zTZppeDUvizH4fB2WrXyg+JJAzMfa0QBghOG5bTGogW0Cd6y1hIiSZthn2w/LQ9ZsoCL
         AX5Q==
X-Gm-Message-State: APjAAAWaDbkDASG0qCtZOaMxAnw/qsSXZWGo7GJghsrY7Bg/5T0H2QWY
        I1Ibz8JE6UoBe4Wq1/Xp6fU2TLZNgTmKR9zDsQk=
X-Google-Smtp-Source: APXvYqzbNCLK+f6xUA8s4ANqDLU451JPWVO79ZC9GiWzMAscrIXW2zIMTnP3+pBEDXKbxgnECtWHS+OMxKbWb715O5g=
X-Received: by 2002:ac8:140c:: with SMTP id k12mr399204qtj.117.1578947733638;
 Mon, 13 Jan 2020 12:35:33 -0800 (PST)
MIME-Version: 1.0
References: <20191229225103.311569-1-eric@sage.org> <20200112040240.267864-1-eric@sage.org>
In-Reply-To: <20200112040240.267864-1-eric@sage.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Jan 2020 12:35:22 -0800
Message-ID: <CAEf4BzbjXRFYkr2LCh50mLV+cQ9WrgRB+U4CbxekVVf=nfRUZw@mail.gmail.com>
Subject: Re: [PATCH v2] samples/bpf: Add xdp_stat sample program
To:     Eric Sage <eric@sage.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 11, 2020 at 8:05 PM Eric Sage <eric@sage.org> wrote:
>
> At Facebook we use tail calls to jump between our firewall filters and
> our L4LB. This is a program I wrote to estimate per program performance
> by swapping out the entries in the program array with interceptors that
> take measurements and then jump to the original entries.
>
> I found the sample programs to be invaluable in understanding how to use
> the libbpf API (as well as the test env from the xdp-tutorial repo for
> testing), and want to return the favor. I am currently working on
> my next iteration that uses fentry/fexit to be less invasive,
> but I thought it was an interesting PoC of what you can do with program
> arrays.
>
> Signed-off-by: Eric Sage <eric@sage.org>
> ---
> Changes in v2:
> - Upped max number of interceptors to 32 and mentioned the max in the
>   help.
> - Fixed license formatting.
> - Requested change to convert BPF map definitions to BTF.
>

I should have mentioned a gotcha with PROG_ARRAY earlier, sorry about
that. Use key_size/value_size for it. Other than that, looks good.

[...]

> diff --git a/samples/bpf/xdp_stat_kern.c b/samples/bpf/xdp_stat_kern.c
> new file mode 100644
> index 000000000000..83cff4807f72
> --- /dev/null
> +++ b/samples/bpf/xdp_stat_kern.c
> @@ -0,0 +1,192 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2019 Facebook
> + */
> +
> +/* Conceptually interception looks like this for a single packet:
> + *
> + * interceptor_0 -> entrypoint -> interceptor_1 -> prog_1 -> ... ->
> + * interceptor_N -> prog_N -> XDP_ACTION
> + *
> + * At any point in the chain, including in the entrypoint, an XDP_ACTION can
> + * be returned. It is also not assumed that the order of jumps will not change
> + * (except that the entrypoint always comes first).
> + *
> + * Because there is no way to hook into the return of the XDP action, the
> + * entrpoint (interceptor_0) is also used to record the terminal run of the

typo: entrypoint

> + * previous BPF program on the same CPU. Conceputally:

typo: Conceptually

> + *
> + * ... -> prog_N -> XDP_ACTION -> interceptor_0 -> ...
> + *
> + * FIXME: A bad side effect of this is that the reported stats will always be
> + * behind in tracking terminal runs which is confusing to the user.
> + */
> +

[...]

> +/* jmp_table_entry has a single entry - the original XDP entrpoint - so that
> + * the intercpetor entrypoint can jump to it.
> + */
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PROG_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, __u32);

Did this actually work, when you run your tool? Few special maps still
don't support specifying type information, I think PROG_ARRAY is one
of those. For such cases you have to specify key_size and value_size,
instead of key/value types:

__uint(key_size, sizeof(__u32));
__uint(value_size, sizeof(__u32));


> +} jmp_table_entrypoint SEC(".maps");
> +

[...]
