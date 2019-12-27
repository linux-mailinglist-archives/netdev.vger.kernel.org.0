Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACC7F12BAB7
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 20:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfL0THp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 14:07:45 -0500
Received: from mail-qt1-f178.google.com ([209.85.160.178]:46216 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfL0THp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 14:07:45 -0500
Received: by mail-qt1-f178.google.com with SMTP id g1so18274570qtr.13;
        Fri, 27 Dec 2019 11:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XdWlJgq0IM3FDdQEfRF08SkHVZo/GOOoncVdUM2B0VI=;
        b=phU1zBmeclG+Y4+Uf4rFwYrMuJguAEFI89dfra5kmLRDVmb7EbQOvP8mgZQiS97Gid
         +GuQJ6XbiLfh1o0FE0xSfu4Mh7/b3HJrS+QmGDHjyU94O72aOmCCL8CNpPxx1v+FJk35
         kaQKXQ5SlqQzHB9HyugmP0P43HokMujZyA+RYR9P4qfrgd7e5bqljduBqz6XU4GUGO/1
         3o+qs4z5Sww5uYiSwtSH5i2SQdwzRsU74PBMd5UhFdhiKKTXzsisTgSx/mP7l9Cve6V0
         t/VYj8NiUXsNbaEfKtkSUmPCNhDdwB4BkL4oKKsuTi+QJYslXY5l7K7v3F7W1FSjxSzS
         BrKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XdWlJgq0IM3FDdQEfRF08SkHVZo/GOOoncVdUM2B0VI=;
        b=VuIpUdK33mt73ifFmfhFW0hWQLM1o7y4ThxV93ZnwHCkfvOynX2dJpI7ifly1o0Kub
         5vAsxGXMKGWpivhvwYWtVuLOPbSWEBadtqe/zC6GF6QXTdjfWUtZelPfGK6Z/Ug2/5oT
         HuB13kh4gXZ7JiOWOZ0Mg+OoLz3F37/Ra6k7mW+Q+qTHyn8InFKsVc47K+FwU7U8Wqbe
         X8FY8KAakumM1b20s49anl9JCcbU0nB6bZGM0HCrFiTbFCcDgyeH1DCLYIF7EpHwKMSc
         LmJMNarBAHCX9FadNeB8dEyFcrbqirhBUsUbDMaJVLOFXsfCQG+uZT0aKYL6O2s02is+
         b15g==
X-Gm-Message-State: APjAAAWO4VsCPoXhIJiCs4q/5zHybQ57ZMqbhhUoajbHMOokEfsu2kaj
        em11BQfzCspHx1FVfN9Qg67Hyd1m/8cpWZLXE8eZW23l
X-Google-Smtp-Source: APXvYqy1GzeuGT4FhrVEvdzTen8aZ/OprXEl+Ct2sfVw5pr1g16JsBdkjmJ7JeGCMt9jhSbd9oXZZCcsZXF07wf8SG8=
X-Received: by 2002:ac8:554b:: with SMTP id o11mr39070292qtr.36.1577473664326;
 Fri, 27 Dec 2019 11:07:44 -0800 (PST)
MIME-Version: 1.0
References: <20191227180817.30438-1-daniel@iogearbox.net>
In-Reply-To: <20191227180817.30438-1-daniel@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 27 Dec 2019 20:07:33 +0100
Message-ID: <CAJ+HfNhW=tWdAD0jUyNCE7+Hby6874JAr8bfJHnc+edFLQExRg@mail.gmail.com>
Subject: Re: pull-request: bpf-next 2019-12-27
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Dec 2019 at 19:08, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
[...]
>
> 2) Merge conflict in arch/riscv/net/bpf_jit_comp.c:
>
> (I'm keeping Bjorn in Cc here for a double-check in case I got it wrong.)
>
>   <<<<<<< HEAD
>           if (is_13b_check(off, insn))
>                   return -1;
>           emit(rv_blt(tcc, RV_REG_ZERO, off >> 1), ctx);
>   =3D=3D=3D=3D=3D=3D=3D
>           emit_branch(BPF_JSLT, RV_REG_T1, RV_REG_ZERO, off, ctx);
>   >>>>>>> 7c8dce4b166113743adad131b5a24c4acc12f92c
>
> Result should look like:
>
>           emit_branch(BPF_JSLT, tcc, RV_REG_ZERO, off, ctx);
>

That's correct. Thanks, Daniel, for the fixup (over the holiday)!


Happy holidays,
Bj=C3=B6rn
