Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2370E773B6
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfGZVrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:47:41 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44015 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfGZVrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:47:41 -0400
Received: by mail-qk1-f195.google.com with SMTP id m14so14486254qka.10;
        Fri, 26 Jul 2019 14:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XHoigrUpY+R6J5goLfaoYtnzY3PdzLLKDsYY1qBnFjY=;
        b=i5UPICNmruCKqL63Rps73+Bfs2/Tv9EvPUDCWu2Kp0eeKTB9Nwd6ITnMnhi6Lc7c6U
         Db9/uCNflde0Gn0XTyEjXKP6C91l5xckKXUw02icbEJ6ONxqxgrnW/K9JcYEj6jda8nL
         0jdherE7JvStVfnZNNUnwDXsgyeY/O4VaQPt5/ZFf9cgXeo3t0FVo+/5v2YWa0GZE25V
         fB8IbB50MQg/D4quKV5Hoa2KI9TuAcPwcFn9PN9S0ClW6aBsHQ6Xt37OlZW4WorEw0+D
         c2z3SHVtW8ufRjBK2Ah9PJk1znIRzVZTPqzLa4l/fiEP6bTVRcs+NLr9Xts0RfkA+Eho
         3DTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XHoigrUpY+R6J5goLfaoYtnzY3PdzLLKDsYY1qBnFjY=;
        b=c2vfMSmMCFVzrNl+0mUiQEtwaPY76D3S0LuinCS28BCOzQ+DiZXTJm80Rg2Iw82S7d
         +C0ZNuo50zctfZrWg3/2NSeLFZosCgGY5yOaYWmXY+rxb3o5s7TGWxTOynpGmkdRQF7B
         WWX5x4JR1GFKCZQsdFSLlp9/8rIiJU1vnK2qGwwdS37OkEgdNzXQN6w40/bt2G6uiHZi
         SZx1ioNPSOkVoxHToQYU+HWUyoViAvwbZYjJsIMEIWLKb5UvRT36LoRXYMTAGIPmtFBt
         QfcnAGZWejiIMEAFDeqO5fyz37AFXCgDJGCRyRXcZ7/qa8PY9Qt1Tik5akv9OdCaLMkV
         fjvA==
X-Gm-Message-State: APjAAAVBqC9d2bWWTHrHC9Vm84FvXLI5MEgJyB7b+G2EueKJHAzJanHU
        9N6j74WwxosHTl5H24Z9gxgExLY1RhXQSL5f1pA=
X-Google-Smtp-Source: APXvYqxas73LiVPYhuTyXPUv7KMCjyUGQvBQ5E0pFClPwcOn337CKmNSScjJS0nf21JeOcqEGIylVEbY9unkH2db1cI=
X-Received: by 2002:a37:9b48:: with SMTP id d69mr67964233qke.449.1564177660269;
 Fri, 26 Jul 2019 14:47:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190726203747.1124677-1-andriin@fb.com> <20190726203747.1124677-5-andriin@fb.com>
 <20190726212818.GC24397@mini-arch>
In-Reply-To: <20190726212818.GC24397@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jul 2019 14:47:28 -0700
Message-ID: <CAEf4BzYoiL7XAXFdLaf5TDDas42u+jUTy2WydgmJT7WiniqOqQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/9] libbpf: add libbpf_swap_print to get
 previous print func
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 2:28 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 07/26, Andrii Nakryiko wrote:
> > libbpf_swap_print allows to restore previously set print function.
> > This is useful when running many independent test with one default print
> > function, but overriding log verbosity for particular subset of tests.
> Can we change the return type of libbpf_set_print instead and return
> the old function from it? Will it break ABI?

Yeah, thought about that, but I wasn't sure about ABI breakage. It
seems like it shouldn't, so I'll just change libbpf_set_print
signature instead.

>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c   | 8 ++++++++
> >  tools/lib/bpf/libbpf.h   | 1 +
> >  tools/lib/bpf/libbpf.map | 5 +++++
> >  3 files changed, 14 insertions(+)
> >

[...]
