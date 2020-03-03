Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28CD3176E3C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 05:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgCCE7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 23:59:37 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36761 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgCCE7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 23:59:37 -0500
Received: by mail-qt1-f195.google.com with SMTP id t13so1922951qto.3;
        Mon, 02 Mar 2020 20:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ejAnt+uAyqn1WHZqMXh9jskwSigm+jlynlcBsOlBXc=;
        b=YloKxOZqHVIxy6syxSZwM+lbqjeDFy6KxpkO/6K3bbZn0uIAyJfqlb6ZSDB/9h2MK3
         AO1ZwJuB4L62GJKcL/dRd2prxX5rhm/YxWlPLjwp7R/31Xx8R8AxdZTJxgD/bIVt10ZW
         9TeZWwpOYw6eepWIdN8DU9MRGXbUvVx/lAWllcmd0JbpBQbY0iwqBIH8iusvG8p45WkM
         QQRXc9o7rwHFZN99Z7B19IS28qIe0RPILCTXhnySGgK9GjTsvdbd1W+fotEdsoeDkPPw
         NFFJf7QSzu1TKb6atRM8ee4Hk5ZhAbucgGYojnz2SVK2tJYQEYogxnXLrj5KQv3JJjLx
         pGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ejAnt+uAyqn1WHZqMXh9jskwSigm+jlynlcBsOlBXc=;
        b=hABQVHfpCSJ6SuKi9bea/eHvjfwLwkNYnWjtguTJm/yX9grbfTZc04wr0XOx/Aoud5
         cFHtrDMsxIOdrIpbM+3BjRpwjsLuJNryIF40mCyotqhxspzv55WWUadiL6efubF0H2kY
         SjR38+cSoyXFGl61t3gE/bbSZvpId15XYApATEDaTSAOublmNXdfDVDNDPybz7j+6whT
         Vv6CVFZHqyDJvTJMN18ydYl0+0Mj9DVwhB/WBNiuEHX5eAtVThAeVjCWT0PTq9Ak7g8z
         J45lqPX7aqhBziNOsieLdSdL7lF3o+szQ8ZxJxtzGmR2ez2qlD1DbiWOlwOQpRErCCS9
         ye4Q==
X-Gm-Message-State: ANhLgQ0zuMsjFmkRveA1DJO3yjjk66auJ9aGm+algwnUdWAPbJL3l+ek
        IIoq2tGpS7bEfrNkO7sP4O2cViF8zmztT7ue2IQ=
X-Google-Smtp-Source: ADFU+vtqmDbp5mzDx5UV/rhQYMaaTOfgvfK+dBtgdJSBs0z+K22Ip5cO/Nr/k0tbIYrU8l5YAbN7VUNq7mVp5IqFfHA=
X-Received: by 2002:ac8:4d4b:: with SMTP id x11mr2787467qtv.171.1583211575848;
 Mon, 02 Mar 2020 20:59:35 -0800 (PST)
MIME-Version: 1.0
References: <20200301081045.3491005-1-andriin@fb.com> <20200303005951.72szj5sb5rveh4xp@ast-mbp>
 <CAEf4BzYsC-5j_+je1pZ_JNsyuPV9_JrLSzpp6tfUvm=3KBNL-A@mail.gmail.com>
In-Reply-To: <CAEf4BzYsC-5j_+je1pZ_JNsyuPV9_JrLSzpp6tfUvm=3KBNL-A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Mar 2020 20:59:24 -0800
Message-ID: <CAEf4Bza+oHc4eJESnPCQh0rRcKtPWqu3SYkzP52B4BLu2O0=6w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Improve raw tracepoint BTF types preservation
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 2, 2020 at 8:10 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Mar 2, 2020 at 4:59 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Sun, Mar 01, 2020 at 12:10:42AM -0800, Andrii Nakryiko wrote:
> > > Fix issue with not preserving btf_trace_##call structs when compiled under
> > > Clang. Additionally, capture raw tracepoint arguments in raw_tp_##call
> > > structs, directly usable from BPF programs. Convert runqslower to use those
> > > for proof of concept and to simplify code further.
> >
> > Not only folks compile kernel with clang they use the latest BPF/BTF features
> > with it. This is very nice to see!
> > I've applied 1st patch to make clang compiled kernel emit proper BTF.
> >
> > As far as patch 2 I'm not sure about 'raw_tp_' prefix. tp_btf type of progs can
> > use the same structs. So I think there could be a better name. Also bpftool can
> > generate them as well while emitting vmlinux.h. I think that will avoid adding
> > few kilobytes to vmlinux BTF that kernel isn't going to use atm.
>
> Fair enough, I'll follow up with bpftool changes to generate such
> structs. I'm thinking to use tp_args_xxx name pattern, unless someone
> has a better idea :)

Bad news. BTF_KIND_FUNC_PROTOs don't capture argument names and having
something like:

struct tp_args_sched_switch {
    bool arg1;
    struct task_struct *arg2;
    struct task_struct *arg3;
};

doesn't seem like a good solution...
