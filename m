Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C34B17082F
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 20:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgBZTBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 14:01:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbgBZTBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 14:01:51 -0500
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36D8A24679;
        Wed, 26 Feb 2020 19:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582743710;
        bh=87zmTGRP72EtUqtXV2kELCZ69ltWhtMns7STCLU89kE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MewZCsKGJ9hYwO1mzDwICzqKxLImxDn0WU4wkz7FLJrt1dm6v7KiUdQ+K4Y7H1txw
         vGsPQVPbk7UQhByko8/eKxUq2r9A+IshMOGnazYVws3lBhN8+i+AYI2Zg1fu68D2gf
         WOUqkHrC+kKwZfMZRRUm0zVW55HTjaMqLN8r3HJo=
Received: by mail-lj1-f172.google.com with SMTP id e3so270917lja.10;
        Wed, 26 Feb 2020 11:01:50 -0800 (PST)
X-Gm-Message-State: ANhLgQ3OjPfEbFMsUuMO7me2VC1Z7GdxidjvurhvBKIxBU5d3Vf8Q5cB
        XGOZrVax4xFj4gsTQaI8imACDG8g2/b7Eo3hZBA=
X-Google-Smtp-Source: ADFU+vs/pms32n/acnO2kmEpekOBkakj5FAYo9koM5OaHTg+pJ0LduTuEyuZeDcvQiR0VQf/9PC6Gjo0XEmFKuvywNA=
X-Received: by 2002:a2e:b017:: with SMTP id y23mr235314ljk.229.1582743708336;
 Wed, 26 Feb 2020 11:01:48 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-4-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-4-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 11:01:37 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5JZeCjmkeu-YWVR0p4ZMUJzxeif+8Qgx2NtxWLOjpL7w@mail.gmail.com>
Message-ID: <CAPhsuW5JZeCjmkeu-YWVR0p4ZMUJzxeif+8Qgx2NtxWLOjpL7w@mail.gmail.com>
Subject: Re: [PATCH 03/18] bpf: Add struct bpf_ksym
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

On Wed, Feb 26, 2020 at 5:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding 'struct bpf_ksym' object that will carry the
> kallsym information for bpf symbol. Adding the start
> and end address to begin with. It will be used by
> bpf_prog, bpf_trampoline, bpf_dispatcher.
>
> The symbol_start/symbol_end values were originally used
> to sort bpf_prog objects. For the address displayed in
> /proc/kallsyms we are using prog->bpf_func.
>
> I'm using the bpf_func for program symbol start instead
> of the symbol_start, because it makes no difference for
> sorting bpf_prog objects and we can use it directly as
> an address for display it in /proc/kallsyms.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
