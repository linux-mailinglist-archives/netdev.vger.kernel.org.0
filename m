Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A05B170C57
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 00:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgBZXKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 18:10:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgBZXKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 18:10:22 -0500
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D93424672;
        Wed, 26 Feb 2020 23:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582758621;
        bh=KspIpxU2HtokbKj86svjFj5TLHdIJJWX3Q9t2yMeTgk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=E8nBEp45AboIvLGHvZR8GoCLYlbvJMHZXZalUpg13oBjV4eWPmU5icN9xgfWOFFUD
         k4yuLScfYAXAqfoUlEJeY74wbfucrSGNFFMc6X9H+V1PcjMKblRz4WthZ6aSkMcr9f
         m9pqKhZeq0qp+n336uK3cS5Yz3WlkcdkfICin3yg=
Received: by mail-lj1-f175.google.com with SMTP id 143so943765ljj.7;
        Wed, 26 Feb 2020 15:10:21 -0800 (PST)
X-Gm-Message-State: ANhLgQ2GdPjmPC5Q+66j7CM4DLQW7rxAJnoBugg6xePp/+wvCeaqKzVQ
        oGcbIibCbjQoKcrOeUR6lWsqucxEGWsIVQG/uRM=
X-Google-Smtp-Source: ADFU+vv0ZmmFo2/2vJ2clO/40f67XJutw73Y69Xvj72xloPaCNGT+S+AbQYRdi+cssYzSiL/qbgJtlFNBQE/W0kQAvg=
X-Received: by 2002:a2e:b017:: with SMTP id y23mr798375ljk.229.1582758619735;
 Wed, 26 Feb 2020 15:10:19 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-7-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-7-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 15:10:08 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5OUKMhCqh8qRq4dC5dgeb56b4LbbODVGwo6R0woV3fTg@mail.gmail.com>
Message-ID: <CAPhsuW5OUKMhCqh8qRq4dC5dgeb56b4LbbODVGwo6R0woV3fTg@mail.gmail.com>
Subject: Re: [PATCH 06/18] bpf: Add bpf_ksym_tree tree
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 5:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The bpf_tree is used both for kallsyms iterations and searching
> for exception tables of bpf programs, which is needed only for
> bpf programs.
>
> Adding bpf_ksym_tree that will hold symbols for all bpf_prog
> bpf_trampoline and bpf_dispatcher objects and keeping bpf_tree
> only for bpf_prog objects to keep it fast.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
